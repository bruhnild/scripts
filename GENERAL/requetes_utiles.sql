GEOMETRIES  


---- passer de 3D à 2D


ALTER TABLE base_bati.bati_rcu_rfu_2016_mfa_update_2_rfu_inte 
  ALTER COLUMN geom TYPE geometry(polygon, 2154) 
    USING ST_Force2D(geom);

--- reprojection

ALTER TABLE covage.sirene_geo 
ALTER COLUMN geom 
TYPE Geometry(Point, 2154) 
USING ST_Transform(geom, 2154);

-- mettre à jour la projection

select UpdateGeometrySRID('crcd_livrable', 'nps', 'the_geom', 2154) ;

--- corriger la géométrie avec un buffer nul
(SELECT id, type, ST_Multi(ST_Buffer(geom,0))::geometry(MULTIPOLYGON, 2154) FROM travail.invalidgeometry 
WHERE NOT ST_IsValid(geom));

--- corriger la géométrie avec la simplification à zero
update 
travail.invalidgeometry
SET 
geom= st_multi(st_simplify(ST_Multi(ST_CollectionExtract(ST_ForceCollection(ST_MakeValid(geom)),3)),0)) 
WHERE ST_GeometryType(geom) = 'ST_MultiPolygon':

-- Table à part des géométries non-valides
CREATE TABLE nyc_neighborhoods_invalid AS
SELECT * FROM nyc_neighborhoods
WHERE NOT ST_IsValid(the_geom);

-- Suppression de la table principale
DELETE FROM nyc_neighborhoods
WHERE NOT ST_IsValid(the_geom);

UPDATE public.mytable
SET geom=cleangeometry(geom);

ALTER TABLE public.mytable  ALTER COLUMN geom SET DATA TYPE geometry;

UPDATE public.valid_mytable
SET geom=ST_MakeValid(geom);

If you only want Polygons or Multipolygons from ST_MakeValid you can use ST_Dump 
to extract the constituent geometries and then test for the geometry type. 
ST_MakeValid will sometimes produce Points or LineStrings which is where the GeometryCollection is coming from: 

SELECT 
  g.geom, 
  row_number() over() AS gid,
FROM 
  (SELECT 
     (ST_DUMP(ST_MakeValid (geom))).geom FROM your_table
  ) AS g
WHERE ST_GeometryType(g.geom) = 'ST_MultiPolygon' 
   OR ST_GeometryType(g.geom) = 'ST_Polygon';


You can try ST_CollectionExtract to extract [Multi]Polygons from GeometryCollections. Use ST_Multi to force them as MuliPolygon:

   UPDATE public.valid_lcmsouthshapefilemulti collection
  SET geom=ST_Multi(ST_CollectionExtract(ST_MakeValid(geom), 3))
  WHERE NOT ST_IsValid(geom);

------ passer de polygone à multipolygone 


INSERT INTO entree_est.heatmap35 ( geom )
       SELECT ST_Multi( geom )  FROM entree_est.heatmap35 ;

       -- passer de multipolygon à polygones 


CREATE TABLE  chaud.bati AS                       --poly will be the new polygon table
WITH dump AS (
    SELECT   gid, id, id_source, hauteur, source_hau, elevation, source_ele, 
       start_date, sce_sdate, end_date, sce_edate, desti_dom, source_dd, 
       date_modif, type_modif, source_mod, source,                      --columns from your multipolygon table 
      (ST_DUMP(geom)).geom AS geom 
    FROM chaud.bati                             --the name of your multipolygon table
) 
SELECT gid, id, id_source, hauteur, source_hau, elevation, source_ele, 
       start_date, sce_sdate, end_date, sce_edate, desti_dom, source_dd, 
       date_modif, type_modif, source_mod, source, 
  geom::geometry(Polygon,2154)         --type cast using SRID from multipolygon
FROM dump;


--- passer de point à multi point 

ALTER TABLE orange_ms2.ft_chambre_toulaud
    ALTER COLUMN wkb_geometry TYPE geometry(MultiPoint,2154) USING ST_Multi(wkb_geometry);

----- préciser le type de géométrie

SELECT objectid as id, tram, ligne, start_date,s_date, end_date,e_date, source, geom::geometry(multilinestring, 2154)
  FROM public_transport.pf004_tram_metropolerouen_mfa_2016_2154;

--- connaitre le nombre de multiligne dans la table

SELECT COUNT(
CASE WHEN ST_NumGeometries(the_geom) > 1 THEN 1 END
) AS multi, COUNT(the_geom) AS total
FROM ways;
---- Passer de multistring à LineString

ALTER TABLE chaud.route
ALTER COLUMN geom TYPE geometry(linestring,2154) USING ST_GeometryN(geom, 1);




--- ajouter geometrie centroide/point


SELECT AddGeometryColumn ('heat_map','h2020','centroide',4326,'POINT',2);
UPDATE heat_map.h2020 SET centroide = ST_Centroid(geom);

ALTER TABLE heat_map.h2020
DROP COLUMN geom;

-------- connaitre le type de geometrie des objects

select ST_GeometryType(geometry)
from table 

------- Clustering within a threshold distance with ST_ClusterWithin


drop table if exists test.cluster;
create table test.cluster as 
SELECT row_number() over () AS id,
  ST_NumGeometries(gc),
  gc AS geom_collection,
  ST_Centroid(gc) AS centroid,
  ST_MinimumBoundingCircle(gc) AS circle,
  sqrt(ST_Area(ST_MinimumBoundingCircle(gc)) / pi()) AS radius
FROM (
  SELECT unnest(ST_ClusterWithin(geom, 10)) gc
  FROM test.bati_2326
) f;


--- Ajout des noeuds de début et fin du réseau

SELECT AddGeometryColumn ('chatuzange','ft_arc_iti','start_point',2154,'POINT',2);
UPDATE chatuzange.ft_arc_iti SET start_point = ST_StartPoint(geom);
SELECT AddGeometryColumn ('chatuzange','ft_arc_iti','end_point',2154,'POINT',2);
UPDATE chatuzange.ft_arc_iti SET end_point = ST_EndPoint(geom);

--- les lignes 

ST_Length(geometry) retourne la longueur d’une ligne
ST_StartPoint(geometry) retourne le premier point d’une ligne
ST_EndPoint(geometry) retourne le dernier point d’une ligne
ST_NPoints(geometry) retourne le nombre de points dans une ligne
----- selectionner des éléments qui ne s'intersectent pas 

CREATE table t_intersect AS
SELECT 
  hp.gid, 
  hp.st_address, 
  hp.city, 
  hp.st_num,
  hp.the_geom
FROM
  public.housepoints as hp
WHERE
  hp.gid NOT IN 
  (
    SELECT 
      h.gid
    FROM 
      public.parcel as p,
      public.housepoints as h
    WHERE 
      ST_Intersects(h.the_geom,p.the_geom)
  ) AS foo

--- ajouter index geom

CREATE INDEX index on table USING GIST (geom) ;

--- ajouter index attributaire

CREATE INDEX ON table (dpt ASC NULLS LAST);

--- Ajout geom

ALTER TABLE ep.chb ADD COLUMN geom geometry(Point, 2154);

--- Regrouper les géométrie sur un champ

SELECT  
       phase, start_date::int, end_date::int, St_linemerge(ST_Union(geom))  as geom
         FROM energy.pf003_coolingnetwork_kaitak_2016
         GROUP BY phase,  start_date, end_date;


------ ajouter une colomne

ALTER TABLE entree_est.vector15
ADD start_date integer ;
update entree_est.vector15 set start_date = 2015 where start_date is null;

------- changer le type d'un champ

 ALTER TABLE maquette_procedurale.bati ALTER COLUMN tx_width TYPE float USING (tx_width::float);
 -- OU --


update
  eau.eau_conso_commune_2010
set
  pop_float = cast(pop as double precision),


----- Arrondir valeur de champ à 2 décimales

  
ALTER TABLE entree_est.out_pjtentreeest_bati_bg
    ALTER COLUMN puiss_tot TYPE numeric(10, 2)
    USING (puiss_tot::numeric(10, 2));

--- modifier valeur dans une table


update referentiel.pf001_programmationurbaine_mlyon_3946 set type_pu = 'nc' where type_pu is null;

---- renommer colonne

ALTER TABLE distributors RENAME COLUMN address TO city;

------ ajouter row number

row_number() OVER () AS id

---- ajouter clé primaire


ALTER TABLE building_2d.bati_rouen_metropole_ign2015_2154
  ADD PRIMARY KEY (id);

---- Autoincrémenter clé primaire dans une table existance : 

ALTER TABLE building_2d.bati_rouen_metropole_ign2015_2154 ADD COLUMN gid SERIAL PRIMARY KEY;


----- Remplacer ',' par '-'


UPDATE building_2d.bati_4326
SET zone = REPLACE(zone, ',' , ' -')


UPDATE covage.points_techniques_renommage 
SET    codcov = (CASE 
    WHEN idtroncon LIKE 'A_S8' THEN REPLACE(code_cov, 'CH-413', 'CH-320')
    WHEN idtroncon LIKE 'S8' THEN REPLACE(code_cov, 'CH-413', 'CH-108')
    WHEN idtroncon LIKE 'S7' THEN REPLACE(code_cov, 'CH-413', 'CH-107')
    WHEN idtroncon LIKE 'R28' THEN REPLACE(code_cov, 'CH-413', 'CH-228')
    END);

----- Mettre à jour table selon un champ avec un case when/else

UPDATE covage.points_techniques_renommage
SET idtroncon = (CASE id_tronc
              WHEN 'LCR1' THEN 'A_S8'
        ELSE id_tronc
              END);

-- connaitre objet en commun entre deux tables
SELECT brand FROM new_products

INTERSECT

SELECT brand FROM legacy_products;

-- connaitre les objets uniques entre les deux tables
SELECT category FROM new_products

EXCEPT

SELECT category FROM legacy_products;

---- Prend les deux dernières valeurs du champ

SELECT RIGHT(code_cb, 2), code_cb
from covage.cables_renommage;

--- Prend toutes les valeurs avant le Ø 
SELECT compositio, substr(compositio,0 ,(strpos(compositio,'Ø'))) AS bidule FROM ep_ms2.infra_ms2 GROUP BY compositio, bidule ORDER BY compositio, bidule ;
--- Prend toutes les valeurs avant 'Ciment:'' ou 'PEHD:''
SELECT compositio, substr(compositio,8 ,(strpos(compositio,'Ciment:'))) AS bidule FROM ep_ms2.infra_ms2 GROUP BY compositio, bidule ORDER BY compositio, bidule ;
SELECT compositio, substr(compositio,6 ,(strpos(compositio,'PEHD:'))) AS bidule FROM ep_ms2.infra_ms2 GROUP BY compositio, bidule ORDER BY compositio, bidule ;

----- Mettre à jour une table dans une sélection (polygones) avec le champs d'une table tierce (points) par intersection géométrique.


UPDATE polygones as a 
SET nature = b.nature
FROM points as b 

WHERE ST_Intersects(a.geom,b.geom)


------ lister toutes les tables d'un schema

SELECT * FROM information_schema.tables 
WHERE table_schema = 'balaruc'



---- supprimer ligne par rapport à lignes d'une autre table

DELETE FROM majic_sete.usage_local110_pev01_cconac o
USING (
    SELECT o2.cconac
    FROM majic_sete.usage_local110_pev01_cconac o2
    LEFT JOIN cconac t ON t.a732 = o2.cconac
    WHERE t.a732 IS NULL
    ) sq
WHERE sq.cconac = o.cconac
    ;

----- insertion de valeur d'une table A vers table B

/* city_objects */
INSERT INTO schema1.city_objects (
   uid,
   object_id,
   city_object_type,
   validity_range,
   deleted,
   geometry,
   data,
   source_key,
   app_data,
   tags
)
SELECT
   uid,
   object_id,
   city_object_type,
   validity_range,
   deleted,
   geometry,
   data,
   source_key,
   app_data,
   tags
FROM schema2.city_objects
;
------------------- trouver les doublons

    SELECT   COUNT(identifiant_all) AS nbr_doublon, identifiant_all
FROM     chaud.sous_station_potentielle_all
GROUP BY identifiant_all
HAVING   COUNT(*) > 1

---------------------------------- commenter une table/champs

COMMENT ON TABLE chaud.net_deliverypoint IS 'Point de livraison';

COMMENT ON COLUMN chaud.net_deliverypoint.DELIVPT_ID IS 'Identifiant du point de livraison';

---------------------------------------------- trouver le polygone le plus proche du point

SELECT poly.geom, poly.id, points.identifiant
FROM chaud.pf004_heated_batiment_ign_dalkia_mfa_2016_2154 as poly, chaud.pf004_next_sousstationcomplet_dalkia_mfa_2017_2154 as points  
WHERE points.identifiant='{B186C22D-04AC-4AC8-B714-AC4BAB910774}' AND ST_DWithin(poly.geom, points.geom, 1000) 
ORDER BY ST_Distance(poly.geom, points.geom) LIMIT 1;

--- Supprimer doublons 

DELETE FROM ep.diag_nro
WHERE classement IN (
  SELECT 
   classement
    FROM (
      SELECT 
       classement,
       ROW_NUMBER() OVER (partition BY chambre_a, chambre_b ORDER BY classement) AS rnum
        FROM ep.diag_nro) t
        WHERE t.rnum > 1);

--- comparer nombre de champs dans 2 tables

SELECT * FROM tbl_A WHERE champ_a_comparer_tbl_A NOT IN(
   SELECT champ_a_comparer_tbl_B   FROM tbl_B;
);
------------------- connaitre longueur de caractères

SELECT LENGTH('exemple');

---- Creer BDD en UTF8

CREATE DATABASE music ENCODING 'UTF8' TEMPLATE template0;

--- Export en CSV

SET CLIENT_ENCODING TO 'utf8';
COPY ep.diag_nro
TO 'C:\csv\myfile1.csv' WITH DELIMITER  ';' CSV HEADER ;