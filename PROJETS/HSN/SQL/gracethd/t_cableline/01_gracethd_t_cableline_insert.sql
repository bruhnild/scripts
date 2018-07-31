--- Schema : gracethd_metis
--- Table : t_cableline
--- Traitement : Initialise la table t_cableline en insérant les valeurs de la table d'origine (gracethd_metis.t_cable) dans t_cableline

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


TRUNCATE gracethd_metis.t_cableline CASCADE;

INSERT INTO gracethd_metis.t_cableline ( 
	cl_code
	, cl_cb_code
	, cl_long
	, cl_creadat
	, geom
)

SELECT
	-- concat('CL700', digt_6, digt_7, digt_8, digt_9, to_char(id, 'FM00000')) AS cl_code
	
	-- , AS cl_cb_code -- jointure sur t_cable(cb_code)
	ST_LENGTH(geom) AS cl_long
	, now() AS cl_creadat
	, geom

FROM avp.cable_linestring
