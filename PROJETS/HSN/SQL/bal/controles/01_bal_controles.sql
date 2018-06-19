--- Schema : psd_orange
--- Vue : v_locaux_hsn_sian_zanro_point_2154_duplicate
--- Traitement : Vue qui contient tous les doublons de locaux (superposition) par liaison

CREATE OR REPLACE VIEW psd_orange.v_locaux_hsn_sian_zanro_point_2154_duplicate AS
SELECT ROW_NUMBER() OVER(ORDER BY liaison_id) gid, * 
FROM(	
WITH locaux_liaison AS
(SELECT a.id, a.geom, a.objectid, b.liaison_id
FROM psd_orange.locaux_hsn_sian_zanro_point_2154 AS a, rbal.liaison_hsn_linestring_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.1))
SELECT   COUNT(liaison_id) AS nbr_doublon, liaison_id, geom
FROM     locaux_liaison
GROUP BY liaison_id, geom
HAVING   COUNT(*) > 1)a
;

--- Schema : rbal
--- Vue : v_bal_hsn_point_2154_out
--- Traitement : Vue qui contient toutes les bal en dehors des batiments (nb :référentiel cadastre edigeo, manque des communes)

CREATE OR REPLACE VIEW rbal.v_bal_hsn_point_2154_out AS
SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, * 
FROM(
SELECT 
  hp.ad_code,
  hp.geom
FROM
  rbal.bal_hsn_point_2154 as hp
WHERE
  hp.ad_code NOT IN 
  (
    SELECT 
      h.ad_code
    FROM 
      pci70_edigeo_majic.geo_batiment as p,
      rbal.bal_hsn_point_2154 as h
    WHERE 
      ST_Intersects(h.geom,p.geom)
  ) )a
;

--- Schema : rbal
--- Vue : v_bal_hsn_point_2154_ftth_ftte
--- Traitement : Vue qui contient pour chaque ad_code le nombre totale de prises ftth et ftte

CREATE OR REPLACE VIEW rbal.v_bal_hsn_point_2154_ftth_ftte AS
SELECT ROW_NUMBER() OVER(ORDER BY ad_code) id, ad_code,  sum(nb_ftth) as nb_ftth, sum(nb_ftte) as nb_ftte
FROM
(
select distinct on (ad_code) ad_code, type_pro1 as type_pro, nb_ftth, nb_ftte
from rbal.bal_hsn_point_2154 a
left join rbal.l_bal_pro_hsn b on a.type_pro1=b.code 
group by ad_code, nb_ftth, nb_ftte
union all
select distinct on (ad_code) ad_code, type_pro2 as type_pro, nb_ftth, nb_ftte
from rbal.bal_hsn_point_2154 a
left join rbal.l_bal_pro_hsn b on a.type_pro2=b.code 
group by ad_code, nb_ftth, nb_ftte
union all
select distinct on (ad_code) ad_code, type_pro3 as type_pro, nb_ftth, nb_ftte
from rbal.bal_hsn_point_2154 a
left join rbal.l_bal_pro_hsn b on a.type_pro3=b.code 
group by ad_code, nb_ftth, nb_ftte
union all
select distinct on (ad_code) ad_code, type_pro4 as type_pro, nb_ftth, nb_ftte
from rbal.bal_hsn_point_2154 a
left join rbal.l_bal_pro_hsn b on a.type_pro4=b.code 
group by ad_code, nb_ftth, nb_ftte
union all
select distinct on (ad_code) ad_code, type_pro5 as type_pro, nb_ftth, nb_ftte
from rbal.bal_hsn_point_2154 a
left join rbal.l_bal_pro_hsn b on a.type_pro5=b.code 
group by ad_code, nb_ftth, nb_ftte
union all
select distinct on (ad_code) ad_code, type_pro6 as type_pro, nb_ftth, nb_ftte
from rbal.bal_hsn_point_2154 a
left join rbal.l_bal_pro_hsn b on a.type_pro6=b.code 
group by ad_code, nb_ftth, nb_ftte
union all
select distinct on (ad_code) ad_code, type_pro7 as type_pro, nb_ftth, nb_ftte
from rbal.bal_hsn_point_2154 a
left join rbal.l_bal_pro_hsn b on a.type_pro7=b.code 
group by ad_code, nb_ftth, nb_ftte
union all
select distinct on (ad_code) ad_code, type_pro8 as type_pro, nb_ftth, nb_ftte
from rbal.bal_hsn_point_2154 a
left join rbal.l_bal_pro_hsn b on a.type_pro8=b.code 
group by ad_code, nb_ftth, nb_ftte
union all
select distinct on (ad_code) ad_code, type_pro9 as type_pro, nb_ftth, nb_ftte
from rbal.bal_hsn_point_2154 a
left join rbal.l_bal_pro_hsn b on a.type_pro9=b.code 
group by ad_code, nb_ftth, nb_ftte
union all
select distinct on (ad_code) ad_code, type_pro10 as type_pro, nb_ftth, nb_ftte
from rbal.bal_hsn_point_2154 a
left join rbal.l_bal_pro_hsn b on a.type_pro10=b.code 
group by ad_code, nb_ftth, nb_ftte) a
WHERE nb_ftth IS NOT NULL 
GROUP BY a.ad_code



