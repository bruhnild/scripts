--- Schema : gracethd_metis
--- Table : t_suf
--- Traitement : Initialise la table t_suf en insérant les valeurs de la table d'origine (psd_orange.zanro_hsn_polygon_2154) dans t_znro

TRUNCATE gracethd_metis.t_suf CASCADE;

INSERT INTO gracethd_metis.t_suf ( 
	 sf_code 
	,sf_nd_code
	,sf_ad_code
	,sf_zp_code
	,sf_type
	,sf_racco
	,sf_creadat

)

SELECT 
	concat('ZP700', digt_6, digt_7, digt_8, digt_9, to_char(id, 'FM00000')) as sf_code
	,sf_nd_code -- REFERENCES t_noeud (nd_code),
	,sf_ad_code -- REFERENCES t_adresse (ad_code),
	,sf_zp_code -- REFERENCES t_zpbo (zp_code),
	,sf_type -- REFERENCES l_suf_type (code) Voir Adresse pour pro/part
	,'PR'::VARCHAR AS sf_racco -- REFERENCES l_suf_racco(code),
	,sf_creadat 
FROM 
