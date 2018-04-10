/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 26/03/2018
Objet : Corriger la géométrie d’une table Postgis
Modification : Nom : ///// - Date : date_de_modif - Motif/nature : //////

-------------------------------------------------------------------------------------
*/

------===============================================------
------= ETAPE 1 : DETECTION D'ERREURS GEOMETRIQUES  =------
------===============================================------

--- Detecter les trois premiers types d'erreurs (geos, geom nulles, collection de géométrie)

SELECT 'non valide' AS nb, count(*) FROM table WHERE NOT ST_IsValid(the_geom)
UNION
SELECT 'geom nulle' AS nb, count(*) FROM table WHERE the_geom is null
UNION
SELECT 'collection' AS nb, count(*) FROM table WHERE not ST_IsValid(the_geom)
AND ST_GeometryType(ST_MakeValid(the_geom))='ST_GeometryCollection';


--- Detecter les erreurs geos

SELECT id, ST_IsValidReason(the_geom) FROM table WHERE NOT ST_IsValid(the_geom);

------====================================------
------= ETAPE 2 : CORRECTION DES ERREURS =------
------====================================------

--- Correction des erreurs geos avec la fonction St_MakeValid

UPDATE table SET the_geom = ST_MakeValid(the_geom) WHERE NOT ST_IsValid(the_geom);

--- Correction des collections de géométrie en les transformant en multi-polygones

UPDATE table
SET the_geom =
ST_Multi(ST_Simplify(ST_Multi(ST_CollectionExtract(ST_ForceCollection(ST_MakeValid(the_geom)),3)),0))
WHERE ST_GeometryType(the_geom) = 'ST_GeometryCollection';


--- Correction des géométrie nulles

DELETE FROM table WHERE the_geom IS NULL;

--- Suppression des noeuds en double

UPDATE table SET the_geom = ST_Multi(ST_Simplify(the_geom,0));

------===============================================------
------= ETAPE 3 : DETECTION D'ERREURS GEOMETRIQUES  =------
------===============================================------

--- Detecter les trois premiers types d'erreurs (geos, geom nulles, collection de géométrie)

SELECT 'non valide' AS nb, count(*) FROM table WHERE NOT ST_IsValid(the_geom)
UNION
SELECT 'geom nulle' AS nb, count(*) FROM table WHERE the_geom is null
UNION
SELECT 'collection' AS nb, count(*) FROM table WHERE not ST_IsValid(the_geom)
AND ST_GeometryType(ST_MakeValid(the_geom))='ST_GeometryCollection';

------=================================================------
------= ETAPE 4 : CORRECTION DES ERREURS PERSISTANTES =------
------=================================================------

--- Créatino d'un buffer nul

UPDATE table SET the_geom = ST_Multi(ST_Buffer(the_geom,0)) WHERE NOT ST_IsValid(the_geom));