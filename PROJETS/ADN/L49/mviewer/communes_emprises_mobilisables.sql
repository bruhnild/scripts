drop table if exists administratif.communes_priorite;
create table administratif.communes_priorite as 
select commune, priorite1::int as priorite, '1'::varchar as numero
from administratif.communes_priorite1
union all
select commune, priorite2::int, '2'::varchar as numero
from administratif.communes_priorite2
union all
select commune, priorite3::int, '3'::varchar as numero
from administratif.communes_priorite3;

drop table if exists administratif.communes_priorite_num;
create table administratif.communes_priorite_num as 
select commune, max(priorite) as priorite
from administratif.communes_priorite
group by commune

ALTER TABLE administratif.communes_priorite_num  add COLUMN  numero   character varying;

UPDATE administratif.communes_priorite_num as a 
SET numero = b.numero
FROM administratif.communes_priorite as b 
WHERE a.commune=b.commune and a.priorite=b.priorite

ALTER TABLE administratif.communes  add COLUMN  num_priorite   character varying;

UPDATE administratif.communes as a 
SET num_priorite = b.numero
FROM administratif.communes_priorite_num  as b 
WHERE a.commune=b.commune ;

DROP TABLE IF EXISTS administratif.communes_priorite1;
DROP TABLE IF EXISTS administratif.communes_priorite2;
DROP TABLE IF EXISTS administratif.communes_priorite3;
DROP TABLE IF EXISTS administratif.communes_priorite_num;
DROP TABLE IF EXISTS administratif.communes_priorite;
DROP TABLE IF EXISTS administratif.communes_emprise;
DROP TABLE IF EXISTS administratif.communes_centroides;



ALTER TABLE analyse_thematique.emprises_mobilisables_26_07  add COLUMN  commune   character varying;


UPDATE analyse_thematique.emprises_mobilisables_26_07 as a 
SET commune = b.commune
FROM administratif.communes  as b 
WHERE st_contains (b.geom, a.geom)





