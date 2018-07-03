CREATE OR REPLACE VIEW rbal.v_bal_ad_fantoir AS
SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, *
FROM
(

--------------------------------------------
-- Tout ce qui n'a pas de ad_fantoir
SELECT 
  hp.ad_code,
  NULL::varchar as ad_fantoir
  FROM
  rbal.bal_hsn_point_2154 as hp
WHERE
  hp.ad_code NOT IN
	
	
(SELECT ad_code FROM 
-- ad_fantoir
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

UNION ALL 

--------------------------------------------
-- Tout ce qui a un ad_fantoir
SELECT ad_code, ad_fantoir FROM 
-- ad_fantoir
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
WHERE id_fantoir IS NOT NULL)a)a