/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 26/06/2018
Objet : Création de la vue v_bal_ad_isole pour calculer le champ ad_isole
Modification : Nom : ///// - Date : date_de_modif - Motif/nature : //////

Sources:  rbal.racco_hsn_linestring_2154 (ST_LENGTH (b.geom) >= 150)) 
-------------------------------------------------------------------------------------
*/

CREATE OR REPLACE VIEW rbal.v_bal_ad_isole AS
SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	(CASE WHEN ad_code IN (SELECT 
	DISTINCT ON (ad_code) a.ad_code
FROM rbal.bal_hsn_point_2154 a, rbal.racco_hsn_linestring_2154 b 
WHERE ST_DWithin(a.geom, b.geom, 0.001) AND ST_LENGTH (b.geom) >= 110) THEN true ELSE false END)  AS ad_isole
FROM rbal.bal_hsn_point_2154 a;