--- Schema : gracethd_metis
--- Vue : v_noeud
--- Traitement : Crée la table v.noeud avec nro, sro, chambre ft et boites

-- drop view gracethd_metis.v_noeud;
CREATE OR REPLACE VIEW gracethd_metis.v_noeud AS 															
WITH vue_noeud AS								 
(	
	SELECT
		concat(b.digt_6, b.digt_7, '00') as sro
		, concat('PT700', b.digt_6, b.digt_7, '00', to_char(a.gid, 'FM00000')) as pt_code 
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
		concat(b.digt_6, b.digt_7, '00') as sro
		, concat('BT700', b.digt_6, b.digt_7, '00', to_char(a.id, 'FM00000')) as pt_code
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
	concat('ND700', sro, to_char(ROW_NUMBER() OVER (PARTITION BY sro ) + 13, 'FM00000')) as nd_code
	, pt_code	
	, nd_codeext
    , nd_type
    , nd_r1_code
    , nd_r2_code	
	, nd_r3_code
	, nd_geolsrc	
	, nd_creadat	
	, geom							 
FROM vue_noeud

