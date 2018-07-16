

--- Schema : rbal
--- Table : liaison_hsn_linestring_2154
--- Traitement : Mise à jour du champ ad_code dans la table liaison_voie_sanspci à chaque nouvelle liaison 

CREATE OR REPLACE FUNCTION fn_update_liaison_voie_sanspci_ad_code()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.liaison_voie_sanspci_hsn_linestring_2154 a
SET    ad_code=b.ad_code
FROM   rbal.bal_hsn_point_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.1) ;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_liaison_voie_sanspci_ad_code ON rbal.liaison_voie_sanspci_hsn_linestring_2154;
DROP TRIGGER IF EXISTS trg_update_liaison_voie_sanspci_ad_code ON rbal.bal_hsn_point_2154;
CREATE TRIGGER trg_update_liaison_voie_sanspci_ad_code
AFTER INSERT OR UPDATE OF geom
ON rbal.liaison_voie_sanspci_hsn_linestring_2154
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_liaison_voie_sanspci_ad_code();

--- Schema : rbal
--- Table : liaison_hsn_linestring_2154
--- Traitement : Mise à jour du champ lieu_dit dans la table liaison_voie_sanspci à chaque nouvelle liaison 

CREATE OR REPLACE FUNCTION fn_update_liaison_voie_sanspci_lieu_dit()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.liaison_voie_sanspci_hsn_linestring_2154 a
SET    lieu_dit=b.lieu_dit
FROM   rbal.noeud_voie_sanspci_hsn_point_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.1) ;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_liaison_voie_sanspci_lieu_dit ON rbal.liaison_voie_sanspci_hsn_linestring_2154;
DROP TRIGGER IF EXISTS trg_update_liaison_voie_sanspci_lieu_dit ON rbal.bal_hsn_point_2154;
CREATE TRIGGER trg_update_liaison_voie_sanspci_lieu_dit
AFTER INSERT OR UPDATE OF geom
ON rbal.liaison_voie_sanspci_hsn_linestring_2154
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_liaison_voie_sanspci_lieu_dit();

--- Schema : rbal
--- Table : liaison_hsn_linestring_2154
--- Traitement : Mise à jour du champ nomvoie dans la table liaison_voie_sanspci à chaque nouvelle liaison 

CREATE OR REPLACE FUNCTION fn_update_liaison_voie_sanspci_nomvoie()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.liaison_voie_sanspci_hsn_linestring_2154 a
SET    nomvoie=b.nomvoie
FROM   rbal.noeud_voie_sanspci_hsn_point_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.1) ;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_liaison_voie_sanspci_nomvoie ON rbal.liaison_voie_sanspci_hsn_linestring_2154;
DROP TRIGGER IF EXISTS trg_update_liaison_voie_sanspci_nomvoie ON rbal.bal_hsn_point_2154;
CREATE TRIGGER trg_update_liaison_voie_sanspci_nomvoie
AFTER INSERT OR UPDATE OF geom
ON rbal.liaison_voie_sanspci_hsn_linestring_2154
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_liaison_voie_sanspci_nomvoie();