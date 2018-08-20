--- Schema : gracethd_metis
--- Table : t_ebp
--- Traitement : Initialise la table t_ebp en insérant les valeurs de la table d'origine (avp.boite) dans t_ebp
TRUNCATE gracethd_metis.t_ebp CASCADE ; 


INSERT INTO gracethd_metis.t_ebp ( 
	bp_code
	, bp_pt_code
	, bp_statut
	, bp_avct
	, bp_typelog
	, bp_rf_code		
	, bp_ca_nb
	, bp_creadat
)


WITH ebp AS
(SELECT
	bp_code
	--,bp_pt_code -- REFERENCES t_ptech(pt_code)
	--,bp_lt_code -- REFERENCES t_ltech(lt_code)
 	, 'AVP' AS bp_statut
	,'C'::VARCHAR AS bp_avct -- REFERENCES l_avancement(code)
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
		concat('BP700', b.digt_6, b.digt_7, '00', to_char(a.id, 'FM00000')) bp_code
		FROM
		:nro.boite a
		, psd_orange.zasro_hsn_polygon_2154 b
		WHERE ST_CONTAINS(b.geom, a.geom)


	) a
) b)
			   
SELECT 
bp_code
, pt_code AS bp_pt_code
, bp_statut
, bp_avct
, bp_typelog
, bp_rf_code		
, bp_ca_nb
, bp_creadat	
FROM ebp A
LEFT JOIN gracethd_metis.v_ptech b ON a.bp_code	= b.pt_code_metier   
LEFT JOIN gracethd_metis.v_ltech c ON a.bp_code	= c.lt_code_metier   ;