/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 26/06/2018
Objet : Création de la vue v_bal_nom_sro pour calculer le champ nom_sro
Modification : Nom : ///// - Date : date_de_modif - Motif/nature : //////

Sources: psd_orange.zpm_hsn_polygon_2154(za_code_def)/ psd_orange.ref_code_zasro(code_sro_initial)
-------------------------------------------------------------------------------------
*/

CREATE OR REPLACE VIEW rbal.v_bal_nom_sro AS
SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, * 
FROM(
SELECT ad_code, za_code_def as nom_sro, digt_6, digt_7, a.geom  FROM 
rbal.bal_hsn_point_2154 a,  psd_orange.zpm_hsn_polygon_2154 b
LEFT JOIN psd_orange.ref_code_zasro c ON b.za_code = code_sro_initial
WHERE ST_CONTAINS (b.geom, a.geom) )a;