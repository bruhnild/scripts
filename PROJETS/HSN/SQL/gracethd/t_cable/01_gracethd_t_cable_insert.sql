TRUNCATE gracethd_metis.t_cable CASCADE;

INSERT INTO gracethd_metis.t_cable ( 
	cb_code
	,cb_nd1
	,cb_nd2
	,cb_statut
	,cb_avct
	,cb_typephy
	,cb_typelog
	,cb_capafo
	,cb_creadat
)
(
		WITH cb_nd AS
		(SELECT concat('CB700', digt_6, digt_7, '00', to_char(a.gid, 'FM00000')) AS cb_code, cb_capa
		FROM avp.cable_linestring a, psd_orange.zanro_hsn_polygon_2154 b)
		SELECT 
		b.cb_code 
		,cb_nd1
		,cb_nd2 
		,'AVP' as cb_statut
		,'C' AS cb_avct --A créer (?)
		,'C' AS cb_typephy			   
		, 'TR' AS cb_typelog
		, cb_capa::int AS cb_capafo
		, now() AS cb_creadat		   
		FROM cb_nd b 
		LEFT JOIN 
		(SELECT cb_nd1, cb_code
		FROM 
		(WITH cb_nd1 AS			  
		(SELECT 
		concat('BP700', digt_6, digt_7, '00', to_char(a.id, 'FM00000')) AS cb_nd1
		,concat('CB700', digt_6, digt_7, '00', to_char(c.gid, 'FM00000')) AS cb_code											  
		FROM avp.boite  a, psd_orange.zanro_hsn_polygon_2154 b , avp.cable_linestring c 
		WHERE ST_INTERSECTS (a.geom, b.geom) AND ST_Dwithin (a.geom, ST_StartPoint(c.geom), 0.5))
		SELECT cb_nd1, cb_code	FROM cb_nd1)a)	a ON a.cb_code = b.cb_code
		LEFT JOIN 
		(SELECT cb_nd2, cb_code
		FROM 
		(WITH cb_nd2 AS													 
		(SELECT  
		concat('BP700', digt_6, digt_7, '00', to_char(a.id, 'FM00000')) AS cb_nd2
		,concat('CB700', digt_6, digt_7, '00', to_char(c.gid, 'FM00000')) AS cb_code	
		FROM avp.boite  a, psd_orange.zanro_hsn_polygon_2154 b , avp.cable_linestring c 
		WHERE ST_INTERSECTS (a.geom, b.geom) AND ST_Dwithin (a.geom, ST_EndPoint(c.geom), 0.5))
		SELECT cb_nd2, cb_code	FROM cb_nd2)c)	c ON c.cb_code = b.cb_code)													 
						 
						