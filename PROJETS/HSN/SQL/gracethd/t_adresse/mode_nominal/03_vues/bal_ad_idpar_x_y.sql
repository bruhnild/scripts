CREATE OR REPLACE VIEW rbal.v_bal_ad_idpar_x_y AS
SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, *
FROM

----------------------------------------------------------
-- Tout ce qui n'a pas de parcelle
(
SELECT 
  hp.ad_code,
  NULL::varchar as ad_idpar,
  NULL::float as ad_x_parc,
  NULL::float as ad_y_parc
FROM
  rbal.bal_hsn_point_2154 as hp
WHERE
  hp.ad_code NOT IN 
  
  
(SELECT ad_code FROM
(WITH ad_id_par_x_y AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	
	geo_parcelle as ad_idpar,
	st_x((st_centroid(b.geom))) as ad_x_parc,
	st_y((st_centroid(b.geom))) as ad_y_parc
FROM rbal.bal_hsn_point_2154 a, pci70_edigeo_majic.geo_parcelle b
WHERE  ST_CONTAINS (b.geom, a.geom))
SELECT * FROM ad_id_par_x_y)a)

UNION ALL 
	
----------------------------------------------------------
-- Tout ce qui a une parcelle

SELECT ad_code, ad_idpar, ad_x_parc, ad_y_parc FROM
(WITH ad_id_par_x_y AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	
	geo_parcelle as ad_idpar,
	st_x((st_centroid(b.geom))) as ad_x_parc,
	st_y((st_centroid(b.geom))) as ad_y_parc
FROM rbal.bal_hsn_point_2154 a, pci70_edigeo_majic.geo_parcelle b
WHERE  ST_CONTAINS (b.geom, a.geom))
SELECT * FROM ad_id_par_x_y)a)a
