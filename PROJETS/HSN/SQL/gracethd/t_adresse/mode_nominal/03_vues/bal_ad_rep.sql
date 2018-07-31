/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 26/06/2018
Objet : Création de la vue v_bal_ad_rep pour calculer le champ ad_rep
Modification : Nom : ///// - Date : date_de_modif - Motif/nature : //////

Sources: rbal.bal_hsn_point_2154 (ad_rep)/ ban.hsn_point_2154 (rep)
-------------------------------------------------------------------------------------
*/



CREATE OR REPLACE VIEW rbal.v_bal_ad_rep AS

SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, *
FROM
/*
-------------------------------------------------------------------------------------
TOUT CE QUI EST SANS REP
-------------------------------------------------------------------------------------
*/
(
SELECT 
 hp.ad_code,
 NULL::varchar as ad_rep
FROM
 rbal.bal_hsn_point_2154 as hp
WHERE
 hp.ad_code NOT IN 

(SELECT ad_code FROM 
(WITH bal_ad_rep AS 
(SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, *
FROM

(
SELECT 
  hp.ad_code,
  (CASE WHEN ad_rep LIKE 'B' OR ad_rep LIKE 'bis' OR ad_rep LIKE 'Bis' OR ad_rep LIKE 'BIS' THEN 'B' END)::varchar AS ad_rep
FROM
  rbal.bal_hsn_point_2154 as hp
WHERE
  hp.ad_code NOT IN 

(SELECT DISTINCT ON (ad_code) ad_code
FROM
(
WITH ad_rep_ban AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	ad_ban_id, 
 	rep
FROM rbal.bal_hsn_point_2154 a, ban.hsn_point_2154 b
WHERE a.ad_ban_id=b.id)
SELECT ad_code, ad_ban_id, rep FROM ad_rep_ban
WHERE ad_ban_id IS NOT NULL)a) 
AND ad_numero IS NOT NULL

UNION ALL

(SELECT DISTINCT ON (ad_code) ad_code, rep
FROM
(
WITH ad_rep_ban AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	ad_ban_id, 
 	rep
FROM rbal.bal_hsn_point_2154 a, ban.hsn_point_2154 b
WHERE a.ad_ban_id=b.id)
SELECT ad_code, ad_ban_id, rep FROM ad_rep_ban
WHERE ad_rep_ban IS NOT NULL)a)) a
WHERE ad_rep IS NOT NULL )
SELECT * FROM bal_ad_rep)a)


-------------------------------------------------------------------------------------
UNION ALL 
-------------------------------------------------------------------------------------

/*
-------------------------------------------------------------------------------------
TOUT CE QUI A UN REP
-------------------------------------------------------------------------------------
*/
SELECT ad_code, ad_rep FROM 
(WITH bal_ad_rep AS 
(SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, *
FROM
-----------------REP AVEC BAL
(
SELECT 
  hp.ad_code,
  (CASE WHEN ad_rep LIKE 'B' OR ad_rep LIKE 'bis' OR ad_rep LIKE 'Bis' OR ad_rep LIKE 'BIS' THEN 'B' END)::varchar AS ad_rep
FROM
  rbal.bal_hsn_point_2154 as hp
WHERE
  hp.ad_code NOT IN 

(SELECT DISTINCT ON (ad_code) ad_code
FROM
(
WITH ad_rep_ban AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	ad_ban_id, 
 	rep
FROM rbal.bal_hsn_point_2154 a, ban.hsn_point_2154 b
WHERE a.ad_ban_id=b.id)
SELECT ad_code, ad_ban_id, rep FROM ad_rep_ban
WHERE ad_ban_id IS NOT NULL)a) 
AND ad_numero IS NOT NULL

-----------------REP AVEC BAN
UNION ALL
-----------------REP AVEC BAN

(SELECT DISTINCT ON (ad_code) ad_code, rep
FROM
(
WITH ad_rep_ban AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	ad_ban_id, 
 	rep
FROM rbal.bal_hsn_point_2154 a, ban.hsn_point_2154 b
WHERE a.ad_ban_id=b.id)
SELECT ad_code, ad_ban_id, rep FROM ad_rep_ban
WHERE ad_rep_ban IS NOT NULL)a)) a
WHERE ad_rep IS NOT NULL )
SELECT * FROM bal_ad_rep)a)a