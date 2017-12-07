/*
-- Ecraser la 3D
ALTER TABLE test.line
ALTER COLUMN geom TYPE geometry(MultilineString, 2154) 
USING ST_Force2D(geom);

-- Multilinestring en linestring

UPDATE test.line
SET geom=ST_Multi(ST_CollectionExtract(ST_MakeValid(geom), 3))
WHERE NOT ST_IsValid(geom);


-- Validation de la geom
UPDATE test.line
SET geom=ST_MakeValid(geom);

-- Splitter la donnée par département

DROP TABLE IF EXISTS test.line_03;
CREATE TABLE test.line_03 AS
SELECT gid, objectid, a.id, type, shape_leng, emprise, a.geom
  FROM test.line as a
 JOIN  test.departements as b
 ON ST_CONTAINS (b.geom , a.geom)
WHERE code_dept like '03';

DROP TABLE IF EXISTS test.line_63;
CREATE TABLE test.line_63 AS
SELECT gid, objectid, a.id, type, shape_leng, emprise, a.geom
  FROM test.line as a
 JOIN  test.departements as b
 ON ST_CONTAINS (b.geom , a.geom)
WHERE code_dept like '63';

DROP TABLE IF EXISTS test.line_42;
CREATE TABLE test.line_42 AS
SELECT gid, objectid, a.id, type, shape_leng, emprise, a.geom
  FROM test.line as a
 JOIN  test.departements as b
 ON ST_CONTAINS (b.geom , a.geom)
WHERE code_dept like '42';

DROP TABLE IF EXISTS test.line_15;
CREATE TABLE test.line_15 AS
SELECT gid, objectid, a.id, type, shape_leng, emprise, a.geom
  FROM test.line as a
 JOIN  test.departements as b
 ON ST_CONTAINS (b.geom , a.geom)
WHERE code_dept like '15';

DROP TABLE IF EXISTS test.line_43;
CREATE TABLE test.line_43 AS
SELECT gid, objectid, a.id, type, shape_leng, emprise, a.geom
  FROM test.line as a
 JOIN  test.departements as b
 ON ST_CONTAINS (b.geom , a.geom)
WHERE code_dept like '43';

DROP TABLE IF EXISTS test.line_26;
CREATE TABLE test.line_26 AS
SELECT gid, objectid, a.id, type, shape_leng, emprise, a.geom
  FROM test.line as a
 JOIN  test.departements as b
 ON ST_CONTAINS (b.geom , a.geom)
WHERE code_dept like '26';


DROP TABLE IF EXISTS test.line_07;
CREATE TABLE test.line_07 AS
SELECT gid, objectid, a.id, type, shape_leng, emprise, a.geom
  FROM test.line as a
 JOIN  test.departements as b
 ON ST_CONTAINS (b.geom , a.geom)
WHERE code_dept like '07';


DROP TABLE IF EXISTS test.line_38;
CREATE TABLE test.line_38 AS
SELECT gid, objectid, a.id, type, shape_leng, emprise, a.geom
  FROM test.line as a
 JOIN  test.departements as b
 ON ST_CONTAINS (b.geom , a.geom)
WHERE code_dept like '38';

DROP TABLE IF EXISTS test.line_69;
CREATE TABLE test.line_69 AS
SELECT gid, objectid, a.id, type, shape_leng, emprise, a.geom
  FROM test.line as a
 JOIN  test.departements as b
 ON ST_CONTAINS (b.geom , a.geom)
WHERE code_dept like '69';


DROP TABLE IF EXISTS test.line_01;
CREATE TABLE test.line_01 AS
SELECT gid, objectid, a.id, type, shape_leng, emprise, a.geom
  FROM test.line as a
 JOIN  test.departements as b
 ON ST_CONTAINS (b.geom , a.geom)
WHERE code_dept like '01';

DROP TABLE IF EXISTS test.line_73;
CREATE TABLE test.line_73 AS
SELECT gid, objectid, a.id, type, shape_leng, emprise, a.geom
  FROM test.line as a
 JOIN  test.departements as b
 ON ST_CONTAINS (b.geom , a.geom)
WHERE code_dept like '73';


DROP TABLE IF EXISTS test.line_74;
CREATE TABLE test.line_74 AS
SELECT gid, objectid, a.id, type, shape_leng, emprise, a.geom
  FROM test.line as a
 JOIN  test.departements as b
 ON ST_CONTAINS (b.geom , a.geom)
WHERE code_dept like '74';


-- Index geometrique des lignes

CREATE INDEX line_74_gix ON test.line_74 USING GIST (geom);
CREATE INDEX line_03_gix ON test.line_03 USING GIST (geom);
CREATE INDEX line_63_gix ON test.line_63 USING GIST (geom);
CREATE INDEX line_42_gix ON test.line_42 USING GIST (geom);
CREATE INDEX line_15_gix ON test.line_15 USING GIST (geom);
CREATE INDEX line_43_gix ON test.line_43 USING GIST (geom);
CREATE INDEX line_26_gix ON test.line_26 USING GIST (geom);
CREATE INDEX line_73_gix ON test.line_73 USING GIST (geom);
CREATE INDEX line_07_gix ON test.line_07 USING GIST (geom);
CREATE INDEX line_38_gix ON test.line_38 USING GIST (geom);
CREATE INDEX line_69_gix ON test.line_69 USING GIST (geom);
CREATE INDEX line_01_gix ON test.line_01 USING GIST (geom);

-- Mise à jour champ emprise avec valeur 'GC_A_CREER'

UPDATE test.line_01 set emprise = 'GC_A_CREER';
UPDATE test.line_03 set emprise = 'GC_A_CREER';
UPDATE test.line_63 set emprise = 'GC_A_CREER';
UPDATE test.line_42 set emprise = 'GC_A_CREER';
UPDATE test.line_15 set emprise = 'GC_A_CREER';
UPDATE test.line_43 set emprise = 'GC_A_CREER';
UPDATE test.line_26 set emprise = 'GC_A_CREER';
UPDATE test.line_07 set emprise = 'GC_A_CREER';
UPDATE test.line_38 set emprise = 'GC_A_CREER';
UPDATE test.line_69 set emprise = 'GC_A_CREER';
UPDATE test.line_73 set emprise = 'GC_A_CREER';
UPDATE test.line_74 set emprise = 'GC_A_CREER';

-- Validation geom des pit

UPDATE test.arciti_01
SET geom=ST_MakeValid(geom);
UPDATE test.arciti_03
SET geom=ST_MakeValid(geom);
UPDATE test.arciti_63
SET geom=ST_MakeValid(geom);
UPDATE test.arciti_42
SET geom=ST_MakeValid(geom);
UPDATE test.arciti_15
SET geom=ST_MakeValid(geom);
UPDATE test.arciti_43
SET geom=ST_MakeValid(geom);
UPDATE test.arciti_26
SET geom=ST_MakeValid(geom);
UPDATE test.arciti_07
SET geom=ST_MakeValid(geom);
UPDATE test.arciti_38
SET geom=ST_MakeValid(geom);
UPDATE test.arciti_69
SET geom=ST_MakeValid(geom);
UPDATE test.arciti_73
SET geom=ST_MakeValid(geom);
UPDATE test.arciti_74
SET geom=ST_MakeValid(geom);

*/
-- Tampon avec mode de pose 0/1/7
DROP TABLE IF EXISTS test.tampon_02;
CREATE TABLE test.tampon_02 as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 30) as geom
FROM test.arciti
where mode_pose like '0' or mode_pose like '1' or mode_pose like '7';
-- Index geom
CREATE INDEX tampon_02_gix ON test.tampon_02 USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_02 ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);

-- Tampon avec mode de pose 0
DROP TABLE IF EXISTS test.tampon_02_ibloaerien;
CREATE TABLE test.tampon_02_ibloaerien as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 30) as geom
FROM test.arciti
where mode_pose like '0' ;
-- Index geom
CREATE INDEX tampon_02_ibloaerien_gix ON test.tampon_02_ibloaerien USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_02_ibloaerien ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);

-- Tampon avec mode de pose 1
DROP TABLE IF EXISTS test.tampon_02_enedisaerien;
CREATE TABLE test.tampon_02_enedisaerien as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 30) as geom
FROM test.arciti
where mode_pose like '1' ;
-- Index geom
CREATE INDEX tampon_02_enedisaerien_gix ON test.tampon_02_enedisaerien USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_02_enedisaerien ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);

-- Tampon avec mode de pose 7
DROP TABLE IF EXISTS test.tampon_02_iblosout;
CREATE TABLE test.tampon_02_iblosout as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 30) as geom
FROM test.arciti
where mode_pose like '7' ;
-- Index geom
CREATE INDEX tampon_02_iblosout_gix ON test.tampon_02_iblosout USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_02_iblosout ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);


-- Tampon avec tous modes de pose 
DROP TABLE IF EXISTS test.tampon_02_all;
CREATE TABLE test.tampon_02_all as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 30) as geom
FROM test.arciti;
-- Index geometrique
CREATE INDEX tampon_02_all_gix ON test.tampon_02_all USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_02_all ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);


-- Union des tampons 0/1/7 en un polygone 
DROP TABLE if exists test.tampon_extract_union_02  ;
CREATE TABLE test.tampon_extract_union_02 as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_02
;
-- Index geometrique
CREATE INDEX tampon_extract_union_02_gix ON test.tampon_extract_union_02 USING GIST (geom);


-- Union des tampons 0 en un polygone 
DROP TABLE if exists test.tampon_extract_union_02_ibloaerien  ;
CREATE TABLE test.tampon_extract_union_02_ibloaerien as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, '0'::varchar as mode_pose
FROM 
    test.tampon_02_ibloaerien
;
-- Index geometrique
CREATE INDEX tampon_extract_union_02_ibloaerien_gix ON test.tampon_extract_union_02_ibloaerien USING GIST (geom);
ALTER TABLE test.tampon_extract_union_02_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union des tampons 1 en un polygone 
DROP TABLE if exists test.tampon_extract_union_02_enedisaerien  ;
CREATE TABLE test.tampon_extract_union_02_enedisaerien as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, '1'::varchar as mode_pose
FROM 
    test.tampon_02_enedisaerien
;
-- Index geometrique
CREATE INDEX tampon_extract_union_02_enedisaerien_gix ON test.tampon_extract_union_02_enedisaerien USING GIST (geom);
ALTER TABLE test.tampon_extract_union_02_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union des tampons 7 en un polygone 
DROP TABLE if exists test.tampon_extract_union_02_iblosout  ;
CREATE TABLE test.tampon_extract_union_02_iblosout as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom,  '7'::varchar as mode_pose
FROM 
    test.tampon_02_iblosout
;
-- Index geometrique
CREATE INDEX tampon_extract_union_02_iblosout_gix ON test.tampon_extract_union_02_iblosout USING GIST (geom);
ALTER TABLE test.tampon_extract_union_02_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union de tous les tampons en un polygone 
DROP TABLE if exists test.tampon_extract_union_02_all  ;
CREATE TABLE test.tampon_extract_union_02_all as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, 7
FROM 
    test.tampon_02_all
;


-- Index geometrique
CREATE INDEX tampon_extract_union_02_all_gix ON test.tampon_extract_union_02_all USING GIST (geom);
ALTER TABLE test.tampon_extract_union_02_all ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 0/1/7 unis
DROP TABLE IF EXISTS test.buffer_difference_02;
CREATE TABLE test.buffer_difference_02 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_02_all b join test.tampon_extract_union_02 a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_02_all b left join temp t on b.gid = t.gid;

-- Index geometrique
CREATE INDEX buffer_difference_02_gix ON test.buffer_difference_02 USING GIST (geom);
ALTER TABLE test.buffer_difference_02 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'exterieur du buffer entier (par dpt)
DROP TABLE IF EXISTS test.line_out_poly_02;
CREATE TABLE test.line_out_poly_02 AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_02 as tpolygone,
    test.line_test as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_out_poly_02_gix ON test.line_out_poly_02 USING GIST (geom);
ALTER TABLE test.line_out_poly_02 ADD COLUMN gid SERIAL PRIMARY KEY;

--- Tampon avec mode de pose 0/1/7
DROP TABLE IF EXISTS test.tampon_02_line;
CREATE TABLE test.tampon_02_line as 
SELECT gid, id, type, emprise, st_buffer(geom, 0.001) as geom
FROM test.line_test;

-- Index geom
CREATE INDEX tampon_02_line_gix ON test.tampon_02_line USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_02_line ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_02_line  ;
CREATE TABLE test.tampon_extract_union_02_line as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_02_line
;

-- Index geom
CREATE INDEX tampon_extract_union_02_line_gix ON test.tampon_extract_union_02_line USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_02_line ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);
ALTER TABLE test.tampon_extract_union_02_line ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon route et tampon arciti
DROP TABLE IF EXISTS test.buffer_difference_line_02;
CREATE TABLE test.buffer_difference_line_02 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_02_line b join test.tampon_extract_union_02_all a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_02_line b left join temp t on b.gid = t.gid;

ALTER TABLE test.buffer_difference_line_02 ADD COLUMN gid SERIAL PRIMARY KEY;
-- Index geom
CREATE INDEX buffer_difference_line_02_gix ON test.buffer_difference_line_02 USING GIST (geom);    

-- Decoupage de lignes à l'exterieur du buffer entier et du pit(par dpt)
DROP TABLE IF EXISTS test.line_out_poly_line_02;
CREATE TABLE test.line_out_poly_line_02 AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_line_02 as tpolygone,
    test.line_test as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;



-- Index geometrique
CREATE INDEX line_out_poly_line_02_gix ON test.line_out_poly_line_02 USING GIST (geom);
ALTER TABLE test.line_out_poly_line_02 ADD COLUMN gid SERIAL PRIMARY KEY;

-- Union des lignes en dehors du buffer en mode pose 0/1/7
drop table if exists aura.line_out_02;
create table aura.line_out_02 as 
SELECT idligne, id, type, emprise, geom
FROM test.line_out_poly_02
union all
select idligne, id, type, emprise, geom
from test.line_out_poly_line_02;
-- Index geometrique
CREATE INDEX line_out_02_gix ON aura.line_out_02 USING GIST (geom);
ALTER TABLE aura.line_out_02 ADD COLUMN gid SERIAL PRIMARY KEY;

-- Mise à jour champ emprise avec valeur 'GC_A_CREER'
UPDATE aura.line_out_02 set emprise = 'GC_A_CREER';
ALTER TABLE aura.line_out_02 ALTER COLUMN geom type geometry(MultiLinestring, 2154) using ST_Multi(geom);

--- Tampon autour de line_out_02
DROP TABLE IF EXISTS test.tampon_line_out_02;
CREATE TABLE test.tampon_line_out_02 as 
SELECT gid, id, type, emprise, st_buffer(geom,0.001) as geom
FROM aura.line_out_02;

-- Index geom
CREATE INDEX tampon_line_out_02_gix ON test.tampon_line_out_02 USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_line_out_02 ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_02_line_out ;
CREATE TABLE test.tampon_extract_union_02_line_out as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_line_out_02
;

-- Index geom
CREATE INDEX tampon_extract_union_02_line_out_gix ON test.tampon_extract_union_02_line_out USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_02_line_out ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);
ALTER TABLE test.tampon_extract_union_02_line_out ADD COLUMN gid SERIAL PRIMARY KEY;




-- Difference entre tampon en dehors du pit et tampon 0 unis
DROP TABLE IF EXISTS test.buffer_difference_in_02_ibloaerien;
CREATE TABLE test.buffer_difference_in_02_ibloaerien AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_02_ibloaerien b join test.tampon_extract_union_02_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_02_ibloaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_02_ibloaerien_gix ON test.buffer_difference_in_02_ibloaerien USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_02_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 1 unis
DROP TABLE IF EXISTS test.buffer_difference_in_02_enedisaerien;
CREATE TABLE test.buffer_difference_in_02_enedisaerien AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_02_enedisaerien b join test.tampon_extract_union_02_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_02_enedisaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_02_enedisaerien_gix ON test.buffer_difference_in_02_enedisaerien USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_02_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 7 unis
DROP TABLE IF EXISTS test.buffer_difference_in_02_iblosout;
CREATE TABLE test.buffer_difference_in_02_iblosout AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_02_iblosout b join test.tampon_extract_union_02_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_02_iblosout b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_02_iblosout_gix ON test.buffer_difference_in_02_iblosout USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_02_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre  0 et 7 pour ne garder que ce qui ne se superpose pas à 7

DROP TABLE IF EXISTS test.buffer_difference_in_02_ibloaerien_decoup;
CREATE TABLE test.buffer_difference_in_02_ibloaerien_decoup AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_02_ibloaerien b join test.buffer_difference_in_02_iblosout a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_02_ibloaerien b left join temp t on b.gid = t.gid;


-- Index geom
CREATE INDEX buffer_difference_in_02_ibloaerien_decoup_gix ON test.buffer_difference_in_02_ibloaerien_decoup USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_02_ibloaerien_decoup ADD COLUMN gid SERIAL PRIMARY KEY;

-- Difference entre  1 et 7 pour ne garder que ce qui ne se superpose pas à 7


DROP TABLE IF EXISTS test.buffer_difference_in_02_enedisaerien_decoup;
CREATE TABLE test.buffer_difference_in_02_enedisaerien_decoup AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_02_enedisaerien b join test.buffer_difference_in_02_iblosout a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_02_enedisaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_02_enedisaerien_decoup_gix ON test.buffer_difference_in_02_enedisaerien_decoup USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_02_enedisaerien_decoup ADD COLUMN gid SERIAL PRIMARY KEY;

-- Difference entre  1 (après découp sur 7) et 0 pour ne garder que ce qui ne se superpose pas à 0



DROP TABLE IF EXISTS test.buffer_difference_in_02_enedisaerien_decoup_left;
CREATE TABLE test.buffer_difference_in_02_enedisaerien_decoup_left AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_02_enedisaerien_decoup b join test.buffer_difference_in_02_ibloaerien a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_02_enedisaerien_decoup b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_02_enedisaerien_decoup_left_gix ON test.buffer_difference_in_02_enedisaerien_decoup_left USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_02_enedisaerien_decoup_left ADD COLUMN gid SERIAL PRIMARY KEY;


-- Table de buffer finale

DROP TABLE IF EXISTS aura.buffer_in_02;
CREATE TABLE aura.buffer_in_02 AS
select mode_pose, geom
from test.buffer_difference_in_02_iblosout
union all
select mode_pose, geom
from test.buffer_difference_in_02_ibloaerien_decoup
union all
select mode_pose, geom
from test.buffer_difference_in_02_enedisaerien_decoup_left;

CREATE INDEX buffer_in_02_gix ON aura.buffer_in_02 USING GIST (geom);  
ALTER TABLE aura.buffer_in_02 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.buffer_in_02 ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);

-- Decoupage de lignes à l'intérieur du buffer entier 7(par dpt)
DROP TABLE IF EXISTS test.line_in_02_iblosout;
CREATE TABLE test.line_in_02_iblosout AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_02_iblosout as tpolygone,
    test.line_test as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_02_iblosout_gix ON test.line_in_02_iblosout USING GIST (geom);
ALTER TABLE test.line_in_02_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;

-- Decoupage de lignes à l'intérieur du buffer entier 0(par dpt)
DROP TABLE IF EXISTS test.line_in_02_ibloaerien;
CREATE TABLE test.line_in_02_ibloaerien AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_02_ibloaerien_decoup as tpolygone,
    test.line_test as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_02_ibloaerien_gix ON test.line_in_02_ibloaerien USING GIST (geom);
ALTER TABLE test.line_in_02_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'intérieur du buffer entier 1(par dpt)
DROP TABLE IF EXISTS test.line_in_02_enedisaerien;
CREATE TABLE test.line_in_02_enedisaerien AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_02_enedisaerien_decoup_left as tpolygone,
    test.line_test as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_02_enedisaerien_gix ON test.line_in_02_enedisaerien USING GIST (geom);
ALTER TABLE test.line_in_02_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;

-- Union des lignes à l'intérieur des buffers 0/1/7
DROP TABLE IF EXISTS aura.line_in_02;
CREATE TABLE aura.line_in_02 AS
select idligne, id, type, 'IBLO_SOUTERRAIN'::varchar (20) as emprise, geom
from test.line_in_02_iblosout
union all
select idligne, id, type,'ENEDIS_AERIEN'::varchar (20) as emprise, geom
from test.line_in_02_enedisaerien
union all
select idligne, id, type, 'IBLO_AERIEN'::varchar (20) as emprise, geom
from test.line_in_02_ibloaerien;

CREATE INDEX line_in_02_gix ON aura.line_in_02 USING GIST (geom);
ALTER TABLE aura.line_in_02 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.line_in_02 ALTER COLUMN geom type geometry(MultiLinestring, 2154) using ST_Multi(geom);

-- Union des 2 tables lignes (intérieur/extérieur)
DROP TABLE IF EXISTS aura.line_type_02;
CREATE TABLE aura.line_type_02 AS
select id, type, emprise, geom
from aura.line_in_02
union all
select id, type, emprise, geom
from aura.line_out_02;

CREATE INDEX line_type_02_gix ON aura.line_type_02 USING GIST (geom);
ALTER TABLE aura.line_type_02 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.line_type_02 ALTER COLUMN geom type geometry(MultiLinestring, 2154) using ST_Multi(geom);

-- Suppression tables intermediaires;
drop table if exists test.tampon_02 ;
drop table if exists test.tampon_02_ibloaerien;
drop table if exists test.tampon_02_enedisaerien;
drop table if exists test.tampon_02_all;
drop table if exists test.tampon_02_iblosout;
drop table if exists test.tampon_extract_union_02;
drop table if exists test.tampon_extract_union_02_ibloaerien;
drop table if exists test.tampon_extract_union_02_enedisaerien;
drop table if exists test.tampon_extract_union_02_iblosout;
drop table if exists test.tampon_extract_union_02_all;
drop table if exists test.buffer_difference_02;
drop table if exists test.line_out_poly_02;
drop table if exists test.tampon_02_line;
drop table if exists test.tampon_extract_union_02_line;
drop table if exists test.tampon_extract_union_02_fusion_pit;
drop table if exists test.buffer_difference_line_02;
drop table if exists test.line_out_poly_line_02;
drop table if exists test.tampon_line_out_02;
drop table if exists test.tampon_extract_union_02_line_out ;
drop table if exists test.buffer_difference_in_02_ibloaerien;
drop table if exists test.buffer_difference_in_02_enedisaerien;
drop table if exists test.buffer_difference_in_02_iblosout;
drop table if exists test.buffer_difference_in_02_ibloaerien_decoup;
drop table if exists test.buffer_difference_in_02_enedisaerien_decoup;
drop table if exists test.buffer_difference_in_02_enedisaerien_decoup_left;
drop table if exists test.line_in_02_iblosout;
drop table if exists test.line_in_02_ibloaerien;
drop table if exists test.line_in_02_enedisaerien;
