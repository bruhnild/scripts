
--- Schema : rbal
--- Vue : v_ctrl_bal_out_batiment
--- Traitement : Vue qui contient toutes les bal en dehors des batiments (nb :référentiel cadastre edigeo, manque des communes)

CREATE OR REPLACE VIEW rbal.v_ctrl_bal_out_batiment AS
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
--- Vue : v_ctrl_bal_out_liaison
--- Traitement : Vue qui contient toutes les bal sans liaison

CREATE OR REPLACE VIEW rbal.v_ctrl_bal_out_liaison AS
WITH bal_liaison_out AS
(
SELECT 
  hp.ad_code,
  hp.ad_nblhab,
  hp.ad_nblpro,
  hp.geom
FROM
  rbal.bal_hsn_point_2154 as hp
WHERE
  hp.ad_code NOT IN 
  (
    SELECT 
      h.ad_code
    FROM 
      rbal.liaison_hsn_linestring_2154 as p,
      rbal.bal_hsn_point_2154 as h
      WHERE ST_DWithin(h.geom, p.geom, 0.1) 
  ))
SELECT  ad_code, geom
FROM bal_liaison_out 
WHERE ad_nblhab >0 OR ad_nblpro > 0;

--- Schema : rbal
--- Vue : v_ctrl_bal_out_liaison_voie
--- Traitement : Vue qui contient toutes les bal sans liaison voie

CREATE OR REPLACE VIEW rbal.v_ctrl_bal_out_liaison_voie AS
WITH bal_liaison_voie_out AS
(
SELECT 
  hp.ad_code,
  hp.ad_nblhab,
  hp.ad_nblpro,
  hp.geom
FROM
  rbal.bal_hsn_point_2154 as hp
WHERE
  hp.ad_code NOT IN 
  (
    SELECT 
      h.ad_code
    FROM 
      rbal.liaison_voie_hsn_linestring_2154 as p,
      rbal.bal_hsn_point_2154 as h
      WHERE ST_DWithin(h.geom, p.geom, 0.1) 
  ))
SELECT  ad_code, geom
FROM bal_liaison_voie_out 
WHERE ad_nblhab >0 OR ad_nblpro > 0;

--- Schema : rbal
--- Vue : v_ctrl_bal_out_racco
--- Traitement : Vue qui contient toutes les bal sans racco

CREATE OR REPLACE VIEW rbal.v_ctrl_bal_out_racco  AS
SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, *
FROM
(
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
      rbal.racco_hsn_linestring_2154 as p,
      rbal.bal_hsn_point_2154 as h
      WHERE ST_DWithin(h.geom, p.geom, 0.1)))a;


--- Schema : rbal
--- Vue : v_ctrl_bal_out_ad_racc
--- Traitement : Vue qui contient toutes les BAL sans ad_racc (sauf pour les supprimés)

CREATE OR REPLACE VIEW rbal.v_ctrl_bal_out_ad_racc AS
SELECT ad_numero, ad_rep, ad_nombat, ad_racc, ad_comment, ad_nblhab, ad_nblpro, construction, destruction, 
type_pro1, nom_pro1, type_pro2, nom_pro2, type_pro3, nom_pro3, type_pro4, nom_pro4, type_pro5, nom_pro5, 
type_pro6, nom_pro6, type_pro7, nom_pro7, type_pro8, nom_pro8, type_pro9, nom_pro9, type_pro10, nom_pro10, 
ad_creadat, ad_ban_id, geom, ad_code
FROM rbal.bal_hsn_point_2154
WHERE ad_racc IS NULL AND destruction NOT LIKE 'Supprimé' AND ad_nblhab > 0 
OR ad_racc IS NULL AND destruction NOT LIKE 'Supprimé' AND ad_nblpro > 0;


--- Schema : rbal
--- Vue : v_ctrl_batimentdur_out_bal
--- Traitement : Vue qui contient toutes les batis "durs" qui n'ont pas de bal


/*CREATE OR REPLACE VIEW rbal.v_ctrl_batimentdur_out_bal AS
SELECT ROW_NUMBER() OVER(ORDER BY geo_batiment) gid, * 
FROM(
SELECT 
  hp.geo_batiment,
  hp.geom,
  hp.geo_dur
FROM
  pci70_edigeo_majic.geo_batiment as hp
WHERE
  hp.geo_batiment NOT IN 
  (
    SELECT 
      p.geo_batiment
    FROM 
      pci70_edigeo_majic.geo_batiment as p,
      rbal.bal_hsn_point_2154 as h
    WHERE 
      ST_Intersects(h.geom,p.geom)
  ) AND geo_dur = '01')a
;

*/
--- Schema : rbal
--- Vue : v_ctrl_bal_out_id_ban
--- Traitement : Vue qui contient toutes bal sans id_ban

CREATE OR REPLACE VIEW rbal.v_ctrl_bal_out_id_ban AS
SELECT 
  hp.ad_code,
  hp.geom
FROM
  rbal.bal_hsn_point_2154 as hp
WHERE
  hp.ad_code NOT IN 

(SELECT DISTINCT ON (ad_code) ad_code
FROM
(
WITH bal_liaison AS
(
    SELECT 
    a.ad_code,
    b.liaison_id,
    b.id_ban,
    a.geom      
    FROM   
      rbal.bal_hsn_point_2154 as a, rbal.liaison_hsn_linestring_2154 as b
      WHERE ST_DWithin(b.geom, a.geom, 0.1))
  SELECT ad_code, liaison_id, id_ban,geom  FROM bal_liaison WHERE id_ban IS NOT NULL)a);
  
  

--- Schema : rbal
--- Vue : v_ctrl_bal_idbanout_idlocauxin
--- Traitement : Vue qui contient toutes bal sans id_ban et avec id_locaux

CREATE OR REPLACE VIEW rbal.v_ctrl_bal_idbanout_idlocauxin AS
SELECT 
  hp.ad_code,
  hp.geom,
  b.liaison_id,
  b.id_locaux
FROM
 rbal.bal_hsn_point_2154 as hp, rbal.liaison_hsn_linestring_2154 as b
WHERE ST_DWithin(b.geom, hp.geom, 0.1)
AND
  hp.ad_code NOT IN 

(SELECT DISTINCT ON (ad_code) ad_code
FROM
(
WITH bal_liaison AS
(
    SELECT 
    a.ad_code,
    b.liaison_id,
    b.id_ban,
    a.geom      
    FROM   
      rbal.bal_hsn_point_2154 as a, rbal.liaison_hsn_linestring_2154 as b
      WHERE ST_DWithin(b.geom, a.geom, 0.1))
  SELECT ad_code, liaison_id, id_ban,geom  FROM bal_liaison WHERE id_ban IS NOT NULL)a)
 
AND hp.ad_code IN

(SELECT DISTINCT ON (ad_code) ad_code
FROM
(
WITH bal_liaison AS
(
    SELECT 
    a.ad_code,
    b.liaison_id,
    b.id_locaux,
    a.geom      
    FROM   
      rbal.bal_hsn_point_2154 as a, rbal.liaison_hsn_linestring_2154 as b
      WHERE ST_DWithin(b.geom, a.geom, 0.1))
  SELECT ad_code, liaison_id, id_locaux,geom  FROM bal_liaison WHERE id_locaux IS NOT NULL)a);
  

--- Schema : rbal
--- Vue : v_ctrl_bal_idbanout_idlocauxin_voie_numero
--- Traitement : Vue qui contient tous les locaux qui seront utilisés pour remplir les champs ad_numero et ad_nomvoie 


CREATE OR REPLACE VIEW rbal.v_ctrl_bal_idbanout_idlocauxin_voie_numero AS 
SELECT 
 hpa.geom,
 hpa.id,
 hpa.numero,
 hpa.voie
 
FROM
 psd_orange.locaux_hsn_sian_zanro_point_2154 hpa

  WHERE hpa.id  IN 


(SELECT 
  b.id_locaux
FROM
 rbal.bal_hsn_point_2154 as hp, rbal.liaison_hsn_linestring_2154 as b
WHERE ST_DWithin(b.geom, hp.geom, 0.1)
AND
  hp.ad_code NOT IN 

(SELECT DISTINCT ON (ad_code) ad_code
FROM
(
WITH bal_liaison AS
(
    SELECT 
    a.ad_code,
    b.liaison_id,
    b.id_ban,
    a.geom      
    FROM   
      rbal.bal_hsn_point_2154 as a, rbal.liaison_hsn_linestring_2154 as b
      WHERE ST_DWithin(b.geom, a.geom, 0.1))
  SELECT ad_code, liaison_id, id_ban,geom  FROM bal_liaison WHERE id_ban IS NOT NULL)a)
 
AND hp.ad_code IN

(SELECT DISTINCT ON (ad_code) ad_code
FROM
(
WITH bal_liaison AS
(
    SELECT 
    a.ad_code,
    b.liaison_id,
    b.id_locaux,
    a.geom      
    FROM   
      rbal.bal_hsn_point_2154 as a, rbal.liaison_hsn_linestring_2154 as b
      WHERE ST_DWithin(b.geom, a.geom, 0.1))
  SELECT ad_code, liaison_id, id_locaux,geom  FROM bal_liaison WHERE id_locaux IS NOT NULL)a));

--- Schema : rbal
--- Vue : v_ctrl_bal_id_ban
--- Traitement : Vue qui contient pour chaque bal son id_ban (via liaison). Voir le champ nbr_doublon_ban pour les doublons


CREATE OR REPLACE VIEW rbal.v_ctrl_bal_id_ban AS
SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, *
FROM
(SELECT ad_code, liaison_id, id_ban,nbr_doublon_ban,geom
FROM
(
WITH bal_liaison AS
(
    SELECT 
    a.ad_code,
    b.liaison_id,
    b.id_ban,
    a.geom      
    FROM   
      rbal.bal_hsn_point_2154 as a, rbal.liaison_hsn_linestring_2154 as b
      WHERE ST_DWithin(b.geom, a.geom, 0.1))
    SELECT bal_liaison.ad_code, liaison_id, id_ban,nbr_doublon_ban, geom  FROM bal_liaison 
  
 
LEFT JOIN
  
(SELECT ad_code, nbr_doublon_ban
FROM
(
  WITH nbr_doublon_ban AS
  
    (SELECT COUNT(ad_code) AS nbr_doublon_ban, ad_code 
     FROM 
  (SELECT ad_code, liaison_id, id_ban,geom
  FROM
  (
  WITH bal_liaison AS
  (
    SELECT 
    a.ad_code,
    b.liaison_id,
    b.id_ban,
    a.geom      
    FROM   
    rbal.bal_hsn_point_2154 as a, rbal.liaison_hsn_linestring_2154 as b
    WHERE ST_DWithin(b.geom, a.geom, 0.1))
  SELECT ad_code, liaison_id, id_ban,geom  FROM bal_liaison WHERE id_ban IS NOT NULL)a)a
  GROUP BY ad_code
  HAVING   COUNT(*) > 1
  ORDER BY nbr_doublon_ban)
SELECT * FROM nbr_doublon_ban)a)nbr_doublon_ban ON nbr_doublon_ban.ad_code=bal_liaison.ad_code
WHERE id_ban IS NOT NULL
ORDER BY nbr_doublon_ban)a)a
ORDER BY nbr_doublon_ban;
  
  
--- Schema : rbal
--- Vue : v_ctrl_bal_id_locaux
--- Traitement : Vue qui contient pour chaque bal son id_locaux (via liaison). Voir le champ nbr_doublon_locaux pour les doublons



CREATE OR REPLACE VIEW rbal.v_ctrl_bal_id_locaux AS
SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, *
FROM
(SELECT ad_code, liaison_id, id_locaux,nbr_doublon_locaux,geom
FROM
(
WITH bal_liaison AS
(
    SELECT 
    a.ad_code,
    b.liaison_id,
    b.id_locaux,
    a.geom      
    FROM   
      rbal.bal_hsn_point_2154 as a, rbal.liaison_hsn_linestring_2154 as b
      WHERE ST_DWithin(b.geom, a.geom, 0.1))
  SELECT bal_liaison.ad_code, liaison_id, id_locaux,nbr_doublon_locaux, geom  FROM bal_liaison 
  
 
 LEFT JOIN
  
  
(SELECT ad_code, nbr_doublon_locaux
FROM
(
  WITH nbr_doublon_locaux AS
  
    (SELECT COUNT(ad_code) AS nbr_doublon_locaux, ad_code 
    FROM (SELECT ad_code, liaison_id, id_locaux,geom
  FROM
    (
    WITH bal_liaison AS
    (
    SELECT 
    a.ad_code,
    b.liaison_id,
    b.id_locaux,
    a.geom      
    FROM   
    rbal.bal_hsn_point_2154 as a, rbal.liaison_hsn_linestring_2154 as b
    WHERE ST_DWithin(b.geom, a.geom, 0.1))
  SELECT ad_code, liaison_id, id_locaux,geom  FROM bal_liaison WHERE id_locaux IS NOT NULL)a)a
  GROUP BY ad_code
  HAVING   COUNT(*) > 1
  ORDER BY nbr_doublon_locaux)
SELECT * FROM nbr_doublon_locaux)a)nbr_doublon_locaux ON nbr_doublon_locaux.ad_code=bal_liaison.ad_code
WHERE id_locaux IS NOT NULL
ORDER BY nbr_doublon_locaux)a)a
ORDER BY nbr_doublon_locaux;
  

--- Schema : rbal
--- Vue : v_ctrl_bal_nb_prises
--- Traitement : Vue qui contient pour pour chaque type_pro/nom_pro de bal le nombre de ftth/ftte correspondant


CREATE OR REPLACE VIEW rbal.v_ctrl_bal_nb_prises AS
WITH nb_prises AS
(SELECT DISTINCT ON (ad_code) ad_code, type_pro1 AS code_pro, nom_pro1 AS nom_pro, type_pro, nb_ftth, nb_ftte
FROM rbal.bal_hsn_point_2154 a
LEFT JOIN rbal.l_bal_pro_hsn b on a.type_pro1=b.code 
GROUP BY ad_code, nb_ftth, nb_ftte, type_pro
UNION ALL
SELECT DISTINCT ON (ad_code) ad_code, type_pro2 AS code_pro, nom_pro2 AS nom_pro, type_pro, nb_ftth, nb_ftte
FROM rbal.bal_hsn_point_2154 a
LEFT JOIN rbal.l_bal_pro_hsn b on a.type_pro2=b.code 
GROUP BY ad_code, nb_ftth, nb_ftte, type_pro
UNION ALL
SELECT DISTINCT ON (ad_code) ad_code, type_pro3 AS code_pro, nom_pro3 AS nom_pro,type_pro, nb_ftth, nb_ftte
FROM rbal.bal_hsn_point_2154 a
LEFT JOIN rbal.l_bal_pro_hsn b on a.type_pro3=b.code 
GROUP BY ad_code, nb_ftth, nb_ftte, type_pro
UNION ALL
SELECT DISTINCT ON (ad_code) ad_code, type_pro4 AS code_pro, nom_pro4 AS nom_pro,type_pro, nb_ftth, nb_ftte
FROM rbal.bal_hsn_point_2154 a
LEFT JOIN rbal.l_bal_pro_hsn b on a.type_pro4=b.code 
GROUP BY ad_code, nb_ftth, nb_ftte, type_pro
UNION ALL
SELECT DISTINCT ON (ad_code) ad_code, type_pro5 AS code_pro, nom_pro5 AS nom_pro,type_pro, nb_ftth, nb_ftte
FROM rbal.bal_hsn_point_2154 a
LEFT JOIN rbal.l_bal_pro_hsn b on a.type_pro5=b.code 
GROUP BY ad_code, nb_ftth, nb_ftte, type_pro
UNION ALL
SELECT DISTINCT ON (ad_code) ad_code, type_pro6 AS code_pro, nom_pro6 AS nom_pro,type_pro, nb_ftth, nb_ftte
FROM rbal.bal_hsn_point_2154 a
LEFT JOIN rbal.l_bal_pro_hsn b on a.type_pro6=b.code 
GROUP BY ad_code, nb_ftth, nb_ftte, type_pro
UNION ALL
SELECT DISTINCT ON (ad_code) ad_code, type_pro7 AS code_pro, nom_pro7 AS nom_pro,type_pro, nb_ftth, nb_ftte
FROM rbal.bal_hsn_point_2154 a
LEFT JOIN rbal.l_bal_pro_hsn b on a.type_pro7=b.code 
GROUP BY ad_code, nb_ftth, nb_ftte, type_pro
UNION ALL
SELECT DISTINCT ON (ad_code) ad_code, type_pro8 AS code_pro, nom_pro8 AS nom_pro,type_pro, nb_ftth, nb_ftte
FROM rbal.bal_hsn_point_2154 a
LEFT JOIN rbal.l_bal_pro_hsn b on a.type_pro8=b.code 
GROUP BY ad_code, nb_ftth, nb_ftte, type_pro
UNION ALL
SELECT DISTINCT ON (ad_code) ad_code, type_pro9 AS code_pro, nom_pro9 AS nom_pro,type_pro, nb_ftth, nb_ftte
FROM rbal.bal_hsn_point_2154 a
LEFT JOIN rbal.l_bal_pro_hsn b on a.type_pro9=b.code 
GROUP BY ad_code, nb_ftth, nb_ftte, type_pro
UNION ALL
SELECT DISTINCT ON (ad_code) ad_code, type_pro10 AS code_pro, nom_pro10 AS nom_pro,type_pro, nb_ftth, nb_ftte
FROM rbal.bal_hsn_point_2154 a
LEFT JOIN rbal.l_bal_pro_hsn b on a.type_pro10=b.code 
GROUP BY ad_code, nb_ftth, nb_ftte,type_pro )
SELECT * FROM nb_prises
WHERE nb_ftth IS NOT NULL ;


--- Schema : rbal
--- Vue : v_ctrl_bal_ftth_ftte
--- Traitement : Vue qui contient pour chaque ad_code le nombre total de prises ftth et ftte


CREATE OR REPLACE VIEW rbal.v_ctrl_bal_ftth_ftte AS
SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, *
FROM
(WITH nb_prises AS
(SELECT DISTINCT ON (ad_code) ad_code, type_pro1 AS code_pro, type_pro, nb_ftth, nb_ftte
FROM rbal.bal_hsn_point_2154 a
LEFT JOIN rbal.l_bal_pro_hsn b on a.type_pro1=b.code 
GROUP BY ad_code, nb_ftth, nb_ftte, type_pro
UNION ALL
SELECT DISTINCT ON (ad_code) ad_code, type_pro2 AS code_pro, type_pro, nb_ftth, nb_ftte
FROM rbal.bal_hsn_point_2154 a
LEFT JOIN rbal.l_bal_pro_hsn b on a.type_pro2=b.code 
GROUP BY ad_code, nb_ftth, nb_ftte, type_pro
UNION ALL
SELECT DISTINCT ON (ad_code) ad_code, type_pro3 AS code_pro, type_pro, nb_ftth, nb_ftte
FROM rbal.bal_hsn_point_2154 a
LEFT JOIN rbal.l_bal_pro_hsn b on a.type_pro3=b.code 
GROUP BY ad_code, nb_ftth, nb_ftte, type_pro
UNION ALL
SELECT DISTINCT ON (ad_code) ad_code, type_pro4 AS code_pro, type_pro, nb_ftth, nb_ftte
FROM rbal.bal_hsn_point_2154 a
LEFT JOIN rbal.l_bal_pro_hsn b on a.type_pro4=b.code 
GROUP BY ad_code, nb_ftth, nb_ftte, type_pro
UNION ALL
SELECT DISTINCT ON (ad_code) ad_code, type_pro5 AS code_pro, type_pro, nb_ftth, nb_ftte
FROM rbal.bal_hsn_point_2154 a
LEFT JOIN rbal.l_bal_pro_hsn b on a.type_pro5=b.code 
GROUP BY ad_code, nb_ftth, nb_ftte, type_pro
UNION ALL
SELECT DISTINCT ON (ad_code) ad_code, type_pro6 AS code_pro, type_pro, nb_ftth, nb_ftte
FROM rbal.bal_hsn_point_2154 a
LEFT JOIN rbal.l_bal_pro_hsn b on a.type_pro6=b.code 
GROUP BY ad_code, nb_ftth, nb_ftte, type_pro
UNION ALL
SELECT DISTINCT ON (ad_code) ad_code, type_pro7 AS code_pro, type_pro, nb_ftth, nb_ftte
FROM rbal.bal_hsn_point_2154 a
LEFT JOIN rbal.l_bal_pro_hsn b on a.type_pro7=b.code 
GROUP BY ad_code, nb_ftth, nb_ftte, type_pro
UNION ALL
SELECT DISTINCT ON (ad_code) ad_code, type_pro8 AS code_pro, type_pro, nb_ftth, nb_ftte
FROM rbal.bal_hsn_point_2154 a
LEFT JOIN rbal.l_bal_pro_hsn b on a.type_pro8=b.code 
GROUP BY ad_code, nb_ftth, nb_ftte, type_pro
UNION ALL
SELECT DISTINCT ON (ad_code) ad_code, type_pro9 AS code_pro, type_pro, nb_ftth, nb_ftte
FROM rbal.bal_hsn_point_2154 a
LEFT JOIN rbal.l_bal_pro_hsn b on a.type_pro9=b.code 
GROUP BY ad_code, nb_ftth, nb_ftte, type_pro
UNION ALL
SELECT DISTINCT ON (ad_code) ad_code, type_pro10 AS code_pro, type_pro, nb_ftth, nb_ftte
FROM rbal.bal_hsn_point_2154 a
LEFT JOIN rbal.l_bal_pro_hsn b on a.type_pro10=b.code 
GROUP BY ad_code, nb_ftth, nb_ftte,type_pro )

SELECT  nb_prises.ad_code,  sum(nb_ftth) AS nb_ftth, sum(nb_ftte) AS nb_ftte, typologie_pro, nom_pro FROM nb_prises

LEFT JOIN 

(SELECT ad_code, typologie_pro, nom_pro
FROM
( 
WITH nom_pro AS
(SELECT ad_code, array_to_string(array_agg(type_pro),';') AS typologie_pro, array_to_string(array_agg(nom_pro),';') AS nom_pro
FROM  rbal.v_ctrl_bal_nb_prises 
GROUP BY ad_code)
SELECT * FROM nom_pro)a)nom_pro ON nom_pro.ad_code=nb_prises.ad_code
WHERE nb_ftth IS NOT NULL 
GROUP BY nb_prises.ad_code, typologie_pro, nom_pro)a;


--- Schema : rbal
--- Vue : v_ctrl_bal_erreurs_nbprises
--- Traitement : Vue qui répertorie les incohérences de nombre de prises (ad_nblhab, ad_nblpro, type_pro)
CREATE OR REPLACE VIEW rbal.v_ctrl_bal_erreurs_nbprises AS
SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, *
FROM
(SELECT distinct on (bal.ad_code) bal.ad_code,  ad_nblhab, ad_nblpro, 
type_pro1, nom_pro1, type_pro2, nom_pro2, type_pro3, nom_pro3, 
type_pro4, nom_pro4, type_pro5, nom_pro5, type_pro6, nom_pro6, 
type_pro7, nom_pro7, type_pro8, nom_pro8, type_pro9, nom_pro9, 
type_pro10, nom_pro10,array_to_string(ARRAY[sans_typepro, sans_nblpro, sans_prise], ',', '*') AS erreur , geom
FROM rbal.bal_hsn_point_2154 as bal
LEFT JOIN 
-- Cas où ad_nblpro >0 et pas de type_pro renseigné
(SELECT ad_code, 'Renseigner type_pro'::varchar as sans_typepro
FROM
( 
WITH sans_type_pro AS
(SELECT ad_nblhab, ad_nblpro, 
type_pro1, nom_pro1, type_pro2, nom_pro2, type_pro3, nom_pro3, 
type_pro4, nom_pro4, type_pro5, nom_pro5, type_pro6, nom_pro6, 
type_pro7, nom_pro7, type_pro8, nom_pro8, type_pro9, nom_pro9, 
type_pro10, nom_pro10, 
geom, ad_code
FROM rbal.bal_hsn_point_2154
WHERE ad_nblpro >0 AND 
type_pro1 IS NULL AND
type_pro2 IS NULL AND
type_pro3 IS NULL AND
type_pro4 IS NULL AND
type_pro5 IS NULL AND
type_pro6 IS NULL AND
type_pro7 IS NULL AND
type_pro8 IS NULL AND
type_pro9 IS NULL AND
type_pro10 IS NULL)
SELECT * FROM sans_type_pro )a)sans_type_pro ON sans_type_pro.ad_code=bal.ad_code
LEFT JOIN 
-- Cas où type_pro renseigné et ad_nblpro = 0
(SELECT ad_code, 'Renseigner ad_nblpro '::varchar as sans_nblpro
FROM
(
WITH sans_type_pro_part AS
(SELECT ad_nblhab, ad_nblpro, 
type_pro1, nom_pro1, type_pro2, nom_pro2, type_pro3, nom_pro3, 
type_pro4, nom_pro4, type_pro5, nom_pro5, type_pro6, nom_pro6, 
type_pro7, nom_pro7, type_pro8, nom_pro8, type_pro9, nom_pro9, 
type_pro10, nom_pro10, 
geom, ad_code
FROM rbal.bal_hsn_point_2154
WHERE ad_nblpro = 0 AND 
type_pro1 IS NOT NULL AND
type_pro2 IS NOT NULL AND
type_pro3 IS NOT NULL AND
type_pro4 IS NOT NULL AND
type_pro5 IS NOT NULL AND
type_pro6 IS NOT NULL AND
type_pro7 IS NOT NULL AND
type_pro8 IS NOT NULL AND
type_pro9 IS NOT NULL AND
type_pro10 IS NOT NULL
 )
SELECT * FROM sans_type_pro_part)a)sans_type_pro_part ON sans_type_pro_part.ad_code=bal.ad_code
LEFT JOIN
-- Cas où ad_nblpro = 0 et ad_nblhab = 0
(SELECT ad_code, 'Renseigner ad_nblpro ou ad_nblhab'::varchar as sans_prise
FROM
(
WITH sans_prises AS
(SELECT ad_nblhab, ad_nblpro, 
type_pro1, nom_pro1, type_pro2, nom_pro2, type_pro3, nom_pro3, 
type_pro4, nom_pro4, type_pro5, nom_pro5, type_pro6, nom_pro6, 
type_pro7, nom_pro7, type_pro8, nom_pro8, type_pro9, nom_pro9, 
type_pro10, nom_pro10, 
geom, ad_code
FROM rbal.bal_hsn_point_2154
WHERE ad_nblpro = 0  
AND ad_nblhab = 0)
SELECT * FROM sans_prises)a)sans_prises ON sans_prises.ad_code=bal.ad_code)a
WHERE erreur NOT LIKE '*,*,*';



--- Schema : rbal
--- Vue : v_ctrl_bal_erreurs_numero
--- Traitement : Vue qui contient toutes les BAL dont le numero ne correspond pas à celui de la BAN et/ou de locaux_hsn


CREATE OR REPLACE VIEW rbal.v_ctrl_bal_erreurs_numero AS
SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, *
FROM
(WITH bal AS
(SELECT ad_code
FROM rbal.bal_hsn_point_2154 a)
SELECT id, liaison_id, bal.ad_code, ad_numero, numero ,incoherence, geom FROM bal
INNER JOIN 

(SELECT id, liaison_id, ad_code, ad_numero, numero, incoherence, geom
FROM
(
WITH bal_numero_erreur AS
(
(SELECT 
 cast(id as varchar), 
 liaison_id, 
 ad_code,  
 ad_numero, 
 numero,
 incoherence_hsn as incoherence ,
 geom
FROM
( 

WITH bal_liaison_locaux AS
(
SELECT ROW_NUMBER() OVER(ORDER BY id) gid, *
FROM
(
WITH ban_liaison AS
(
SELECT  distinct on (a.id) a.id,  numero
  FROM psd_orange.locaux_hsn_sian_zanro_point_2154 a
  INNER JOIN  rbal.liaison_hsn_linestring_2154 b ON a.id=b.id_locaux)
  SELECT id, liaison_id, ad_code, numero,  LPAD(ad_numero::text, 4, '0')ad_numero_, ad_numero,'Locaux HSN'::varchar as incoherence_hsn, geom FROM ban_liaison

LEFT JOIN 
(SELECT ad_code, ad_numero, ad_rep, liaison_id, id_locaux, geom
FROM
( 
WITH bal_liaison AS
(
    SELECT 
    distinct on (a.ad_code) a.ad_code,
    a.ad_numero,
    a.ad_rep,
    b.liaison_id,
    b.id_locaux,
    a.geom      
    FROM   
      rbal.bal_hsn_point_2154 as a, rbal.liaison_hsn_linestring_2154 as b
      WHERE ST_DWithin(b.geom, a.geom, 0.1) )
  SELECT * FROM bal_liaison)a)bal_liaison ON bal_liaison.id_locaux=ban_liaison.id)a
  WHERE cast(ad_numero_ as varchar) <> numero
  ORDER BY liaison_id)
  SELECT * FROM bal_liaison_locaux)a)
  
  UNION ALL
  
  (SELECT 
   id, 
   liaison_id, 
   ad_code,   
   ad_numero,
   numero,
   incoherence_ban as incoherence, 
   geom
FROM
( 

WITH bal_liaison_ban AS
(SELECT ROW_NUMBER() OVER(ORDER BY id) gid, *
FROM
(
WITH ban_liaison AS
(
SELECT  distinct on (a.id) a.id, nom_voie, id_fantoir, numero, rep, code_insee, code_post, alias, nom_ld, x, y, commune, fant_voie, fant_ld
  FROM ban.hsn_point_2154 a
  INNER JOIN  rbal.liaison_hsn_linestring_2154 b ON a.id=b.id_ban)
  SELECT id, liaison_id, ad_code, nom_voie, id_fantoir, ad_numero, numero, rep, code_insee, code_post, alias, nom_ld, x, y, commune, fant_voie, fant_ld, 'BAN'::varchar as incoherence_ban, bal_liaison.geom  FROM ban_liaison

LEFT JOIN 
(SELECT ad_code, ad_numero, ad_rep, liaison_id, id_ban, geom
FROM
( 
WITH bal_liaison AS
(
    SELECT 
    distinct on (a.ad_code) a.ad_code,
    a.ad_numero,
    a.ad_rep,
    b.liaison_id,
    b.id_ban,
    a.geom      
    FROM   
      rbal.bal_hsn_point_2154 as a, rbal.liaison_hsn_linestring_2154 as b
      WHERE ST_DWithin(b.geom, a.geom, 0.1) )
  SELECT * FROM bal_liaison)a)bal_liaison ON bal_liaison.id_ban=ban_liaison.id
  WHERE cast(ad_numero as varchar) <> numero
  ORDER BY liaison_id)a)
  SELECT id, liaison_id, ad_code, nom_voie, id_fantoir, 
  ad_numero, numero,  rep, code_insee, code_post, alias, nom_ld, x, y, 
  commune, fant_voie, fant_ld, incoherence_ban, geom FROM bal_liaison_ban)a))
  SELECT * FROM bal_numero_erreur)a)bal_numero_erreur ON bal_numero_erreur.ad_code=bal.ad_code)a;



