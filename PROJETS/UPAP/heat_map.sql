
ALTER TABLE "analyse".heat_map 
ADD range_id_interval integer ;

update "analyse".heat_map  set range_id_interval = 1 where dn <= 105;
update "analyse".heat_map  set range_id_interval = 2 where dn between 106 and 210;
update "analyse".heat_map  set range_id_interval = 3 where dn between 211 and 315;
update "analyse".heat_map  set range_id_interval = 4 where dn between 316 and 420;
update "analyse".heat_map  set range_id_interval = 5 where dn between 421 and 525;
update "analyse".heat_map  set range_id_interval = 6 where dn between 526 and 630;
update "analyse".heat_map  set range_id_interval = 7 where dn >=630;

drop table if exists "analyse".heat_map_intervales_egaux;
create table "analyse".heat_map_intervales_egaux as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, range_id_interval
FROM 
    "analyse".heat_map 
    group by range_id_interval
;

update "analyse".heat_map_intervales_egaux  set geom = ST_Buffer (ST_Buffer (geom, 15), -15) ;

update "analyse".heat_map  set range_id = 1 where dn <= 81;
update "analyse".heat_map  set range_id = 2 where dn between 82 and 150;
update "analyse".heat_map  set range_id = 3 where dn between 151 and 208;
update "analyse".heat_map  set range_id = 4 where dn between 209 and 264;
update "analyse".heat_map  set range_id = 5 where dn between 265 and 333;
update "analyse".heat_map  set range_id = 6 where dn between 334 and 435;
update "analyse".heat_map  set range_id = 7 where dn >=435;

drop table if exists "analyse".heat_map_quantile;
create table "analyse".heat_map_quantile as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, range_id
FROM 
    "analyse".heat_map 
    group by range_id
;

update "analyse".heat_map_quantile  set geom = ST_Buffer (ST_Buffer (geom, 15), -15) 
;