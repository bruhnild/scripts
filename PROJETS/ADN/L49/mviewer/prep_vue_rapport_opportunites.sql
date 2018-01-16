/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 19/10/2017
Objet : Préparatino des vues pour la génération semi automatisé du rapport bi mensuel L49
Modification : Nom : // - Date : // - Motif/nature : //
-------------------------------------------------------------------------------------
*/


--- Schema : rip1
--- Table : vue_chambres_adn

CREATE OR REPLACE VIEW rip1.vue_chambres_adn AS 
SELECT 
 (CASE 
 WHEN count(DISTINCT (c.id)) IS NULL THEN 0 ELSE count(distinct (c.id)) END) AS nb_chb_exists,
 a.id_opp
 FROM  coordination.opportunite as a
 JOIN  rip1.chambres as c ON ST_intersects (st_buffer(a.geom, 10),c.geom)
 WHERE a.id_opp IS NOT NULL
 GROUP BY  a.id_opp

--- Schema : administratif
--- Table : vue_nb_suf_com

CREATE OR REPLACE VIEW administratif.vue_nb_suf_com AS 
SELECT 
 count(a.id) as nb_suf_com, 
 b.commune
 FROM administratif.adn_suf_majic_2016 as a
 JOIN administratif.communes as b
 ON ST_CONTAINS (b.geom , a.geom)
 WHERE opp is not null 
 group by b.commune;


--- Schema : coordination
--- Vue : vue_rapport_opportunites_synthese

CREATE OR REPLACE VIEW coordination.vue_rapport_opportunites_synthese AS 
SELECT ROW_NUMBER() OVER(ORDER BY id_opp) id, * 
FROM(
SELECT 
a.id_opp, 
a.nom,
a.com_dep,
a.emprise, 
a.travaux, 
a.prev_starr, 
a.cables,
a.typ_cable, 
a.prog_dsp, 
CASE WHEN a.debut_trvx IS NULL THEN 'Inconnue'::character varying ELSE a.debut_trvx END AS debut_trvx,
a.moa, 
d.nb_suf, 
sum(longueur) AS longueur,  
b.nb_chb_exists,
null::int AS nb_chb_a_creer,
null::int as nb_chb_desserte,
null::int as nb_chb_transport,
null::int as nb_chb_indef
FROM coordination.opportunite as a
LEFT JOIN rip1.vue_chambres_adn b ON a.id_opp::text = b.id_opp::text
LEFT JOIN administratif.vue_nb_suf_opp d ON a.id_opp::text = d.id_opp::text
WHERE a.id_opp NOT IN 
 (SELECT 
   a.id_opp
   FROM coordination.opportunite a
   LEFT JOIN rip1.vue_chambres_adn b ON a.id_opp::text = b.id_opp::text
   JOIN coordination.chambres c ON st_dwithin(a.geom, c.geom, 30::double precision)
   LEFT JOIN administratif.vue_nb_suf_opp d ON a.id_opp::text = d.id_opp::text
   WHERE a.id_opp IS NOT NULL
   GROUP BY a.id_opp,a.com_dep,a.emprise, a.travaux, a.prev_starr, a.cables, a.typ_cable, a.prog_dsp, a.debut_trvx, a.moa, d.nb_suf, b.nb_chb_exists
   order by id_opp)
GROUP BY a.id_opp,a.nom, a.com_dep,a.emprise, a.travaux, a.prev_starr, a.cables, a.typ_cable, a.prog_dsp, a.debut_trvx, a.moa, d.nb_suf, b.nb_chb_exists
UNION ALL
SELECT 
a.id_opp,
a.nom,
a.com_dep,
a.emprise,
a.travaux,
a.prev_starr,
a.cables,
a.typ_cable,
a.prog_dsp,
CASE WHEN a.debut_trvx IS NULL THEN 'Inconnue'::character varying ELSE a.debut_trvx END AS debut_trvx,
a.moa,
d.nb_suf,
sum(a.longueur) AS longueur,
b.nb_chb_exists,
count(DISTINCT c.id) AS nb_chb_a_creer,
count(CASE WHEN fonction = 'Desserte' THEN 1 ELSE NULL END) nb_chb_desserte,
count(CASE WHEN fonction = 'Transport' THEN 1 ELSE NULL END) nb_chb_transport,
count(CASE WHEN fonction = 'Indefinie' THEN 1 ELSE NULL END) nb_chb_indef
FROM coordination.opportunite a
LEFT JOIN rip1.vue_chambres_adn b ON a.id_opp::text = b.id_opp::text
JOIN coordination.chambres c ON st_dwithin(a.geom, c.geom, 30::double precision)
LEFT JOIN administratif.vue_nb_suf_opp d ON a.id_opp::text = d.id_opp::text
where a.id_opp like 'OPP_1-8_LT_26301_WDHB_001' or 
a.id_opp like 'OPP_3-XX_LT_07291_WRMZ_001' or 
a.id_opp like 'OPP_4-10_LT_26173_MCHE_001' or 
a.id_opp like 'OPP_4-XX_LT_26381_JLAN_001' 
GROUP BY a.id_opp,a.nom, a.com_dep,a.emprise, a.travaux, a.prev_starr, a.cables, a.typ_cable, a.prog_dsp, a.debut_trvx, a.moa, d.nb_suf, c.fonction, b.nb_chb_exists
order by id_opp)vue ;



--- Schema : coordination
--- Vue : vue_rapport_opportunites_typegc

CREATE OR REPLACE VIEW coordination.vue_rapport_opportunites_typegc AS 
SELECT 
-- informations
row_number() over () AS id,
a.id_opp, 
-- unités d'oeuvre
prev_starr,
lg_prev_st,
gc_typ_mut,
CASE WHEN a.gc_typ_mut IS not null THEN sum(longueur) END AS lg_typ_mut,
gc_typ_int,
CASE WHEN a.gc_typ_int IS not null THEN sum(longueur) END AS lg_typ_int,
sum(longueur) as longueur,
-- couts
a.com_dep
FROM coordination.opportunite as a
LEFT JOIN  rip1.vue_chambres_adn as b on a.id_opp=b.id_opp 
LEFT JOIN  administratif.vue_nb_suf_opp as d on a.id_opp=d.id_opp
where a.id_opp like 'OPP_1-8_LT_26301_WDHB_001' or 
a.id_opp like 'OPP_3-XX_LT_07291_WRMZ_001' or 
a.id_opp like 'OPP_4-22_LT_26173_MCHE_001' or 
a.id_opp like 'OPP_4-XX_LT_26381_JLAN_001' 
group by a.id_opp, com_dep, prev_starr,lg_prev_st, gc_typ_mut, gc_typ_int
order by id_opp
;



--- Schema : coordination
--- Table : vue_bounding_box
CREATE OR REPLACE VIEW coordination.vue_bounding_box AS 
SELECT id_opp, ST_Extent(geom) AS bounding_box , ST_SetSRID(ST_Extent(geom),2154) as geom
FROM coordination.opportunite as a
group by id_opp
;

--- Schema : coordination
--- Table : vue_bounding_box

CREATE OR REPLACE VIEW administratif.vue_nb_suf_opp AS 
SELECT row_number() over () AS id, count(distinct (a.id)) as nb_suf , id_opp, ST_Extent(b.geom) AS bounding_box , ST_SetSRID(ST_Extent(b.geom),2154) as geom
FROM administratif.adn_suf_majic_2016 as a, coordination.vue_bounding_box as b 
WHERE st_contains (b.geom, a.geom)
GROUP BY id_opp
;


CREATE OR REPLACE VIEW administratif.vue_nb_suf_opp AS 
SELECT row_number() over () AS id, count(distinct (a.id)) as nb_suf , id_opp, ST_Extent(b.geom) AS bounding_box , ST_SetSRID(ST_Extent(b.geom),2154) as geom
FROM administratif.adn_suf_majic_2016 as a, coordination.vue_bounding_box as b 
WHERE st_contains (b.geom, a.geom)
GROUP BY id_opp
;

CREATE OR REPLACE VIEW administratif.vue_nb_suf_opp2 AS 
SELECT row_number() over () AS id, id_opp, b.commune, ST_Extent(a.geom) AS bounding_box , ST_SetSRID(ST_Extent(a.geom),2154) as geom
FROM coordination.opportunite_rapport as a
JOIN administratif.communes as b 
ON ST_INTERSECTS (a.geom, b.geom)
group by id_opp, commune
order by id_opp
;

--------------------------------------------------------------------------------------------------------

--- Schema : rapport
--- Table : opportunites_synthese


drop table if exists rapport.opportunites_synthese;
create table rapport.opportunites_synthese as
SELECT ROW_NUMBER() OVER(ORDER BY id_opp) id, * 
FROM(
SELECT 
a.id_opp, 
a.nom,
a.com_dep,
a.emprise, 
a.travaux, 
a.prev_starr, 
a.cables,
a.typ_cable, 
a.prog_dsp, 
CASE WHEN a.debut_trvx IS NULL THEN 'Inconnue'::character varying ELSE a.debut_trvx END AS debut_trvx,
a.moa, 
d.nb_suf, 
sum(longueur) AS longueur,  
b.nb_chb_exists,
null::int AS nb_chb_a_creer,
null::int as nb_chb_desserte,
null::int as nb_chb_transport,
null::int as nb_chb_indef
FROM coordination.opportunite as a
LEFT JOIN rip1.vue_chambres_adn b ON a.id_opp::text = b.id_opp::text
LEFT JOIN administratif.vue_nb_suf_opp d ON a.id_opp::text = d.id_opp::text
WHERE a.id_opp NOT IN 
 (SELECT 
   a.id_opp
   FROM coordination.opportunite a
   LEFT JOIN rip1.vue_chambres_adn b ON a.id_opp::text = b.id_opp::text
   JOIN coordination.chambres c ON st_dwithin(a.geom, c.geom, 30::double precision)
   LEFT JOIN administratif.vue_nb_suf_opp d ON a.id_opp::text = d.id_opp::text
   WHERE a.id_opp IS NOT NULL
   GROUP BY a.id_opp,a.com_dep,a.emprise, a.travaux, a.prev_starr, a.cables, a.typ_cable, a.prog_dsp, a.debut_trvx, a.moa, d.nb_suf, b.nb_chb_exists
   order by id_opp)
GROUP BY a.id_opp,a.nom, a.com_dep,a.emprise, a.travaux, a.prev_starr, a.cables, a.typ_cable, a.prog_dsp, a.debut_trvx, a.moa, d.nb_suf, b.nb_chb_exists
UNION ALL
SELECT 
a.id_opp,
a.nom,
a.com_dep,
a.emprise,
a.travaux,
a.prev_starr,
a.cables,
a.typ_cable,
a.prog_dsp,
CASE WHEN a.debut_trvx IS NULL THEN 'Inconnue'::character varying ELSE a.debut_trvx END AS debut_trvx,
a.moa,
d.nb_suf,
sum(a.longueur) AS longueur,
b.nb_chb_exists,
count(DISTINCT c.id) AS nb_chb_a_creer,
count(CASE WHEN fonction = 'Desserte' THEN 1 ELSE NULL END) nb_chb_desserte,
count(CASE WHEN fonction = 'Transport' THEN 1 ELSE NULL END) nb_chb_transport,
count(CASE WHEN fonction = 'Indefinie' THEN 1 ELSE NULL END) nb_chb_indef
FROM coordination.opportunite a
LEFT JOIN rip1.vue_chambres_adn b ON a.id_opp::text = b.id_opp::text
JOIN coordination.chambres c ON st_dwithin(a.geom, c.geom, 30::double precision)
LEFT JOIN administratif.vue_nb_suf_opp d ON a.id_opp::text = d.id_opp::text
where a.id_opp like 'OPP_1-8_LT_26301_WDHB_001' or 
a.id_opp like 'OPP_3-XX_LT_07291_WRMZ_001' or 
a.id_opp like 'OPP_4-10_LT_26173_MCHE_001' or 
a.id_opp like 'OPP_4-XX_LT_26381_JLAN_001' 
GROUP BY a.id_opp,a.nom, a.com_dep,a.emprise, a.travaux, a.prev_starr, a.cables, a.typ_cable, a.prog_dsp, a.debut_trvx, a.moa, d.nb_suf, c.fonction, b.nb_chb_exists
order by id_opp)vue ;


ALTER TABLE rapport.opportunites_synthese ADD PRIMARY KEY (id);

--- Schema : rapport
--- Table : opportunites_typegc
DROP TABLE IF EXISTS rapport.opportunites_typegc;
CREATE TABLE rapport.opportunites_typegc as 
SELECT 
-- informations
row_number() over () AS id,
a.id_opp, 
-- unités d'oeuvre
prev_starr,
lg_prev_st,
gc_typ_mut,
CASE WHEN a.gc_typ_mut IS not null THEN sum(longueur) END AS lg_typ_mut,
gc_typ_int,
CASE WHEN a.gc_typ_int IS not null THEN sum(longueur) END AS lg_typ_int,
sum(longueur) as longueur,
-- couts
a.com_dep
FROM coordination.opportunite as a
LEFT JOIN  rip1.vue_chambres_adn as b on a.id_opp=b.id_opp 
LEFT JOIN  administratif.vue_nb_suf_opp as d on a.id_opp=d.id_opp
where a.id_opp like 'OPP_1-8_LT_26301_WDHB_001' or 
a.id_opp like 'OPP_3-XX_LT_07291_WRMZ_001' or 
a.id_opp like 'OPP_4-22_LT_26173_MCHE_001' or 
a.id_opp like 'OPP_4-XX_LT_26381_JLAN_001' 
group by a.id_opp, com_dep, prev_starr,lg_prev_st, gc_typ_mut, gc_typ_int
order by id_opp
;


ALTER TABLE rapport.opportunites_typegc ADD PRIMARY KEY (id);


