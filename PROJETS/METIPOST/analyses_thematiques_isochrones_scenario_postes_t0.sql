/*
-------------------------------------------------------------------------------------
ANALYSES THEMATIQUES : CALCUL D'ISOCHRONES

Nous allons créer des isochrones à partir du réseau pour les piétons, cyclistes et automobilistes. 

Pour cela nous allons : calculer et visualiser les nœuds et arcs qui se situent à 500m de la poste. 

Algorithme : driving distance de pgRouting pour calculer la distance la plus coute 
accessible à moins de 500m.  

Les nœuds retournent exactement la distance entre 0 et 499m tandis que les 
arcs(tronçons de voirie) dépassent de plusieurs mètres sur les extrémités.
Cette erreur est liée aux intersections entre les nœuds extrêmes et les arcs 
qui les touchent au-delà des 500m. 
-------------------------------------------------------------------------------------
*/



/*
-------------------------------------------------------------------------------------
ETAPE 1 : ANALYSES THEMATIQUES : CALCUL D'ISOCHRONES
          POSTE 1
-------------------------------------------------------------------------------------
*/
-- PIETONS
--Avec les arcs et les noeuds
--0.35 (350m = 5mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_poste1_pietons_5mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_poste1_pietons_5mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
91, 0.35, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
91,0.35,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--0.7 (700m = 10mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_poste1_pietons_10mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_poste1_pietons_10mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
91, 0.7, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
91,0.7,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--1.5 (1.5km = 20mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_poste1_pietons_20mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_poste1_pietons_20mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
91, 1.5, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
91,1.5,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
-- VELOS
--Avec les arcs et les noeuds
--0.5 (500m = 2mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_poste1_velos_2mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_poste1_velos_2mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
91, 0.5, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
91,0.5,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--1 (1km = 4mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_poste1_velos_4mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_poste1_velos_4mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
91, 1, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
91,1,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--2 (2km = 8mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_poste1_velos_8mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_poste1_velos_8mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
91, 2, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
91,2,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
-- VOITURE
--Avec les arcs et les noeuds
--1.3 (1.3km = 2mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_poste1_voiture_2mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_poste1_voiture_2mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
91, 1.3, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
91,1.3,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--2.6 (2.6km = 4mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_poste1_voiture_4mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_poste1_voiture_4mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
91, 2.6, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
91,2.6,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
/*
-------------------------------------------------------------------------------------
ETAPE 2 : ANALYSES THEMATIQUES : CALCUL D'ISOCHRONES
          POSTE 2
-------------------------------------------------------------------------------------
*/
-- PIETONS
--Avec les arcs et les noeuds
--0.35 (350m = 5mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_poste2_pietons_5mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_poste2_pietons_5mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
772, 0.35, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
772,0.35,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--0.7 (700m = 10mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_poste2_pietons_10mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_poste2_pietons_10mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
772, 0.7, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
772,0.7,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--1.5 (1.5km = 20mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_poste2_pietons_20mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_poste2_pietons_20mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
772, 1.5, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
772,1.5,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
-- VELOS
--Avec les arcs et les noeuds
--0.5 (500m = 2mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_poste2_velos_2mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_poste2_velos_2mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
772, 0.5, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
772,0.5,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--1 (1km = 4mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_poste2_velos_4mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_poste2_velos_4mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
772, 1, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
772,1,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--2 (2km = 8mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_poste2_velos_8mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_poste2_velos_8mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
772, 2, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
772,2,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
-- VOITURE
--Avec les arcs et les noeuds
--1.3 (1.3km = 2mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_poste2_voiture_2mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_poste2_voiture_2mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
772, 1.3, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
772,1.3,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--2.6 (2.6km = 4mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_poste2_voiture_4mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_poste2_voiture_4mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
772, 2.6, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
772,2.6,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;



/*
-------------------------------------------------------------------------------------
ETAPE 3 : ANALYSES THEMATIQUES : CALCUL D'ISOCHRONES
          POSTES 1 et 2 UNION
-------------------------------------------------------------------------------------
*/
-- PIETONS
--Avec les arcs et les noeuds
--0.35 (350m = 5mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_pietons_5mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_pietons_5mn as
with merge as (
select*
from routing.ST_MakePolygon_ST_ExteriorRing_poste1_pietons_5mn
union all
select*
from routing.ST_MakePolygon_ST_ExteriorRing_poste2_pietons_5mn)
SELECT st_union (geom) from merge;
;
--Avec les arcs et les noeuds
--0.7 (700m = 10mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_pietons_10mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_pietons_10mn as
with merge as (
select*
from routing.ST_MakePolygon_ST_ExteriorRing_poste1_pietons_10mn
union all
select*
from routing.ST_MakePolygon_ST_ExteriorRing_poste2_pietons_10mn)
SELECT st_union (geom) from merge;
--Avec les arcs et les noeuds
--1.5 (1.5km = 20mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_pietons_20mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_pietons_20mn as
with merge as (
select*
from routing.ST_MakePolygon_ST_ExteriorRing_poste1_pietons_20mn
union all
select*
from routing.ST_MakePolygon_ST_ExteriorRing_poste2_pietons_20mn)
SELECT st_union (geom) from merge;
-- VELOS
--Avec les arcs et les noeuds
--0.5 (500m = 2mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_velos_2mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_velos_2mn as
with merge as (
select*
from routing.ST_MakePolygon_ST_ExteriorRing_poste1_velos_2mn
union all
select*
from routing.ST_MakePolygon_ST_ExteriorRing_poste2_velos_2mn)
SELECT st_union (geom) from merge;
--Avec les arcs et les noeuds
--1 (1km = 4mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_velos_4mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_velos_4mn as
with merge as (
select*
from routing.ST_MakePolygon_ST_ExteriorRing_poste1_velos_4mn
union all
select*
from routing.ST_MakePolygon_ST_ExteriorRing_poste2_velos_4mn)
SELECT st_union (geom) from merge;
--Avec les arcs et les noeuds
--2 (2km = 8mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_velos_8mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_velos_8mn as
with merge as (
select*
from routing.ST_MakePolygon_ST_ExteriorRing_poste1_velos_8mn
union all
select*
from routing.ST_MakePolygon_ST_ExteriorRing_poste2_velos_8mn)
SELECT st_union (geom) from merge;
-- VOITURE
--Avec les arcs et les noeuds
--1.3 (1.3km = 2mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_voiture_2mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_voiture_2mn as
with merge as (
select*
from routing.ST_MakePolygon_ST_ExteriorRing_poste1_voiture_2mn
union all
select*
from routing.ST_MakePolygon_ST_ExteriorRing_poste2_voiture_2mn)
SELECT st_union (geom) from merge;
--Avec les arcs et les noeuds
--2.6 (2.6km = 4mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_voiture_4mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_voiture_4mn as
with merge as (
select*
from routing.ST_MakePolygon_ST_ExteriorRing_poste1_voiture_4mn
union all
select*
from routing.ST_MakePolygon_ST_ExteriorRing_poste2_voiture_4mn)
SELECT st_union (geom) from merge;

/*
-------------------------------------------------------------------------------------
ETAPE 4 : ANALYSES THEMATIQUES : CALCUL D'ISOCHRONES
          AJOUT CHAMP surf_hab CONNAITRE POPULATION TOUCHEE PAR ISOCHRONE
-------------------------------------------------------------------------------------
*/
-- POSTE 1

-- PIETONS
ALTER TABLE routing.ST_MakePolygon_ST_ExteriorRing_poste1_pietons_5mn ADD COLUMN surf_hab integer;
	
UPDATE routing.ST_MakePolygon_ST_ExteriorRing_poste1_pietons_5mn a
SET surf_hab = t.sumPrice
FROM batiments.osm_2018 AS p
INNER JOIN
    (
    select a.geom as geom, sum(b.surf_hab)sumPrice, nom_del_fr
	from routing.ST_MakePolygon_ST_ExteriorRing_poste1_pietons_5mn a, batiments.osm_2018 b
	where st_intersects(a.geom, b.geom)
	group by a.geom, nom_del_fr
    ) t
    ON t.nom_del_fr = p.nom_del_fr
    ;

ALTER TABLE routing.ST_MakePolygon_ST_ExteriorRing_poste1_pietons_10mn ADD COLUMN surf_hab integer;
	
UPDATE routing.ST_MakePolygon_ST_ExteriorRing_poste1_pietons_10mn a
SET surf_hab = t.sumPrice
FROM batiments.osm_2018 AS p
INNER JOIN
    (
    select a.geom as geom, sum(b.surf_hab)sumPrice, nom_del_fr
	from routing.ST_MakePolygon_ST_ExteriorRing_poste1_pietons_10mn a, batiments.osm_2018 b
	where st_intersects(a.geom, b.geom)
	group by a.geom, nom_del_fr
    ) t
    ON t.nom_del_fr = p.nom_del_fr
    ;

ALTER TABLE routing.ST_MakePolygon_ST_ExteriorRing_poste1_pietons_20mn ADD COLUMN surf_hab integer;
	
UPDATE routing.ST_MakePolygon_ST_ExteriorRing_poste1_pietons_20mn a
SET surf_hab = t.sumPrice
FROM batiments.osm_2018 AS p
INNER JOIN
    (
    select a.geom as geom, sum(b.surf_hab)sumPrice, nom_del_fr
	from routing.ST_MakePolygon_ST_ExteriorRing_poste1_pietons_20mn a, batiments.osm_2018 b
	where st_intersects(a.geom, b.geom)
	group by a.geom, nom_del_fr
    ) t
    ON t.nom_del_fr = p.nom_del_fr
    ;

-- VELOS

ALTER TABLE routing.ST_MakePolygon_ST_ExteriorRing_poste1_velos_2mn ADD COLUMN surf_hab integer;
	
UPDATE routing.ST_MakePolygon_ST_ExteriorRing_poste1_velos_2mn a
SET surf_hab = t.sumPrice
FROM batiments.osm_2018 AS p
INNER JOIN
    (
    select a.geom as geom, sum(b.surf_hab)sumPrice, nom_del_fr
	from routing.ST_MakePolygon_ST_ExteriorRing_poste1_velos_2mn a, batiments.osm_2018 b
	where st_intersects(a.geom, b.geom)
	group by a.geom, nom_del_fr
    ) t
    ON t.nom_del_fr = p.nom_del_fr
    ;

ALTER TABLE routing.ST_MakePolygon_ST_ExteriorRing_poste1_velos_4mn ADD COLUMN surf_hab integer;
	
UPDATE routing.ST_MakePolygon_ST_ExteriorRing_poste1_velos_4mn a
SET surf_hab = t.sumPrice
FROM batiments.osm_2018 AS p
INNER JOIN
    (
    select a.geom as geom, sum(b.surf_hab)sumPrice, nom_del_fr
	from routing.ST_MakePolygon_ST_ExteriorRing_poste1_velos_4mn a, batiments.osm_2018 b
	where st_intersects(a.geom, b.geom)
	group by a.geom, nom_del_fr
    ) t
    ON t.nom_del_fr = p.nom_del_fr
    ;

ALTER TABLE routing.ST_MakePolygon_ST_ExteriorRing_poste1_velos_8mn ADD COLUMN surf_hab integer;
	
UPDATE routing.ST_MakePolygon_ST_ExteriorRing_poste1_velos_8mn a
SET surf_hab = t.sumPrice
FROM batiments.osm_2018 AS p
INNER JOIN
    (
    select a.geom as geom, sum(b.surf_hab)sumPrice, nom_del_fr
	from routing.ST_MakePolygon_ST_ExteriorRing_poste1_velos_8mn a, batiments.osm_2018 b
	where st_intersects(a.geom, b.geom)
	group by a.geom, nom_del_fr
    ) t
    ON t.nom_del_fr = p.nom_del_fr
    ;

-- VOITURES

ALTER TABLE routing.ST_MakePolygon_ST_ExteriorRing_poste1_voiture_2mn ADD COLUMN surf_hab integer;
	
UPDATE routing.ST_MakePolygon_ST_ExteriorRing_poste1_voiture_2mn a
SET surf_hab = t.sumPrice
FROM batiments.osm_2018 AS p
INNER JOIN
    (
    select a.geom as geom, sum(b.surf_hab)sumPrice, nom_del_fr
	from routing.ST_MakePolygon_ST_ExteriorRing_poste1_voiture_2mn a, batiments.osm_2018 b
	where st_intersects(a.geom, b.geom)
	group by a.geom, nom_del_fr
    ) t
    ON t.nom_del_fr = p.nom_del_fr
    ;

ALTER TABLE routing.ST_MakePolygon_ST_ExteriorRing_poste1_voiture_4mn ADD COLUMN surf_hab integer;
	
UPDATE routing.ST_MakePolygon_ST_ExteriorRing_poste1_voiture_4mn a
SET surf_hab = t.sumPrice
FROM batiments.osm_2018 AS p
INNER JOIN
    (
    select a.geom as geom, sum(b.surf_hab)sumPrice, nom_del_fr
	from routing.ST_MakePolygon_ST_ExteriorRing_poste1_voiture_4mn a, batiments.osm_2018 b
	where st_intersects(a.geom, b.geom)
	group by a.geom, nom_del_fr
    ) t
    ON t.nom_del_fr = p.nom_del_fr
    ;

-- POSTE 2

-- PIETONS

ALTER TABLE routing.ST_MakePolygon_ST_ExteriorRing_poste2_pietons_5mn ADD COLUMN surf_hab integer;
	
UPDATE routing.ST_MakePolygon_ST_ExteriorRing_poste2_pietons_5mn a
SET surf_hab = t.sumPrice
FROM batiments.osm_2018 AS p
INNER JOIN
    (
    select a.geom as geom, sum(b.surf_hab)sumPrice, nom_del_fr
	from routing.ST_MakePolygon_ST_ExteriorRing_poste2_pietons_5mn a, batiments.osm_2018 b
	where st_intersects(a.geom, b.geom)
	group by a.geom, nom_del_fr
    ) t
    ON t.nom_del_fr = p.nom_del_fr
    ;

ALTER TABLE routing.ST_MakePolygon_ST_ExteriorRing_poste2_pietons_10mn ADD COLUMN surf_hab integer;
	
UPDATE routing.ST_MakePolygon_ST_ExteriorRing_poste2_pietons_10mn a
SET surf_hab = t.sumPrice
FROM batiments.osm_2018 AS p
INNER JOIN
    (
    select a.geom as geom, sum(b.surf_hab)sumPrice, nom_del_fr
	from routing.ST_MakePolygon_ST_ExteriorRing_poste2_pietons_10mn a, batiments.osm_2018 b
	where st_intersects(a.geom, b.geom)
	group by a.geom, nom_del_fr
    ) t
    ON t.nom_del_fr = p.nom_del_fr
    ;

ALTER TABLE routing.ST_MakePolygon_ST_ExteriorRing_poste2_pietons_20mn ADD COLUMN surf_hab integer;
	
UPDATE routing.ST_MakePolygon_ST_ExteriorRing_poste2_pietons_20mn a
SET surf_hab = t.sumPrice
FROM batiments.osm_2018 AS p
INNER JOIN
    (
    select a.geom as geom, sum(b.surf_hab)sumPrice, nom_del_fr
	from routing.ST_MakePolygon_ST_ExteriorRing_poste2_pietons_20mn a, batiments.osm_2018 b
	where st_intersects(a.geom, b.geom)
	group by a.geom, nom_del_fr
    ) t
    ON t.nom_del_fr = p.nom_del_fr
    ;

-- VELOS

ALTER TABLE routing.ST_MakePolygon_ST_ExteriorRing_poste2_velos_2mn ADD COLUMN surf_hab integer;
	
UPDATE routing.ST_MakePolygon_ST_ExteriorRing_poste2_velos_2mn a
SET surf_hab = t.sumPrice
FROM batiments.osm_2018 AS p
INNER JOIN
    (
    select a.geom as geom, sum(b.surf_hab)sumPrice, nom_del_fr
	from routing.ST_MakePolygon_ST_ExteriorRing_poste2_velos_2mn a, batiments.osm_2018 b
	where st_intersects(a.geom, b.geom)
	group by a.geom, nom_del_fr
    ) t
    ON t.nom_del_fr = p.nom_del_fr
    ;

ALTER TABLE routing.ST_MakePolygon_ST_ExteriorRing_poste2_velos_4mn ADD COLUMN surf_hab integer;
	
UPDATE routing.ST_MakePolygon_ST_ExteriorRing_poste2_velos_4mn a
SET surf_hab = t.sumPrice
FROM batiments.osm_2018 AS p
INNER JOIN
    (
    select a.geom as geom, sum(b.surf_hab)sumPrice, nom_del_fr
	from routing.ST_MakePolygon_ST_ExteriorRing_poste2_velos_4mn a, batiments.osm_2018 b
	where st_intersects(a.geom, b.geom)
	group by a.geom, nom_del_fr
    ) t
    ON t.nom_del_fr = p.nom_del_fr
    ;

ALTER TABLE routing.ST_MakePolygon_ST_ExteriorRing_poste2_velos_8mn ADD COLUMN surf_hab integer;
	
UPDATE routing.ST_MakePolygon_ST_ExteriorRing_poste2_velos_8mn a
SET surf_hab = t.sumPrice
FROM batiments.osm_2018 AS p
INNER JOIN
    (
    select a.geom as geom, sum(b.surf_hab)sumPrice, nom_del_fr
	from routing.ST_MakePolygon_ST_ExteriorRing_poste2_velos_8mn a, batiments.osm_2018 b
	where st_intersects(a.geom, b.geom)
	group by a.geom, nom_del_fr
    ) t
    ON t.nom_del_fr = p.nom_del_fr
    ;

-- VOITURES

ALTER TABLE routing.ST_MakePolygon_ST_ExteriorRing_poste2_voiture_2mn ADD COLUMN surf_hab integer;
	
UPDATE routing.ST_MakePolygon_ST_ExteriorRing_poste2_voiture_2mn a
SET surf_hab = t.sumPrice
FROM batiments.osm_2018 AS p
INNER JOIN
    (
    select a.geom as geom, sum(b.surf_hab)sumPrice, nom_del_fr
	from routing.ST_MakePolygon_ST_ExteriorRing_poste2_voiture_2mn a, batiments.osm_2018 b
	where st_intersects(a.geom, b.geom)
	group by a.geom, nom_del_fr
    ) t
    ON t.nom_del_fr = p.nom_del_fr
    ;

ALTER TABLE routing.ST_MakePolygon_ST_ExteriorRing_poste2_voiture_4mn ADD COLUMN surf_hab integer;
	
UPDATE routing.ST_MakePolygon_ST_ExteriorRing_poste2_voiture_4mn a
SET surf_hab = t.sumPrice
FROM batiments.osm_2018 AS p
INNER JOIN
    (
    select a.geom as geom, sum(b.surf_hab)sumPrice, nom_del_fr
	from routing.ST_MakePolygon_ST_ExteriorRing_poste2_voiture_4mn a, batiments.osm_2018 b
	where st_intersects(a.geom, b.geom)
	group by a.geom, nom_del_fr
    ) t
    ON t.nom_del_fr = p.nom_del_fr
    ;

-- POSTES 1 et 2 (UNION)

-- PIETONS
ALTER TABLE routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_pietons_5mn ADD COLUMN surf_hab integer;
	
UPDATE routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_pietons_5mn a
SET surf_hab = t.sumPrice
FROM batiments.osm_2018 AS p
INNER JOIN
    (
    select a.st_union as geom, sum(b.surf_hab)sumPrice, nom_del_fr
	from routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_pietons_5mn a, batiments.osm_2018 b
	where st_intersects(a.st_union, b.geom)
	group by a.st_union, nom_del_fr
    ) t
    ON t.nom_del_fr = p.nom_del_fr
    ;

ALTER TABLE routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_pietons_10mn ADD COLUMN surf_hab integer;
	
UPDATE routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_pietons_10mn a
SET surf_hab = t.sumPrice
FROM batiments.osm_2018 AS p
INNER JOIN
    (
    select a.st_union as geom, sum(b.surf_hab)sumPrice, nom_del_fr
	from routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_pietons_10mn a, batiments.osm_2018 b
	where st_intersects(a.st_union, b.geom)
	group by a.st_union, nom_del_fr
    ) t
    ON t.nom_del_fr = p.nom_del_fr
    ;

ALTER TABLE routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_pietons_20mn ADD COLUMN surf_hab integer;
	
UPDATE routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_pietons_20mn a
SET surf_hab = t.sumPrice
FROM batiments.osm_2018 AS p
INNER JOIN
    (
    select a.st_union as geom, sum(b.surf_hab)sumPrice, nom_del_fr
	from routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_pietons_20mn a, batiments.osm_2018 b
	where st_intersects(a.st_union, b.geom)
	group by a.st_union, nom_del_fr
    ) t
    ON t.nom_del_fr = p.nom_del_fr
    ;

-- VELOS

ALTER TABLE routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_velos_2mn ADD COLUMN surf_hab integer;
	
UPDATE routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_velos_2mn a
SET surf_hab = t.sumPrice
FROM batiments.osm_2018 AS p
INNER JOIN
    (
    select a.st_union as geom, sum(b.surf_hab)sumPrice, nom_del_fr
	from routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_velos_2mn a, batiments.osm_2018 b
	where st_intersects(a.st_union, b.geom)
	group by a.st_union, nom_del_fr
    ) t
    ON t.nom_del_fr = p.nom_del_fr
    ;

ALTER TABLE routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_velos_4mn ADD COLUMN surf_hab integer;
	
UPDATE routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_velos_4mn a
SET surf_hab = t.sumPrice
FROM batiments.osm_2018 AS p
INNER JOIN
    (
    select a.st_union as geom, sum(b.surf_hab)sumPrice, nom_del_fr
	from routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_velos_4mn a, batiments.osm_2018 b
	where st_intersects(a.st_union, b.geom)
	group by a.st_union, nom_del_fr
    ) t
    ON t.nom_del_fr = p.nom_del_fr
    ;

ALTER TABLE routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_velos_8mn ADD COLUMN surf_hab integer;
	
UPDATE routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_velos_8mn a
SET surf_hab = t.sumPrice
FROM batiments.osm_2018 AS p
INNER JOIN
    (
    select a.st_union as geom, sum(b.surf_hab)sumPrice, nom_del_fr
	from routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_velos_8mn a, batiments.osm_2018 b
	where st_intersects(a.st_union, b.geom)
	group by a.st_union, nom_del_fr
    ) t
    ON t.nom_del_fr = p.nom_del_fr
    ;

-- VOITURES

ALTER TABLE routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_voiture_2mn ADD COLUMN surf_hab integer;
	
UPDATE routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_voiture_2mn a
SET surf_hab = t.sumPrice
FROM batiments.osm_2018 AS p
INNER JOIN
    (
    select a.st_union as geom, sum(b.surf_hab)sumPrice, nom_del_fr
	from routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_voiture_2mn a, batiments.osm_2018 b
	where st_intersects(a.st_union, b.geom)
	group by a.st_union, nom_del_fr
    ) t
    ON t.nom_del_fr = p.nom_del_fr
    ;

ALTER TABLE routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_voiture_4mn ADD COLUMN surf_hab integer;
	
UPDATE routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_voiture_4mn a
SET surf_hab = t.sumPrice
FROM batiments.osm_2018 AS p
INNER JOIN
    (
    select a.st_union as geom, sum(b.surf_hab)sumPrice, nom_del_fr
	from routing.ST_MakePolygon_ST_ExteriorRing_poste1_2_voiture_4mn a, batiments.osm_2018 b
	where st_intersects(a.st_union, b.geom)
	group by a.st_union, nom_del_fr
    ) t
    ON t.nom_del_fr = p.nom_del_fr
    ;

/*
-------------------------------------------------------------------------------------
ETAPE 4 : ANALYSES THEMATIQUES : CALCUL D'ISOCHRONES
          CONSOLIDATION TABLES DANS SCHEMA ANALYSES
-------------------------------------------------------------------------------------
*/

-- POSTE 1

drop table if exists analyses.st_makepolygon_st_exteriorring_poste1_pietons_5mn;
create table analyses.st_makepolygon_st_exteriorring_poste1_pietons_5mn as 
select *
from routing.st_makepolygon_st_exteriorring_poste1_pietons_5mn;

CREATE INDEX st_makepolygon_st_exteriorring_poste1_pietons_5mn_gix 
ON analyses.st_makepolygon_st_exteriorring_poste1_pietons_5mn USING GIST (geom);
ALTER TABLE analyses.st_makepolygon_st_exteriorring_poste1_pietons_5mn 
ADD COLUMN gid SERIAL PRIMARY KEY;

drop table if exists analyses.st_makepolygon_st_exteriorring_poste1_pietons_10mn;
create table analyses.st_makepolygon_st_exteriorring_poste1_pietons_10mn as 
select *
from routing.st_makepolygon_st_exteriorring_poste1_pietons_10mn;

CREATE INDEX st_makepolygon_st_exteriorring_poste1_pietons_10mn_gix 
ON analyses.st_makepolygon_st_exteriorring_poste1_pietons_10mn USING GIST (geom);
ALTER TABLE analyses.st_makepolygon_st_exteriorring_poste1_pietons_10mn 
ADD COLUMN gid SERIAL PRIMARY KEY;

drop table if exists analyses.st_makepolygon_st_exteriorring_poste1_pietons_20mn;
create table analyses.st_makepolygon_st_exteriorring_poste1_pietons_20mn as 
select *
from routing.st_makepolygon_st_exteriorring_poste1_pietons_20mn;

CREATE INDEX st_makepolygon_st_exteriorring_poste1_pietons_20mn_gix 
ON analyses.st_makepolygon_st_exteriorring_poste1_pietons_20mn USING GIST (geom);
ALTER TABLE analyses.st_makepolygon_st_exteriorring_poste1_pietons_20mn 
ADD COLUMN gid SERIAL PRIMARY KEY;

drop table if exists analyses.st_makepolygon_st_exteriorring_poste1_velos_2mn;
create table analyses.st_makepolygon_st_exteriorring_poste1_velos_2mn as 
select *
from routing.st_makepolygon_st_exteriorring_poste1_velos_2mn;

CREATE INDEX st_makepolygon_st_exteriorring_poste1_velos_2mn_gix 
ON analyses.st_makepolygon_st_exteriorring_poste1_velos_2mn USING GIST (geom);
ALTER TABLE analyses.st_makepolygon_st_exteriorring_poste1_velos_2mn 
ADD COLUMN gid SERIAL PRIMARY KEY;

drop table if exists analyses.st_makepolygon_st_exteriorring_poste1_velos_4mn;
create table analyses.st_makepolygon_st_exteriorring_poste1_velos_4mn as 
select *
from routing.st_makepolygon_st_exteriorring_poste1_velos_4mn;

CREATE INDEX st_makepolygon_st_exteriorring_poste1_velos_4mn_gix 
ON analyses.st_makepolygon_st_exteriorring_poste1_velos_4mn USING GIST (geom);
ALTER TABLE analyses.st_makepolygon_st_exteriorring_poste1_velos_4mn 
ADD COLUMN gid SERIAL PRIMARY KEY;

drop table if exists analyses.st_makepolygon_st_exteriorring_poste1_velos_8mn;
create table analyses.st_makepolygon_st_exteriorring_poste1_velos_8mn as 
select *
from routing.st_makepolygon_st_exteriorring_poste1_velos_8mn;

CREATE INDEX st_makepolygon_st_exteriorring_poste1_velos_8mn_gix 
ON analyses.st_makepolygon_st_exteriorring_poste1_velos_8mn USING GIST (geom);
ALTER TABLE analyses.st_makepolygon_st_exteriorring_poste1_velos_8mn 
ADD COLUMN gid SERIAL PRIMARY KEY;

drop table if exists analyses.st_makepolygon_st_exteriorring_poste1_voiture_2mn;
create table analyses.st_makepolygon_st_exteriorring_poste1_voiture_2mn as 
select *
from routing.st_makepolygon_st_exteriorring_poste1_voiture_2mn;

CREATE INDEX st_makepolygon_st_exteriorring_poste1_voiture_2mn_gix 
ON analyses.st_makepolygon_st_exteriorring_poste1_voiture_2mn USING GIST (geom);
ALTER TABLE analyses.st_makepolygon_st_exteriorring_poste1_voiture_2mn 
ADD COLUMN gid SERIAL PRIMARY KEY;

drop table if exists analyses.st_makepolygon_st_exteriorring_poste1_voiture_4mn;
create table analyses.st_makepolygon_st_exteriorring_poste1_voiture_4mn as 
select *
from routing.st_makepolygon_st_exteriorring_poste1_voiture_4mn;

CREATE INDEX st_makepolygon_st_exteriorring_poste1_voiture_4mn_gix 
ON analyses.st_makepolygon_st_exteriorring_poste1_voiture_4mn USING GIST (geom);
ALTER TABLE analyses.st_makepolygon_st_exteriorring_poste1_voiture_4mn 
ADD COLUMN gid SERIAL PRIMARY KEY;

-- POSTE 2


drop table if exists analyses.st_makepolygon_st_exteriorring_poste2_pietons_5mn;
create table analyses.st_makepolygon_st_exteriorring_poste2_pietons_5mn as 
select *
from routing.st_makepolygon_st_exteriorring_poste2_pietons_5mn;

CREATE INDEX st_makepolygon_st_exteriorring_poste2_pietons_5mn_gix 
ON analyses.st_makepolygon_st_exteriorring_poste2_pietons_5mn USING GIST (geom);
ALTER TABLE analyses.st_makepolygon_st_exteriorring_poste2_pietons_5mn 
ADD COLUMN gid SERIAL PRIMARY KEY;

drop table if exists analyses.st_makepolygon_st_exteriorring_poste2_pietons_10mn;
create table analyses.st_makepolygon_st_exteriorring_poste2_pietons_10mn as 
select *
from routing.st_makepolygon_st_exteriorring_poste2_pietons_10mn;

CREATE INDEX st_makepolygon_st_exteriorring_poste2_pietons_10mn_gix 
ON analyses.st_makepolygon_st_exteriorring_poste2_pietons_10mn USING GIST (geom);
ALTER TABLE analyses.st_makepolygon_st_exteriorring_poste2_pietons_10mn 
ADD COLUMN gid SERIAL PRIMARY KEY;

drop table if exists analyses.st_makepolygon_st_exteriorring_poste2_pietons_20mn;
create table analyses.st_makepolygon_st_exteriorring_poste2_pietons_20mn as 
select *
from routing.st_makepolygon_st_exteriorring_poste2_pietons_20mn;

CREATE INDEX st_makepolygon_st_exteriorring_poste2_pietons_20mn_gix 
ON analyses.st_makepolygon_st_exteriorring_poste2_pietons_20mn USING GIST (geom);
ALTER TABLE analyses.st_makepolygon_st_exteriorring_poste2_pietons_20mn 
ADD COLUMN gid SERIAL PRIMARY KEY;

drop table if exists analyses.st_makepolygon_st_exteriorring_poste2_velos_2mn;
create table analyses.st_makepolygon_st_exteriorring_poste2_velos_2mn as 
select *
from routing.st_makepolygon_st_exteriorring_poste2_velos_2mn;

CREATE INDEX st_makepolygon_st_exteriorring_poste2_velos_2mn_gix 
ON analyses.st_makepolygon_st_exteriorring_poste2_velos_2mn USING GIST (geom);
ALTER TABLE analyses.st_makepolygon_st_exteriorring_poste2_velos_2mn 
ADD COLUMN gid SERIAL PRIMARY KEY;

drop table if exists analyses.st_makepolygon_st_exteriorring_poste2_velos_4mn;
create table analyses.st_makepolygon_st_exteriorring_poste2_velos_4mn as 
select *
from routing.st_makepolygon_st_exteriorring_poste2_velos_4mn;

CREATE INDEX st_makepolygon_st_exteriorring_poste2_velos_4mn_gix 
ON analyses.st_makepolygon_st_exteriorring_poste2_velos_4mn USING GIST (geom);
ALTER TABLE analyses.st_makepolygon_st_exteriorring_poste2_velos_4mn 
ADD COLUMN gid SERIAL PRIMARY KEY;

drop table if exists analyses.st_makepolygon_st_exteriorring_poste2_velos_8mn;
create table analyses.st_makepolygon_st_exteriorring_poste2_velos_8mn as 
select *
from routing.st_makepolygon_st_exteriorring_poste2_velos_8mn;

CREATE INDEX st_makepolygon_st_exteriorring_poste2_velos_8mn_gix 
ON analyses.st_makepolygon_st_exteriorring_poste2_velos_8mn USING GIST (geom);
ALTER TABLE analyses.st_makepolygon_st_exteriorring_poste2_velos_8mn 
ADD COLUMN gid SERIAL PRIMARY KEY;

drop table if exists analyses.st_makepolygon_st_exteriorring_poste2_voiture_2mn;
create table analyses.st_makepolygon_st_exteriorring_poste2_voiture_2mn as 
select *
from routing.st_makepolygon_st_exteriorring_poste2_voiture_2mn;

CREATE INDEX st_makepolygon_st_exteriorring_poste2_voiture_2mn_gix 
ON analyses.st_makepolygon_st_exteriorring_poste2_voiture_2mn USING GIST (geom);
ALTER TABLE analyses.st_makepolygon_st_exteriorring_poste2_voiture_2mn 
ADD COLUMN gid SERIAL PRIMARY KEY;

drop table if exists analyses.st_makepolygon_st_exteriorring_poste2_voiture_4mn;
create table analyses.st_makepolygon_st_exteriorring_poste2_voiture_4mn as 
select *
from routing.st_makepolygon_st_exteriorring_poste2_voiture_4mn;

CREATE INDEX st_makepolygon_st_exteriorring_poste2_voiture_4mn_gix 
ON analyses.st_makepolygon_st_exteriorring_poste2_voiture_4mn USING GIST (geom);
ALTER TABLE analyses.st_makepolygon_st_exteriorring_poste2_voiture_4mn 
ADD COLUMN gid SERIAL PRIMARY KEY;

-- POSTES 1 et 2

-- POSTE 1

drop table if exists analyses.st_makepolygon_st_exteriorring_poste1_2_pietons_5mn;
create table analyses.st_makepolygon_st_exteriorring_poste1_2_pietons_5mn as 
select *
from routing.st_makepolygon_st_exteriorring_poste1_2_pietons_5mn;

CREATE INDEX st_makepolygon_st_exteriorring_poste1_2_pietons_5mn_gix 
ON analyses.st_makepolygon_st_exteriorring_poste1_2_pietons_5mn USING GIST (st_union);
ALTER TABLE analyses.st_makepolygon_st_exteriorring_poste1_2_pietons_5mn 
ADD COLUMN gid SERIAL PRIMARY KEY;

drop table if exists analyses.st_makepolygon_st_exteriorring_poste1_2_pietons_10mn;
create table analyses.st_makepolygon_st_exteriorring_poste1_2_pietons_10mn as 
select *
from routing.st_makepolygon_st_exteriorring_poste1_2_pietons_10mn;

CREATE INDEX st_makepolygon_st_exteriorring_poste1_2_pietons_10mn_gix 
ON analyses.st_makepolygon_st_exteriorring_poste1_2_pietons_10mn USING GIST (st_union);
ALTER TABLE analyses.st_makepolygon_st_exteriorring_poste1_2_pietons_10mn 
ADD COLUMN gid SERIAL PRIMARY KEY;

drop table if exists analyses.st_makepolygon_st_exteriorring_poste1_2_pietons_20mn;
create table analyses.st_makepolygon_st_exteriorring_poste1_2_pietons_20mn as 
select *
from routing.st_makepolygon_st_exteriorring_poste1_2_pietons_20mn;

CREATE INDEX st_makepolygon_st_exteriorring_poste1_2_pietons_20mn_gix 
ON analyses.st_makepolygon_st_exteriorring_poste1_2_pietons_20mn USING GIST (st_union);
ALTER TABLE analyses.st_makepolygon_st_exteriorring_poste1_2_pietons_20mn 
ADD COLUMN gid SERIAL PRIMARY KEY;

drop table if exists analyses.st_makepolygon_st_exteriorring_poste1_2_velos_2mn;
create table analyses.st_makepolygon_st_exteriorring_poste1_2_velos_2mn as 
select *
from routing.st_makepolygon_st_exteriorring_poste1_2_velos_2mn;

CREATE INDEX st_makepolygon_st_exteriorring_poste1_2_velos_2mn_gix 
ON analyses.st_makepolygon_st_exteriorring_poste1_2_velos_2mn USING GIST (st_union);
ALTER TABLE analyses.st_makepolygon_st_exteriorring_poste1_2_velos_2mn 
ADD COLUMN gid SERIAL PRIMARY KEY;

drop table if exists analyses.st_makepolygon_st_exteriorring_poste1_2_velos_4mn;
create table analyses.st_makepolygon_st_exteriorring_poste1_2_velos_4mn as 
select *
from routing.st_makepolygon_st_exteriorring_poste1_2_velos_4mn;

CREATE INDEX st_makepolygon_st_exteriorring_poste1_2_velos_4mn_gix 
ON analyses.st_makepolygon_st_exteriorring_poste1_2_velos_4mn USING GIST (st_union);
ALTER TABLE analyses.st_makepolygon_st_exteriorring_poste1_2_velos_4mn 
ADD COLUMN gid SERIAL PRIMARY KEY;

drop table if exists analyses.st_makepolygon_st_exteriorring_poste1_2_velos_8mn;
create table analyses.st_makepolygon_st_exteriorring_poste1_2_velos_8mn as 
select *
from routing.st_makepolygon_st_exteriorring_poste1_2_velos_8mn;

CREATE INDEX st_makepolygon_st_exteriorring_poste1_2_velos_8mn_gix 
ON analyses.st_makepolygon_st_exteriorring_poste1_2_velos_8mn USING GIST (st_union);
ALTER TABLE analyses.st_makepolygon_st_exteriorring_poste1_2_velos_8mn 
ADD COLUMN gid SERIAL PRIMARY KEY;

drop table if exists analyses.st_makepolygon_st_exteriorring_poste1_2_voiture_2mn;
create table analyses.st_makepolygon_st_exteriorring_poste1_2_voiture_2mn as 
select *
from routing.st_makepolygon_st_exteriorring_poste1_2_voiture_2mn;

CREATE INDEX st_makepolygon_st_exteriorring_poste1_2_voiture_2mn_gix 
ON analyses.st_makepolygon_st_exteriorring_poste1_2_voiture_2mn USING GIST (st_union);
ALTER TABLE analyses.st_makepolygon_st_exteriorring_poste1_2_voiture_2mn 
ADD COLUMN gid SERIAL PRIMARY KEY;

drop table if exists analyses.st_makepolygon_st_exteriorring_poste1_2_voiture_4mn;
create table analyses.st_makepolygon_st_exteriorring_poste1_2_voiture_4mn as 
select *
from routing.st_makepolygon_st_exteriorring_poste1_2_voiture_4mn;

CREATE INDEX st_makepolygon_st_exteriorring_poste1_2_voiture_4mn_gix 
ON analyses.st_makepolygon_st_exteriorring_poste1_2_voiture_4mn USING GIST (st_union);
ALTER TABLE analyses.st_makepolygon_st_exteriorring_poste1_2_voiture_4mn 
ADD COLUMN gid SERIAL PRIMARY KEY;


















