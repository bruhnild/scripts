--- Schema : gracethd_metis
--- Table : t_zpbo
--- Traitement : Initialise la table t_zpbo en insérant les valeurs des tables d'origine (psd_orange.nro_hsn_phase1_point_2154/sro_hsn_point_2154) dans t_zpbo


TRUNCATE gracethd_metis.t_zpbo CASCADE;

INSERT INTO gracethd_metis.t_zpbo ( 
	zp_code
	,zp_nd_code
	,zp_zs_code
	,zp_creadat
	,geom
)

SELECT 
	concat('ZP700', digt_6, digt_7, digt_8, digt_9, to_char(id, 'FM00000')) as zp_code
	,zp_nd_code -- REFERENCES t_noeud (nd_code)
	,zp_zs_code -- REFERENCES t_zsro (zs_code)
	,now() AS zp_creadat
	,geom geometry(MultiPolygon,2154) 
FROM 
