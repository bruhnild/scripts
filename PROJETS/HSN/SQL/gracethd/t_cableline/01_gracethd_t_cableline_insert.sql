-- ================================================
-- CONVERTION DE LA TABLE  avp.cable en LINESTRING
-- ================================================
-- DROP TABLE IF EXISTS avp.cable_linestring;
-- CREATE TABLE avp.cable_linestring
-- AS
-- (WITH dump AS (
-- SELECT 
-- 	id
-- 	, id_cable
-- 	, cb_capa
-- 	, cb_typelog
-- 	, (ST_DUMP(geom)).geom AS geom 
-- FROM avp.cable
-- ) 
-- SELECT
-- 	id
-- 	, id_cable
-- 	, cb_capa
-- 	, cb_typelog
-- 	, geom::geometry(Linestring,2154)
-- FROM dump);

-- ================================================
--- Schema : gracethd_metis
--- Table : t_cableline
--- Traitement : Initialise la table t_cableline
-- ================================================

TRUNCATE gracethd_metis.t_cableline CASCADE;
INSERT INTO gracethd_metis.t_cableline ( 
	cl_code
	, cl_cb_code
	, cl_long
	, cl_creadat
	, geom
)

SELECT
	concat('CL700', digt_6, digt_7, '00', to_char(gid, 'FM00000')) AS cl_code
	, concat('CB700', b.digt_6, b.digt_7, '00', to_char(gid, 'FM00000')) AS cl_cb_code -- jointure sur t_cable(cb_code)
	, ST_LENGTH(a.geom) AS cl_long
	, now() AS cl_creadat
	, a.geom
FROM 
	avp_n070gay.cable_linestring a 
	, psd_orange.zanro_hsn_polygon_2154 b
WHERE st_intersects(a.geom, b.geom);
