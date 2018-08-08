--- Schema : gracethd_metis
--- Table : t_znro
--- Traitement : Initialise la table t_znro en insérant les valeurs de la table d'origine (psd_orange.zanro_hsn_polygon_2154) dans t_znro

TRUNCATE gracethd_metis.t_znro CASCADE;

INSERT INTO gracethd_metis.t_znro ( 
	zn_code
	, zn_nd_code
	, zn_r1_code
	, zn_r2_code
	, zn_nroref
	, zn_geolsrc
	, zn_creadat
	, geom

)

SELECT 
    zn_code, 
	zn_nd_code,
	zs_r1_code,
	zs_r2_code, 
	zn_nroref, 
	zn_geolsrc,
	zs_creadat,													
	geom
FROM 
(WITH nro AS
(SELECT
	concat('ZN700', a.digt_6, a.digt_7, '00', to_char(a.id, 'FM00000')) as zn_code, 
	nd_code as zn_nd_code,
	'DP70'::varchar as zs_r1_code,
	code_nro_def as zs_r2_code, 
	code_nro_def as zn_nroref, 
	'PSD'::varchar as zn_geolsrc,
	now() as zs_creadat,													
	ST_MULTI( a.geom ) as geom
	FROM psd_orange.zanro_hsn_polygon_2154 a 
	RIGHT JOIN gracethd_metis.t_noeud c ON code_nro_def=nd_r2_code)
SELECT 
	DISTINCT ON (zn_code) zn_code, 
	zn_nd_code,
	zs_r1_code,
	zs_r2_code, 
	zn_nroref, 
	zn_geolsrc,
	zs_creadat,													
	geom

FROM nro)a
WHERE geom IS NOT NULL;

-- En cas de truncate de t_noeud t_znro se truncate aussi
--Importer znro en multipolygon

/*UPDATE gracethd_metis.t_znro a
SET geom = null;
UPDATE gracethd_metis.t_znro a
SET geom = b.geom
FROM gracethd_metis.znro b 
WHERE a.zn_code= b.zn_code;*/
