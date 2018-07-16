/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 26/06/2018
Objet : Création de la vue v_bal_ad_numero pour calculer le champ ad_numero
Modification : Nom : ///// - Date : date_de_modif - Motif/nature : //////

Sources: rbal.bal_hsn_point_2154 (numero)/ ban.hsn_point_2154 (numero)
-------------------------------------------------------------------------------------
*/


CREATE OR REPLACE VIEW rbal.v_bal_ad_numero AS
SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, *
FROM
------------------------------------------
-- Tout ce qui n'a pas de numero
(
SELECT 
  hp.ad_code,
  hp.ad_numero
FROM
  rbal.bal_hsn_point_2154 as hp
WHERE
  hp.ad_code NOT IN 

(SELECT ad_code FROM 
(WITH bal_ad_numero AS
((SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, *
FROM
-- ad_numero (bal)
(
SELECT 
  hp.ad_code,
  hp.ad_numero
FROM
  rbal.bal_hsn_point_2154 as hp
WHERE
  hp.ad_code NOT IN 

(SELECT DISTINCT ON (ad_code) ad_code
FROM
(
WITH ad_numero_ban AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	ad_ban_id, 
 	cast(numero as integer)
FROM rbal.bal_hsn_point_2154 a, ban.hsn_point_2154 b
WHERE a.ad_ban_id=b.id)
SELECT ad_code, ad_ban_id, numero FROM ad_numero_ban
WHERE ad_ban_id IS NOT NULL)a) 
AND ad_numero IS NOT NULL

UNION ALL
-- ad_numero (ban)
(SELECT DISTINCT ON (ad_code) ad_code, numero
FROM
(
WITH ad_numero_ban AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	ad_ban_id, 
 	cast(numero as integer)
FROM rbal.bal_hsn_point_2154 a, ban.hsn_point_2154 b
WHERE a.ad_ban_id=b.id)
SELECT ad_code, ad_ban_id, numero FROM ad_numero_ban
WHERE ad_ban_id IS NOT NULL)a)) a
WHERE ad_numero IS NOT NULL ))
SELECT * FROM bal_ad_numero)a)

UNION ALL 
------------------------------------------
-- Tout ce qui a un numero
SELECT ad_code, ad_numero FROM 
(WITH bal_ad_numero AS
((SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, *
FROM
-- ad_numero (bal)
(
SELECT 
  hp.ad_code,
  hp.ad_numero
FROM
  rbal.bal_hsn_point_2154 as hp
WHERE
  hp.ad_code NOT IN 

(SELECT DISTINCT ON (ad_code) ad_code
FROM
(
WITH ad_numero_ban AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	ad_ban_id, 
 	cast(numero as integer)
FROM rbal.bal_hsn_point_2154 a, ban.hsn_point_2154 b
WHERE a.ad_ban_id=b.id)
SELECT ad_code, ad_ban_id, numero FROM ad_numero_ban
WHERE ad_ban_id IS NOT NULL)a) 
AND ad_numero IS NOT NULL

UNION ALL
-- ad_numero (ban)
(SELECT DISTINCT ON (ad_code) ad_code, numero
FROM
(
WITH ad_numero_ban AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	ad_ban_id, 
 	cast(numero as integer)
FROM rbal.bal_hsn_point_2154 a, ban.hsn_point_2154 b
WHERE a.ad_ban_id=b.id)
SELECT ad_code, ad_ban_id, numero FROM ad_numero_ban
WHERE ad_ban_id IS NOT NULL)a)) a
WHERE ad_numero IS NOT NULL ))
SELECT * FROM bal_ad_numero)a)a