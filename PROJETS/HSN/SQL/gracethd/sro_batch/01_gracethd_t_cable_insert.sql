-- Schema : gracethd_metis
-- Table : t_cable
-- Traitement : Initialise la table t_cable avec avp_{n070gay}.cable_linestring

TRUNCATE gracethd_metis.t_cable CASCADE;

INSERT INTO gracethd_metis.t_cable ( 
	cb_code
	, cb_nd1
	, cb_nd2
	, cb_statut
	, cb_avct
	, cb_typephy
	, cb_typelog
	, cb_capafo
	, cb_creadat
)
(
	WITH cb_nd AS (
	SELECT 
		concat('CB700'
		, b.digt_6
		, b.digt_7
		, '00'
		, to_char(a.gid, 'FM00000')) AS cb_code --   /!\ ALTER TABLE :nro.cable_linestring ADD COLUMN gid SERIAL PRIMARY KEY;
		, cb_capa
	FROM :nro.cable_linestring a,psd_orange.zanro_hsn_polygon_2154 b
	WHERE st_contains(b.geom, a.geom)

	)
	SELECT 
	DISTINCT ON (b.cb_code) -- /!\ REGLES D'INGENIERIE A PRECISER (superposition des noeuds SRO/NRO/BT)
		b.cb_code
		, cb_nd1
		, cb_nd2 
		, 'AVP' as cb_statut
		, 'C' AS cb_avct --A créer (?)
		, 'C' AS cb_typephy			   
		, 'TR' AS cb_typelog
		, cb_capa::int AS cb_capafo
		, now() AS cb_creadat
	FROM cb_nd b 

	LEFT JOIN 
		(SELECT cb_nd1, cb_code
		FROM 
		(
			WITH cb_nd1 AS			  
			(
				SELECT  
					a.nd_code AS cb_nd1
					, concat('CB700', b.digt_6, b.digt_7, '00', to_char(c.gid, 'FM00000')) AS cb_code	
				FROM 
					gracethd_metis.t_noeud  a
						LEFT JOIN gracethd_metis.v_noeud d 
						ON a.nd_code = d.nd_code 
						AND d.nd_type = 'BT' 
						OR d.nd_type = 'ST'
					, psd_orange.zanro_hsn_polygon_2154 b 
					, :nro.cable_linestring c 
				WHERE st_intersects (a.geom, b.geom) 
				-- AND st_dwithin(a.geom, ST_StartPoint(c.geom), 5)
				AND st_equals(a.geom, ST_StartPoint(c.geom))
			)
			SELECT cb_nd1, cb_code	FROM cb_nd1)a)	a ON a.cb_code = b.cb_code

	LEFT JOIN 
		(SELECT cb_nd2, cb_code
		FROM 
		(
			WITH cb_nd2 AS													 
			(
				SELECT  
					a.nd_code AS cb_nd2
					, concat('CB700', b.digt_6, b.digt_7, '00', to_char(c.gid, 'FM00000')) AS cb_code	
				FROM 
					gracethd_metis.t_noeud  a
						LEFT JOIN gracethd_metis.v_noeud d 
						ON a.nd_code = d.nd_code 
						AND d.nd_type = 'BT' 
						OR d.nd_type = 'ST'
					, psd_orange.zanro_hsn_polygon_2154 b 
					, :nro.cable_linestring c 
				WHERE st_intersects (a.geom, b.geom) 
				-- AND st_dwithin(a.geom, ST_EndPoint(c.geom), 5)
				AND st_equals(a.geom, ST_EndPoint(c.geom))
			)
			SELECT cb_nd2, cb_code	FROM cb_nd2)c)	c ON c.cb_code = b.cb_code)