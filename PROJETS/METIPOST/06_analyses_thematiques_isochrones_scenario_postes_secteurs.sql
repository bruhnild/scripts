/*
-------------------------------------------------------------------------------------
ETAPE 1 : ANALYSES THEMATIQUES : CALCUL D'ISOCHRONES
          POSTE SECONDAIRE : 14 JANVIER
-------------------------------------------------------------------------------------
*/
-- PIETONS
--Avec les arcs et les noeuds
--0.35 (350m = 5mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_14janvier_pietons_5mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_14janvier_pietons_5mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
842, 0.35, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
842,0.35,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--0.7 (700m = 10mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_14janvier_pietons_10mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_14janvier_pietons_10mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
842, 0.7, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
842,0.7,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--1.5 (1.5km = 20mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_14janvier_pietons_20mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_14janvier_pietons_20mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
842, 1.5, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
842,1.5,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
-- VELOS
--Avec les arcs et les noeuds
--0.5 (500m = 2mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_14janvier_velos_2mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_14janvier_velos_2mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
842, 0.5, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
842,0.5,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--1 (1km = 4mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_14janvier_velos_4mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_14janvier_velos_4mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
842, 1, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
842,1,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--2 (2km = 8mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_14janvier_velos_8mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_14janvier_velos_8mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
842, 2, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
842,2,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
-- VOITURE
--Avec les arcs et les noeuds
--1.3 (1.3km = 2mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_14janvier_voiture_2mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_14janvier_voiture_2mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
842, 1.3, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
842,1.3,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--2.6 (2.6km = 4mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_14janvier_voiture_4mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_14janvier_voiture_4mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
842, 2.6, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
842,2.6,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;

/*
-------------------------------------------------------------------------------------
ETAPE 1 : ANALYSES THEMATIQUES : CALCUL D'ISOCHRONES
          POSTE SECONDAIRE : MONGI SLIM
-------------------------------------------------------------------------------------
*/
-- PIETONS
--Avec les arcs et les noeuds
--0.35 (350m = 5mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_mongislim_pietons_5mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_mongislim_pietons_5mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
612, 0.35, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
612,0.35,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--0.7 (700m = 10mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_mongislim_pietons_10mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_mongislim_pietons_10mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
612, 0.7, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
612,0.7,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--1.5 (1.5km = 20mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_mongislim_pietons_20mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_mongislim_pietons_20mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
612, 1.5, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
612,1.5,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
-- VELOS
--Avec les arcs et les noeuds
--0.5 (500m = 2mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_mongislim_velos_2mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_mongislim_velos_2mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
612, 0.5, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
612,0.5,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--1 (1km = 4mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_mongislim_velos_4mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_mongislim_velos_4mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
612, 1, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
612,1,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--2 (2km = 8mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_mongislim_velos_8mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_mongislim_velos_8mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
612, 2, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
612,2,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
-- VOITURE
--Avec les arcs et les noeuds
--1.3 (1.3km = 2mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_mongislim_voiture_2mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_mongislim_voiture_2mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
612, 1.3, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
612,1.3,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--2.6 (2.6km = 4mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_mongislim_voiture_4mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_mongislim_voiture_4mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
612, 2.6, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
612,2.6,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;


/*
-------------------------------------------------------------------------------------
ETAPE 1 : ANALYSES THEMATIQUES : CALCUL D'ISOCHRONES
          POSTE SECONDAIRE : KHAIREDDINE PACHA
-------------------------------------------------------------------------------------
*/
-- PIETONS
--Avec les arcs et les noeuds
--0.35 (350m = 5mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_khaireddinepacha_pietons_5mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_khaireddinepacha_pietons_5mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
106, 0.35, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
106,0.35,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--0.7 (700m = 10mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_khaireddinepacha_pietons_10mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_khaireddinepacha_pietons_10mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
106, 0.7, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
106,0.7,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--1.5 (1.5km = 20mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_khaireddinepacha_pietons_20mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_khaireddinepacha_pietons_20mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
106, 1.5, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
106,1.5,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
-- VELOS
--Avec les arcs et les noeuds
--0.5 (500m = 2mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_khaireddinepacha_velos_2mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_khaireddinepacha_velos_2mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
106, 0.5, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
106,0.5,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--1 (1km = 4mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_khaireddinepacha_velos_4mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_khaireddinepacha_velos_4mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
106, 1, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
106,1,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--2 (2km = 8mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_khaireddinepacha_velos_8mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_khaireddinepacha_velos_8mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
106, 2, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
106,2,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
-- VOITURE
--Avec les arcs et les noeuds
--1.3 (1.3km = 2mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_khaireddinepacha_voiture_2mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_khaireddinepacha_voiture_2mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
106, 1.3, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
106,1.3,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--2.6 (2.6km = 4mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_khaireddinepacha_voiture_4mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_khaireddinepacha_voiture_4mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
106, 2.6, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
106,2.6,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;


/*
-------------------------------------------------------------------------------------
ETAPE 1 : ANALYSES THEMATIQUES : CALCUL D'ISOCHRONES
          POSTE SECONDAIRE : ABULKASSEM ECH-CHEBBI
-------------------------------------------------------------------------------------
*/
-- PIETONS
--Avec les arcs et les noeuds
--0.35 (350m = 5mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_abulkassem_pietons_5mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_abulkassem_pietons_5mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
426, 0.35, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
426,0.35,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--0.7 (700m = 10mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_abulkassem_pietons_10mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_abulkassem_pietons_10mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
426, 0.7, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
426,0.7,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--1.5 (1.5km = 20mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_abulkassem_pietons_20mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_abulkassem_pietons_20mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
426, 1.5, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
426,1.5,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
-- VELOS
--Avec les arcs et les noeuds
--0.5 (500m = 2mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_abulkassem_velos_2mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_abulkassem_velos_2mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
426, 0.5, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
426,0.5,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--1 (1km = 4mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_abulkassem_velos_4mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_abulkassem_velos_4mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
426, 1, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
426,1,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--2 (2km = 8mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_abulkassem_velos_8mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_abulkassem_velos_8mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
426, 2, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
426,2,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
-- VOITURE
--Avec les arcs et les noeuds
--1.3 (1.3km = 2mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_abulkassem_voiture_2mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_abulkassem_voiture_2mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
426, 1.3, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
426,1.3,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--2.6 (2.6km = 4mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_abulkassem_voiture_4mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_abulkassem_voiture_4mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
426, 2.6, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
426,2.6,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;


/*
-------------------------------------------------------------------------------------
ETAPE 1 : ANALYSES THEMATIQUES : CALCUL D'ISOCHRONES
          POSTE SECONDAIRE : IBN KHALDOUN
-------------------------------------------------------------------------------------
*/
-- PIETONS
--Avec les arcs et les noeuds
--0.35 (350m = 5mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_ibnkhaldoun_pietons_5mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_ibnkhaldoun_pietons_5mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
728, 0.35, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
728,0.35,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--0.7 (700m = 10mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_ibnkhaldoun_pietons_10mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_ibnkhaldoun_pietons_10mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
728, 0.7, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
728,0.7,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--1.5 (1.5km = 20mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_ibnkhaldoun_pietons_20mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_ibnkhaldoun_pietons_20mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
728, 1.5, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
728,1.5,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
-- VELOS
--Avec les arcs et les noeuds
--0.5 (500m = 2mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_ibnkhaldoun_velos_2mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_ibnkhaldoun_velos_2mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
728, 0.5, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
728,0.5,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--1 (1km = 4mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_ibnkhaldoun_velos_4mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_ibnkhaldoun_velos_4mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
728, 1, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
728,1,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--2 (2km = 8mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_ibnkhaldoun_velos_8mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_ibnkhaldoun_velos_8mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
728, 2, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
728,2,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
-- VOITURE
--Avec les arcs et les noeuds
--1.3 (1.3km = 2mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_ibnkhaldoun_voiture_2mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_ibnkhaldoun_voiture_2mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
728, 1.3, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
728,1.3,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--2.6 (2.6km = 4mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_ibnkhaldoun_voiture_4mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_ibnkhaldoun_voiture_4mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
728, 2.6, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
728,2.6,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;


/*
-------------------------------------------------------------------------------------
ETAPE 1 : ANALYSES THEMATIQUES : CALCUL D'ISOCHRONES
          POSTE SECONDAIRE : CITE ETTADHAMEN
-------------------------------------------------------------------------------------
*/
-- PIETONS
--Avec les arcs et les noeuds
--0.35 (350m = 5mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_ettadhamen_pietons_5mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_ettadhamen_pietons_5mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
457, 0.35, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
457,0.35,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--0.7 (700m = 10mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_ettadhamen_pietons_10mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_ettadhamen_pietons_10mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
457, 0.7, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
457,0.7,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--1.5 (1.5km = 20mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_ettadhamen_pietons_20mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_ettadhamen_pietons_20mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
457, 1.5, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
457,1.5,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
-- VELOS
--Avec les arcs et les noeuds
--0.5 (500m = 2mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_ettadhamen_velos_2mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_ettadhamen_velos_2mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
457, 0.5, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
457,0.5,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--1 (1km = 4mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_ettadhamen_velos_4mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_ettadhamen_velos_4mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
457, 1, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
457,1,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--2 (2km = 8mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_ettadhamen_velos_8mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_ettadhamen_velos_8mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
457, 2, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
457,2,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
-- VOITURE
--Avec les arcs et les noeuds
--1.3 (1.3km = 2mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_ettadhamen_voiture_2mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_ettadhamen_voiture_2mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
457, 1.3, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
457,1.3,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--2.6 (2.6km = 4mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_ettadhamen_voiture_4mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_ettadhamen_voiture_4mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
457, 2.6, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
457,2.6,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;



/*
-------------------------------------------------------------------------------------
ETAPE 1 : ANALYSES THEMATIQUES : CALCUL D'ISOCHRONES
          POSTE SECONDAIRE : 09 AVRIL
-------------------------------------------------------------------------------------
*/
-- PIETONS
--Avec les arcs et les noeuds
--0.35 (350m = 5mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_09avril_pietons_5mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_09avril_pietons_5mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
984, 0.35, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
984,0.35,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--0.7 (700m = 10mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_09avril_pietons_10mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_09avril_pietons_10mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
984, 0.7, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
984,0.7,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--1.5 (1.5km = 20mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_09avril_pietons_20mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_09avril_pietons_20mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
984, 1.5, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
984,1.5,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
-- VELOS
--Avec les arcs et les noeuds
--0.5 (500m = 2mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_09avril_velos_2mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_09avril_velos_2mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
984, 0.5, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
984,0.5,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--1 (1km = 4mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_09avril_velos_4mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_09avril_velos_4mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
984, 1, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
984,1,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--2 (2km = 8mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_09avril_velos_8mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_09avril_velos_8mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
984, 2, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
984,2,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
-- VOITURE
--Avec les arcs et les noeuds
--1.3 (1.3km = 2mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_09avril_voiture_2mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_09avril_voiture_2mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
984, 1.3, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
984,1.3,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--2.6 (2.6km = 4mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_09avril_voiture_4mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_09avril_voiture_4mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
984, 2.6, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
984,2.6,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;


/*
-------------------------------------------------------------------------------------
ETAPE 1 : ANALYSES THEMATIQUES : CALCUL D'ISOCHRONES
          POSTE SECONDAIRE : 18 JANVIER
-------------------------------------------------------------------------------------
*/
-- PIETONS
--Avec les arcs et les noeuds
--0.35 (350m = 5mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_18janvier_pietons_5mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_18janvier_pietons_5mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
1316, 0.35, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
1316,0.35,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--0.7 (700m = 10mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_18janvier_pietons_10mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_18janvier_pietons_10mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
1316, 0.7, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
1316,0.7,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--1.5 (1.5km = 20mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_18janvier_pietons_20mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_18janvier_pietons_20mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
1316, 1.5, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
1316,1.5,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
-- VELOS
--Avec les arcs et les noeuds
--0.5 (500m = 2mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_18janvier_velos_2mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_18janvier_velos_2mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
1316, 0.5, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
1316,0.5,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--1 (1km = 4mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_18janvier_velos_4mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_18janvier_velos_4mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
1316, 1, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
1316,1,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--2 (2km = 8mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_18janvier_velos_8mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_18janvier_velos_8mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
1316, 2, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
1316,2,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
-- VOITURE
--Avec les arcs et les noeuds
--1.3 (1.3km = 2mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_18janvier_voiture_2mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_18janvier_voiture_2mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
1316, 1.3, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
1316,1.3,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--2.6 (2.6km = 4mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_18janvier_voiture_4mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_18janvier_voiture_4mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
1316, 2.6, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
1316,2.6,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;

/*
-------------------------------------------------------------------------------------
ETAPE 1 : ANALYSES THEMATIQUES : CALCUL D'ISOCHRONES
          POSTE SECONDAIRE : 20 MARS
-------------------------------------------------------------------------------------
*/
-- PIETONS
--Avec les arcs et les noeuds
--0.35 (350m = 5mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_20mars_pietons_5mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_20mars_pietons_5mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
332, 0.35, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
332,0.35,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--0.7 (700m = 10mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_20mars_pietons_10mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_20mars_pietons_10mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
332, 0.7, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
332,0.7,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--1.5 (1.5km = 20mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_20mars_pietons_20mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_20mars_pietons_20mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
332, 1.5, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
332,1.5,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
-- VELOS
--Avec les arcs et les noeuds
--0.5 (500m = 2mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_20mars_velos_2mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_20mars_velos_2mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
332, 0.5, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
332,0.5,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--1 (1km = 4mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_20mars_velos_4mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_20mars_velos_4mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
332, 1, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
332,1,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--2 (2km = 8mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_20mars_velos_8mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_20mars_velos_8mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
332, 2, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
332,2,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
-- VOITURE
--Avec les arcs et les noeuds
--1.3 (1.3km = 2mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_20mars_voiture_2mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_20mars_voiture_2mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
332, 1.3, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
332,1.3,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
--Avec les arcs et les noeuds
--2.6 (2.6km = 4mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_20mars_voiture_4mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_20mars_voiture_4mn as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
332, 2.6, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
332,2.6,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;


/*
-------------------------------------------------------------------------------------
ETAPE 2 : ANALYSES THEMATIQUES : CALCUL D'ISOCHRONES
          POSTES SECONDAIRES UNION
-------------------------------------------------------------------------------------
*/
-- PIETONS
--Avec les arcs et les noeuds
--0.35 (350m = 5mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_postesec_pietons_5mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_postesec_pietons_5mn as
with merge as (
select*
from routing.st_makepolygon_st_exteriorring_09avril_pietons_5mn
union all
select*
from routing.st_makepolygon_st_exteriorring_14janvier_pietons_5mn
union all
select*
from routing.st_makepolygon_st_exteriorring_18janvier_pietons_5mn
union all
select*
from routing.st_makepolygon_st_exteriorring_abulkassem_pietons_5mn
union all
select*
from routing.st_makepolygon_st_exteriorring_ettadhamen_pietons_5mn
union all
select*
from routing.st_makepolygon_st_exteriorring_ibnkhaldoun_pietons_5mn
union all
select*
from routing.st_makepolygon_st_exteriorring_khaireddinepacha_pietons_5mn
union all
select*
from routing.st_makepolygon_st_exteriorring_mongislim_pietons_5mn
union all
select*
from routing.st_makepolygon_st_exteriorring_20mars_pietons_5mn)
SELECT st_union (geom) from merge
;
--Avec les arcs et les noeuds
--0.7 (700m = 10mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_postesec_pietons_10mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_postesec_pietons_10mn as
with merge as (
select*
from routing.st_makepolygon_st_exteriorring_09avril_pietons_10mn
union all
select*
from routing.st_makepolygon_st_exteriorring_14janvier_pietons_10mn
union all
select*
from routing.st_makepolygon_st_exteriorring_18janvier_pietons_10mn
union all
select*
from routing.st_makepolygon_st_exteriorring_abulkassem_pietons_10mn
union all
select*
from routing.st_makepolygon_st_exteriorring_ettadhamen_pietons_10mn
union all
select*
from routing.st_makepolygon_st_exteriorring_ibnkhaldoun_pietons_10mn
union all
select*
from routing.st_makepolygon_st_exteriorring_khaireddinepacha_pietons_10mn
union all
select*
from routing.st_makepolygon_st_exteriorring_mongislim_pietons_10mn
union all
select*
from routing.st_makepolygon_st_exteriorring_20mars_pietons_10mn)
SELECT st_union (geom) from merge
;
--Avec les arcs et les noeuds
--1.5 (1.5km = 20mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_postesec_pietons_20mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_postesec_pietons_20mn as
with merge as (
select*
from routing.st_makepolygon_st_exteriorring_09avril_pietons_20mn
union all
select*
from routing.st_makepolygon_st_exteriorring_14janvier_pietons_20mn
union all
select*
from routing.st_makepolygon_st_exteriorring_18janvier_pietons_20mn
union all
select*
from routing.st_makepolygon_st_exteriorring_abulkassem_pietons_20mn
union all
select*
from routing.st_makepolygon_st_exteriorring_ettadhamen_pietons_20mn
union all
select*
from routing.st_makepolygon_st_exteriorring_ibnkhaldoun_pietons_20mn
union all
select*
from routing.st_makepolygon_st_exteriorring_khaireddinepacha_pietons_20mn
union all
select*
from routing.st_makepolygon_st_exteriorring_mongislim_pietons_20mn
union all
select*
from routing.st_makepolygon_st_exteriorring_20mars_pietons_20mn)
SELECT st_union (geom) from merge
;
-- VELOS
--Avec les arcs et les noeuds
--0.5 (500m = 2mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_postesec_velos_2mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_postesec_velos_2mn as
with merge as (
select*
from routing.st_makepolygon_st_exteriorring_09avril_velos_2mn
union all
select*
from routing.st_makepolygon_st_exteriorring_14janvier_velos_2mn
union all
select*
from routing.st_makepolygon_st_exteriorring_18janvier_velos_2mn
union all
select*
from routing.st_makepolygon_st_exteriorring_abulkassem_velos_2mn
union all
select*
from routing.st_makepolygon_st_exteriorring_ettadhamen_velos_2mn
union all
select*
from routing.st_makepolygon_st_exteriorring_ibnkhaldoun_velos_2mn
union all
select*
from routing.st_makepolygon_st_exteriorring_khaireddinepacha_velos_2mn
union all
select*
from routing.st_makepolygon_st_exteriorring_mongislim_velos_2mn
union all
select*
from routing.st_makepolygon_st_exteriorring_20mars_velos_2mn)
SELECT st_union (geom) from merge
;
--Avec les arcs et les noeuds
--1 (1km = 4mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_postesec_velos_4mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_postesec_velos_4mn as
with merge as (
select*
from routing.st_makepolygon_st_exteriorring_09avril_velos_4mn
union all
select*
from routing.st_makepolygon_st_exteriorring_14janvier_velos_4mn
union all
select*
from routing.st_makepolygon_st_exteriorring_18janvier_velos_4mn
union all
select*
from routing.st_makepolygon_st_exteriorring_abulkassem_velos_4mn
union all
select*
from routing.st_makepolygon_st_exteriorring_ettadhamen_velos_4mn
union all
select*
from routing.st_makepolygon_st_exteriorring_ibnkhaldoun_velos_4mn
union all
select*
from routing.st_makepolygon_st_exteriorring_khaireddinepacha_velos_4mn
union all
select*
from routing.st_makepolygon_st_exteriorring_mongislim_velos_4mn
union all
select*
from routing.st_makepolygon_st_exteriorring_20mars_velos_4mn)
SELECT st_union (geom) from merge
;
--Avec les arcs et les noeuds
--2 (2km = 8mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_postesec_velos_8mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_postesec_velos_8mn as
with merge as (
select*
from routing.st_makepolygon_st_exteriorring_09avril_velos_8mn
union all
select*
from routing.st_makepolygon_st_exteriorring_14janvier_velos_8mn
union all
select*
from routing.st_makepolygon_st_exteriorring_18janvier_velos_8mn
union all
select*
from routing.st_makepolygon_st_exteriorring_abulkassem_velos_8mn
union all
select*
from routing.st_makepolygon_st_exteriorring_ettadhamen_velos_8mn
union all
select*
from routing.st_makepolygon_st_exteriorring_ibnkhaldoun_velos_8mn
union all
select*
from routing.st_makepolygon_st_exteriorring_khaireddinepacha_velos_8mn
union all
select*
from routing.st_makepolygon_st_exteriorring_mongislim_velos_8mn
union all
select*
from routing.st_makepolygon_st_exteriorring_20mars_velos_8mn)
SELECT st_union (geom) from merge
;
-- VOITURE
--Avec les arcs et les noeuds
--1.3 (1.3km = 2mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_postesec_voiture_2mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_postesec_voiture_2mn as
with merge as (
select*
from routing.st_makepolygon_st_exteriorring_09avril_voiture_2mn
union all
select*
from routing.st_makepolygon_st_exteriorring_14janvier_voiture_2mn
union all
select*
from routing.st_makepolygon_st_exteriorring_18janvier_voiture_2mn
union all
select*
from routing.st_makepolygon_st_exteriorring_abulkassem_voiture_2mn
union all
select*
from routing.st_makepolygon_st_exteriorring_ettadhamen_voiture_2mn
union all
select*
from routing.st_makepolygon_st_exteriorring_ibnkhaldoun_voiture_2mn
union all
select*
from routing.st_makepolygon_st_exteriorring_khaireddinepacha_voiture_2mn
union all
select*
from routing.st_makepolygon_st_exteriorring_mongislim_voiture_2mn
union all
select*
from routing.st_makepolygon_st_exteriorring_20mars_voiture_2mn)
SELECT st_union (geom) from merge
;
--Avec les arcs et les noeuds
--2.6 (2.6km = 4mn)
drop table if exists routing.ST_MakePolygon_ST_ExteriorRing_postesec_voiture_4mn;
create table routing.ST_MakePolygon_ST_ExteriorRing_postesec_voiture_4mn as
with merge as (
select*
from routing.st_makepolygon_st_exteriorring_09avril_voiture_4mn
union all
select*
from routing.st_makepolygon_st_exteriorring_14janvier_voiture_4mn
union all
select*
from routing.st_makepolygon_st_exteriorring_18janvier_voiture_4mn
union all
select*
from routing.st_makepolygon_st_exteriorring_abulkassem_voiture_4mn
union all
select*
from routing.st_makepolygon_st_exteriorring_ettadhamen_voiture_4mn
union all
select*
from routing.st_makepolygon_st_exteriorring_ibnkhaldoun_voiture_4mn
union all
select*
from routing.st_makepolygon_st_exteriorring_khaireddinepacha_voiture_4mn
union all
select*
from routing.st_makepolygon_st_exteriorring_mongislim_voiture_4mn
union all
select*
from routing.st_makepolygon_st_exteriorring_20mars_voiture_4mn)
SELECT st_union (geom) from merge
;

/*
-------------------------------------------------------------------------------------
ETAPE 3 : ANALYSES THEMATIQUES : CALCUL D'ISOCHRONES
          AJOUT CHAMP surf_hab CONNAITRE POPULATION TOUCHEE PAR ISOCHRONE
-------------------------------------------------------------------------------------
*/

-- PIETONS
ALTER TABLE routing.ST_MakePolygon_ST_ExteriorRing_postesec_pietons_5mn ADD COLUMN surf_hab integer;
	
UPDATE routing.ST_MakePolygon_ST_ExteriorRing_postesec_pietons_5mn a
SET surf_hab = t.sumPrice
FROM batiments.osm_2018 AS p
INNER JOIN
    (
    select a.st_union as geom, sum(b.surf_hab)sumPrice, nom_del_fr
	from routing.ST_MakePolygon_ST_ExteriorRing_postesec_pietons_5mn a, batiments.osm_2018 b
	where st_intersects(a.st_union, b.geom) and nom_del_fr like 'CITE ETTADHAMEN' and usage like 'Particulier'
	group by a.st_union, nom_del_fr
    ) t
    ON t.nom_del_fr = p.nom_del_fr
    ;

ALTER TABLE routing.ST_MakePolygon_ST_ExteriorRing_postesec_pietons_10mn ADD COLUMN surf_hab integer;
	
UPDATE routing.ST_MakePolygon_ST_ExteriorRing_postesec_pietons_10mn a
SET surf_hab = t.sumPrice
FROM batiments.osm_2018 AS p
INNER JOIN
    (
    select a.st_union as geom, sum(b.surf_hab)sumPrice, nom_del_fr
	from routing.ST_MakePolygon_ST_ExteriorRing_postesec_pietons_10mn a, batiments.osm_2018 b
	where st_intersects(a.st_union, b.geom) and nom_del_fr like 'CITE ETTADHAMEN' and usage like 'Particulier'
	group by a.st_union, nom_del_fr
    ) t
    ON t.nom_del_fr = p.nom_del_fr
    ;

ALTER TABLE routing.ST_MakePolygon_ST_ExteriorRing_postesec_pietons_20mn ADD COLUMN surf_hab integer;
	
UPDATE routing.ST_MakePolygon_ST_ExteriorRing_postesec_pietons_20mn a
SET surf_hab = t.sumPrice
FROM batiments.osm_2018 AS p
INNER JOIN
    (
    select a.st_union as geom, sum(b.surf_hab)sumPrice, nom_del_fr
	from routing.ST_MakePolygon_ST_ExteriorRing_postesec_pietons_20mn a, batiments.osm_2018 b
	where st_intersects(a.st_union, b.geom) and nom_del_fr like 'CITE ETTADHAMEN' and usage like 'Particulier'
	group by a.st_union, nom_del_fr
    ) t
    ON t.nom_del_fr = p.nom_del_fr
    ;

-- VELOS

ALTER TABLE routing.ST_MakePolygon_ST_ExteriorRing_postesec_velos_2mn ADD COLUMN surf_hab integer;
	
UPDATE routing.ST_MakePolygon_ST_ExteriorRing_postesec_velos_2mn a
SET surf_hab = t.sumPrice
FROM batiments.osm_2018 AS p
INNER JOIN
    (
    select a.st_union as geom, sum(b.surf_hab)sumPrice, nom_del_fr
	from routing.ST_MakePolygon_ST_ExteriorRing_postesec_velos_2mn a, batiments.osm_2018 b
	where st_intersects(a.st_union, b.geom) and nom_del_fr like 'CITE ETTADHAMEN' and usage like 'Particulier'
	group by a.st_union, nom_del_fr
    ) t
    ON t.nom_del_fr = p.nom_del_fr
    ;

ALTER TABLE routing.ST_MakePolygon_ST_ExteriorRing_postesec_velos_4mn ADD COLUMN surf_hab integer;
	
UPDATE routing.ST_MakePolygon_ST_ExteriorRing_postesec_velos_4mn a
SET surf_hab = t.sumPrice
FROM batiments.osm_2018 AS p
INNER JOIN
    (
    select a.st_union as geom, sum(b.surf_hab)sumPrice, nom_del_fr
	from routing.ST_MakePolygon_ST_ExteriorRing_postesec_velos_4mn a, batiments.osm_2018 b
	where st_intersects(a.st_union, b.geom) and nom_del_fr like 'CITE ETTADHAMEN' and usage like 'Particulier'
	group by a.st_union, nom_del_fr
    ) t
    ON t.nom_del_fr = p.nom_del_fr
    ;

ALTER TABLE routing.ST_MakePolygon_ST_ExteriorRing_postesec_velos_8mn ADD COLUMN surf_hab integer;
	
UPDATE routing.ST_MakePolygon_ST_ExteriorRing_postesec_velos_8mn a
SET surf_hab = t.sumPrice
FROM batiments.osm_2018 AS p
INNER JOIN
    (
    select a.st_union as geom, sum(b.surf_hab)sumPrice, nom_del_fr
	from routing.ST_MakePolygon_ST_ExteriorRing_postesec_velos_8mn a, batiments.osm_2018 b
	where st_intersects(a.st_union, b.geom) and nom_del_fr like 'CITE ETTADHAMEN' and usage like 'Particulier'
	group by a.st_union, nom_del_fr
    ) t
    ON t.nom_del_fr = p.nom_del_fr
    ;

-- VOITURES

ALTER TABLE routing.ST_MakePolygon_ST_ExteriorRing_postesec_voiture_2mn ADD COLUMN surf_hab integer;
	
UPDATE routing.ST_MakePolygon_ST_ExteriorRing_postesec_voiture_2mn a
SET surf_hab = t.sumPrice
FROM batiments.osm_2018 AS p
INNER JOIN
    (
    select a.st_union as geom, sum(b.surf_hab)sumPrice, nom_del_fr
	from routing.ST_MakePolygon_ST_ExteriorRing_postesec_voiture_2mn a, batiments.osm_2018 b
	where st_intersects(a.st_union, b.geom) and nom_del_fr like 'CITE ETTADHAMEN' and usage like 'Particulier'
	group by a.st_union, nom_del_fr
    ) t
    ON t.nom_del_fr = p.nom_del_fr
    ;

ALTER TABLE routing.ST_MakePolygon_ST_ExteriorRing_postesec_voiture_4mn ADD COLUMN surf_hab integer;
	
UPDATE routing.ST_MakePolygon_ST_ExteriorRing_postesec_voiture_4mn a
SET surf_hab = t.sumPrice
FROM batiments.osm_2018 AS p
INNER JOIN
    (
    select a.st_union as geom, sum(b.surf_hab)sumPrice, nom_del_fr
	from routing.ST_MakePolygon_ST_ExteriorRing_postesec_voiture_4mn a, batiments.osm_2018 b
	where st_intersects(a.st_union, b.geom) and nom_del_fr like 'CITE ETTADHAMEN' and usage like 'Particulier'
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

-- POSTES SECTEURS

drop table if exists analyses.st_makepolygon_st_exteriorring_postesec_pietons_5mn;
create table analyses.st_makepolygon_st_exteriorring_postesec_pietons_5mn as 
select *
from routing.st_makepolygon_st_exteriorring_postesec_pietons_5mn;

CREATE INDEX st_makepolygon_st_exteriorring_postesec_pietons_5mn_gix 
ON analyses.st_makepolygon_st_exteriorring_postesec_pietons_5mn USING GIST (st_union);
ALTER TABLE analyses.st_makepolygon_st_exteriorring_postesec_pietons_5mn 
ADD COLUMN gid SERIAL PRIMARY KEY;

drop table if exists analyses.st_makepolygon_st_exteriorring_postesec_pietons_10mn;
create table analyses.st_makepolygon_st_exteriorring_postesec_pietons_10mn as 
select *
from routing.st_makepolygon_st_exteriorring_postesec_pietons_10mn;

CREATE INDEX st_makepolygon_st_exteriorring_postesec_pietons_10mn_gix 
ON analyses.st_makepolygon_st_exteriorring_postesec_pietons_10mn USING GIST (st_union);
ALTER TABLE analyses.st_makepolygon_st_exteriorring_postesec_pietons_10mn 
ADD COLUMN gid SERIAL PRIMARY KEY;

drop table if exists analyses.st_makepolygon_st_exteriorring_postesec_pietons_20mn;
create table analyses.st_makepolygon_st_exteriorring_postesec_pietons_20mn as 
select *
from routing.st_makepolygon_st_exteriorring_postesec_pietons_20mn;

CREATE INDEX st_makepolygon_st_exteriorring_postesec_pietons_20mn_gix 
ON analyses.st_makepolygon_st_exteriorring_postesec_pietons_20mn USING GIST (st_union);
ALTER TABLE analyses.st_makepolygon_st_exteriorring_postesec_pietons_20mn 
ADD COLUMN gid SERIAL PRIMARY KEY;

drop table if exists analyses.st_makepolygon_st_exteriorring_postesec_velos_2mn;
create table analyses.st_makepolygon_st_exteriorring_postesec_velos_2mn as 
select *
from routing.st_makepolygon_st_exteriorring_postesec_velos_2mn;

CREATE INDEX st_makepolygon_st_exteriorring_postesec_velos_2mn_gix 
ON analyses.st_makepolygon_st_exteriorring_postesec_velos_2mn USING GIST (st_union);
ALTER TABLE analyses.st_makepolygon_st_exteriorring_postesec_velos_2mn 
ADD COLUMN gid SERIAL PRIMARY KEY;

drop table if exists analyses.st_makepolygon_st_exteriorring_postesec_velos_4mn;
create table analyses.st_makepolygon_st_exteriorring_postesec_velos_4mn as 
select *
from routing.st_makepolygon_st_exteriorring_postesec_velos_4mn;

CREATE INDEX st_makepolygon_st_exteriorring_postesec_velos_4mn_gix 
ON analyses.st_makepolygon_st_exteriorring_postesec_velos_4mn USING GIST (st_union);
ALTER TABLE analyses.st_makepolygon_st_exteriorring_postesec_velos_4mn 
ADD COLUMN gid SERIAL PRIMARY KEY;

drop table if exists analyses.st_makepolygon_st_exteriorring_postesec_velos_8mn;
create table analyses.st_makepolygon_st_exteriorring_postesec_velos_8mn as 
select *
from routing.st_makepolygon_st_exteriorring_postesec_velos_8mn;

CREATE INDEX st_makepolygon_st_exteriorring_postesec_velos_8mn_gix 
ON analyses.st_makepolygon_st_exteriorring_postesec_velos_8mn USING GIST (st_union);
ALTER TABLE analyses.st_makepolygon_st_exteriorring_postesec_velos_8mn 
ADD COLUMN gid SERIAL PRIMARY KEY;

drop table if exists analyses.st_makepolygon_st_exteriorring_postesec_voiture_2mn;
create table analyses.st_makepolygon_st_exteriorring_postesec_voiture_2mn as 
select *
from routing.st_makepolygon_st_exteriorring_postesec_voiture_2mn;

CREATE INDEX st_makepolygon_st_exteriorring_postesec_voiture_2mn_gix 
ON analyses.st_makepolygon_st_exteriorring_postesec_voiture_2mn USING GIST (st_union);
ALTER TABLE analyses.st_makepolygon_st_exteriorring_postesec_voiture_2mn 
ADD COLUMN gid SERIAL PRIMARY KEY;

drop table if exists analyses.st_makepolygon_st_exteriorring_postesec_voiture_4mn;
create table analyses.st_makepolygon_st_exteriorring_postesec_voiture_4mn as 
select *
from routing.st_makepolygon_st_exteriorring_postesec_voiture_4mn;

CREATE INDEX st_makepolygon_st_exteriorring_postesec_voiture_4mn_gix 
ON analyses.st_makepolygon_st_exteriorring_postesec_voiture_4mn USING GIST (st_union);
ALTER TABLE analyses.st_makepolygon_st_exteriorring_postesec_voiture_4mn 
ADD COLUMN gid SERIAL PRIMARY KEY;






