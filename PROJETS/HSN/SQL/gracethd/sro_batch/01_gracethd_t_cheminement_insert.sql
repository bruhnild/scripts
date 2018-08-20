--- Schema : gracethd_metis
--- Table : t_cheminement
--- Traitement : Initialise la table t_cheminement à partir de orange.ft_arciti_hsn_linestring_2154

TRUNCATE gracethd_metis.t_cheminement CASCADE;

INSERT INTO gracethd_metis.t_cheminement ( 
	cm_code
	, cm_ndcode1
	, cm_ndcode2
	, cm_typ_imp
	, cm_mod_pos
	, cm_long
	, cm_creadat
	, geom
)

(
	WITH ch_nd AS (
	SELECT
		concat('CM700', digt_6, digt_7, '00', to_char(a.id, 'FM00000')) AS cm_code --cm_code VARCHAR(254) NOT NULL  ,
		, mode_pose AS cm_typ_imp --	cm_typ_imp VARCHAR(2)   REFERENCES l_implantation_type (code),
		, 'NC' AS cm_mod_pos --	Non communiqué (?),
		, ST_LENGTH(a.geom)::NUMERIC(8,2) AS cm_long
		, now() AS cm_creadat
		, a.geom
	FROM orange.ft_arciti_hsn_linestring_2154 a,psd_orange.zanro_hsn_polygon_2154 b
	WHERE st_intersects(b.geom, a.geom)

	)
	SELECT 
	b.cm_code
	, a.cm_ndcode1
	, c.cm_ndcode2
	, cm_typ_imp
	, cm_mod_pos
	, cm_long
	, cm_creadat
	, geom
	FROM ch_nd b 

	LEFT JOIN 
		(SELECT cm_ndcode1, cm_code
			FROM 				 
			(WITH cm_ndcode1 AS				  
			(WITH cm_ndcode AS
			(SELECT nd_code AS cm_ndcode1, geom
			FROM gracethd_metis.v_noeud
			WHERE nd_code_metier LIKE 'BP%' OR nd_code_metier LIKE 'ND%' )		
			SELECT  cm_ndcode1, a.geom	, concat (b.digt_6, b.digt_7, '00') as nro
			FROM cm_ndcode a, psd_orange.zanro_hsn_polygon_2154 b   
			WHERE st_intersects (a.geom, b.geom))
			SELECT cm_ndcode1, concat('CM700', nro, to_char(b.id, 'FM00000')) AS cm_code, a.geom
			FROM cm_ndcode1 a, orange.ft_arciti_hsn_linestring_2154 b
			WHERE st_equals(a.geom, ST_StartPoint(b.geom)))a)a ON a.cm_code = b.cm_code
							 
				 					 

	LEFT JOIN 
	(SELECT cm_ndcode2, cm_code
			FROM 				 
			(WITH cm_ndcode2 AS				  
			(WITH cm_ndcode AS
			(SELECT nd_code AS cm_ndcode2, geom
			FROM gracethd_metis.v_noeud
			WHERE nd_code_metier LIKE 'BP%' OR nd_code_metier LIKE 'ND%' )		
			SELECT  cm_ndcode2, a.geom	, concat (b.digt_6, b.digt_7, '00') as nro
			FROM cm_ndcode a, psd_orange.zanro_hsn_polygon_2154 b   
			WHERE st_intersects (a.geom, b.geom))
			SELECT cm_ndcode2, concat('CM700', nro, to_char(b.id, 'FM00000')) AS cm_code, a.geom
			FROM cm_ndcode2 a, orange.ft_arciti_hsn_linestring_2154 b
			WHERE st_equals(a.geom, ST_StartPoint(b.geom)))a)c ON c.cm_code = b.cm_code)
							 
	