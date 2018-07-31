/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 26/06/2018
Objet : Création de la vue v_bal_potentiel_ftte pour calculer le champ potentiel_ftte
Modification : Nom : ///// - Date : date_de_modif - Motif/nature : //////

Sources: rbal.v_ctrl_bal_ftth_ftte (nb_ftte) 
-------------------------------------------------------------------------------------
*/

CREATE OR REPLACE VIEW rbal.v_bal_potentiel_ftte AS
SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, *
FROM
/*
-------------------------------------------------------------------------------------
POTENTIEL FTTE = 0
-------------------------------------------------------------------------------------
*/
(
SELECT 
  hp.ad_code,
  0::int as potentiel_ftte
FROM
  rbal.bal_hsn_point_2154 as hp
WHERE
  hp.ad_code NOT IN 


(SELECT ad_code FROM 
(WITH ad_insee_postal_commune AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
 	nb_ftte  as potentiel_ftte
FROM rbal.bal_hsn_point_2154 a, rbal.v_ctrl_bal_ftth_ftte b
WHERE a.ad_code=b.ad_code)

SELECT ad_code, potentiel_ftte FROM ad_insee_postal_commune)a)

-------------------------------------------------------------------------------------
UNION ALL
-------------------------------------------------------------------------------------

/*
-------------------------------------------------------------------------------------
POTENTIEL FTTE > 0
-------------------------------------------------------------------------------------
*/
SELECT ad_code, potentiel_ftte FROM 
(WITH potentiel_ftte AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
 	nb_ftte  as potentiel_ftte
FROM rbal.bal_hsn_point_2154 a, rbal.v_ctrl_bal_ftth_ftte b
WHERE a.ad_code=b.ad_code)

SELECT ad_code, potentiel_ftte FROM potentiel_ftte)a)a;