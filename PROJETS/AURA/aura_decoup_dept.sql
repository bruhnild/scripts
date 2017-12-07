--- DEPARTEMENT 03
-- Tampon avec mode de pose 0/1/7
DROP TABLE IF EXISTS test.tampon_03;
CREATE TABLE test.tampon_03 as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 50) as geom
FROM test.arciti_03
where mode_pose like '0' or mode_pose like '1' or mode_pose like '7';
-- Index geom
CREATE INDEX tampon_03_gix ON test.tampon_03 USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_03 ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);

-- Tampon avec mode de pose 0
DROP TABLE IF EXISTS test.tampon_03_ibloaerien;
CREATE TABLE test.tampon_03_ibloaerien as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 50) as geom
FROM test.arciti_03
where mode_pose like '0' ;
-- Index geom
CREATE INDEX tampon_03_ibloaerien_gix ON test.tampon_03_ibloaerien USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_03_ibloaerien ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);

-- Tampon avec mode de pose 1
DROP TABLE IF EXISTS test.tampon_03_enedisaerien;
CREATE TABLE test.tampon_03_enedisaerien as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 50) as geom
FROM test.arciti_03
where mode_pose like '1' ;
-- Index geom
CREATE INDEX tampon_03_enedisaerien_gix ON test.tampon_03_enedisaerien USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_03_enedisaerien ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);

-- Tampon avec mode de pose 7
DROP TABLE IF EXISTS test.tampon_03_iblosout;
CREATE TABLE test.tampon_03_iblosout as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 50) as geom
FROM test.arciti_03
where mode_pose like '7' ;
-- Index geom
CREATE INDEX tampon_03_iblosout_gix ON test.tampon_03_iblosout USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_03_iblosout ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);


-- Tampon avec tous modes de pose 
DROP TABLE IF EXISTS test.tampon_03_all;
CREATE TABLE test.tampon_03_all as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 50) as geom
FROM test.arciti_03;
-- Index geometrique
CREATE INDEX tampon_03_all_gix ON test.tampon_03_all USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_03_all ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);


-- Union des tampons 0/1/7 en un polygone 
DROP TABLE if exists test.tampon_extract_union_03  ;
CREATE TABLE test.tampon_extract_union_03 as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_03
;
-- Index geometrique
CREATE INDEX tampon_extract_union_03_gix ON test.tampon_extract_union_03 USING GIST (geom);


-- Union des tampons 0 en un polygone 
DROP TABLE if exists test.tampon_extract_union_03_ibloaerien  ;
CREATE TABLE test.tampon_extract_union_03_ibloaerien as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, '0'::varchar as mode_pose
FROM 
    test.tampon_03_ibloaerien
;
-- Index geometrique
CREATE INDEX tampon_extract_union_03_ibloaerien_gix ON test.tampon_extract_union_03_ibloaerien USING GIST (geom);
ALTER TABLE test.tampon_extract_union_03_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union des tampons 1 en un polygone 
DROP TABLE if exists test.tampon_extract_union_03_enedisaerien  ;
CREATE TABLE test.tampon_extract_union_03_enedisaerien as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, '1'::varchar as mode_pose
FROM 
    test.tampon_03_enedisaerien
;
-- Index geometrique
CREATE INDEX tampon_extract_union_03_enedisaerien_gix ON test.tampon_extract_union_03_enedisaerien USING GIST (geom);
ALTER TABLE test.tampon_extract_union_03_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union des tampons 7 en un polygone 
DROP TABLE if exists test.tampon_extract_union_03_iblosout  ;
CREATE TABLE test.tampon_extract_union_03_iblosout as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom,  '7'::varchar as mode_pose
FROM 
    test.tampon_03_iblosout
;
-- Index geometrique
CREATE INDEX tampon_extract_union_03_iblosout_gix ON test.tampon_extract_union_03_iblosout USING GIST (geom);

ALTER TABLE test.tampon_extract_union_03_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union de tous les tampons en un polygone 
DROP TABLE if exists test.tampon_extract_union_03_all  ;
CREATE TABLE test.tampon_extract_union_03_all as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, 7
FROM 
    test.tampon_03_all
;


-- Index geometrique
CREATE INDEX tampon_extract_union_03_all_gix ON test.tampon_extract_union_03_all USING GIST (geom);
ALTER TABLE test.tampon_extract_union_03_all ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 0/1/7 unis
DROP TABLE IF EXISTS test.buffer_difference_03;
CREATE TABLE test.buffer_difference_03 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_03_all b join test.tampon_extract_union_03 a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_03_all b left join temp t on b.gid = t.gid;


ALTER TABLE test.buffer_difference_03 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'exterieur du buffer entier (par dpt)
DROP TABLE IF EXISTS test.line_out_poly_03;
CREATE TABLE test.line_out_poly_03 AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_03 as tpolygone,
    test.line_03 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_out_poly_03_gix ON test.line_out_poly_03 USING GIST (geom);
ALTER TABLE test.line_out_poly_03 ADD COLUMN gid SERIAL PRIMARY KEY;

--- Tampon avec mode de pose 0/1/7
DROP TABLE IF EXISTS test.tampon_03_line;
CREATE TABLE test.tampon_03_line as 
SELECT gid, id, type, emprise, st_buffer(geom, 1) as geom
FROM test.line_03;

-- Index geom
CREATE INDEX tampon_03_line_gix ON test.tampon_03_line USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_03_line ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_03_line  ;
CREATE TABLE test.tampon_extract_union_03_line as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_03_line
;

-- Index geom
CREATE INDEX tampon_extract_union_03_line_gix ON test.tampon_extract_union_03_line USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_03_line ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);
ALTER TABLE test.tampon_extract_union_03 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Fusion des deux tampons unis du pit
DROP TABLE if exists test.tampon_extract_union_03_fusion_pit  ;
CREATE TABLE test.tampon_extract_union_03_fusion_pit as 
select geom, gid
from test.tampon_extract_union_03_all
union all
select geom, gid
from test.tampon_extract_union_03;

-- Index geom
CREATE INDEX tampon_extract_union_03_fusion_pit_gix ON test.tampon_extract_union_03_fusion_pit USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_03_fusion_pit ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_03_pit  ;
CREATE TABLE test.tampon_extract_union_03_pit as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_extract_union_03_fusion_pit
;

-- Index geom
CREATE INDEX tampon_extract_union_03_pit_gix ON test.tampon_extract_union_03_pit USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_03_pit ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);

ALTER TABLE test.tampon_extract_union_03_line ADD COLUMN gid SERIAL PRIMARY KEY;



-- difference
DROP TABLE IF EXISTS test.buffer_difference_line_03;
CREATE TABLE test.buffer_difference_line_03 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_03_line b join test.tampon_extract_union_03_pit a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_03_line b left join temp t on b.gid = t.gid;

ALTER TABLE test.buffer_difference_line_03 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'exterieur du buffer entier et du pit(par dpt)
DROP TABLE IF EXISTS test.line_out_poly_line_03;
CREATE TABLE test.line_out_poly_line_03 AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_line_03 as tpolygone,
    test.line_03 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;



-- Index geometrique
CREATE INDEX line_out_poly_line_03_gix ON test.line_out_poly_line_03 USING GIST (geom);
ALTER TABLE test.line_out_poly_line_03 ADD COLUMN gid SERIAL PRIMARY KEY;

-- Union des lignes en dehors du buffer en mode pose 0/1/7
drop table if exists aura.line_out_03;
create table aura.line_out_03 as 
SELECT idligne, id, type, emprise, geom
FROM test.line_out_poly_03
union all
select idligne, id, type, emprise, geom
from test.line_out_poly_line_03;
-- Index geometrique
CREATE INDEX line_out_03_gix ON aura.line_out_03 USING GIST (geom);
ALTER TABLE aura.line_out_03 ADD COLUMN gid SERIAL PRIMARY KEY;

-- Mise à jour champ emprise avec valeur 'GC_A_CREER'
UPDATE aura.line_out_03 set emprise = 'GC_A_CREER';
ALTER TABLE aura.line_out_03 ALTER COLUMN geom type geometry(MultiLinestring, 2154) using ST_Multi(geom);

--- Tampon autour de line_out_03
DROP TABLE IF EXISTS test.tampon_line_out_03;
CREATE TABLE test.tampon_line_out_03 as 
SELECT gid, id, type, emprise, st_buffer(geom,0.001) as geom
FROM aura.line_out_03;

-- Index geom
CREATE INDEX tampon_line_out_03_gix ON test.tampon_line_out_03 USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_line_out_03 ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_03_line_out ;
CREATE TABLE test.tampon_extract_union_03_line_out as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_line_out_03
;

-- Index geom
CREATE INDEX tampon_extract_union_03_line_out_gix ON test.tampon_extract_union_03_line_out USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_03_line_out ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);
ALTER TABLE test.tampon_extract_union_03_line_out ADD COLUMN gid SERIAL PRIMARY KEY;


-- Diffrence entre tampon tout pit et tampon 0/1/7 unis
DROP TABLE IF EXISTS test.buffer_difference_in_03;
CREATE TABLE test.buffer_difference_in_03 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_03 b join test.tampon_extract_union_03_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_03 b left join temp t on b.gid = t.gid;


ALTER TABLE test.buffer_difference_in_03 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 0 unis
DROP TABLE IF EXISTS test.buffer_difference_in_03_ibloaerien;
CREATE TABLE test.buffer_difference_in_03_ibloaerien AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_03_ibloaerien b join test.tampon_extract_union_03_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_03_ibloaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_03_ibloaerien_gix ON test.buffer_difference_in_03_ibloaerien USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_03_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 1 unis
DROP TABLE IF EXISTS test.buffer_difference_in_03_enedisaerien;
CREATE TABLE test.buffer_difference_in_03_enedisaerien AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_03_enedisaerien b join test.tampon_extract_union_03_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_03_enedisaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_03_enedisaerien_gix ON test.buffer_difference_in_03_enedisaerien USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_03_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 7 unis
DROP TABLE IF EXISTS test.buffer_difference_in_03_iblosout;
CREATE TABLE test.buffer_difference_in_03_iblosout AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_03_iblosout b join test.tampon_extract_union_03_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_03_iblosout b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_03_iblosout_gix ON test.buffer_difference_in_03_iblosout USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_03_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre  0 et 7 pour ne garder que ce qui ne se superpose pas à 7

DROP TABLE IF EXISTS test.buffer_difference_in_03_ibloaerien_decoup;
CREATE TABLE test.buffer_difference_in_03_ibloaerien_decoup AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_03_ibloaerien b join test.buffer_difference_in_03_iblosout a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_03_ibloaerien b left join temp t on b.gid = t.gid;


-- Index geom
CREATE INDEX buffer_difference_in_03_ibloaerien_decoup_gix ON test.buffer_difference_in_03_ibloaerien_decoup USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_03_ibloaerien_decoup ADD COLUMN gid SERIAL PRIMARY KEY;

-- Difference entre  1 et 7 pour ne garder que ce qui ne se superpose pas à 7


DROP TABLE IF EXISTS test.buffer_difference_in_03_enedisaerien_decoup;
CREATE TABLE test.buffer_difference_in_03_enedisaerien_decoup AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_03_enedisaerien b join test.buffer_difference_in_03_iblosout a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_03_enedisaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_03_enedisaerien_decoup_gix ON test.buffer_difference_in_03_enedisaerien_decoup USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_03_enedisaerien_decoup ADD COLUMN gid SERIAL PRIMARY KEY;

-- Difference entre  1 (après découp sur 7) et 0 pour ne garder que ce qui ne se superpose pas à 0



DROP TABLE IF EXISTS test.buffer_difference_in_03_enedisaerien_decoup_left;
CREATE TABLE test.buffer_difference_in_03_enedisaerien_decoup_left AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_03_enedisaerien_decoup b join test.buffer_difference_in_03_ibloaerien a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_03_enedisaerien_decoup b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_03_enedisaerien_decoup_left_gix ON test.buffer_difference_in_03_enedisaerien_decoup_left USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_03_enedisaerien_decoup_left ADD COLUMN gid SERIAL PRIMARY KEY;


-- Table de buffer finale

DROP TABLE IF EXISTS aura.buffer_in_03;
CREATE TABLE aura.buffer_in_03 AS
select mode_pose, geom
from test.buffer_difference_in_03_iblosout
union all
select mode_pose, geom
from test.buffer_difference_in_03_ibloaerien_decoup
union all
select mode_pose, geom
from test.buffer_difference_in_03_enedisaerien_decoup_left;

CREATE INDEX buffer_in_03_gix ON aura.buffer_in_03 USING GIST (geom);  
ALTER TABLE aura.buffer_in_03 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.buffer_in_03 ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);

-- Decoupage de lignes à l'intérieur du buffer entier 7(par dpt)
DROP TABLE IF EXISTS test.line_in_03_iblosout;
CREATE TABLE test.line_in_03_iblosout AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_03_iblosout as tpolygone,
    test.line_03 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_03_iblosout_gix ON test.line_in_03_iblosout USING GIST (geom);
ALTER TABLE test.line_in_03_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;





-- Decoupage de lignes à l'intérieur du buffer entier 0(par dpt)
DROP TABLE IF EXISTS test.line_in_03_ibloaerien;
CREATE TABLE test.line_in_03_ibloaerien AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_03_ibloaerien_decoup as tpolygone,
    test.line_03 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_03_ibloaerien_gix ON test.line_in_03_ibloaerien USING GIST (geom);
ALTER TABLE test.line_in_03_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'intérieur du buffer entier 1(par dpt)
DROP TABLE IF EXISTS test.line_in_03_enedisaerien;
CREATE TABLE test.line_in_03_enedisaerien AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_03_enedisaerien_decoup_left as tpolygone,
    test.line_03 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_03_enedisaerien_gix ON test.line_in_03_enedisaerien USING GIST (geom);
ALTER TABLE test.line_in_03_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;

-- Union des lignes à l'intérieur des buffers 0/1/7
DROP TABLE IF EXISTS aura.line_in_03;
CREATE TABLE aura.line_in_03 AS
select idligne, id, type, 'IBLO_SOUTERRAIN'::varchar (20) as emprise, geom
from test.line_in_03_iblosout
union all
select idligne, id, type,'ENEDIS_AERIEN'::varchar (20) as emprise, geom
from test.line_in_03_enedisaerien
union all
select idligne, id, type, 'IBLO_AERIEN'::varchar (20) as emprise, geom
from test.line_in_03_ibloaerien;

CREATE INDEX line_in_03_gix ON aura.line_in_03 USING GIST (geom);
ALTER TABLE aura.line_in_03 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.line_in_03 ALTER COLUMN geom type geometry(MultiLinestring, 2154) using ST_Multi(geom);

-- Union des 2 tables lignes (intérieur/extérieur)
DROP TABLE IF EXISTS aura.line_type_03;
CREATE TABLE aura.line_type_03 AS
select id, type, emprise, geom
from aura.line_in_03
union all
select id, type, emprise, geom
from aura.line_out_03;

CREATE INDEX line_type_03_gix ON aura.line_type_03 USING GIST (geom);
ALTER TABLE aura.line_type_03 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.line_type_03 ALTER COLUMN geom type geometry(MultiLinestring, 2154) using ST_Multi(geom);

-- Suppression tables intermediaires;
drop table if exists test.tampon_03 ;
drop table if exists test.tampon_03_ibloaerien;
drop table if exists test.tampon_03_enedisaerien;
drop table if exists test.tampon_03_all;
drop table if exists test.tampon_03_iblosout;
drop table if exists test.tampon_extract_union_03;
drop table if exists test.tampon_extract_union_03_ibloaerien;
drop table if exists test.tampon_extract_union_03_enedisaerien;
drop table if exists test.tampon_extract_union_03_iblosout;
drop table if exists test.tampon_extract_union_03_all;
drop table if exists test.buffer_difference_03;
drop table if exists test.line_out_poly_03;
drop table if exists test.tampon_03_line;
drop table if exists test.tampon_extract_union_03_line;
drop table if exists test.tampon_extract_union_03_fusion_pit;
drop table if exists test.tampon_extract_union_03_pit;
drop table if exists test.buffer_difference_line_03;
drop table if exists test.line_out_poly_line_03;
drop table if exists test.tampon_line_out_03;
drop table if exists test.tampon_extract_union_03_line_out ;
drop table if exists test.buffer_difference_in_03;
drop table if exists test.buffer_difference_in_03_ibloaerien;
drop table if exists test.buffer_difference_in_03_enedisaerien;
drop table if exists test.buffer_difference_in_03_iblosout;
drop table if exists test.buffer_difference_in_03_ibloaerien_decoup;
drop table if exists test.buffer_difference_in_03_enedisaerien_decoup;
drop table if exists test.buffer_difference_in_03_enedisaerien_decoup_left;
drop table if exists test.line_in_03_iblosout;
drop table if exists test.line_in_03_ibloaerien;
drop table if exists test.line_in_03_enedisaerien;

--- DEPARTEMENT 63


-- Tampon avec mode de pose 0/1/7
DROP TABLE IF EXISTS test.tampon_63;
CREATE TABLE test.tampon_63 as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 50) as geom
FROM test.arciti_63
where mode_pose like '0' or mode_pose like '1' or mode_pose like '7';
-- Index geom
CREATE INDEX tampon_63_gix ON test.tampon_63 USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_63 ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);

-- Tampon avec mode de pose 0
DROP TABLE IF EXISTS test.tampon_63_ibloaerien;
CREATE TABLE test.tampon_63_ibloaerien as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 50) as geom
FROM test.arciti_63
where mode_pose like '0' ;
-- Index geom
CREATE INDEX tampon_63_ibloaerien_gix ON test.tampon_63_ibloaerien USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_63_ibloaerien ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);

-- Tampon avec mode de pose 1
DROP TABLE IF EXISTS test.tampon_63_enedisaerien;
CREATE TABLE test.tampon_63_enedisaerien as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 50) as geom
FROM test.arciti_63
where mode_pose like '1' ;
-- Index geom
CREATE INDEX tampon_63_enedisaerien_gix ON test.tampon_63_enedisaerien USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_63_enedisaerien ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);

-- Tampon avec mode de pose 7
DROP TABLE IF EXISTS test.tampon_63_iblosout;
CREATE TABLE test.tampon_63_iblosout as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 50) as geom
FROM test.arciti_63
where mode_pose like '7' ;
-- Index geom
CREATE INDEX tampon_63_iblosout_gix ON test.tampon_63_iblosout USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_63_iblosout ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);


-- Tampon avec tous modes de pose 
DROP TABLE IF EXISTS test.tampon_63_all;
CREATE TABLE test.tampon_63_all as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 50) as geom
FROM test.arciti_63;
-- Index geometrique
CREATE INDEX tampon_63_all_gix ON test.tampon_63_all USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_63_all ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);


-- Union des tampons 0/1/7 en un polygone 
DROP TABLE if exists test.tampon_extract_union_63  ;
CREATE TABLE test.tampon_extract_union_63 as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_63
;
-- Index geometrique
CREATE INDEX tampon_extract_union_63_gix ON test.tampon_extract_union_63 USING GIST (geom);


-- Union des tampons 0 en un polygone 
DROP TABLE if exists test.tampon_extract_union_63_ibloaerien  ;
CREATE TABLE test.tampon_extract_union_63_ibloaerien as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, '0'::varchar as mode_pose
FROM 
    test.tampon_63_ibloaerien
;
-- Index geometrique
CREATE INDEX tampon_extract_union_63_ibloaerien_gix ON test.tampon_extract_union_63_ibloaerien USING GIST (geom);
ALTER TABLE test.tampon_extract_union_63_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union des tampons 1 en un polygone 
DROP TABLE if exists test.tampon_extract_union_63_enedisaerien  ;
CREATE TABLE test.tampon_extract_union_63_enedisaerien as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, '1'::varchar as mode_pose
FROM 
    test.tampon_63_enedisaerien
;
-- Index geometrique
CREATE INDEX tampon_extract_union_63_enedisaerien_gix ON test.tampon_extract_union_63_enedisaerien USING GIST (geom);
ALTER TABLE test.tampon_extract_union_63_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union des tampons 7 en un polygone 
DROP TABLE if exists test.tampon_extract_union_63_iblosout  ;
CREATE TABLE test.tampon_extract_union_63_iblosout as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom,  '7'::varchar as mode_pose
FROM 
    test.tampon_63_iblosout
;
-- Index geometrique
CREATE INDEX tampon_extract_union_63_iblosout_gix ON test.tampon_extract_union_63_iblosout USING GIST (geom);

ALTER TABLE test.tampon_extract_union_63_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union de tous les tampons en un polygone 
DROP TABLE if exists test.tampon_extract_union_63_all  ;
CREATE TABLE test.tampon_extract_union_63_all as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, 7
FROM 
    test.tampon_63_all
;


-- Index geometrique
CREATE INDEX tampon_extract_union_63_all_gix ON test.tampon_extract_union_63_all USING GIST (geom);
ALTER TABLE test.tampon_extract_union_63_all ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 0/1/7 unis
DROP TABLE IF EXISTS test.buffer_difference_63;
CREATE TABLE test.buffer_difference_63 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_63_all b join test.tampon_extract_union_63 a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_63_all b left join temp t on b.gid = t.gid;


ALTER TABLE test.buffer_difference_63 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'exterieur du buffer entier (par dpt)
DROP TABLE IF EXISTS test.line_out_poly_63;
CREATE TABLE test.line_out_poly_63 AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_63 as tpolygone,
    test.line_63 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_out_poly_63_gix ON test.line_out_poly_63 USING GIST (geom);
ALTER TABLE test.line_out_poly_63 ADD COLUMN gid SERIAL PRIMARY KEY;

--- Tampon avec mode de pose 0/1/7
DROP TABLE IF EXISTS test.tampon_63_line;
CREATE TABLE test.tampon_63_line as 
SELECT gid, id, type, emprise, st_buffer(geom, 1) as geom
FROM test.line_63;

-- Index geom
CREATE INDEX tampon_63_line_gix ON test.tampon_63_line USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_63_line ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_63_line  ;
CREATE TABLE test.tampon_extract_union_63_line as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_63_line
;

-- Index geom
CREATE INDEX tampon_extract_union_63_line_gix ON test.tampon_extract_union_63_line USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_63_line ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);
ALTER TABLE test.tampon_extract_union_63 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Fusion des deux tampons unis du pit
DROP TABLE if exists test.tampon_extract_union_63_fusion_pit  ;
CREATE TABLE test.tampon_extract_union_63_fusion_pit as 
select geom, gid
from test.tampon_extract_union_63_all
union all
select geom, gid
from test.tampon_extract_union_63;

-- Index geom
CREATE INDEX tampon_extract_union_63_fusion_pit_gix ON test.tampon_extract_union_63_fusion_pit USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_63_fusion_pit ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_63_pit  ;
CREATE TABLE test.tampon_extract_union_63_pit as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_extract_union_63_fusion_pit
;

-- Index geom
CREATE INDEX tampon_extract_union_63_pit_gix ON test.tampon_extract_union_63_pit USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_63_pit ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);

ALTER TABLE test.tampon_extract_union_63_line ADD COLUMN gid SERIAL PRIMARY KEY;



-- difference
DROP TABLE IF EXISTS test.buffer_difference_line_63;
CREATE TABLE test.buffer_difference_line_63 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_63_line b join test.tampon_extract_union_63_pit a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_63_line b left join temp t on b.gid = t.gid;

ALTER TABLE test.buffer_difference_line_63 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'exterieur du buffer entier et du pit(par dpt)
DROP TABLE IF EXISTS test.line_out_poly_line_63;
CREATE TABLE test.line_out_poly_line_63 AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_line_63 as tpolygone,
    test.line_63 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;



-- Index geometrique
CREATE INDEX line_out_poly_line_63_gix ON test.line_out_poly_line_63 USING GIST (geom);
ALTER TABLE test.line_out_poly_line_63 ADD COLUMN gid SERIAL PRIMARY KEY;

-- Union des lignes en dehors du buffer en mode pose 0/1/7
drop table if exists aura.line_out_63;
create table aura.line_out_63 as 
SELECT idligne, id, type, emprise, geom
FROM test.line_out_poly_63
union all
select idligne, id, type, emprise, geom
from test.line_out_poly_line_63;
-- Index geometrique
CREATE INDEX line_out_63_gix ON aura.line_out_63 USING GIST (geom);
ALTER TABLE aura.line_out_63 ADD COLUMN gid SERIAL PRIMARY KEY;

-- Mise à jour champ emprise avec valeur 'GC_A_CREER'
UPDATE aura.line_out_63 set emprise = 'GC_A_CREER';
ALTER TABLE aura.line_out_63 ALTER COLUMN geom type geometry(MultiLinestring, 2154) using ST_Multi(geom);

--- Tampon autour de line_out_63
DROP TABLE IF EXISTS test.tampon_line_out_63;
CREATE TABLE test.tampon_line_out_63 as 
SELECT gid, id, type, emprise, st_buffer(geom,0.001) as geom
FROM aura.line_out_63;

-- Index geom
CREATE INDEX tampon_line_out_63_gix ON test.tampon_line_out_63 USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_line_out_63 ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_63_line_out ;
CREATE TABLE test.tampon_extract_union_63_line_out as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_line_out_63
;

-- Index geom
CREATE INDEX tampon_extract_union_63_line_out_gix ON test.tampon_extract_union_63_line_out USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_63_line_out ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);
ALTER TABLE test.tampon_extract_union_63_line_out ADD COLUMN gid SERIAL PRIMARY KEY;


-- Diffrence entre tampon tout pit et tampon 0/1/7 unis
DROP TABLE IF EXISTS test.buffer_difference_in_63;
CREATE TABLE test.buffer_difference_in_63 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_63 b join test.tampon_extract_union_63_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_63 b left join temp t on b.gid = t.gid;


ALTER TABLE test.buffer_difference_in_63 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 0 unis
DROP TABLE IF EXISTS test.buffer_difference_in_63_ibloaerien;
CREATE TABLE test.buffer_difference_in_63_ibloaerien AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_63_ibloaerien b join test.tampon_extract_union_63_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_63_ibloaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_63_ibloaerien_gix ON test.buffer_difference_in_63_ibloaerien USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_63_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 1 unis
DROP TABLE IF EXISTS test.buffer_difference_in_63_enedisaerien;
CREATE TABLE test.buffer_difference_in_63_enedisaerien AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_63_enedisaerien b join test.tampon_extract_union_63_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_63_enedisaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_63_enedisaerien_gix ON test.buffer_difference_in_63_enedisaerien USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_63_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 7 unis
DROP TABLE IF EXISTS test.buffer_difference_in_63_iblosout;
CREATE TABLE test.buffer_difference_in_63_iblosout AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_63_iblosout b join test.tampon_extract_union_63_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_63_iblosout b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_63_iblosout_gix ON test.buffer_difference_in_63_iblosout USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_63_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre  0 et 7 pour ne garder que ce qui ne se superpose pas à 7

DROP TABLE IF EXISTS test.buffer_difference_in_63_ibloaerien_decoup;
CREATE TABLE test.buffer_difference_in_63_ibloaerien_decoup AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_63_ibloaerien b join test.buffer_difference_in_63_iblosout a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_63_ibloaerien b left join temp t on b.gid = t.gid;


-- Index geom
CREATE INDEX buffer_difference_in_63_ibloaerien_decoup_gix ON test.buffer_difference_in_63_ibloaerien_decoup USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_63_ibloaerien_decoup ADD COLUMN gid SERIAL PRIMARY KEY;

-- Difference entre  1 et 7 pour ne garder que ce qui ne se superpose pas à 7


DROP TABLE IF EXISTS test.buffer_difference_in_63_enedisaerien_decoup;
CREATE TABLE test.buffer_difference_in_63_enedisaerien_decoup AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_63_enedisaerien b join test.buffer_difference_in_63_iblosout a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_63_enedisaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_63_enedisaerien_decoup_gix ON test.buffer_difference_in_63_enedisaerien_decoup USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_63_enedisaerien_decoup ADD COLUMN gid SERIAL PRIMARY KEY;

-- Difference entre  1 (après découp sur 7) et 0 pour ne garder que ce qui ne se superpose pas à 0



DROP TABLE IF EXISTS test.buffer_difference_in_63_enedisaerien_decoup_left;
CREATE TABLE test.buffer_difference_in_63_enedisaerien_decoup_left AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_63_enedisaerien_decoup b join test.buffer_difference_in_63_ibloaerien a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_63_enedisaerien_decoup b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_63_enedisaerien_decoup_left_gix ON test.buffer_difference_in_63_enedisaerien_decoup_left USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_63_enedisaerien_decoup_left ADD COLUMN gid SERIAL PRIMARY KEY;


-- Table de buffer finale

DROP TABLE IF EXISTS aura.buffer_in_63;
CREATE TABLE aura.buffer_in_63 AS
select mode_pose, geom
from test.buffer_difference_in_63_iblosout
union all
select mode_pose, geom
from test.buffer_difference_in_63_ibloaerien_decoup
union all
select mode_pose, geom
from test.buffer_difference_in_63_enedisaerien_decoup_left;

CREATE INDEX buffer_in_63_gix ON aura.buffer_in_63 USING GIST (geom);  
ALTER TABLE aura.buffer_in_63 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.buffer_in_63 ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);

-- Decoupage de lignes à l'intérieur du buffer entier 7(par dpt)
DROP TABLE IF EXISTS test.line_in_63_iblosout;
CREATE TABLE test.line_in_63_iblosout AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_63_iblosout as tpolygone,
    test.line_63 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_63_iblosout_gix ON test.line_in_63_iblosout USING GIST (geom);
ALTER TABLE test.line_in_63_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;





-- Decoupage de lignes à l'intérieur du buffer entier 0(par dpt)
DROP TABLE IF EXISTS test.line_in_63_ibloaerien;
CREATE TABLE test.line_in_63_ibloaerien AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_63_ibloaerien_decoup as tpolygone,
    test.line_63 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_63_ibloaerien_gix ON test.line_in_63_ibloaerien USING GIST (geom);
ALTER TABLE test.line_in_63_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'intérieur du buffer entier 1(par dpt)
DROP TABLE IF EXISTS test.line_in_63_enedisaerien;
CREATE TABLE test.line_in_63_enedisaerien AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_63_enedisaerien_decoup_left as tpolygone,
    test.line_63 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_63_enedisaerien_gix ON test.line_in_63_enedisaerien USING GIST (geom);
ALTER TABLE test.line_in_63_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;

-- Union des lignes à l'intérieur des buffers 0/1/7
DROP TABLE IF EXISTS aura.line_in_63;
CREATE TABLE aura.line_in_63 AS
select idligne, id, type, 'IBLO_SOUTERRAIN'::varchar (20) as emprise, geom
from test.line_in_63_iblosout
union all
select idligne, id, type,'ENEDIS_AERIEN'::varchar (20) as emprise, geom
from test.line_in_63_enedisaerien
union all
select idligne, id, type, 'IBLO_AERIEN'::varchar (20) as emprise, geom
from test.line_in_63_ibloaerien;

CREATE INDEX line_in_63_gix ON aura.line_in_63 USING GIST (geom);
ALTER TABLE aura.line_in_63 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.line_in_63 ALTER COLUMN geom type geometry(MultiLinestring, 2154) using ST_Multi(geom);

-- Union des 2 tables lignes (intérieur/extérieur)
DROP TABLE IF EXISTS aura.line_type_63;
CREATE TABLE aura.line_type_63 AS
select id, type, emprise, geom
from aura.line_in_63
union all
select id, type, emprise, geom
from aura.line_out_63;

CREATE INDEX line_type_63_gix ON aura.line_type_63 USING GIST (geom);
ALTER TABLE aura.line_type_63 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.line_type_63 ALTER COLUMN geom type geometry(MultiLinestring, 2154) using ST_Multi(geom);

-- Suppression tables intermediaires;
drop table if exists test.tampon_63 ;
drop table if exists test.tampon_63_ibloaerien;
drop table if exists test.tampon_63_enedisaerien;
drop table if exists test.tampon_63_all;
drop table if exists test.tampon_63_iblosout;
drop table if exists test.tampon_extract_union_63;
drop table if exists test.tampon_extract_union_63_ibloaerien;
drop table if exists test.tampon_extract_union_63_enedisaerien;
drop table if exists test.tampon_extract_union_63_iblosout;
drop table if exists test.tampon_extract_union_63_all;
drop table if exists test.buffer_difference_63;
drop table if exists test.line_out_poly_63;
drop table if exists test.tampon_63_line;
drop table if exists test.tampon_extract_union_63_line;
drop table if exists test.tampon_extract_union_63_fusion_pit;
drop table if exists test.tampon_extract_union_63_pit;
drop table if exists test.buffer_difference_line_63;
drop table if exists test.line_out_poly_line_63;
drop table if exists test.tampon_line_out_63;
drop table if exists test.tampon_extract_union_63_line_out ;
drop table if exists test.buffer_difference_in_63;
drop table if exists test.buffer_difference_in_63_ibloaerien;
drop table if exists test.buffer_difference_in_63_enedisaerien;
drop table if exists test.buffer_difference_in_63_iblosout;
drop table if exists test.buffer_difference_in_63_ibloaerien_decoup;
drop table if exists test.buffer_difference_in_63_enedisaerien_decoup;
drop table if exists test.buffer_difference_in_63_enedisaerien_decoup_left;
drop table if exists test.line_in_63_iblosout;
drop table if exists test.line_in_63_ibloaerien;
drop table if exists test.line_in_63_enedisaerien;


--- DEPARTEMENT 42


-- Tampon avec mode de pose 0/1/7
DROP TABLE IF EXISTS test.tampon_42;
CREATE TABLE test.tampon_42 as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 50) as geom
FROM test.arciti_42
where mode_pose like '0' or mode_pose like '1' or mode_pose like '7';
-- Index geom
CREATE INDEX tampon_42_gix ON test.tampon_42 USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_42 ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);

-- Tampon avec mode de pose 0
DROP TABLE IF EXISTS test.tampon_42_ibloaerien;
CREATE TABLE test.tampon_42_ibloaerien as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 50) as geom
FROM test.arciti_42
where mode_pose like '0' ;
-- Index geom
CREATE INDEX tampon_42_ibloaerien_gix ON test.tampon_42_ibloaerien USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_42_ibloaerien ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);

-- Tampon avec mode de pose 1
DROP TABLE IF EXISTS test.tampon_42_enedisaerien;
CREATE TABLE test.tampon_42_enedisaerien as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 50) as geom
FROM test.arciti_42
where mode_pose like '1' ;
-- Index geom
CREATE INDEX tampon_42_enedisaerien_gix ON test.tampon_42_enedisaerien USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_42_enedisaerien ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);

-- Tampon avec mode de pose 7
DROP TABLE IF EXISTS test.tampon_42_iblosout;
CREATE TABLE test.tampon_42_iblosout as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 50) as geom
FROM test.arciti_42
where mode_pose like '7' ;
-- Index geom
CREATE INDEX tampon_42_iblosout_gix ON test.tampon_42_iblosout USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_42_iblosout ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);


-- Tampon avec tous modes de pose 
DROP TABLE IF EXISTS test.tampon_42_all;
CREATE TABLE test.tampon_42_all as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 50) as geom
FROM test.arciti_42;
-- Index geometrique
CREATE INDEX tampon_42_all_gix ON test.tampon_42_all USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_42_all ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);


-- Union des tampons 0/1/7 en un polygone 
DROP TABLE if exists test.tampon_extract_union_42  ;
CREATE TABLE test.tampon_extract_union_42 as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_42
;
-- Index geometrique
CREATE INDEX tampon_extract_union_42_gix ON test.tampon_extract_union_42 USING GIST (geom);


-- Union des tampons 0 en un polygone 
DROP TABLE if exists test.tampon_extract_union_42_ibloaerien  ;
CREATE TABLE test.tampon_extract_union_42_ibloaerien as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, '0'::varchar as mode_pose
FROM 
    test.tampon_42_ibloaerien
;
-- Index geometrique
CREATE INDEX tampon_extract_union_42_ibloaerien_gix ON test.tampon_extract_union_42_ibloaerien USING GIST (geom);
ALTER TABLE test.tampon_extract_union_42_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union des tampons 1 en un polygone 
DROP TABLE if exists test.tampon_extract_union_42_enedisaerien  ;
CREATE TABLE test.tampon_extract_union_42_enedisaerien as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, '1'::varchar as mode_pose
FROM 
    test.tampon_42_enedisaerien
;
-- Index geometrique
CREATE INDEX tampon_extract_union_42_enedisaerien_gix ON test.tampon_extract_union_42_enedisaerien USING GIST (geom);
ALTER TABLE test.tampon_extract_union_42_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union des tampons 7 en un polygone 
DROP TABLE if exists test.tampon_extract_union_42_iblosout  ;
CREATE TABLE test.tampon_extract_union_42_iblosout as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom,  '7'::varchar as mode_pose
FROM 
    test.tampon_42_iblosout
;
-- Index geometrique
CREATE INDEX tampon_extract_union_42_iblosout_gix ON test.tampon_extract_union_42_iblosout USING GIST (geom);

ALTER TABLE test.tampon_extract_union_42_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union de tous les tampons en un polygone 
DROP TABLE if exists test.tampon_extract_union_42_all  ;
CREATE TABLE test.tampon_extract_union_42_all as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, 7
FROM 
    test.tampon_42_all
;


-- Index geometrique
CREATE INDEX tampon_extract_union_42_all_gix ON test.tampon_extract_union_42_all USING GIST (geom);
ALTER TABLE test.tampon_extract_union_42_all ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 0/1/7 unis
DROP TABLE IF EXISTS test.buffer_difference_42;
CREATE TABLE test.buffer_difference_42 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_42_all b join test.tampon_extract_union_42 a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_42_all b left join temp t on b.gid = t.gid;


ALTER TABLE test.buffer_difference_42 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'exterieur du buffer entier (par dpt)
DROP TABLE IF EXISTS test.line_out_poly_42;
CREATE TABLE test.line_out_poly_42 AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_42 as tpolygone,
    test.line_42 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_out_poly_42_gix ON test.line_out_poly_42 USING GIST (geom);
ALTER TABLE test.line_out_poly_42 ADD COLUMN gid SERIAL PRIMARY KEY;

--- Tampon avec mode de pose 0/1/7
DROP TABLE IF EXISTS test.tampon_42_line;
CREATE TABLE test.tampon_42_line as 
SELECT gid, id, type, emprise, st_buffer(geom, 1) as geom
FROM test.line_42;

-- Index geom
CREATE INDEX tampon_42_line_gix ON test.tampon_42_line USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_42_line ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_42_line  ;
CREATE TABLE test.tampon_extract_union_42_line as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_42_line
;

-- Index geom
CREATE INDEX tampon_extract_union_42_line_gix ON test.tampon_extract_union_42_line USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_42_line ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);
ALTER TABLE test.tampon_extract_union_42 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Fusion des deux tampons unis du pit
DROP TABLE if exists test.tampon_extract_union_42_fusion_pit  ;
CREATE TABLE test.tampon_extract_union_42_fusion_pit as 
select geom, gid
from test.tampon_extract_union_42_all
union all
select geom, gid
from test.tampon_extract_union_42;

-- Index geom
CREATE INDEX tampon_extract_union_42_fusion_pit_gix ON test.tampon_extract_union_42_fusion_pit USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_42_fusion_pit ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_42_pit  ;
CREATE TABLE test.tampon_extract_union_42_pit as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_extract_union_42_fusion_pit
;

-- Index geom
CREATE INDEX tampon_extract_union_42_pit_gix ON test.tampon_extract_union_42_pit USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_42_pit ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);

ALTER TABLE test.tampon_extract_union_42_line ADD COLUMN gid SERIAL PRIMARY KEY;



-- difference
DROP TABLE IF EXISTS test.buffer_difference_line_42;
CREATE TABLE test.buffer_difference_line_42 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_42_line b join test.tampon_extract_union_42_pit a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_42_line b left join temp t on b.gid = t.gid;

ALTER TABLE test.buffer_difference_line_42 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'exterieur du buffer entier et du pit(par dpt)
DROP TABLE IF EXISTS test.line_out_poly_line_42;
CREATE TABLE test.line_out_poly_line_42 AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_line_42 as tpolygone,
    test.line_42 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;



-- Index geometrique
CREATE INDEX line_out_poly_line_42_gix ON test.line_out_poly_line_42 USING GIST (geom);
ALTER TABLE test.line_out_poly_line_42 ADD COLUMN gid SERIAL PRIMARY KEY;

-- Union des lignes en dehors du buffer en mode pose 0/1/7
drop table if exists aura.line_out_42;
create table aura.line_out_42 as 
SELECT idligne, id, type, emprise, geom
FROM test.line_out_poly_42
union all
select idligne, id, type, emprise, geom
from test.line_out_poly_line_42;
-- Index geometrique
CREATE INDEX line_out_42_gix ON aura.line_out_42 USING GIST (geom);
ALTER TABLE aura.line_out_42 ADD COLUMN gid SERIAL PRIMARY KEY;

-- Mise à jour champ emprise avec valeur 'GC_A_CREER'
UPDATE aura.line_out_42 set emprise = 'GC_A_CREER';
ALTER TABLE aura.line_out_42 ALTER COLUMN geom type geometry(MultiLinestring, 2154) using ST_Multi(geom);

--- Tampon autour de line_out_42
DROP TABLE IF EXISTS test.tampon_line_out_42;
CREATE TABLE test.tampon_line_out_42 as 
SELECT gid, id, type, emprise, st_buffer(geom,0.001) as geom
FROM aura.line_out_42;

-- Index geom
CREATE INDEX tampon_line_out_42_gix ON test.tampon_line_out_42 USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_line_out_42 ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_42_line_out ;
CREATE TABLE test.tampon_extract_union_42_line_out as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_line_out_42
;

-- Index geom
CREATE INDEX tampon_extract_union_42_line_out_gix ON test.tampon_extract_union_42_line_out USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_42_line_out ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);
ALTER TABLE test.tampon_extract_union_42_line_out ADD COLUMN gid SERIAL PRIMARY KEY;


-- Diffrence entre tampon tout pit et tampon 0/1/7 unis
DROP TABLE IF EXISTS test.buffer_difference_in_42;
CREATE TABLE test.buffer_difference_in_42 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_42 b join test.tampon_extract_union_42_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_42 b left join temp t on b.gid = t.gid;


ALTER TABLE test.buffer_difference_in_42 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 0 unis
DROP TABLE IF EXISTS test.buffer_difference_in_42_ibloaerien;
CREATE TABLE test.buffer_difference_in_42_ibloaerien AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_42_ibloaerien b join test.tampon_extract_union_42_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_42_ibloaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_42_ibloaerien_gix ON test.buffer_difference_in_42_ibloaerien USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_42_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 1 unis
DROP TABLE IF EXISTS test.buffer_difference_in_42_enedisaerien;
CREATE TABLE test.buffer_difference_in_42_enedisaerien AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_42_enedisaerien b join test.tampon_extract_union_42_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_42_enedisaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_42_enedisaerien_gix ON test.buffer_difference_in_42_enedisaerien USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_42_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 7 unis
DROP TABLE IF EXISTS test.buffer_difference_in_42_iblosout;
CREATE TABLE test.buffer_difference_in_42_iblosout AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_42_iblosout b join test.tampon_extract_union_42_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_42_iblosout b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_42_iblosout_gix ON test.buffer_difference_in_42_iblosout USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_42_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre  0 et 7 pour ne garder que ce qui ne se superpose pas à 7

DROP TABLE IF EXISTS test.buffer_difference_in_42_ibloaerien_decoup;
CREATE TABLE test.buffer_difference_in_42_ibloaerien_decoup AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_42_ibloaerien b join test.buffer_difference_in_42_iblosout a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_42_ibloaerien b left join temp t on b.gid = t.gid;


-- Index geom
CREATE INDEX buffer_difference_in_42_ibloaerien_decoup_gix ON test.buffer_difference_in_42_ibloaerien_decoup USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_42_ibloaerien_decoup ADD COLUMN gid SERIAL PRIMARY KEY;

-- Difference entre  1 et 7 pour ne garder que ce qui ne se superpose pas à 7


DROP TABLE IF EXISTS test.buffer_difference_in_42_enedisaerien_decoup;
CREATE TABLE test.buffer_difference_in_42_enedisaerien_decoup AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_42_enedisaerien b join test.buffer_difference_in_42_iblosout a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_42_enedisaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_42_enedisaerien_decoup_gix ON test.buffer_difference_in_42_enedisaerien_decoup USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_42_enedisaerien_decoup ADD COLUMN gid SERIAL PRIMARY KEY;

-- Difference entre  1 (après découp sur 7) et 0 pour ne garder que ce qui ne se superpose pas à 0



DROP TABLE IF EXISTS test.buffer_difference_in_42_enedisaerien_decoup_left;
CREATE TABLE test.buffer_difference_in_42_enedisaerien_decoup_left AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_42_enedisaerien_decoup b join test.buffer_difference_in_42_ibloaerien a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_42_enedisaerien_decoup b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_42_enedisaerien_decoup_left_gix ON test.buffer_difference_in_42_enedisaerien_decoup_left USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_42_enedisaerien_decoup_left ADD COLUMN gid SERIAL PRIMARY KEY;


-- Table de buffer finale

DROP TABLE IF EXISTS aura.buffer_in_42;
CREATE TABLE aura.buffer_in_42 AS
select mode_pose, geom
from test.buffer_difference_in_42_iblosout
union all
select mode_pose, geom
from test.buffer_difference_in_42_ibloaerien_decoup
union all
select mode_pose, geom
from test.buffer_difference_in_42_enedisaerien_decoup_left;

CREATE INDEX buffer_in_42_gix ON aura.buffer_in_42 USING GIST (geom);  
ALTER TABLE aura.buffer_in_42 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.buffer_in_42 ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);

-- Decoupage de lignes à l'intérieur du buffer entier 7(par dpt)
DROP TABLE IF EXISTS test.line_in_42_iblosout;
CREATE TABLE test.line_in_42_iblosout AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_42_iblosout as tpolygone,
    test.line_42 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_42_iblosout_gix ON test.line_in_42_iblosout USING GIST (geom);
ALTER TABLE test.line_in_42_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;





-- Decoupage de lignes à l'intérieur du buffer entier 0(par dpt)
DROP TABLE IF EXISTS test.line_in_42_ibloaerien;
CREATE TABLE test.line_in_42_ibloaerien AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_42_ibloaerien_decoup as tpolygone,
    test.line_42 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_42_ibloaerien_gix ON test.line_in_42_ibloaerien USING GIST (geom);
ALTER TABLE test.line_in_42_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'intérieur du buffer entier 1(par dpt)
DROP TABLE IF EXISTS test.line_in_42_enedisaerien;
CREATE TABLE test.line_in_42_enedisaerien AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_42_enedisaerien_decoup_left as tpolygone,
    test.line_42 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_42_enedisaerien_gix ON test.line_in_42_enedisaerien USING GIST (geom);
ALTER TABLE test.line_in_42_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;

-- Union des lignes à l'intérieur des buffers 0/1/7
DROP TABLE IF EXISTS aura.line_in_42;
CREATE TABLE aura.line_in_42 AS
select idligne, id, type, 'IBLO_SOUTERRAIN'::varchar (20) as emprise, geom
from test.line_in_42_iblosout
union all
select idligne, id, type,'ENEDIS_AERIEN'::varchar (20) as emprise, geom
from test.line_in_42_enedisaerien
union all
select idligne, id, type, 'IBLO_AERIEN'::varchar (20) as emprise, geom
from test.line_in_42_ibloaerien;

CREATE INDEX line_in_42_gix ON aura.line_in_42 USING GIST (geom);
ALTER TABLE aura.line_in_42 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.line_in_42 ALTER COLUMN geom type geometry(MultiLinestring, 2154) using ST_Multi(geom);

-- Union des 2 tables lignes (intérieur/extérieur)
DROP TABLE IF EXISTS aura.line_type_42;
CREATE TABLE aura.line_type_42 AS
select id, type, emprise, geom
from aura.line_in_42
union all
select id, type, emprise, geom
from aura.line_out_42;

CREATE INDEX line_type_42_gix ON aura.line_type_42 USING GIST (geom);
ALTER TABLE aura.line_type_42 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.line_type_42 ALTER COLUMN geom type geometry(MultiLinestring, 2154) using ST_Multi(geom);

-- Suppression tables intermediaires;
drop table if exists test.tampon_42 ;
drop table if exists test.tampon_42_ibloaerien;
drop table if exists test.tampon_42_enedisaerien;
drop table if exists test.tampon_42_all;
drop table if exists test.tampon_42_iblosout;
drop table if exists test.tampon_extract_union_42;
drop table if exists test.tampon_extract_union_42_ibloaerien;
drop table if exists test.tampon_extract_union_42_enedisaerien;
drop table if exists test.tampon_extract_union_42_iblosout;
drop table if exists test.tampon_extract_union_42_all;
drop table if exists test.buffer_difference_42;
drop table if exists test.line_out_poly_42;
drop table if exists test.tampon_42_line;
drop table if exists test.tampon_extract_union_42_line;
drop table if exists test.tampon_extract_union_42_fusion_pit;
drop table if exists test.tampon_extract_union_42_pit;
drop table if exists test.buffer_difference_line_42;
drop table if exists test.line_out_poly_line_42;
drop table if exists test.tampon_line_out_42;
drop table if exists test.tampon_extract_union_42_line_out ;
drop table if exists test.buffer_difference_in_42;
drop table if exists test.buffer_difference_in_42_ibloaerien;
drop table if exists test.buffer_difference_in_42_enedisaerien;
drop table if exists test.buffer_difference_in_42_iblosout;
drop table if exists test.buffer_difference_in_42_ibloaerien_decoup;
drop table if exists test.buffer_difference_in_42_enedisaerien_decoup;
drop table if exists test.buffer_difference_in_42_enedisaerien_decoup_left;
drop table if exists test.line_in_42_iblosout;
drop table if exists test.line_in_42_ibloaerien;
drop table if exists test.line_in_42_enedisaerien;

--- DEPARTEMENT 15


-- Tampon avec mode de pose 0/1/7
DROP TABLE IF EXISTS test.tampon_15;
CREATE TABLE test.tampon_15 as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 55) as geom
FROM test.arciti_15
where mode_pose like '0' or mode_pose like '1' or mode_pose like '7';
-- Index geom
CREATE INDEX tampon_15_gix ON test.tampon_15 USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_15 ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);

-- Tampon avec mode de pose 0
DROP TABLE IF EXISTS test.tampon_15_ibloaerien;
CREATE TABLE test.tampon_15_ibloaerien as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 55) as geom
FROM test.arciti_15
where mode_pose like '0' ;
-- Index geom
CREATE INDEX tampon_15_ibloaerien_gix ON test.tampon_15_ibloaerien USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_15_ibloaerien ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);

-- Tampon avec mode de pose 1
DROP TABLE IF EXISTS test.tampon_15_enedisaerien;
CREATE TABLE test.tampon_15_enedisaerien as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 55) as geom
FROM test.arciti_15
where mode_pose like '1' ;
-- Index geom
CREATE INDEX tampon_15_enedisaerien_gix ON test.tampon_15_enedisaerien USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_15_enedisaerien ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);

-- Tampon avec mode de pose 7
DROP TABLE IF EXISTS test.tampon_15_iblosout;
CREATE TABLE test.tampon_15_iblosout as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 55) as geom
FROM test.arciti_15
where mode_pose like '7' ;
-- Index geom
CREATE INDEX tampon_15_iblosout_gix ON test.tampon_15_iblosout USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_15_iblosout ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);


-- Tampon avec tous modes de pose 
DROP TABLE IF EXISTS test.tampon_15_all;
CREATE TABLE test.tampon_15_all as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 55) as geom
FROM test.arciti_15;
-- Index geometrique
CREATE INDEX tampon_15_all_gix ON test.tampon_15_all USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_15_all ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);


-- Union des tampons 0/1/7 en un polygone 
DROP TABLE if exists test.tampon_extract_union_15  ;
CREATE TABLE test.tampon_extract_union_15 as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_15
;
-- Index geometrique
CREATE INDEX tampon_extract_union_15_gix ON test.tampon_extract_union_15 USING GIST (geom);


-- Union des tampons 0 en un polygone 
DROP TABLE if exists test.tampon_extract_union_15_ibloaerien  ;
CREATE TABLE test.tampon_extract_union_15_ibloaerien as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, '0'::varchar as mode_pose
FROM 
    test.tampon_15_ibloaerien
;
-- Index geometrique
CREATE INDEX tampon_extract_union_15_ibloaerien_gix ON test.tampon_extract_union_15_ibloaerien USING GIST (geom);
ALTER TABLE test.tampon_extract_union_15_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union des tampons 1 en un polygone 
DROP TABLE if exists test.tampon_extract_union_15_enedisaerien  ;
CREATE TABLE test.tampon_extract_union_15_enedisaerien as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, '1'::varchar as mode_pose
FROM 
    test.tampon_15_enedisaerien
;
-- Index geometrique
CREATE INDEX tampon_extract_union_15_enedisaerien_gix ON test.tampon_extract_union_15_enedisaerien USING GIST (geom);
ALTER TABLE test.tampon_extract_union_15_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union des tampons 7 en un polygone 
DROP TABLE if exists test.tampon_extract_union_15_iblosout  ;
CREATE TABLE test.tampon_extract_union_15_iblosout as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom,  '7'::varchar as mode_pose
FROM 
    test.tampon_15_iblosout
;
-- Index geometrique
CREATE INDEX tampon_extract_union_15_iblosout_gix ON test.tampon_extract_union_15_iblosout USING GIST (geom);

ALTER TABLE test.tampon_extract_union_15_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union de tous les tampons en un polygone 
DROP TABLE if exists test.tampon_extract_union_15_all  ;
CREATE TABLE test.tampon_extract_union_15_all as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, 7
FROM 
    test.tampon_15_all
;


-- Index geometrique
CREATE INDEX tampon_extract_union_15_all_gix ON test.tampon_extract_union_15_all USING GIST (geom);
ALTER TABLE test.tampon_extract_union_15_all ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 0/1/7 unis
DROP TABLE IF EXISTS test.buffer_difference_15;
CREATE TABLE test.buffer_difference_15 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_15_all b join test.tampon_extract_union_15 a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_15_all b left join temp t on b.gid = t.gid;


ALTER TABLE test.buffer_difference_15 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'exterieur du buffer entier (par dpt)
DROP TABLE IF EXISTS test.line_out_poly_15;
CREATE TABLE test.line_out_poly_15 AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_15 as tpolygone,
    test.line_15 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_out_poly_15_gix ON test.line_out_poly_15 USING GIST (geom);
ALTER TABLE test.line_out_poly_15 ADD COLUMN gid SERIAL PRIMARY KEY;

--- Tampon avec mode de pose 0/1/7
DROP TABLE IF EXISTS test.tampon_15_line;
CREATE TABLE test.tampon_15_line as 
SELECT gid, id, type, emprise, st_buffer(geom, 1) as geom
FROM test.line_15;

-- Index geom
CREATE INDEX tampon_15_line_gix ON test.tampon_15_line USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_15_line ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_15_line  ;
CREATE TABLE test.tampon_extract_union_15_line as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_15_line
;

-- Index geom
CREATE INDEX tampon_extract_union_15_line_gix ON test.tampon_extract_union_15_line USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_15_line ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);
ALTER TABLE test.tampon_extract_union_15 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Fusion des deux tampons unis du pit
DROP TABLE if exists test.tampon_extract_union_15_fusion_pit  ;
CREATE TABLE test.tampon_extract_union_15_fusion_pit as 
select geom, gid
from test.tampon_extract_union_15_all
union all
select geom, gid
from test.tampon_extract_union_15;

-- Index geom
CREATE INDEX tampon_extract_union_15_fusion_pit_gix ON test.tampon_extract_union_15_fusion_pit USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_15_fusion_pit ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_15_pit  ;
CREATE TABLE test.tampon_extract_union_15_pit as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_extract_union_15_fusion_pit
;

-- Index geom
CREATE INDEX tampon_extract_union_15_pit_gix ON test.tampon_extract_union_15_pit USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_15_pit ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);

ALTER TABLE test.tampon_extract_union_15_line ADD COLUMN gid SERIAL PRIMARY KEY;



-- difference
DROP TABLE IF EXISTS test.buffer_difference_line_15;
CREATE TABLE test.buffer_difference_line_15 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_15_line b join test.tampon_extract_union_15_pit a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_15_line b left join temp t on b.gid = t.gid;

ALTER TABLE test.buffer_difference_line_15 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'exterieur du buffer entier et du pit(par dpt)
DROP TABLE IF EXISTS test.line_out_poly_line_15;
CREATE TABLE test.line_out_poly_line_15 AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_line_15 as tpolygone,
    test.line_15 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;



-- Index geometrique
CREATE INDEX line_out_poly_line_15_gix ON test.line_out_poly_line_15 USING GIST (geom);
ALTER TABLE test.line_out_poly_line_15 ADD COLUMN gid SERIAL PRIMARY KEY;

-- Union des lignes en dehors du buffer en mode pose 0/1/7
drop table if exists aura.line_out_15;
create table aura.line_out_15 as 
SELECT idligne, id, type, emprise, geom
FROM test.line_out_poly_15
union all
select idligne, id, type, emprise, geom
from test.line_out_poly_line_15;
-- Index geometrique
CREATE INDEX line_out_15_gix ON aura.line_out_15 USING GIST (geom);
ALTER TABLE aura.line_out_15 ADD COLUMN gid SERIAL PRIMARY KEY;

-- Mise à jour champ emprise avec valeur 'GC_A_CREER'
UPDATE aura.line_out_15 set emprise = 'GC_A_CREER';
ALTER TABLE aura.line_out_15 ALTER COLUMN geom type geometry(MultiLinestring, 2154) using ST_Multi(geom);

--- Tampon autour de line_out_15
DROP TABLE IF EXISTS test.tampon_line_out_15;
CREATE TABLE test.tampon_line_out_15 as 
SELECT gid, id, type, emprise, st_buffer(geom,0.001) as geom
FROM aura.line_out_15;

-- Index geom
CREATE INDEX tampon_line_out_15_gix ON test.tampon_line_out_15 USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_line_out_15 ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_15_line_out ;
CREATE TABLE test.tampon_extract_union_15_line_out as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_line_out_15
;

-- Index geom
CREATE INDEX tampon_extract_union_15_line_out_gix ON test.tampon_extract_union_15_line_out USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_15_line_out ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);
ALTER TABLE test.tampon_extract_union_15_line_out ADD COLUMN gid SERIAL PRIMARY KEY;


-- Diffrence entre tampon tout pit et tampon 0/1/7 unis
DROP TABLE IF EXISTS test.buffer_difference_in_15;
CREATE TABLE test.buffer_difference_in_15 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_15 b join test.tampon_extract_union_15_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_15 b left join temp t on b.gid = t.gid;


ALTER TABLE test.buffer_difference_in_15 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 0 unis
DROP TABLE IF EXISTS test.buffer_difference_in_15_ibloaerien;
CREATE TABLE test.buffer_difference_in_15_ibloaerien AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_15_ibloaerien b join test.tampon_extract_union_15_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_15_ibloaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_15_ibloaerien_gix ON test.buffer_difference_in_15_ibloaerien USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_15_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 1 unis
DROP TABLE IF EXISTS test.buffer_difference_in_15_enedisaerien;
CREATE TABLE test.buffer_difference_in_15_enedisaerien AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_15_enedisaerien b join test.tampon_extract_union_15_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_15_enedisaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_15_enedisaerien_gix ON test.buffer_difference_in_15_enedisaerien USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_15_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 7 unis
DROP TABLE IF EXISTS test.buffer_difference_in_15_iblosout;
CREATE TABLE test.buffer_difference_in_15_iblosout AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_15_iblosout b join test.tampon_extract_union_15_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_15_iblosout b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_15_iblosout_gix ON test.buffer_difference_in_15_iblosout USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_15_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre  0 et 7 pour ne garder que ce qui ne se superpose pas à 7

DROP TABLE IF EXISTS test.buffer_difference_in_15_ibloaerien_decoup;
CREATE TABLE test.buffer_difference_in_15_ibloaerien_decoup AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_15_ibloaerien b join test.buffer_difference_in_15_iblosout a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_15_ibloaerien b left join temp t on b.gid = t.gid;


-- Index geom
CREATE INDEX buffer_difference_in_15_ibloaerien_decoup_gix ON test.buffer_difference_in_15_ibloaerien_decoup USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_15_ibloaerien_decoup ADD COLUMN gid SERIAL PRIMARY KEY;

-- Difference entre  1 et 7 pour ne garder que ce qui ne se superpose pas à 7


DROP TABLE IF EXISTS test.buffer_difference_in_15_enedisaerien_decoup;
CREATE TABLE test.buffer_difference_in_15_enedisaerien_decoup AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_15_enedisaerien b join test.buffer_difference_in_15_iblosout a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_15_enedisaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_15_enedisaerien_decoup_gix ON test.buffer_difference_in_15_enedisaerien_decoup USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_15_enedisaerien_decoup ADD COLUMN gid SERIAL PRIMARY KEY;

-- Difference entre  1 (après découp sur 7) et 0 pour ne garder que ce qui ne se superpose pas à 0



DROP TABLE IF EXISTS test.buffer_difference_in_15_enedisaerien_decoup_left;
CREATE TABLE test.buffer_difference_in_15_enedisaerien_decoup_left AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_15_enedisaerien_decoup b join test.buffer_difference_in_15_ibloaerien a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_15_enedisaerien_decoup b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_15_enedisaerien_decoup_left_gix ON test.buffer_difference_in_15_enedisaerien_decoup_left USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_15_enedisaerien_decoup_left ADD COLUMN gid SERIAL PRIMARY KEY;


-- Table de buffer finale

DROP TABLE IF EXISTS aura.buffer_in_15;
CREATE TABLE aura.buffer_in_15 AS
select mode_pose, geom
from test.buffer_difference_in_15_iblosout
union all
select mode_pose, geom
from test.buffer_difference_in_15_ibloaerien_decoup
union all
select mode_pose, geom
from test.buffer_difference_in_15_enedisaerien_decoup_left;

CREATE INDEX buffer_in_15_gix ON aura.buffer_in_15 USING GIST (geom);  
ALTER TABLE aura.buffer_in_15 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.buffer_in_15 ALTER COLUMN geom type geometry(MultiPolygon, 2154) using ST_Multi(geom);

-- Decoupage de lignes à l'intérieur du buffer entier 7(par dpt)
DROP TABLE IF EXISTS test.line_in_15_iblosout;
CREATE TABLE test.line_in_15_iblosout AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_15_iblosout as tpolygone,
    test.line_15 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_15_iblosout_gix ON test.line_in_15_iblosout USING GIST (geom);
ALTER TABLE test.line_in_15_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;





-- Decoupage de lignes à l'intérieur du buffer entier 0(par dpt)
DROP TABLE IF EXISTS test.line_in_15_ibloaerien;
CREATE TABLE test.line_in_15_ibloaerien AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_15_ibloaerien_decoup as tpolygone,
    test.line_15 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_15_ibloaerien_gix ON test.line_in_15_ibloaerien USING GIST (geom);
ALTER TABLE test.line_in_15_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'intérieur du buffer entier 1(par dpt)
DROP TABLE IF EXISTS test.line_in_15_enedisaerien;
CREATE TABLE test.line_in_15_enedisaerien AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_15_enedisaerien_decoup_left as tpolygone,
    test.line_15 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_15_enedisaerien_gix ON test.line_in_15_enedisaerien USING GIST (geom);
ALTER TABLE test.line_in_15_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;

-- Union des lignes à l'intérieur des buffers 0/1/7
DROP TABLE IF EXISTS aura.line_in_15;
CREATE TABLE aura.line_in_15 AS
select idligne, id, type, 'IBLO_SOUTERRAIN'::varchar (20) as emprise, geom
from test.line_in_15_iblosout
union all
select idligne, id, type,'ENEDIS_AERIEN'::varchar (20) as emprise, geom
from test.line_in_15_enedisaerien
union all
select idligne, id, type, 'IBLO_AERIEN'::varchar (20) as emprise, geom
from test.line_in_15_ibloaerien;

CREATE INDEX line_in_15_gix ON aura.line_in_15 USING GIST (geom);
ALTER TABLE aura.line_in_15 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.line_in_15 ALTER COLUMN geom type geometry(MultiLinestring, 2154) using ST_Multi(geom);

-- Union des 2 tables lignes (intérieur/extérieur)
DROP TABLE IF EXISTS aura.line_type_15;
CREATE TABLE aura.line_type_15 AS
select id, type, emprise, geom
from aura.line_in_15
union all
select id, type, emprise, geom
from aura.line_out_15;

CREATE INDEX line_type_15_gix ON aura.line_type_15 USING GIST (geom);
ALTER TABLE aura.line_type_15 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.line_type_15 ALTER COLUMN geom type geometry(MultiLinestring, 2154) using ST_Multi(geom);

-- Suppression tables intermediaires;
drop table if exists test.tampon_15 ;
drop table if exists test.tampon_15_ibloaerien;
drop table if exists test.tampon_15_enedisaerien;
drop table if exists test.tampon_15_all;
drop table if exists test.tampon_15_iblosout;
drop table if exists test.tampon_extract_union_15;
drop table if exists test.tampon_extract_union_15_ibloaerien;
drop table if exists test.tampon_extract_union_15_enedisaerien;
drop table if exists test.tampon_extract_union_15_iblosout;
drop table if exists test.tampon_extract_union_15_all;
drop table if exists test.buffer_difference_15;
drop table if exists test.line_out_poly_15;
drop table if exists test.tampon_15_line;
drop table if exists test.tampon_extract_union_15_line;
drop table if exists test.tampon_extract_union_15_fusion_pit;
drop table if exists test.tampon_extract_union_15_pit;
drop table if exists test.buffer_difference_line_15;
drop table if exists test.line_out_poly_line_15;
drop table if exists test.tampon_line_out_15;
drop table if exists test.tampon_extract_union_15_line_out ;
drop table if exists test.buffer_difference_in_15;
drop table if exists test.buffer_difference_in_15_ibloaerien;
drop table if exists test.buffer_difference_in_15_enedisaerien;
drop table if exists test.buffer_difference_in_15_iblosout;
drop table if exists test.buffer_difference_in_15_ibloaerien_decoup;
drop table if exists test.buffer_difference_in_15_enedisaerien_decoup;
drop table if exists test.buffer_difference_in_15_enedisaerien_decoup_left;
drop table if exists test.line_in_15_iblosout;
drop table if exists test.line_in_15_ibloaerien;
drop table if exists test.line_in_15_enedisaerien;


-- DEPARTEMENT 43


-- Tampon avec mode de pose 0/1/7
DROP TABLE IF EXISTS test.tampon_43;
CREATE TABLE test.tampon_43 as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 55) as geom
FROM test.arciti_43
where mode_pose like '0' or mode_pose like '1' or mode_pose like '7';
-- Index geom
CREATE INDEX tampon_43_gix ON test.tampon_43 USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_43 ALTER COLUMN geom type geometry(MultiPolygon, 2434) using ST_Multi(geom);

-- Tampon avec mode de pose 0
DROP TABLE IF EXISTS test.tampon_43_ibloaerien;
CREATE TABLE test.tampon_43_ibloaerien as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 55) as geom
FROM test.arciti_43
where mode_pose like '0' ;
-- Index geom
CREATE INDEX tampon_43_ibloaerien_gix ON test.tampon_43_ibloaerien USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_43_ibloaerien ALTER COLUMN geom type geometry(MultiPolygon, 2434) using ST_Multi(geom);

-- Tampon avec mode de pose 1
DROP TABLE IF EXISTS test.tampon_43_enedisaerien;
CREATE TABLE test.tampon_43_enedisaerien as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 55) as geom
FROM test.arciti_43
where mode_pose like '1' ;
-- Index geom
CREATE INDEX tampon_43_enedisaerien_gix ON test.tampon_43_enedisaerien USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_43_enedisaerien ALTER COLUMN geom type geometry(MultiPolygon, 2434) using ST_Multi(geom);

-- Tampon avec mode de pose 7
DROP TABLE IF EXISTS test.tampon_43_iblosout;
CREATE TABLE test.tampon_43_iblosout as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 55) as geom
FROM test.arciti_43
where mode_pose like '7' ;
-- Index geom
CREATE INDEX tampon_43_iblosout_gix ON test.tampon_43_iblosout USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_43_iblosout ALTER COLUMN geom type geometry(MultiPolygon, 2434) using ST_Multi(geom);


-- Tampon avec tous modes de pose 
DROP TABLE IF EXISTS test.tampon_43_all;
CREATE TABLE test.tampon_43_all as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 55) as geom
FROM test.arciti_43;
-- Index geometrique
CREATE INDEX tampon_43_all_gix ON test.tampon_43_all USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_43_all ALTER COLUMN geom type geometry(MultiPolygon, 2434) using ST_Multi(geom);


-- Union des tampons 0/1/7 en un polygone 
DROP TABLE if exists test.tampon_extract_union_43  ;
CREATE TABLE test.tampon_extract_union_43 as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_43
;
-- Index geometrique
CREATE INDEX tampon_extract_union_43_gix ON test.tampon_extract_union_43 USING GIST (geom);


-- Union des tampons 0 en un polygone 
DROP TABLE if exists test.tampon_extract_union_43_ibloaerien  ;
CREATE TABLE test.tampon_extract_union_43_ibloaerien as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, '0'::varchar as mode_pose
FROM 
    test.tampon_43_ibloaerien
;
-- Index geometrique
CREATE INDEX tampon_extract_union_43_ibloaerien_gix ON test.tampon_extract_union_43_ibloaerien USING GIST (geom);
ALTER TABLE test.tampon_extract_union_43_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union des tampons 1 en un polygone 
DROP TABLE if exists test.tampon_extract_union_43_enedisaerien  ;
CREATE TABLE test.tampon_extract_union_43_enedisaerien as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, '1'::varchar as mode_pose
FROM 
    test.tampon_43_enedisaerien
;
-- Index geometrique
CREATE INDEX tampon_extract_union_43_enedisaerien_gix ON test.tampon_extract_union_43_enedisaerien USING GIST (geom);
ALTER TABLE test.tampon_extract_union_43_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union des tampons 7 en un polygone 
DROP TABLE if exists test.tampon_extract_union_43_iblosout  ;
CREATE TABLE test.tampon_extract_union_43_iblosout as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom,  '7'::varchar as mode_pose
FROM 
    test.tampon_43_iblosout
;
-- Index geometrique
CREATE INDEX tampon_extract_union_43_iblosout_gix ON test.tampon_extract_union_43_iblosout USING GIST (geom);

ALTER TABLE test.tampon_extract_union_43_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union de tous les tampons en un polygone 
DROP TABLE if exists test.tampon_extract_union_43_all  ;
CREATE TABLE test.tampon_extract_union_43_all as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, 7
FROM 
    test.tampon_43_all
;


-- Index geometrique
CREATE INDEX tampon_extract_union_43_all_gix ON test.tampon_extract_union_43_all USING GIST (geom);
ALTER TABLE test.tampon_extract_union_43_all ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 0/1/7 unis
DROP TABLE IF EXISTS test.buffer_difference_43;
CREATE TABLE test.buffer_difference_43 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_43_all b join test.tampon_extract_union_43 a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_43_all b left join temp t on b.gid = t.gid;


ALTER TABLE test.buffer_difference_43 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'exterieur du buffer entier (par dpt)
DROP TABLE IF EXISTS test.line_out_poly_43;
CREATE TABLE test.line_out_poly_43 AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_43 as tpolygone,
    test.line_43 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_out_poly_43_gix ON test.line_out_poly_43 USING GIST (geom);
ALTER TABLE test.line_out_poly_43 ADD COLUMN gid SERIAL PRIMARY KEY;

--- Tampon avec mode de pose 0/1/7
DROP TABLE IF EXISTS test.tampon_43_line;
CREATE TABLE test.tampon_43_line as 
SELECT gid, id, type, emprise, st_buffer(geom, 1) as geom
FROM test.line_43;

-- Index geom
CREATE INDEX tampon_43_line_gix ON test.tampon_43_line USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_43_line ALTER COLUMN geom type geometry(MultiPolygon, 2434) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_43_line  ;
CREATE TABLE test.tampon_extract_union_43_line as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_43_line
;

-- Index geom
CREATE INDEX tampon_extract_union_43_line_gix ON test.tampon_extract_union_43_line USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_43_line ALTER COLUMN geom type geometry(MultiPolygon, 2434) using ST_Multi(geom);
ALTER TABLE test.tampon_extract_union_43 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Fusion des deux tampons unis du pit
DROP TABLE if exists test.tampon_extract_union_43_fusion_pit  ;
CREATE TABLE test.tampon_extract_union_43_fusion_pit as 
select geom, gid
from test.tampon_extract_union_43_all
union all
select geom, gid
from test.tampon_extract_union_43;

-- Index geom
CREATE INDEX tampon_extract_union_43_fusion_pit_gix ON test.tampon_extract_union_43_fusion_pit USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_43_fusion_pit ALTER COLUMN geom type geometry(MultiPolygon, 2434) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_43_pit  ;
CREATE TABLE test.tampon_extract_union_43_pit as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_extract_union_43_fusion_pit
;

-- Index geom
CREATE INDEX tampon_extract_union_43_pit_gix ON test.tampon_extract_union_43_pit USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_43_pit ALTER COLUMN geom type geometry(MultiPolygon, 2434) using ST_Multi(geom);

ALTER TABLE test.tampon_extract_union_43_line ADD COLUMN gid SERIAL PRIMARY KEY;



-- difference
DROP TABLE IF EXISTS test.buffer_difference_line_43;
CREATE TABLE test.buffer_difference_line_43 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_43_line b join test.tampon_extract_union_43_pit a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_43_line b left join temp t on b.gid = t.gid;

ALTER TABLE test.buffer_difference_line_43 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'exterieur du buffer entier et du pit(par dpt)
DROP TABLE IF EXISTS test.line_out_poly_line_43;
CREATE TABLE test.line_out_poly_line_43 AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_line_43 as tpolygone,
    test.line_43 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;



-- Index geometrique
CREATE INDEX line_out_poly_line_43_gix ON test.line_out_poly_line_43 USING GIST (geom);
ALTER TABLE test.line_out_poly_line_43 ADD COLUMN gid SERIAL PRIMARY KEY;

-- Union des lignes en dehors du buffer en mode pose 0/1/7
drop table if exists aura.line_out_43;
create table aura.line_out_43 as 
SELECT idligne, id, type, emprise, geom
FROM test.line_out_poly_43
union all
select idligne, id, type, emprise, geom
from test.line_out_poly_line_43;
-- Index geometrique
CREATE INDEX line_out_43_gix ON aura.line_out_43 USING GIST (geom);
ALTER TABLE aura.line_out_43 ADD COLUMN gid SERIAL PRIMARY KEY;

-- Mise à jour champ emprise avec valeur 'GC_A_CREER'
UPDATE aura.line_out_43 set emprise = 'GC_A_CREER';
ALTER TABLE aura.line_out_43 ALTER COLUMN geom type geometry(MultiLinestring, 2434) using ST_Multi(geom);

--- Tampon autour de line_out_43
DROP TABLE IF EXISTS test.tampon_line_out_43;
CREATE TABLE test.tampon_line_out_43 as 
SELECT gid, id, type, emprise, st_buffer(geom,0.001) as geom
FROM aura.line_out_43;

-- Index geom
CREATE INDEX tampon_line_out_43_gix ON test.tampon_line_out_43 USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_line_out_43 ALTER COLUMN geom type geometry(MultiPolygon, 2434) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_43_line_out ;
CREATE TABLE test.tampon_extract_union_43_line_out as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_line_out_43
;

-- Index geom
CREATE INDEX tampon_extract_union_43_line_out_gix ON test.tampon_extract_union_43_line_out USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_43_line_out ALTER COLUMN geom type geometry(MultiPolygon, 2434) using ST_Multi(geom);
ALTER TABLE test.tampon_extract_union_43_line_out ADD COLUMN gid SERIAL PRIMARY KEY;


-- Diffrence entre tampon tout pit et tampon 0/1/7 unis
DROP TABLE IF EXISTS test.buffer_difference_in_43;
CREATE TABLE test.buffer_difference_in_43 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_43 b join test.tampon_extract_union_43_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_43 b left join temp t on b.gid = t.gid;


ALTER TABLE test.buffer_difference_in_43 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 0 unis
DROP TABLE IF EXISTS test.buffer_difference_in_43_ibloaerien;
CREATE TABLE test.buffer_difference_in_43_ibloaerien AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_43_ibloaerien b join test.tampon_extract_union_43_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_43_ibloaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_43_ibloaerien_gix ON test.buffer_difference_in_43_ibloaerien USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_43_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 1 unis
DROP TABLE IF EXISTS test.buffer_difference_in_43_enedisaerien;
CREATE TABLE test.buffer_difference_in_43_enedisaerien AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_43_enedisaerien b join test.tampon_extract_union_43_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_43_enedisaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_43_enedisaerien_gix ON test.buffer_difference_in_43_enedisaerien USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_43_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 7 unis
DROP TABLE IF EXISTS test.buffer_difference_in_43_iblosout;
CREATE TABLE test.buffer_difference_in_43_iblosout AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_43_iblosout b join test.tampon_extract_union_43_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_43_iblosout b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_43_iblosout_gix ON test.buffer_difference_in_43_iblosout USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_43_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre  0 et 7 pour ne garder que ce qui ne se superpose pas à 7

DROP TABLE IF EXISTS test.buffer_difference_in_43_ibloaerien_decoup;
CREATE TABLE test.buffer_difference_in_43_ibloaerien_decoup AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_43_ibloaerien b join test.buffer_difference_in_43_iblosout a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_43_ibloaerien b left join temp t on b.gid = t.gid;


-- Index geom
CREATE INDEX buffer_difference_in_43_ibloaerien_decoup_gix ON test.buffer_difference_in_43_ibloaerien_decoup USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_43_ibloaerien_decoup ADD COLUMN gid SERIAL PRIMARY KEY;

-- Difference entre  1 et 7 pour ne garder que ce qui ne se superpose pas à 7


DROP TABLE IF EXISTS test.buffer_difference_in_43_enedisaerien_decoup;
CREATE TABLE test.buffer_difference_in_43_enedisaerien_decoup AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_43_enedisaerien b join test.buffer_difference_in_43_iblosout a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_43_enedisaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_43_enedisaerien_decoup_gix ON test.buffer_difference_in_43_enedisaerien_decoup USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_43_enedisaerien_decoup ADD COLUMN gid SERIAL PRIMARY KEY;

-- Difference entre  1 (après découp sur 7) et 0 pour ne garder que ce qui ne se superpose pas à 0



DROP TABLE IF EXISTS test.buffer_difference_in_43_enedisaerien_decoup_left;
CREATE TABLE test.buffer_difference_in_43_enedisaerien_decoup_left AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_43_enedisaerien_decoup b join test.buffer_difference_in_43_ibloaerien a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_43_enedisaerien_decoup b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_43_enedisaerien_decoup_left_gix ON test.buffer_difference_in_43_enedisaerien_decoup_left USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_43_enedisaerien_decoup_left ADD COLUMN gid SERIAL PRIMARY KEY;


-- Table de buffer finale

DROP TABLE IF EXISTS aura.buffer_in_43;
CREATE TABLE aura.buffer_in_43 AS
select mode_pose, geom
from test.buffer_difference_in_43_iblosout
union all
select mode_pose, geom
from test.buffer_difference_in_43_ibloaerien_decoup
union all
select mode_pose, geom
from test.buffer_difference_in_43_enedisaerien_decoup_left;

CREATE INDEX buffer_in_43_gix ON aura.buffer_in_43 USING GIST (geom);  
ALTER TABLE aura.buffer_in_43 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.buffer_in_43 ALTER COLUMN geom type geometry(MultiPolygon, 2434) using ST_Multi(geom);

-- Decoupage de lignes à l'intérieur du buffer entier 7(par dpt)
DROP TABLE IF EXISTS test.line_in_43_iblosout;
CREATE TABLE test.line_in_43_iblosout AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_43_iblosout as tpolygone,
    test.line_43 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_43_iblosout_gix ON test.line_in_43_iblosout USING GIST (geom);
ALTER TABLE test.line_in_43_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;





-- Decoupage de lignes à l'intérieur du buffer entier 0(par dpt)
DROP TABLE IF EXISTS test.line_in_43_ibloaerien;
CREATE TABLE test.line_in_43_ibloaerien AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_43_ibloaerien_decoup as tpolygone,
    test.line_43 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_43_ibloaerien_gix ON test.line_in_43_ibloaerien USING GIST (geom);
ALTER TABLE test.line_in_43_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'intérieur du buffer entier 1(par dpt)
DROP TABLE IF EXISTS test.line_in_43_enedisaerien;
CREATE TABLE test.line_in_43_enedisaerien AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_43_enedisaerien_decoup_left as tpolygone,
    test.line_43 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_43_enedisaerien_gix ON test.line_in_43_enedisaerien USING GIST (geom);
ALTER TABLE test.line_in_43_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;

-- Union des lignes à l'intérieur des buffers 0/1/7
DROP TABLE IF EXISTS aura.line_in_43;
CREATE TABLE aura.line_in_43 AS
select idligne, id, type, 'IBLO_SOUTERRAIN'::varchar (20) as emprise, geom
from test.line_in_43_iblosout
union all
select idligne, id, type,'ENEDIS_AERIEN'::varchar (20) as emprise, geom
from test.line_in_43_enedisaerien
union all
select idligne, id, type, 'IBLO_AERIEN'::varchar (20) as emprise, geom
from test.line_in_43_ibloaerien;

CREATE INDEX line_in_43_gix ON aura.line_in_43 USING GIST (geom);
ALTER TABLE aura.line_in_43 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.line_in_43 ALTER COLUMN geom type geometry(MultiLinestring, 2434) using ST_Multi(geom);

-- Union des 2 tables lignes (intérieur/extérieur)
DROP TABLE IF EXISTS aura.line_type_43;
CREATE TABLE aura.line_type_43 AS
select id, type, emprise, geom
from aura.line_in_43
union all
select id, type, emprise, geom
from aura.line_out_43;

CREATE INDEX line_type_43_gix ON aura.line_type_43 USING GIST (geom);
ALTER TABLE aura.line_type_43 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.line_type_43 ALTER COLUMN geom type geometry(MultiLinestring, 2434) using ST_Multi(geom);

-- Suppression tables intermediaires;
drop table if exists test.tampon_43 ;
drop table if exists test.tampon_43_ibloaerien;
drop table if exists test.tampon_43_enedisaerien;
drop table if exists test.tampon_43_all;
drop table if exists test.tampon_43_iblosout;
drop table if exists test.tampon_extract_union_43;
drop table if exists test.tampon_extract_union_43_ibloaerien;
drop table if exists test.tampon_extract_union_43_enedisaerien;
drop table if exists test.tampon_extract_union_43_iblosout;
drop table if exists test.tampon_extract_union_43_all;
drop table if exists test.buffer_difference_43;
drop table if exists test.line_out_poly_43;
drop table if exists test.tampon_43_line;
drop table if exists test.tampon_extract_union_43_line;
drop table if exists test.tampon_extract_union_43_fusion_pit;
drop table if exists test.tampon_extract_union_43_pit;
drop table if exists test.buffer_difference_line_43;
drop table if exists test.line_out_poly_line_43;
drop table if exists test.tampon_line_out_43;
drop table if exists test.tampon_extract_union_43_line_out ;
drop table if exists test.buffer_difference_in_43;
drop table if exists test.buffer_difference_in_43_ibloaerien;
drop table if exists test.buffer_difference_in_43_enedisaerien;
drop table if exists test.buffer_difference_in_43_iblosout;
drop table if exists test.buffer_difference_in_43_ibloaerien_decoup;
drop table if exists test.buffer_difference_in_43_enedisaerien_decoup;
drop table if exists test.buffer_difference_in_43_enedisaerien_decoup_left;
drop table if exists test.line_in_43_iblosout;
drop table if exists test.line_in_43_ibloaerien;
drop table if exists test.line_in_43_enedisaerien;


-- DEPARTEMENT 26


-- Tampon avec mode de pose 0/1/7
DROP TABLE IF EXISTS test.tampon_26;
CREATE TABLE test.tampon_26 as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 40) as geom
FROM test.arciti_26
where mode_pose like '0' or mode_pose like '1' or mode_pose like '7';
-- Index geom
CREATE INDEX tampon_26_gix ON test.tampon_26 USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_26 ALTER COLUMN geom type geometry(MultiPolygon, 2264) using ST_Multi(geom);

-- Tampon avec mode de pose 0
DROP TABLE IF EXISTS test.tampon_26_ibloaerien;
CREATE TABLE test.tampon_26_ibloaerien as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 40) as geom
FROM test.arciti_26
where mode_pose like '0' ;
-- Index geom
CREATE INDEX tampon_26_ibloaerien_gix ON test.tampon_26_ibloaerien USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_26_ibloaerien ALTER COLUMN geom type geometry(MultiPolygon, 2264) using ST_Multi(geom);

-- Tampon avec mode de pose 1
DROP TABLE IF EXISTS test.tampon_26_enedisaerien;
CREATE TABLE test.tampon_26_enedisaerien as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 40) as geom
FROM test.arciti_26
where mode_pose like '1' ;
-- Index geom
CREATE INDEX tampon_26_enedisaerien_gix ON test.tampon_26_enedisaerien USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_26_enedisaerien ALTER COLUMN geom type geometry(MultiPolygon, 2264) using ST_Multi(geom);

-- Tampon avec mode de pose 7
DROP TABLE IF EXISTS test.tampon_26_iblosout;
CREATE TABLE test.tampon_26_iblosout as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 40) as geom
FROM test.arciti_26
where mode_pose like '7' ;
-- Index geom
CREATE INDEX tampon_26_iblosout_gix ON test.tampon_26_iblosout USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_26_iblosout ALTER COLUMN geom type geometry(MultiPolygon, 2264) using ST_Multi(geom);


-- Tampon avec tous modes de pose 
DROP TABLE IF EXISTS test.tampon_26_all;
CREATE TABLE test.tampon_26_all as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 40) as geom
FROM test.arciti_26;
-- Index geometrique
CREATE INDEX tampon_26_all_gix ON test.tampon_26_all USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_26_all ALTER COLUMN geom type geometry(MultiPolygon, 2264) using ST_Multi(geom);


-- Union des tampons 0/1/7 en un polygone 
DROP TABLE if exists test.tampon_extract_union_26  ;
CREATE TABLE test.tampon_extract_union_26 as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_26
;
-- Index geometrique
CREATE INDEX tampon_extract_union_26_gix ON test.tampon_extract_union_26 USING GIST (geom);


-- Union des tampons 0 en un polygone 
DROP TABLE if exists test.tampon_extract_union_26_ibloaerien  ;
CREATE TABLE test.tampon_extract_union_26_ibloaerien as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, '0'::varchar as mode_pose
FROM 
    test.tampon_26_ibloaerien
;
-- Index geometrique
CREATE INDEX tampon_extract_union_26_ibloaerien_gix ON test.tampon_extract_union_26_ibloaerien USING GIST (geom);
ALTER TABLE test.tampon_extract_union_26_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union des tampons 1 en un polygone 
DROP TABLE if exists test.tampon_extract_union_26_enedisaerien  ;
CREATE TABLE test.tampon_extract_union_26_enedisaerien as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, '1'::varchar as mode_pose
FROM 
    test.tampon_26_enedisaerien
;
-- Index geometrique
CREATE INDEX tampon_extract_union_26_enedisaerien_gix ON test.tampon_extract_union_26_enedisaerien USING GIST (geom);
ALTER TABLE test.tampon_extract_union_26_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union des tampons 7 en un polygone 
DROP TABLE if exists test.tampon_extract_union_26_iblosout  ;
CREATE TABLE test.tampon_extract_union_26_iblosout as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom,  '7'::varchar as mode_pose
FROM 
    test.tampon_26_iblosout
;
-- Index geometrique
CREATE INDEX tampon_extract_union_26_iblosout_gix ON test.tampon_extract_union_26_iblosout USING GIST (geom);

ALTER TABLE test.tampon_extract_union_26_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union de tous les tampons en un polygone 
DROP TABLE if exists test.tampon_extract_union_26_all  ;
CREATE TABLE test.tampon_extract_union_26_all as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, 7
FROM 
    test.tampon_26_all
;


-- Index geometrique
CREATE INDEX tampon_extract_union_26_all_gix ON test.tampon_extract_union_26_all USING GIST (geom);
ALTER TABLE test.tampon_extract_union_26_all ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 0/1/7 unis
DROP TABLE IF EXISTS test.buffer_difference_26;
CREATE TABLE test.buffer_difference_26 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_26_all b join test.tampon_extract_union_26 a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_26_all b left join temp t on b.gid = t.gid;


ALTER TABLE test.buffer_difference_26 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'exterieur du buffer entier (par dpt)
DROP TABLE IF EXISTS test.line_out_poly_26;
CREATE TABLE test.line_out_poly_26 AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_26 as tpolygone,
    test.line_26 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_out_poly_26_gix ON test.line_out_poly_26 USING GIST (geom);
ALTER TABLE test.line_out_poly_26 ADD COLUMN gid SERIAL PRIMARY KEY;

--- Tampon avec mode de pose 0/1/7
DROP TABLE IF EXISTS test.tampon_26_line;
CREATE TABLE test.tampon_26_line as 
SELECT gid, id, type, emprise, st_buffer(geom, 1) as geom
FROM test.line_26;

-- Index geom
CREATE INDEX tampon_26_line_gix ON test.tampon_26_line USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_26_line ALTER COLUMN geom type geometry(MultiPolygon, 2264) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_26_line  ;
CREATE TABLE test.tampon_extract_union_26_line as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_26_line
;

-- Index geom
CREATE INDEX tampon_extract_union_26_line_gix ON test.tampon_extract_union_26_line USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_26_line ALTER COLUMN geom type geometry(MultiPolygon, 2264) using ST_Multi(geom);
ALTER TABLE test.tampon_extract_union_26 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Fusion des deux tampons unis du pit
DROP TABLE if exists test.tampon_extract_union_26_fusion_pit  ;
CREATE TABLE test.tampon_extract_union_26_fusion_pit as 
select geom, gid
from test.tampon_extract_union_26_all
union all
select geom, gid
from test.tampon_extract_union_26;

-- Index geom
CREATE INDEX tampon_extract_union_26_fusion_pit_gix ON test.tampon_extract_union_26_fusion_pit USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_26_fusion_pit ALTER COLUMN geom type geometry(MultiPolygon, 2264) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_26_pit  ;
CREATE TABLE test.tampon_extract_union_26_pit as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_extract_union_26_fusion_pit
;

-- Index geom
CREATE INDEX tampon_extract_union_26_pit_gix ON test.tampon_extract_union_26_pit USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_26_pit ALTER COLUMN geom type geometry(MultiPolygon, 2264) using ST_Multi(geom);

ALTER TABLE test.tampon_extract_union_26_line ADD COLUMN gid SERIAL PRIMARY KEY;



-- difference
DROP TABLE IF EXISTS test.buffer_difference_line_26;
CREATE TABLE test.buffer_difference_line_26 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_26_line b join test.tampon_extract_union_26_pit a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_26_line b left join temp t on b.gid = t.gid;

ALTER TABLE test.buffer_difference_line_26 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'exterieur du buffer entier et du pit(par dpt)
DROP TABLE IF EXISTS test.line_out_poly_line_26;
CREATE TABLE test.line_out_poly_line_26 AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_line_26 as tpolygone,
    test.line_26 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;



-- Index geometrique
CREATE INDEX line_out_poly_line_26_gix ON test.line_out_poly_line_26 USING GIST (geom);
ALTER TABLE test.line_out_poly_line_26 ADD COLUMN gid SERIAL PRIMARY KEY;

-- Union des lignes en dehors du buffer en mode pose 0/1/7
drop table if exists aura.line_out_26;
create table aura.line_out_26 as 
SELECT idligne, id, type, emprise, geom
FROM test.line_out_poly_26
union all
select idligne, id, type, emprise, geom
from test.line_out_poly_line_26;
-- Index geometrique
CREATE INDEX line_out_26_gix ON aura.line_out_26 USING GIST (geom);
ALTER TABLE aura.line_out_26 ADD COLUMN gid SERIAL PRIMARY KEY;

-- Mise à jour champ emprise avec valeur 'GC_A_CREER'
UPDATE aura.line_out_26 set emprise = 'GC_A_CREER';
ALTER TABLE aura.line_out_26 ALTER COLUMN geom type geometry(MultiLinestring, 2264) using ST_Multi(geom);

--- Tampon autour de line_out_26
DROP TABLE IF EXISTS test.tampon_line_out_26;
CREATE TABLE test.tampon_line_out_26 as 
SELECT gid, id, type, emprise, st_buffer(geom,0.001) as geom
FROM aura.line_out_26;

-- Index geom
CREATE INDEX tampon_line_out_26_gix ON test.tampon_line_out_26 USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_line_out_26 ALTER COLUMN geom type geometry(MultiPolygon, 2264) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_26_line_out ;
CREATE TABLE test.tampon_extract_union_26_line_out as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_line_out_26
;

-- Index geom
CREATE INDEX tampon_extract_union_26_line_out_gix ON test.tampon_extract_union_26_line_out USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_26_line_out ALTER COLUMN geom type geometry(MultiPolygon, 2264) using ST_Multi(geom);
ALTER TABLE test.tampon_extract_union_26_line_out ADD COLUMN gid SERIAL PRIMARY KEY;


-- Diffrence entre tampon tout pit et tampon 0/1/7 unis
DROP TABLE IF EXISTS test.buffer_difference_in_26;
CREATE TABLE test.buffer_difference_in_26 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_26 b join test.tampon_extract_union_26_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_26 b left join temp t on b.gid = t.gid;


ALTER TABLE test.buffer_difference_in_26 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 0 unis
DROP TABLE IF EXISTS test.buffer_difference_in_26_ibloaerien;
CREATE TABLE test.buffer_difference_in_26_ibloaerien AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_26_ibloaerien b join test.tampon_extract_union_26_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_26_ibloaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_26_ibloaerien_gix ON test.buffer_difference_in_26_ibloaerien USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_26_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 1 unis
DROP TABLE IF EXISTS test.buffer_difference_in_26_enedisaerien;
CREATE TABLE test.buffer_difference_in_26_enedisaerien AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_26_enedisaerien b join test.tampon_extract_union_26_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_26_enedisaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_26_enedisaerien_gix ON test.buffer_difference_in_26_enedisaerien USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_26_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 7 unis
DROP TABLE IF EXISTS test.buffer_difference_in_26_iblosout;
CREATE TABLE test.buffer_difference_in_26_iblosout AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_26_iblosout b join test.tampon_extract_union_26_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_26_iblosout b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_26_iblosout_gix ON test.buffer_difference_in_26_iblosout USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_26_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre  0 et 7 pour ne garder que ce qui ne se superpose pas à 7

DROP TABLE IF EXISTS test.buffer_difference_in_26_ibloaerien_decoup;
CREATE TABLE test.buffer_difference_in_26_ibloaerien_decoup AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_26_ibloaerien b join test.buffer_difference_in_26_iblosout a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_26_ibloaerien b left join temp t on b.gid = t.gid;


-- Index geom
CREATE INDEX buffer_difference_in_26_ibloaerien_decoup_gix ON test.buffer_difference_in_26_ibloaerien_decoup USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_26_ibloaerien_decoup ADD COLUMN gid SERIAL PRIMARY KEY;

-- Difference entre  1 et 7 pour ne garder que ce qui ne se superpose pas à 7


DROP TABLE IF EXISTS test.buffer_difference_in_26_enedisaerien_decoup;
CREATE TABLE test.buffer_difference_in_26_enedisaerien_decoup AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_26_enedisaerien b join test.buffer_difference_in_26_iblosout a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_26_enedisaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_26_enedisaerien_decoup_gix ON test.buffer_difference_in_26_enedisaerien_decoup USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_26_enedisaerien_decoup ADD COLUMN gid SERIAL PRIMARY KEY;

-- Difference entre  1 (après découp sur 7) et 0 pour ne garder que ce qui ne se superpose pas à 0



DROP TABLE IF EXISTS test.buffer_difference_in_26_enedisaerien_decoup_left;
CREATE TABLE test.buffer_difference_in_26_enedisaerien_decoup_left AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_26_enedisaerien_decoup b join test.buffer_difference_in_26_ibloaerien a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_26_enedisaerien_decoup b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_26_enedisaerien_decoup_left_gix ON test.buffer_difference_in_26_enedisaerien_decoup_left USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_26_enedisaerien_decoup_left ADD COLUMN gid SERIAL PRIMARY KEY;


-- Table de buffer finale

DROP TABLE IF EXISTS aura.buffer_in_26;
CREATE TABLE aura.buffer_in_26 AS
select mode_pose, geom
from test.buffer_difference_in_26_iblosout
union all
select mode_pose, geom
from test.buffer_difference_in_26_ibloaerien_decoup
union all
select mode_pose, geom
from test.buffer_difference_in_26_enedisaerien_decoup_left;

CREATE INDEX buffer_in_26_gix ON aura.buffer_in_26 USING GIST (geom);  
ALTER TABLE aura.buffer_in_26 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.buffer_in_26 ALTER COLUMN geom type geometry(MultiPolygon, 2264) using ST_Multi(geom);

-- Decoupage de lignes à l'intérieur du buffer entier 7(par dpt)
DROP TABLE IF EXISTS test.line_in_26_iblosout;
CREATE TABLE test.line_in_26_iblosout AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_26_iblosout as tpolygone,
    test.line_26 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_26_iblosout_gix ON test.line_in_26_iblosout USING GIST (geom);
ALTER TABLE test.line_in_26_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;





-- Decoupage de lignes à l'intérieur du buffer entier 0(par dpt)
DROP TABLE IF EXISTS test.line_in_26_ibloaerien;
CREATE TABLE test.line_in_26_ibloaerien AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_26_ibloaerien_decoup as tpolygone,
    test.line_26 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_26_ibloaerien_gix ON test.line_in_26_ibloaerien USING GIST (geom);
ALTER TABLE test.line_in_26_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'intérieur du buffer entier 1(par dpt)
DROP TABLE IF EXISTS test.line_in_26_enedisaerien;
CREATE TABLE test.line_in_26_enedisaerien AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_26_enedisaerien_decoup_left as tpolygone,
    test.line_26 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_26_enedisaerien_gix ON test.line_in_26_enedisaerien USING GIST (geom);
ALTER TABLE test.line_in_26_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;

-- Union des lignes à l'intérieur des buffers 0/1/7
DROP TABLE IF EXISTS aura.line_in_26;
CREATE TABLE aura.line_in_26 AS
select idligne, id, type, 'IBLO_SOUTERRAIN'::varchar (20) as emprise, geom
from test.line_in_26_iblosout
union all
select idligne, id, type,'ENEDIS_AERIEN'::varchar (20) as emprise, geom
from test.line_in_26_enedisaerien
union all
select idligne, id, type, 'IBLO_AERIEN'::varchar (20) as emprise, geom
from test.line_in_26_ibloaerien;

CREATE INDEX line_in_26_gix ON aura.line_in_26 USING GIST (geom);
ALTER TABLE aura.line_in_26 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.line_in_26 ALTER COLUMN geom type geometry(MultiLinestring, 2264) using ST_Multi(geom);

-- Union des 2 tables lignes (intérieur/extérieur)
DROP TABLE IF EXISTS aura.line_type_26;
CREATE TABLE aura.line_type_26 AS
select id, type, emprise, geom
from aura.line_in_26
union all
select id, type, emprise, geom
from aura.line_out_26;

CREATE INDEX line_type_26_gix ON aura.line_type_26 USING GIST (geom);
ALTER TABLE aura.line_type_26 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.line_type_26 ALTER COLUMN geom type geometry(MultiLinestring, 2264) using ST_Multi(geom);

-- Suppression tables intermediaires;
drop table if exists test.tampon_26 ;
drop table if exists test.tampon_26_ibloaerien;
drop table if exists test.tampon_26_enedisaerien;
drop table if exists test.tampon_26_all;
drop table if exists test.tampon_26_iblosout;
drop table if exists test.tampon_extract_union_26;
drop table if exists test.tampon_extract_union_26_ibloaerien;
drop table if exists test.tampon_extract_union_26_enedisaerien;
drop table if exists test.tampon_extract_union_26_iblosout;
drop table if exists test.tampon_extract_union_26_all;
drop table if exists test.buffer_difference_26;
drop table if exists test.line_out_poly_26;
drop table if exists test.tampon_26_line;
drop table if exists test.tampon_extract_union_26_line;
drop table if exists test.tampon_extract_union_26_fusion_pit;
drop table if exists test.tampon_extract_union_26_pit;
drop table if exists test.buffer_difference_line_26;
drop table if exists test.line_out_poly_line_26;
drop table if exists test.tampon_line_out_26;
drop table if exists test.tampon_extract_union_26_line_out ;
drop table if exists test.buffer_difference_in_26;
drop table if exists test.buffer_difference_in_26_ibloaerien;
drop table if exists test.buffer_difference_in_26_enedisaerien;
drop table if exists test.buffer_difference_in_26_iblosout;
drop table if exists test.buffer_difference_in_26_ibloaerien_decoup;
drop table if exists test.buffer_difference_in_26_enedisaerien_decoup;
drop table if exists test.buffer_difference_in_26_enedisaerien_decoup_left;
drop table if exists test.line_in_26_iblosout;
drop table if exists test.line_in_26_ibloaerien;
drop table if exists test.line_in_26_enedisaerien;


-- DEPARTEMENT 07


-- Tampon avec mode de pose 0/1/7
DROP TABLE IF EXISTS test.tampon_07;
CREATE TABLE test.tampon_07 as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 40) as geom
FROM test.arciti_07
where mode_pose like '0' or mode_pose like '1' or mode_pose like '7';
-- Index geom
CREATE INDEX tampon_07_gix ON test.tampon_07 USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_07 ALTER COLUMN geom type geometry(MultiPolygon, 2074) using ST_Multi(geom);

-- Tampon avec mode de pose 0
DROP TABLE IF EXISTS test.tampon_07_ibloaerien;
CREATE TABLE test.tampon_07_ibloaerien as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 40) as geom
FROM test.arciti_07
where mode_pose like '0' ;
-- Index geom
CREATE INDEX tampon_07_ibloaerien_gix ON test.tampon_07_ibloaerien USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_07_ibloaerien ALTER COLUMN geom type geometry(MultiPolygon, 2074) using ST_Multi(geom);

-- Tampon avec mode de pose 1
DROP TABLE IF EXISTS test.tampon_07_enedisaerien;
CREATE TABLE test.tampon_07_enedisaerien as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 40) as geom
FROM test.arciti_07
where mode_pose like '1' ;
-- Index geom
CREATE INDEX tampon_07_enedisaerien_gix ON test.tampon_07_enedisaerien USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_07_enedisaerien ALTER COLUMN geom type geometry(MultiPolygon, 2074) using ST_Multi(geom);

-- Tampon avec mode de pose 7
DROP TABLE IF EXISTS test.tampon_07_iblosout;
CREATE TABLE test.tampon_07_iblosout as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 40) as geom
FROM test.arciti_07
where mode_pose like '7' ;
-- Index geom
CREATE INDEX tampon_07_iblosout_gix ON test.tampon_07_iblosout USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_07_iblosout ALTER COLUMN geom type geometry(MultiPolygon, 2074) using ST_Multi(geom);


-- Tampon avec tous modes de pose 
DROP TABLE IF EXISTS test.tampon_07_all;
CREATE TABLE test.tampon_07_all as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 40) as geom
FROM test.arciti_07;
-- Index geometrique
CREATE INDEX tampon_07_all_gix ON test.tampon_07_all USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_07_all ALTER COLUMN geom type geometry(MultiPolygon, 2074) using ST_Multi(geom);


-- Union des tampons 0/1/7 en un polygone 
DROP TABLE if exists test.tampon_extract_union_07  ;
CREATE TABLE test.tampon_extract_union_07 as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_07
;
-- Index geometrique
CREATE INDEX tampon_extract_union_07_gix ON test.tampon_extract_union_07 USING GIST (geom);


-- Union des tampons 0 en un polygone 
DROP TABLE if exists test.tampon_extract_union_07_ibloaerien  ;
CREATE TABLE test.tampon_extract_union_07_ibloaerien as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, '0'::varchar as mode_pose
FROM 
    test.tampon_07_ibloaerien
;
-- Index geometrique
CREATE INDEX tampon_extract_union_07_ibloaerien_gix ON test.tampon_extract_union_07_ibloaerien USING GIST (geom);
ALTER TABLE test.tampon_extract_union_07_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union des tampons 1 en un polygone 
DROP TABLE if exists test.tampon_extract_union_07_enedisaerien  ;
CREATE TABLE test.tampon_extract_union_07_enedisaerien as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, '1'::varchar as mode_pose
FROM 
    test.tampon_07_enedisaerien
;
-- Index geometrique
CREATE INDEX tampon_extract_union_07_enedisaerien_gix ON test.tampon_extract_union_07_enedisaerien USING GIST (geom);
ALTER TABLE test.tampon_extract_union_07_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union des tampons 7 en un polygone 
DROP TABLE if exists test.tampon_extract_union_07_iblosout  ;
CREATE TABLE test.tampon_extract_union_07_iblosout as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom,  '7'::varchar as mode_pose
FROM 
    test.tampon_07_iblosout
;
-- Index geometrique
CREATE INDEX tampon_extract_union_07_iblosout_gix ON test.tampon_extract_union_07_iblosout USING GIST (geom);

ALTER TABLE test.tampon_extract_union_07_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union de tous les tampons en un polygone 
DROP TABLE if exists test.tampon_extract_union_07_all  ;
CREATE TABLE test.tampon_extract_union_07_all as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, 7
FROM 
    test.tampon_07_all
;


-- Index geometrique
CREATE INDEX tampon_extract_union_07_all_gix ON test.tampon_extract_union_07_all USING GIST (geom);
ALTER TABLE test.tampon_extract_union_07_all ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 0/1/7 unis
DROP TABLE IF EXISTS test.buffer_difference_07;
CREATE TABLE test.buffer_difference_07 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_07_all b join test.tampon_extract_union_07 a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_07_all b left join temp t on b.gid = t.gid;


ALTER TABLE test.buffer_difference_07 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'exterieur du buffer entier (par dpt)
DROP TABLE IF EXISTS test.line_out_poly_07;
CREATE TABLE test.line_out_poly_07 AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_07 as tpolygone,
    test.line_07 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_out_poly_07_gix ON test.line_out_poly_07 USING GIST (geom);
ALTER TABLE test.line_out_poly_07 ADD COLUMN gid SERIAL PRIMARY KEY;

--- Tampon avec mode de pose 0/1/7
DROP TABLE IF EXISTS test.tampon_07_line;
CREATE TABLE test.tampon_07_line as 
SELECT gid, id, type, emprise, st_buffer(geom, 1) as geom
FROM test.line_07;

-- Index geom
CREATE INDEX tampon_07_line_gix ON test.tampon_07_line USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_07_line ALTER COLUMN geom type geometry(MultiPolygon, 2074) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_07_line  ;
CREATE TABLE test.tampon_extract_union_07_line as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_07_line
;

-- Index geom
CREATE INDEX tampon_extract_union_07_line_gix ON test.tampon_extract_union_07_line USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_07_line ALTER COLUMN geom type geometry(MultiPolygon, 2074) using ST_Multi(geom);
ALTER TABLE test.tampon_extract_union_07 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Fusion des deux tampons unis du pit
DROP TABLE if exists test.tampon_extract_union_07_fusion_pit  ;
CREATE TABLE test.tampon_extract_union_07_fusion_pit as 
select geom, gid
from test.tampon_extract_union_07_all
union all
select geom, gid
from test.tampon_extract_union_07;

-- Index geom
CREATE INDEX tampon_extract_union_07_fusion_pit_gix ON test.tampon_extract_union_07_fusion_pit USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_07_fusion_pit ALTER COLUMN geom type geometry(MultiPolygon, 2074) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_07_pit  ;
CREATE TABLE test.tampon_extract_union_07_pit as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_extract_union_07_fusion_pit
;

-- Index geom
CREATE INDEX tampon_extract_union_07_pit_gix ON test.tampon_extract_union_07_pit USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_07_pit ALTER COLUMN geom type geometry(MultiPolygon, 2074) using ST_Multi(geom);

ALTER TABLE test.tampon_extract_union_07_line ADD COLUMN gid SERIAL PRIMARY KEY;



-- difference
DROP TABLE IF EXISTS test.buffer_difference_line_07;
CREATE TABLE test.buffer_difference_line_07 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_07_line b join test.tampon_extract_union_07_pit a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_07_line b left join temp t on b.gid = t.gid;

ALTER TABLE test.buffer_difference_line_07 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'exterieur du buffer entier et du pit(par dpt)
DROP TABLE IF EXISTS test.line_out_poly_line_07;
CREATE TABLE test.line_out_poly_line_07 AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_line_07 as tpolygone,
    test.line_07 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;



-- Index geometrique
CREATE INDEX line_out_poly_line_07_gix ON test.line_out_poly_line_07 USING GIST (geom);
ALTER TABLE test.line_out_poly_line_07 ADD COLUMN gid SERIAL PRIMARY KEY;

-- Union des lignes en dehors du buffer en mode pose 0/1/7
drop table if exists aura.line_out_07;
create table aura.line_out_07 as 
SELECT idligne, id, type, emprise, geom
FROM test.line_out_poly_07
union all
select idligne, id, type, emprise, geom
from test.line_out_poly_line_07;
-- Index geometrique
CREATE INDEX line_out_07_gix ON aura.line_out_07 USING GIST (geom);
ALTER TABLE aura.line_out_07 ADD COLUMN gid SERIAL PRIMARY KEY;

-- Mise à jour champ emprise avec valeur 'GC_A_CREER'
UPDATE aura.line_out_07 set emprise = 'GC_A_CREER';
ALTER TABLE aura.line_out_07 ALTER COLUMN geom type geometry(MultiLinestring, 2074) using ST_Multi(geom);

--- Tampon autour de line_out_07
DROP TABLE IF EXISTS test.tampon_line_out_07;
CREATE TABLE test.tampon_line_out_07 as 
SELECT gid, id, type, emprise, st_buffer(geom,0.001) as geom
FROM aura.line_out_07;

-- Index geom
CREATE INDEX tampon_line_out_07_gix ON test.tampon_line_out_07 USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_line_out_07 ALTER COLUMN geom type geometry(MultiPolygon, 2074) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_07_line_out ;
CREATE TABLE test.tampon_extract_union_07_line_out as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_line_out_07
;

-- Index geom
CREATE INDEX tampon_extract_union_07_line_out_gix ON test.tampon_extract_union_07_line_out USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_07_line_out ALTER COLUMN geom type geometry(MultiPolygon, 2074) using ST_Multi(geom);
ALTER TABLE test.tampon_extract_union_07_line_out ADD COLUMN gid SERIAL PRIMARY KEY;


-- Diffrence entre tampon tout pit et tampon 0/1/7 unis
DROP TABLE IF EXISTS test.buffer_difference_in_07;
CREATE TABLE test.buffer_difference_in_07 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_07 b join test.tampon_extract_union_07_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_07 b left join temp t on b.gid = t.gid;


ALTER TABLE test.buffer_difference_in_07 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 0 unis
DROP TABLE IF EXISTS test.buffer_difference_in_07_ibloaerien;
CREATE TABLE test.buffer_difference_in_07_ibloaerien AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_07_ibloaerien b join test.tampon_extract_union_07_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_07_ibloaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_07_ibloaerien_gix ON test.buffer_difference_in_07_ibloaerien USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_07_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 1 unis
DROP TABLE IF EXISTS test.buffer_difference_in_07_enedisaerien;
CREATE TABLE test.buffer_difference_in_07_enedisaerien AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_07_enedisaerien b join test.tampon_extract_union_07_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_07_enedisaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_07_enedisaerien_gix ON test.buffer_difference_in_07_enedisaerien USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_07_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 7 unis
DROP TABLE IF EXISTS test.buffer_difference_in_07_iblosout;
CREATE TABLE test.buffer_difference_in_07_iblosout AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_07_iblosout b join test.tampon_extract_union_07_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_07_iblosout b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_07_iblosout_gix ON test.buffer_difference_in_07_iblosout USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_07_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre  0 et 7 pour ne garder que ce qui ne se superpose pas à 7

DROP TABLE IF EXISTS test.buffer_difference_in_07_ibloaerien_decoup;
CREATE TABLE test.buffer_difference_in_07_ibloaerien_decoup AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_07_ibloaerien b join test.buffer_difference_in_07_iblosout a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_07_ibloaerien b left join temp t on b.gid = t.gid;


-- Index geom
CREATE INDEX buffer_difference_in_07_ibloaerien_decoup_gix ON test.buffer_difference_in_07_ibloaerien_decoup USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_07_ibloaerien_decoup ADD COLUMN gid SERIAL PRIMARY KEY;

-- Difference entre  1 et 7 pour ne garder que ce qui ne se superpose pas à 7


DROP TABLE IF EXISTS test.buffer_difference_in_07_enedisaerien_decoup;
CREATE TABLE test.buffer_difference_in_07_enedisaerien_decoup AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_07_enedisaerien b join test.buffer_difference_in_07_iblosout a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_07_enedisaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_07_enedisaerien_decoup_gix ON test.buffer_difference_in_07_enedisaerien_decoup USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_07_enedisaerien_decoup ADD COLUMN gid SERIAL PRIMARY KEY;

-- Difference entre  1 (après découp sur 7) et 0 pour ne garder que ce qui ne se superpose pas à 0



DROP TABLE IF EXISTS test.buffer_difference_in_07_enedisaerien_decoup_left;
CREATE TABLE test.buffer_difference_in_07_enedisaerien_decoup_left AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_07_enedisaerien_decoup b join test.buffer_difference_in_07_ibloaerien a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_07_enedisaerien_decoup b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_07_enedisaerien_decoup_left_gix ON test.buffer_difference_in_07_enedisaerien_decoup_left USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_07_enedisaerien_decoup_left ADD COLUMN gid SERIAL PRIMARY KEY;


-- Table de buffer finale

DROP TABLE IF EXISTS aura.buffer_in_07;
CREATE TABLE aura.buffer_in_07 AS
select mode_pose, geom
from test.buffer_difference_in_07_iblosout
union all
select mode_pose, geom
from test.buffer_difference_in_07_ibloaerien_decoup
union all
select mode_pose, geom
from test.buffer_difference_in_07_enedisaerien_decoup_left;

CREATE INDEX buffer_in_07_gix ON aura.buffer_in_07 USING GIST (geom);  
ALTER TABLE aura.buffer_in_07 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.buffer_in_07 ALTER COLUMN geom type geometry(MultiPolygon, 2074) using ST_Multi(geom);

-- Decoupage de lignes à l'intérieur du buffer entier 7(par dpt)
DROP TABLE IF EXISTS test.line_in_07_iblosout;
CREATE TABLE test.line_in_07_iblosout AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_07_iblosout as tpolygone,
    test.line_07 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_07_iblosout_gix ON test.line_in_07_iblosout USING GIST (geom);
ALTER TABLE test.line_in_07_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;





-- Decoupage de lignes à l'intérieur du buffer entier 0(par dpt)
DROP TABLE IF EXISTS test.line_in_07_ibloaerien;
CREATE TABLE test.line_in_07_ibloaerien AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_07_ibloaerien_decoup as tpolygone,
    test.line_07 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_07_ibloaerien_gix ON test.line_in_07_ibloaerien USING GIST (geom);
ALTER TABLE test.line_in_07_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'intérieur du buffer entier 1(par dpt)
DROP TABLE IF EXISTS test.line_in_07_enedisaerien;
CREATE TABLE test.line_in_07_enedisaerien AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_07_enedisaerien_decoup_left as tpolygone,
    test.line_07 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_07_enedisaerien_gix ON test.line_in_07_enedisaerien USING GIST (geom);
ALTER TABLE test.line_in_07_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;

-- Union des lignes à l'intérieur des buffers 0/1/7
DROP TABLE IF EXISTS aura.line_in_07;
CREATE TABLE aura.line_in_07 AS
select idligne, id, type, 'IBLO_SOUTERRAIN'::varchar (20) as emprise, geom
from test.line_in_07_iblosout
union all
select idligne, id, type,'ENEDIS_AERIEN'::varchar (20) as emprise, geom
from test.line_in_07_enedisaerien
union all
select idligne, id, type, 'IBLO_AERIEN'::varchar (20) as emprise, geom
from test.line_in_07_ibloaerien;

CREATE INDEX line_in_07_gix ON aura.line_in_07 USING GIST (geom);
ALTER TABLE aura.line_in_07 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.line_in_07 ALTER COLUMN geom type geometry(MultiLinestring, 2074) using ST_Multi(geom);

-- Union des 2 tables lignes (intérieur/extérieur)
DROP TABLE IF EXISTS aura.line_type_07;
CREATE TABLE aura.line_type_07 AS
select id, type, emprise, geom
from aura.line_in_07
union all
select id, type, emprise, geom
from aura.line_out_07;

CREATE INDEX line_type_07_gix ON aura.line_type_07 USING GIST (geom);
ALTER TABLE aura.line_type_07 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.line_type_07 ALTER COLUMN geom type geometry(MultiLinestring, 2074) using ST_Multi(geom);

-- Suppression tables intermediaires;
drop table if exists test.tampon_07 ;
drop table if exists test.tampon_07_ibloaerien;
drop table if exists test.tampon_07_enedisaerien;
drop table if exists test.tampon_07_all;
drop table if exists test.tampon_07_iblosout;
drop table if exists test.tampon_extract_union_07;
drop table if exists test.tampon_extract_union_07_ibloaerien;
drop table if exists test.tampon_extract_union_07_enedisaerien;
drop table if exists test.tampon_extract_union_07_iblosout;
drop table if exists test.tampon_extract_union_07_all;
drop table if exists test.buffer_difference_07;
drop table if exists test.line_out_poly_07;
drop table if exists test.tampon_07_line;
drop table if exists test.tampon_extract_union_07_line;
drop table if exists test.tampon_extract_union_07_fusion_pit;
drop table if exists test.tampon_extract_union_07_pit;
drop table if exists test.buffer_difference_line_07;
drop table if exists test.line_out_poly_line_07;
drop table if exists test.tampon_line_out_07;
drop table if exists test.tampon_extract_union_07_line_out ;
drop table if exists test.buffer_difference_in_07;
drop table if exists test.buffer_difference_in_07_ibloaerien;
drop table if exists test.buffer_difference_in_07_enedisaerien;
drop table if exists test.buffer_difference_in_07_iblosout;
drop table if exists test.buffer_difference_in_07_ibloaerien_decoup;
drop table if exists test.buffer_difference_in_07_enedisaerien_decoup;
drop table if exists test.buffer_difference_in_07_enedisaerien_decoup_left;
drop table if exists test.line_in_07_iblosout;
drop table if exists test.line_in_07_ibloaerien;
drop table if exists test.line_in_07_enedisaerien;


-- DEPARTEMENT 38


-- Tampon avec mode de pose 0/1/7
DROP TABLE IF EXISTS test.tampon_38;
CREATE TABLE test.tampon_38 as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 40) as geom
FROM test.arciti_38
where mode_pose like '0' or mode_pose like '1' or mode_pose like '7';
-- Index geom
CREATE INDEX tampon_38_gix ON test.tampon_38 USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_38 ALTER COLUMN geom type geometry(MultiPolygon, 2384) using ST_Multi(geom);

-- Tampon avec mode de pose 0
DROP TABLE IF EXISTS test.tampon_38_ibloaerien;
CREATE TABLE test.tampon_38_ibloaerien as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 40) as geom
FROM test.arciti_38
where mode_pose like '0' ;
-- Index geom
CREATE INDEX tampon_38_ibloaerien_gix ON test.tampon_38_ibloaerien USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_38_ibloaerien ALTER COLUMN geom type geometry(MultiPolygon, 2384) using ST_Multi(geom);

-- Tampon avec mode de pose 1
DROP TABLE IF EXISTS test.tampon_38_enedisaerien;
CREATE TABLE test.tampon_38_enedisaerien as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 40) as geom
FROM test.arciti_38
where mode_pose like '1' ;
-- Index geom
CREATE INDEX tampon_38_enedisaerien_gix ON test.tampon_38_enedisaerien USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_38_enedisaerien ALTER COLUMN geom type geometry(MultiPolygon, 2384) using ST_Multi(geom);

-- Tampon avec mode de pose 7
DROP TABLE IF EXISTS test.tampon_38_iblosout;
CREATE TABLE test.tampon_38_iblosout as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 40) as geom
FROM test.arciti_38
where mode_pose like '7' ;
-- Index geom
CREATE INDEX tampon_38_iblosout_gix ON test.tampon_38_iblosout USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_38_iblosout ALTER COLUMN geom type geometry(MultiPolygon, 2384) using ST_Multi(geom);


-- Tampon avec tous modes de pose 
DROP TABLE IF EXISTS test.tampon_38_all;
CREATE TABLE test.tampon_38_all as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 40) as geom
FROM test.arciti_38;
-- Index geometrique
CREATE INDEX tampon_38_all_gix ON test.tampon_38_all USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_38_all ALTER COLUMN geom type geometry(MultiPolygon, 2384) using ST_Multi(geom);


-- Union des tampons 0/1/7 en un polygone 
DROP TABLE if exists test.tampon_extract_union_38  ;
CREATE TABLE test.tampon_extract_union_38 as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_38
;
-- Index geometrique
CREATE INDEX tampon_extract_union_38_gix ON test.tampon_extract_union_38 USING GIST (geom);


-- Union des tampons 0 en un polygone 
DROP TABLE if exists test.tampon_extract_union_38_ibloaerien  ;
CREATE TABLE test.tampon_extract_union_38_ibloaerien as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, '0'::varchar as mode_pose
FROM 
    test.tampon_38_ibloaerien
;
-- Index geometrique
CREATE INDEX tampon_extract_union_38_ibloaerien_gix ON test.tampon_extract_union_38_ibloaerien USING GIST (geom);
ALTER TABLE test.tampon_extract_union_38_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union des tampons 1 en un polygone 
DROP TABLE if exists test.tampon_extract_union_38_enedisaerien  ;
CREATE TABLE test.tampon_extract_union_38_enedisaerien as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, '1'::varchar as mode_pose
FROM 
    test.tampon_38_enedisaerien
;
-- Index geometrique
CREATE INDEX tampon_extract_union_38_enedisaerien_gix ON test.tampon_extract_union_38_enedisaerien USING GIST (geom);
ALTER TABLE test.tampon_extract_union_38_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union des tampons 7 en un polygone 
DROP TABLE if exists test.tampon_extract_union_38_iblosout  ;
CREATE TABLE test.tampon_extract_union_38_iblosout as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom,  '7'::varchar as mode_pose
FROM 
    test.tampon_38_iblosout
;
-- Index geometrique
CREATE INDEX tampon_extract_union_38_iblosout_gix ON test.tampon_extract_union_38_iblosout USING GIST (geom);

ALTER TABLE test.tampon_extract_union_38_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union de tous les tampons en un polygone 
DROP TABLE if exists test.tampon_extract_union_38_all  ;
CREATE TABLE test.tampon_extract_union_38_all as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, 7
FROM 
    test.tampon_38_all
;


-- Index geometrique
CREATE INDEX tampon_extract_union_38_all_gix ON test.tampon_extract_union_38_all USING GIST (geom);
ALTER TABLE test.tampon_extract_union_38_all ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 0/1/7 unis
DROP TABLE IF EXISTS test.buffer_difference_38;
CREATE TABLE test.buffer_difference_38 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_38_all b join test.tampon_extract_union_38 a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_38_all b left join temp t on b.gid = t.gid;


ALTER TABLE test.buffer_difference_38 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'exterieur du buffer entier (par dpt)
DROP TABLE IF EXISTS test.line_out_poly_38;
CREATE TABLE test.line_out_poly_38 AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_38 as tpolygone,
    test.line_38 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_out_poly_38_gix ON test.line_out_poly_38 USING GIST (geom);
ALTER TABLE test.line_out_poly_38 ADD COLUMN gid SERIAL PRIMARY KEY;

--- Tampon avec mode de pose 0/1/7
DROP TABLE IF EXISTS test.tampon_38_line;
CREATE TABLE test.tampon_38_line as 
SELECT gid, id, type, emprise, st_buffer(geom, 1) as geom
FROM test.line_38;

-- Index geom
CREATE INDEX tampon_38_line_gix ON test.tampon_38_line USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_38_line ALTER COLUMN geom type geometry(MultiPolygon, 2384) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_38_line  ;
CREATE TABLE test.tampon_extract_union_38_line as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_38_line
;

-- Index geom
CREATE INDEX tampon_extract_union_38_line_gix ON test.tampon_extract_union_38_line USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_38_line ALTER COLUMN geom type geometry(MultiPolygon, 2384) using ST_Multi(geom);
ALTER TABLE test.tampon_extract_union_38 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Fusion des deux tampons unis du pit
DROP TABLE if exists test.tampon_extract_union_38_fusion_pit  ;
CREATE TABLE test.tampon_extract_union_38_fusion_pit as 
select geom, gid
from test.tampon_extract_union_38_all
union all
select geom, gid
from test.tampon_extract_union_38;

-- Index geom
CREATE INDEX tampon_extract_union_38_fusion_pit_gix ON test.tampon_extract_union_38_fusion_pit USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_38_fusion_pit ALTER COLUMN geom type geometry(MultiPolygon, 2384) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_38_pit  ;
CREATE TABLE test.tampon_extract_union_38_pit as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_extract_union_38_fusion_pit
;

-- Index geom
CREATE INDEX tampon_extract_union_38_pit_gix ON test.tampon_extract_union_38_pit USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_38_pit ALTER COLUMN geom type geometry(MultiPolygon, 2384) using ST_Multi(geom);

ALTER TABLE test.tampon_extract_union_38_line ADD COLUMN gid SERIAL PRIMARY KEY;



-- difference
DROP TABLE IF EXISTS test.buffer_difference_line_38;
CREATE TABLE test.buffer_difference_line_38 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_38_line b join test.tampon_extract_union_38_pit a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_38_line b left join temp t on b.gid = t.gid;

ALTER TABLE test.buffer_difference_line_38 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'exterieur du buffer entier et du pit(par dpt)
DROP TABLE IF EXISTS test.line_out_poly_line_38;
CREATE TABLE test.line_out_poly_line_38 AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_line_38 as tpolygone,
    test.line_38 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;



-- Index geometrique
CREATE INDEX line_out_poly_line_38_gix ON test.line_out_poly_line_38 USING GIST (geom);
ALTER TABLE test.line_out_poly_line_38 ADD COLUMN gid SERIAL PRIMARY KEY;

-- Union des lignes en dehors du buffer en mode pose 0/1/7
drop table if exists aura.line_out_38;
create table aura.line_out_38 as 
SELECT idligne, id, type, emprise, geom
FROM test.line_out_poly_38
union all
select idligne, id, type, emprise, geom
from test.line_out_poly_line_38;
-- Index geometrique
CREATE INDEX line_out_38_gix ON aura.line_out_38 USING GIST (geom);
ALTER TABLE aura.line_out_38 ADD COLUMN gid SERIAL PRIMARY KEY;

-- Mise à jour champ emprise avec valeur 'GC_A_CREER'
UPDATE aura.line_out_38 set emprise = 'GC_A_CREER';
ALTER TABLE aura.line_out_38 ALTER COLUMN geom type geometry(MultiLinestring, 2384) using ST_Multi(geom);

--- Tampon autour de line_out_38
DROP TABLE IF EXISTS test.tampon_line_out_38;
CREATE TABLE test.tampon_line_out_38 as 
SELECT gid, id, type, emprise, st_buffer(geom,0.001) as geom
FROM aura.line_out_38;

-- Index geom
CREATE INDEX tampon_line_out_38_gix ON test.tampon_line_out_38 USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_line_out_38 ALTER COLUMN geom type geometry(MultiPolygon, 2384) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_38_line_out ;
CREATE TABLE test.tampon_extract_union_38_line_out as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_line_out_38
;

-- Index geom
CREATE INDEX tampon_extract_union_38_line_out_gix ON test.tampon_extract_union_38_line_out USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_38_line_out ALTER COLUMN geom type geometry(MultiPolygon, 2384) using ST_Multi(geom);
ALTER TABLE test.tampon_extract_union_38_line_out ADD COLUMN gid SERIAL PRIMARY KEY;


-- Diffrence entre tampon tout pit et tampon 0/1/7 unis
DROP TABLE IF EXISTS test.buffer_difference_in_38;
CREATE TABLE test.buffer_difference_in_38 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_38 b join test.tampon_extract_union_38_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_38 b left join temp t on b.gid = t.gid;


ALTER TABLE test.buffer_difference_in_38 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 0 unis
DROP TABLE IF EXISTS test.buffer_difference_in_38_ibloaerien;
CREATE TABLE test.buffer_difference_in_38_ibloaerien AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_38_ibloaerien b join test.tampon_extract_union_38_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_38_ibloaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_38_ibloaerien_gix ON test.buffer_difference_in_38_ibloaerien USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_38_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 1 unis
DROP TABLE IF EXISTS test.buffer_difference_in_38_enedisaerien;
CREATE TABLE test.buffer_difference_in_38_enedisaerien AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_38_enedisaerien b join test.tampon_extract_union_38_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_38_enedisaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_38_enedisaerien_gix ON test.buffer_difference_in_38_enedisaerien USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_38_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 7 unis
DROP TABLE IF EXISTS test.buffer_difference_in_38_iblosout;
CREATE TABLE test.buffer_difference_in_38_iblosout AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_38_iblosout b join test.tampon_extract_union_38_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_38_iblosout b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_38_iblosout_gix ON test.buffer_difference_in_38_iblosout USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_38_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre  0 et 7 pour ne garder que ce qui ne se superpose pas à 7

DROP TABLE IF EXISTS test.buffer_difference_in_38_ibloaerien_decoup;
CREATE TABLE test.buffer_difference_in_38_ibloaerien_decoup AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_38_ibloaerien b join test.buffer_difference_in_38_iblosout a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_38_ibloaerien b left join temp t on b.gid = t.gid;


-- Index geom
CREATE INDEX buffer_difference_in_38_ibloaerien_decoup_gix ON test.buffer_difference_in_38_ibloaerien_decoup USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_38_ibloaerien_decoup ADD COLUMN gid SERIAL PRIMARY KEY;

-- Difference entre  1 et 7 pour ne garder que ce qui ne se superpose pas à 7


DROP TABLE IF EXISTS test.buffer_difference_in_38_enedisaerien_decoup;
CREATE TABLE test.buffer_difference_in_38_enedisaerien_decoup AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_38_enedisaerien b join test.buffer_difference_in_38_iblosout a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_38_enedisaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_38_enedisaerien_decoup_gix ON test.buffer_difference_in_38_enedisaerien_decoup USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_38_enedisaerien_decoup ADD COLUMN gid SERIAL PRIMARY KEY;

-- Difference entre  1 (après découp sur 7) et 0 pour ne garder que ce qui ne se superpose pas à 0



DROP TABLE IF EXISTS test.buffer_difference_in_38_enedisaerien_decoup_left;
CREATE TABLE test.buffer_difference_in_38_enedisaerien_decoup_left AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_38_enedisaerien_decoup b join test.buffer_difference_in_38_ibloaerien a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_38_enedisaerien_decoup b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_38_enedisaerien_decoup_left_gix ON test.buffer_difference_in_38_enedisaerien_decoup_left USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_38_enedisaerien_decoup_left ADD COLUMN gid SERIAL PRIMARY KEY;


-- Table de buffer finale

DROP TABLE IF EXISTS aura.buffer_in_38;
CREATE TABLE aura.buffer_in_38 AS
select mode_pose, geom
from test.buffer_difference_in_38_iblosout
union all
select mode_pose, geom
from test.buffer_difference_in_38_ibloaerien_decoup
union all
select mode_pose, geom
from test.buffer_difference_in_38_enedisaerien_decoup_left;

CREATE INDEX buffer_in_38_gix ON aura.buffer_in_38 USING GIST (geom);  
ALTER TABLE aura.buffer_in_38 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.buffer_in_38 ALTER COLUMN geom type geometry(MultiPolygon, 2384) using ST_Multi(geom);

-- Decoupage de lignes à l'intérieur du buffer entier 7(par dpt)
DROP TABLE IF EXISTS test.line_in_38_iblosout;
CREATE TABLE test.line_in_38_iblosout AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_38_iblosout as tpolygone,
    test.line_38 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_38_iblosout_gix ON test.line_in_38_iblosout USING GIST (geom);
ALTER TABLE test.line_in_38_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;





-- Decoupage de lignes à l'intérieur du buffer entier 0(par dpt)
DROP TABLE IF EXISTS test.line_in_38_ibloaerien;
CREATE TABLE test.line_in_38_ibloaerien AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_38_ibloaerien_decoup as tpolygone,
    test.line_38 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_38_ibloaerien_gix ON test.line_in_38_ibloaerien USING GIST (geom);
ALTER TABLE test.line_in_38_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'intérieur du buffer entier 1(par dpt)
DROP TABLE IF EXISTS test.line_in_38_enedisaerien;
CREATE TABLE test.line_in_38_enedisaerien AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_38_enedisaerien_decoup_left as tpolygone,
    test.line_38 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_38_enedisaerien_gix ON test.line_in_38_enedisaerien USING GIST (geom);
ALTER TABLE test.line_in_38_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;

-- Union des lignes à l'intérieur des buffers 0/1/7
DROP TABLE IF EXISTS aura.line_in_38;
CREATE TABLE aura.line_in_38 AS
select idligne, id, type, 'IBLO_SOUTERRAIN'::varchar (20) as emprise, geom
from test.line_in_38_iblosout
union all
select idligne, id, type,'ENEDIS_AERIEN'::varchar (20) as emprise, geom
from test.line_in_38_enedisaerien
union all
select idligne, id, type, 'IBLO_AERIEN'::varchar (20) as emprise, geom
from test.line_in_38_ibloaerien;

CREATE INDEX line_in_38_gix ON aura.line_in_38 USING GIST (geom);
ALTER TABLE aura.line_in_38 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.line_in_38 ALTER COLUMN geom type geometry(MultiLinestring, 2384) using ST_Multi(geom);

-- Union des 2 tables lignes (intérieur/extérieur)
DROP TABLE IF EXISTS aura.line_type_38;
CREATE TABLE aura.line_type_38 AS
select id, type, emprise, geom
from aura.line_in_38
union all
select id, type, emprise, geom
from aura.line_out_38;

CREATE INDEX line_type_38_gix ON aura.line_type_38 USING GIST (geom);
ALTER TABLE aura.line_type_38 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.line_type_38 ALTER COLUMN geom type geometry(MultiLinestring, 2384) using ST_Multi(geom);

-- Suppression tables intermediaires;
drop table if exists test.tampon_38 ;
drop table if exists test.tampon_38_ibloaerien;
drop table if exists test.tampon_38_enedisaerien;
drop table if exists test.tampon_38_all;
drop table if exists test.tampon_38_iblosout;
drop table if exists test.tampon_extract_union_38;
drop table if exists test.tampon_extract_union_38_ibloaerien;
drop table if exists test.tampon_extract_union_38_enedisaerien;
drop table if exists test.tampon_extract_union_38_iblosout;
drop table if exists test.tampon_extract_union_38_all;
drop table if exists test.buffer_difference_38;
drop table if exists test.line_out_poly_38;
drop table if exists test.tampon_38_line;
drop table if exists test.tampon_extract_union_38_line;
drop table if exists test.tampon_extract_union_38_fusion_pit;
drop table if exists test.tampon_extract_union_38_pit;
drop table if exists test.buffer_difference_line_38;
drop table if exists test.line_out_poly_line_38;
drop table if exists test.tampon_line_out_38;
drop table if exists test.tampon_extract_union_38_line_out ;
drop table if exists test.buffer_difference_in_38;
drop table if exists test.buffer_difference_in_38_ibloaerien;
drop table if exists test.buffer_difference_in_38_enedisaerien;
drop table if exists test.buffer_difference_in_38_iblosout;
drop table if exists test.buffer_difference_in_38_ibloaerien_decoup;
drop table if exists test.buffer_difference_in_38_enedisaerien_decoup;
drop table if exists test.buffer_difference_in_38_enedisaerien_decoup_left;
drop table if exists test.line_in_38_iblosout;
drop table if exists test.line_in_38_ibloaerien;
drop table if exists test.line_in_38_enedisaerien;


-- DEPARTEMENT 69


-- Tampon avec mode de pose 0/1/7
DROP TABLE IF EXISTS test.tampon_69;
CREATE TABLE test.tampon_69 as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 30) as geom
FROM test.arciti_69
where mode_pose like '0' or mode_pose like '1' or mode_pose like '7';
-- Index geom
CREATE INDEX tampon_69_gix ON test.tampon_69 USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_69 ALTER COLUMN geom type geometry(MultiPolygon, 2694) using ST_Multi(geom);

-- Tampon avec mode de pose 0
DROP TABLE IF EXISTS test.tampon_69_ibloaerien;
CREATE TABLE test.tampon_69_ibloaerien as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 30) as geom
FROM test.arciti_69
where mode_pose like '0' ;
-- Index geom
CREATE INDEX tampon_69_ibloaerien_gix ON test.tampon_69_ibloaerien USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_69_ibloaerien ALTER COLUMN geom type geometry(MultiPolygon, 2694) using ST_Multi(geom);

-- Tampon avec mode de pose 1
DROP TABLE IF EXISTS test.tampon_69_enedisaerien;
CREATE TABLE test.tampon_69_enedisaerien as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 30) as geom
FROM test.arciti_69
where mode_pose like '1' ;
-- Index geom
CREATE INDEX tampon_69_enedisaerien_gix ON test.tampon_69_enedisaerien USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_69_enedisaerien ALTER COLUMN geom type geometry(MultiPolygon, 2694) using ST_Multi(geom);

-- Tampon avec mode de pose 7
DROP TABLE IF EXISTS test.tampon_69_iblosout;
CREATE TABLE test.tampon_69_iblosout as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 30) as geom
FROM test.arciti_69
where mode_pose like '7' ;
-- Index geom
CREATE INDEX tampon_69_iblosout_gix ON test.tampon_69_iblosout USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_69_iblosout ALTER COLUMN geom type geometry(MultiPolygon, 2694) using ST_Multi(geom);


-- Tampon avec tous modes de pose 
DROP TABLE IF EXISTS test.tampon_69_all;
CREATE TABLE test.tampon_69_all as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 30) as geom
FROM test.arciti_69;
-- Index geometrique
CREATE INDEX tampon_69_all_gix ON test.tampon_69_all USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_69_all ALTER COLUMN geom type geometry(MultiPolygon, 2694) using ST_Multi(geom);


-- Union des tampons 0/1/7 en un polygone 
DROP TABLE if exists test.tampon_extract_union_69  ;
CREATE TABLE test.tampon_extract_union_69 as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_69
;
-- Index geometrique
CREATE INDEX tampon_extract_union_69_gix ON test.tampon_extract_union_69 USING GIST (geom);


-- Union des tampons 0 en un polygone 
DROP TABLE if exists test.tampon_extract_union_69_ibloaerien  ;
CREATE TABLE test.tampon_extract_union_69_ibloaerien as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, '0'::varchar as mode_pose
FROM 
    test.tampon_69_ibloaerien
;
-- Index geometrique
CREATE INDEX tampon_extract_union_69_ibloaerien_gix ON test.tampon_extract_union_69_ibloaerien USING GIST (geom);
ALTER TABLE test.tampon_extract_union_69_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union des tampons 1 en un polygone 
DROP TABLE if exists test.tampon_extract_union_69_enedisaerien  ;
CREATE TABLE test.tampon_extract_union_69_enedisaerien as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, '1'::varchar as mode_pose
FROM 
    test.tampon_69_enedisaerien
;
-- Index geometrique
CREATE INDEX tampon_extract_union_69_enedisaerien_gix ON test.tampon_extract_union_69_enedisaerien USING GIST (geom);
ALTER TABLE test.tampon_extract_union_69_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union des tampons 7 en un polygone 
DROP TABLE if exists test.tampon_extract_union_69_iblosout  ;
CREATE TABLE test.tampon_extract_union_69_iblosout as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom,  '7'::varchar as mode_pose
FROM 
    test.tampon_69_iblosout
;
-- Index geometrique
CREATE INDEX tampon_extract_union_69_iblosout_gix ON test.tampon_extract_union_69_iblosout USING GIST (geom);

ALTER TABLE test.tampon_extract_union_69_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union de tous les tampons en un polygone 
DROP TABLE if exists test.tampon_extract_union_69_all  ;
CREATE TABLE test.tampon_extract_union_69_all as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, 7
FROM 
    test.tampon_69_all
;


-- Index geometrique
CREATE INDEX tampon_extract_union_69_all_gix ON test.tampon_extract_union_69_all USING GIST (geom);
ALTER TABLE test.tampon_extract_union_69_all ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 0/1/7 unis
DROP TABLE IF EXISTS test.buffer_difference_69;
CREATE TABLE test.buffer_difference_69 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_69_all b join test.tampon_extract_union_69 a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_69_all b left join temp t on b.gid = t.gid;


ALTER TABLE test.buffer_difference_69 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'exterieur du buffer entier (par dpt)
DROP TABLE IF EXISTS test.line_out_poly_69;
CREATE TABLE test.line_out_poly_69 AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_69 as tpolygone,
    test.line_69 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_out_poly_69_gix ON test.line_out_poly_69 USING GIST (geom);
ALTER TABLE test.line_out_poly_69 ADD COLUMN gid SERIAL PRIMARY KEY;

--- Tampon avec mode de pose 0/1/7
DROP TABLE IF EXISTS test.tampon_69_line;
CREATE TABLE test.tampon_69_line as 
SELECT gid, id, type, emprise, st_buffer(geom, 1) as geom
FROM test.line_69;

-- Index geom
CREATE INDEX tampon_69_line_gix ON test.tampon_69_line USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_69_line ALTER COLUMN geom type geometry(MultiPolygon, 2694) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_69_line  ;
CREATE TABLE test.tampon_extract_union_69_line as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_69_line
;

-- Index geom
CREATE INDEX tampon_extract_union_69_line_gix ON test.tampon_extract_union_69_line USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_69_line ALTER COLUMN geom type geometry(MultiPolygon, 2694) using ST_Multi(geom);
ALTER TABLE test.tampon_extract_union_69 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Fusion des deux tampons unis du pit
DROP TABLE if exists test.tampon_extract_union_69_fusion_pit  ;
CREATE TABLE test.tampon_extract_union_69_fusion_pit as 
select geom, gid
from test.tampon_extract_union_69_all
union all
select geom, gid
from test.tampon_extract_union_69;

-- Index geom
CREATE INDEX tampon_extract_union_69_fusion_pit_gix ON test.tampon_extract_union_69_fusion_pit USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_69_fusion_pit ALTER COLUMN geom type geometry(MultiPolygon, 2694) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_69_pit  ;
CREATE TABLE test.tampon_extract_union_69_pit as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_extract_union_69_fusion_pit
;

-- Index geom
CREATE INDEX tampon_extract_union_69_pit_gix ON test.tampon_extract_union_69_pit USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_69_pit ALTER COLUMN geom type geometry(MultiPolygon, 2694) using ST_Multi(geom);

ALTER TABLE test.tampon_extract_union_69_line ADD COLUMN gid SERIAL PRIMARY KEY;



-- difference
DROP TABLE IF EXISTS test.buffer_difference_line_69;
CREATE TABLE test.buffer_difference_line_69 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_69_line b join test.tampon_extract_union_69_pit a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_69_line b left join temp t on b.gid = t.gid;

ALTER TABLE test.buffer_difference_line_69 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'exterieur du buffer entier et du pit(par dpt)
DROP TABLE IF EXISTS test.line_out_poly_line_69;
CREATE TABLE test.line_out_poly_line_69 AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_line_69 as tpolygone,
    test.line_69 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;



-- Index geometrique
CREATE INDEX line_out_poly_line_69_gix ON test.line_out_poly_line_69 USING GIST (geom);
ALTER TABLE test.line_out_poly_line_69 ADD COLUMN gid SERIAL PRIMARY KEY;

-- Union des lignes en dehors du buffer en mode pose 0/1/7
drop table if exists aura.line_out_69;
create table aura.line_out_69 as 
SELECT idligne, id, type, emprise, geom
FROM test.line_out_poly_69
union all
select idligne, id, type, emprise, geom
from test.line_out_poly_line_69;
-- Index geometrique
CREATE INDEX line_out_69_gix ON aura.line_out_69 USING GIST (geom);
ALTER TABLE aura.line_out_69 ADD COLUMN gid SERIAL PRIMARY KEY;

-- Mise à jour champ emprise avec valeur 'GC_A_CREER'
UPDATE aura.line_out_69 set emprise = 'GC_A_CREER';
ALTER TABLE aura.line_out_69 ALTER COLUMN geom type geometry(MultiLinestring, 2694) using ST_Multi(geom);

--- Tampon autour de line_out_69
DROP TABLE IF EXISTS test.tampon_line_out_69;
CREATE TABLE test.tampon_line_out_69 as 
SELECT gid, id, type, emprise, st_buffer(geom,0.001) as geom
FROM aura.line_out_69;

-- Index geom
CREATE INDEX tampon_line_out_69_gix ON test.tampon_line_out_69 USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_line_out_69 ALTER COLUMN geom type geometry(MultiPolygon, 2694) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_69_line_out ;
CREATE TABLE test.tampon_extract_union_69_line_out as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_line_out_69
;

-- Index geom
CREATE INDEX tampon_extract_union_69_line_out_gix ON test.tampon_extract_union_69_line_out USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_69_line_out ALTER COLUMN geom type geometry(MultiPolygon, 2694) using ST_Multi(geom);
ALTER TABLE test.tampon_extract_union_69_line_out ADD COLUMN gid SERIAL PRIMARY KEY;


-- Diffrence entre tampon tout pit et tampon 0/1/7 unis
DROP TABLE IF EXISTS test.buffer_difference_in_69;
CREATE TABLE test.buffer_difference_in_69 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_69 b join test.tampon_extract_union_69_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_69 b left join temp t on b.gid = t.gid;


ALTER TABLE test.buffer_difference_in_69 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 0 unis
DROP TABLE IF EXISTS test.buffer_difference_in_69_ibloaerien;
CREATE TABLE test.buffer_difference_in_69_ibloaerien AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_69_ibloaerien b join test.tampon_extract_union_69_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_69_ibloaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_69_ibloaerien_gix ON test.buffer_difference_in_69_ibloaerien USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_69_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 1 unis
DROP TABLE IF EXISTS test.buffer_difference_in_69_enedisaerien;
CREATE TABLE test.buffer_difference_in_69_enedisaerien AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_69_enedisaerien b join test.tampon_extract_union_69_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_69_enedisaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_69_enedisaerien_gix ON test.buffer_difference_in_69_enedisaerien USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_69_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 7 unis
DROP TABLE IF EXISTS test.buffer_difference_in_69_iblosout;
CREATE TABLE test.buffer_difference_in_69_iblosout AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_69_iblosout b join test.tampon_extract_union_69_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_69_iblosout b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_69_iblosout_gix ON test.buffer_difference_in_69_iblosout USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_69_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre  0 et 7 pour ne garder que ce qui ne se superpose pas à 7

DROP TABLE IF EXISTS test.buffer_difference_in_69_ibloaerien_decoup;
CREATE TABLE test.buffer_difference_in_69_ibloaerien_decoup AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_69_ibloaerien b join test.buffer_difference_in_69_iblosout a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_69_ibloaerien b left join temp t on b.gid = t.gid;


-- Index geom
CREATE INDEX buffer_difference_in_69_ibloaerien_decoup_gix ON test.buffer_difference_in_69_ibloaerien_decoup USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_69_ibloaerien_decoup ADD COLUMN gid SERIAL PRIMARY KEY;

-- Difference entre  1 et 7 pour ne garder que ce qui ne se superpose pas à 7


DROP TABLE IF EXISTS test.buffer_difference_in_69_enedisaerien_decoup;
CREATE TABLE test.buffer_difference_in_69_enedisaerien_decoup AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_69_enedisaerien b join test.buffer_difference_in_69_iblosout a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_69_enedisaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_69_enedisaerien_decoup_gix ON test.buffer_difference_in_69_enedisaerien_decoup USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_69_enedisaerien_decoup ADD COLUMN gid SERIAL PRIMARY KEY;

-- Difference entre  1 (après découp sur 7) et 0 pour ne garder que ce qui ne se superpose pas à 0



DROP TABLE IF EXISTS test.buffer_difference_in_69_enedisaerien_decoup_left;
CREATE TABLE test.buffer_difference_in_69_enedisaerien_decoup_left AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_69_enedisaerien_decoup b join test.buffer_difference_in_69_ibloaerien a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_69_enedisaerien_decoup b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_69_enedisaerien_decoup_left_gix ON test.buffer_difference_in_69_enedisaerien_decoup_left USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_69_enedisaerien_decoup_left ADD COLUMN gid SERIAL PRIMARY KEY;


-- Table de buffer finale

DROP TABLE IF EXISTS aura.buffer_in_69;
CREATE TABLE aura.buffer_in_69 AS
select mode_pose, geom
from test.buffer_difference_in_69_iblosout
union all
select mode_pose, geom
from test.buffer_difference_in_69_ibloaerien_decoup
union all
select mode_pose, geom
from test.buffer_difference_in_69_enedisaerien_decoup_left;

CREATE INDEX buffer_in_69_gix ON aura.buffer_in_69 USING GIST (geom);  
ALTER TABLE aura.buffer_in_69 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.buffer_in_69 ALTER COLUMN geom type geometry(MultiPolygon, 2694) using ST_Multi(geom);

-- Decoupage de lignes à l'intérieur du buffer entier 7(par dpt)
DROP TABLE IF EXISTS test.line_in_69_iblosout;
CREATE TABLE test.line_in_69_iblosout AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_69_iblosout as tpolygone,
    test.line_69 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_69_iblosout_gix ON test.line_in_69_iblosout USING GIST (geom);
ALTER TABLE test.line_in_69_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;





-- Decoupage de lignes à l'intérieur du buffer entier 0(par dpt)
DROP TABLE IF EXISTS test.line_in_69_ibloaerien;
CREATE TABLE test.line_in_69_ibloaerien AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_69_ibloaerien_decoup as tpolygone,
    test.line_69 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_69_ibloaerien_gix ON test.line_in_69_ibloaerien USING GIST (geom);
ALTER TABLE test.line_in_69_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'intérieur du buffer entier 1(par dpt)
DROP TABLE IF EXISTS test.line_in_69_enedisaerien;
CREATE TABLE test.line_in_69_enedisaerien AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_69_enedisaerien_decoup_left as tpolygone,
    test.line_69 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_69_enedisaerien_gix ON test.line_in_69_enedisaerien USING GIST (geom);
ALTER TABLE test.line_in_69_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;

-- Union des lignes à l'intérieur des buffers 0/1/7
DROP TABLE IF EXISTS aura.line_in_69;
CREATE TABLE aura.line_in_69 AS
select idligne, id, type, 'IBLO_SOUTERRAIN'::varchar (20) as emprise, geom
from test.line_in_69_iblosout
union all
select idligne, id, type,'ENEDIS_AERIEN'::varchar (20) as emprise, geom
from test.line_in_69_enedisaerien
union all
select idligne, id, type, 'IBLO_AERIEN'::varchar (20) as emprise, geom
from test.line_in_69_ibloaerien;

CREATE INDEX line_in_69_gix ON aura.line_in_69 USING GIST (geom);
ALTER TABLE aura.line_in_69 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.line_in_69 ALTER COLUMN geom type geometry(MultiLinestring, 2694) using ST_Multi(geom);

-- Union des 2 tables lignes (intérieur/extérieur)
DROP TABLE IF EXISTS aura.line_type_69;
CREATE TABLE aura.line_type_69 AS
select id, type, emprise, geom
from aura.line_in_69
union all
select id, type, emprise, geom
from aura.line_out_69;

CREATE INDEX line_type_69_gix ON aura.line_type_69 USING GIST (geom);
ALTER TABLE aura.line_type_69 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.line_type_69 ALTER COLUMN geom type geometry(MultiLinestring, 2694) using ST_Multi(geom);

-- Suppression tables intermediaires;
drop table if exists test.tampon_69 ;
drop table if exists test.tampon_69_ibloaerien;
drop table if exists test.tampon_69_enedisaerien;
drop table if exists test.tampon_69_all;
drop table if exists test.tampon_69_iblosout;
drop table if exists test.tampon_extract_union_69;
drop table if exists test.tampon_extract_union_69_ibloaerien;
drop table if exists test.tampon_extract_union_69_enedisaerien;
drop table if exists test.tampon_extract_union_69_iblosout;
drop table if exists test.tampon_extract_union_69_all;
drop table if exists test.buffer_difference_69;
drop table if exists test.line_out_poly_69;
drop table if exists test.tampon_69_line;
drop table if exists test.tampon_extract_union_69_line;
drop table if exists test.tampon_extract_union_69_fusion_pit;
drop table if exists test.tampon_extract_union_69_pit;
drop table if exists test.buffer_difference_line_69;
drop table if exists test.line_out_poly_line_69;
drop table if exists test.tampon_line_out_69;
drop table if exists test.tampon_extract_union_69_line_out ;
drop table if exists test.buffer_difference_in_69;
drop table if exists test.buffer_difference_in_69_ibloaerien;
drop table if exists test.buffer_difference_in_69_enedisaerien;
drop table if exists test.buffer_difference_in_69_iblosout;
drop table if exists test.buffer_difference_in_69_ibloaerien_decoup;
drop table if exists test.buffer_difference_in_69_enedisaerien_decoup;
drop table if exists test.buffer_difference_in_69_enedisaerien_decoup_left;
drop table if exists test.line_in_69_iblosout;
drop table if exists test.line_in_69_ibloaerien;
drop table if exists test.line_in_69_enedisaerien;


--DEPARTEMENT 01


-- Tampon avec mode de pose 0/1/7
DROP TABLE IF EXISTS test.tampon_01;
CREATE TABLE test.tampon_01 as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 30) as geom
FROM test.arciti_01
where mode_pose like '0' or mode_pose like '1' or mode_pose like '7';
-- Index geom
CREATE INDEX tampon_01_gix ON test.tampon_01 USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_01 ALTER COLUMN geom type geometry(MultiPolygon, 2014) using ST_Multi(geom);

-- Tampon avec mode de pose 0
DROP TABLE IF EXISTS test.tampon_01_ibloaerien;
CREATE TABLE test.tampon_01_ibloaerien as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 30) as geom
FROM test.arciti_01
where mode_pose like '0' ;
-- Index geom
CREATE INDEX tampon_01_ibloaerien_gix ON test.tampon_01_ibloaerien USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_01_ibloaerien ALTER COLUMN geom type geometry(MultiPolygon, 2014) using ST_Multi(geom);

-- Tampon avec mode de pose 1
DROP TABLE IF EXISTS test.tampon_01_enedisaerien;
CREATE TABLE test.tampon_01_enedisaerien as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 30) as geom
FROM test.arciti_01
where mode_pose like '1' ;
-- Index geom
CREATE INDEX tampon_01_enedisaerien_gix ON test.tampon_01_enedisaerien USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_01_enedisaerien ALTER COLUMN geom type geometry(MultiPolygon, 2014) using ST_Multi(geom);

-- Tampon avec mode de pose 7
DROP TABLE IF EXISTS test.tampon_01_iblosout;
CREATE TABLE test.tampon_01_iblosout as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 30) as geom
FROM test.arciti_01
where mode_pose like '7' ;
-- Index geom
CREATE INDEX tampon_01_iblosout_gix ON test.tampon_01_iblosout USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_01_iblosout ALTER COLUMN geom type geometry(MultiPolygon, 2014) using ST_Multi(geom);


-- Tampon avec tous modes de pose 
DROP TABLE IF EXISTS test.tampon_01_all;
CREATE TABLE test.tampon_01_all as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 30) as geom
FROM test.arciti_01;
-- Index geometrique
CREATE INDEX tampon_01_all_gix ON test.tampon_01_all USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_01_all ALTER COLUMN geom type geometry(MultiPolygon, 2014) using ST_Multi(geom);


-- Union des tampons 0/1/7 en un polygone 
DROP TABLE if exists test.tampon_extract_union_01  ;
CREATE TABLE test.tampon_extract_union_01 as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_01
;
-- Index geometrique
CREATE INDEX tampon_extract_union_01_gix ON test.tampon_extract_union_01 USING GIST (geom);


-- Union des tampons 0 en un polygone 
DROP TABLE if exists test.tampon_extract_union_01_ibloaerien  ;
CREATE TABLE test.tampon_extract_union_01_ibloaerien as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, '0'::varchar as mode_pose
FROM 
    test.tampon_01_ibloaerien
;
-- Index geometrique
CREATE INDEX tampon_extract_union_01_ibloaerien_gix ON test.tampon_extract_union_01_ibloaerien USING GIST (geom);
ALTER TABLE test.tampon_extract_union_01_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union des tampons 1 en un polygone 
DROP TABLE if exists test.tampon_extract_union_01_enedisaerien  ;
CREATE TABLE test.tampon_extract_union_01_enedisaerien as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, '1'::varchar as mode_pose
FROM 
    test.tampon_01_enedisaerien
;
-- Index geometrique
CREATE INDEX tampon_extract_union_01_enedisaerien_gix ON test.tampon_extract_union_01_enedisaerien USING GIST (geom);
ALTER TABLE test.tampon_extract_union_01_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union des tampons 7 en un polygone 
DROP TABLE if exists test.tampon_extract_union_01_iblosout  ;
CREATE TABLE test.tampon_extract_union_01_iblosout as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom,  '7'::varchar as mode_pose
FROM 
    test.tampon_01_iblosout
;
-- Index geometrique
CREATE INDEX tampon_extract_union_01_iblosout_gix ON test.tampon_extract_union_01_iblosout USING GIST (geom);

ALTER TABLE test.tampon_extract_union_01_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union de tous les tampons en un polygone 
DROP TABLE if exists test.tampon_extract_union_01_all  ;
CREATE TABLE test.tampon_extract_union_01_all as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, 7
FROM 
    test.tampon_01_all
;


-- Index geometrique
CREATE INDEX tampon_extract_union_01_all_gix ON test.tampon_extract_union_01_all USING GIST (geom);
ALTER TABLE test.tampon_extract_union_01_all ADD COLUMN gid SERIAL PRIMARY KEY;


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


ALTER TABLE test.buffer_difference_01 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'exterieur du buffer entier (par dpt)
DROP TABLE IF EXISTS test.line_out_poly_01;
CREATE TABLE test.line_out_poly_01 AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_01 as tpolygone,
    test.line_01 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_out_poly_01_gix ON test.line_out_poly_01 USING GIST (geom);
ALTER TABLE test.line_out_poly_01 ADD COLUMN gid SERIAL PRIMARY KEY;

--- Tampon avec mode de pose 0/1/7
DROP TABLE IF EXISTS test.tampon_01_line;
CREATE TABLE test.tampon_01_line as 
SELECT gid, id, type, emprise, st_buffer(geom, 1) as geom
FROM test.line_01;

-- Index geom
CREATE INDEX tampon_01_line_gix ON test.tampon_01_line USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_01_line ALTER COLUMN geom type geometry(MultiPolygon, 2014) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_01_line  ;
CREATE TABLE test.tampon_extract_union_01_line as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_01_line
;

-- Index geom
CREATE INDEX tampon_extract_union_01_line_gix ON test.tampon_extract_union_01_line USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_01_line ALTER COLUMN geom type geometry(MultiPolygon, 2014) using ST_Multi(geom);
ALTER TABLE test.tampon_extract_union_01 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Fusion des deux tampons unis du pit
DROP TABLE if exists test.tampon_extract_union_01_fusion_pit  ;
CREATE TABLE test.tampon_extract_union_01_fusion_pit as 
select geom, gid
from test.tampon_extract_union_01_all
union all
select geom, gid
from test.tampon_extract_union_01;

-- Index geom
CREATE INDEX tampon_extract_union_01_fusion_pit_gix ON test.tampon_extract_union_01_fusion_pit USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_01_fusion_pit ALTER COLUMN geom type geometry(MultiPolygon, 2014) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_01_pit  ;
CREATE TABLE test.tampon_extract_union_01_pit as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_extract_union_01_fusion_pit
;

-- Index geom
CREATE INDEX tampon_extract_union_01_pit_gix ON test.tampon_extract_union_01_pit USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_01_pit ALTER COLUMN geom type geometry(MultiPolygon, 2014) using ST_Multi(geom);

ALTER TABLE test.tampon_extract_union_01_line ADD COLUMN gid SERIAL PRIMARY KEY;



-- difference
DROP TABLE IF EXISTS test.buffer_difference_line_01;
CREATE TABLE test.buffer_difference_line_01 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_01_line b join test.tampon_extract_union_01_pit a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_01_line b left join temp t on b.gid = t.gid;

ALTER TABLE test.buffer_difference_line_01 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'exterieur du buffer entier et du pit(par dpt)
DROP TABLE IF EXISTS test.line_out_poly_line_01;
CREATE TABLE test.line_out_poly_line_01 AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_line_01 as tpolygone,
    test.line_01 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;



-- Index geometrique
CREATE INDEX line_out_poly_line_01_gix ON test.line_out_poly_line_01 USING GIST (geom);
ALTER TABLE test.line_out_poly_line_01 ADD COLUMN gid SERIAL PRIMARY KEY;

-- Union des lignes en dehors du buffer en mode pose 0/1/7
drop table if exists aura.line_out_01;
create table aura.line_out_01 as 
SELECT idligne, id, type, emprise, geom
FROM test.line_out_poly_01
union all
select idligne, id, type, emprise, geom
from test.line_out_poly_line_01;
-- Index geometrique
CREATE INDEX line_out_01_gix ON aura.line_out_01 USING GIST (geom);
ALTER TABLE aura.line_out_01 ADD COLUMN gid SERIAL PRIMARY KEY;

-- Mise à jour champ emprise avec valeur 'GC_A_CREER'
UPDATE aura.line_out_01 set emprise = 'GC_A_CREER';
ALTER TABLE aura.line_out_01 ALTER COLUMN geom type geometry(MultiLinestring, 2014) using ST_Multi(geom);

--- Tampon autour de line_out_01
DROP TABLE IF EXISTS test.tampon_line_out_01;
CREATE TABLE test.tampon_line_out_01 as 
SELECT gid, id, type, emprise, st_buffer(geom,0.001) as geom
FROM aura.line_out_01;

-- Index geom
CREATE INDEX tampon_line_out_01_gix ON test.tampon_line_out_01 USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_line_out_01 ALTER COLUMN geom type geometry(MultiPolygon, 2014) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_01_line_out ;
CREATE TABLE test.tampon_extract_union_01_line_out as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_line_out_01
;

-- Index geom
CREATE INDEX tampon_extract_union_01_line_out_gix ON test.tampon_extract_union_01_line_out USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_01_line_out ALTER COLUMN geom type geometry(MultiPolygon, 2014) using ST_Multi(geom);
ALTER TABLE test.tampon_extract_union_01_line_out ADD COLUMN gid SERIAL PRIMARY KEY;


-- Diffrence entre tampon tout pit et tampon 0/1/7 unis
DROP TABLE IF EXISTS test.buffer_difference_in_01;
CREATE TABLE test.buffer_difference_in_01 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_01 b join test.tampon_extract_union_01_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_01 b left join temp t on b.gid = t.gid;


ALTER TABLE test.buffer_difference_in_01 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 0 unis
DROP TABLE IF EXISTS test.buffer_difference_in_01_ibloaerien;
CREATE TABLE test.buffer_difference_in_01_ibloaerien AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_01_ibloaerien b join test.tampon_extract_union_01_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_01_ibloaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_01_ibloaerien_gix ON test.buffer_difference_in_01_ibloaerien USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_01_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 1 unis
DROP TABLE IF EXISTS test.buffer_difference_in_01_enedisaerien;
CREATE TABLE test.buffer_difference_in_01_enedisaerien AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_01_enedisaerien b join test.tampon_extract_union_01_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_01_enedisaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_01_enedisaerien_gix ON test.buffer_difference_in_01_enedisaerien USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_01_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 7 unis
DROP TABLE IF EXISTS test.buffer_difference_in_01_iblosout;
CREATE TABLE test.buffer_difference_in_01_iblosout AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_01_iblosout b join test.tampon_extract_union_01_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_01_iblosout b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_01_iblosout_gix ON test.buffer_difference_in_01_iblosout USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_01_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre  0 et 7 pour ne garder que ce qui ne se superpose pas à 7

DROP TABLE IF EXISTS test.buffer_difference_in_01_ibloaerien_decoup;
CREATE TABLE test.buffer_difference_in_01_ibloaerien_decoup AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_01_ibloaerien b join test.buffer_difference_in_01_iblosout a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_01_ibloaerien b left join temp t on b.gid = t.gid;


-- Index geom
CREATE INDEX buffer_difference_in_01_ibloaerien_decoup_gix ON test.buffer_difference_in_01_ibloaerien_decoup USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_01_ibloaerien_decoup ADD COLUMN gid SERIAL PRIMARY KEY;

-- Difference entre  1 et 7 pour ne garder que ce qui ne se superpose pas à 7


DROP TABLE IF EXISTS test.buffer_difference_in_01_enedisaerien_decoup;
CREATE TABLE test.buffer_difference_in_01_enedisaerien_decoup AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_01_enedisaerien b join test.buffer_difference_in_01_iblosout a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_01_enedisaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_01_enedisaerien_decoup_gix ON test.buffer_difference_in_01_enedisaerien_decoup USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_01_enedisaerien_decoup ADD COLUMN gid SERIAL PRIMARY KEY;

-- Difference entre  1 (après découp sur 7) et 0 pour ne garder que ce qui ne se superpose pas à 0



DROP TABLE IF EXISTS test.buffer_difference_in_01_enedisaerien_decoup_left;
CREATE TABLE test.buffer_difference_in_01_enedisaerien_decoup_left AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_01_enedisaerien_decoup b join test.buffer_difference_in_01_ibloaerien a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_01_enedisaerien_decoup b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_01_enedisaerien_decoup_left_gix ON test.buffer_difference_in_01_enedisaerien_decoup_left USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_01_enedisaerien_decoup_left ADD COLUMN gid SERIAL PRIMARY KEY;


-- Table de buffer finale

DROP TABLE IF EXISTS aura.buffer_in_01;
CREATE TABLE aura.buffer_in_01 AS
select mode_pose, geom
from test.buffer_difference_in_01_iblosout
union all
select mode_pose, geom
from test.buffer_difference_in_01_ibloaerien_decoup
union all
select mode_pose, geom
from test.buffer_difference_in_01_enedisaerien_decoup_left;

CREATE INDEX buffer_in_01_gix ON aura.buffer_in_01 USING GIST (geom);  
ALTER TABLE aura.buffer_in_01 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.buffer_in_01 ALTER COLUMN geom type geometry(MultiPolygon, 2014) using ST_Multi(geom);

-- Decoupage de lignes à l'intérieur du buffer entier 7(par dpt)
DROP TABLE IF EXISTS test.line_in_01_iblosout;
CREATE TABLE test.line_in_01_iblosout AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_01_iblosout as tpolygone,
    test.line_01 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_01_iblosout_gix ON test.line_in_01_iblosout USING GIST (geom);
ALTER TABLE test.line_in_01_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;





-- Decoupage de lignes à l'intérieur du buffer entier 0(par dpt)
DROP TABLE IF EXISTS test.line_in_01_ibloaerien;
CREATE TABLE test.line_in_01_ibloaerien AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_01_ibloaerien_decoup as tpolygone,
    test.line_01 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_01_ibloaerien_gix ON test.line_in_01_ibloaerien USING GIST (geom);
ALTER TABLE test.line_in_01_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'intérieur du buffer entier 1(par dpt)
DROP TABLE IF EXISTS test.line_in_01_enedisaerien;
CREATE TABLE test.line_in_01_enedisaerien AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_01_enedisaerien_decoup_left as tpolygone,
    test.line_01 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_01_enedisaerien_gix ON test.line_in_01_enedisaerien USING GIST (geom);
ALTER TABLE test.line_in_01_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;

-- Union des lignes à l'intérieur des buffers 0/1/7
DROP TABLE IF EXISTS aura.line_in_01;
CREATE TABLE aura.line_in_01 AS
select idligne, id, type, 'IBLO_SOUTERRAIN'::varchar (20) as emprise, geom
from test.line_in_01_iblosout
union all
select idligne, id, type,'ENEDIS_AERIEN'::varchar (20) as emprise, geom
from test.line_in_01_enedisaerien
union all
select idligne, id, type, 'IBLO_AERIEN'::varchar (20) as emprise, geom
from test.line_in_01_ibloaerien;

CREATE INDEX line_in_01_gix ON aura.line_in_01 USING GIST (geom);
ALTER TABLE aura.line_in_01 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.line_in_01 ALTER COLUMN geom type geometry(MultiLinestring, 2014) using ST_Multi(geom);

-- Union des 2 tables lignes (intérieur/extérieur)
DROP TABLE IF EXISTS aura.line_type_01;
CREATE TABLE aura.line_type_01 AS
select id, type, emprise, geom
from aura.line_in_01
union all
select id, type, emprise, geom
from aura.line_out_01;

CREATE INDEX line_type_01_gix ON aura.line_type_01 USING GIST (geom);
ALTER TABLE aura.line_type_01 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.line_type_01 ALTER COLUMN geom type geometry(MultiLinestring, 2014) using ST_Multi(geom);

-- Suppression tables intermediaires;
drop table if exists test.tampon_01 ;
drop table if exists test.tampon_01_ibloaerien;
drop table if exists test.tampon_01_enedisaerien;
drop table if exists test.tampon_01_all;
drop table if exists test.tampon_01_iblosout;
drop table if exists test.tampon_extract_union_01;
drop table if exists test.tampon_extract_union_01_ibloaerien;
drop table if exists test.tampon_extract_union_01_enedisaerien;
drop table if exists test.tampon_extract_union_01_iblosout;
drop table if exists test.tampon_extract_union_01_all;
drop table if exists test.buffer_difference_01;
drop table if exists test.line_out_poly_01;
drop table if exists test.tampon_01_line;
drop table if exists test.tampon_extract_union_01_line;
drop table if exists test.tampon_extract_union_01_fusion_pit;
drop table if exists test.tampon_extract_union_01_pit;
drop table if exists test.buffer_difference_line_01;
drop table if exists test.line_out_poly_line_01;
drop table if exists test.tampon_line_out_01;
drop table if exists test.tampon_extract_union_01_line_out ;
drop table if exists test.buffer_difference_in_01;
drop table if exists test.buffer_difference_in_01_ibloaerien;
drop table if exists test.buffer_difference_in_01_enedisaerien;
drop table if exists test.buffer_difference_in_01_iblosout;
drop table if exists test.buffer_difference_in_01_ibloaerien_decoup;
drop table if exists test.buffer_difference_in_01_enedisaerien_decoup;
drop table if exists test.buffer_difference_in_01_enedisaerien_decoup_left;
drop table if exists test.line_in_01_iblosout;
drop table if exists test.line_in_01_ibloaerien;
drop table if exists test.line_in_01_enedisaerien;


-- DEPARTMENT 73


-- Tampon avec mode de pose 0/1/7
DROP TABLE IF EXISTS test.tampon_73;
CREATE TABLE test.tampon_73 as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 30) as geom
FROM test.arciti_73
where mode_pose like '0' or mode_pose like '1' or mode_pose like '7';
-- Index geom
CREATE INDEX tampon_73_gix ON test.tampon_73 USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_73 ALTER COLUMN geom type geometry(MultiPolygon, 2734) using ST_Multi(geom);

-- Tampon avec mode de pose 0
DROP TABLE IF EXISTS test.tampon_73_ibloaerien;
CREATE TABLE test.tampon_73_ibloaerien as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 30) as geom
FROM test.arciti_73
where mode_pose like '0' ;
-- Index geom
CREATE INDEX tampon_73_ibloaerien_gix ON test.tampon_73_ibloaerien USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_73_ibloaerien ALTER COLUMN geom type geometry(MultiPolygon, 2734) using ST_Multi(geom);

-- Tampon avec mode de pose 1
DROP TABLE IF EXISTS test.tampon_73_enedisaerien;
CREATE TABLE test.tampon_73_enedisaerien as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 30) as geom
FROM test.arciti_73
where mode_pose like '1' ;
-- Index geom
CREATE INDEX tampon_73_enedisaerien_gix ON test.tampon_73_enedisaerien USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_73_enedisaerien ALTER COLUMN geom type geometry(MultiPolygon, 2734) using ST_Multi(geom);

-- Tampon avec mode de pose 7
DROP TABLE IF EXISTS test.tampon_73_iblosout;
CREATE TABLE test.tampon_73_iblosout as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 30) as geom
FROM test.arciti_73
where mode_pose like '7' ;
-- Index geom
CREATE INDEX tampon_73_iblosout_gix ON test.tampon_73_iblosout USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_73_iblosout ALTER COLUMN geom type geometry(MultiPolygon, 2734) using ST_Multi(geom);


-- Tampon avec tous modes de pose 
DROP TABLE IF EXISTS test.tampon_73_all;
CREATE TABLE test.tampon_73_all as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 30) as geom
FROM test.arciti_73;
-- Index geometrique
CREATE INDEX tampon_73_all_gix ON test.tampon_73_all USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_73_all ALTER COLUMN geom type geometry(MultiPolygon, 2734) using ST_Multi(geom);


-- Union des tampons 0/1/7 en un polygone 
DROP TABLE if exists test.tampon_extract_union_73  ;
CREATE TABLE test.tampon_extract_union_73 as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_73
;
-- Index geometrique
CREATE INDEX tampon_extract_union_73_gix ON test.tampon_extract_union_73 USING GIST (geom);


-- Union des tampons 0 en un polygone 
DROP TABLE if exists test.tampon_extract_union_73_ibloaerien  ;
CREATE TABLE test.tampon_extract_union_73_ibloaerien as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, '0'::varchar as mode_pose
FROM 
    test.tampon_73_ibloaerien
;
-- Index geometrique
CREATE INDEX tampon_extract_union_73_ibloaerien_gix ON test.tampon_extract_union_73_ibloaerien USING GIST (geom);
ALTER TABLE test.tampon_extract_union_73_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union des tampons 1 en un polygone 
DROP TABLE if exists test.tampon_extract_union_73_enedisaerien  ;
CREATE TABLE test.tampon_extract_union_73_enedisaerien as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, '1'::varchar as mode_pose
FROM 
    test.tampon_73_enedisaerien
;
-- Index geometrique
CREATE INDEX tampon_extract_union_73_enedisaerien_gix ON test.tampon_extract_union_73_enedisaerien USING GIST (geom);
ALTER TABLE test.tampon_extract_union_73_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union des tampons 7 en un polygone 
DROP TABLE if exists test.tampon_extract_union_73_iblosout  ;
CREATE TABLE test.tampon_extract_union_73_iblosout as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom,  '7'::varchar as mode_pose
FROM 
    test.tampon_73_iblosout
;
-- Index geometrique
CREATE INDEX tampon_extract_union_73_iblosout_gix ON test.tampon_extract_union_73_iblosout USING GIST (geom);

ALTER TABLE test.tampon_extract_union_73_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union de tous les tampons en un polygone 
DROP TABLE if exists test.tampon_extract_union_73_all  ;
CREATE TABLE test.tampon_extract_union_73_all as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, 7
FROM 
    test.tampon_73_all
;


-- Index geometrique
CREATE INDEX tampon_extract_union_73_all_gix ON test.tampon_extract_union_73_all USING GIST (geom);
ALTER TABLE test.tampon_extract_union_73_all ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 0/1/7 unis
DROP TABLE IF EXISTS test.buffer_difference_73;
CREATE TABLE test.buffer_difference_73 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_73_all b join test.tampon_extract_union_73 a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_73_all b left join temp t on b.gid = t.gid;


ALTER TABLE test.buffer_difference_73 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'exterieur du buffer entier (par dpt)
DROP TABLE IF EXISTS test.line_out_poly_73;
CREATE TABLE test.line_out_poly_73 AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_73 as tpolygone,
    test.line_73 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_out_poly_73_gix ON test.line_out_poly_73 USING GIST (geom);
ALTER TABLE test.line_out_poly_73 ADD COLUMN gid SERIAL PRIMARY KEY;

--- Tampon avec mode de pose 0/1/7
DROP TABLE IF EXISTS test.tampon_73_line;
CREATE TABLE test.tampon_73_line as 
SELECT gid, id, type, emprise, st_buffer(geom, 1) as geom
FROM test.line_73;

-- Index geom
CREATE INDEX tampon_73_line_gix ON test.tampon_73_line USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_73_line ALTER COLUMN geom type geometry(MultiPolygon, 2734) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_73_line  ;
CREATE TABLE test.tampon_extract_union_73_line as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_73_line
;

-- Index geom
CREATE INDEX tampon_extract_union_73_line_gix ON test.tampon_extract_union_73_line USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_73_line ALTER COLUMN geom type geometry(MultiPolygon, 2734) using ST_Multi(geom);
ALTER TABLE test.tampon_extract_union_73 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Fusion des deux tampons unis du pit
DROP TABLE if exists test.tampon_extract_union_73_fusion_pit  ;
CREATE TABLE test.tampon_extract_union_73_fusion_pit as 
select geom, gid
from test.tampon_extract_union_73_all
union all
select geom, gid
from test.tampon_extract_union_73;

-- Index geom
CREATE INDEX tampon_extract_union_73_fusion_pit_gix ON test.tampon_extract_union_73_fusion_pit USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_73_fusion_pit ALTER COLUMN geom type geometry(MultiPolygon, 2734) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_73_pit  ;
CREATE TABLE test.tampon_extract_union_73_pit as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_extract_union_73_fusion_pit
;

-- Index geom
CREATE INDEX tampon_extract_union_73_pit_gix ON test.tampon_extract_union_73_pit USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_73_pit ALTER COLUMN geom type geometry(MultiPolygon, 2734) using ST_Multi(geom);

ALTER TABLE test.tampon_extract_union_73_line ADD COLUMN gid SERIAL PRIMARY KEY;



-- difference
DROP TABLE IF EXISTS test.buffer_difference_line_73;
CREATE TABLE test.buffer_difference_line_73 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_73_line b join test.tampon_extract_union_73_pit a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_73_line b left join temp t on b.gid = t.gid;

ALTER TABLE test.buffer_difference_line_73 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'exterieur du buffer entier et du pit(par dpt)
DROP TABLE IF EXISTS test.line_out_poly_line_73;
CREATE TABLE test.line_out_poly_line_73 AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_line_73 as tpolygone,
    test.line_73 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;



-- Index geometrique
CREATE INDEX line_out_poly_line_73_gix ON test.line_out_poly_line_73 USING GIST (geom);
ALTER TABLE test.line_out_poly_line_73 ADD COLUMN gid SERIAL PRIMARY KEY;

-- Union des lignes en dehors du buffer en mode pose 0/1/7
drop table if exists aura.line_out_73;
create table aura.line_out_73 as 
SELECT idligne, id, type, emprise, geom
FROM test.line_out_poly_73
union all
select idligne, id, type, emprise, geom
from test.line_out_poly_line_73;
-- Index geometrique
CREATE INDEX line_out_73_gix ON aura.line_out_73 USING GIST (geom);
ALTER TABLE aura.line_out_73 ADD COLUMN gid SERIAL PRIMARY KEY;

-- Mise à jour champ emprise avec valeur 'GC_A_CREER'
UPDATE aura.line_out_73 set emprise = 'GC_A_CREER';
ALTER TABLE aura.line_out_73 ALTER COLUMN geom type geometry(MultiLinestring, 2734) using ST_Multi(geom);

--- Tampon autour de line_out_73
DROP TABLE IF EXISTS test.tampon_line_out_73;
CREATE TABLE test.tampon_line_out_73 as 
SELECT gid, id, type, emprise, st_buffer(geom,0.073) as geom
FROM aura.line_out_73;

-- Index geom
CREATE INDEX tampon_line_out_73_gix ON test.tampon_line_out_73 USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_line_out_73 ALTER COLUMN geom type geometry(MultiPolygon, 2734) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_73_line_out ;
CREATE TABLE test.tampon_extract_union_73_line_out as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_line_out_73
;

-- Index geom
CREATE INDEX tampon_extract_union_73_line_out_gix ON test.tampon_extract_union_73_line_out USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_73_line_out ALTER COLUMN geom type geometry(MultiPolygon, 2734) using ST_Multi(geom);
ALTER TABLE test.tampon_extract_union_73_line_out ADD COLUMN gid SERIAL PRIMARY KEY;


-- Diffrence entre tampon tout pit et tampon 0/1/7 unis
DROP TABLE IF EXISTS test.buffer_difference_in_73;
CREATE TABLE test.buffer_difference_in_73 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_73 b join test.tampon_extract_union_73_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_73 b left join temp t on b.gid = t.gid;


ALTER TABLE test.buffer_difference_in_73 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 0 unis
DROP TABLE IF EXISTS test.buffer_difference_in_73_ibloaerien;
CREATE TABLE test.buffer_difference_in_73_ibloaerien AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_73_ibloaerien b join test.tampon_extract_union_73_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_73_ibloaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_73_ibloaerien_gix ON test.buffer_difference_in_73_ibloaerien USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_73_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 1 unis
DROP TABLE IF EXISTS test.buffer_difference_in_73_enedisaerien;
CREATE TABLE test.buffer_difference_in_73_enedisaerien AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_73_enedisaerien b join test.tampon_extract_union_73_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_73_enedisaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_73_enedisaerien_gix ON test.buffer_difference_in_73_enedisaerien USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_73_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 7 unis
DROP TABLE IF EXISTS test.buffer_difference_in_73_iblosout;
CREATE TABLE test.buffer_difference_in_73_iblosout AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_73_iblosout b join test.tampon_extract_union_73_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_73_iblosout b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_73_iblosout_gix ON test.buffer_difference_in_73_iblosout USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_73_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre  0 et 7 pour ne garder que ce qui ne se superpose pas à 7

DROP TABLE IF EXISTS test.buffer_difference_in_73_ibloaerien_decoup;
CREATE TABLE test.buffer_difference_in_73_ibloaerien_decoup AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_73_ibloaerien b join test.buffer_difference_in_73_iblosout a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_73_ibloaerien b left join temp t on b.gid = t.gid;


-- Index geom
CREATE INDEX buffer_difference_in_73_ibloaerien_decoup_gix ON test.buffer_difference_in_73_ibloaerien_decoup USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_73_ibloaerien_decoup ADD COLUMN gid SERIAL PRIMARY KEY;

-- Difference entre  1 et 7 pour ne garder que ce qui ne se superpose pas à 7


DROP TABLE IF EXISTS test.buffer_difference_in_73_enedisaerien_decoup;
CREATE TABLE test.buffer_difference_in_73_enedisaerien_decoup AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_73_enedisaerien b join test.buffer_difference_in_73_iblosout a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_73_enedisaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_73_enedisaerien_decoup_gix ON test.buffer_difference_in_73_enedisaerien_decoup USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_73_enedisaerien_decoup ADD COLUMN gid SERIAL PRIMARY KEY;

-- Difference entre  1 (après découp sur 7) et 0 pour ne garder que ce qui ne se superpose pas à 0



DROP TABLE IF EXISTS test.buffer_difference_in_73_enedisaerien_decoup_left;
CREATE TABLE test.buffer_difference_in_73_enedisaerien_decoup_left AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_73_enedisaerien_decoup b join test.buffer_difference_in_73_ibloaerien a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_73_enedisaerien_decoup b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_73_enedisaerien_decoup_left_gix ON test.buffer_difference_in_73_enedisaerien_decoup_left USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_73_enedisaerien_decoup_left ADD COLUMN gid SERIAL PRIMARY KEY;


-- Table de buffer finale

DROP TABLE IF EXISTS aura.buffer_in_73;
CREATE TABLE aura.buffer_in_73 AS
select mode_pose, geom
from test.buffer_difference_in_73_iblosout
union all
select mode_pose, geom
from test.buffer_difference_in_73_ibloaerien_decoup
union all
select mode_pose, geom
from test.buffer_difference_in_73_enedisaerien_decoup_left;

CREATE INDEX buffer_in_73_gix ON aura.buffer_in_73 USING GIST (geom);  
ALTER TABLE aura.buffer_in_73 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.buffer_in_73 ALTER COLUMN geom type geometry(MultiPolygon, 2734) using ST_Multi(geom);

-- Decoupage de lignes à l'intérieur du buffer entier 7(par dpt)
DROP TABLE IF EXISTS test.line_in_73_iblosout;
CREATE TABLE test.line_in_73_iblosout AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_73_iblosout as tpolygone,
    test.line_73 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_73_iblosout_gix ON test.line_in_73_iblosout USING GIST (geom);
ALTER TABLE test.line_in_73_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;





-- Decoupage de lignes à l'intérieur du buffer entier 0(par dpt)
DROP TABLE IF EXISTS test.line_in_73_ibloaerien;
CREATE TABLE test.line_in_73_ibloaerien AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_73_ibloaerien_decoup as tpolygone,
    test.line_73 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_73_ibloaerien_gix ON test.line_in_73_ibloaerien USING GIST (geom);
ALTER TABLE test.line_in_73_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'intérieur du buffer entier 1(par dpt)
DROP TABLE IF EXISTS test.line_in_73_enedisaerien;
CREATE TABLE test.line_in_73_enedisaerien AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_73_enedisaerien_decoup_left as tpolygone,
    test.line_73 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_73_enedisaerien_gix ON test.line_in_73_enedisaerien USING GIST (geom);
ALTER TABLE test.line_in_73_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;

-- Union des lignes à l'intérieur des buffers 0/1/7
DROP TABLE IF EXISTS aura.line_in_73;
CREATE TABLE aura.line_in_73 AS
select idligne, id, type, 'IBLO_SOUTERRAIN'::varchar (20) as emprise, geom
from test.line_in_73_iblosout
union all
select idligne, id, type,'ENEDIS_AERIEN'::varchar (20) as emprise, geom
from test.line_in_73_enedisaerien
union all
select idligne, id, type, 'IBLO_AERIEN'::varchar (20) as emprise, geom
from test.line_in_73_ibloaerien;

CREATE INDEX line_in_73_gix ON aura.line_in_73 USING GIST (geom);
ALTER TABLE aura.line_in_73 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.line_in_73 ALTER COLUMN geom type geometry(MultiLinestring, 2734) using ST_Multi(geom);

-- Union des 2 tables lignes (intérieur/extérieur)
DROP TABLE IF EXISTS aura.line_type_73;
CREATE TABLE aura.line_type_73 AS
select id, type, emprise, geom
from aura.line_in_73
union all
select id, type, emprise, geom
from aura.line_out_73;

CREATE INDEX line_type_73_gix ON aura.line_type_73 USING GIST (geom);
ALTER TABLE aura.line_type_73 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.line_type_73 ALTER COLUMN geom type geometry(MultiLinestring, 2734) using ST_Multi(geom);

-- Suppression tables intermediaires;
drop table if exists test.tampon_73 ;
drop table if exists test.tampon_73_ibloaerien;
drop table if exists test.tampon_73_enedisaerien;
drop table if exists test.tampon_73_all;
drop table if exists test.tampon_73_iblosout;
drop table if exists test.tampon_extract_union_73;
drop table if exists test.tampon_extract_union_73_ibloaerien;
drop table if exists test.tampon_extract_union_73_enedisaerien;
drop table if exists test.tampon_extract_union_73_iblosout;
drop table if exists test.tampon_extract_union_73_all;
drop table if exists test.buffer_difference_73;
drop table if exists test.line_out_poly_73;
drop table if exists test.tampon_73_line;
drop table if exists test.tampon_extract_union_73_line;
drop table if exists test.tampon_extract_union_73_fusion_pit;
drop table if exists test.tampon_extract_union_73_pit;
drop table if exists test.buffer_difference_line_73;
drop table if exists test.line_out_poly_line_73;
drop table if exists test.tampon_line_out_73;
drop table if exists test.tampon_extract_union_73_line_out ;
drop table if exists test.buffer_difference_in_73;
drop table if exists test.buffer_difference_in_73_ibloaerien;
drop table if exists test.buffer_difference_in_73_enedisaerien;
drop table if exists test.buffer_difference_in_73_iblosout;
drop table if exists test.buffer_difference_in_73_ibloaerien_decoup;
drop table if exists test.buffer_difference_in_73_enedisaerien_decoup;
drop table if exists test.buffer_difference_in_73_enedisaerien_decoup_left;
drop table if exists test.line_in_73_iblosout;
drop table if exists test.line_in_73_ibloaerien;
drop table if exists test.line_in_73_enedisaerien;


-- DEPARTEMENT 74


-- Tampon avec mode de pose 0/1/7
DROP TABLE IF EXISTS test.tampon_74;
CREATE TABLE test.tampon_74 as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 30) as geom
FROM test.arciti_74
where mode_pose like '0' or mode_pose like '1' or mode_pose like '7';
-- Index geom
CREATE INDEX tampon_74_gix ON test.tampon_74 USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_74 ALTER COLUMN geom type geometry(MultiPolygon, 2744) using ST_Multi(geom);

-- Tampon avec mode de pose 0
DROP TABLE IF EXISTS test.tampon_74_ibloaerien;
CREATE TABLE test.tampon_74_ibloaerien as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 30) as geom
FROM test.arciti_74
where mode_pose like '0' ;
-- Index geom
CREATE INDEX tampon_74_ibloaerien_gix ON test.tampon_74_ibloaerien USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_74_ibloaerien ALTER COLUMN geom type geometry(MultiPolygon, 2744) using ST_Multi(geom);

-- Tampon avec mode de pose 1
DROP TABLE IF EXISTS test.tampon_74_enedisaerien;
CREATE TABLE test.tampon_74_enedisaerien as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 30) as geom
FROM test.arciti_74
where mode_pose like '1' ;
-- Index geom
CREATE INDEX tampon_74_enedisaerien_gix ON test.tampon_74_enedisaerien USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_74_enedisaerien ALTER COLUMN geom type geometry(MultiPolygon, 2744) using ST_Multi(geom);

-- Tampon avec mode de pose 7
DROP TABLE IF EXISTS test.tampon_74_iblosout;
CREATE TABLE test.tampon_74_iblosout as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 30) as geom
FROM test.arciti_74
where mode_pose like '7' ;
-- Index geom
CREATE INDEX tampon_74_iblosout_gix ON test.tampon_74_iblosout USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_74_iblosout ALTER COLUMN geom type geometry(MultiPolygon, 2744) using ST_Multi(geom);


-- Tampon avec tous modes de pose 
DROP TABLE IF EXISTS test.tampon_74_all;
CREATE TABLE test.tampon_74_all as 
SELECT gid, statut, mode_pose, nature_con, type_longu, longueur, compositio, 
       id_proprie, origine, shape_len, st_buffer(geom, 30) as geom
FROM test.arciti_74;
-- Index geometrique
CREATE INDEX tampon_74_all_gix ON test.tampon_74_all USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_74_all ALTER COLUMN geom type geometry(MultiPolygon, 2744) using ST_Multi(geom);


-- Union des tampons 0/1/7 en un polygone 
DROP TABLE if exists test.tampon_extract_union_74  ;
CREATE TABLE test.tampon_extract_union_74 as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_74
;
-- Index geometrique
CREATE INDEX tampon_extract_union_74_gix ON test.tampon_extract_union_74 USING GIST (geom);


-- Union des tampons 0 en un polygone 
DROP TABLE if exists test.tampon_extract_union_74_ibloaerien  ;
CREATE TABLE test.tampon_extract_union_74_ibloaerien as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, '0'::varchar as mode_pose
FROM 
    test.tampon_74_ibloaerien
;
-- Index geometrique
CREATE INDEX tampon_extract_union_74_ibloaerien_gix ON test.tampon_extract_union_74_ibloaerien USING GIST (geom);
ALTER TABLE test.tampon_extract_union_74_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union des tampons 1 en un polygone 
DROP TABLE if exists test.tampon_extract_union_74_enedisaerien  ;
CREATE TABLE test.tampon_extract_union_74_enedisaerien as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, '1'::varchar as mode_pose
FROM 
    test.tampon_74_enedisaerien
;
-- Index geometrique
CREATE INDEX tampon_extract_union_74_enedisaerien_gix ON test.tampon_extract_union_74_enedisaerien USING GIST (geom);
ALTER TABLE test.tampon_extract_union_74_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union des tampons 7 en un polygone 
DROP TABLE if exists test.tampon_extract_union_74_iblosout  ;
CREATE TABLE test.tampon_extract_union_74_iblosout as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom,  '7'::varchar as mode_pose
FROM 
    test.tampon_74_iblosout
;
-- Index geometrique
CREATE INDEX tampon_extract_union_74_iblosout_gix ON test.tampon_extract_union_74_iblosout USING GIST (geom);

ALTER TABLE test.tampon_extract_union_74_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;


-- Union de tous les tampons en un polygone 
DROP TABLE if exists test.tampon_extract_union_74_all  ;
CREATE TABLE test.tampon_extract_union_74_all as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, 7
FROM 
    test.tampon_74_all
;


-- Index geometrique
CREATE INDEX tampon_extract_union_74_all_gix ON test.tampon_extract_union_74_all USING GIST (geom);
ALTER TABLE test.tampon_extract_union_74_all ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 0/1/7 unis
DROP TABLE IF EXISTS test.buffer_difference_74;
CREATE TABLE test.buffer_difference_74 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_74_all b join test.tampon_extract_union_74 a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_74_all b left join temp t on b.gid = t.gid;


ALTER TABLE test.buffer_difference_74 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'exterieur du buffer entier (par dpt)
DROP TABLE IF EXISTS test.line_out_poly_74;
CREATE TABLE test.line_out_poly_74 AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_74 as tpolygone,
    test.line_74 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_out_poly_74_gix ON test.line_out_poly_74 USING GIST (geom);
ALTER TABLE test.line_out_poly_74 ADD COLUMN gid SERIAL PRIMARY KEY;

--- Tampon avec mode de pose 0/1/7
DROP TABLE IF EXISTS test.tampon_74_line;
CREATE TABLE test.tampon_74_line as 
SELECT gid, id, type, emprise, st_buffer(geom, 1) as geom
FROM test.line_74;

-- Index geom
CREATE INDEX tampon_74_line_gix ON test.tampon_74_line USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_74_line ALTER COLUMN geom type geometry(MultiPolygon, 2744) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_74_line  ;
CREATE TABLE test.tampon_extract_union_74_line as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_74_line
;

-- Index geom
CREATE INDEX tampon_extract_union_74_line_gix ON test.tampon_extract_union_74_line USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_74_line ALTER COLUMN geom type geometry(MultiPolygon, 2744) using ST_Multi(geom);
ALTER TABLE test.tampon_extract_union_74 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Fusion des deux tampons unis du pit
DROP TABLE if exists test.tampon_extract_union_74_fusion_pit  ;
CREATE TABLE test.tampon_extract_union_74_fusion_pit as 
select geom, gid
from test.tampon_extract_union_74_all
union all
select geom, gid
from test.tampon_extract_union_74;

-- Index geom
CREATE INDEX tampon_extract_union_74_fusion_pit_gix ON test.tampon_extract_union_74_fusion_pit USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_74_fusion_pit ALTER COLUMN geom type geometry(MultiPolygon, 2744) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_74_pit  ;
CREATE TABLE test.tampon_extract_union_74_pit as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_extract_union_74_fusion_pit
;

-- Index geom
CREATE INDEX tampon_extract_union_74_pit_gix ON test.tampon_extract_union_74_pit USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_74_pit ALTER COLUMN geom type geometry(MultiPolygon, 2744) using ST_Multi(geom);

ALTER TABLE test.tampon_extract_union_74_line ADD COLUMN gid SERIAL PRIMARY KEY;



-- difference
DROP TABLE IF EXISTS test.buffer_difference_line_74;
CREATE TABLE test.buffer_difference_line_74 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_74_line b join test.tampon_extract_union_74_pit a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_74_line b left join temp t on b.gid = t.gid;

ALTER TABLE test.buffer_difference_line_74 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'exterieur du buffer entier et du pit(par dpt)
DROP TABLE IF EXISTS test.line_out_poly_line_74;
CREATE TABLE test.line_out_poly_line_74 AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_line_74 as tpolygone,
    test.line_74 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;



-- Index geometrique
CREATE INDEX line_out_poly_line_74_gix ON test.line_out_poly_line_74 USING GIST (geom);
ALTER TABLE test.line_out_poly_line_74 ADD COLUMN gid SERIAL PRIMARY KEY;

-- Union des lignes en dehors du buffer en mode pose 0/1/7
drop table if exists aura.line_out_74;
create table aura.line_out_74 as 
SELECT idligne, id, type, emprise, geom
FROM test.line_out_poly_74
union all
select idligne, id, type, emprise, geom
from test.line_out_poly_line_74;
-- Index geometrique
CREATE INDEX line_out_74_gix ON aura.line_out_74 USING GIST (geom);
ALTER TABLE aura.line_out_74 ADD COLUMN gid SERIAL PRIMARY KEY;

-- Mise à jour champ emprise avec valeur 'GC_A_CREER'
UPDATE aura.line_out_74 set emprise = 'GC_A_CREER';
ALTER TABLE aura.line_out_74 ALTER COLUMN geom type geometry(MultiLinestring, 2744) using ST_Multi(geom);

--- Tampon autour de line_out_74
DROP TABLE IF EXISTS test.tampon_line_out_74;
CREATE TABLE test.tampon_line_out_74 as 
SELECT gid, id, type, emprise, st_buffer(geom,0.074) as geom
FROM aura.line_out_74;

-- Index geom
CREATE INDEX tampon_line_out_74_gix ON test.tampon_line_out_74 USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_line_out_74 ALTER COLUMN geom type geometry(MultiPolygon, 2744) using ST_Multi(geom);


--Union de la geometrie
DROP TABLE if exists test.tampon_extract_union_74_line_out ;
CREATE TABLE test.tampon_extract_union_74_line_out as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom
FROM 
    test.tampon_line_out_74
;

-- Index geom
CREATE INDEX tampon_extract_union_74_line_out_gix ON test.tampon_extract_union_74_line_out USING GIST (geom);    
-- Force le type de geom
ALTER TABLE test.tampon_extract_union_74_line_out ALTER COLUMN geom type geometry(MultiPolygon, 2744) using ST_Multi(geom);
ALTER TABLE test.tampon_extract_union_74_line_out ADD COLUMN gid SERIAL PRIMARY KEY;


-- Diffrence entre tampon tout pit et tampon 0/1/7 unis
DROP TABLE IF EXISTS test.buffer_difference_in_74;
CREATE TABLE test.buffer_difference_in_74 AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom
  from     test.tampon_extract_union_74 b join test.tampon_extract_union_74_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from test.tampon_extract_union_74 b left join temp t on b.gid = t.gid;


ALTER TABLE test.buffer_difference_in_74 ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 0 unis
DROP TABLE IF EXISTS test.buffer_difference_in_74_ibloaerien;
CREATE TABLE test.buffer_difference_in_74_ibloaerien AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_74_ibloaerien b join test.tampon_extract_union_74_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_74_ibloaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_74_ibloaerien_gix ON test.buffer_difference_in_74_ibloaerien USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_74_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 1 unis
DROP TABLE IF EXISTS test.buffer_difference_in_74_enedisaerien;
CREATE TABLE test.buffer_difference_in_74_enedisaerien AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_74_enedisaerien b join test.tampon_extract_union_74_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_74_enedisaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_74_enedisaerien_gix ON test.buffer_difference_in_74_enedisaerien USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_74_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre tampon tout pit et tampon 7 unis
DROP TABLE IF EXISTS test.buffer_difference_in_74_iblosout;
CREATE TABLE test.buffer_difference_in_74_iblosout AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.tampon_extract_union_74_iblosout b join test.tampon_extract_union_74_line_out a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.tampon_extract_union_74_iblosout b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_74_iblosout_gix ON test.buffer_difference_in_74_iblosout USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_74_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;


-- Difference entre  0 et 7 pour ne garder que ce qui ne se superpose pas à 7

DROP TABLE IF EXISTS test.buffer_difference_in_74_ibloaerien_decoup;
CREATE TABLE test.buffer_difference_in_74_ibloaerien_decoup AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_74_ibloaerien b join test.buffer_difference_in_74_iblosout a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_74_ibloaerien b left join temp t on b.gid = t.gid;


-- Index geom
CREATE INDEX buffer_difference_in_74_ibloaerien_decoup_gix ON test.buffer_difference_in_74_ibloaerien_decoup USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_74_ibloaerien_decoup ADD COLUMN gid SERIAL PRIMARY KEY;

-- Difference entre  1 et 7 pour ne garder que ce qui ne se superpose pas à 7


DROP TABLE IF EXISTS test.buffer_difference_in_74_enedisaerien_decoup;
CREATE TABLE test.buffer_difference_in_74_enedisaerien_decoup AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_74_enedisaerien b join test.buffer_difference_in_74_iblosout a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_74_enedisaerien b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_74_enedisaerien_decoup_gix ON test.buffer_difference_in_74_enedisaerien_decoup USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_74_enedisaerien_decoup ADD COLUMN gid SERIAL PRIMARY KEY;

-- Difference entre  1 (après découp sur 7) et 0 pour ne garder que ce qui ne se superpose pas à 0



DROP TABLE IF EXISTS test.buffer_difference_in_74_enedisaerien_decoup_left;
CREATE TABLE test.buffer_difference_in_74_enedisaerien_decoup_left AS
with temp as 
(
  select   b.gid, st_union(a.geom) as geom, b.mode_pose
  from     test.buffer_difference_in_74_enedisaerien_decoup b join test.buffer_difference_in_74_ibloaerien a on st_intersects(a.geom, b.geom)
  group by b.gid
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom, b.mode_pose
from test.buffer_difference_in_74_enedisaerien_decoup b left join temp t on b.gid = t.gid;

-- Index geom
CREATE INDEX buffer_difference_in_74_enedisaerien_decoup_left_gix ON test.buffer_difference_in_74_enedisaerien_decoup_left USING GIST (geom);  
ALTER TABLE test.buffer_difference_in_74_enedisaerien_decoup_left ADD COLUMN gid SERIAL PRIMARY KEY;


-- Table de buffer finale

DROP TABLE IF EXISTS aura.buffer_in_74;
CREATE TABLE aura.buffer_in_74 AS
select mode_pose, geom
from test.buffer_difference_in_74_iblosout
union all
select mode_pose, geom
from test.buffer_difference_in_74_ibloaerien_decoup
union all
select mode_pose, geom
from test.buffer_difference_in_74_enedisaerien_decoup_left;

CREATE INDEX buffer_in_74_gix ON aura.buffer_in_74 USING GIST (geom);  
ALTER TABLE aura.buffer_in_74 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.buffer_in_74 ALTER COLUMN geom type geometry(MultiPolygon, 2744) using ST_Multi(geom);

-- Decoupage de lignes à l'intérieur du buffer entier 7(par dpt)
DROP TABLE IF EXISTS test.line_in_74_iblosout;
CREATE TABLE test.line_in_74_iblosout AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_74_iblosout as tpolygone,
    test.line_74 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_74_iblosout_gix ON test.line_in_74_iblosout USING GIST (geom);
ALTER TABLE test.line_in_74_iblosout ADD COLUMN gid SERIAL PRIMARY KEY;





-- Decoupage de lignes à l'intérieur du buffer entier 0(par dpt)
DROP TABLE IF EXISTS test.line_in_74_ibloaerien;
CREATE TABLE test.line_in_74_ibloaerien AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_74_ibloaerien_decoup as tpolygone,
    test.line_74 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_74_ibloaerien_gix ON test.line_in_74_ibloaerien USING GIST (geom);
ALTER TABLE test.line_in_74_ibloaerien ADD COLUMN gid SERIAL PRIMARY KEY;


-- Decoupage de lignes à l'intérieur du buffer entier 1(par dpt)
DROP TABLE IF EXISTS test.line_in_74_enedisaerien;
CREATE TABLE test.line_in_74_enedisaerien AS
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    'L'||tligne.gid AS idligne,
    'P'||tpolygone.gid AS idpolygone, 
    tligne.id,
    tligne.type,
    tligne.emprise
    
FROM
    test.buffer_difference_in_74_enedisaerien_decoup_left as tpolygone,
    test.line_74 as tligne
WHERE
    tpolygone.geom && tligne.geom
AND 
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.gid,
    tpolygone.gid
;

-- Index geometrique
CREATE INDEX line_in_74_enedisaerien_gix ON test.line_in_74_enedisaerien USING GIST (geom);
ALTER TABLE test.line_in_74_enedisaerien ADD COLUMN gid SERIAL PRIMARY KEY;

-- Union des lignes à l'intérieur des buffers 0/1/7
DROP TABLE IF EXISTS aura.line_in_74;
CREATE TABLE aura.line_in_74 AS
select idligne, id, type, 'IBLO_SOUTERRAIN'::varchar (20) as emprise, geom
from test.line_in_74_iblosout
union all
select idligne, id, type,'ENEDIS_AERIEN'::varchar (20) as emprise, geom
from test.line_in_74_enedisaerien
union all
select idligne, id, type, 'IBLO_AERIEN'::varchar (20) as emprise, geom
from test.line_in_74_ibloaerien;

CREATE INDEX line_in_74_gix ON aura.line_in_74 USING GIST (geom);
ALTER TABLE aura.line_in_74 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.line_in_74 ALTER COLUMN geom type geometry(MultiLinestring, 2744) using ST_Multi(geom);

-- Union des 2 tables lignes (intérieur/extérieur)
DROP TABLE IF EXISTS aura.line_type_74;
CREATE TABLE aura.line_type_74 AS
select id, type, emprise, geom
from aura.line_in_74
union all
select id, type, emprise, geom
from aura.line_out_74;

CREATE INDEX line_type_74_gix ON aura.line_type_74 USING GIST (geom);
ALTER TABLE aura.line_type_74 ADD COLUMN gid SERIAL PRIMARY KEY;
ALTER TABLE aura.line_type_74 ALTER COLUMN geom type geometry(MultiLinestring, 2744) using ST_Multi(geom);

-- Suppression tables intermediaires;
drop table if exists test.tampon_74 ;
drop table if exists test.tampon_74_ibloaerien;
drop table if exists test.tampon_74_enedisaerien;
drop table if exists test.tampon_74_all;
drop table if exists test.tampon_74_iblosout;
drop table if exists test.tampon_extract_union_74;
drop table if exists test.tampon_extract_union_74_ibloaerien;
drop table if exists test.tampon_extract_union_74_enedisaerien;
drop table if exists test.tampon_extract_union_74_iblosout;
drop table if exists test.tampon_extract_union_74_all;
drop table if exists test.buffer_difference_74;
drop table if exists test.line_out_poly_74;
drop table if exists test.tampon_74_line;
drop table if exists test.tampon_extract_union_74_line;
drop table if exists test.tampon_extract_union_74_fusion_pit;
drop table if exists test.tampon_extract_union_74_pit;
drop table if exists test.buffer_difference_line_74;
drop table if exists test.line_out_poly_line_74;
drop table if exists test.tampon_line_out_74;
drop table if exists test.tampon_extract_union_74_line_out ;
drop table if exists test.buffer_difference_in_74;
drop table if exists test.buffer_difference_in_74_ibloaerien;
drop table if exists test.buffer_difference_in_74_enedisaerien;
drop table if exists test.buffer_difference_in_74_iblosout;
drop table if exists test.buffer_difference_in_74_ibloaerien_decoup;
drop table if exists test.buffer_difference_in_74_enedisaerien_decoup;
drop table if exists test.buffer_difference_in_74_enedisaerien_decoup_left;
drop table if exists test.line_in_74_iblosout;
drop table if exists test.line_in_74_ibloaerien;
drop table if exists test.line_in_74_enedisaerien;
