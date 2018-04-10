/*
 PREPARATION TABLES PG ROUTING
-------------------------------------------------------------------------------------
*/

CREATE EXTENSION pgrouting;

DROP SCHEMA IF EXISTS topology CASCADE;
DROP SCHEMA IF EXISTS routing CASCADE;
CREATE EXTENSION postgis_topology;

-- Action 3: Création du schéma topologique en 32632
SELECT topology.CreateTopology('routing', 32632);

UPDATE routes.osm_2018
SET geom=ST_MakeValid(geom);

-- Action 6: Ajouter une colonne topologique 'topo'
SELECT topology.AddTopoGeometryColumn('routing', 'routes', 'osm_2018', 'topo', 'LINESTRING');

-- Action 7: Convertir les lignes brisées en noeuds et arrêtes au sein de la topologie  
UPDATE routes.osm_2018 SET topo = topology.toTopoGeom(geom, 'routing', 1, 0)
where nom_del_fr like 'CITE ETTADHAMEN';

-- Enrichir notre table en rajoutant les noms et  les type de voiries.

ALTER TABLE routing.edge_data  add COLUMN  fclass   character varying;
ALTER TABLE routing.edge_data  add COLUMN  name  character varying;

-- Créer une table intermédiaire « route_edge_data » pour stocker les noms et types.

drop table if exists routing.route_edge_data;
create table routing.route_edge_data as
SELECT 
	e.edge_id,
	r.fclass, 
	r.oneway,
	r.name 
FROM routing.edge_data e, routing.relation rel, routes.osm_2018 r
WHERE e.edge_id = rel.element_id  AND rel.topogeo_id = (r.topo).id;

-- Mettre à jour attributs depuis la table « route_edge_data »

UPDATE routing.edge_data  a 
SET (fclass, name) = (r.fclass, r.name) 
FROM routing.route_edge_data  r 
WHERE a.edge_id=r.edge_id;

--Pour enrichir notre table en rajoutant le sens de la circulation voici la requête.
drop table if exists routing.route_edge_data;
create table routing.route_edge_data as
SELECT 
	e.edge_id,
	r.oneway 
FROM routing.edge_data e, routing.relation rel, routes.osm_2018 r
WHERE e.edge_id = rel.element_id  AND rel.topogeo_id = (r.topo).id ;

--Ajouter les colonnes à remplir
ALTER TABLE routing.edge_data  add COLUMN  oneway character varying;
--Maj attributs depuis la table route
UPDATE routing.edge_data  a 
SET oneway = r.oneway
FROM routing.route_edge_data  r 
WHERE a.edge_id=r.edge_id;


-- Action 8: Ajout de la colonne  colonne tps_distance pour l'agorithme de plus court chemin
ALTER TABLE routing.edge_data  add COLUMN tps_distance   double precision;
UPDATE routing.edge_data a  SET tps_distance=st_length(st_transform(geom,32632))/1000;

--Donc on ajoute l’attribut tps_pieton dans notre table « edge_data »  
 ALTER TABLE routing.edge_data  ADD COLUMN tps_pieton   double precision; 

--MAJ tps_pieton   
UPDATE routing.edge_data  SET tps_pieton =tps_distance/4;
--Calcul en minutes
update routing.edge_data set tps_pieton  =tps_pieton*60;
--Cependant on sait aussi qu’un piéton ne doit pas 
--emprunter les autoroutes et voix expresses donc nous allons les restreindre. 
--Mais il faut également avoir en tête  qu’il peut circuler dans les deux sens.


--MAJ restreinte tps_pieton   
UPDATE routing.edge_data  SET tps_pieton =-1 WHERE fclass IN ('trunk','trunk_link','motorway','motorway_link','primary_link','primary');

--Le plus court chemin à vélo 
--On ajoute l’attribut tps_velo dans notre table « edge_data »
ALTER TABLE routing.edge_data  ADD COLUMN tps_velo double precision;

--MAJ tps_velo
UPDATE routing.edge_data SET tps_velo =tps_distance /15 ;
UPDATE routing.edge_data SET tps_velo=tps_distance /12 WHERE fclass IN ('footway','pedestrian' ) ;
UPDATE routing.edge_data SET tps_velo =tps_distance /2 WHERE fclass ='steps' ;
--Calcul en minutes
update routing.edge_data set tps_velo  =tps_velo*60;
-- Restriction
UPDATE routing.edge_data SET tps_velo  =-1 WHERE tps_velo  IS NULL ;

--Le plus court chemin en voiture 
--Couts tps_voiture
ALTER TABLE routing.edge_data  ADD COLUMN tps_voiture double precision;
--MAJ tps_voiture
update routing.edge_data set tps_voiture  =tps_distance /90 where fclass =  'trunk' ;
update routing.edge_data set tps_voiture  =tps_distance /45 where fclass = 'trunk_link';  
update routing.edge_data set tps_voiture  =tps_distance /85 where fclass ='motorway';
update routing.edge_data set tps_voiture  =tps_distance /40 where fclass = 'motorway_link'  ;
update routing.edge_data set tps_voiture  =tps_distance /65 where fclass ='primary'  ;
update routing.edge_data set tps_voiture  =tps_distance /30 where fclass = 'primary_link' ;
update routing.edge_data set tps_voiture  =tps_distance /55 where fclass = 'secondary'  ;
update routing.edge_data set tps_voiture  =tps_distance /25 where fclass = 'secondary_link' ;
update routing.edge_data set tps_voiture  =tps_distance /40 where fclass = 'tertiary' ;
update routing.edge_data set tps_voiture  =tps_distance /20 where fclass = 'tertiary_link' ;
update routing.edge_data set tps_voiture  =tps_distance /30 where fclass = 'service' ;
update routing.edge_data set tps_voiture  =tps_distance /25 where fclass = 'residential' ;
update routing.edge_data set tps_voiture  =tps_distance /25 where fclass = 'road'  ;
update routing.edge_data set tps_voiture  =tps_distance /25 where fclass = 'track' ;
update routing.edge_data set tps_voiture  =tps_distance /25 where fclass = 'unclassified';
update routing.edge_data set tps_voiture  =tps_distance /10 where fclass = 'living_street';
--Calcul en minutes
update routing.edge_data set tps_voiture  =tps_voiture*60;

--Coûts inverses
update routing.edge_data set tps_voiture  =-1 WHERE tps_voiture IS NULL ;
