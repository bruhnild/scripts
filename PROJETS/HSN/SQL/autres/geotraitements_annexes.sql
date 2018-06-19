/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 08/06/2018
Projet : RIP - MOE 70 - HSN
Objet : Geotraitements annexes
Modification : Nom : ///// - Date : date_de_modif - Motif/nature : //////

-------------------------------------------------------------------------------------
*/

/*
-------------------------------------------------------------------------------------
CREATION SEGMENTS BAL-RBAL
-------------------------------------------------------------------------------------
*/

--- Schema : ban
--- Vue : communes_non_cadastrees_osm_hsn_polygon_2154
--- Traitement : Creation d'une table avec les communes (osm) non cadastrées par rapport aux fichiers edigeo

DROP TABLE IF EXISTS ban.communes_non_cadastrees_osm_hsn_polygon_2154 ;
CREATE TABLE ban.communes_non_cadastrees_osm_hsn_polygon_2154 AS
SELECT DISTINCT ON (c.id) id, c.insee, c.geom
FROM
 ban.nat_osm_2018_2154  as c
WHERE
  c.id NOT IN 
  (
    SELECT 
      a.id
    FROM 
       ban.nat_osm_2018_2154 as a,
       pci70_edigeo_majic.geo_commune as b
    WHERE 
     ST_CONTAINS (a.geom, ST_PointOnSurface(b.geom))
  ) ;