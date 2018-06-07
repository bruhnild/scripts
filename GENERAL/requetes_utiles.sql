GEOMETRIES  


---- passer de 3D à 2D


ALTER TABLE base_bati.bati_rcu_rfu_2016_mfa_update_2_rfu_inte 
  ALTER COLUMN geom TYPE geometry(polygon, 2154) 
    USING ST_Force2D(geom);

-- Passer de 3D à 2D en passant de multi point à point
SELECT ST_Force2D((ST_Dump(wkb_geometry)).geom) as wkb_geometry
FROM tr20.nro;
--- reprojection

ALTER TABLE covage.sirene_geo 
ALTER COLUMN geom 
TYPE Geometry(Point, 2154) 
USING ST_Transform(geom, 2154);

-- mettre à jour la projection

select UpdateGeometrySRID('crcd_livrable', 'nps', 'the_geom', 2154) ;

-- mettre à jour type de geometrie

SELECT populate_geometry_columns('travail.cable'::regclass);

--- corriger la géométrie avec un buffer nul
(SELECT id, type, ST_Multi(ST_Buffer(geom,0))::geometry(MULTIPOLYGON, 2154) FROM travail.invalidgeometry 
WHERE NOT ST_IsValid(geom));

-- lisser la geometrie d'un polygone

select st_buffer(st_buffer(st_buffer(geom, 30), -2), 20)geom, dn
FROM analyse_thematique.heat500_agg4_
;
-- OU
select st_buffer(st_buffer(st_buffer(st_simplify(geom,10), 10), -10), 40)geom, dn
FROM analyse_thematique.heat500_agg4_
;

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

-- préciser type geom 
ALTER TABLE test.tampon_01 ALTER COLUMN geom type geometry(Polygon, 2154);

-- précisez type geom si multi et polygon

ALTER TABLE test.tampon_01 ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);

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

   SELECT 
  g.geom, 
  g.cb_id,
  row_number() over() AS gid,
FROM 
  (SELECT 
     (ST_DUMP(ST_MakeValid (geom))).geom  FROM your_table
  ) AS g
WHERE ST_GeometryType(g.geom) = 'ST_MultiLinestring' 
   OR ST_GeometryType(g.geom) = 'ST_Linestring';



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

--- Savoir si il y a des multi geom

  SELECT COUNT(CASE WHEN ST_NumGeometries(geom) > 1 THEN 1 END) AS multi_geom,
       COUNT(geom) AS total_geom
FROM analyse_thematique.cluster_suf_union;

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


-- OU

  DROP TABLE IF EXISTS tr20_in.cable_linestring_1200007;
CREATE TABLE  tr20_in.cable_linestring_1200007 AS  
SELECT cab_id, ST_LineMerge(ST_Collect(geom)) as geom
FROM tr20_in.cable_linestring
where cab_id = '1200007'
GROUP BY cab_id;

ALTER TABLE tr20_in.cable_linestring_1200007 ALTER COLUMN geom type geometry(Linestring, 2154);

-- connaitre les multilinestring

SELECT 
 result.merge_geom as geom,
 st_geometrytype(merge_geom) as type,
 result.cb_id
FROM
 (SELECT st_astext(st_linemerge(geom)) as merge_geom, st_geometrytype(geom) as type, cb_id FROM temp.CB) AS result
 
WHERE st_geometrytype(merge_geom) = 'ST_MultiLineString';
--- ajouter geometrie centroide/point


SELECT AddGeometryColumn ('heat_map','h2020','centroide',4326,'POINT',2);
UPDATE heat_map.h2020 SET centroide = ST_Centroid(geom);

--- ajouter geometrie centroide/point STRICTEMENT à l'interieur de la parcelle

SELECT AddGeometryColumn ('cadastre','parcelles','centroide',2154,'POINT',2);
UPDATE cadastre.parcelles SET centroide = ST_PointOnSurface(geom);

-------- connaitre le type de geometrie des objects

select ST_GeometryType(geometry)
from table 


--- Précise le type de géométrie de la colonne geom
ALTER TABLE travail.zde
ADD CONSTRAINT enforce_geotype_geom
CHECK (geometrytype(geom) = 'MultiPolygon')


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

-- Difference entre tampon tout pit et tampon 0/1/7 unis
DROP TABLE IF EXISTS test.buffer_difference_01;
CREATE TABLE test.buffer_difference_01 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_01_all b join test.tampon_extract_union_01 a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_01_all b left join temp t on b.gid = t.gid;


--- Découper les lignes en ne gardant que celles à l'intérieur des polygones

drop table if exists test.test ;
create table test.test as 
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.tampon_iti as tpolygone,
    test.emprise as tligne
WHERE
    tpolygone.geom && tligne.geom
AND
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;
--- Indexation spatiale

CREATE INDEX table_name_gix ON table_name USING GIST (geom);
VACUUM ANALYZE table_name
CLUSTER table_name USING table_name_gix;

--- ajouter index attributaire

CREATE INDEX ON table (dpt ASC NULLS LAST);

--- Ajout geom

ALTER TABLE ep.chb ADD COLUMN geom geometry(Point, 2154);

--- Regrouper les géométrie sur un champ

SELECT  
       phase, start_date::int, end_date::int, St_linemerge(ST_Union(geom))  as geom
         FROM energy.pf003_coolingnetwork_kaitak_2016
         GROUP BY phase,  start_date, end_date;


--- Fusion de polygones sur un champ

SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, range_id
FROM 
    analyse.heat_map 
    group by range_id
;

--- Vérifie la correspondance entre le nombre de fourreaux de la couche fourreaux et le champ "TRCH_NB_F" de la couche tranchee
SELECT f.geom as lgfourreaux_geom, t.geom as tranchee_geom, 
count_fourreaux, 
TRCH_NB_F  = count_fourreaux  AS sont_egaux
FROM 
    (SELECT geom, count(0) count_fourreaux 
    FROM travail.lgfourreaux
    GROUP BY geom
    ) as f
JOIN
    travail.tranchee t
ON t.geom = f.geom


-- Index geometrique
CREATE INDEX buffer_difference_01_gix ON test.buffer_difference_01 USING GIST (geom);
ALTER TABLE test.buffer_difference_01 ADD COLUMN gid SERIAL PRIMARY KEY;

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

-- Ajouter nouvelle colonne 
ALTER TABLE pois.osm_2018 ADD COLUMN usage_1 varchar(254);

---- renommer colonne

ALTER TABLE distributors RENAME COLUMN address TO city;

------ ajouter row number

row_number() OVER () AS id

---- ajouter clé primaire


ALTER TABLE building_2d.bati_rouen_metropole_ign2015_2154
  ADD PRIMARY KEY (id);

---- Autoincrémenter clé primaire dans une table existance : 

ALTER TABLE building_2d.bati_rouen_metropole_ign2015_2154 ADD COLUMN gid SERIAL PRIMARY KEY;

--Ajouter clé primaire

ALTER TABLE tr20_out.lgfourreaux
  ADD PRIMARY KEY (lgfx_id);

--- Traitement : Création d'un ogc_fid (alors qu'il existe déjà une clé primaire)

  ALTER TABLE pci70_edigeo_majic.geo_batiment ADD COLUMN ogc_fid integer  
  UPDATE pci70_edigeo_majic.geo_batiment c
    SET ogc_fid = c2.seqnum
    FROM (SELECT c2.*, row_number() over () as seqnum
          FROM pci70_edigeo_majic.geo_batiment c2
         ) c2
    WHERE c2.geo_batiment = c.geo_batiment;

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

----- Connaitre type de caractère dans un champ
SELECT num_deb_fr, SUBSTR(num_deb_fr, 2,1),
    (CASE WHEN ASCII(SUBSTR(num_deb_fr, 2,1)) BETWEEN 48 AND 57 THEN 'chiffre'
      WHEN ASCII(SUBSTR(num_deb_fr, 2,1)) BETWEEN 65 AND 90 THEN 'lettre'
      WHEN ASCII(SUBSTR(num_deb_fr, 2,1)) BETWEEN 97 AND 122 THEN 'lettre'
      ELSE 'autre caractère' END) AS carac
FROM ban.t_ban_travail_arianaville


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

--- selectionner le pourcentage d'aéroport en atitude par état
SELECT 
state, 
100.0 * sum(CASE WHEN elevation >= 2000 THEN 1 ELSE 0 END) / count(*)  as percentage_high_elevation_airports 
FROM airports GROUP BY state;


--- Couper des lignes par des points 

select couche_de_ligne.champ1,couche_de_ligne.champ2,
ST_SNAP((ST_DUMP(st_difference(couche_de_ligne.the_geom,point))).geom,all_point,0.1) as the_geom 
from (select ST_Multi(ST_Union(st_expand(couche_de_point.the_geom, 0.05))) as point from couche_de_point ) as t1, 
couche_de_ligne,(select ST_MULTI(ST_COLLECT(couche_de_point.the_geom))as all_point from couche_de_point) as t2
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

---Find duplicate rows in a table based on values from two fields:

 select * from (
   SELECT id,
   ROW_NUMBER() OVER(PARTITION BY merchant_Id, url ORDER BY id asc) AS Row
   FROM Photos
 ) dups
 where
 dups.Row > 1

---------------------------------- commenter une table/champs

COMMENT ON TABLE chaud.net_deliverypoint IS 'Point de livraison';

COMMENT ON COLUMN chaud.net_deliverypoint.DELIVPT_ID IS 'Identifiant du point de livraison';

---------------------------------------------- trouver le polygone le plus proche du point

SELECT poly.geom, poly.id, points.identifiant
FROM chaud.pf004_heated_batiment_ign_dalkia_mfa_2016_2154 as poly, chaud.pf004_next_sousstationcomplet_dalkia_mfa_2017_2154 as points  
WHERE points.identifiant='{B186C22D-04AC-4AC8-B714-AC4BAB910774}' AND ST_DWithin(poly.geom, points.geom, 1000) 
ORDER BY ST_Distance(poly.geom, points.geom) LIMIT 1;

--- connaitre les doublons (gid) à supprimer

select gid from
(SELECT *, row_number() OVER (PARTITION BY id_geom) as row
FROM(
    SELECT DISTINCT *, LEAST(st_astext(the_geom), st_astext(st_reverse(the_geom))) || '_' || greatest(st_astext(the_geom), st_astext(st_reverse(the_geom))) AS id_geom
    FROM  temp.line as T1
    WHERE  EXISTS (SELECT *
        FROM   temp.line T2
        WHERE  T1.gid <> T2.gid
        AND T1.the_geom && T2.the_geom
        AND  (st_astext(T1.the_geom) = st_astext(T2.the_geom) OR st_astext(T1.the_geom) = st_astext(st_reverse(T2.the_geom)))
        )
    ORDER BY id_geom
    ) as S1
) as S2
where row > 1

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

--- Supprimer doublons lorsque plusieurs entités ont le même id_coord 
--- mais plusieurs mission_moe et supprimer mission_moe = 'Numerisation'
WITH a_supprimer AS
(
SELECT *
FROM dashboard.t_suivi AS num
WHERE num.id_coord  IN 
(SELECT DISTINCT id_coord 
FROM dashboard.t_suivi opp
WHERE num.mission_moe not LIKE  opp.mission_moe and num.mission_moe like 'Numerisation'
GROUP BY id_coord, mission_moe
HAVING num.id_coord=opp.id_coord
))
DELETE FROM dashboard.t_suivi a
USING a_supprimer b
WHERE a.id = b.id
;
--- comparer nombre de champs dans 2 tables

SELECT * FROM tbl_A WHERE champ_a_comparer_tbl_A NOT IN(
   SELECT champ_a_comparer_tbl_B   FROM tbl_B;
);
------------------- connaitre longueur de caractères

SELECT LENGTH('exemple');

---- Creer BDD en UTF8

CREATE DATABASE music ENCODING 'UTF8' TEMPLATE template0;

-- ou 

update pg_database set encoding = pg_char_to_encoding('UTF8') where datname = 'l49'


---import data from a CSV file using the COPY command:

 COPY noise.locations (name, complaint, descript, boro, lat, lon)
 FROM '/Users/chrislhenrick/tutorials/postgresql/data/noise.csv' WITH CSV HEADER;

 --import CSV file into table, only specific columns

\copy <table_name>(<column_1>,<column_1>,<column_1>) FROM '<file_path>' CSV


---create a new table for data from a CSV that has lat and lon columns:

create table noise.locations
(                                     
name varchar(100),
complaint varchar(100), descript varchar(100),
boro varchar(50),
lat float8,
lon float8,
geom geometry(POINT, 4326)
);

---inputing values for the geometry type after loading data from a CSV:
update noise.locations set the_geom = ST_SetSRID(ST_MakePoint(lon, lat), 4326);

--- Export en CSV

SET CLIENT_ENCODING TO 'utf8';
COPY ep.diag_nro
TO 'C:\csv\myfile1.csv' WITH DELIMITER  ';' CSV HEADER ;

--export table, only specific columns, to CSV file

\copy <table_name>(<column_1>,<column_1>,<column_1>) TO '<file_path>' CSV


--Select data within a bounding box
--Using ST_MakeEnvelope

--HINT: You can use bboxfinder.com to easily grab coordinates of a bounding box for a given area.

select ST_Extent(geom) from orange.arciti;

SELECT * FROM some_table
where geom && ST_MakeEnvelope(-73.913891, 40.873781, -73.907229, 40.878251, 4326)

--- Mettre tous les résultats dans une ligne
SELECT   array_agg(un_id_opp.id_opp)
 AS id_opp
FROM     un_id_opp

--- suppression bdd
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'TARGET_DB';

--- vue sur deux tables de deux bases de données differentes

CREATE OR REPLACE VIEW emprises_mobilisables.route_adn_ign_2017_2154 AS 
SELECT t1.id, t1.type, t1.emprise, t1.geom FROM dblink('host=192.168.101.254 port=5432 dbname=reseaux user=postgres password=l0cA!L8:','select id, type, emprise , geom from emprises_mobilisables.route_07_ign_2017_2154')
AS t1(id varchar, type varchar, emprise varchar, geom geometry) 
join dblink('host=192.168.101.254 port=5432 dbname=adn_l49 user=postgres password=l0cA!L8:','select commune, opp, geom from administratif.communes')
AS t2(commune varchar, opp varchar, geom geometry) on st_contains(t2.geom,t1.geom)
where t2.opp is not null 

-- Met à jour le champ url de chambres_a_creer à partir du champurl d'opportunite

CREATE OR REPLACE FUNCTION update_url() RETURNS TRIGGER AS $$
BEGIN
--  IF NEW.url != OLD.url  THEN
    UPDATE coordination.chambres_a_creer a
    SET url=b.url
  FROM coordination.opportunite b 
  WHERE a.id_coord= b.id_opp;
--  END IF;
--  RETURN NEW;
  RETURN NULL;
END;
$$ LANGUAGE 'plpgsql';

DROP TRIGGER IF EXISTS trg_update_url ON coordination.opportunite;
CREATE TRIGGER trg_update_url
AFTER INSERT OR UPDATE OR DELETE ON coordination.opportunite
FOR EACH ROW EXECUTE PROCEDURE update_url();



--- Supprimer table récalcitrante (pid)
SELECT *
  FROM pg_locks l
  JOIN pg_class t ON l.relation = t.oid AND t.relkind = 'r'
 WHERE t.relname = 'numerisation_test';
 
 SELECT pg_cancel_backend('82752');

--- Connaitre la taille de toues les bases de données
 SELECT pg_database.datname, pg_size_pretty(pg_database_size(pg_database.datname)) AS size FROM pg_database;

 --- Supprimer BDD

  SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'adn_l49'
  AND pid <> pg_backend_pid();

  -- suppression de la base de donnée depuis une autre bdd
   drop database adn_l49;