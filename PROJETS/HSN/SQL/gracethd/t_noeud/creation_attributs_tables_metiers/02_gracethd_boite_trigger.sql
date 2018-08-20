
--- Schema : avp_n070gay
--- Table : boite
--- Traitement : Mise à jour des champ code_sro_def, digt_6, digt_7, digt_8, digt_9 à chaque nouvel update ou insert de geom



/*ALTER TABLE avp_n070gay.boite  ADD COLUMN code_sro_def VARCHAR;
ALTER TABLE avp_n070gay.boite  ADD COLUMN code_nro_def VARCHAR;
ALTER TABLE avp_n070gay.boite  ADD COLUMN digt_6 VARCHAR;
ALTER TABLE avp_n070gay.boite  ADD COLUMN digt_7 VARCHAR;
ALTER TABLE avp_n070gay.boite  ADD COLUMN digt_8 VARCHAR;
ALTER TABLE avp_n070gay.boite  ADD COLUMN digt_9 VARCHAR;*/


CREATE OR REPLACE FUNCTION fn_update_code_sro_boite()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN

UPDATE avp_n070gay.boite a
SET code_sro_def=b.za_code_def
FROM psd_orange.zasro_hsn_polygon_2154 b 
WHERE ST_CONTAINS (b.geom, a.geom);

UPDATE avp_n070gay.boite a
SET code_nro_def=b.zanro
FROM psd_orange.zasro_hsn_polygon_2154 b 
WHERE ST_CONTAINS (b.geom, a.geom);

UPDATE avp_n070gay.boite a
SET digt_6=b.digt_6
FROM psd_orange.zasro_hsn_polygon_2154 b 
WHERE ST_CONTAINS (b.geom, a.geom);

UPDATE avp_n070gay.boite a
SET digt_7=b.digt_7
FROM psd_orange.zasro_hsn_polygon_2154 b 
WHERE ST_CONTAINS (b.geom, a.geom);

UPDATE avp_n070gay.boite a
SET digt_8=b.digt_8
FROM psd_orange.zasro_hsn_polygon_2154 b 
WHERE ST_CONTAINS (b.geom, a.geom);

UPDATE avp_n070gay.boite a
SET digt_9=b.digt_9
FROM psd_orange.zasro_hsn_polygon_2154 b 
WHERE ST_CONTAINS (b.geom, a.geom);

