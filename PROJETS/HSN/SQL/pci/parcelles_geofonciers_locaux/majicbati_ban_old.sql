/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 14/06/2018
Projet : RIP - MOE 70 - HSN
Objet : Geotraitements sur la donnée MAJIC/EDIGEO pour affecter un id_ban par batiment
Modification : Nom : ///// - Date : date_de_modif - Motif/nature : //////

CCONLC = Nature du local (local10)
DTELOC = Type de local (local10)
CCONAD  = Nature de dépendances (pev)
CCOAFF = Affectation de PEV (pev)
CCOAPE= Code NAF pour les locaux professionnels (local10)
CCONAC = Code NACE pour les locaux professionnels (local10)
JANNAT = Année de construction (local10)
DNBNIV = Nombre de niveau de la constructi (local10)
DSUPOT = Surface pondérée du local (local10)
DNATPR = Code nature de personne physique ou morale (proprietaire)
CCOGRM = Code groupe de personne morale (proprietaire)

-------------------------------------------------------------------------------------
*/

--- Schema : pci70_majic_analyses
--- Vue : voie_parcelle_hsn_polygon_2154
--- Traitement : Crée une table de parcelles qui ont un local

DROP TABLE IF EXISTS pci70_majic_analyses.voie_parcelle_hsn_polygon_2154 ;
CREATE TABLE pci70_majic_analyses.voie_parcelle_hsn_polygon_2154 AS
WITH voie_parcelle AS
(SELECT 
  DISTINCT ON (parcelle) parcelle, 
  a.voie,  
  concat (b.ccodep, b.ccocom,'_',
  b.ccoriv, b.clerivili) AS fant_voie_majic, 
  b.ccodep, b.ccocom, b.ccoriv, b.clerivili,b.natvoi, b.libvoi, b.codvoi, b.typvoi, 
  c.geom
  FROM pci70_edigeo_majic.local00 AS a
  LEFT JOIN pci70_edigeo_majic.voie b ON a.voie=b.voie
  LEFT JOIN pci70_edigeo_majic.geo_parcelle c ON a.parcelle=c.geo_parcelle )
  SELECT DISTINCT ON (parcelle) parcelle, 
  voie, -- nom de voie du local
  fant_voie_majic, -- fant_voie qui fera la correspondance avec le champ fant_voie de la ban
  ccodep, ccocom, ccoriv, clerivili, natvoi,libvoi,codvoi,typvoi, 
  geom -- geometrie de la parcelle
  FROM voie_parcelle
  WHERE geom IS NOT NULL ;

--- Schema : pci70_majic_analyses
--- Vue : batiment_parcelle_hsn_polygon_2154
--- Traitement : Positionne un batiment (surface max) par parcelle

DROP TABLE IF EXISTS pci70_majic_analyses.batiment_parcelle_hsn_polygon_2154;
CREATE TABLE pci70_majic_analyses.batiment_parcelle_hsn_polygon_2154 as 
WITH max_area_bati_parcelle AS
(SELECT geo_parcelle, surface
FROM
(WITH max_area_bati AS
(SELECT a.geo_batiment, ST_Area(geom) as surface , b.geo_parcelle
FROM pci70_edigeo_majic.geo_batiment a
LEFT JOIN pci70_edigeo_majic.geo_batiment_parcelle b ON a.geo_batiment=b.geo_batiment
ORDER BY ST_Area(geom))
SELECT  max_area_bati.geo_parcelle, max(surface) as surface FROM max_area_bati
GROUP BY geo_parcelle)a)
SELECT max_area_bati_parcelle.geo_parcelle,bati_parcelle_geom.geo_batiment, voie, fant_voie_majic, ccodep, ccocom, ccoriv, clerivili, natvoi, libvoi, codvoi, typvoi,bati_parcelle_geom.geo_dur, bati_parcelle_geom.geom, max_area_bati_parcelle.surface::int FROM max_area_bati_parcelle
LEFT JOIN
(SELECT geo_parcelle, geo_batiment, geo_dur, geom
FROM
(WITH bati_parcelle_geom AS
(SELECT DISTINCT ON (b.geo_batiment)b.geo_batiment, c.geo_dur, a.*, c.geom
FROM max_area_bati_parcelle a
LEFT JOIN pci70_edigeo_majic.geo_batiment_parcelle  b ON a.geo_parcelle=b.geo_parcelle
LEFT JOIN pci70_edigeo_majic.geo_batiment c ON b.geo_batiment=c.geo_batiment AND a.surface=ST_Area(c.geom)) 
SELECT * FROM bati_parcelle_geom)a)bati_parcelle_geom ON max_area_bati_parcelle.geo_parcelle=bati_parcelle_geom.geo_parcelle 
INNER JOIN pci70_majic_analyses.voie_parcelle_hsn_polygon_2154 AS  voie_parcelle ON voie_parcelle.parcelle=max_area_bati_parcelle.geo_parcelle;

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
LEFT JOIN ban.hsn_point_2154 b on a.fant_voie_majic=b.fant_voie and b.numero=c.tex

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