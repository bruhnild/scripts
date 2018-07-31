
--- Schema : rbal
--- Table : liaison_hsn_linestring_2154
--- Traitement : Mise à jour du champ id_voie à chaque nouvelle liaison de liaison_voie

CREATE OR REPLACE FUNCTION fn_update_liaison_voie_id_voie()
RETURNS trigger AS
$func$
BEGIN

UPDATE rbal.liaison_voie_hsn_linestring_2154 a
SET    id_voie=geo_id
FROM   (SELECT geo_zoncommuni as geo_id, tex, geom FROM 
(WITH nom_voie_majic AS
(SELECT 
	geo_zoncommuni, 
	tex, 
	geom
FROM pci70_edigeo_majic.geo_zoncommuni
WHERE tex IS NOT NULL 

UNION ALL 

SELECT 
  nom_route.geo_tronroute, 
  nom_route.tex, 
  nom_route.geom
FROM
   pci70_edigeo_majic.geo_tronroute as nom_route
WHERE
  nom_route.geo_tronroute NOT IN 
  (
    SELECT 
      route.geo_tronroute
    FROM 
      pci70_edigeo_majic.geo_tronroute as route,
      pci70_edigeo_majic.geo_zoncommuni as voie
    WHERE 
      ST_Intersects(voie.geom,route.geom)
  ) )
SELECT * FROM nom_voie_majic)a) b
WHERE ST_DWithin(a.geom, b.geom, 0.1) ;

RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_liaison_voie_id_voie ON rbal.liaison_voie_hsn_linestring_2154;
DROP TRIGGER IF EXISTS trg_update_liaison_voie_id_voie ON pci70_edigeo_majic.geo_zoncommuni;
DROP TRIGGER IF EXISTS trg_update_liaison_voie_id_voie ON pci70_edigeo_majic.geo_tronroute;
CREATE TRIGGER trg_update_liaison_voie_id_voie
AFTER INSERT OR UPDATE OF geom
ON rbal.liaison_voie_hsn_linestring_2154
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_liaison_voie_id_voie();

--- Schema : rbal
--- Table : liaison_hsn_linestring_2154
--- Traitement : Mise à jour du champ ad_code dans la table liaison_voie à chaque nouvelle liaison 

CREATE OR REPLACE FUNCTION fn_update_liaison_voie_ad_code()
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

DROP TRIGGER IF EXISTS trg_update_liaison_voie_ad_code ON rbal.liaison_voie_hsn_linestring_2154;
DROP TRIGGER IF EXISTS trg_update_liaison_voie_ad_code ON rbal.bal_hsn_point_2154;
CREATE TRIGGER trg_update_liaison_voie_ad_code
AFTER INSERT OR UPDATE OF geom
ON rbal.liaison_voie_hsn_linestring_2154
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_liaison_voie_ad_code();

--- Schema : rbal
--- Table : liaison_hsn_linestring_2154
--- Traitement : Mise à jour du champ nomvoie dans la table liaison_voie à chaque nouvelle liaison 

CREATE OR REPLACE FUNCTION fn_update_liaison_voie_nomvoie()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.liaison_voie_hsn_linestring_2154 a
SET    nomvoie=tex
FROM   (SELECT geo_zoncommuni as geo_id, tex, geom FROM 
(WITH nom_voie_majic AS
(SELECT 
	geo_zoncommuni, 
	tex, 
	geom
FROM pci70_edigeo_majic.geo_zoncommuni
WHERE tex IS NOT NULL 

UNION ALL 

SELECT 
  nom_route.geo_tronroute, 
  nom_route.tex, 
  nom_route.geom
FROM
   pci70_edigeo_majic.geo_tronroute as nom_route
WHERE
  nom_route.geo_tronroute NOT IN 
  (
    SELECT 
      route.geo_tronroute
    FROM 
      pci70_edigeo_majic.geo_tronroute as route,
      pci70_edigeo_majic.geo_zoncommuni as voie
    WHERE 
      ST_Intersects(voie.geom,route.geom)
  ) )
SELECT * FROM nom_voie_majic)a)  b
WHERE ST_DWithin(a.geom, b.geom, 0.1) ;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_liaison_voie_nomvoie ON rbal.liaison_voie_hsn_linestring_2154;
DROP TRIGGER IF EXISTS trg_update_liaison_voie_nomvoie ON pci70_edigeo_majic.geo_zoncommuni;
DROP TRIGGER IF EXISTS trg_update_liaison_voie_nomvoie ON pci70_edigeo_majic.geo_tronroute;
CREATE TRIGGER trg_update_liaison_voie_nomvoie
AFTER INSERT OR UPDATE OF geom
ON rbal.liaison_voie_hsn_linestring_2154
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_liaison_voie_nomvoie();