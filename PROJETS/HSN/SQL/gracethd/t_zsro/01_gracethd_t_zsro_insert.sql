--- Schema : gracethd_metis
--- Table : t_zsro
--- Traitement : Initialise la table t_zsro en insérant les valeurs de la table d'origine (psd_orange.zasro_hsn_polygon_2154) dans t_zsro

TRUNCATE gracethd_metis.t_zsro CASCADE;

INSERT INTO gracethd_metis.t_zsro ( 
	zs_code 
	, zs_nd_code 
	, zs_zn_code 
	, zs_r1_code
	, zs_r2_code 
	, zs_r3_code 
	, zs_capamax
	, zs_ad_code
	, zs_nblogmt
	, zs_geolsrc
	, zs_creadat
	, geom

)
SELECT
	concat('ZS700', a.digt_6, a.digt_7, a.digt_8, a.digt_9, to_char(a.id, 'FM00000')) as zs_code, 
	nd_code as zs_nd_code,
	concat('ZN700', b.digt_6, b.digt_7, '00', to_char(b.id, 'FM00000')) as zs_zn_code, 
	'DP70'::varchar as zs_r1_code,
	zanro as zs_r2_code, 	
	za_code_def as	zs_r3_code,	
	CASE WHEN nb_prise.nb_prises_sro <= 400 THEN 720 ELSE 1008 END zs_capamax,
	ad_code.st_ad_code as zs_ad_code,
	nb_prise.nb_prises_sro as zs_nblogmt,
	'PSD'::varchar as zs_geolsrc,
	now() as zs_creadat,													
	ST_MULTI( a.geom ) as geom
	FROM psd_orange.zasro_hsn_polygon_2154 a 
	LEFT JOIN psd_orange.zanro_hsn_polygon_2154 b on a.zanro = b.code_nro_def
	LEFT JOIN gracethd_metis.t_noeud c ON za_code_def=nd_r3_code
	LEFT JOIN (
		SELECT
			pt_code 
			, CASE WHEN log.nb_prises_sro IS NOT NULL THEN log.nb_prises_sro ELSE pt_nbel END AS nb_prises_sro
		FROM psd_orange.sro_hsn_point_2154 a
		LEFT JOIN 
		(
			SELECT
				nom_sro
				, count(nb_prises_totale) nb_prises_sro
			FROM gracethd_metis.t_adresse
			GROUP BY nom_sro
		) log ON log.nom_sro = a.pt_code
	) nb_prise ON a.za_code_def = nb_prise.pt_code
	LEFT JOIN (
	WITH sro AS (
		SELECT
			concat('ST700', digt_6, digt_7, digt_8, digt_9, to_char(id, 'FM00000')) as st_code 
			, concat('ND700', digt_6, digt_7, digt_8, digt_9, to_char(id, 'FM00000')) as st_nd_code
			, 'C'::varchar AS st_avct
			, 'ADR'::varchar AS st_typephy
			, 'SRO' AS st_typelog
			, now() AS st_creadat
			, geom
		FROM psd_orange.sro_hsn_point_2154
	)

	SELECT 
		sro.st_code 
		, sro.st_nd_code
		, sro.st_avct
		, sro.st_typephy
		, sro.st_typelog
		, c.pt_id
		, c.st_ad_code
		, sro.st_creadat
	FROM 
		sro 

	LEFT JOIN 

	(
		SELECT 
			st_code
			, pt_id
			, st_ad_code
		FROM 
			(WITH sro_st_code AS			 
				(SELECT concat('ST700', digt_6, digt_7, digt_8, digt_9, to_char(id, 'FM00000')) as st_code, pt_id
					FROM psd_orange.sro_hsn_point_2154)
				SELECT 
					a.st_code
					, a.pt_id
					, b.st_ad_code

				FROM sro_st_code a

				LEFT JOIN 			 

				(SELECT st_code, st_ad_code
					FROM								 
					(WITH tmp AS
					-- requête qui permet de prendre le premier point sro le plus proche de chaque adresse
						(
						SELECT concat('ST700', digt_6, digt_7, digt_8, digt_9, to_char(id, 'FM00000')) as st_code, t.ad_code, t.dist
						FROM psd_orange.sro_hsn_point_2154 as pt
						CROSS JOIN LATERAL
						-- requête qui permet de récupérer la distance la plus proche entre adresse et sro
						(SELECT adresse.ad_code AS ad_code, st_distance(adresse.geom, pt.geom) AS dist
						FROM gracethd_metis.t_adresse as adresse 
						ORDER BY pt.geom <-> adresse.geom
						LIMIT 1) AS t
						)
					SELECT st_code, ad_code as st_ad_code , dist 
					FROM tmp b
					WHERE dist <= 100)b
				)b ON a.st_code=b.st_code)a
	) 
	c ON c.st_code = sro.st_code
) ad_code ON ad_code.pt_id = a.za_code_def
;

-- En cas de truncate de t_noeud t_zsro se truncate aussi
-- Importer zsro en multipolygon

/*UPDATE gracethd_metis.t_zsro a
SET geom = null;
UPDATE gracethd_metis.t_zsro a
SET geom = b.geom
FROM gracethd_metis.zsro b 
WHERE a.zs_code= b.zs_code*/