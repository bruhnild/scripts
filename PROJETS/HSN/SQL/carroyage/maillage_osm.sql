/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 05/06/2017
Objet : Formatage et numérotation des tables de grilles 1/2000 et 1/500
Modification : Nom : // - Date : // - Motif/nature : //
-------------------------------------------------------------------------------------
*/


--- Schema : rbal
--- Table : grille_2000_polygon_2154
--- Traitement : Formatage de la table grille 1/2000 

DROP TABLE IF EXISTS rbal.grille_2000_polygon_2154;
CREATE TABLE rbal.grille_2000_polygon_2154 AS 
WITH commune AS
-- choisi la surface maximale de commune intersectée par chaque grille
(SELECT DISTINCT ON (a.gid)
a.*,b.insee as commune,
(st_area(st_intersection(a.geom, b.geom))/st_area(a.geom)) AS proportion
FROM rbal.grille_2000_polygon_2154_old a, osm.communes_hsn_multipolygon_2154 b
LEFT JOIN osm.communes_hsn_multipolygon_2154 c ON b.insee=c.insee
WHERE st_intersects(a.geom, b.geom) 
ORDER BY a.gid, proportion DESC)
SELECT row_number() over () AS gid, concat(ligne, '_',colonne) AS id_grille, commune.ligne, commune.colonne, za_code, commune, nb_batis AS nb_bati, nb_local, commune.geom FROM commune
LEFT JOIN
(SELECT gid, za_code
FROM
(WITH zpm AS
-- choisi la surface maximale de zapm intersectée par chaque grille
(SELECT DISTINCT ON (a.gid)
a.*,za_code,
(st_area(st_intersection(a.geom, b.geom))/st_area(a.geom)) AS proportion
FROM rbal.grille_2000_polygon_2154_old a, psd_orange.zpm_hsn_polygon_2154 b
WHERE st_intersects(a.geom, b.geom) 
ORDER BY a.gid, proportion DESC)
SELECT * FROM zpm)a)zpm ON zpm.gid=commune.gid
LEFT JOIN
(SELECT gid, a.nb_batis
FROM
(WITH bati AS
-- compte le nombre de bati (centroide) contenus dans chaque grille
(SELECT DISTINCT ON (a.gid)
a.*,
COUNT(st_centroid(b.geom)) AS nb_batis
FROM rbal.grille_2000_polygon_2154_old a, pci70_edigeo_majic.geo_batiment b
WHERE st_intersects(a.geom, b.geom) 
GROUP BY a.gid)
SELECT * FROM bati)a)bati ON bati.gid=commune.gid
LEFT JOIN
(SELECT gid, a.nb_local
 FROM
(WITH locaux AS
-- compte le nombre de locaux (centroide) contenus dans chaque grille
(SELECT DISTINCT ON (a.gid)
a.*,
COUNT(st_centroid(b.geom)) AS nb_local
FROM rbal.grille_2000_polygon_2154_old a, psd_orange.locaux_hsn_sian_zanro_point_2154 b
WHERE st_intersects(a.geom, b.geom) 
GROUP BY a.gid)
SELECT * FROM locaux)a)locaux ON locaux.gid=commune.gid;


ALTER TABLE rbal.grille_2000_polygon_2154  ADD PRIMARY KEY (id_grille);
CREATE INDEX grille_2000_polygon_2154_gix ON rbal.grille_2000_polygon_2154 USING GIST (geom);


--- Schema : rbal
--- Table : grille_500_polygon_2154
--- Traitement : Formatage de la table grille 1/500

DROP TABLE IF EXISTS rbal.grille_500_polygon_2154;
CREATE TABLE rbal.grille_500_polygon_2154 AS 
WITH commune AS
-- choisi la surface maximale de commune intersectée par chaque grille
(SELECT DISTINCT ON (a.gid)
a.*,b.insee AS commune,
(st_area(st_intersection(a.geom, b.geom))/st_area(a.geom)) AS proportion
FROM rbal.grille_500_polygon_2154_old a, osm.communes_hsn_multipolygon_2154 b
LEFT JOIN osm.communes_hsn_multipolygon_2154 c ON b.insee=c.insee
WHERE st_intersects(a.geom, b.geom) 
ORDER BY a.gid, proportion DESC)
SELECT  row_number() over () AS gid, id_grille AS id_grille_2000, concat(id_grille,'_',compteurs) AS id_grille, compteurs,  za_code, commune, nb_batis AS nb_bati, nb_local, NULL::varchar AS impression, commune.geom FROM commune
LEFT JOIN
(SELECT gid, id_grille, compteurs
FROM
(WITH id_grille_2000 AS
-- récupère l'id_grille de la table grille_2000_polygon_2154 et crée une séquence jusqu'à 16 pour chaque grille au 1/500 par grille au 1/2000
(SELECT DISTINCT ON (a.gid)
a.*,
b.id_grille,
row_number() OVER (PARTITION BY b.id_grille ORDER BY a.gid) AS compteurs 
FROM rbal.grille_500_polygon_2154_old a, rbal.grille_2000_polygon_2154 b
WHERE st_intersects(st_buffer(a.geom,-5), b.geom) 
GROUP BY a.gid, id_grille )
SELECT * FROM id_grille_2000)a)id_grille_2000 ON id_grille_2000.gid=commune.gid
LEFT JOIN 
(SELECT gid, za_code
FROM
(WITH zpm AS
-- choisi la surface maximale de zapm intersectée par chaque grille
(SELECT DISTINCT ON (a.gid)
a.*,za_code,
(st_area(st_intersection(a.geom, b.geom))/st_area(a.geom)) AS proportion
FROM rbal.grille_500_polygon_2154_old a, psd_orange.zpm_hsn_polygon_2154 b
WHERE st_intersects(a.geom, b.geom) 
ORDER BY a.gid, proportion DESC)
SELECT * FROM zpm)a)zpm ON zpm.gid=commune.gid
LEFT JOIN
(SELECT gid, a.nb_batis
FROM
(WITH bati AS
-- compte le nombre de bati (centroide) contenus dans chaque grille
(SELECT DISTINCT ON (a.gid)
a.*,
COUNT(st_centroid(b.geom)) AS nb_batis
FROM rbal.grille_500_polygon_2154_old a, pci70_edigeo_majic.geo_batiment b
WHERE st_intersects(a.geom, b.geom) 
GROUP BY a.gid)
SELECT * FROM bati)a)bati ON bati.gid=commune.gid
LEFT JOIN
(SELECT gid, a.nb_local
 FROM
(WITH locaux AS
-- compte le nombre de locaux (centroide) contenus dans chaque grille
(SELECT DISTINCT ON (a.gid)
a.*,
COUNT(st_centroid(b.geom)) AS nb_local
FROM rbal.grille_500_polygon_2154_old a, psd_orange.locaux_hsn_sian_zanro_point_2154 b
WHERE st_intersects(a.geom, b.geom) 
GROUP BY a.gid)
SELECT * FROM locaux)a)locaux ON locaux.gid=commune.gid;


ALTER TABLE rbal.grille_500_polygon_2154  ADD PRIMARY KEY (id_grille);
CREATE INDEX grille_500_polygon_2154_gix ON rbal.grille_500_polygon_2154 USING GIST (geom);

