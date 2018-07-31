DROP TABLE IF EXISTS gracethd_metis.matrice;
CREATE TABLE gracethd_metis.matrice AS
SELECT * FROM 

(SELECT inc FROM
(WITH incrementation AS
(SELECT 
	generate_series AS inc
FROM generate_series(1,99999))
SELECT to_char(inc, 'FM00000')as inc FROM incrementation)a)a,
		 
((SELECT 
 (concat(a.digt_6, a.digt_7, a.digt_8, a.digt_9) ) as sro
 	FROM psd_orange.ref_code_zasro a)
 UNION ALL
 (SELECT nro FROM 
 (WITH nro AS
 (SELECT 
 (concat(a.digt_6, a.digt_7,'00') ) as nro
 	FROM psd_orange.ref_code_zasro a)
SELECT DISTINCT ON (nro)nro FROM nro)a))  b
ORDER BY sro, inc;

DROP INDEX IF EXISTS sro_idx; 
CREATE INDEX sro_idx ON gracethd_metis.matrice(sro); 
 

 
WITH  existant as (
				SELECT 
				  substring(a.st_code from 6 for 4) sro_existant,
	  			  substring(a.st_code from 10 for 5) inc_existant
				FROM gracethd_metis.t_sitetech a
			)
			SELECT sro_existant, 
 			inc_existant, 
            CASE WHEN matrice.sro = sro_existant AND matrice.inc=existant.inc_existant THEN 1 END
			FROM existant
            LEFT JOIN gracethd_metis.matrice matrice ON matrice.sro = existant.sro_existant AND matrice.inc=existant.inc_existant

  
DROP SEQUENCE IF EXISTS gracethd_metis.t_noeud_incrementation_nd_code;
CREATE SEQUENCE gracethd_metis.t_noeud_incrementation_nd_code
  INCREMENT 1
  MINVALUE 00000
  MAXVALUE 99999
  START 1
  CACHE 1;
ALTER TABLE gracethd_metis.t_noeud OWNER TO postgres;

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
    nd_code,
	nb_type,	
	r1_code,
	r2_code,
	r3_code,
	r4_code,
	nd_geolsrc,		
	nd_creadat,
	geom
FROM 
(WITH vue_metier AS
	(SELECT
        concat(digt_6, digt_7, '00') as sro
		,'ST' as nb_type
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
    	concat(digt_6, digt_7, digt_8, digt_9) as sro
		,'ST' as nb_type
		, 'DP70' as r1_code
		, zanro as r2_code
		, pt_code as r3_code
		, '' as r4_code
		,'PSD'::varchar as nd_geolsrc
		, now() as nd_creadat
		, geom
	FROM psd_orange.sro_hsn_point_2154
  
  UNION ALL
  
  	SELECT
  		concat(digt_6, digt_7, digt_8, digt_9) as sro
		,'SF' as nb_type
		, 'DP70' as r1_code
		, substring(nom_sro from 1 for 7)as r2_code
		, nom_sro as r3_code
		, '' as r4_code
		,'PSD'::varchar as nd_geolsrc
		, now() as nd_creadat
		, geom
	FROM rbal.bal_hsn_point_2154 a
    LEFT JOIN psd_orange.ref_code_zasro b ON a.nom_sro=b.code_sro_definitif)
    SELECT 
	concat('ND700', sro, to_char(nextval('gracethd_metis.t_noeud_incrementation_nd_code'), 'FM00000')) as nd_code,
	nb_type,	
	r1_code,
	r2_code,
	r3_code,
	r4_code,
	nd_geolsrc,		
	nd_creadat,
	geom
	FROM  vue_metier)a;
		
  

  
CREATE OR REPLACE VIEW gracethd_metis.v_noeud AS
SELECT 
    nd_code,
	nb_type,	
	r1_code,
	r2_code,
	r3_code,
	r4_code,
	nd_geolsrc,		
	nd_creadat,
	geom
FROM 
(WITH vue_metier AS
	(SELECT
        concat(digt_6, digt_7, '00') as sro
		,'ST' as nb_type
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
    	concat(digt_6, digt_7, digt_8, digt_9) as sro
		,'ST' as nb_type
		, 'DP70' as r1_code
		, zanro as r2_code
		, pt_code as r3_code
		, '' as r4_code
		,'PSD'::varchar as nd_geolsrc
		, now() as nd_creadat
		, geom
	FROM psd_orange.sro_hsn_point_2154
  
  UNION ALL
  
  	SELECT
  		concat(digt_6, digt_7, digt_8, digt_9) as sro
		,'SF' as nb_type
		, 'DP70' as r1_code
		, substring(nom_sro from 1 for 7)as r2_code
		, nom_sro as r3_code
		, '' as r4_code
		,'PSD'::varchar as nd_geolsrc
		, now() as nd_creadat
		, geom
	FROM rbal.bal_hsn_point_2154 a
    LEFT JOIN psd_orange.ref_code_zasro b ON a.nom_sro=b.code_sro_definitif)
    SELECT 
	concat('ND700', sro, to_char(nextval('gracethd_metis.t_noeud_incrementation_nd_code'), 'FM00000')) as nd_code,
	nb_type,	
	r1_code,
	r2_code,
	r3_code,
	r4_code,
	nd_geolsrc,		
	nd_creadat,
	geom
	FROM  vue_metier)a
		
  

  