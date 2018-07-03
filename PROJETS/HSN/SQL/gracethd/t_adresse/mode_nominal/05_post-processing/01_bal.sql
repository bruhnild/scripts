
--- Schema : rbal
--- Vue : v_bal_snap_in_bat
--- Traitement : Vue qui snap toutes les bals (sauf celles en doublon par bati) dans chaque batiment

CREATE OR REPLACE VIEW rbal.v_postprocess_bal_snap_in_bat AS
SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, * 
FROM(
SELECT 
ST_SNAP(a.geom, ST_POINTONSURFACE(b.geom),10) as geom, geo_batiment, ad_code
FROM rbal.bal_hsn_point_2154 a, pci70_edigeo_majic.geo_batiment b
WHERE ST_CONTAINS (b.geom, a.geom) AND  b.geo_batiment  IN 


(SELECT geo_batiment FROM 
(WITH geo_batiment AS
((SELECT 
  hp.geo_batiment,
  hp.geom
FROM
  pci70_edigeo_majic.geo_batiment as hp
WHERE
  hp.geo_batiment NOT IN 
  

(SELECT geo_batiment FROM
(WITH nb_ad_code_batiment AS
(
    SELECT 
      h.ad_code,
    p.geo_batiment
    FROM 
      pci70_edigeo_majic.geo_batiment as p,
      rbal.bal_hsn_point_2154 as h
    WHERE 
      ST_Intersects(h.geom,p.geom))
SELECT   COUNT(geo_batiment) AS nbr_doublon, geo_batiment
FROM     nb_ad_code_batiment
GROUP BY geo_batiment
HAVING   COUNT(*) > 1)a)))
SELECT * FROM geo_batiment)a))a;
