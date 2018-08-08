

--- Schema : avp_n070gay
--- Table : ft_chambre
--- Traitement : Mise à jour du champ nd_creadat à chaque nouvel update ou insert de geom

--ALTER TABLE avp_n070gay.ft_chambre  ADD COLUMN nd_creadat TIMESTAMP;

CREATE OR REPLACE FUNCTION fn_update_creadat_ft_chambre()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN

UPDATE avp_n070gay.ft_chambre 
SET nd_creadat=now();

RETURN NULL;
END;
$$;

DROP TRIGGER IF EXISTS trg_update_creadat_ft_chambre ON avp_n070gay.ft_chambre;
CREATE TRIGGER trg_update_creadat_ft_chambre
AFTER INSERT OR UPDATE OF geom 
ON avp_n070gay.ft_chambre
FOR EACH ROW EXECUTE PROCEDURE fn_update_creadat_ft_chambre ();

--- Schema : avp_n070gay
--- Table : ft_chambre
--- Traitement : Mise à jour des champ code_sro_def, digt_6, digt_7, digt_8, digt_9 à chaque nouvel update ou insert de geom


/*ALTER TABLE avp_n070gay.ft_chambre  ADD COLUMN code_sro_def VARCHAR;
ALTER TABLE avp_n070gay.ft_chambre  ADD COLUMN code_nro_def VARCHAR;
ALTER TABLE avp_n070gay.ft_chambre  ADD COLUMN digt_6 VARCHAR;
ALTER TABLE avp_n070gay.ft_chambre  ADD COLUMN digt_7 VARCHAR;
ALTER TABLE avp_n070gay.ft_chambre  ADD COLUMN digt_8 VARCHAR;
ALTER TABLE avp_n070gay.ft_chambre  ADD COLUMN digt_9 VARCHAR;*/


UPDATE avp_n070gay.ft_chambre a
SET code_sro_def=b.za_code_def
FROM psd_orange.zasro_hsn_polygon_2154 b 
WHERE ST_CONTAINS (b.geom, a.geom);

UPDATE avp_n070gay.ft_chambre a
SET code_nro_def=b.zanro
FROM psd_orange.zasro_hsn_polygon_2154 b 
WHERE ST_CONTAINS (b.geom, a.geom);

UPDATE avp_n070gay.ft_chambre a
SET digt_6=b.digt_6
FROM psd_orange.zasro_hsn_polygon_2154 b 
WHERE ST_CONTAINS (b.geom, a.geom);

UPDATE avp_n070gay.ft_chambre a
SET digt_7=b.digt_7
FROM psd_orange.zasro_hsn_polygon_2154 b 
WHERE ST_CONTAINS (b.geom, a.geom);

UPDATE avp_n070gay.ft_chambre a
SET digt_8=b.digt_8
FROM psd_orange.zasro_hsn_polygon_2154 b 
WHERE ST_CONTAINS (b.geom, a.geom);

UPDATE avp_n070gay.ft_chambre a
SET digt_9=b.digt_9
FROM psd_orange.zasro_hsn_polygon_2154 b 
WHERE ST_CONTAINS (b.geom, a.geom);


