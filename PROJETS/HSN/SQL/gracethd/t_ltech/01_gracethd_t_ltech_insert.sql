--- Schema : gracethd_metis
--- Table : t_ltech
--- Traitement : Initialise la table t_ltech à partir de ??

TRUNCATE gracethd_metis.t_ltech CASCADE;

INSERT INTO gracethd_metis.t_ltech ( 
	lt_code
	-- , lt_etiquet
	, lt_st_code
	, lt_prop
	, lt_gest
	, lt_user
	, lt_statut
	, lt_creadat
)
SELECT
	concat('LT700', digt_6, digt_7, digt_8, digt_9, to_char(id, 'FM00000')) AS lt_code
	-- , AS lt_etiquet -- VARCHAR(20)   
	, concat('ST700', digt_6, digt_7, digt_8, digt_9, to_char(id, 'FM00000')) AS lt_st_code
	, 'OR700000000000' AS lt_prop
	, 'OR700000000000' AS lt_gest
	, 'OR700000000000' AS lt_user
	, 'AVP' AS lt_statut
	 , now() AS lt_creadat
FROM 
(	
	SELECT digt_6, digt_7, digt_8, digt_9, id FROM
	psd_orange.sro_hsn_point_2154
	
	UNION ALL 
	
	SELECT digt_6, digt_7, digt_8, digt_9, id FROM
	psd_orange.nro_hsn_phase1_point_2154
) a