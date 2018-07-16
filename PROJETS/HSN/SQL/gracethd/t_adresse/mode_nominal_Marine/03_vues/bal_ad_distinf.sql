CREATE OR REPLACE VIEW rbal.v_bal_ad_distinf AS
SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, *
FROM
(
SELECT 
  hp.ad_code,
  NULL::int as ad_distinf
  FROM
  rbal.bal_hsn_point_2154 as hp
WHERE
  hp.ad_code NOT IN

(SELECT ad_code FROM
(WITH bal_ad_distinf AS
(SELECT ad_code, ad_ban_id, ad_distinf FROM
(WITH ad_ban_id_liaison AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	a.ad_ban_id,
 	ST_LENGTH(b.geom)::int as ad_distinf
FROM rbal.bal_hsn_point_2154 a, rbal.racco_hsn_linestring_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.001) )
SELECT ad_code,ad_ban_id, ad_distinf FROM ad_ban_id_liaison)a)
SELECT * FROM bal_ad_distinf)a)

UNION ALL 


(SELECT ad_code, ad_distinf FROM
(WITH bal_ad_distinf AS
(SELECT ad_code, ad_ban_id, ad_distinf FROM
(WITH ad_ban_id_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code)a.ad_code,
	a.ad_ban_id,
 	ST_LENGTH(b.geom)::int as ad_distinf
FROM rbal.bal_hsn_point_2154 a, rbal.racco_hsn_linestring_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.001) )
SELECT ad_code,ad_ban_id, ad_distinf FROM ad_ban_id_liaison
)a)
SELECT * FROM bal_ad_distinf)a))a

