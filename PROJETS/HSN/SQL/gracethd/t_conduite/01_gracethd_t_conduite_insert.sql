--- Schema : gracethd_metis
--- Table : t_conduite
--- Traitement : Initialise la table t_conduite en insérant les valeurs de la table d'origine (orange.ft_arciti_hsn_linestring_2154) dans t_conduite

TRUNCATE gracethd_metis.t_conduite CASCADE;

INSERT INTO gracethd_metis.t_conduite ( 
	cd_code 
	,cd_cd_code 
	,cd_prop
	,cd_gest 
	,cd_user 
	,cd_avct
	,cd_type
	,cd_dia_ext
	,cd_creadat 
)

SELECT
	concat('CB700', digt_6, digt_7, digt_8, digt_9, to_char(id, 'FM00000')) AS cd_code
	concat('CB700', digt_6, digt_7, digt_8, digt_9, to_char(id, 'FM00000')) AS cd_cd_code -- REFERENCES t_conduite (cd_code)
	,cd_prop -- REFERENCES t_organisme (or_code)
	,cd_prop VARCHAR(20) --  REFERENCES t_organisme (or_code),
	,cd_gest VARCHAR(20) --  REFERENCES t_organisme (or_code),
	,cd_user VARCHAR(20) --  REFERENCES t_organisme (or_code),
	,'C'::VARCHAR AS cd_avct-- REFERENCES l_avancement(code),
	,'NC'::VARCHAR AS cd_type -- REFERENCES l_conduite_type (code),
	,compositio AS cd_dia_ext 
	,now() AS cd_creadat 
FROM orange.ft_arciti_hsn_linestring_2154