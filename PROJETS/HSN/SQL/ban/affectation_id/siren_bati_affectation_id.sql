ALTER TABLE ban.batiments_hsn_polygon_2154
ADD COLUMN sirene_gid numeric[];

WITH tmp AS
-- requête qui permet de prendre le premier point sirène le plus proche de chaque bâtiment
(
SELECT sirene.siren AS s_gid, t.bat_id, t.dist
FROM sirene.geo_sirene_hsn_point_2154 as sirene
CROSS JOIN LATERAL
-- requête qui permet de récupérer la distance la plus proche entre Sirène et bâti
(SELECT bati.id AS bat_id, st_distance(bati.geom, sirene.geom) AS dist
FROM ban.batiments_hsn_polygon_2154 as bati
ORDER BY sirene.geom <-> bati.geom
LIMIT 1) AS t
WHERE sirene.geo_type LIKE 'housenumber' OR sirene.geo_type LIKE 'interpolation' OR sirene.geo_type LIKE 'street'
),
-- requête qui permet de créer un identifiant partitionné par identifiant bâti de la distance la plus petite à la plus grande
tmp1 AS 
(
SELECT t.*, ROW_NUMBER() OVER (PARTITION BY t.bat_id ORDER BY t.dist ) AS rn
FROM tmp AS t
),
-- requête qui permet d'aggréger les identifiants sirene sous forme de liste
tmp2 AS
(
SELECT tmp1.bat_id, array_agg(tmp1.s_gid) as s_gid_agg
FROM tmp1
GROUP BY tmp1.bat_id
)
-- requête qui permet de mettre à jour l'identifiant de la base Sirène dans la couche sur l'ensemble bâti
UPDATE ban.batiments_hsn_polygon_2154 as bati
SET sirene_gid = tmp2.s_gid_agg
FROM tmp2, tmp1
WHERE tmp2.bat_id = bati.id AND tmp1.bat_id=bati.id AND tmp1.rn = 1;
