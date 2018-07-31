--- Schema : gracethd_metis
--- Table : t_noeud
--- Traitement : Initialise la table t_noeud en insérant les valeurs des tables d'origine (psd_orange.nro_hsn_phase1_point_2154/sro_hsn_point_2154) dans t_noeud


/*TRUNCATE gracethd_metis.t_noeud CASCADE;

INSERT INTO gracethd_metis.t_noeud ( 
	nd_code
	, nd_type
	, nd_r1_code
	, nd_r2_code
	, nd_r3_code
	, nd_r4_code
	, nd_geolsrc
	, nd_creadat
	, geom
	)

	SELECT
		concat('ND700', digt_6, digt_7, '00', to_char(id, 'FM00000')) as nd_code 
		, 'ST' as nb_type
		, 'DP70' as r1_code
		, code_nro_ref as r2_code
		, '' as r3_code
		, '' as r4_code
		,'PSD'::varchar as nd_geolsrc
		, now() as nd_creadat
		, geom
	FROM psd_orange.nro_hsn_phase1_point_2154 

	UNION ALL

	SELECT
	concat('ND700', digt_6, digt_7, digt_8, digt_9, to_char(id, 'FM00000')) as nd_code
		, 'ST' as nb_type
		, 'DP70' as r1_code
		, zanro as r2_code
		, pt_code as r3_code
		, '' as r4_code
		,'PSD'::varchar as nd_geolsrc
		, now() as nd_creadat
		, geom
	FROM psd_orange.sro_hsn_point_2154;
*/


/*
INSERT INTO gracethd_metis.t_noeud ( 
	nd_code
	, nd_type
	, nd_r1_code
	, nd_r2_code
	, nd_r3_code
	, nd_geolsrc
	, nd_creadat
	, geom
	)													
															
	WITH vue_metis AS								 
(	SELECT
		concat(b.digt_6, b.digt_7, '00') as sro
		, 'PT' as nb_type
		, 'DP70' as r1_code
		, code_nro_def as r2_code
		, '' as r3_code
		,'PSD'::varchar as nd_geolsrc
		, now() as nd_creadat
		, a.geom
	FROM orange.ft_chambre_hsn_point_2154 a ,  psd_orange.zanro_hsn_polygon_2154 b 
    WHERE ST_CONTAINS (b.geom, a.geom)

	UNION ALL

	SELECT
		concat(b.digt_6, b.digt_7, '00') as sro
		, 'PT' as nb_type
		, 'DP70' as r1_code
		, code_nro_def as r2_code
 		, '' as r3_code
		,'PSD'::varchar as nd_geolsrc
		, now() as nd_creadat
		, a.geom
	FROM orange.ft_appui_hsn_point_2154 a ,  psd_orange.zanro_hsn_polygon_2154 b 
    WHERE ST_CONTAINS (b.geom, a.geom))
					   
SELECT   
	concat('ND700',sro , to_char(ROW_NUMBER() OVER (PARTITION BY sro )+ 13, 'FM00000')) as nd_code
    ,nb_type
    ,r1_code
    ,r2_code	
	,r3_code
	,nd_geolsrc	
	,nd_creadat	
	,geom							 
FROM vue_metis*/