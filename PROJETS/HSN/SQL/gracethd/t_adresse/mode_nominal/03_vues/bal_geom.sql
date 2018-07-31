/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 26/06/2018
Objet : Création de la vue v_bal_geom pour snapper les geom dans les centroides de batiments (sauf si plusieurs bals par batiment)
Modification : Nom : ///// - Date : date_de_modif - Motif/nature : //////

Sources: rbal.bal_hsn_point_2154 (geom)/ pci70_edigeo_majic.geo_batiment (centroide geom)
-------------------------------------------------------------------------------------
*/



CREATE OR REPLACE VIEW rbal.v_bal_geom AS
SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, * 
FROM(
/*
-------------------------------------------------------------------------------------
TOUTES LES BALS QUI NE SONT PAS DANS UN BATIMENT
-------------------------------------------------------------------------------------
*/
SELECT 
  hp.ad_code,
  hp.geom
FROM
  rbal.bal_hsn_point_2154 as hp
WHERE
  hp.ad_code NOT IN 

(SELECT ad_code FROM 
(WITH st_snap_bal_in_bat AS
((SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, * 
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
SELECT * FROM geo_batiment)a))a))
SELECT * FROM st_snap_bal_in_bat)a)

UNION ALL
/*
-------------------------------------------------------------------------------------
TOUTES LES BALS QUI SONT DANS UN BATIMENT
-------------------------------------------------------------------------------------
*/
SELECT ad_code, geom FROM 
(WITH st_snap_bal_in_bat AS
((SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, * 
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
SELECT * FROM geo_batiment)a))a))
SELECT * FROM st_snap_bal_in_bat)a)a;
