--- Schema : gracethd_metis
--- Table : t_sitetech
--- Traitement : Initialise la table t_sitetech en insérant les valeurs des tables d'origine (psd_orange.nro_hsn_phase1_point_2154/sro_hsn_point_2154) dans t_sitetech


TRUNCATE gracethd_metis.t_sitetech CASCADE;

INSERT INTO gracethd_metis.t_sitetech ( 
	st_code
	, st_nd_code
	, st_prop
	, st_gest
	, st_user
	, st_statut
	, st_avct
	, st_typephy
	, st_typelog
	, st_ad_code
	, st_creadat
)

SELECT 
	st_code
	, st_nd_code
	, 'OR700000000000' as st_prop
	, 'OR700000000000' as st_gest
	, 'OR700000000000' as st_user
	, 'AVP' st_statut
	, st_avct
	, st_typephy
	, st_typelog
	, st_ad_code
	, st_creadat
FROM 
(
	(
	WITH nro AS (
		SELECT
			concat('ST700', digt_6, digt_7, '00', to_char(id, 'FM00000')) as st_code 
			, concat('ND700', digt_6, digt_7, '00', to_char(id, 'FM00000')) as st_nd_code
			, 'C'::varchar AS st_avct
			, 'SHE'::varchar AS st_typephy
			, 'NRO' AS st_typelog
			-- , AS st_ad_code
			, now() AS st_creadat
			, geom
		FROM psd_orange.nro_hsn_phase1_point_2154 
	)

	SELECT 
		nro.st_code 
		, nro.st_nd_code
		, nro.st_avct
		, nro.st_typephy
		, nro.st_typelog
		, c.st_ad_code
		, nro.st_creadat
	FROM 
		nro 
	LEFT JOIN 
	(
		SELECT 
			st_code
			, st_ad_code
		FROM 
		(WITH nro_st_code AS (
			SELECT 
				concat('ST700', digt_6, digt_7, digt_8, digt_9, to_char(id, 'FM00000')) as st_code
			FROM psd_orange.nro_hsn_phase1_point_2154
			) 
			SELECT 
				a.st_code
				, b.st_ad_code  	
			FROM nro_st_code a
		
		LEFT JOIN 			 

		(SELECT 
			st_code
			, st_ad_code
		FROM								 
		(WITH tmp AS
		-- requête qui permet de prendre le premier point nro le plus proche de chaque adresse
		(
		SELECT 
			concat('ST700', digt_6, digt_7, '00', to_char(id, 'FM00000')) as st_code
			, t.ad_code
			, t.dist
		FROM psd_orange.nro_hsn_phase1_point_2154 as pt
		CROSS JOIN LATERAL
		-- requête qui permet de récupérer la distance la plus proche entre adresse et nro
		(SELECT adresse.ad_code AS ad_code, st_distance(adresse.geom, pt.geom) AS dist
		FROM gracethd_metis.t_adresse as adresse 
		ORDER BY pt.geom <-> adresse.geom
		LIMIT 1) AS t
		)

		SELECT st_code, ad_code as st_ad_code , dist 
		FROM tmp b
		WHERE dist <= 100)a
		)b ON b.st_code=a.st_code)a
	)c ON c.st_code = nro.st_code
)

	UNION ALL

(
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
		, c.st_ad_code
		, sro.st_creadat
	FROM 
		sro 

	LEFT JOIN 

	(
		SELECT 
			st_code
			, st_ad_code
		FROM 
			(WITH sro_st_code AS			 
				(SELECT concat('ST700', digt_6, digt_7, digt_8, digt_9, to_char(id, 'FM00000')) as st_code
					FROM psd_orange.sro_hsn_point_2154)
				SELECT 
					a.st_code
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
)

UNION ALL 


(
	WITH boite AS (
		SELECT
		    concat('ST700', concat(s.digt_6, s.digt_7, '00'), to_char(row_number() over (partition by concat(s.digt_6, s.digt_7, '00') ) + 13 , 'FM00000')) as st_code	
			, concat('ND700', digt_6, digt_7, '00', to_char(g.id, 'FM00000')) as st_nd_code
			, 'C'::varchar AS st_avct
			, 'ADR'::varchar AS st_typephy
			, 'NRO' AS st_typelog
			, now() AS st_creadat
			, g.geom
		FROM avp_n070gay.boite g, psd_orange.zasro_hsn_polygon_2154 s
		WHERE ST_CONTAINS(s.geom, g.geom)
	)

	SELECT 
	    boite.st_code
		, boite.st_nd_code
		, boite.st_avct
		, boite.st_typephy
		, boite.st_typelog
		, c.st_ad_code
		, boite.st_creadat
	FROM 
		boite 

	LEFT JOIN 

	(
		SELECT 
			st_code
			, st_ad_code
		FROM 
			(WITH boite_st_code AS			 
				(
					SELECT 
					    concat('ST700', concat(s.digt_6, s.digt_7, '00'), to_char(row_number() over (partition by concat(s.digt_6, s.digt_7, '00') ) + 13 , 'FM00000')) as st_code
					FROM avp_n070gay.boite g, psd_orange.zasro_hsn_polygon_2154 s
					WHERE ST_CONTAINS(s.geom, g.geom)
				)
				
				SELECT 
					a.st_code
					, b.st_ad_code

				FROM boite_st_code a

				LEFT JOIN 			 

				(SELECT 
					st_code
					, st_ad_code
				FROM								 
					(WITH tmp AS
					-- requête qui permet de prendre le premier point boitier le plus proche de chaque adresse
						(
						WITH boite_dist AS
						(SELECT 
						    concat('ST700', concat(s.digt_6, s.digt_7, '00'), to_char(row_number() over (partition by concat(s.digt_6, s.digt_7, '00') ) + 13 , 'FM00000')) as st_code
						    ,g.geom
					    FROM avp_n070gay.boite as g, psd_orange.zasro_hsn_polygon_2154 as s
					    WHERE ST_CONTAINS(s.geom, g.geom))
					    SELECT st_code, geom , t.ad_code, t.dist FROM boite_dist as pt
						CROSS JOIN LATERAL
						-- requête qui permet de récupérer la distance la plus proche entre adresse et boitier
							(
								SELECT adresse.ad_code AS ad_code, st_distance(adresse.geom, pt.geom) AS dist
								FROM gracethd_metis.t_adresse as adresse 
								ORDER BY pt.geom <-> adresse.geom
								LIMIT 1
							) AS t
						)
					SELECT st_code, ad_code as st_ad_code , dist 
					FROM tmp b
					WHERE dist <= 100)b
				)b ON a.st_code=b.st_code)a
	) 
	c ON c.st_code = boite.st_code
)
) gracieux
