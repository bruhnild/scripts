/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 2/06/2018
Objet : Création de la vue matérialisée intermédiaire au format gracethd (calcul des champs)
Modification : Nom : ///// - Date : date_de_modif - Motif/nature : //////

-------------------------------------------------------------------------------------
*/


--- Schema : rbal
--- Vue : vm_bal_columns_gracethdview
--- Traitement : Crée la vue vm_bal_columns_gracethdview à partir de jointures (cf I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\vues)


DROP MATERIALIZED VIEW IF EXISTS rbal.vm_bal_columns_gracethdview CASCADE;
CREATE MATERIALIZED VIEW rbal.vm_bal_columns_gracethdview AS

SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, *
FROM
(
WITH columns_gracethdview AS
(SELECT 
  DISTINCT ON (ad_code) a.ad_code,
  ad_racc,
  ad_nombat, 
  NULL::varchar as ad_comment, 
  ad_creadat, 
  (CASE WHEN ad_nblhab IS NOT NULL THEN ad_nblhab ELSE 0 END)::int as ad_nblhab,
  (CASE WHEN ad_nblpro IS NOT NULL THEN ad_nblpro ELSE 0 END)::int ad_nblpro,
  (CASE WHEN ad_nblhab IS NOT NULL THEN ad_nblhab ELSE 0 END)::int as ad_nbprhab,
  (CASE WHEN ((CASE WHEN ad_nblhab IS NOT NULL THEN ad_nblhab ELSE 0 END)+ad_nblpro)>=3 THEN 'I' ELSE 'P' END)::varchar as ad_itypeim,
  (CASE WHEN a.construction ='En construction' THEN TRUE ELSE NULL END)::boolean as ad_imneuf,
  insee,
  nom,
  nom_sro,
  st_x(a.geom) as x,
  st_y(a.geom) as y,
  a.geom
FROM rbal.bal_hsn_point_2154 a, osm.communes_hsn_multipolygon_2154 b 
WHERE ST_CONTAINS (b.geom, a.geom))
SELECT 
  columns_gracethdview.ad_code,
  j.ad_ban_id,
  k.ad_nomvoie,
  m.ad_rep,
  r.ad_numero,
  n.ad_nom_ld,
  l.ad_fantoir,
  o.ad_idpar,
  o.ad_x_parc,
  o.ad_y_parc,
  columns_gracethdview.ad_racc,
  columns_gracethdview.ad_nombat, 
  columns_gracethdview.ad_comment, 
  columns_gracethdview.ad_creadat, 
  columns_gracethdview.insee as ad_insee,
  columns_gracethdview.nom as ad_commune, 
  b.code_postal as ad_postal, 
  columns_gracethdview.ad_nblhab,
  columns_gracethdview.ad_nblpro,
  columns_gracethdview.ad_nbprhab, 
  c.ad_nbprpro,
  f.potentiel_ftte,
  g.nom_pro,
  g.typologie_pro,
  h.nom_id,
  i.statut,
  e.nb_prises_totale,
  q.ad_distinf,
  d.ad_isole,
  columns_gracethdview.ad_imneuf,
  columns_gracethdview.ad_itypeim,
  columns_gracethdview.nom_sro,
  t.digt_6,
  t.digt_7,
  t.digt_8,
  t.digt_9,
  columns_gracethdview.x,
  columns_gracethdview.y,
  p.ad_x_ban,
  p.ad_y_ban,
  columns_gracethdview.geom
FROM columns_gracethdview
LEFT JOIN la_poste.codcom_codpost_correspondance_hsn_2017 b ON columns_gracethdview.insee=b.code_commune_insee
LEFT JOIN  rbal.v_bal_ad_nbprpro c ON columns_gracethdview.ad_code = c.ad_code
LEFT JOIN  rbal.v_bal_ad_isole d ON columns_gracethdview.ad_code = d.ad_code
LEFT JOIN  rbal.v_bal_nb_prises_totale e ON columns_gracethdview.ad_code = e.ad_code
LEFT JOIN  rbal.v_bal_potentiel_ftte f ON columns_gracethdview.ad_code = f.ad_code
LEFT JOIN  rbal.v_ctrl_bal_ftth_ftte g ON columns_gracethdview.ad_code = g.ad_code
LEFT JOIN  rbal.v_bal_nom_id h ON columns_gracethdview.ad_code = h.ad_code
LEFT JOIN  rbal.v_bal_statut i ON columns_gracethdview.ad_code = i.ad_code 
LEFT JOIN  rbal.v_bal_ad_ban_id j ON columns_gracethdview.ad_code = j.ad_code 
LEFT JOIN  rbal.v_bal_ad_nomvoie k ON columns_gracethdview.ad_code = k.ad_code 
LEFT JOIN  rbal.v_bal_ad_fantoir l ON columns_gracethdview.ad_code = l.ad_code 
LEFT JOIN  rbal.v_bal_ad_rep  m ON columns_gracethdview.ad_code = m.ad_code 
LEFT JOIN  rbal.v_bal_ad_nom_ld  n ON columns_gracethdview.ad_code = n.ad_code 
LEFT JOIN  rbal.v_bal_ad_idpar_x_y  o ON columns_gracethdview.ad_code = o.ad_code 
LEFT JOIN  rbal.v_bal_ad_ban_x_y  p ON columns_gracethdview.ad_code = p.ad_code 
LEFT JOIN  rbal.v_bal_ad_distinf q ON columns_gracethdview.ad_code = q.ad_code 
LEFT JOIN  rbal.v_bal_ad_numero r ON columns_gracethdview.ad_code = r.ad_code 
--LEFT JOIN  rbal.v_bal_geom s ON columns_gracethdview.ad_code = s.ad_code
LEFT JOIN  rbal.v_bal_nom_sro t ON columns_gracethdview.ad_code = t.ad_code)a;


CREATE INDEX vm_bal_columns_gracethdview_gix ON rbal.vm_bal_columns_gracethdview USING GIST (geom);



--- Schema : rbal
--- Vue : vm_bal_columns_gracethdview
--- Traitement : le trigger qui va raffraichir la vue vm_bal_columns_gracethdview à chaque nouvelle entité de bal


CREATE OR REPLACE FUNCTION fn_refresh_vm_bal_columns_gracethdview() 
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW rbal.vm_bal_columns_gracethdview;
  RETURN NULL;
END; $$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_refresh_vm_bal_columns_gracethdview ON rbal.vm_bal_columns_gracethdview;
DROP TRIGGER IF EXISTS trg_refresh_vm_bal_columns_gracethdview ON rbal.bal_hsn_point_2154;
CREATE TRIGGER trg_refresh_vm_bal_columns_gracethdview 
AFTER INSERT OR UPDATE OF geom
ON rbal.bal_hsn_point_2154
FOR EACH ROW 
EXECUTE PROCEDURE fn_refresh_vm_bal_columns_gracethdview();