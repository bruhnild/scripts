--- Schema : gracethd_metis
--- Table : t_cable_patch201
--- Traitement : Initialise la table t_cable_patch201 en insérant les valeurs de la table d'origine (avp.cable) dans t_cable_patch201

TRUNCATE gracethd_metis.t_cable_patch201 CASCADE;

INSERT INTO gracethd_metis.t_cable_patch201 ( 
	cb_code 
	,cb_bp1 
	,cb_ba1 
	,cb_bp2 
	,cb_ba2 
)

SELECT
	a.cl_cb_code AS cb_code
	, b.cb_bp1 -- REFERENCES t_ebp(bp_code)
	, d.cb_ba1 -- REFERENCES t_baie(ba_code)
	, c.cb_bp2 -- REFERENCES t_ebp(bp_code)
	, e.cb_ba2 -- REFERENCES t_baie(ba_code)

FROM gracethd_metis.t_cableline a

LEFT JOIN

(
SELECT  
	a.nd_code_metier AS cb_bp1
	, b.cl_cb_code AS cb_code	
FROM 
	gracethd_metis.v_noeud a						
	, gracethd_metis.t_cableline b
WHERE a.nd_code_metier LIKE 'BP%' 
AND st_equals(a.geom, ST_StartPoint(b.geom))
) b
ON a.cl_cb_code = b.cb_code

LEFT JOIN

(
	SELECT  
		a.nd_code_metier AS cb_bp2
		, b.cl_cb_code AS cb_code	
	FROM 
		gracethd_metis.v_noeud a						
		, gracethd_metis.t_cableline b
	WHERE a.nd_code_metier LIKE 'BP%' 
	AND st_equals(a.geom, ST_EndPoint(b.geom))
) c
ON a.cl_cb_code = c.cb_code

LEFT JOIN 

(
	SELECT 
		bp_code AS cb_ba1
		, cb_code
	FROM 
	(WITH bp_code1 AS
		(SELECT 
			concat('BA700', b.digt_6, b.digt_7, '00', to_char(a.id, 'FM00000')) as bp_code
			, a.geom
		FROM
			
			psd_orange.nro_hsn_phase1_point_2154 a
			, psd_orange.zasro_hsn_polygon_2154 b

		WHERE ST_INTERSECTS(b.geom, a.geom)) 
		SELECT 
			bp_code
			, b.cl_cb_code AS cb_code	
			, a.geom
		FROM 
			bp_code1 a
			, gracethd_metis.t_cableline b
		WHERE  st_equals(a.geom, ST_StartPoint(b.geom))) d
) d
ON d.cb_code= a.cl_cb_code

LEFT JOIN 

(
	SELECT 
		bp_code AS cb_ba2
		, cb_code
	FROM 
	(
	WITH bp_code2 AS
		(SELECT 
			concat('BA700', b.digt_6, b.digt_7, b.digt_8, b.digt_9, to_char(a.id, 'FM00000')) as bp_code
			, a.geom
		FROM
			
			psd_orange.sro_hsn_point_2154 a
			, psd_orange.zasro_hsn_polygon_2154 b
		WHERE ST_INTERSECTS(b.geom, a.geom)) 
		SELECT 
			bp_code
			, b.cl_cb_code AS cb_code	
			, a.geom
		FROM 
			bp_code2 a
			, gracethd_metis.t_cableline b
		WHERE  st_equals(a.geom, ST_EndPoint(b.geom))) e
) e
ON e.cb_code= a.cl_cb_code