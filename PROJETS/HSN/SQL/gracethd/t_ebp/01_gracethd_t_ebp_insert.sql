--- Schema : gracethd_metis
--- Table : t_ebp
--- Traitement : Initialise la table t_ebp en insérant les valeurs de la table d'origine (avp.boite) dans t_ebp

TRUNCATE gracethd_metis.t_ebp CASCADE;

INSERT INTO gracethd_metis.t_ebp ( 
	bp_code
	,bp_pt_code
	,bp_lt_code
	,bp_avct
	,bp_typeph
	,bp_typelog
	,bp_rf_code
	,bp_ca_nb
	,bp_creadat
)

SELECT
	bp_code
	--,bp_pt_code -- REFERENCES t_ptech(pt_code)
	--,bp_lt_code -- REFERENCES t_ltech(lt_code)
	,'C'::VARCHAR AS bp_avct -- REFERENCES l_avancement(code)
	,'B006'::VARCHAR AS bp_typephy --  REFERENCES l_bp_type_phy (code)
	,'BPE'::VARCHAR AS bp_typelog-- NOT NULL REFERENCES l_bp_type_log (code)
	,'RF700010100001'::VARCHAR AS bp_rf_code -- REFERENCES t_reference (rf_code)
	,'0'::INTEGER AS bp_ca_nb
	,now() AS bp_creadat
FROM 
(
	SELECT
		bp_code

	FROM 
	(	
		SELECT 
		concat('BP700', digt_6, digt_7, digt_8, digt_9, to_char(g.id, 'FM00000')) bp_code
		FROM
		avp_n070gay.boite g
		, psd_orange.zasro_hsn_polygon_2154 s
		WHERE ST_CONTAINS(s.geom, g.geom)

		UNION ALL 
		
		SELECT 
		concat('BP700', digt_6, digt_7, '00', to_char(g.id, 'FM00000')) bp_code
		FROM
		avp_n070gay.boite g
		, psd_orange.zanro_hsn_polygon_2154 s
		WHERE ST_CONTAINS(s.geom, g.geom)
	) a
) b