TRUNCATE gracethd_metis.t_baie CASCADE;

INSERT INTO gracethd_metis.t_baie ( 
	ba_code -- VARCHAR(254) NOT NULL
	, ba_lt_code -- VARCHAR(254) NOT NULL  REFERENCES t_ltech (lt_code),
	, ba_statut -- VARCHAR(3)   REFERENCES l_statut (code),
	, ba_rf_code -- VARCHAR(254)   REFERENCES t_reference (rf_code),
	, ba_type -- VARCHAR(10)   REFERENCES l_baie_type (code),
	, ba_creadat -- TIMESTAMP 
)

SELECT
	ba_code
	, lt_code AS ba_lt_code 
	, 'AVP' AS ba_statut
	, 'RF700010100001' AS ba_rf_code
	, 'BAIE' AS ba_type
	,now() AS ba_creadat 
FROM 
(
	SELECT
		concat('BA700', digt_6, digt_7, '00', to_char(id, 'FM00000')) as ba_code 
		, concat('LT700', digt_6, digt_7, '00', to_char(id, 'FM00000')) lt_code
	FROM psd_orange.nro_hsn_phase1_point_2154 
	
	UNION ALL

	SELECT
		concat('BA700', digt_6, digt_7, digt_8, digt_9, to_char(id, 'FM00000')) as st_code 
		, concat('LT700', digt_6, digt_7, digt_8, digt_9, to_char(id, 'FM00000')) lt_code
	FROM psd_orange.sro_hsn_point_2154
) gracieux