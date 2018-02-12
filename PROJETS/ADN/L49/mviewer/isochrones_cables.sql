-Next, we create start and end point geometries. I used a view:
SELECT AddGeometryColumn ('rip1','cables_linestring','start_point',2154,'POINT',2);
UPDATE rip1.cables_linestring SET start_point = ST_StartPoint(geom);
SELECT AddGeometryColumn ('rip1','cables_linestring','end_point',2154,'POINT',2);
UPDATE rip1.cables_linestring SET end_point = ST_EndPoint(geom);

CREATE TABLE routing.cable_node AS
   SELECT row_number() OVER (ORDER BY foo.p)::integer AS id,
          foo.p AS the_geom
   FROM (
      SELECT DISTINCT road_ext.startpoint AS p FROM rip1.cables_linestring as road_ext
      UNION
      SELECT DISTINCT road_ext.endpoint AS p FROM rip1.cables_linestring as road_ext
   ) foo
   GROUP BY foo.p;
   
   CREATE TABLE routing.network AS
   SELECT a.*, b.id as start_id, c.id as end_id
   FROM rip1.cables_linestring AS a
      JOIN routing.cable_node AS b ON a.startpoint = b.the_geom
      JOIN routing.cable_node AS c ON a.endpoint = c.the_geom
	 ; 
	 
ALTER TABLE routing.network  add COLUMN  shape_leng float8;
update  routing.network as a
set shape_leng=st_length (geom)


with buffer_itineraire as (
SELECT et.id ,
st_buffer(et. geom,10, 'endcap=square join=round') as geom
, 1 as factor
FROM
(SELECT *  FROM pgr_drivingDistance(
'SELECT id::integer, start_node as source, end_node as target, tps_distance as cost FROM routing.network',
200, 0.5, false, false)
) firstPath
CROSS JOIN
(SELECT *  FROM pgr_drivingDistance(
'SELECT id::integer, start_node as source, end_node as target, tps_distance as cost FROM routing.network',
21561, 0.5, false, false)
) secondPath
INNER JOIN routing.network et
ON firstPath.id1 = et.start_node
AND secondPath.id1 = et.end_node)
SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(geom),1))) as geom FROM buffer_itineraire;


SELECT *  FROM pgr_drivingDistance(
        'SELECT id::integer, start_node as source, end_node as target, tps_distance as cost FROM routing.network',
        200, 0.5, false, false
      );

drop table if exists routing.test;
create table routing.test as 
 SELECT seq, id1 AS node, id2 AS edge, cost, the_geom
  FROM pgr_drivingdistance(
    'SELECT id::integer, start_node as source, end_node as target, tps_distance as cost FROM routing.network',
    1, 100000, false, false
  ) as di
  JOIN routing.cable_node pt
  ON di.id1 = pt.id;
  
  SELECT ST_MakePolygon(ST_ExteriorRing(ST_GeometryN(st_union(the_geom),1))) as geom FROM routing.test;