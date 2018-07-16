/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 26/06/2018
Objet : Création de la vue v_bal_ad_ban_id pour calculer le champ ad_ban_id
Modification : Nom : ///// - Date : date_de_modif - Motif/nature : //////

Sources: rbal.liaison_hsn_linestring_2154 (ad_ban_id) via ban.hsn_point_2154 (id)
-------------------------------------------------------------------------------------
*/

CREATE OR REPLACE VIEW rbal.v_bal_ad_ban_id AS
SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, *
FROM
(
SELECT 
  hp.ad_code,
  NULL::varchar as ad_ban_id
  FROM
  rbal.bal_hsn_point_2154 as hp
WHERE
  hp.ad_code NOT IN

(SELECT ad_code FROM
(WITH ad_ban_id_liaison AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	b.id_ban
FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.1) )
SELECT ad_code,id_ban as ad_ban_id FROM ad_ban_id_liaison
WHERE id_ban IS NOT NULL)a) 

UNION ALL 

SELECT ad_code, ad_ban_id FROM
(WITH ad_ban_id_liaison AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	b.id_ban
FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.1) )
SELECT ad_code,id_ban as ad_ban_id FROM ad_ban_id_liaison
WHERE id_ban IS NOT NULL)a)a


