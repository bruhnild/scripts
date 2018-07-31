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
	concat('BP700', digt_6, digt_7, digt_8, digt_9, to_char(id, 'FM00000')) AS bp_code
	,bp_pt_code -- REFERENCES t_ptech(pt_code)
	,bp_lt_code -- REFERENCES t_ltech(lt_code)
	,'C'::VARCHAR AS bp_avct -- REFERENCES l_avancement(code)
	,'B006'::VARCHAR AS bp_typephy --  REFERENCES l_bp_type_phy (code)
	,'BPE'::VARCHAR AS bp_typelog-- NOT NULL REFERENCES l_bp_type_log (code)
	,'RF700010100001'::VARCHAR AS bp_rf_code -- REFERENCES t_reference (rf_code)
	,'0'::INTEGER AS bp_ca_nb INTEGER   
	,now() AS bp_creadat
FROM avp.boite