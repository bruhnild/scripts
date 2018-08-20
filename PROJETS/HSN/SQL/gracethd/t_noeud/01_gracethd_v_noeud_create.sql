--- Schema : gracethd_metis
--- Vue : v_noeud
--- Traitement : Crée la table v.noeud avec nro, sro, chambre ft et boites

-- drop view gracethd_metis.v_noeud;


CREATE OR REPLACE VIEW gracethd_metis.v_noeud AS 															
WITH vue_noeud AS								 
(	
	SELECT
		concat(b.digt_6, b.digt_7, '00') as nro
		, concat('PT700', b.digt_6, b.digt_7, '00', to_char(a.gid, 'FM00000')) as nd_code_metier 
		, pt_codeext as nd_codeext
		, 'PT'::VARCHAR as nd_type
		, 'DP70' as nd_r1_code
		, b.zanro as nd_r2_code
		, b.za_code_def::VARCHAR as nd_r3_code
		,'PSD'::varchar as nd_geolsrc
		, now() as nd_creadat
		, a.geom
	FROM avp_n070gay.ft_chambre a ,  psd_orange.zasro_hsn_polygon_2154 b 
	WHERE ST_CONTAINS (b.geom, a.geom)

	UNION ALL

	SELECT
		concat(b.digt_6, b.digt_7, '00') as nro
		, concat('BP700', b.digt_6, b.digt_7, '00', to_char(a.id, 'FM00000')) as nd_code_metier
		, pt_codeext as nd_codeext
		, 'PT'::VARCHAR as nd_type
		, 'DP70' as nd_r1_code
		, b.zanro as nd_r2_code
		, b.za_code_def::VARCHAR as nd_r3_code
		,'PSD'::varchar as nd_geolsrc
		, now() as nd_creadat
		, a.geom
	FROM avp_n070gay.boite a,  psd_orange.zasro_hsn_polygon_2154 b 
    WHERE ST_CONTAINS (b.geom, a.geom)
)
					   
SELECT   
	concat('ND700', nro, to_char(ROW_NUMBER() OVER (PARTITION BY nro ) + 13, 'FM00000')) as nd_code
	, nd_code_metier	
	, nd_codeext
    , nd_type
    , nd_r1_code
    , nd_r2_code	
	, nd_r3_code
	, nd_geolsrc	
	, nd_creadat	
	, geom							 
FROM vue_noeud
								 
UNION ALL 								 
SELECT
		concat('ND700', digt_6, digt_7, '00', to_char(id, 'FM00000')) AS nd_code 
		, concat('ND700', digt_6, digt_7, '00', to_char(id, 'FM00000')) AS nd_code_metier	
		, NULL::VARCHAR AS nd_codeext											  
		, 'ST' as nd_type
		, 'DP70' as r1_code
		, code_nro_ref as r2_code
		, '' as r3_code
		,'PSD'::varchar as nd_geolsrc
		, now() as nd_creadat
		, geom
	FROM psd_orange.nro_hsn_phase1_point_2154 

	UNION ALL

	SELECT
		concat('ND700', digt_6, digt_7, digt_8, digt_9, to_char(id, 'FM00000')) as nd_code
		, concat('ND700', digt_6, digt_7, digt_8, digt_9, to_char(id, 'FM00000')) as nd_code_metier	
		, NULL::VARCHAR AS nd_codeext														  
		, 'ST' as nb_type
		, 'DP70' as r1_code
		, zanro as r2_code
		, pt_code as r3_code
		,'PSD'::varchar as nd_geolsrc
		, now() as nd_creadat
		, geom
	FROM psd_orange.sro_hsn_point_2154;

	