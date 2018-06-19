--- calcul de la surface réelle par locaux

drop table if exists pci70_majic_analyses.usage_surf_princip ; 
create table pci70_majic_analyses.usage_surf_princip as 
SELECT 
a.pev, 
(a.dep1_dsueic+ a.dep2_dsueic+a.dep3_dsueic+a.dep4_dsueic+a.dsupdc) as surf_princip, 
'usage_surf_dep_princip'::varchar  as champs
from pci70_edigeo_majic.pevprincipale as a ;

drop table if exists pci70_majic_analyses.usage_surf_dep ; 
create table pci70_majic_analyses.usage_surf_dep as 
SELECT pev, sum(dsudep) as surf_dep, 'usage_surf_dep_princip'::varchar  as champs
from pci70_edigeo_majic.pevdependances
group by pev;

drop table if exists pci70_majic_analyses.usage_surf_dep_princip ; 
create table pci70_majic_analyses.usage_surf_dep_princip as 
SELECT a.pev, a.surf_princip+ surf_dep as surf_dep_princip, 'usage_surf_dep_princip'::varchar  as champs
from pci70_majic_analyses.usage_surf_princip as a 
left join pci70_majic_analyses.usage_surf_dep as b on a.pev=b.pev
where surf_dep is not null ;


drop table if exists pci70_majic_analyses.usage_surf_dep_princip_left;
create table pci70_majic_analyses.usage_surf_dep_princip_left as 
SELECT 
distinct on (hp.pev) pev, hp.surf_princip,  'majic_sete.usage_surf_dep_princip_left'::varchar as champs
FROM
pci70_majic_analyses.usage_surf_princip as hp
WHERE
  hp.pev NOT IN 
  (
    SELECT 
      h.pev
    FROM 
       pci70_majic_analyses.usage_surf_dep_princip  as p,
      pci70_majic_analyses.usage_surf_princip as h
    WHERE 
     h.pev = p.pev
  ) ;
  
  
  
drop table if exists pci70_majic_analyses.usage_surf_dep_princi_pro;
create table pci70_majic_analyses.usage_surf_dep_princi_pro as 
select pev, surf_dep_princip as usage_surf_dep_princip_pro, champs
from pci70_majic_analyses.usage_surf_dep_princip
union all
select pev, surf_princip as usage_surf_dep_princip_pro, champs
from pci70_majic_analyses.usage_surf_dep_princip_left
union all
select pev, vsurzt as usage_surf_dep_princip_pro, 'pev_pro'::varchar as champs
from pci70_edigeo_majic.pevprofessionnelle;

--- Récupère tous les attributs nécessaires au local (code nature du local, type de local, code naf du local, nombre de niveau, surface pondérée )
--- condition : le champ cconac n'est pas null 

drop table if exists pci70_majic_analyses.usage_local110_pev01_cconac;
create table pci70_majic_analyses.usage_local110_pev01_cconac as 
SELECT distinct on (a.local10)a.local10 , a.parcelle, a.ccodep, a.ccodir, a.ccocom, a.invar, 
 a.dnupro, dnatpr, ccogrm, dteloc,cconlc, cconad, ccoaff, cconac,jannat, 
       dnbniv, b.dsupot, usage_surf_dep_princip_pro
  FROM pci70_edigeo_majic.local10 as a
  left join pci70_edigeo_majic.pev as b on a.local10=b.local10
  left join pci70_edigeo_majic.pevdependances as c on b.pev= c.pev
  left join pci70_edigeo_majic.proprietaire as d on a.dnupro= d.dnupro
  left join pci70_majic_analyses.usage_surf_dep_princi_pro as e on b.pev = e.pev
  where cconac is not null ;


--- supprimer code cconac non valides ou obsolètes
  
DELETE FROM pci70_majic_analyses.usage_local110_pev01_cconac o
USING (
    SELECT o2.cconac
    FROM pci70_majic_analyses.usage_local110_pev01_cconac o2
    LEFT JOIN pci70_majic_analyses.mappingnaf732usagen234 t ON t.a732 = o2.cconac
    WHERE t.a732 IS NULL
    ) sq
WHERE sq.cconac = o.cconac
    ;

--- mapping

ALTER TABLE pci70_majic_analyses.usage_local110_pev01_cconac ALTER COLUMN cconac TYPE varchar (254) USING (cconac::varchar);

UPDATE pci70_majic_analyses.usage_local110_pev01_cconac  as a 
SET cconac = b.name_a732
FROM pci70_majic_analyses.mappingnaf732usagen234 as b 
WHERE a.cconac=b.a732;

---- nombre d'usages différents par parcelle (ex: 8 activités industrielles/5 activités commerciales pour la parcelle xx)

drop table if exists pci70_majic_analyses.usage_local110_pev01_cconac_count;
create table pci70_majic_analyses.usage_local110_pev01_cconac_count as 
SELECT parcelle, cconac, count(cconac) count_cconac, sum(dsupot) as sum_dsupot, sum(usage_surf_dep_princip_pro) as sum_surface
FROM pci70_majic_analyses.usage_local110_pev01_cconac
group by parcelle, cconac
order by count_cconac desc;    

---somme totale des usages par parcelle

drop table if exists pci70_majic_analyses.usage_local110_pev01_cconac_count_sum;
create table pci70_majic_analyses.usage_local110_pev01_cconac_count_sum as 
SELECT parcelle, sum(count_cconac) as nb_cconac_parcelle
FROM pci70_majic_analyses.usage_local110_pev01_cconac_count
group by parcelle;


---- part de chaque usage par parcelle

drop table if exists pci70_majic_analyses.usage_local110_pev01_cconac_count_sum_final;
create table pci70_majic_analyses.usage_local110_pev01_cconac_count_sum_final as 
SELECT a.parcelle, cconac, count_cconac, nb_cconac_parcelle, round((count_cconac*100/nb_cconac_parcelle),0) as cconac_pct, a.sum_dsupot, a.sum_surface, c.geom
FROM pci70_majic_analyses.usage_local110_pev01_cconac_count as a
left join pci70_majic_analyses.usage_local110_pev01_cconac_count_sum as b on a.parcelle = b.parcelle
left join pci70_edigeo_majic.geo_parcelle as c on a.parcelle=c.geo_parcelle
order by cconac_pct;


  ALTER TABLE pci70_majic_analyses.usage_local110_pev01_cconac ADD COLUMN gid SERIAL PRIMARY KEY;