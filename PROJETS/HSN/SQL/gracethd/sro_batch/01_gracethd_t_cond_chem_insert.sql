
TRUNCATE gracethd_metis.t_cond_chem CASCADE;

INSERT INTO gracethd_metis.t_cond_chem ( 
	dm_cd_code
	, dm_cm_code
	, dm_creadat 
)

SELECT
	concat('CD700', digt_6, digt_7, '00', to_char(pit.id, 'FM00000')) AS dm_cd_code -- REFERENCES t_conduite(cd_code),
	, cm_code AS dm_cm_code -- REFERENCES t_cheminement(cm_code),
    , now() AS dm_creadat
FROM 
	gracethd_metis.t_cheminement ch
	, orange.ft_arciti_hsn_linestring_2154 pit
	,psd_orange.zanro_hsn_polygon_2154 zn
WHERE st_intersects(zn.geom, ch.geom)
AND st_intersects(ch.geom, pit.geom)
AND zn.code_nro_def LIKE :code_nro
--AND zn.code_nro_def LIKE ':code_nro' -- /!\ ADAPTER EN FONCTION DU NRO EN COURS
;