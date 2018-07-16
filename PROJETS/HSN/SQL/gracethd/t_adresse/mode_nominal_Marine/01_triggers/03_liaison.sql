--- Schema : rbal
--- Table : liaison_hsn_linestring_2154
--- Traitement : Mise à jour du champ id_locaux à chaque nouvelle liaison


CREATE OR REPLACE FUNCTION fn_update_liaison_id_locaux()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.liaison_hsn_linestring_2154 a
SET    id_locaux=id
FROM   psd_orange.locaux_hsn_sian_zanro_point_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.001) ;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_liaison_id_locaux ON rbal.liaison_hsn_linestring_2154;
DROP TRIGGER IF EXISTS trg_update_liaison_id_locaux ON psd_orange.locaux_hsn_sian_zanro_point_2154;
CREATE TRIGGER trg_update_liaison_id_locaux
AFTER INSERT OR UPDATE OF geom
ON rbal.liaison_hsn_linestring_2154
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_liaison_id_locaux();

--- Schema : rbal
--- Table : liaison_hsn_linestring_2154
--- Traitement : Mise à jour du champ id_ban à chaque nouvelle liaison

CREATE OR REPLACE FUNCTION fn_update_liaison_id_ban()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.liaison_hsn_linestring_2154 a
SET    id_ban=id
FROM   ban.hsn_point_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.001) ;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_liaison_id_ban ON rbal.liaison_hsn_linestring_2154;
DROP TRIGGER IF EXISTS trg_update_liaison_id_ban ON ban.hsn_point_2154;
CREATE TRIGGER trg_update_liaison_id_ban
AFTER INSERT OR UPDATE OF geom
ON rbal.liaison_hsn_linestring_2154
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_liaison_id_ban();

--- Schema : rbal
--- Table : liaison_hsn_linestring_2154
--- Traitement : Mise à jour du champ ad_code à chaque nouvelle liaison

CREATE OR REPLACE FUNCTION fn_update_liaison_ad_code()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.liaison_hsn_linestring_2154 a
SET    ad_code=b.ad_code
FROM   rbal.bal_hsn_point_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.001) ;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_liaison_ad_code ON rbal.liaison_hsn_linestring_2154;
DROP TRIGGER IF EXISTS trg_update_liaison_ad_code ON rbal.bal_hsn_point_2154;
CREATE TRIGGER trg_update_liaison_ad_code
AFTER INSERT OR UPDATE OF geom
ON rbal.liaison_hsn_linestring_2154
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_liaison_ad_code();
