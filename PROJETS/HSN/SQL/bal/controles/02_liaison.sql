CREATE OR REPLACE VIEW psd_orange.v_locaux_hsn_sian_zanro_point_2154 AS
SELECT ROW_NUMBER() OVER(ORDER BY liaison_id) gid, * 
FROM(	
WITH locaux_liaison AS
(SELECT a.id, a.geom, a.objectid, b.liaison_id
FROM psd_orange.locaux_hsn_sian_zanro_point_2154 AS a, rbal.liaison_hsn_linestring_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.1))
SELECT   COUNT(liaison_id) AS nbr_doublon, liaison_id, geom
FROM     locaux_liaison
GROUP BY liaison_id, geom
HAVING   COUNT(*) > 1)a
;


--- Schema : rbal
--- Table : liaison_hsn_linestring_2154
--- Traitement : Mise à jour du champ id_locaux à chaque nouvelle liaison


CREATE OR REPLACE FUNCTION fn_update_id_locaux()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.liaison_hsn_linestring_2154 a
SET    id_locaux=id
FROM   psd_orange.locaux_hsn_sian_zanro_point_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.1) ;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_id_locaux ON rbal.liaison_hsn_linestring_2154;
DROP TRIGGER IF EXISTS trg_update_id_locaux ON psd_orange.locaux_hsn_sian_zanro_point_2154;
CREATE TRIGGER trg_update_id_locaux
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.liaison_hsn_linestring_2154
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_id_locaux();

--- Schema : rbal
--- Table : liaison_hsn_linestring_2154
--- Traitement : Mise à jour du champ id_ban à chaque nouvelle liaison

CREATE OR REPLACE FUNCTION fn_update_id_ban()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.liaison_hsn_linestring_2154 a
SET    id_ban=id
FROM   ban.hsn_point_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.1) ;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_id_ban ON rbal.liaison_hsn_linestring_2154;
DROP TRIGGER IF EXISTS trg_update_id_ban ON ban.hsn_point_2154;
CREATE TRIGGER trg_update_id_ban
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.liaison_hsn_linestring_2154
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_id_ban();


