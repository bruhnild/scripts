/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 26/06/2018
Objet : Création de la vue v_bal_nb_prises_totale pour calculer le champ nb_prises_totale
Modification : Nom : ///// - Date : date_de_modif - Motif/nature : //////

Sources: rbal.v_bal_ad_nbprpro (ad_nbprhab+ad_nbprpro) 
-------------------------------------------------------------------------------------
*/


CREATE OR REPLACE VIEW rbal.v_bal_nb_prises_totale AS
SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, *
FROM
(
WITH bal_nb_prises AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
   (CASE WHEN ad_nblhab IS NOT NULL THEN ad_nblhab ELSE 0 END)::int as ad_nbprhab,
   ad_nbprpro
FROM rbal.bal_hsn_point_2154 a
LEFT JOIN rbal.v_bal_ad_nbprpro as b ON a.ad_code = b.ad_code)
SELECT ad_code, ad_nbprhab, ad_nbprpro, ad_nbprhab+ad_nbprpro as nb_prises_totale  FROM bal_nb_prises)a;