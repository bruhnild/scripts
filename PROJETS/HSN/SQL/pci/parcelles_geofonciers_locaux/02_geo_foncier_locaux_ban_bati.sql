/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 14/06/2018
Projet : RIP - MOE 70 - HSN
Objet : Geotraitements sur la donnée MAJIC/EDIGEO pour affecter un id_ban par batiment
Modification : Nom : ///// - Date : date_de_modif - Motif/nature : //////

-------------------------------------------------------------------------------------
*/

--- Schema : pci70_majic_analyses
--- Vue : voie_parcelle_hsn_polygon_2154
--- Traitement : Crée une table de parcelles qui ont un local

DROP TABLE IF EXISTS pci70_majic_analyses.voie_parcelle_hsn_polygon_2154 ;
CREATE TABLE pci70_majic_analyses.voie_parcelle_hsn_polygon_2154 AS
WITH voie_parcelle AS
(SELECT 
  DISTINCT ON (parcelle) a.parcelle, 
  a.voie,  
  concat (b.ccodep, b.ccocom,'_', b.ccoriv, b.clerivili) AS fant_voie_majic, b.ccodep, b.ccocom, b.ccoriv, b.clerivili,b.natvoi, b.libvoi, b.codvoi, b.typvoi, 
  c.idu, c.nlocmaison, c.nlocappt, c.nlochabit, c.nlocdep, c.nloccom, c.nloccomrdc, c.tlocdomin, c.nlocal, c.noccprop, c.nocclocat, c.nlocsaison, c.nvacant, c.nresec,c.geom
  FROM pci70_edigeo_majic.local00 AS a
  LEFT JOIN pci70_edigeo_majic.voie b ON a.voie=b.voie
  LEFT JOIN pci70_majic_analyses.parcelle_geo_foncier_locaux c ON a.parcelle=c.parcelle )
  SELECT DISTINCT ON (parcelle) parcelle, -- Clé parcelle
  idu -- Identifiant parcelle
  ccodep, -- Code de département
  ccocom, -- Code commune
  voie, -- Clé voie
  fant_voie_majic, -- fant_voie pour faire la correspondance avec le champ fant_voie de la ban
  natvoi,-- Nature de voie
  libvoi, -- Libellé de voie
  codvoi, -- Code identifiant la voie
  typvoi,  -- Type de voie
  ccoriv, -- Code voie Rivoli
  clerivili, -- Clé Rivoli
  nlocmaison, -- Nombre de locaux de type maison
  nlocappt, -- Nombre de locaux de type appartement
  nlochabit, -- Nombre de locaux de type maison ou appartement
  nlocdep, -- Nombre de locaux de type dépendances
  nloccom, -- Nombre de locaux de type commercial ou industriel
  nloccomrdc, -- Nombre de locaux de type commercial ou industriel situés au rezdechaussée
  tlocdomin, -- Type de local dominant sur la parcelle (en nombre)
  nlocal,  -- Nombre de locaux
  noccprop, -- Nombre de logements occupés par un propriétaire
  nocclocat, -- Nombre de logements occupés par un locataire
  nlocsaison, -- Nombre de logements meublés destinés à la location occasionnelle ou saisonnière
  nvacant, -- Nombre de logements vacants
  nresec,-- Estimation du nombre de résidences secondaires
  geom -- Géométrie de la parcelle
  FROM voie_parcelle
  WHERE geom IS NOT NULL ;


--- Schema : pci70_majic_analyses
--- Vue : batiment_parcelle_hsn_polygon_2154
--- Traitement : Positionne un batiment (surface max) par parcelle

DROP TABLE IF EXISTS pci70_majic_analyses.batiment_parcelle_hsn_polygon_2154;
CREATE TABLE pci70_majic_analyses.batiment_parcelle_hsn_polygon_2154 as 
WITH bati_parcelle AS
(SELECT geo_parcelle
FROM
(WITH bati AS
(SELECT a.geo_batiment, b.geo_parcelle
FROM pci70_edigeo_majic.geo_batiment a
LEFT JOIN pci70_edigeo_majic.geo_batiment_parcelle b ON a.geo_batiment=b.geo_batiment
ORDER BY ST_Area(geom))
SELECT  bati.geo_parcelle  FROM bati
GROUP BY geo_parcelle)a)
SELECT 
bati_parcelle.geo_parcelle,
bati_parcelle_geom.geo_batiment, 
voie_parcelle.voie, 
voie_parcelle.fant_voie_majic, 
voie_parcelle.ccodep, 
voie_parcelle.ccocom, 
voie_parcelle.ccoriv, 
voie_parcelle.clerivili, 
voie_parcelle.natvoi, 
voie_parcelle.libvoi, 
voie_parcelle.codvoi, 
voie_parcelle.typvoi,
bati_parcelle_geom.geo_dur, 
bati_parcelle_geom.geom 
FROM bati_parcelle
LEFT JOIN
(SELECT geo_parcelle, geo_batiment, geo_dur, geom
FROM
(WITH bati_parcelle_geom AS
(SELECT DISTINCT ON (b.geo_batiment)b.geo_batiment, c.geo_dur, a.*, c.geom
FROM bati_parcelle a
LEFT JOIN pci70_edigeo_majic.geo_batiment_parcelle  b ON a.geo_parcelle=b.geo_parcelle
LEFT JOIN pci70_edigeo_majic.geo_batiment c ON b.geo_batiment=c.geo_batiment) 
SELECT * FROM bati_parcelle_geom)a)bati_parcelle_geom ON bati_parcelle.geo_parcelle=bati_parcelle_geom.geo_parcelle 
INNER JOIN pci70_majic_analyses.voie_parcelle_hsn_polygon_2154 AS  voie_parcelle ON voie_parcelle.parcelle=bati_parcelle.geo_parcelle;

--- Schema : pci70_majic_analyses
--- Vue : numvoie_parcelle_hsn_point_2154
--- Traitement : Fais le lien entre les numéros de voie et les numeros de parcelles

DROP TABLE IF EXISTS pci70_majic_analyses.numvoie_parcelle_hsn_point_2154 ;
CREATE TABLE pci70_majic_analyses.numvoie_parcelle_hsn_point_2154 AS
WITH numvoie_parcelle AS
(SELECT DISTINCT ON (a.geo_numvoie)a.geo_numvoie, b.geo_parcelle, tex, geom
  FROM pci70_edigeo_majic.geo_numvoie AS a
  LEFT JOIN pci70_edigeo_majic.geo_numvoie_parcelle AS b ON a.geo_numvoie=b.geo_numvoie
  GROUP BY a.geo_numvoie, b.geo_parcelle)
  SELECT * FROM numvoie_parcelle;

--- Schema : pci70_majic_analyses
--- Vue : batiment_parcelle_ban_hsn_polygon_2154
--- Traitement : Affecte l'id_ban et le numero de voie à chaque batiment (14% des batiments concernés ont une id_ban)


DROP TABLE IF EXISTS pci70_majic_analyses.batiment_parcelle_ban_hsn_polygon_2154 ;
CREATE TABLE pci70_majic_analyses.batiment_parcelle_ban_hsn_polygon_2154 AS
SELECT DISTINCT ON (geo_batiment) geo_batiment,a.geo_parcelle,  voie, fant_voie_majic, ccodep, ccocom, ccoriv, 
clerivili, natvoi, libvoi, codvoi, typvoi, geo_dur, c.tex, b.rep, b.id as ban_id, a.geom
FROM pci70_majic_analyses.batiment_parcelle_hsn_polygon_2154 as a
LEFT JOIN pci70_majic_analyses.numvoie_parcelle_hsn_point_2154 c ON a.geo_parcelle=c.geo_parcelle 
LEFT JOIN ban.hsn_point_2154 b on a.fant_voie_majic=b.fant_voie and b.numero=c.tex;

--- Schema : rbal
--- Vue : segment_ban_bati_hsn_linestring_2154
--- Traitement : Création de segments entre les points ban et centroides de bati en fonction de ban_id (id ban)


CREATE OR REPLACE VIEW rbal.segment_ban_bati_hsn_linestring_2154 AS 
SELECT 
  row_number() OVER (ORDER BY sub_query.ban_id) AS fid,
    sub_query.ban_id,
    ST_Makeline(sub_query.geom_ban, sub_query.geom_adresse) AS geom
  FROM(
  SELECT 
    ban.id as ban_id,
    (ST_Dump(ban.geom)).geom as geom_ban, 
    bati.ban_id as bati_ban_id,
     (ST_Dump(ST_POINTONSURFACE(bati.geom))).geom geom_adresse
  FROM 
    ban.hsn_point_2154 as ban,
    pci70_majic_analyses.batiment_parcelle_ban_hsn_polygon_2154 as bati
  WHERE 
    ban.id = bati.ban_id) AS sub_query;