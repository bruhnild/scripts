-- Création du schéma topologique en 3857
SELECT topology.CreateTopology('routing_cameroun', 3857);

-- Ajouter une colonne topologique 'topo'
SELECT topology.AddTopoGeometryColumn('routing_cameroun', 'cameroun', 'route', 'topo', 'LINESTRING');

-- Convertir les lignes brisées en noeuds et arrêtes au sein de la topologie  
UPDATE cameroun.route SET topo = topology.toTopoGeom(geom, 'routing_cameroun', 1, 0.0001);

-- Enrichir notre table en rajoutant les noms et  les type de voiries.
ALTER TABLE routing_cameroun.edge_data  add COLUMN  type   character varying;
ALTER TABLE routing_cameroun.edge_data  add COLUMN  nom  character varying;

-- Créer une table intermédiaire « route_edge_data » pour stocker les noms et types.
drop table if exists routing_cameroun.route_edge_data;
create table routing_cameroun.route_edge_data as
SELECT 
	e.edge_id,
	r.fclass as type, 
	r.oneway,
	r.name as nom  
FROM routing_cameroun.edge e, routing_cameroun.relation rel, cameroun.route r
WHERE e.edge_id = rel.element_id  AND rel.topogeo_id = (r.topo).id;


-- Mettre à jour attributs depuis la table « route_edge_data »
UPDATE routing_cameroun.edge_data  a SET (type, nom) = (r.type, r.nom) FROM routing_cameroun.route_edge_data  r WHERE a.edge_id=r.edge_id;


--Ajout de la colonne  colonne tps_distance pour les distances

ALTER TABLE routing_cameroun.edge_data  add COLUMN tps_distance    double precision;

--Mise à jour des distances

UPDATE routing_cameroun.edge_data a  SET tps_distance=st_length(st_transform(geom,3857))/1000;


--Donc on ajoute l’attribut tps_pieton dans notre table « edge_data »  
 ALTER TABLE routing_cameroun.edge_data  ADD COLUMN tps_pieton   double precision; 
 --MAJ tps_pieton   
UPDATE routing_cameroun.edge_data  SET tps_pieton =tps_distance/5;
--MAJ restreinte tps_pieton   
UPDATE routing_cameroun.edge_data  SET tps_pieton =-1 WHERE type IN ('trunk','trunk_link','motorway','motorway_link');

--Le plus court chemin à vélo 
--On ajoute l’attribut tps_velo dans notre table « edge_data »
ALTER TABLE routing_cameroun.edge_data  ADD COLUMN tps_velo double precision;

--MAJ tps_velo
UPDATE routing_cameroun.edge_data SET tps_velo =tps_distance /15 ;
UPDATE routing_cameroun.edge_data SET tps_velo=tps_distance /12 WHERE type IN ('footway','pedestrian' ) ;
UPDATE routing_cameroun.edge_data SET tps_velo =tps_distance /2 WHERE type ='steps' ;
-- Restriction
UPDATE routing_cameroun.edge_data SET tps_velo  =-1 WHERE tps_velo  IS NULL ;

--Le plus court chemin en voiture 
--Couts tps_voiture
ALTER TABLE routing_cameroun.edge_data  ADD COLUMN tps_voiture double precision;
--MAJ tps_voiture
update routing_cameroun.edge_data set tps_voiture  =tps_distance /90 where type =  'trunk' ;
update routing_cameroun.edge_data set tps_voiture  =tps_distance /45 where type = 'trunk_link';  
update routing_cameroun.edge_data set tps_voiture  =tps_distance /85 where type ='motorway';
update routing_cameroun.edge_data set tps_voiture  =tps_distance /40 where type = 'motorway_link'  ;
update routing_cameroun.edge_data set tps_voiture  =tps_distance /65 where type ='primary'  ;
update routing_cameroun.edge_data set tps_voiture  =tps_distance /30 where type = 'primary_link' ;
update routing_cameroun.edge_data set tps_voiture  =tps_distance /55 where type = 'secondary'  ;
update routing_cameroun.edge_data set tps_voiture  =tps_distance /25 where type = 'secondary_link' ;
update routing_cameroun.edge_data set tps_voiture  =tps_distance /40 where type = 'tertiary' ;
update routing_cameroun.edge_data set tps_voiture  =tps_distance /20 where type = 'tertiary_link' ;
update routing_cameroun.edge_data set tps_voiture  =tps_distance /25 where type = 'residential' ;
update routing_cameroun.edge_data set tps_voiture  =tps_distance /25 where type = 'road'  ;
update routing_cameroun.edge_data set tps_voiture  =tps_distance /25 where type = 'unclassified';
update routing_cameroun.edge_data set tps_voiture  =tps_distance /10 where type = 'living_street';

SELECT   id1 AS node_id ,pt.tps_distance as cost,geom
FROM pgr_drivingDistance(
'SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as cost from routing_cameroun.edge_data',243, 15, false, false) as di
JOIN routing_cameroun.edge_data pt ON di.id1 = pt.tps_distance;

--Calcul du plus court chemin  en isodistance de poste à poste
drop table if exists routing_cameroun.pgr_dijkstra ;
create table routing_cameroun.pgr_dijkstra as 
SELECT seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance*1000 as  cost from routing_cameroun.edge_data',293, 765, false, false)            
as di JOIN routing_cameroun.edge_data pt ON di.id2 = pt.edge_id;

-- Preparation donnees
-- Mettre à jour la table burkinafaso_donnees_collectees_commerces avec le noeud le plus proche
ALTER TABLE cameroun.commerces
ADD COLUMN nearest_node integer;

drop table if exists cameroun.commerces_start_node;
create table cameroun.commerces_start_node as 
   SELECT a.id, b.start_node, min(a.dist)
   FROM
     (SELECT poi.id, 
             min(ST_distance(poi.geom,  edge_data.geom)) AS dist
      FROM  cameroun.commerces poi, routing_cameroun.edge_data  
      GROUP BY poi.id) AS a,
     (SELECT poi.id, start_node, 
             ST_distance(poi.geom, edge_data.geom) AS dist
   FROM  cameroun.commerces poi, routing_cameroun.edge_data ) AS b
   WHERE a.dist = b. dist 
   AND a.id = b.id
   GROUP BY a.id, b.start_node;


UPDATE cameroun.commerces poi
SET nearest_node = 
   (SELECT start_node 
    FROM  cameroun.commerces_start_node start_node
    WHERE start_node.id = poi.id);
 
 -- Liste des start node correspondant aux commerces
drop table if exists cameroun.commerces_start_node_agg;
create table cameroun.commerces_start_node_agg as 
select array_agg(start_node)
from cameroun.commerces_start_node

ALTER TABLE cameroun.commerces_start_node_agg ADD COLUMN gid SERIAL PRIMARY KEY;

-- Calcul de chemin multiples (poste djemoun vers points relais)

drop table if exists resultats_cameroun.isodistance_djemoun;
create table resultats_cameroun.isodistance_sonapost_djemoun as 
 SELECT 
	seq, 
	id1 AS path, 
	id2 AS node, 
	id3 AS edge, 
	cost
FROM pgr_kdijkstraPath
(
      'SELECT 
	edge_id as id, 
	start_node as source, 
	end_node as target, 
	tps_distance as cost 
	FROM routing_cameroun.edge_data',
        765, 
        array[
        102,62,283,776,1,127,41,50,1,121,236,
67,794,190,66,282,188,374,622,38,730,201,
50,305,729,129,123,190,932,102,103,374,937,
932,875,374,18,216,794,794,1100,1086,179,305,
375,190,283,246,730,65,343,374,190,729,202,313,
780,811,190,440,145,507,119,764,806,277,276,512,
200,276,305,512,622,123,55,375,1039,1031,374,144,
856,282,443,440,77,932,313,133,65,275,201,65,917,
766,766,766,374,201,374,283,374,59,313,179,216,776,
361,282,246,135,5,588,38,274,201,1110,109,1042,305,
246,179,207,178,14,730,55,789,119,622,282,65,66,282,
893,103,780,282,730,1106,69], 
        false, 
        false
);

-- Ajout de la géométrie et attributs multimodaux
drop table if exists resultats_cameroun.isodistance_sonapost_djemoun_geom;
create table resultats_cameroun.isodistance_sonapost_djemoun_geom as 
SELECT  
	path, 
	sum(cost) as cost, 
	round(sum(tps_pieton*60)) as tps_pieton, 
	round(sum(tps_velo*60))as tps_velo, 
	round(sum(tps_voiture*60)) as tps_voiture,
	st_linemerge(st_union(geom))
FROM resultats_cameroun.isodistance_sonapost_djemoun as a
left join routing_cameroun.edge_data as b
on a.edge=b.edge_id
group by path
;
ALTER TABLE resultats_cameroun.isodistance_sonapost_djemoun_geom ADD COLUMN gid SERIAL PRIMARY KEY;

-- Arrondi du champ 'cost'
ALTER TABLE resultats_cameroun.isodistance_sonapost_djemoun_geom
    ALTER COLUMN cost TYPE numeric(10, 1)
    USING (cost::numeric(10, 1));
    
-- Ajout de l'identifiant commerce
ALTER TABLE resultats_cameroun.isodistance_sonapost_djemoun_geom ADD COLUMN id_commerce varchar;

UPDATE resultats_cameroun.isodistance_sonapost_djemoun_geom
SET id_commerce = id
from cameroun.commerces
where path = nearest_node;

    
-- Calcul de chemin multiples (poste vers points relais)
   
drop table if exists resultats_cameroun.isodistance_poste;
create table resultats_cameroun.isodistance_sonapost_poste as 
 SELECT 
	seq, 
	id1 AS path, 
	id2 AS node, 
	id3 AS edge, 
	cost
FROM pgr_kdijkstraPath
(
      'SELECT 
	edge_id as id, 
	start_node as source, 
	end_node as target, 
	tps_distance as cost 
	FROM routing_cameroun.edge_data',
        293, 
        array[
        102,62,283,776,1,127,41,50,1,121,236,
67,794,190,66,282,188,374,622,38,730,201,
50,305,729,129,123,190,932,102,103,374,937,
932,875,374,18,216,794,794,1100,1086,179,305,
375,190,283,246,730,65,343,374,190,729,202,313,
780,811,190,440,145,507,119,764,806,277,276,512,
200,276,305,512,622,123,55,375,1039,1031,374,144,
856,282,443,440,77,932,313,133,65,275,201,65,917,
766,766,766,374,201,374,283,374,59,313,179,216,776,
361,282,246,135,5,588,38,274,201,1110,109,1042,305,
246,179,207,178,14,730,55,789,119,622,282,65,66,282,
893,103,780,282,730,1106,69], 
        false, 
        false
);


-- Ajout de la géométrie et attributs multimodaux
drop table if exists resultats_cameroun.isodistance_sonapost_poste_geom;
create table resultats_cameroun.isodistance_sonapost_poste_geom as 
SELECT  
	path, 
	sum(cost) as cost, 
	round(sum(tps_pieton*60)) as tps_pieton, 
	round(sum(tps_velo*60))as tps_velo, 
	round(sum(tps_voiture*60)) as tps_voiture,
	st_linemerge(st_union(geom))
FROM resultats_cameroun.isodistance_sonapost_poste as a
left join routing_cameroun.edge_data as b
on a.edge=b.edge_id
group by path
;
ALTER TABLE resultats_cameroun.isodistance_sonapost_poste_geom ADD COLUMN gid SERIAL PRIMARY KEY;

-- Arrondi du champ 'cost'
ALTER TABLE resultats_cameroun.isodistance_sonapost_poste_geom
    ALTER COLUMN cost TYPE numeric(10, 1)
    USING (cost::numeric(10, 1));
    
-- Ajout de l'identifiant commerce
ALTER TABLE resultats_cameroun.isodistance_sonapost_poste_geom ADD COLUMN id_commerce varchar;

UPDATE resultats_cameroun.isodistance_sonapost_poste_geom
SET id_commerce = id
from cameroun.commerces
where path = nearest_node;


drop table if exists routing_cameroun.node_commerces;
create table routing_cameroun.node_commerces as 
select 
node_id, containing_face, geom, st_x (geom) as longitude, st_y(geom) as latitude
from routing_cameroun.node as a
join cameroun.commerces_start_node as b 
on a.node_id = b.start_node;

drop table if exists routing_cameroun.path_order_node_poste;
create table routing_cameroun.path_order_node_poste as 
SELECT seq, id1, id2, round(cost::numeric, 2) AS cost, lag(id2)  OVER (ORDER by seq) as id_prec
FROM pgr_tsp('SELECT node_id as id, longitude as x,latitude as y FROM routing_cameroun.node_commerces  ORDER BY id', 293, 293)
;

ALTER TABLE cameroun.commerces
drop column if exists seq;
ALTER TABLE cameroun.commerces
ADD column  seq integer ;
update cameroun.commerces as a
set seq = b.seq
from routing_cameroun.path_order_node_poste as b 
where id1 = nearest_node;

 

drop table if exists routing_cameroun.path_order_node_djemoun;
create table routing_cameroun.path_order_node_djemoun as 
SELECT seq, id1, id2, round(cost::numeric, 2) AS cost, lag(id2)  OVER (ORDER by seq) as id_prec
FROM pgr_tsp('SELECT node_id as id, longitude as x,latitude as y FROM routing_cameroun.node_commerces  ORDER BY id', 765, 765)
;
