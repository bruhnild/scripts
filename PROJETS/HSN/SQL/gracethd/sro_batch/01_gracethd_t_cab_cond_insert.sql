--- Schema : gracethd_metis
--- Table : t_cab_cond
--- Traitement : Initialise la table t_cab_cond

TRUNCATE gracethd_metis.t_cab_cond CASCADE;

INSERT INTO gracethd_metis.t_cab_cond ( 
	cc_cb_code 
    , cc_cd_code 
	, cc_creadat
)

SELECT
	cl_cb_code AS cc_cb_code --REFERENCES t_cable(cb_code)
	, concat('CD700', digt_6, digt_7, '00', to_char(pit.id, 'FM00000')) AS cc_cd_code -- REFERENCES t_conduite(cd_code)
    , now() AS cc_creadat
FROM 
	gracethd_metis.t_cableline cl
	, orange.ft_arciti_hsn_linestring_2154 pit
	,psd_orange.zanro_hsn_polygon_2154 zn
WHERE st_contains(zn.geom, cl.geom)
AND st_intersects(cl.geom, pit.geom)
;