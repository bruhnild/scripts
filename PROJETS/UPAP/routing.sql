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

--Calcul du plus court chemin  en isodistance
-- Voir aussi le calcul du plus court chemin avec pgRouting Layer de Qgis

drop table if exists routing.pgr_dijkstra_ ;
create table routing.pgr_dijkstra_ as 
SELECT seq, id1 AS node, id2 AS edge, cost,type, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',6987, 8271, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id;

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

--Le plus court chemin en voiture 
--Couts tps_voiture
ALTER TABLE routing.edge_data  ADD COLUMN tps_voiture double precision;
--MAJ tps_voiture
update routing.edge_data set tps_voiture  =tps_distance /90 where type =  'trunk' ;
update routing.edge_data set tps_voiture  =tps_distance /45 where type = 'trunk_link';  
update routing.edge_data set tps_voiture  =tps_distance /85 where type ='motorway';
update routing.edge_data set tps_voiture  =tps_distance /40 where type = 'motorway_link'  ;
update routing.edge_data set tps_voiture  =tps_distance /65 where type ='primary'  ;
update routing.edge_data set tps_voiture  =tps_distance /30 where type = 'primary_link' ;
update routing.edge_data set tps_voiture  =tps_distance /55 where type = 'secondary'  ;
update routing.edge_data set tps_voiture  =tps_distance /25 where type = 'secondary_link' ;
update routing.edge_data set tps_voiture  =tps_distance /40 where type = 'tertiary' ;
update routing.edge_data set tps_voiture  =tps_distance /20 where type = 'tertiary_link' ;
update routing.edge_data set tps_voiture  =tps_distance /25 where type = 'residential' ;
update routing.edge_data set tps_voiture  =tps_distance /25 where type = 'road'  ;
update routing.edge_data set tps_voiture  =tps_distance /25 where type = 'unclassified';
update routing.edge_data set tps_voiture  =tps_distance /10 where type = 'living_street';

--Coûts inverses
update routing.edge_data set tps_voiture  =-1 WHERE tps_voiture IS NULL ;

--Pour enrichir notre table en rajoutant le sens de la circulation voici la requête.
drop table if exists routing.route_edge_data;
create table routing.route_edge_data as
SELECT 
	e.edge_id,r.oneway as sens  
FROM routing.edge e, routing.relation rel, routing.route r
WHERE e.edge_id = rel.element_id  AND rel.topogeo_id = (r.topo).id ;

--Ajouter les colonnes à remplir
ALTER TABLE routing.edge_data  add COLUMN  sens character varying;
--Maj attributs depuis la table route
UPDATE routing.edge_data  a SET (sens) = (r. sens) FROM routing.route_edge_data  r WHERE a.edge_id=r.edge_id;

--Voici les requêtes à passer pour attribuer les coûts pour chaque type de tronçons. 
--D’abord on ajoute de la colonne  rc_voiture  pour les coûts inverses. 
--Pour info les coûts inverses vont nous servir ici pour prendre en compte le sens de la circulation.

ALTER TABLE routing.edge_data  add COLUMN rc_voiture  double precision;

--Calcul du plus court chemin avec L’algorithme A* 
--Ajout des colonnes

ALTER TABLE routing.edge_data ADD COLUMN x1 double precision;
ALTER TABLE routing.edge_data  ADD COLUMN y1 double precision;
ALTER TABLE routing.edge_data  ADD COLUMN x2 double precision;
ALTER TABLE routing.edge_data  ADD COLUMN y2 double precision;

--Mise à jour des colonnes A*

UPDATE routing.edge_data  SET x1 = ST_x(ST_PointN(geom, 1));
UPDATE routing.edge_data  SET y1 = ST_y(ST_PointN(geom, 1));
UPDATE routing.edge_data  SET x2 = ST_x(ST_PointN(geom, ST_NumPoints(geom)));
UPDATE routing.edge_data  SET y2 = ST_y(ST_PointN(geom, ST_NumPoints(geom)));

--Créer des isochrones et isodistances à partir du réseau  pour les piétons, cyclistes et automobilistes.
--Analyse comparative des méthodes de création d’isochrones  

--Après avoir modéliser notre réseau, nous allons calculer et visualiser les nœuds et arcs qui se situent à 500m de la poste. 
--Pour ce faire nous allons utiliser l’algorithme driving distance de pgRouting pour calculer la distance la plus coute accessible à moins de 500m.  

--Driving distance pour les nœuds
Drop table if exists routing.pgr_drivingdistance_pt;
create table routing.pgr_drivingdistance_pt as       
 SELECT   id1 AS node_id ,  cost,geom
 FROM pgr_drivingDistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as    cost from routing.edge_data',6987, 0.5, false, false) as di
JOIN routing.node pt ON di.id1 = pt.node_id;

--Driving distance pour les tronçons
Drop table if exists routing.pgr_drivingdistance_lgn;
create table routing.pgr_drivingdistance_lgn as         
SELECT   id1 AS node_id ,pt.tps_distance as cost,geom
FROM pgr_drivingDistance(
'SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',6987, 0.5, false, false) as di
JOIN routing.edge_data pt ON di.id1 = pt.start_node;

--Les nœuds retournent exactement la distance entre 0 et 499m
--tandis que les arcs(tronçons de voirie) dépassent de plusieurs mètres sur les extrémités.
--Cette erreur est liée aux intersections entre les nœuds extrêmes et les arcs qui les touches au-delà des 500m. 
--Maintenant nous allons comparer différents isodistances  à partir des nœuds et des arcs et voir lesquels s’approchent le mieux à la réalité.

--Isodistance avec la fonction pgr_alphAShape

--Cette fonction retourne un tableau avec des lignes (x, y) qui décrivent les sommets d’une forme alpha. 
--Nous allons donc le coupler avec l’algorithme de driving distance pour créer un polygone à partir des sommets des nœuds et des arcs. 
--Pour plus d’information je vous renvoie vers cette documentation:

DROP TABLE if exists routing.isochrone_pgr_alphAShape;
CREATE TABLE routing.isochrone_pgr_alphAShape AS
SELECT ST_SetSRID(ST_MakePolygon(ST_AddPoint(foo.openline, ST_StartPoint(foo.openline))),3857)::geometry, 2 as alphaPoly
from (select st_makeline(points order by id) as openline from
(SELECT st_makepoint(x,y) as points ,row_number() over() AS id
FROM pgr_alphAShape('SELECT node_id::integer as id, st_x(geom)::float as x, st_y(geom)::float as y FROM routing.pgr_drivingdistance_pt')
) as a) as foo;

--B Isodistance avec la fonction pgr_pointsAsPolygon

DROP TABLE if exists routing.pgr_pointsAsPolygon_ST_ExteriorRing;
CREATE TABLE routing.pgr_pointsAsPolygon_ST_ExteriorRing AS
with pgr_pointsAsPolygon as (
SELECT 500, ST_SetSRID(geom,3857) as geom
FROM
pgr_pointsAsPolygon(
'SELECT node_id::integer as id, st_x(geom)::float as x, st_y(geom)::float as y FROM routing.pgr_drivingdistance_pt') as geom
)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(geom,1))) as geom FROM pgr_pointsAsPolygon;

-- C Isochrone avec St_buffer sur les coûts (distance)
--L’objectif est de pondérer les coûts en fonction de la distance. 

drop table if exists routing.buffer_cost;
CREATE TABLE routing.buffer_cost as
with buffer as (
select
case when cost<1 then (0.5-cost)*200 end as cost,geom
from routing.pgr_drivingdistance_pt)
select st_union(st_buffer(geom,cost)) as geom from buffer ;

--Isochrone avec st_concavehull et st_union
drop table if exists routing. st_concavehull_st_union;
CREATE TABLE routing. st_concavehull_st_union as
SELECT 1 AS id, st_concavehull(st_union(t.geom), 0.7)--ST_ConcaveHull(ST_Collect(geom),0.95,true) --
FROM
(SELECT seq, id1 AS node, id2 AS edge, cost, pt.geom
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
6987, 0.5, false, false
) AS di
JOIN routing.node pt
ON di.id1 = pt.node_id) t;

-- EIsochrone avec St_ ConcaveHull et st_Collect

--Avec les arcs
drop table if exists routing.ST_ConcaveHull_ST_Collect_lgn;
create table routing.ST_ConcaveHull_ST_Collect_lgn as
SELECT ST_ConcaveHull(ST_Collect(geom),0.70,false)
FROM routing.edge_data
JOIN (SELECT * FROM pgr_drivingdistance('
SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
6987, 0.5, false, false ))
AS route
ON routing.edge_data.start_node = route.id1 ;
--Avec les noeuds
drop table if exists routing.ST_ConcaveHull_ST_Collect_pt;
create table routing.ST_ConcaveHull_ST_Collect_pt as
SELECT ST_ConcaveHull(ST_Collect(geom),0.70,false)
FROM routing.edge_data
JOIN (SELECT * FROM pgr_drivingdistance('
SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
6987, 0.5, false, false ))
AS route
ON routing.edge_data.start_node = route.id1 ;

--Isochrone avec ST_MakePolygon et ST_ExteriorRing
--Avec les arcs
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing;
create table routing.ST_MakePolygon_ST_ExteriorRing as
WITH buffer_itineraire as (
SELECT --id1 AS node_id ,pt.cost,
st_buffer(st_union(geom),10 ) as geom
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
6987, 0.5, false, false
) as di
JOIN routing.edge_data pt
ON di.id1 = pt.start_node)
---Fermer les polygones
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(geom,1))) as geom FROM buffer_itineraire;

--Avec les arcs et les noeuds
drop table if exists routing. ST_MakePolygon_ST_ExteriorRing_v2;
create table routing. ST_MakePolygon_ST_ExteriorRing_v2 as
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



