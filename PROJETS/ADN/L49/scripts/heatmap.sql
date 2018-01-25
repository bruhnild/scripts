--- HEAT 500

drop table if exists analyse_thematique.heat500_agg1;
create table analyse_thematique.heat500_agg1 as 
SELECT (ST_UnaryUnion(ST_Collect(geom))) geom,'0-6'::varchar as dn 
  FROM analyse_thematique.heat500
  where dn >=0 and dn <=6
  group by dn
  ;

drop table if exists analyse_thematique.heat500_agg1_;
create table analyse_thematique.heat500_agg1_ as 
SELECT st_union (geom) geom, dn
  FROM analyse_thematique.heat500_agg1
  group by dn;
  

drop table if exists analyse_thematique.heat500_agg1__;
create table analyse_thematique.heat500_agg1__ as 
select st_buffer(st_buffer(st_buffer(st_simplify(geom,10), 10), -10), 40)geom, dn
FROM analyse_thematique.heat500_agg1_
;

drop table if exists analyse_thematique.heat500_agg2;
create table analyse_thematique.heat500_agg2 as 
SELECT (ST_UnaryUnion(ST_Collect(geom))) geom,'7-11'::varchar as dn 
  FROM analyse_thematique.heat500
  where dn >=7 and dn <=11
  group by dn;

drop table if exists analyse_thematique.heat500_agg2_;
create table analyse_thematique.heat500_agg2_ as 
SELECT st_union (geom) geom, dn
  FROM analyse_thematique.heat500_agg2
  group by dn;


drop table if exists analyse_thematique.heat500_agg2__;
create table analyse_thematique.heat500_agg2__ as 
select st_buffer(st_buffer(st_buffer(st_simplify(geom,10), 10), -10), 40)geom, dn
FROM analyse_thematique.heat500_agg2_
;

  drop table if exists analyse_thematique.heat500_agg3;
create table analyse_thematique.heat500_agg3 as 
SELECT (ST_UnaryUnion(ST_Collect(geom))) geom,'12-20'::varchar as dn 
  FROM analyse_thematique.heat500
  where dn >=12 and dn <=20
  group by dn;

  drop table if exists analyse_thematique.heat500_agg3_;
create table analyse_thematique.heat500_agg3_ as 
SELECT st_union (geom) geom, dn
  FROM analyse_thematique.heat500_agg3
  group by dn;
  

drop table if exists analyse_thematique.heat500_agg3__;
create table analyse_thematique.heat500_agg3__ as 
select st_buffer(st_buffer(st_buffer(st_simplify(geom,10), 10), -10), 40)geom, dn
FROM analyse_thematique.heat500_agg3_
;
  drop table if exists analyse_thematique.heat500_agg4;
create table analyse_thematique.heat500_agg4 as 
SELECT (ST_UnaryUnion(ST_Collect(geom))) geom,'21-41'::varchar as dn 
  FROM analyse_thematique.heat500
  where dn >=21 and dn <=41
  group by dn;

  drop table if exists analyse_thematique.heat500_agg4_;
create table analyse_thematique.heat500_agg4_ as 
SELECT st_union (geom) geom, dn
  FROM analyse_thematique.heat500_agg4
  group by dn;
  


drop table if exists analyse_thematique.heat500_agg4__;
create table analyse_thematique.heat500_agg4__ as 
select st_buffer(st_buffer(st_buffer(st_simplify(geom,10), 10), -10), 40)geom, dn
FROM analyse_thematique.heat500_agg4_
;

  drop table if exists analyse_thematique.heat500_agg5;
create table analyse_thematique.heat500_agg5 as 
SELECT (ST_UnaryUnion(ST_Collect(geom))) geom,'>=42'::varchar as dn 
  FROM analyse_thematique.heat500
  where dn >=42 
  group by dn;

  drop table if exists analyse_thematique.heat500_agg5_;
create table analyse_thematique.heat500_agg5_ as 
SELECT st_union (geom) geom, dn
  FROM analyse_thematique.heat500_agg5
  group by dn;
  

drop table if exists analyse_thematique.heat500_agg5__;
create table analyse_thematique.heat500_agg5__ as 
select st_buffer(st_buffer(st_buffer(st_simplify(geom,10), 10), -10), 40)geom, dn
FROM analyse_thematique.heat500_agg5_
;

drop table if exists analyse_thematique.heat_500;
create table analyse_thematique.heat_500 as 
SELECT geom, dn
	FROM analyse_thematique.heat500_agg1__
	union all
	SELECT geom, dn
	FROM analyse_thematique.heat500_agg2__
	union all
	SELECT geom, dn
	FROM analyse_thematique.heat500_agg3__
	union all
	SELECT geom, dn
	FROM analyse_thematique.heat500_agg4__
	union all
	SELECT geom, dn
	FROM analyse_thematique.heat500_agg5__;
	
	drop table if exists analyse_thematique.heat500_agg1_;
	drop table if exists analyse_thematique.heat500_agg2_;
	drop table if exists analyse_thematique.heat500_agg3_;
	drop table if exists analyse_thematique.heat500_agg4_;
	drop table if exists analyse_thematique.heat500_agg5_;
	drop table if exists analyse_thematique.heat500_agg1;
	drop table if exists analyse_thematique.heat500_agg2;
	drop table if exists analyse_thematique.heat500_agg3;
	drop table if exists analyse_thematique.heat500_agg4;
	drop table if exists analyse_thematique.heat500_agg5;
	drop table if exists analyse_thematique.heat500_agg1__;
	drop table if exists analyse_thematique.heat500_agg2__;
	drop table if exists analyse_thematique.heat500_agg3__;
	drop table if exists analyse_thematique.heat500_agg4__;
	drop table if exists analyse_thematique.heat500_agg5__;


	------- HEAT 1000

	drop table if exists analyse_thematique.heat1000_agg1;
create table analyse_thematique.heat1000_agg1 as 
SELECT (ST_UnaryUnion(ST_Collect(geom))) geom,'0-15'::varchar as dn 
  FROM analyse_thematique.heat1000
  where dn >=0 and dn <=15
  group by dn;
  
drop table if exists analyse_thematique.heat1000_agg1_;
create table analyse_thematique.heat1000_agg1_ as 
SELECT st_union (geom) geom, dn
  FROM analyse_thematique.heat1000_agg1
  group by dn;
  

drop table if exists analyse_thematique.heat1000_agg1__;
create table analyse_thematique.heat1000_agg1__ as 
select st_buffer(st_buffer(st_buffer(st_simplify(geom,10), 10), -10), 40)geom, dn
FROM analyse_thematique.heat1000_agg1_
;

drop table if exists analyse_thematique.heat1000_agg2;
create table analyse_thematique.heat1000_agg2 as 
SELECT (ST_UnaryUnion(ST_Collect(geom))) geom,'16-27'::varchar as dn 
  FROM analyse_thematique.heat1000
  where dn >=16 and dn <=27
  group by dn;

drop table if exists analyse_thematique.heat1000_agg2_;
create table analyse_thematique.heat1000_agg2_ as 
SELECT st_union (geom) geom, dn
  FROM analyse_thematique.heat1000_agg2
  group by dn;


drop table if exists analyse_thematique.heat1000_agg2__;
create table analyse_thematique.heat1000_agg2__ as 
select st_buffer(st_buffer(st_buffer(st_simplify(geom,10), 10), -10), 40)geom, dn
FROM analyse_thematique.heat1000_agg2_
;

  drop table if exists analyse_thematique.heat1000_agg3;
create table analyse_thematique.heat1000_agg3 as 
SELECT (ST_UnaryUnion(ST_Collect(geom))) geom,'28-47'::varchar as dn 
  FROM analyse_thematique.heat1000
  where dn >=28 and dn <=47
  group by dn;

  drop table if exists analyse_thematique.heat1000_agg3_;
create table analyse_thematique.heat1000_agg3_ as 
SELECT st_union (geom) geom, dn
  FROM analyse_thematique.heat1000_agg3
  group by dn;
  

drop table if exists analyse_thematique.heat1000_agg3__;
create table analyse_thematique.heat1000_agg3__ as 
select st_buffer(st_buffer(st_buffer(st_simplify(geom,10), 10), -10), 40)geom, dn
FROM analyse_thematique.heat1000_agg3_
;
  drop table if exists analyse_thematique.heat1000_agg4;
create table analyse_thematique.heat1000_agg4 as 
SELECT (ST_UnaryUnion(ST_Collect(geom))) geom,'48-93'::varchar as dn 
  FROM analyse_thematique.heat1000
  where dn >=48 and dn <=93
  group by dn;

  drop table if exists analyse_thematique.heat1000_agg4_;
create table analyse_thematique.heat1000_agg4_ as 
SELECT st_union (geom) geom, dn
  FROM analyse_thematique.heat1000_agg4
  group by dn;
  


drop table if exists analyse_thematique.heat1000_agg4__;
create table analyse_thematique.heat1000_agg4__ as 
select st_buffer(st_buffer(st_buffer(st_simplify(geom,10), 10), -10), 40)geom, dn
FROM analyse_thematique.heat1000_agg4_
;

  drop table if exists analyse_thematique.heat1000_agg5;
create table analyse_thematique.heat1000_agg5 as 
SELECT (ST_UnaryUnion(ST_Collect(geom))) geom,'>=94'::varchar as dn 
  FROM analyse_thematique.heat1000
  where dn >=94 
  group by dn;

  drop table if exists analyse_thematique.heat1000_agg5_;
create table analyse_thematique.heat1000_agg5_ as 
SELECT st_union (geom) geom, dn
  FROM analyse_thematique.heat1000_agg5
  group by dn;
  

drop table if exists analyse_thematique.heat1000_agg5__;
create table analyse_thematique.heat1000_agg5__ as 
select st_buffer(st_buffer(st_buffer(st_simplify(geom,10), 10), -10), 40)geom, dn
FROM analyse_thematique.heat1000_agg5_
;

drop table if exists analyse_thematique.heat_1000;
create table analyse_thematique.heat_1000 as 
SELECT geom, dn
	FROM analyse_thematique.heat1000_agg1__
	union all
	SELECT geom, dn
	FROM analyse_thematique.heat1000_agg2__
	union all
	SELECT geom, dn
	FROM analyse_thematique.heat1000_agg3__
	union all
	SELECT geom, dn
	FROM analyse_thematique.heat1000_agg4__
	union all
	SELECT geom, dn
	FROM analyse_thematique.heat1000_agg5__;
	
	drop table if exists analyse_thematique.heat1000_agg1_;
	drop table if exists analyse_thematique.heat1000_agg2_;
	drop table if exists analyse_thematique.heat1000_agg3_;
	drop table if exists analyse_thematique.heat1000_agg4_;
	drop table if exists analyse_thematique.heat1000_agg5_;
	drop table if exists analyse_thematique.heat1000_agg1;
	drop table if exists analyse_thematique.heat1000_agg2;
	drop table if exists analyse_thematique.heat1000_agg3;
	drop table if exists analyse_thematique.heat1000_agg4;
	drop table if exists analyse_thematique.heat1000_agg5;
	drop table if exists analyse_thematique.heat1000_agg1__;
	drop table if exists analyse_thematique.heat1000_agg2__;
	drop table if exists analyse_thematique.heat1000_agg3__;
	drop table if exists analyse_thematique.heat1000_agg4__;
	drop table if exists analyse_thematique.heat1000_agg5__;


--- HEAT 1500

drop table if exists analyse_thematique.heat1500_agg1;
create table analyse_thematique.heat1500_agg1 as 
SELECT (ST_UnaryUnion(ST_Collect(geom))) geom,'0-26'::varchar as dn 
  FROM analyse_thematique.heat1500
  where dn >=0 and dn <=26
  group by dn
;
  
drop table if exists analyse_thematique.heat1500_agg1_;
create table analyse_thematique.heat1500_agg1_ as 
SELECT st_union (geom) geom, dn
  FROM analyse_thematique.heat1500_agg1
  group by dn;
  

drop table if exists analyse_thematique.heat1500_agg1__;
create table analyse_thematique.heat1500_agg1__ as 
select st_buffer(st_buffer(st_buffer(st_simplify(geom,10), 10), -10), 40)geom, dn
FROM analyse_thematique.heat1500_agg1_
;

drop table if exists analyse_thematique.heat1500_agg2;
create table analyse_thematique.heat1500_agg2 as 
SELECT (ST_UnaryUnion(ST_Collect(geom))) geom,'27-48'::varchar as dn 
  FROM analyse_thematique.heat1500
  where dn >=27 and dn <=48
  group by dn;

drop table if exists analyse_thematique.heat1500_agg2_;
create table analyse_thematique.heat1500_agg2_ as 
SELECT st_union (geom) geom, dn
  FROM analyse_thematique.heat1500_agg2
  group by dn;


drop table if exists analyse_thematique.heat1500_agg2__;
create table analyse_thematique.heat1500_agg2__ as 
select st_buffer(st_buffer(st_buffer(st_simplify(geom,10), 10), -10), 40)geom, dn
FROM analyse_thematique.heat1500_agg2_
;

  drop table if exists analyse_thematique.heat1500_agg3;
create table analyse_thematique.heat1500_agg3 as 
SELECT (ST_UnaryUnion(ST_Collect(geom))) geom,'49-81'::varchar as dn 
  FROM analyse_thematique.heat1500
  where dn >=49 and dn <=81
  group by dn;

  drop table if exists analyse_thematique.heat1500_agg3_;
create table analyse_thematique.heat1500_agg3_ as 
SELECT st_union (geom) geom, dn
  FROM analyse_thematique.heat1500_agg3
  group by dn;
  

drop table if exists analyse_thematique.heat1500_agg3__;
create table analyse_thematique.heat1500_agg3__ as 
select st_buffer(st_buffer(st_buffer(st_simplify(geom,10), 10), -10), 40)geom, dn
FROM analyse_thematique.heat1500_agg3_
;
  drop table if exists analyse_thematique.heat1500_agg4;
create table analyse_thematique.heat1500_agg4 as 
SELECT (ST_UnaryUnion(ST_Collect(geom))) geom,'82-156'::varchar as dn 
  FROM analyse_thematique.heat1500
  where dn >=82 and dn <=156
  group by dn;

  drop table if exists analyse_thematique.heat1500_agg4_;
create table analyse_thematique.heat1500_agg4_ as 
SELECT st_union (geom) geom, dn
  FROM analyse_thematique.heat1500_agg4
  group by dn;
  


drop table if exists analyse_thematique.heat1500_agg4__;
create table analyse_thematique.heat1500_agg4__ as 
select st_buffer(st_buffer(st_buffer(st_simplify(geom,10), 10), -10), 40)geom, dn
FROM analyse_thematique.heat1500_agg4_
;

  drop table if exists analyse_thematique.heat1500_agg5;
create table analyse_thematique.heat1500_agg5 as 
SELECT (ST_UnaryUnion(ST_Collect(geom))) geom,'>=157'::varchar as dn 
  FROM analyse_thematique.heat1500
  where dn >=157 
  group by dn;

  drop table if exists analyse_thematique.heat1500_agg5_;
create table analyse_thematique.heat1500_agg5_ as 
SELECT st_union (geom) geom, dn
  FROM analyse_thematique.heat1500_agg5
  group by dn;
  

drop table if exists analyse_thematique.heat1500_agg5__;
create table analyse_thematique.heat1500_agg5__ as 
select st_buffer(st_buffer(st_buffer(st_simplify(geom,10), 10), -10), 40)geom, dn
FROM analyse_thematique.heat1500_agg5_
;

drop table if exists analyse_thematique.heat_1500;
create table analyse_thematique.heat_1500 as 
SELECT geom, dn
	FROM analyse_thematique.heat1500_agg1__
	union all
	SELECT geom, dn
	FROM analyse_thematique.heat1500_agg2__
	union all
	SELECT geom, dn
	FROM analyse_thematique.heat1500_agg3__
	union all
	SELECT geom, dn
	FROM analyse_thematique.heat1500_agg4__
	union all
	SELECT geom, dn
	FROM analyse_thematique.heat1500_agg5__;
	
	drop table if exists analyse_thematique.heat1500_agg1_;
	drop table if exists analyse_thematique.heat1500_agg2_;
	drop table if exists analyse_thematique.heat1500_agg3_;
	drop table if exists analyse_thematique.heat1500_agg4_;
	drop table if exists analyse_thematique.heat1500_agg5_;
	drop table if exists analyse_thematique.heat1500_agg1;
	drop table if exists analyse_thematique.heat1500_agg2;
	drop table if exists analyse_thematique.heat1500_agg3;
	drop table if exists analyse_thematique.heat1500_agg4;
	drop table if exists analyse_thematique.heat1500_agg5;
	drop table if exists analyse_thematique.heat1500_agg1__;
	drop table if exists analyse_thematique.heat1500_agg2__;
	drop table if exists analyse_thematique.heat1500_agg3__;
	drop table if exists analyse_thematique.heat1500_agg4__;
	drop table if exists analyse_thematique.heat1500_agg5__;

--- HEAT 2000

drop table if exists analyse_thematique.heat2000_agg1;
create table analyse_thematique.heat2000_agg1 as 
SELECT (ST_UnaryUnion(ST_Collect(geom))) geom,'0-38'::varchar as dn 
  FROM analyse_thematique.heat2000
  where dn >=0 and dn <=38
  group by dn
;
  
drop table if exists analyse_thematique.heat2000_agg1_;
create table analyse_thematique.heat2000_agg1_ as 
SELECT st_union (geom) geom, dn
  FROM analyse_thematique.heat2000_agg1
  group by dn;
  

drop table if exists analyse_thematique.heat2000_agg1__;
create table analyse_thematique.heat2000_agg1__ as 
select st_buffer(st_buffer(st_buffer(st_simplify(geom,10), 10), -10), 40)geom, dn
FROM analyse_thematique.heat2000_agg1_
;

drop table if exists analyse_thematique.heat2000_agg2;
create table analyse_thematique.heat2000_agg2 as 
SELECT (ST_UnaryUnion(ST_Collect(geom))) geom,'39-71'::varchar as dn 
  FROM analyse_thematique.heat2000
  where dn >=39 and dn <=71
  group by dn;

drop table if exists analyse_thematique.heat2000_agg2_;
create table analyse_thematique.heat2000_agg2_ as 
SELECT st_union (geom) geom, dn
  FROM analyse_thematique.heat2000_agg2
  group by dn;


drop table if exists analyse_thematique.heat2000_agg2__;
create table analyse_thematique.heat2000_agg2__ as 
select st_buffer(st_buffer(st_buffer(st_simplify(geom,10), 10), -10), 40)geom, dn
FROM analyse_thematique.heat2000_agg2_
;

  drop table if exists analyse_thematique.heat2000_agg3;
create table analyse_thematique.heat2000_agg3 as 
SELECT (ST_UnaryUnion(ST_Collect(geom))) geom,'72-120'::varchar as dn 
  FROM analyse_thematique.heat2000
  where dn >=72 and dn <=120
  group by dn;

  drop table if exists analyse_thematique.heat2000_agg3_;
create table analyse_thematique.heat2000_agg3_ as 
SELECT st_union (geom) geom, dn
  FROM analyse_thematique.heat2000_agg3
  group by dn;
  

drop table if exists analyse_thematique.heat2000_agg3__;
create table analyse_thematique.heat2000_agg3__ as 
select st_buffer(st_buffer(st_buffer(st_simplify(geom,10), 10), -10), 40)geom, dn
FROM analyse_thematique.heat2000_agg3_
;
  drop table if exists analyse_thematique.heat2000_agg4;
create table analyse_thematique.heat2000_agg4 as 
SELECT (ST_UnaryUnion(ST_Collect(geom))) geom,'121-225'::varchar as dn 
  FROM analyse_thematique.heat2000
  where dn >=121 and dn <=225
  group by dn;

  drop table if exists analyse_thematique.heat2000_agg4_;
create table analyse_thematique.heat2000_agg4_ as 
SELECT st_union (geom) geom, dn
  FROM analyse_thematique.heat2000_agg4
  group by dn;
  


drop table if exists analyse_thematique.heat2000_agg4__;
create table analyse_thematique.heat2000_agg4__ as 
select st_buffer(st_buffer(st_buffer(st_simplify(geom,10), 10), -10), 40)geom, dn
FROM analyse_thematique.heat2000_agg4_
;

  drop table if exists analyse_thematique.heat2000_agg5;
create table analyse_thematique.heat2000_agg5 as 
SELECT (ST_UnaryUnion(ST_Collect(geom))) geom,'>=226'::varchar as dn 
  FROM analyse_thematique.heat2000
  where dn >=226
  group by dn;

  drop table if exists analyse_thematique.heat2000_agg5_;
create table analyse_thematique.heat2000_agg5_ as 
SELECT st_union (geom) geom, dn
  FROM analyse_thematique.heat2000_agg5
  group by dn;
  

drop table if exists analyse_thematique.heat2000_agg5__;
create table analyse_thematique.heat2000_agg5__ as 
select st_buffer(st_buffer(st_buffer(st_simplify(geom,10), 10), -10), 40)geom, dn
FROM analyse_thematique.heat2000_agg5_
;

drop table if exists analyse_thematique.heat_2000;
create table analyse_thematique.heat_2000 as 
SELECT geom, dn
	FROM analyse_thematique.heat2000_agg1__
	union all
	SELECT geom, dn
	FROM analyse_thematique.heat2000_agg2__
	union all
	SELECT geom, dn
	FROM analyse_thematique.heat2000_agg3__
	union all
	SELECT geom, dn
	FROM analyse_thematique.heat2000_agg4__
	union all
	SELECT geom, dn
	FROM analyse_thematique.heat2000_agg5__;
	
	drop table if exists analyse_thematique.heat2000_agg1_;
	drop table if exists analyse_thematique.heat2000_agg2_;
	drop table if exists analyse_thematique.heat2000_agg3_;
	drop table if exists analyse_thematique.heat2000_agg4_;
	drop table if exists analyse_thematique.heat2000_agg5_;
	drop table if exists analyse_thematique.heat2000_agg1;
	drop table if exists analyse_thematique.heat2000_agg2;
	drop table if exists analyse_thematique.heat2000_agg3;
	drop table if exists analyse_thematique.heat2000_agg4;
	drop table if exists analyse_thematique.heat2000_agg5;
	drop table if exists analyse_thematique.heat2000_agg1__;
	drop table if exists analyse_thematique.heat2000_agg2__;
	drop table if exists analyse_thematique.heat2000_agg3__;
	drop table if exists analyse_thematique.heat2000_agg4__;
	drop table if exists analyse_thematique.heat2000_agg5__;


	--- HEAT 3000

	drop table if exists analyse_thematique.heat3000_agg1;
create table analyse_thematique.heat3000_agg1 as 
SELECT (ST_UnaryUnion(ST_Collect(geom))) geom,'0-69'::varchar as dn 
  FROM analyse_thematique.heat3000
  where dn >=0 and dn <=69
  group by dn
;
  
drop table if exists analyse_thematique.heat3000_agg1_;
create table analyse_thematique.heat3000_agg1_ as 
SELECT st_union (geom) geom, dn
  FROM analyse_thematique.heat3000_agg1
  group by dn;
  

drop table if exists analyse_thematique.heat3000_agg1__;
create table analyse_thematique.heat3000_agg1__ as 
select st_buffer(st_buffer(st_buffer(st_simplify(geom,10), 10), -10), 40)geom, dn
FROM analyse_thematique.heat3000_agg1_
;

drop table if exists analyse_thematique.heat3000_agg2;
create table analyse_thematique.heat3000_agg2 as 
SELECT (ST_UnaryUnion(ST_Collect(geom))) geom,'70-134'::varchar as dn 
  FROM analyse_thematique.heat3000
  where dn >=70 and dn <=134
  group by dn;

drop table if exists analyse_thematique.heat3000_agg2_;
create table analyse_thematique.heat3000_agg2_ as 
SELECT st_union (geom) geom, dn
  FROM analyse_thematique.heat3000_agg2
  group by dn;


drop table if exists analyse_thematique.heat3000_agg2__;
create table analyse_thematique.heat3000_agg2__ as 
select st_buffer(st_buffer(st_buffer(st_simplify(geom,10), 10), -10), 40)geom, dn
FROM analyse_thematique.heat3000_agg2_
;

  drop table if exists analyse_thematique.heat3000_agg3;
create table analyse_thematique.heat3000_agg3 as 
SELECT (ST_UnaryUnion(ST_Collect(geom))) geom,'135-231'::varchar as dn 
  FROM analyse_thematique.heat3000
  where dn >=135 and dn <=231
  group by dn;

  drop table if exists analyse_thematique.heat3000_agg3_;
create table analyse_thematique.heat3000_agg3_ as 
SELECT st_union (geom) geom, dn
  FROM analyse_thematique.heat3000_agg3
  group by dn;
  

drop table if exists analyse_thematique.heat3000_agg3__;
create table analyse_thematique.heat3000_agg3__ as 
select st_buffer(st_buffer(st_buffer(st_simplify(geom,10), 10), -10), 40)geom, dn
FROM analyse_thematique.heat3000_agg3_
;
  drop table if exists analyse_thematique.heat3000_agg4;
create table analyse_thematique.heat3000_agg4 as 
SELECT (ST_UnaryUnion(ST_Collect(geom))) geom,'232-405'::varchar as dn 
  FROM analyse_thematique.heat3000
  where dn >=232 and dn <=405
  group by dn;

  drop table if exists analyse_thematique.heat3000_agg4_;
create table analyse_thematique.heat3000_agg4_ as 
SELECT st_union (geom) geom, dn
  FROM analyse_thematique.heat3000_agg4
  group by dn;
  


drop table if exists analyse_thematique.heat3000_agg4__;
create table analyse_thematique.heat3000_agg4__ as 
select st_buffer(st_buffer(st_buffer(st_simplify(geom,10), 10), -10), 40)geom, dn
FROM analyse_thematique.heat3000_agg4_
;

  drop table if exists analyse_thematique.heat3000_agg5;
create table analyse_thematique.heat3000_agg5 as 
SELECT (ST_UnaryUnion(ST_Collect(geom))) geom,'>=406'::varchar as dn 
  FROM analyse_thematique.heat3000
  where dn >=406
  group by dn;

  drop table if exists analyse_thematique.heat3000_agg5_;
create table analyse_thematique.heat3000_agg5_ as 
SELECT st_union (geom) geom, dn
  FROM analyse_thematique.heat3000_agg5
  group by dn;
  

drop table if exists analyse_thematique.heat3000_agg5__;
create table analyse_thematique.heat3000_agg5__ as 
select st_buffer(st_buffer(st_buffer(st_simplify(geom,10), 10), -10), 40)geom, dn
FROM analyse_thematique.heat3000_agg5_
;

drop table if exists analyse_thematique.heat_3000;
create table analyse_thematique.heat_3000 as 
SELECT geom, dn
	FROM analyse_thematique.heat3000_agg1__
	union all
	SELECT geom, dn
	FROM analyse_thematique.heat3000_agg2__
	union all
	SELECT geom, dn
	FROM analyse_thematique.heat3000_agg3__
	union all
	SELECT geom, dn
	FROM analyse_thematique.heat3000_agg4__
	union all
	SELECT geom, dn
	FROM analyse_thematique.heat3000_agg5__;
	
	drop table if exists analyse_thematique.heat3000_agg1_;
	drop table if exists analyse_thematique.heat3000_agg2_;
	drop table if exists analyse_thematique.heat3000_agg3_;
	drop table if exists analyse_thematique.heat3000_agg4_;
	drop table if exists analyse_thematique.heat3000_agg5_;
	drop table if exists analyse_thematique.heat3000_agg1;
	drop table if exists analyse_thematique.heat3000_agg2;
	drop table if exists analyse_thematique.heat3000_agg3;
	drop table if exists analyse_thematique.heat3000_agg4;
	drop table if exists analyse_thematique.heat3000_agg5;
	drop table if exists analyse_thematique.heat3000_agg1__;
	drop table if exists analyse_thematique.heat3000_agg2__;
	drop table if exists analyse_thematique.heat3000_agg3__;
	drop table if exists analyse_thematique.heat3000_agg4__;
	drop table if exists analyse_thematique.heat3000_agg5__;

--- HEAT 4000

drop table if exists analyse_thematique.heat4000_agg1;
create table analyse_thematique.heat4000_agg1 as 
SELECT (ST_UnaryUnion(ST_Collect(geom))) geom,'0-109'::varchar as dn 
  FROM analyse_thematique.heat4000
  where dn >=0 and dn <=109
  group by dn
;
  
drop table if exists analyse_thematique.heat4000_agg1_;
create table analyse_thematique.heat4000_agg1_ as 
SELECT st_union (geom) geom, dn
  FROM analyse_thematique.heat4000_agg1
  group by dn;
  

drop table if exists analyse_thematique.heat4000_agg1__;
create table analyse_thematique.heat4000_agg1__ as 
select st_buffer(st_buffer(st_buffer(st_simplify(geom,10), 10), -10), 40)geom, dn
FROM analyse_thematique.heat4000_agg1_
;

drop table if exists analyse_thematique.heat4000_agg2;
create table analyse_thematique.heat4000_agg2 as 
SELECT (ST_UnaryUnion(ST_Collect(geom))) geom,'110-218'::varchar as dn 
  FROM analyse_thematique.heat4000
  where dn >=110 and dn <=218
  group by dn;

drop table if exists analyse_thematique.heat4000_agg2_;
create table analyse_thematique.heat4000_agg2_ as 
SELECT st_union (geom) geom, dn
  FROM analyse_thematique.heat4000_agg2
  group by dn;


drop table if exists analyse_thematique.heat4000_agg2__;
create table analyse_thematique.heat4000_agg2__ as 
select st_buffer(st_buffer(st_buffer(st_simplify(geom,10), 10), -10), 40)geom, dn
FROM analyse_thematique.heat4000_agg2_
;

  drop table if exists analyse_thematique.heat4000_agg3;
create table analyse_thematique.heat4000_agg3 as 
SELECT (ST_UnaryUnion(ST_Collect(geom))) geom,'219-378'::varchar as dn 
  FROM analyse_thematique.heat4000
  where dn >=219 and dn <=378
  group by dn;

  drop table if exists analyse_thematique.heat4000_agg3_;
create table analyse_thematique.heat4000_agg3_ as 
SELECT st_union (geom) geom, dn
  FROM analyse_thematique.heat4000_agg3
  group by dn;
  

drop table if exists analyse_thematique.heat4000_agg3__;
create table analyse_thematique.heat4000_agg3__ as 
select st_buffer(st_buffer(st_buffer(st_simplify(geom,10), 10), -10), 40)geom, dn
FROM analyse_thematique.heat4000_agg3_
;
  drop table if exists analyse_thematique.heat4000_agg4;
create table analyse_thematique.heat4000_agg4 as 
SELECT (ST_UnaryUnion(ST_Collect(geom))) geom,'379-648'::varchar as dn 
  FROM analyse_thematique.heat4000
  where dn >=379 and dn <=648
  group by dn;

  drop table if exists analyse_thematique.heat4000_agg4_;
create table analyse_thematique.heat4000_agg4_ as 
SELECT st_union (geom) geom, dn
  FROM analyse_thematique.heat4000_agg4
  group by dn;
  


drop table if exists analyse_thematique.heat4000_agg4__;
create table analyse_thematique.heat4000_agg4__ as 
select st_buffer(st_buffer(st_buffer(st_simplify(geom,10), 10), -10), 40)geom, dn
FROM analyse_thematique.heat4000_agg4_
;

  drop table if exists analyse_thematique.heat4000_agg5;
create table analyse_thematique.heat4000_agg5 as 
SELECT (ST_UnaryUnion(ST_Collect(geom))) geom,'>=649'::varchar as dn 
  FROM analyse_thematique.heat4000
  where dn >=649
  group by dn;

  drop table if exists analyse_thematique.heat4000_agg5_;
create table analyse_thematique.heat4000_agg5_ as 
SELECT st_union (geom) geom, dn
  FROM analyse_thematique.heat4000_agg5
  group by dn;
  

drop table if exists analyse_thematique.heat4000_agg5__;
create table analyse_thematique.heat4000_agg5__ as 
select st_buffer(st_buffer(st_buffer(st_simplify(geom,10), 10), -10), 40)geom, dn
FROM analyse_thematique.heat4000_agg5_
;

drop table if exists analyse_thematique.heat_4000;
create table analyse_thematique.heat_4000 as 
SELECT geom, dn
	FROM analyse_thematique.heat4000_agg1__
	union all
	SELECT geom, dn
	FROM analyse_thematique.heat4000_agg2__
	union all
	SELECT geom, dn
	FROM analyse_thematique.heat4000_agg3__
	union all
	SELECT geom, dn
	FROM analyse_thematique.heat4000_agg4__
	union all
	SELECT geom, dn
	FROM analyse_thematique.heat4000_agg5__;
	
	drop table if exists analyse_thematique.heat4000_agg1_;
	drop table if exists analyse_thematique.heat4000_agg2_;
	drop table if exists analyse_thematique.heat4000_agg3_;
	drop table if exists analyse_thematique.heat4000_agg4_;
	drop table if exists analyse_thematique.heat4000_agg5_;
	drop table if exists analyse_thematique.heat4000_agg1;
	drop table if exists analyse_thematique.heat4000_agg2;
	drop table if exists analyse_thematique.heat4000_agg3;
	drop table if exists analyse_thematique.heat4000_agg4;
	drop table if exists analyse_thematique.heat4000_agg5;
	drop table if exists analyse_thematique.heat4000_agg1__;
	drop table if exists analyse_thematique.heat4000_agg2__;
	drop table if exists analyse_thematique.heat4000_agg3__;
	drop table if exists analyse_thematique.heat4000_agg4__;
	drop table if exists analyse_thematique.heat4000_agg5__;

--- HEAT 5000

drop table if exists analyse_thematique.heat5000_agg1;
create table analyse_thematique.heat5000_agg1 as 
SELECT (ST_UnaryUnion(ST_Collect(geom))) geom,'0-152'::varchar as dn 
  FROM analyse_thematique.heat5000
  where dn >=0 and dn <=152
  group by dn
;
  
drop table if exists analyse_thematique.heat5000_agg1_;
create table analyse_thematique.heat5000_agg1_ as 
SELECT st_union (geom) geom, dn
  FROM analyse_thematique.heat5000_agg1
  group by dn;
  

drop table if exists analyse_thematique.heat5000_agg1__;
create table analyse_thematique.heat5000_agg1__ as 
select st_buffer(st_buffer(st_buffer(st_simplify(geom,10), 10), -10), 40)geom, dn
FROM analyse_thematique.heat5000_agg1_
;

drop table if exists analyse_thematique.heat5000_agg2;
create table analyse_thematique.heat5000_agg2 as 
SELECT (ST_UnaryUnion(ST_Collect(geom))) geom,'153-310'::varchar as dn 
  FROM analyse_thematique.heat5000
  where dn >=153 and dn <=310
  group by dn;

drop table if exists analyse_thematique.heat5000_agg2_;
create table analyse_thematique.heat5000_agg2_ as 
SELECT st_union (geom) geom, dn
  FROM analyse_thematique.heat5000_agg2
  group by dn;


drop table if exists analyse_thematique.heat5000_agg2__;
create table analyse_thematique.heat5000_agg2__ as 
select st_buffer(st_buffer(st_buffer(st_simplify(geom,10), 10), -10), 40)geom, dn
FROM analyse_thematique.heat5000_agg2_
;

  drop table if exists analyse_thematique.heat5000_agg3;
create table analyse_thematique.heat5000_agg3 as 
SELECT (ST_UnaryUnion(ST_Collect(geom))) geom,'310-550'::varchar as dn 
  FROM analyse_thematique.heat5000
  where dn >=310 and dn <=550
  group by dn;

  drop table if exists analyse_thematique.heat5000_agg3_;
create table analyse_thematique.heat5000_agg3_ as 
SELECT st_union (geom) geom, dn
  FROM analyse_thematique.heat5000_agg3
  group by dn;
  

drop table if exists analyse_thematique.heat5000_agg3__;
create table analyse_thematique.heat5000_agg3__ as 
select st_buffer(st_buffer(st_buffer(st_simplify(geom,10), 10), -10), 40)geom, dn
FROM analyse_thematique.heat5000_agg3_
;
  drop table if exists analyse_thematique.heat5000_agg4;
create table analyse_thematique.heat5000_agg4 as 
SELECT (ST_UnaryUnion(ST_Collect(geom))) geom,'551-935'::varchar as dn 
  FROM analyse_thematique.heat5000
  where dn >=551 and dn <=935
  group by dn;

  drop table if exists analyse_thematique.heat5000_agg4_;
create table analyse_thematique.heat5000_agg4_ as 
SELECT st_union (geom) geom, dn
  FROM analyse_thematique.heat5000_agg4
  group by dn;
  


drop table if exists analyse_thematique.heat5000_agg4__;
create table analyse_thematique.heat5000_agg4__ as 
select st_buffer(st_buffer(st_buffer(st_simplify(geom,10), 10), -10), 40)geom, dn
FROM analyse_thematique.heat5000_agg4_
;

  drop table if exists analyse_thematique.heat5000_agg5;
create table analyse_thematique.heat5000_agg5 as 
SELECT (ST_UnaryUnion(ST_Collect(geom))) geom,'>=936'::varchar as dn 
  FROM analyse_thematique.heat5000
  where dn >=936
  group by dn;

  drop table if exists analyse_thematique.heat5000_agg5_;
create table analyse_thematique.heat5000_agg5_ as 
SELECT st_union (geom) geom, dn
  FROM analyse_thematique.heat5000_agg5
  group by dn;
  

drop table if exists analyse_thematique.heat5000_agg5__;
create table analyse_thematique.heat5000_agg5__ as 
select st_buffer(st_buffer(st_buffer(st_simplify(geom,10), 10), -10), 40)geom, dn
FROM analyse_thematique.heat5000_agg5_
;

drop table if exists analyse_thematique.heat_5000;
create table analyse_thematique.heat_5000 as 
SELECT geom, dn
	FROM analyse_thematique.heat5000_agg1__
	union all
	SELECT geom, dn
	FROM analyse_thematique.heat5000_agg2__
	union all
	SELECT geom, dn
	FROM analyse_thematique.heat5000_agg3__
	union all
	SELECT geom, dn
	FROM analyse_thematique.heat5000_agg4__
	union all
	SELECT geom, dn
	FROM analyse_thematique.heat5000_agg5__;
	
	drop table if exists analyse_thematique.heat5000_agg1_;
	drop table if exists analyse_thematique.heat5000_agg2_;
	drop table if exists analyse_thematique.heat5000_agg3_;
	drop table if exists analyse_thematique.heat5000_agg4_;
	drop table if exists analyse_thematique.heat5000_agg5_;
	drop table if exists analyse_thematique.heat5000_agg1;
	drop table if exists analyse_thematique.heat5000_agg2;
	drop table if exists analyse_thematique.heat5000_agg3;
	drop table if exists analyse_thematique.heat5000_agg4;
	drop table if exists analyse_thematique.heat5000_agg5;
	drop table if exists analyse_thematique.heat5000_agg1__;
	drop table if exists analyse_thematique.heat5000_agg2__;
	drop table if exists analyse_thematique.heat5000_agg3__;
	drop table if exists analyse_thematique.heat5000_agg4__;
	drop table if exists analyse_thematique.heat5000_agg5__;

--- UNION DE TOUTES LES HEAT MAP

drop table if exists analyse_thematique.heatmap;
create table analyse_thematique.heatmap as 
select dn, '500'::varchar as rayon, geom
from analyse_thematique.heat500
union all
select dn, '1000'::varchar as rayon, geom
from analyse_thematique.heat1000
union all
select dn, '1500'::varchar as rayon, geom
from analyse_thematique.heat1500
union all
select dn, '2000'::varchar as rayon, geom
from analyse_thematique.heat2000
union all
select dn, '3000'::varchar as rayon, geom
from analyse_thematique.heat3000
union all
select dn, '4000'::varchar as rayon, geom
from analyse_thematique.heat4000
union all
select dn, '5000'::varchar as rayon, geom
from analyse_thematique.heat5000
;