
--- Schema : rbal
--- Table : liaison_hsn_linestring_2154
--- Traitement : Mise à jour du champ id_voie à chaque nouvelle liaison de liaison_voie

CREATE OR REPLACE FUNCTION fn_update_liaisonvoie_id_voie()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.liaison_voie_hsn_linestring_2154 a
SET    id_voie=geo_zoncommuni
FROM   pci70_edigeo_majic.geo_zoncommuni b
WHERE ST_DWithin(a.geom, b.geom, 0.1) ;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_liaisonvoie_id_voie ON rbal.liaison_voie_hsn_linestring_2154;
DROP TRIGGER IF EXISTS trg_update_liaisonvoie_id_voie ON ci70_edigeo_majic.geo_zoncommuni;
CREATE TRIGGER trg_update_liaisonvoie_id_voie
AFTER INSERT OR UPDATE OF geom
ON rbal.liaison_voie_hsn_linestring_2154
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_liaisonvoie_id_voie();

--- Schema : rbal
--- Table : liaison_hsn_linestring_2154
--- Traitement : Mise à jour du champ ad_code dans la table liaison_voie à chaque nouvelle liaison 

CREATE OR REPLACE FUNCTION fn_update_liaisonvoie_ad_code()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.liaison_voie_hsn_linestring_2154 a
SET    ad_code=b.ad_code
FROM   rbal.bal_hsn_point_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.1) ;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_liaisonvoie_ad_code ON rbal.liaison_voie_hsn_linestring_2154;
DROP TRIGGER IF EXISTS trg_update_liaisonvoie_ad_code ON rbal.bal_hsn_point_2154;
CREATE TRIGGER trg_update_liaisonvoie_ad_code
AFTER INSERT OR UPDATE OF geom
ON rbal.liaison_voie_hsn_linestring_2154
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_liaisonvoie_ad_code();

--- Schema : rbal
--- Table : liaison_hsn_linestring_2154
--- Traitement : Mise à jour du champ nomvoie dans la table liaison_voie à chaque nouvelle liaison 

CREATE OR REPLACE FUNCTION fn_update_liaisonvoie_nomvoie()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.liaison_voie_hsn_linestring_2154 a
SET    nomvoie=tex
FROM   pci70_edigeo_majic.geo_zoncommuni b
WHERE  id_voie=geo_zoncommuni;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_liaisonvoie_nomvoie ON rbal.liaison_voie_hsn_linestring_2154;
DROP TRIGGER IF EXISTS trg_update_liaisonvoie_nomvoie ON ci70_edigeo_majic.geo_zoncommuni;
CREATE TRIGGER trg_update_liaisonvoie_nomvoie
AFTER INSERT OR UPDATE OF geom
ON rbal.liaison_voie_hsn_linestring_2154
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_liaisonvoie_nomvoie();