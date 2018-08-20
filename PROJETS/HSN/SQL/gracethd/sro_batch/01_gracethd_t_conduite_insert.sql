--- Schema : gracethd_metis
--- Table : t_conduite
--- Traitement : Initialise la table t_conduite en insérant les valeurs de la table d'origine (orange.ft_arciti_hsn_linestring_2154) dans t_conduite

TRUNCATE gracethd_metis.t_conduite CASCADE;

INSERT INTO gracethd_metis.t_conduite ( 
	cd_code 
	, cd_cd_code 
	, cd_prop
	, cd_gest
	, cd_user 
	, cd_statut
	, cd_avct
	, cd_type
	, cd_dia_ext
	, cd_creadat 
)

SELECT
	concat('CD700', digt_6, digt_7, '00', to_char(a.id, 'FM00000')) AS cd_code
	, concat('CD700', digt_6, digt_7, '00', to_char(a.id, 'FM00000')) AS cd_cd_code -- REFERENCES t_conduite (cd_code)
	, 'OR700000000002' cd_prop -- REFERENCES t_organisme (or_code)
	, 'OR700000000002' cd_gest --  REFERENCES t_organisme (or_code),
	, 'OR700000000002' cd_user --  REFERENCES t_organisme (or_code),
	, 'AVP' cd_statut
	, 'C'::VARCHAR AS cd_avct-- REFERENCES l_avancement(code),
	, 'NC'::VARCHAR AS cd_type -- REFERENCES l_conduite_type (code),
	, 1000 AS cd_dia_ext  -- /!\ Prendre l'attribut compositio dans orange.ft_arciti_hsn_linestring_2154 a
	, now() AS cd_creadat 
FROM orange.ft_arciti_hsn_linestring_2154 a
	, psd_orange.zanro_hsn_polygon_2154 b
WHERE st_intersects(a.geom, b.geom)
AND b.code_nro_def LIKE :code_nro
;