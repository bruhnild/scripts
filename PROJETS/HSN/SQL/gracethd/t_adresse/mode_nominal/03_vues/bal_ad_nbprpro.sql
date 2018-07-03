CREATE OR REPLACE VIEW rbal.v_bal_ad_nbprpro AS
SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, *
FROM
-- ad_nbprpro = 0 par defaut
(
SELECT 
  hp.ad_code,
  0::int as ad_nbprpro
FROM
  rbal.bal_hsn_point_2154 as hp
WHERE
  hp.ad_code NOT IN 


(SELECT ad_code FROM 
(WITH ad_insee_postal_commune AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
 	nb_ftth  as ad_nbprpro
FROM rbal.bal_hsn_point_2154 a, rbal.v_ctrl_bal_ftth_ftte b
WHERE a.ad_code=b.ad_code)

SELECT ad_code, ad_nbprpro FROM ad_insee_postal_commune)a)
UNION ALL
-- nb_ftth = ad_nbprpro 
SELECT ad_code, ad_nbprpro FROM 
(WITH ad_nbprpro AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
 	nb_ftth  as ad_nbprpro
FROM rbal.bal_hsn_point_2154 a, rbal.v_ctrl_bal_ftth_ftte b
WHERE a.ad_code=b.ad_code)

SELECT ad_code, ad_nbprpro FROM ad_nbprpro)a)a;