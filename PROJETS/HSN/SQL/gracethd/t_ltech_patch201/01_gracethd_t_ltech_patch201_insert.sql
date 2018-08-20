--- Schema : gracethd_metis
--- Table : t_ltech
--- Traitement : Initialise la table t_ltech à partir de ??
TRUNCATE gracethd_metis.t_ltech_patch201 CASCADE;

INSERT INTO gracethd_metis.t_ltech_patch201 ( 
	lt_code -- VARCHAR(254) NOT NULL REFERENCES t_ltech(lt_code),
)

SELECT
	lt_code

FROM 
(	
	SELECT 
	concat('LT700', digt_6, digt_7, digt_8, digt_9, to_char(id, 'FM00000')) lt_code
	FROM
	psd_orange.sro_hsn_point_2154
	
	UNION ALL 
	
	SELECT 
	concat('LT700', digt_6, digt_7, '00', to_char(id, 'FM00000')) lt_code
	FROM
	psd_orange.nro_hsn_phase1_point_2154

UNION ALL 

	SELECT 
	concat('LT700', concat(b.digt_6, b.digt_7, '00'), to_char(ROW_NUMBER() OVER (PARTITION BY concat(b.digt_6, b.digt_7, '00') ) + 13, 'FM00000')) as lt_code														  
	FROM
	avp_n070gay.boite a
	, psd_orange.zasro_hsn_polygon_2154 b
	WHERE ST_CONTAINS(b.geom, a.geom)
) a;