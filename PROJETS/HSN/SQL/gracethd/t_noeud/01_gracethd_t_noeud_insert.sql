-- Schema : gracethd_metis
-- Table : t_noeud
-- Traitement : Initialise la table t_noeud en insérant les valeurs des tables d'origine (psd_orange.nro_hsn_phase1_point_2154/sro_hsn_point_2154) dans t_noeud


TRUNCATE gracethd_metis.t_noeud CASCADE;

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


-- Donnée issue de la table v_noeud (chambre et boite)
INSERT INTO gracethd_metis.t_noeud (  
	nd_code 
	, nd_codeext
	, nd_type
	, nd_r1_code 
	, nd_r2_code 
	, nd_r3_code
	, nd_geolsrc
	, nd_creadat
	, geom
)
	SELECT  
		nd_code
		, nd_codeext
		, nd_type
		, nd_r1_code
		, nd_r2_code
		, nd_r3_code
		, nd_geolsrc
		, nd_creadat
		, geom
	FROM gracethd_metis.v_noeud v;