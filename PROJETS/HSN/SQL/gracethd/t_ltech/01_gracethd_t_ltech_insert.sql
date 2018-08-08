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
	, lt_etat
	, lt_creadat
)
SELECT
	lt_code
	-- , AS lt_etiquet -- VARCHAR(20)   
	, lt_st_code
	, 'OR700000000000' AS lt_prop
	, 'OR700000000000' AS lt_gest
	, 'OR700000000000' AS lt_user
	, 'AVP' AS lt_statut
	, 'NC' lt_etat-- VARCHAR(3) NOT NULL  REFERENCES l_etat_type (code),
	, now() AS lt_creadat
FROM 
(	
	SELECT 
	concat('LT700', digt_6, digt_7, digt_8, digt_9, to_char(id, 'FM00000')) lt_code
	, concat('ST700', digt_6, digt_7, digt_8, digt_9, to_char(id, 'FM00000')) AS lt_st_code
	FROM
	psd_orange.sro_hsn_point_2154
	
	UNION ALL 
	
	SELECT 
	concat('LT700', digt_6, digt_7, '00', to_char(id, 'FM00000')) lt_code
	, concat('ST700', digt_6, digt_7, '00', to_char(id, 'FM00000')) AS lt_st_code
	FROM
	psd_orange.nro_hsn_phase1_point_2154

UNION ALL 

	SELECT 
	concat('BP700', digt_6, digt_7, digt_8, digt_9, to_char(g.id, 'FM00000')) bp_code
	FROM
	avp_n070gay.boite g
	, psd_orange.zasro_hsn_polygon_2154 s
	WHERE ST_CONTAINS(s.geom, g.geom)
) a