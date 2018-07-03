--- Schema : rbal
--- Vue : v_liaison_snap
--- Traitement : Vue qui snap toutes les liaisons sur les bal snappées dans les centroides de batiments (sans doublon) et sans locaux

CREATE OR REPLACE VIEW rbal.v_liaison_snap as 
SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, * 
FROM(
SELECT ban_id, ad_code, geom FROM
(WITH segment_ban_bal AS
(SELECT ROW_NUMBER() OVER(ORDER BY fid) gid, *
FROM
(
SELECT 
  row_number() OVER (ORDER BY sub_query.ban_id) AS fid,
    sub_query.ban_id,
  sub_query.ad_code,
    ST_Makeline(sub_query.geom_ban, sub_query.geom_adresse) AS geom
  FROM(
  SELECT 
    ban.id as ban_id,
   rbal.ad_code,
    (ST_Dump(ban.geom)).geom as geom_ban, 
    rbal.gid as rbal_id,
     (ST_Dump(rbal.geom)).geom geom_adresse
  FROM 
    ban.hsn_point_2154 as ban,
    rbal.vm_bal_columns_gracethdview as rbal
  WHERE 
    ban.id = rbal.ad_ban_id AND nom_id IS NULL) AS sub_query)a)
SELECT * FROM segment_ban_bal
WHERE ad_code IN 
(SELECT ad_code FROM rbal.v_bal_snap_in_bat))a)a;


--- Schema : rbal
--- Table : segment_liaison_id_01
--- Traitement : Découpe les liaisons à chaque point bal et incrémente un nouvel id (gid)


--please add this function:
--https://github.com/Remi-C/PPPP_utilities/blob/master/postgis/rc_split_multi.sql

-- please create a universal sequence for unique id multipurpose
CREATE SEQUENCE segment_liaison_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1
  CYCLE;

-- lines (non st_unioned linestrings, with gist index) : linetable
-- points (non st_unioned points, with gist index) : pointtable

-- first, lines with cuts (pointtable)
DROP TABLE IF EXISTS rbal.segment_liaison_id_00;
CREATE TABLE rbal.segment_liaison_id_00 AS (
WITH points_intersecting_lines AS( 
   SELECT lines.liaison_id AS lines_id, lines.geom AS line_geom,  ST_Collect(points.geom) AS blade
   FROM 
   rbal.liaison_hsn_linestring_2154_snap AS lines, 
   rbal.bal_hsn_point_2154_old AS points
   WHERE st_dwithin(lines.geom, points.geom, 4) = true
   GROUP BY lines.liaison_id, lines.geom
)
SELECT lines_id, rc_Split_multi(line_geom, blade, 4)
FROM points_intersecting_lines
);
CREATE INDEX ON rbal.segment_liaison_id_00 USING gist(rc_split_multi);


-- then, segments cutted by points
DROP TABLE IF EXISTS rbal.segment_liaison_id_01;
CREATE TABLE rbal.segment_liaison_id_01 AS (
SELECT 
(ST_Dump(rc_split_multi)).geom AS geom,  nextval('segment_liaison_id'::regclass) AS gid  from rbal.segment_liaison_id_00
);
CREATE INDEX ON rbal.segment_liaison_id_01 USING gist(geom);