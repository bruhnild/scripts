--- Schema : rbal
--- Table : racco_hsn_linestring_2154
--- Traitement : Mise à jour du champ ad_ban_id à chaque nouveau racco

CREATE OR REPLACE FUNCTION fn_update_racco_ad_ban_id()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.racco_hsn_linestring_2154 a
SET    ad_ban_id=id
FROM   ban.hsn_point_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.1) ;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_racco_ad_ban_id ON rbal.racco_hsn_linestring_2154;
DROP TRIGGER IF EXISTS trg_update_racco_ad_ban_id ON ban.hsn_point_2154;
CREATE TRIGGER trg_update_racco_ad_ban_id
AFTER INSERT OR UPDATE OF geom
ON rbal.racco_hsn_linestring_2154
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_racco_ad_ban_id();