drop table if exists resultats.burkina_isochrone_agroalimentaire_1;
create table resultats.burkina_isochrone_agroalimentaire_1 as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
8503, 0.2, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
8503,0.2,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;


drop table if exists resultats.burkina_isochrone_agroalimentaire_2;
create table resultats.burkina_isochrone_agroalimentaire_2 as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
7085, 0.2, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
7085,0.2,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;


drop table if exists resultats.burkina_isochrone_agroalimentaire_3;
create table resultats.burkina_isochrone_agroalimentaire_3 as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
8296, 0.2, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
8296,0.2,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;

drop table if exists resultats.burkina_isochrone_agroalimentaire_4;
create table resultats.burkina_isochrone_agroalimentaire_4 as
with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
6662, 0.2, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
6662,0.2,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;

drop table if exists resultats.burkina_isochrone_agroalimentaire_5;
create table resultats.burkina_isochrone_agroalimentaire_5 as

with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
7751, 0.2, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
7751,0.2,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;

drop table if exists resultats.burkina_isochrone_agroalimentaire_6;
create table resultats.burkina_isochrone_agroalimentaire_6 as

with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
8281, 0.2, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
8281,0.2,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;


drop table if exists resultats.burkina_isochrone_agroalimentaire_7;
create table resultats.burkina_isochrone_agroalimentaire_7 as

with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
8822, 0.2, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
8822,0.2,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;


drop table if exists resultats.burkina_isochrone_agroalimentaire_8;
create table resultats.burkina_isochrone_agroalimentaire_8 as

with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
7789, 0.2, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
7789,0.2,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;

drop table if exists resultats.burkina_isochrone_agroalimentaire_9;
create table resultats.burkina_isochrone_agroalimentaire_9 as

with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
8356, 0.2, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
8356,0.2,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;


drop table if exists resultats.burkina_isochrone_agroalimentaire_10;
create table resultats.burkina_isochrone_agroalimentaire_10 as

with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
9238, 0.2, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
9238,0.2,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;

drop table if exists resultats.burkina_isochrone_agroalimentaire_11;
create table resultats.burkina_isochrone_agroalimentaire_11 as

with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
8360, 0.2, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
8360,0.2,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;


drop table if exists resultats.burkina_isochrone_agroalimentaire_11;
create table resultats.burkina_isochrone_agroalimentaire_11 as

with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
8271, 0.2, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
8271,0.2,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;

drop table if exists resultats.burkina_isochrone_agroalimentaire_12;
create table resultats.burkina_isochrone_agroalimentaire_12 as

with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
8355, 0.2, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
8355,0.2,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;

drop table if exists resultats.burkina_isochrone_agroalimentaire_13;
create table resultats.burkina_isochrone_agroalimentaire_13 as

with buffer_itineraire as (
SELECT et.edge_id,
st_buffer(et.geom,10,'endcap=square join=round') as geom
, 1 as factor
FROM pgr_drivingdistance(
'SELECT edge_id as id, start_node as source, end_node as target, tps_distance as cost from routing.edge_data',
7435, 0.2, false, false
) firstPath
CROSS JOIN
(SELECT id1,cost from pgr_drivingDistance(
'SELECT edge_id as id,start_node as source , end_node as target,tps_distance as cost FROM routing.edge_data',
7435,0.2,false,false)
) secondPath
INNER JOIN routing.edge_data et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;
