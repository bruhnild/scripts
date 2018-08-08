--- Schema : rbal
--- Table : bal_hsn_point_2154
--- Traitement : Mise à jour du champ nom_sro à chaque nouvelle bal


CREATE OR REPLACE FUNCTION fn_update_bal_nom_sro()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.bal_hsn_point_2154 a
SET nom_sro = b.za_code_def
FROM psd_orange.zasro_hsn_polygon_2154 b
WHERE ST_CONTAINS (b.geom, a.geom) ;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_bal_nom_sro ON rbal.bal_hsn_point_2154;
CREATE TRIGGER trg_update_bal_nom_sro
AFTER INSERT OR UPDATE OF geom
ON rbal.bal_hsn_point_2154
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_bal_nom_sro();



