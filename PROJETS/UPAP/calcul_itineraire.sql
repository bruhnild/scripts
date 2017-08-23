/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 16/06/2017
Objet : Création de calculs d'itinéraire/isochrone 
Modification : Nom : ///// - Date : date_de_modif - Motif/nature : //////

Prerequis:

Importer les donner osm
C:\osm2pgsql\donnees\burkina-faso-latest.osm
C:\osm2pgsql\import_osm.txt

-------------------------------------------------------------------------------------
*/


--postgis :
CREATE EXTENSION postgis ;
--Postgis_topology:
CREATE EXTENSION postgis_topology;
--pgRouting:
CREATE EXTENSION pgrouting;

-- Création du schéma topologique en 3857
SELECT topology.CreateTopology('routing', 3857);

--Ajouter une colonne géometrique  en Lambert 93 dans la table « planet_osm_line »
ALTER TABLE  public.planet_osm_line ADD COLUMN geom geometry (LINESTRING,3857);

-- Mettre à jour la colonne géométrique
UPDATE  public.planet_osm_line SET geom=st_transform(way,3857);

-- Création de la table route qui intersecte le département
DROP TABLE IF EXISTS routing.route ;
CREATE TABLE routing.route as 
SELECT 
	osm_id, 
	access, 
	"addr:housename", 
	"addr:housenumber", 
	"addr:interpolation", 
	admin_level, 
	aerialway, 
	aeroway, 
	amenity, 
	area, 
	barrier, 
	bicycle, 
	brand, 
	bridge, 
	boundary, 
	building, 
	construction, 
	covered, 
	culvert, 
	cutting, 
	denomination, 
	disused, 
	embankment, 
	foot, 
	"generator:source", 
	harbour, 
	highway, 
	historic, 
	horse, 
	intermittent, 
	junction, 
	landuse,
	layer, 
	leisure, 
	lock, 
	man_made, 
	military, 
	motorcar, 
	name, 
	"natural", 
	office, 
	oneway, 
	operator, 
	place, 
	population, 
	power, 
	power_source, 
	public_transport, 
	railway, 
	ref, 
	religion, 
	route, 
	service, 
	shop, 
	sport, 
	surface, 
	toll, 
	tourism, 
	"tower:type", 
	tracktype, 
	tunnel, 
	water, 
	waterway, 
	wetland, 
	width, 
	wood, 
	z_order, 
	st_intersection( a.geom,b.geom) as geom  
FROM public.planet_osm_line a, public.departement b
WHERE ST_intersects(a.geom,b.geom) AND highway IS NOT NULL

--Creer un index spatial
 CREATE INDEX idx_routing_route_geom  ON routing.route  USING gist  (geom);

-- Ajouter une colonne topologique 'topo'

SELECT topology.AddTopoGeometryColumn('routing', 'routing', 'route', 'topo', 'LINESTRING');

-- Convertir les lignes brisées en noeuds et arrêtes au sein de la topologie  

UPDATE routing.route SET topo = topology.toTopoGeom(geom, 'routing', 1, 0.0001);

-- Enrichir notre table en rajoutant les noms et  les type de voiries.

ALTER TABLE routing.edge_data  add COLUMN  type   character varying;
ALTER TABLE routing.edge_data  add COLUMN  nom  character varying;

-- Créer une table intermédiaire « route_edge_data » pour stocker les noms et types.

drop table if exists routing. route_edge_data;
create table routing.route_edge_data as
SELECT 
	e.edge_id,
	r.highway as type, 
	r.oneway,
	r.name as nom  
FROM routing.edge e, routing.relation rel, routing.route r
WHERE e.edge_id = rel.element_id  AND rel.topogeo_id = (r.topo).id;

-- Mettre à jour attributs depuis la table « route_edge_data »

UPDATE routing.edge_data  a SET (type, nom) = (r.type, r.nom) FROM routing.route_edge_data  r WHERE a.edge_id=r.edge_id;

--Calcul du plus court chemin avec l'algorithme de Dijkstra.
--Ajout de la colonne  colonne tps_distance pour les distances

ALTER TABLE routing.edge_data  add COLUMN tps_distance    double precision;

--Mise à jour des distances

UPDATE routing.edge_data a  SET tps_distance=st_length(st_transform(geom,3857))/1000;

/* PLUS COURT CHEMIN/ISOCHRONES (deprecated)

--Calcul du plus court chemin  en isodistance
-- Voir aussi le calcul du plus court chemin avec pgRouting Layer de Qgis

--- Méthode Dijkstra
--Retourne le plus court chemin en utilisant l’algorithme Dijkstra
drop table if exists routing.pgr_dijkstra ;
create table routing.pgr_dijkstra as 
SELECT seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',6987, 7706, false, false)       
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id;

--- Méthode A*
--Retourne le plus court chemin en utilisant l’algorithme A*.  Il s'agit d'une extension de l’algorithme de Dijkstra de 1959
drop table if exists routing.pgr_astar ;
create table routing.pgr_astar as 
SELECT seq, id1 AS node, id2 AS edge, di.cost, geom
FROM pgr_astar(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost, x1, y1, x2, y2 FROM routing.edge_data',
6987, 7706, false, false
) as di
JOIN routing.edge_data
ON di.id2 = edge_id ;
     

--Le plus court chemin à pied 
--Il est généralement établit  qu’un piéton marche en moyenne à une vitesse de 4 à 5km/h. 
--Pour estimer te temps de parcours pour un tronçon donné, la règle est la suivante : 
--Temps = distance /vitesse  sachant qu’on connait déjà la distance des tronçons  (tps_distance).

--Donc on ajoute l’attribut tps_pieton dans notre table « edge_data »  
 ALTER TABLE routing.edge_data  ADD COLUMN tps_pieton   double precision; 

--MAJ tps_pieton   
UPDATE routing.edge_data  SET tps_pieton =tps_distance/5;

--Cependant on sait aussi qu’un piéton ne doit pas 
--emprunter les autoroutes et voix expresses donc nous allons les restreindre. 
--Mais il faut également avoir en tête  qu’il peut circuler dans les deux sens.

--MAJ restreinte tps_pieton   
UPDATE routing.edge_data  SET tps_pieton =-1 WHERE type IN ('trunk','trunk_link','motorway','motorway_link');

--Le plus court chemin à vélo 
--On ajoute l’attribut tps_velo dans notre table « edge_data »
ALTER TABLE routing.edge_data  ADD COLUMN tps_velo double precision;

--MAJ tps_velo
UPDATE routing.edge_data SET tps_velo =tps_distance /15 ;
UPDATE routing.edge_data SET tps_velo=tps_distance /12 WHERE type IN ('footway','pedestrian' ) ;
UPDATE routing.edge_data SET tps_velo =tps_distance /2 WHERE type ='steps' ;
-- Restriction
UPDATE routing.edge_data SET tps_velo  =-1 WHERE tps_velo  IS NULL ;


--Calcul du plus court chemin  en isodistance
-- Voir aussi le calcul du plus court chemin avec pgRouting Layer de Qgis

-- Départ depuis la poste jusqu'à un commerce (dans la zone de desserte)
drop table if exists resultats.burkina_isodistance_poste_com_;
create table resultats.burkina_isodistance_poste_com_ as 
SELECT seq, id1 AS node, id2 AS edge, cost,type, tps_pieton, tps_velo , geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance*1000 as  cost, tps_pieton as tps_pieton, tps_velo from routing.edge_data',6987, 7706, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id;

UPDATE resultats.burkina_isodistance_poste_com_ SET tps_pieton =tps_pieton*60;
UPDATE resultats.burkina_isodistance_poste_com_ SET tps_velo =tps_velo*60;

-- Départ depuis la poste jusqu'à un commerce (dans la zone de desserte)
drop table if exists resultats.burkina_isodistance_poste_com;
create table resultats.burkina_isodistance_poste_com as 
SELECT seq, id1 AS node, id2 AS edge, cost,type, tps_pieton, tps_velo , geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance*1000 as  cost, tps_pieton as tps_pieton, tps_velo from routing.edge_data',8215, 8100, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id;

UPDATE resultats.burkina_isodistance_poste_com SET tps_pieton =tps_pieton*60;
UPDATE resultats.burkina_isodistance_poste_com SET tps_velo =tps_velo*60;


-- Départ depuis la poste jusqu'à un commerce (en dehors de la zone de desserte)
drop table if exists resultats.burkina_isodistance_poste_ ;
create table resultats.burkina_isodistance_poste_ as 
SELECT seq, id1 AS node, id2 AS edge, cost,type, tps_pieton, tps_velo , geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance*1000 as  cost, tps_pieton as tps_pieton, tps_velo from routing.edge_data',6987, 6876, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id;

UPDATE resultats.burkina_isodistance_poste_ SET tps_pieton =tps_pieton*60;
UPDATE resultats.burkina_isodistance_poste_ SET tps_velo =tps_velo*60;

-- Départ depuis la poste jusqu'à un commerce (dans la zone de desserte)
drop table if exists resultats.burkina_isodistance_poste;
create table resultats.burkina_isodistance_poste as 
SELECT seq, id1 AS node, id2 AS edge, cost,type, tps_pieton, tps_velo , geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance*1000 as  cost, tps_pieton as tps_pieton, tps_velo from routing.edge_data',8215, 9238, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id;

UPDATE resultats.burkina_isodistance_poste SET tps_pieton =tps_pieton*60;
UPDATE resultats.burkina_isodistance_poste SET tps_velo =tps_velo*60;

drop table if exists resultats.burkina_isodistance;
create table resultats.burkina_isodistance as
SELECT  round(sum(cost)) as cost, round(sum(tps_pieton)) as tps_pieton, round(sum(tps_velo)) as tps_velo, st_union(geom) as geom
  FROM resultats.burkina_isodistance_poste_
  union all
SELECT  round(sum(cost)) as cost, round(sum(tps_pieton)) as tps_pieton, round(sum(tps_velo)) as tps_velo, st_union(geom) as geom
  FROM resultats.burkina_isodistance_poste
  union all
  SELECT  round(sum(cost)) as cost, round(sum(tps_pieton)) as tps_pieton, round(sum(tps_velo)) as tps_velo, st_union(geom) as geom
  FROM resultats.burkina_isodistance_poste_com
  union all 
  SELECT  round(sum(cost)) as cost, round(sum(tps_pieton)) as tps_pieton, round(sum(tps_velo)) as tps_velo, st_union(geom) as geom
  FROM resultats.burkina_isodistance_poste_com_;

--Ajouter les colonnes à remplir
ALTER TABLE routing.edge_data  add COLUMN  sens character varying;
--Maj attributs depuis la table route
UPDATE routing.edge_data  a SET (sens) = (r. sens) FROM routing.route_edge_data  r WHERE a.edge_id=r.edge_id;



--Créer des isochrones et isodistances à partir du réseau  pour les piétons, cyclistes et automobilistes.

--Avec les arcs et les noeuds
--Poste (500m)
drop table if exists resultats.burkina_isochrone_poste_;
create table resultats.burkina_isochrone_poste_ as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
6987, 0.5, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
6987,0.5,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;

-- Poste (500m)
drop table if exists resultats.burkina_isochrone_poste;
create table resultats.burkina_isochrone_poste as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
8215, 0.5, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
8215,0.5,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;

--création de la table avec l'id et la distance 
DROP TABLE IF EXISTS data.distance_to_site;
CREATE TABLE data.distance_to_site AS 
    SELECT 
        a.id ,
        b.edge_id,
        ST_Distance(a.geom, b.geom)::double precision as distance
    FROM
      data.donnees_collectees as a,routing.edge_data as b 
      WHERE a.type_comm like 'Services' or a.type_comm like 'Autres' or a.type_comm like 'Agroalimentaire'
    ORDER BY distance;
    

--parce qu'un point site peut être près de plusieurs points siren, ne conserver que le point siren le plus proche
DROP TABLE IF EXISTS data.distance_to_site_min;
CREATE TABLE data.distance_to_site_min AS
     SELECT 
       edge_id,
       min(distance) as min_distance
     FROM 
       data.distance_to_site
     WHERE distance <=100
     GROUP BY 
       edge_id;

--création de l'index attributaire
CREATE INDEX ON data.distance_to_site_min (edge_id ASC NULLS LAST);

--affecter l'id
ALTER TABLE data.distance_to_site_min ADD COLUMN id varchar;

UPDATE data.distance_to_site_min as dis_min 
   SET id=dis.id
   FROM data.distance_to_site as dis
   WHERE dis_min.edge_id=dis.edge_id AND dis_min.min_distance=dis.distance;

--affecter la géométrie
ALTER TABLE data.distance_to_site_min ADD COLUMN geom geometry(Point, 3857);

UPDATE data.distance_to_site_min as dis_min
   SET geom=ST_ClosestPoint(a.geom, b.geom)
   FROM  data.donnees_collectees as a, routing.edge_data as b 
   WHERE a.id=dis_min.id AND b.edge_id=dis_min.edge_id;

--création de l'index géométrique 
CREATE INDEX distance_to_site_min_geom2 ON data.distance_to_site_min USING  gist (geom);

--creer table site temp
DROP TABLE IF EXISTS data.temp;
CREATE TABLE data.temp as 
SELECT 
  id, 
  edge_id, 
  min(min_distance) as distance,   
  geom
FROM data.distance_to_site_min
GROUP BY 
  min_distance,
  edge_id,
  id, 
  geom
ORDER BY id;

--création de la table temp_min pour ne garder que la plus petite distance par code_st
DROP TABLE IF EXISTS data.temp_min;
CREATE TABLE data.temp_min as 
SELECT 
  distinct on (id) id, 
  min(distance) distance
FROM data.temp
GROUP BY  id;

--mettre à jour le champs edge_id de la table temp_min avec les informations de la table temp
ALTER TABLE data.temp_min ADD COLUMN edge_id integer;

UPDATE data.temp_min as a
   SET edge_id=b.edge_id
   FROM data.temp as b
   WHERE a.id=b.id AND a.distance=b.distance;

--création de la clé primaire

ALTER TABLE data.temp_min
  ADD PRIMARY KEY (edge_id);

--rajouter champ service/agro/autre/poste dans la table edge_data
ALTER TABLE routing.edge_data ADD COLUMN id_donnee_col varchar;

UPDATE routing.edge_data as a
   SET id_donnee_col=b.id
   FROM data.temp_min as b
   WHERE a.edge_id=b.edge_id ;


--rajouter champ type commerce dans la table temp_min
 
ALTER TABLE data.temp_min ADD COLUMN type_comm varchar;

UPDATE data.temp_min as a
   SET type_comm=b.type_comm
   FROM data.donnees_collectees as b
   WHERE a.id=b.id;

rajouter champ type commerce dans la table edge_data 
ALTER TABLE routing.edge_data ADD COLUMN type_comm varchar;

UPDATE routing.edge_data as a
   SET type_comm=b.type_comm
   FROM data.temp_min as b
   WHERE a.id_donnee_col=b.id;

*/

-- Après import, selectionner les données uniquement de type commerce

drop table if exists data.burkinafaso_donnees_collectees_commerces;
create table  data.burkinafaso_donnees_collectees_commerces as 
SELECT id, geom, nb_bal_bat, type_bal, type_comm, geonym, coor_x, coor_y
  FROM data.burkinafaso_donnees_collectees
  where type_comm is not null ;

-- Mettre à jour la table burkinafaso_donnees_collectees_commerces avec le noeud le plus proche
ALTER TABLE data.burkinafaso_donnees_collectees_commerces
ADD COLUMN nearest_node integer;

drop table if exists data.temp;
create table data.temp as 
   SELECT a.id, b.start_node, min(a.dist)
   FROM
     (SELECT poi.id, 
             min(ST_distance(poi.geom,  edge_data.geom)) AS dist
      FROM data.burkinafaso_donnees_collectees_commerces poi, routing.edge_data 
      GROUP BY poi.id) AS a,
     (SELECT poi.id, start_node, 
             ST_distance(poi.geom, edge_data.geom) AS dist
   FROM data.burkinafaso_donnees_collectees_commerces poi, routing.edge_data) AS b
   WHERE a.dist = b. dist 
   AND a.id = b.id
   GROUP BY a.id, b.start_node;

UPDATE data.burkinafaso_donnees_collectees_commerces poi
SET nearest_node = 
   (SELECT start_node 
    FROM data.temp
    WHERE temp.id = poi.id);
 

-- Calcul de chemin multiples (poste vers points relais)
drop table if exists resultats.burkinafaso_isodistance_sonapost_temp;
create table resultats.burkinafaso_isodistance_sonapost_temp as 
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
	FROM routing_burkina_faso.edge_data',
        6987, 
        array[
        8509, 
	    7698,
		8296,
		7751,
		8503,
		7435,
		7085,
		6662,
		8270,
		8281,
		8822,
		7789,
		8356,
		9238,
		8360,
		8271,
		8359,
		7778,
		8099,
		8269,
		8099,
		7791,
		7799,
		8273,
		8269,
		8789,
		8222,
		8271,
		8503,
		7742,
		7744,
		7803,
		7552,
		7277,
		7547,
		6982,
		7946,
		7751,
		8354], 
        false, 
        false
);

-- Ajout de la géométrie et attributs multimodaux
drop table if exists resultats.burkinafaso_isodistance_sonapost;
create table resultats.burkinafaso_isodistance_sonapost as 
SELECT  
	path, 
	sum(cost) as cost, 
	round(sum(tps_pieton*60)) as tps_pieton, 
	round(sum(tps_velo*60))as tps_velo, 
	round(sum(tps_voiture*60)) as tps_voiture,
	st_linemerge(st_union(geom))
FROM resultats.burkinafaso_isodistance_sonapost_temp as a
left join routing_burkina_faso.edge_data as b
on a.edge=b.edge_id
group by path
;
ALTER TABLE resultats.burkinafaso_isodistance_sonapost ADD COLUMN gid SERIAL PRIMARY KEY;
-- Arrondi du champ 'cost'
ALTER TABLE resultats.burkinafaso_isodistance_sonapost
    ALTER COLUMN cost TYPE numeric(10, 1)
    USING (cost::numeric(10, 1));

-- Ajout de l'identifiant commerce
ALTER TABLE resultats.burkinafaso_isodistance_sonapost ADD COLUMN id_commerce varchar;

UPDATE resultats.burkinafaso_isodistance_sonapost
SET id_commerce = id
from data.burkinafaso_donnees_collectees_commerces
where path = nearest_node;


-- Calcul itinéraire en plusieurs temps (parcours)

drop table if exists path_order_node;
create table path_order_node as 
SELECT seq, id1, id2, round(cost::numeric, 2) AS cost, lag(id2)  OVER (ORDER by seq) as id_prec
FROM pgr_tsp('SELECT node_id as id, longitude as x,latitude as y FROM mes_cibles  ORDER BY id', 6987, 6987)
;


ALTER TABLE data.burkinafaso_donnees_collectees_commerces
drop column if exists seq;
ALTER TABLE data.burkinafaso_donnees_collectees_commerces
ADD column  seq integer ;
update data.burkinafaso_donnees_collectees_commerces as a
set seq = b.seq
from path_order_node as b 
where id1 = nearest_node;


-- copier l'identifiant des noeuds dans l'odre pour la prochaine requete
SELECT string_agg(CAST(id2 as varchar), ',') FROM path_order_node;

-- Calcul pour chaque itinéraire avec dijkstra en suivant l'odre des noeuds 

drop table if exists public.burkinafaso_itineraire_sonapost_temp;
create table public.burkinafaso_itineraire_sonapost_temp as 

SELECT 1::int as path, seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing_burkina_faso.edge_data',6987, 6662, false, false)       
as di JOIN routing_burkina_faso.edge_data pt ON di.id2 = pt.edge_id
union all 
SELECT 2::int as path, seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing_burkina_faso.edge_data',6662, 7435, false, false)       
as di JOIN routing_burkina_faso.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 3::int as path, seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing_burkina_faso.edge_data',7435, 7552, false, false)       
as di JOIN routing_burkina_faso.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 4::int as path, seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing_burkina_faso.edge_data',7552, 7803, false, false)       
as di JOIN routing_burkina_faso.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 5::int as path, seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing_burkina_faso.edge_data',7803, 7946, false, false)       
as di JOIN routing_burkina_faso.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 6::int as path, seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing_burkina_faso.edge_data',7946, 8822, false, false)       
as di JOIN routing_burkina_faso.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 7::int as path, seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing_burkina_faso.edge_data',8822, 8281, false, false)       
as di JOIN routing_burkina_faso.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 8::int as path, seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing_burkina_faso.edge_data',8281, 8360, false, false)       
as di JOIN routing_burkina_faso.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 9::int as path, seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing_burkina_faso.edge_data',8360, 8359, false, false)       
as di JOIN routing_burkina_faso.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 10::int as path, seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing_burkina_faso.edge_data',8359, 8273, false, false)       
as di JOIN routing_burkina_faso.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 11::int as path, seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing_burkina_faso.edge_data',8273, 8356, false, false)       
as di JOIN routing_burkina_faso.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 12::int as path, seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing_burkina_faso.edge_data',8356, 7698, false, false)       
as di JOIN routing_burkina_faso.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 13::int as path, seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing_burkina_faso.edge_data',7698, 7778, false, false)       
as di JOIN routing_burkina_faso.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 14::int as path, seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing_burkina_faso.edge_data',7778, 8270, false, false)       
as di JOIN routing_burkina_faso.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 15::int as path, seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing_burkina_faso.edge_data',8270, 8271, false, false)       
as di JOIN routing_burkina_faso.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 16::int as path, seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing_burkina_faso.edge_data',8271, 8269, false, false)       
as di JOIN routing_burkina_faso.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 17::int as path, seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing_burkina_faso.edge_data',8269, 8354, false, false)       
as di JOIN routing_burkina_faso.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 18::int as path, seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing_burkina_faso.edge_data',8354, 8503, false, false)       
as di JOIN routing_burkina_faso.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 19::int as path, seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing_burkina_faso.edge_data',8503, 8509, false, false)       
as di JOIN routing_burkina_faso.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 20::int as path, seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing_burkina_faso.edge_data',8509, 8789, false, false)       
as di JOIN routing_burkina_faso.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 21::int as path, seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing_burkina_faso.edge_data',8789, 9238, false, false)       
as di JOIN routing_burkina_faso.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 22::int as path, seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing_burkina_faso.edge_data',9238, 7789, false, false)       
as di JOIN routing_burkina_faso.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 23::int as path, seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing_burkina_faso.edge_data',7789, 8222, false, false)       
as di JOIN routing_burkina_faso.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 24::int as path, seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing_burkina_faso.edge_data',8222, 7791, false, false)       
as di JOIN routing_burkina_faso.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 25::int as path, seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing_burkina_faso.edge_data',7791, 7751, false, false)       
as di JOIN routing_burkina_faso.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 26::int as path, seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing_burkina_faso.edge_data',7751, 7742, false, false)       
as di JOIN routing_burkina_faso.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 27::int as path, seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing_burkina_faso.edge_data',7742, 7547, false, false)       
as di JOIN routing_burkina_faso.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 28::int as path, seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing_burkina_faso.edge_data',7547, 7277, false, false)       
as di JOIN routing_burkina_faso.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 29::int as path, seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing_burkina_faso.edge_data',7277, 7085, false, false)       
as di JOIN routing_burkina_faso.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 30::int as path, seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing_burkina_faso.edge_data',7085, 6982, false, false)       
as di JOIN routing_burkina_faso.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 31::int as path, seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing_burkina_faso.edge_data',6982, 7744, false, false)       
as di JOIN routing_burkina_faso.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 32::int as path, seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing_burkina_faso.edge_data',7744, 7799, false, false)       
as di JOIN routing_burkina_faso.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 33::int as path, seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing_burkina_faso.edge_data',7799, 8099, false, false)       
as di JOIN routing_burkina_faso.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 34::int as path, seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing_burkina_faso.edge_data',8099, 8296, false, false)       
as di JOIN routing_burkina_faso.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 35::int as path, seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing_burkina_faso.edge_data',8296, 6987, false, false)       
as di JOIN routing_burkina_faso.edge_data pt ON di.id2 = pt.edge_id;

-- aggrégation des attributs

drop table if exists resultats.burkinafaso_itineraire_sonapost;
create table resultats.burkinafaso_itineraire_sonapost as 
SELECT path, sum(cost) as cost, round(sum(tps_pieton*60)) as tps_pieton, round(sum(tps_velo*60))as tps_velo, 
	round(sum(tps_voiture*60)) as tps_voiture,st_linemerge(st_union(a.geom))
  FROM public.burkinafaso_itineraire_sonapost_temp as a
    left join routing_burkina_faso.edge_data as b
  on a.edge= b.edge_id
group by path
order by path
;

-- Arrondi du champ 'cost'
ALTER TABLE resultats.burkinafaso_itineraire_sonapost
    ALTER COLUMN cost TYPE numeric(10, 1)
    USING (cost::numeric(10, 1));



-- Suppression des tables temporaires
DROP TABLE IF EXISTS data.temp;
DROP TABLE IF EXISTS resultats.burkinafaso_isodistance_sonapost_temp;
DROP TABLE IF EXISTS path_order_node;
DROP TABLE IF EXISTS  public.burkinafaso_itineraire_sonapost_temp;


-- test
drop table if exists test;
create table test as 
SELECT seq, id1, id2, round(cost::numeric, 2) AS cost, lag(id2)  OVER (ORDER by seq) as id_prec
FROM pgr_tsp('SELECT node_id as id, longitude as x,latitude as y FROM mes_cibles  ORDER BY id', 6987, 6987);

    SELECT string_agg(CAST(id2 as varchar), ',') FROM test

drop table if exists test_path;
create table test_path as     
SELECT * FROM pgr_dijkstraVia(
    'SELECT id, source, target, cost FROM public.edge_data order by id',
    ARRAY[6987,6662,7435,7552,7803,7946,8822,8281,8360,8359,8273,8356,7698,7778,8270,8271,8269,8354,8503,8509,8789,9238,7789,8222,7791,7751,7742,7547,7277,7085,6982,7744,7799,8099,8296]);



drop table if exists test_path_geom;
create table test_path_geom as 
SELECT path_id,  start_vid, end_vid, sum(cost) as cost, round(sum(tps_pieton*60)) as tps_pieton, round(sum(tps_velo*60))as tps_velo, 
	round(sum(tps_voiture*60)) as tps_voiture,st_linemerge(st_union(geom))
  FROM public.test_path as a
  left join routing_burkina_faso.edge_data as b
  on a.edge= b.edge_id
group by path_id, start_vid, end_vid
order by path_id

