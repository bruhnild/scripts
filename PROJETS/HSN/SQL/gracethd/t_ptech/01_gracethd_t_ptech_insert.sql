--- Schema : gracethd_metis
--- Table : t_ptech
--- Traitement : Initialise la table t_ptech à partir de orange.ft_chambre_hsn_point_2154/orange.ft_appui_hsn_point_2154/orange.gespot_hsn_point_2154

TRUNCATE gracethd_metis.t_ptech CASCADE;

INSERT INTO gracethd_metis.t_ptech ( 
	pt_code
	,pt_codeext
	,pt_nd_code 
	,pt_ad_code
	,pt_prop 
	,pt_gest 
	,pt_avct 
	,pt_typephy 
	,pt_typelog 
	,pt_rf_code 
	,pt_nature 
	,pt_secu 
	,pt_a_struc 
	,pt_a_haut 
	,pt_rotatio 
	,pt_creadat 
)
SELECT
	concat('PT700', digt_6, digt_7, digt_8, digt_9, to_char(id, 'FM00000')) AS pt_code
	,pt_codeext AS pt_codeext
	,pt_nd_code --  REFERENCES t_noeud (nd_code)
	,pt_ad_code --  REFERENCES t_adresse(ad_code)
	,'OR700000000001'::VARCHAR AS pt_prop -- REFERENCES t_organisme (or_code)
	,pt_gest -- REFERENCES t_organisme (or_code)
	,pt_avct -- REFERENCES l_avancement(code)
	,'C'::VARCHAR AS pt_typephy -- REFERENCES l_ptech_type_phy (code)
	,'I'::VARCHAR AS pt_typelog -- REFERENCES l_ptech_type_log (code)
	,'RF700010100001' AS pt_rf_code -- REFERENCES t_reference (rf_code)
	,ref_chambr::VARCHAR AS pt_nature --  REFERENCES l_ptech_nature (code)
	,0::BOOLEAN AS pt_secu 
	,now() AS pt_creadat 
FROM orange.ft_chambre_hsn_point_2154

