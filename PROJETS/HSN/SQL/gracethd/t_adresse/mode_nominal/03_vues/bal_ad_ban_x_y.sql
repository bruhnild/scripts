CREATE OR REPLACE VIEW rbal.v_bal_ad_ban_x_y AS
SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, *
FROM
------------------------------------------------------
-- Tout ce qui n'a pas de ban
(
SELECT 
  hp.ad_code,
  NULL::float as ad_x_ban,
  NULL::float as ad_y_ban
FROM
  rbal.bal_hsn_point_2154 as hp
WHERE
  hp.ad_code NOT IN 
  
  
(SELECT ad_code FROM
(WITH ad_rep_ban AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	ad_ban_id, 
 	st_x(b.geom) as ad_x_ban,
    st_y(b.geom) as ad_y_ban
FROM rbal.bal_hsn_point_2154 a, ban.hsn_point_2154 b
WHERE a.ad_ban_id=b.id)
SELECT ad_code, ad_ban_id, ad_x_ban,ad_y_ban  FROM ad_rep_ban
WHERE ad_ban_id IS NOT NULL) a) 

UNION ALL 
------------------------------------------------------
-- Tout ce qui a une ban
SELECT ad_code, ad_x_ban, ad_y_ban FROM
(WITH ad_rep_ban AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	ad_ban_id, 
 	st_x(b.geom) as ad_x_ban,
    st_y(b.geom) as ad_y_ban
FROM rbal.bal_hsn_point_2154 a, ban.hsn_point_2154 b
WHERE a.ad_ban_id=b.id)
SELECT ad_code, ad_ban_id, ad_x_ban,ad_y_ban  FROM ad_rep_ban
WHERE ad_ban_id IS NOT NULL) a)a
