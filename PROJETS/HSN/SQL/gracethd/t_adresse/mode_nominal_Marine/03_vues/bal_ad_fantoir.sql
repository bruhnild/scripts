CREATE OR REPLACE VIEW rbal.v_bal_ad_fantoir AS
SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, *
FROM
(
/*
-------------------------------------------------------------------------------------
TOUT CE QUI N'A PAS D'AD FANTOIR
-------------------------------------------------------------------------------------
*/

SELECT 
  hp.ad_code,
  NULL::varchar as ad_fantoir
  FROM
  rbal.bal_hsn_point_2154 as hp
WHERE
  hp.ad_code NOT IN
  
  
(SELECT ad_code FROM
(WITH ad_fantoir AS
((SELECT ad_code, ad_fantoir FROM 

(WITH ad_ban_id_liaison AS
(SELECT 
  DISTINCT ON (ad_code) a.ad_code,
  b.id_ban as ad_ban_id
FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.1) )
SELECT ad_code, ad_ban_id,id_fantoir as ad_fantoir FROM ad_ban_id_liaison

LEFT JOIN 

(SELECT id_fantoir, id FROM
(WITH ad_fantoir_ban AS
(SELECT 
  id_fantoir,
    id
FROM ban.hsn_point_2154 b
)
SELECT id_fantoir , id FROM ad_fantoir_ban)a)ad_fantoir_ban ON ad_fantoir_ban.id=ad_ban_id_liaison.ad_ban_id
WHERE id_fantoir IS NOT NULL)a)
            
-----------------AD FANTOIR AVEC GEO FONCIER (SANS BAN) 
UNION ALL
-----------------AD FANTOIR AVEC GEO FONCIER (SANS BAN) 
(SELECT ad_code, ad_fantoir FROM
(WITH ad_fantoir_geofoncier AS
(SELECT 
  DISTINCT ON (a.ad_code) a.ad_code,
 b.geo_batiment,
 b.fant_voie_majic,
 b.ccoriv as ad_fantoir,
 b.ad_nomvoie,
 b.typvoi
  FROM rbal.bal_hsn_point_2154 a, pci70_majic_analyses.batiment_parcelle_hsn_polygon_2154 b
  WHERE ST_CONTAINS(b.geom, a.geom) AND a.ad_code NOT IN 
            
(SELECT ad_code FROM
(WITH ad_fantoir_ban AS
(SELECT ad_code, ad_fantoir FROM 

(WITH ad_ban_id_liaison AS
(SELECT 
  DISTINCT ON (ad_code) a.ad_code,
  b.id_ban as ad_ban_id
FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.1) )
SELECT ad_code, ad_ban_id,id_fantoir as ad_fantoir FROM ad_ban_id_liaison

LEFT JOIN 

(SELECT id_fantoir, id FROM
(WITH ad_fantoir_ban AS
(SELECT 
  id_fantoir,
    id
FROM ban.hsn_point_2154 b
)
SELECT id_fantoir , id FROM ad_fantoir_ban)a)ad_fantoir_ban ON ad_fantoir_ban.id=ad_ban_id_liaison.ad_ban_id
WHERE id_fantoir IS NOT NULL)a)
SELECT * FROM ad_fantoir_ban )a))
SELECT * FROM ad_fantoir_geofoncier)a))
SELECT * FROM ad_fantoir)a)

/*
-------------------------------------------------------------------------------------
TOUT CE QUI A UN AD FANTOIR
-------------------------------------------------------------------------------------
*/

-----------------AD FANTOIR AVEC BAN
 UNION ALL
-----------------AD FANTOIR AVEC BAN
(SELECT ad_code, ad_fantoir FROM
(WITH ad_fantoir AS
((SELECT ad_code, ad_fantoir FROM 

(WITH ad_ban_id_liaison AS
(SELECT 
  DISTINCT ON (ad_code) a.ad_code,
  b.id_ban as ad_ban_id
FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.1) )
SELECT ad_code, ad_ban_id,id_fantoir as ad_fantoir FROM ad_ban_id_liaison

LEFT JOIN 

(SELECT id_fantoir, id FROM
(WITH ad_fantoir_ban AS
(SELECT 
  id_fantoir,
    id
FROM ban.hsn_point_2154 b
)
SELECT id_fantoir , id FROM ad_fantoir_ban)a)ad_fantoir_ban ON ad_fantoir_ban.id=ad_ban_id_liaison.ad_ban_id
WHERE id_fantoir IS NOT NULL)a)
            
-----------------AD FANTOIR AVEC GEO FONCIER (SANS BAN) 
UNION ALL
-----------------AD FANTOIR AVEC GEO FONCIER (SANS BAN) 
(SELECT ad_code, ad_fantoir FROM
(WITH ad_fantoir_geofoncier AS
(SELECT 
  DISTINCT ON (a.ad_code) a.ad_code,
 b.geo_batiment,
 b.fant_voie_majic,
 b.ccoriv as ad_fantoir,
 b.ad_nomvoie,
 b.typvoi
  FROM rbal.bal_hsn_point_2154 a, pci70_majic_analyses.batiment_parcelle_hsn_polygon_2154 b
  WHERE ST_CONTAINS(b.geom, a.geom) AND a.ad_code NOT IN 
            
(SELECT ad_code FROM
(WITH ad_fantoir_ban AS
(SELECT ad_code, ad_fantoir FROM 

(WITH ad_ban_id_liaison AS
(SELECT 
  DISTINCT ON (ad_code) a.ad_code,
  b.id_ban as ad_ban_id
FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.1) )
SELECT ad_code, ad_ban_id,id_fantoir as ad_fantoir FROM ad_ban_id_liaison

LEFT JOIN 

(SELECT id_fantoir, id FROM
(WITH ad_fantoir_ban AS
(SELECT 
  id_fantoir,
    id
FROM ban.hsn_point_2154 b
)
SELECT id_fantoir , id FROM ad_fantoir_ban)a)ad_fantoir_ban ON ad_fantoir_ban.id=ad_ban_id_liaison.ad_ban_id
WHERE id_fantoir IS NOT NULL)a)
SELECT * FROM ad_fantoir_ban )a))
SELECT * FROM ad_fantoir_geofoncier)a))
SELECT * FROM ad_fantoir)a))a;