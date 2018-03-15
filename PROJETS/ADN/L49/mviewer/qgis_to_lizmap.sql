/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 12/10/2017
Objet : Structuration des tables/vues du projet L49
Modification : Nom : // - Date : // - Motif/nature : //
-------------------------------------------------------------------------------------
*/


--************* Création de vues pour alléger le projet Qgis **************

--- Schema : administratif
--- Table : commune

CREATE OR REPLACE VIEW administratif.vue_communes AS
SELECT *
FROM administratif.communes
WHERE communes.opp IS NOT NULL;


--- Schema : administratif
--- Table : vue_adn_suf_majic_2016

  -- Remplir le champ nom_sro dans la table
ALTER TABLE administratif.adn_suf_majic_2016 ALTER COLUMN nom_sro TYPE varchar (14) USING (nom_sro::varchar);
UPDATE administratif.adn_suf_majic_2016 as a 
SET nom_sro = b.msro_ref
FROM rip2.adn_zsro as b 


CREATE OR REPLACE VIEW administratif.vue_adn_suf_majic_2016 AS SELECT 
 a.id, 
 a.geom, 
 lieu_dit, 
 adresse, 
 adr_compl, 
 cod_post, 
 insee, 
 a.commune, 
 id_parc, 
 nb_coll, 
 nb_indiv, 
 nb_prof, 
 nb_total, 
 nom_sro, 
 nom_zsro, 
 nature, 
 type, 
 nb_tech, 
 supp_tech, 
 haut_tech, 
 proprio, 
 siret, 
 raison_soc, 
 effectif, 
 naf, 
 sect_activ, 
 dcren, 
 longitude, 
 latitude, 
 "position", 
 x_bati, 
 y_bati, 
 cod_geoc
 FROM administratif.adn_suf_majic_2016 as a
 JOIN  administratif.communes as b
 ON ST_CONTAINS (b.geom , a.geom)
 WHERE b.opp is not null;



--- Schema : coordination
--- Table : chambres

CREATE OR REPLACE VIEW coordination.vue_chambres AS 
SELECT 
 a.id, 
 a.geom, 
 id_opp,
 comment,
 fonction
 FROM coordination.chambres as a
 JOIN  administratif.communes as b
 ON ST_CONTAINS (b.geom , a.geom)
 WHERE b.opp is not null;


-- Schema : coordination
-- Vue : vue_numerisation

CREATE OR REPLACE VIEW coordination.vue_numerisation AS 
SELECT 
 row_number() OVER () AS id,
id_opp, 
lot, 
id_prog, 
id_nro, 
id_reseau, 
statut, 
phase, 
emprise, 
nom, 
support, 
travaux,  
sum(longueur) as longueur, 
debut_trvx, 
prog_dsp, 
moa, 
cdd, 
commentair, 
envoi_moe,
St_linemerge(ST_Union(geom))  as geom
FROM coordination.numerisation
group by 
 id_opp, 
 lot, 
 id_prog, 
 id_nro, 
 id_reseau,
 statut, 
 phase, 
 emprise, 
 nom, 
 support, 
 travaux,  
 debut_trvx, 
 prog_dsp, 
 moa, 
 cdd, 
 commentair,
 envoi_moe
 order by id_opp
;


-- Schema : coordination
-- Vue : vue_numerisation_abandon

CREATE OR REPLACE VIEW coordination.vue_numerisation_abandon AS 
 SELECT   
 row_number() OVER () AS id,
 id_opp, 
 lot, 
 id_prog, 
 id_nro, 
 id_reseau,
 statut, 
 phase, 
 emprise, 
 nom, 
 support, 
 travaux,  
 sum(longueur) as longueur, 
 debut_trvx, 
 prog_dsp, 
 moa, 
 cdd, 
 commentaire, 
 St_linemerge(ST_Union(geom))  as geom
 FROM coordination.numerisation
  WHERE statut like 'Abandonné'
 group by 
 id_opp, 
 lot, 
 id_prog, 
 id_nro, 
 id_reseau,
 statut, 
 phase, 
 emprise, 
 nom, 
 support, 
 travaux,  
 debut_trvx, 
 prog_dsp, 
 moa, 
 cdd, 
 commentaire
 order by id_opp
;

-- Schema : coordination
-- Vue : vue_opportunite
CREATE OR REPLACE VIEW coordination.vue_opportunite AS 
SELECT id_opp, lot, cdd, id_prog, id_nro, id_reseau, insee, com_dep, 
       emprise, nom, travaux, support, typ_reseau, cables, typ_cable, 
       fibres, prev_starr, lg_prev_st, gc_typ_mut, gc_typ_int, sum(longueur) AS longueur, 
       debut_trvx, prog_dsp, moa, moe, moe_bpe, ent_tvx, commentair, 
       statut, st_linemerge(st_union(geom))
  FROM coordination.opportunite
  
  GROUP BY id_opp, cdd, lot, id_prog, id_nro, id_reseau, insee, com_dep, emprise, nom, travaux, support, typ_reseau, cables,typ_cable,fibres, prev_starr, lg_prev_st, gc_typ_mut, gc_typ_int, debut_trvx, prog_dsp, moa, moe,  moe_bpe, ent_tvx, commentair, statut
  ORDER BY id_opp;
-- Schema : coordination
-- Vue : vue_opportunite_abandonné

CREATE OR REPLACE VIEW coordination.vue_opportunite_abandon AS 

SELECT id_opp, lot, cdd, id_prog, id_nro, id_reseau, insee, com_dep, 
       emprise, nom, travaux, support, typ_reseau, cables, typ_cable, 
       fibres, prev_starr, lg_prev_st, gc_typ_mut, gc_typ_int, sum(longueur) AS longueur, 
       debut_trvx, prog_dsp, moa, moe, moe_bpe, ent_tvx, commentair, 
       statut, st_linemerge(st_union(geom))
  FROM coordination.opportunite
  WHERE statut like 'Abandonné'
  GROUP BY id_opp, cdd, lot, id_prog, id_nro, id_reseau, insee, com_dep, emprise, nom, travaux, support, typ_reseau, cables,typ_cable,fibres, prev_starr, lg_prev_st, gc_typ_mut, gc_typ_int, debut_trvx, prog_dsp, moa, moe,  moe_bpe, ent_tvx, commentair, statut
  ORDER BY id_opp;


--- Schema : orange
--- Table : vue_arciti

CREATE OR REPLACE VIEW orange.vue_arciti AS 
SELECT 
 a.id, 
 a.geom, 
 statut, 
 mode_pose, 
 aut_passag, 
 aut_pass_1, 
 nature_con, 
 type_longu, 
 longueur, 
 note, 
 compositio, 
 id_proprie, 
 index_doc_, 
 enabled, 
 origine, 
 label_cabl, 
 nb_cable, 
 shape_len, 
 classe
 FROM orange.arc_iti as a
 JOIN  administratif.communes as b
 ON ST_CONTAINS (b.geom , a.geom)
 WHERE b.opp is not null;



--- Schema : orange
--- Table : chambres

CREATE OR REPLACE VIEW orange.vue_chambres AS 
SELECT 
 a.id, 
 a.geom, 
 statut, 
 implant, 
 nature_cha, 
 ref_chambr, 
 ref_note, 
 code_com, 
 code_voie, 
 num_voie, 
 id_proprie, 
 type_trapp, 
 quantifica, 
 a.rotation, 
 code_ch1, 
 code_ch2, 
 note, 
 securisee, 
 cle_mkt1, 
 cle_mkt2, 
 code_ch1_c, 
 code_ch2_p, 
 classe, 
 id_gestion, 
 id_noeud, 
 index_doc_, 
 ventil, 
 plafon, 
 acc_deport, 
 attente
 FROM orange.chambres as a
 JOIN  administratif.communes as b
 ON ST_CONTAINS (b.geom , a.geom)
 WHERE b.opp is not null;


--- Schema : rip1
--- Table : vue_adr_shl

CREATE OR REPLACE VIEW rip1.vue_adr_shl AS 
SELECT 
 a.id, 
 a.geom, 
 objectid, 
 datecree, 
 fabrique, 
 modele, 
 reference, 
 user_ref, 
 soustype, 
 address, 
 location, 
 codeinsee, 
 statut, 
 proprio, 
 imputation, 
 code_site, 
 gpscoord1, 
 gpscoord2
 FROM rip1.adr_shl as a
 JOIN  administratif.communes as b
 ON ST_CONTAINS (b.geom , a.geom)
 WHERE b.opp is not null;

--- Schema : rip1
--- Table : cables

CREATE OR REPLACE VIEW rip1.vue_cables AS 
SELECT 
 a.id, 
 a.geom, 
 objectid, 
 datecree, 
 fabrique, 
 equipement, 
 modele, 
 diametre, 
 reference, 
 user_ref, 
 nbr_tubes, 
 nbr_fibres, 
 soustype, 
 statut, 
 proprio, 
 imputation, 
 code_site, 
 libres, 
 saturation, 
 longueur, 
 usage
 FROM rip1.cables as a
 JOIN  administratif.communes as b
 ON ST_CONTAINS (b.geom , a.geom)
 WHERE b.opp is not null;

--- Schema : rip1
--- Table : chambres

CREATE OR REPLACE VIEW rip1.vue_chambres AS
SELECT 
 a.id, 
 a.geom, 
 objectid, 
 datecree, 
 equipement, 
 modele, 
 reference, 
 user_ref, 
 address, 
 location, 
 codeinsee, 
 code_site, 
 statut, 
 proprio, 
 imputation, 
 coordx, 
 coordy, 
 comment_ad
 FROM rip1.chambres as a
 JOIN  administratif.communes as b
 ON ST_CONTAINS (b.geom , a.geom)
 WHERE b.opp is not null;


--- Schema : rip1
--- Table : souterrain

CREATE OR REPLACE VIEW rip1.vue_souterrain AS 
SELECT 
 a.id, 
 a.geom, 
 objectid, 
 datecree, 
 location, 
 equipement, 
 modele, 
 reference, 
 user_ref, 
 fourreaux, 
 soustype, 
 statut, 
 proprio, 
 imputation, 
 code_site, 
 emprise, 
 longueur, 
 noeud_a_x, 
 usage, 
 long_adn
 FROM rip1.souterrain as a
 JOIN  administratif.communes as b
 ON ST_CONTAINS (b.geom , a.geom)
 WHERE b.opp is not null;

--- Schema : erdf
--- Table : vue_appareil_coupure_aerien_hta_me_position_07

CREATE OR REPLACE VIEW erdf.vue_appareil_coupure_aerien_hta_me_position_07 AS 
SELECT 
 a.id,
 a.geom, 
 "t�l�comman" as telecomman, 
 automatism, 
 automati1, 
 automati2, 
 code_insee, 
 code_relai, 
 "libell�_co" as libelle_co, 
 "libell�_1" as libelle_1
 FROM erdf.appareil_coupure_aerien_hta_me_position_07 as a
 JOIN  administratif.communes as b
 ON ST_CONTAINS (b.geom , a.geom)
 WHERE b.opp is not null;


--- Schema : erdf
--- Table : vue_appareil_coupure_aerien_hta_me_position_26

CREATE OR REPLACE VIEW erdf.vue_appareil_coupure_aerien_hta_me_position_26 AS 
SELECT 
 a.id,
 a.geom, 
 "t�l�comman" as telecomman, 
 automatism, 
 automati1, 
 automati2, 
 code_insee, 
 code_relai, 
 "libell�_co" as libelle_co, 
 "libell�_1" as libelle_1
 FROM erdf.appareil_coupure_aerien_hta_me_position_26 as a
 JOIN  administratif.communes as b
 ON ST_CONTAINS (b.geom , a.geom)
 WHERE b.opp is not null;

 --- Schema : erdf
--- Table : vue_poste_elec_me_position_07

CREATE OR REPLACE VIEW erdf.vue_poste_elec_me_position_07 AS 
SELECT 
 a.id, 
 a.geom, 
 nom_du_pos, 
 fonction_p, 
 e_commune_, 
 code_relai, 
 "libell�_co" as libelle_co, 
 "libell�_1" as libelle
 FROM erdf.poste_elec_me_position_07 as a
 JOIN  administratif.communes as b
 ON ST_CONTAINS (b.geom , a.geom)
 WHERE b.opp is not null;

 --- Schema : erdf
--- Table : vue_poste_elec_me_position_26

CREATE OR REPLACE VIEW erdf.vue_poste_elec_me_position_26 AS 
SELECT 
 a.id, 
 a.geom, 
 nom_du_pos, 
 fonction_p, 
 e_commune_, 
 code_relai, 
 "libell�_co" as libelle_co, 
 "libell�_1" as libelle
 FROM erdf.poste_elec_me_position_26 as a
 JOIN  administratif.communes as b
 ON ST_CONTAINS (b.geom , a.geom)
 WHERE b.opp is not null;

  --- Schema : erdf
--- Table : vue_troncon_aerien_bt_nu_07

CREATE OR REPLACE VIEW erdf.vue_troncon_aerien_bt_nu_07 AS 
SELECT 
 a.id, 
 a.geom, 
 code_insee, 
 nom_commun, 
 code_relai, 
 "libell�_co" as libelle_co, 
 type_de_li, 
 "d�signatio" as designation
 FROM erdf.troncon_aerien_bt_nu_07 as a
 JOIN  administratif.communes as b
 ON ST_CONTAINS (b.geom , a.geom)
 WHERE b.opp is not null;

 --- Schema : erdf
--- Table : vue_troncon_aerien_bt_nu_26

CREATE OR REPLACE VIEW erdf.vue_troncon_aerien_bt_nu_26 AS 
SELECT 
 a.id, 
 a.geom, 
 code_insee, 
 nom_commun, 
 code_relai, 
 "libell�_co" as libelle_co, 
 type_de_li, 
 "d�signatio" as designation
 FROM erdf.troncon_aerien_bt_nu_26 as a
 JOIN  administratif.communes as b
 ON ST_CONTAINS (b.geom , a.geom)
 WHERE b.opp is not null;

 --- Schema : erdf
--- Table : vue_troncon_aerien_bt_torsade_07

CREATE OR REPLACE VIEW erdf.vue_troncon_aerien_bt_torsade_07 AS 
SELECT 
 a.id, 
 a.geom, 
 code_insee, 
 nom_commun, 
 code_relai, 
 "libell�_co" as libelle_co, 
 type_de_li, 
 "d�signatio" as designatio
 FROM erdf.troncon_aerien_bt_torsade_07 as a
 JOIN  administratif.communes as b
 ON ST_CONTAINS (b.geom , a.geom)
 WHERE b.opp is not null;

  --- Schema : erdf
--- Table : vue_troncon_aerien_bt_torsade_26

CREATE OR REPLACE VIEW erdf.vue_troncon_aerien_bt_torsade_26 AS 
SELECT 
 a.id, 
 a.geom, 
 code_insee, 
 nom_commun, 
 code_relai, 
 "libell�_co" as libelle_co, 
 type_de_li, 
 "d�signatio" as designatio
 FROM erdf.troncon_aerien_bt_torsade_26 as a
 JOIN  administratif.communes as b
 ON ST_CONTAINS (b.geom , a.geom)
 WHERE b.opp is not null;

  --- Schema : erdf
--- Table : vue_troncon_aerien_hta_nu_07

CREATE OR REPLACE VIEW erdf.vue_troncon_aerien_hta_nu_07 AS 
SELECT 
 a.id, 
 a.geom, 
 code_insee, 
 nom_commun, 
 code_relai, 
 "libell�_co" as libelle_co, 
 type_de_li, 
 "d�signatio" as designatio
 FROM erdf.troncon_aerien_hta_nu_07 as a
 JOIN  administratif.communes as b
 ON ST_CONTAINS (b.geom , a.geom)
 WHERE b.opp is not null;

  --- Schema : erdf
--- Table : vue_troncon_aerien_hta_nu_26

CREATE OR REPLACE VIEW erdf.vue_troncon_aerien_hta_nu_26 AS 
SELECT 
 a.id, 
 a.geom, 
 code_insee, 
 nom_commun, 
 code_relai, 
 "libell�_co" as libelle_co, 
 type_de_li, 
 "d�signatio" as designatio
 FROM erdf.troncon_aerien_hta_nu_26 as a
 JOIN  administratif.communes as b
 ON ST_CONTAINS (b.geom , a.geom)
 WHERE b.opp is not null;

  --- Schema : erdf
--- Table : vue_troncon_aerien_hta_torsade_07

CREATE OR REPLACE VIEW erdf.vue_troncon_aerien_hta_torsade_07 AS 
SELECT 
 a.id, 
 a.geom, 
 code_insee, 
 nom_commun, 
 code_relai, 
 "libell�_co" as libelle_co, 
 type_de_li, 
 "d�signatio" as designatio
 FROM erdf.troncon_aerien_hta_torsade_07 as a
 JOIN  administratif.communes as b
 ON ST_CONTAINS (b.geom , a.geom)
 WHERE b.opp is not null;

  --- Schema : erdf
--- Table : vue_troncon_aerien_hta_torsade_26

CREATE OR REPLACE VIEW erdf.vue_troncon_aerien_hta_torsade_26 AS 
SELECT 
 a.id, 
 a.geom, 
 code_insee, 
 nom_commun, 
 code_relai, 
 "libell�_co" as libelle_co, 
 type_de_li, 
 "d�signatio" as designatio
 FROM erdf.troncon_aerien_hta_torsade_26 as a
 JOIN  administratif.communes as b
 ON ST_CONTAINS (b.geom , a.geom)
 WHERE b.opp is not null;

  --- Schema : erdf
--- Table : troncon_aerien_bt

drop table if exists erdf.troncon_aerien_bt;
create table erdf.troncon_aerien_bt as 
SELECT id, geom, code_insee, nom_commun, code_relai, libelle_co, type_de_li, 
       designatio, 'Aérien BT nu'::varchar as nature, 'BT'::varchar as type_tr
  FROM erdf.troncon_aerien_bt_nu_07
  union all 
SELECT id, geom, code_insee, nom_commun, code_relai, libelle_co, type_de_li, 
       designatio, 'Aérien BT nu'::varchar as nature,'BT'::varchar as type_tr
  FROM erdf.troncon_aerien_bt_nu_26
  union all
  SELECT id, geom, code_insee, nom_commun, code_relai, libelle_co, type_de_li, 
       designatio, 'Aérien BT torsadé'::varchar as nature, 'BT'::varchar as type_tr
  FROM erdf.troncon_aerien_bt_torsade_07
  union all
    SELECT id, geom, code_insee, nom_commun, code_relai, libelle_co, type_de_li, 
       designatio, 'Aérien BT torsadé'::varchar as nature, 'BT'::varchar as type_tr
  FROM erdf.troncon_aerien_bt_torsade_26;

  --- Schema : erdf
--- Table : troncon_aerien_bt

drop table if exists erdf.troncon_aerien_hta;
create table erdf.troncon_aerien_hta as 

SELECT id, geom, code_insee, nom_commun, code_relai, libelle_co, type_de_li, 
       designatio, 'Aérien HTA nu'::varchar as nature, 'HTA'::varchar as type_tr
  FROM erdf.troncon_aerien_hta_nu_07
  union all 
SELECT id, geom, code_insee, nom_commun, code_relai, libelle_co, type_de_li, 
       designatio, 'Aérien HTA nu'::varchar as nature,'HTA'::varchar as type_tr
  FROM erdf.troncon_aerien_hta_nu_26
  union all
  SELECT id, geom, code_insee, nom_commun, code_relai, libelle_co, type_de_li, 
       designatio, 'Aérien HTA torsadé'::varchar as nature,'HTA'::varchar as type_tr
  FROM erdf.troncon_aerien_hta_torsade_07
  union all
    SELECT id, geom, code_insee, nom_commun, code_relai, libelle_co, type_de_li, 
       designatio, 'Aérien HTA torsadé'::varchar as nature,'HTA'::varchar as type_tr
  FROM erdf.troncon_aerien_hta_torsade_26;

  --- Schema : erdf
--- Table : vue_troncon_aerien_bt

  CREATE OR REPLACE VIEW erdf.vue_troncon_aerien_bt AS 
SELECT a.id,
    a.geom,
    a.code_insee,
    a.nom_commun,
    a.code_relai,
    a.libelle_co,
    a.type_de_li,
    a.nature,
    a.type_tr,
    a.designatio AS designation
   FROM erdf.troncon_aerien_bt a
     JOIN administratif.communes b ON st_contains(b.geom, a.geom)
  WHERE b.opp IS NOT NULL;

  --- Schema : erdf
--- Table : vue_troncon_aerien_hta

  CREATE OR REPLACE VIEW erdf.vue_troncon_aerien_hta AS 
SELECT a.id,
    a.geom,
    a.code_insee,
    a.nom_commun,
    a.code_relai,
    a.libelle_co,
    a.type_de_li,
    a.nature,
    a.type_tr,
    a.designatio AS designation
   FROM erdf.troncon_aerien_hta a
     JOIN administratif.communes b ON st_contains(b.geom, a.geom)
  WHERE b.opp IS NOT NULL;

--- Schema : rip2
--- Table : vue_starr_transport

CREATE OR REPLACE VIEW rip2.vue_starr_transport AS 
SELECT 
 ogc_fid, 
 id_reseau, 
 id_element, 
 rang_opt, 
 niveau, 
 segment, 
 support, 
 nom, 
 cle_ext, 
 sites, 
 prises, 
 fibres, 
 fibres_p2p, 
 fibres_pon, 
 fibres_res, 
 cables, 
 longueur, 
 cout, 
 id_nod_pri, 
 id_nod_sup, 
 nom_nro, 
 ancien_nom, 
 a.geom
 FROM rip2.starr_transport as a 
 JOIN  administratif.communes as b
 ON ST_CONTAINS (b.geom , a.geom)
 WHERE b.opp is not null;


--- Schema : rip2
--- Table : vue_starr_liens
CREATE OR REPLACE VIEW rip2.vue_starr_liens AS 
SELECT 
 ogc_fid, 
 id_reseau, 
 id_element, 
 rang_opt, 
 niveau, 
 segment, 
 support, 
 nom, 
 cle_ext, 
 sites, 
 prises, 
 fibres, 
 fibres_p2p, 
 fibres_pon, 
 fibres_res, 
 cables, 
 longueur, 
 cout, 
 id_nod_pri, 
 id_nod_sup, 
 capa_util, 
 nom_nro, 
 ancien_nom, 
 a.geom
 FROM rip2.starr_liens as a
 JOIN  administratif.communes as b
 ON ST_CONTAINS (b.geom, a.geom)
 WHERE b.opp is not null;


--- Schema : rip2
--- Table : vue_adn_lots_geographiques

CREATE OR REPLACE VIEW rip2.vue_adn_lots_geographiques AS 
 SELECT DISTINCT a.id,
    a.geom,
    a.id_0,
    a.cat,
    a.commune,
    a.codinsee,
    a.dpt,
    a.region,
    a.canton,
    a.arrondisst,
    a.popul,
    a.com_com,
    a.epci_2012,
    a.interco,
    a.longueur,
    a.numericab,
    a.xg,
    a.gr_bl,
    a.zone_amii,
    a.source_ami,
    a.za_raccord,
    a.competence,
    a.x,
    a.y,
    a.rotation,
    a.siren_epci,
    a.delib,
    a.t_lots,
    a.q_lots,
    a.ms,
    a.lot,
    a.cdd,
    a.label
   FROM rip2.adn_lots_geographiques a
     JOIN administratif.communes b ON st_intersects(a.geom, b.geom)
  WHERE b.opp IS NOT NULL;

--- Schema : rip2
--- Table : vue_adn_programmation

CREATE OR REPLACE VIEW rip2.vue_adn_programmation AS 
SELECT 
 distinct gid, 
 a.geom, 
 id_0, 
 a.id, 
 pr, 
 total_pris, 
 prises_uti, 
 cout_prise, 
 cout_total, 
 epci, 
 communes, 
 phase, 
 a.x, 
 a.y, 
 length, 
 libelle, 
 vdsl2, 
 nb_pet_ent, 
 nb_gde_ent, 
 nb_lg, 
 prise_util, 
 prog_dsp, 
 nom_offici, 
 a.ms
 FROM rip2.adn_programmation as a
 JOIN  administratif.communes as b
 ON ST_INTERSECTS (a.geom, b.geom)
 WHERE b.opp is not null;

--- Schema : rip2
--- Table : vue_adn_zsro


CREATE OR REPLACE VIEW rip2.vue_adn_zsro AS 
SELECT 
 distinct a.id, 
 a.geom, 
 a.msro_ref,
 c.annee_pr, 
 a.ancien_nom, 
 a.ancien_n_1, 
 nb_majic, 
 nb_tech, 
 nb_plu, 
 nb_total,
 c.comment
  FROM rip2.adn_zsro as a
 JOIN  administratif.communes as b ON st_intersects (a.geom, b.geom)
 JOIN rip2.adn_sro c ON a.msro_ref= c.msro_ref
;


--- Schema : rip2
--- Table : vue_adn_sro

CREATE OR REPLACE VIEW rip2.vue_adn_sro AS 
 SELECT DISTINCT a.id,
    a.geom,
    a.msro_ref,
    a.ancien_nom,
    a.ancien_n_1,
    a.localisati,
    a.typo,
    a.annee_pr,
    a.ms,
    a.prevision_,
    a.comment,
    a.phase,
    a.etat,
    a.adresse
   FROM rip2.adn_sro a
JOIN rip2.vue_adn_zsro b on a.msro_ref=b.msro_ref;


--- Schema : rip2
--- Table : vue_adn_znro

  CREATE OR REPLACE VIEW rip2.vue_adn_znro AS 
 SELECT 
    distinct a.id,
    a.geom,
    a.nro_ref,
    c.annee_pr,
    a.nro,
    a.nb_majic,
    a.nb_tech,
    a.nb_plu,
    a.nb_total,
     c.comment
   FROM rip2.adn_znro a
   JOIN administratif.communes b ON st_intersects(a.geom, b.geom)
   JOIN rip2.adn_nro c ON a.nro_ref= c.nro_ref

--- Schema : rip2
--- Table : vue_adn_nro

CREATE OR REPLACE VIEW rip2.vue_adn_nro AS 

  SELECT 
    distinct a.id,
    a.geom,
    a.nro_ref,
    a.nom_nro,
    a.type_colle,
    a.annee_pr,
    a.phase,
    a.comment,
    a.nom_pi
   FROM rip2.adn_nro a
   join rip2.vue_adn_znro  as b ON a.nro_ref= b.nro_ref





drop table if exists administratif.cluster_suf;
create table administratif.cluster_suf as 
SELECT row_number() over () AS id,
  ST_NumGeometries(gc),
  gc AS geom_collection,
  ST_Centroid(gc) AS centroid,
  ST_MinimumBoundingCircle(gc) AS circle,
  sqrt(ST_Area(ST_MinimumBoundingCircle(gc)) / pi()) AS radius
FROM (
  SELECT unnest(ST_ClusterWithin(geom, 50)) gc
  FROM administratif.adn_suf_majic_2016
) f;

ALTER TABLE administratif.cluster_suf
  ADD PRIMARY KEY (id);


CREATE INDEX administratif_cluster_suf_geom ON administratif.cluster_suf USING GIST (geom);


ALTER TABLE analyse_thematique.grille_densite_50
  ADD PRIMARY KEY (id);
CREATE OR REPLACE VIEW analyse_thematique.vue_grille_densite_50_nb_suf AS 
SELECT 
count(a.ogc_fid) as nb_suf, 
a.id, a.geom
FROM analyse_thematique.grille_densite_50 as a
join administratif.vue_adn_suf_majic_2016 as b on st_contains (a.geom, b.geom)
group by a.id

CREATE OR REPLACE VIEW analyse_thematique.vue_cluster_suf AS 
 SELECT a.id,
    a.st_numgeometries AS nb_suf,
    a.circle as geom,
    a.radius::int
  
   FROM analyse_thematique.cluster_suf a
     JOIN administratif.vue_communes b ON st_contains(b.geom, a.circle);

--- Schema : emprises_mobilisables (bdd reseaux)
--- Table : vue_route_adn_ign_2017_2154

/*CREATE OR REPLACE VIEW emprises_mobilisables.vue_route_adn_ign_2017_2154 AS 
SELECT row_number() over () AS gid, * 
from(
SELECT t1.id, t1.type, t1.emprise, t1.geom FROM dblink('host=192.168.101.254 port=5432 dbname=reseaux user=postgres password=l0cA!L8:','select id, type, emprise , geom from emprises_mobilisables.route_07_ign_2017_2154')
AS t1(id varchar, type varchar, emprise varchar, geom geometry) 
join dblink('host=192.168.101.254 port=5432 dbname=adn_l49 user=postgres password=l0cA!L8:','select commune, opp, geom from administratif.communes')
AS t2(commune varchar, opp varchar, geom geometry) on st_contains(t2.geom,t1.geom)
where t2.opp is not null 
union all
SELECT t1.id, t1.type, t1.emprise, t1.geom FROM dblink('host=192.168.101.254 port=5432 dbname=reseaux user=postgres password=l0cA!L8:','select id, type, emprise , geom from emprises_mobilisables.route_26_ign_2017_2154')
AS t1(id varchar, type varchar, emprise varchar, geom geometry) 
join dblink('host=192.168.101.254 port=5432 dbname=adn_l49 user=postgres password=l0cA!L8:','select commune, opp, geom from administratif.communes')
AS t2(commune varchar, opp varchar, geom geometry) on st_contains(t2.geom,t1.geom)
where t2.opp is not null )vue
*/

--- Schema : analyse_thematique 
--- Table : vue_emprises_mobilisables_26_07

CREATE OR REPLACE VIEW analyse_thematique.vue_emprises_mobilisables_26_07 AS 
SELECT 
row_number() OVER () AS id,
a.dn, 
a.type, 
a.emprise, 
a.heatmap, 
a.geom, 
a.commune
FROM analyse_thematique.emprises_mobilisables_26_07 as a
JOIN  administratif.communes as b
ON a.commune = b.commune
WHERE b.opp is not null;

--- Schema : analyse_thematique 
--- Table : vue_communes_centroides


CREATE OR REPLACE VIEW analyse_thematique.vue_communes_centroides AS
 SELECT row_number() OVER () AS gid,
    st_centroid(geom) as geom,
    commune,
    codinsee,
    dpt,
    region,
  emprise_mob,
    num_priorite
   FROM administratif.communes 
  WHERE opp IS NOT NULL;

--- Schema : coordination 
--- Table : vue_opportunite_pins

CREATE OR REPLACE VIEW coordination.vue_opportunite_pins AS 
SELECT id_opp, ST_Extent(geom) AS bounding_box , ST_SetSRID(ST_Extent(geom),2154) as geom, st_centroid(ST_SetSRID(ST_Extent(geom),2154)) as centroid
FROM coordination.opportunite as a
where id_opp is not null
group by id_opp
;

--- Schema : coordination 
--- Table : vue_numerisation_pins

CREATE OR REPLACE VIEW coordination.vue_numerisation_pins AS 
SELECT id_opp, ST_Extent(geom) AS bounding_box , ST_SetSRID(ST_Extent(geom),2154) as geom, st_centroid(ST_SetSRID(ST_Extent(geom),2154)) as centroid
FROM coordination.numerisation as a
where id_opp is not null
group by id_opp
;

--- Schema : coordination 
--- Table : chambres_a_creer
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


--- Schema : coordination 
--- Table : opportunite
-- Met à jour le champ url d'opportunite lorsque le champs statut = 'Traitée'
CREATE OR REPLACE FUNCTION update_url_opp() RETURNS TRIGGER AS $$
BEGIN

    NEW.url :=        
      concat('/adn/document/rapports/',
     NEW.envoi_moe,
      '/',
  NEW.id_opp,
  '.pdf'
     ) ;
  RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';


DROP TRIGGER IF EXISTS trg_update_url_opp ON coordination.opportunite;
CREATE TRIGGER trg_update_url_opp
BEFORE INSERT OR UPDATE OF 
statut 
ON coordination.opportunite
FOR EACH ROW 
WHEN (NEW.statut = 'Traitée')
EXECUTE PROCEDURE update_url_opp();

--- Schema : coordination 
--- Table : numerisation
-- Met à jour le champ travaux d'opportunite à partir du champ support
CREATE OR REPLACE FUNCTION update_travaux_num() RETURNS TRIGGER AS $$
BEGIN

    NEW.travaux :=        
      CASE
      WHEN NEW.support like 'Souterrain FT' THEN 'Souterrain FT'
    WHEN NEW.support like 'Aerien FT' THEN 'Aerien FT'
    WHEN NEW.support like 'Refection de voirie' THEN 'Refection de voirie'
    WHEN NEW.support like 'Souterrain FT' THEN 'Souterrain FT'
    WHEN NEW.support like 'Souterrain HT' OR NEW.support like 'Souterrain BT' OR NEW.support like 'Souterrain EP' THEN 'Souterrain HT/BT/EP'
    WHEN NEW.support like 'Aerien HT' OR NEW.support like 'Aerien BT' OR NEW.support like 'Eclairage public' THEN 'Aerien HT/BT/EP'
    WHEN NEW.support like 'Assainissement' OR NEW.support like 'Eau potable' OR NEW.support like 'Eau pluviale' OR NEW.support like 'Eaux usees' THEN 'AEP/EP/EU'
    WHEN NEW.support like 'Feux tricolores' OR NEW.support like 'Signalisation routiere' THEN 'Signalisation/feux tricolores'
    WHEN NEW.support like 'Chauffage' OR NEW.support like 'Climatisation' THEN 'Chauffage/climatisation'
    WHEN NEW.support like 'Gaz' OR NEW.support like 'Combustibles' OR NEW.support like 'Hydrocarbures' THEN 'Gaz/hydrocarbures'
    END;
  RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';


DROP TRIGGER IF EXISTS trg_update_travaux_num ON coordination.numerisation;
CREATE TRIGGER trg_update_travaux_num
BEFORE INSERT OR UPDATE OF 
geom 
ON coordination.numerisation
FOR EACH ROW 
EXECUTE PROCEDURE update_travaux_num();

--- Schema : administratif 
--- Table : communes
-- Met à jour le champ opp de communes à partir du champ id_opp d'opportunite

CREATE OR REPLACE FUNCTION update_opp() RETURNS TRIGGER AS $$
BEGIN
--  IF NEW.url != OLD.url  THEN
    UPDATE administratif.communes a
    SET opp= CASE WHEN b.statut like 'Traitée' THEN id_opp ELSE null END
    FROM coordination.opportunite b 
    WHERE ST_INTERSECTS (b.geom,a.geom);
--  END IF;
--  RETURN NEW;
  RETURN NULL;
END;
$$ LANGUAGE 'plpgsql';

DROP TRIGGER IF EXISTS trg_update_opp ON coordination.opportunite;
CREATE TRIGGER trg_update_opp
AFTER INSERT OR UPDATE OR DELETE ON coordination.opportunite
FOR EACH STATEMENT EXECUTE PROCEDURE update_opp();

--- Schema : coordination 
--- Table : numerisation
-- Met à jour le champ id_opp de numerisation àà la création d'entités
CREATE OR REPLACE FUNCTION update_id_opp() RETURNS TRIGGER AS $$
BEGIN

    NEW.id_opp :=        
      concat('OPP_',
      -- cherche id prog sinon lot
      (CASE 
        WHEN NEW.lot like '1' and NEW.id_prog = 'NULL' THEN '1-XX'::character varying 
            WHEN NEW.lot like '2' and NEW.id_prog = 'NULL' THEN '2-XX'::character varying 
            WHEN NEW.lot like '3' and NEW.id_prog = 'NULL' THEN '3-XX'::character varying 
            WHEN NEW.lot like '4' and NEW.id_prog = 'NULL' THEN '4-XX'::character varying 
          ELSE NEW.id_prog END),
      '_',
      -- cherche nro ref
      NEW.id_nro,
      '_',
      -- incrémente en fonction du nombre de fois que l'id_nro a été utilisé
       lpad((SELECT cast(nbr_doublon+1 as varchar) test FROM coordination.vue_doublons_nro_all where nro_ref like  NEW.id_nro),3,'0')) 
      as id_opp ;
  RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

DROP TRIGGER IF EXISTS trg_update_id_opp ON coordination.numerisation;
CREATE TRIGGER trg_update_id_opp
BEFORE INSERT OR UPDATE OF 
geom 
ON coordination.numerisation
FOR EACH ROW EXECUTE PROCEDURE update_id_opp();





--- Schema : coordination 
--- Table : vue_doublons_nro_all
/*CREATE OR REPLACE VIEW coordination.vue_doublons_nro_all AS
 SELECT doublons_nro.nbr_doublon,
    doublons_nro.id_nro AS nro_ref
   FROM ( WITH compte AS (
                 SELECT numerisation.id_nro,
                    numerisation.id_opp
                   FROM coordination.numerisation
                  GROUP BY numerisation.id_nro, numerisation.id_opp
                  ORDER BY numerisation.id_nro
                )
         SELECT count(compte.id_nro) + 1 AS nbr_doublon,
            compte.id_nro
           FROM compte
          GROUP BY compte.id_nro) doublons_nro
  ORDER BY doublons_nro.nbr_doublon DESC;
*/
--- Schema : coordination 
--- Table : vue_doublons_nro_all

 CREATE OR REPLACE VIEW coordination.vue_doublons_nro_all AS
 SELECT doublons_nro.nbr_doublon,
    doublons_nro.id_nro AS nro_ref
   FROM ( WITH compte AS (
                 SELECT numerisation.id_nro,
                    numerisation.id_opp
                   FROM coordination.numerisation
                  GROUP BY numerisation.id_nro, numerisation.id_opp
                  ORDER BY numerisation.id_nro
                )
         SELECT count(compte.id_nro) AS nbr_doublon,
            compte.id_nro
           FROM compte
          GROUP BY compte.id_nro) doublons_nro
UNION ALL
 SELECT 0 AS nbr_doublon,
    doublons_nro.nro_ref
   FROM ( WITH compte AS (
                 SELECT a.nro_ref,
                    NULL::character varying AS id_opp
                   FROM administratif.communes a
                  GROUP BY a.nro_ref, NULL::character varying
                  ORDER BY a.nro_ref
                )
         SELECT count(compte.nro_ref) AS nbr_doublon,
            compte.nro_ref
           FROM compte
          GROUP BY compte.nro_ref) doublons_nro
  WHERE NOT (doublons_nro.nro_ref::text IN ( SELECT a.id_nro
           FROM coordination.numerisation a
          WHERE a.id_nro IS NOT NULL))
  ORDER BY 1 DESC;

/*
-- MAJ chausees
  ALTER TABLE coordination.chausees ADD COLUMN communes varchar(254);
ALTER TABLE coordination.chausees ADD COLUMN id_opp varchar(254);

UPDATE coordination.chausees as a 
SET communes = b.commune
FROM administratif.communes as b 

WHERE ST_Intersects(b.geom,a.geom)

--- Schema : coordination 
--- Table : chaussee_2018_07_opp
--- Incrémentation id_opp
  drop table if exists coordination.chaussee_2018_07_opp;
create table coordination.chaussee_2018_07_opp as 
SELECT id, nbr_doublon, 'OPP_'||pr ||'_'|| nro_ref||'_'||lpad(CAST(row_number() OVER (PARTITION BY nro_ref, nbr_doublon ORDER BY id) + nbr_doublon - 1 AS VARCHAR), 3, '0')id_opp, communes, priorite, nom_rd,geom
FROM ( WITH sequenc AS (
SELECT 
  a.id as id , 
  a.communes,
  a.geom,
  b.nro_ref,
  c.nbr_doublon +1 as nbr_doublon,
  a.priorite,
  a.nom_rd,
  CASE 
   WHEN b.lot = 1 and b.pr IS NULL THEN '1-XX'::character varying 
   WHEN b.lot = 2 and b.pr IS NULL THEN '2-XX'::character varying 
   WHEN b.lot = 3 and b.pr IS NULL THEN '3-XX'::character varying 
   WHEN b.lot = 4 and b.pr IS NULL THEN '4-XX'::character varying 
   ELSE b.pr END AS pr
FROM coordination.chausees as a
JOIN  administratif.communes as b ON a.communes=b.commune
JOIN  coordination.vue_doublons_nro_all  as c USING (nro_ref)
order by id_opp
)
SELECT *
FROM sequenc
) concat
;


DROP table if exists  coordination.chaussee_2018_07_opp_linestring ;
CREATE TABLE   coordination.chaussee_2018_07_opp_linestring AS                       --poly will be the new polygon table
WITH dump AS (
  SELECT
   id, nbr_doublon, id_opp, communes, priorite, nom_rd,
                    --columns from your multipolygon table 
      (ST_DUMP(geom)).geom AS geom 
   FROM coordination.chaussee_2018_07_opp                          --the name of your multipolygon table
) 
SELECT id, nbr_doublon, id_opp, communes, priorite, nom_rd,
  geom::geometry(Linestring,2154)         --type cast using SRID from multipolygon
FROM dump;

ALTER TABLE coordination.chaussee_2018_07_opp_linestring ADD COLUMN gid SERIAL PRIMARY KEY;


INSERT INTO coordination.numerisation (
geom, 
id_opp, 
lot, 
id_prog, 
id_nro, 
id_reseau, 
insee, 
com_dep, 
statut, 
phase, 
emprise, 
nom, 
support, 
travaux, 
typ_reseau, 
longueur, 
debut_trvx, 
prog_dsp, 
moa, 
cdd, 
commentair, 
envoi_moe, 
date



)

SELECT 
a.geom, 
id_opp, 
b.lot, 
b.pr as id_prog, 
b.nro_ref as id_nro, 
'R001'::varchar as id_reseau, 
b.codinsee as insee, 
a.communes as com_dep, 
'A étudier'::varchar as statut, 
'Numerisation'::varchar as phase, 
concat(a.communes,'-',nom_rd) as emprise, 
concat('COO_Réfection des Voiries_Renouvellement-des-couches-des-surfaces(',a.communes,')_',a.nom_rd,'_ Chausées')::varchar as nom, 
'Refection de voirie'::varchar as support, 
'Refection de voirie'::varchar as travaux, 
null::varchar as typ_reseau, 
st_length (a.geom)::integer as longueur, 
CASE 
  WHEN priorite like '1' THEN 'Ete 2018'
  WHEN priorite like '1_bis' THEN 'Automne 2018'
  WHEN priorite like '2' THEN 'Printemps 2019'
  WHEN priorite like '3' THEN 'Printemps 2020' 
  END::varchar as debut_trvx, 
b.prog_dsp, 
'Département de l''Ardèche'::varchar as moa,
b.cdd, 
CASE 
  WHEN priorite like '1' THEN 'Priorité 1 : Les travaux devront être réalisés pour le 1er Juillet 2018'
  WHEN priorite like '1_bis' THEN 'Priorité 1 bis : Les travaux pourront être réalisés à compter du 1er septembre 2018, sous réserve du budget disponible à l’issue des priorités 1. Les opérations non réalisées au second semestre seront reportées en 2019'
  WHEN priorite like '2' THEN 'Priorité 2 : Les travaux seront réalisés sur les exercices 2019 et 2020'
  WHEN priorite like '3' THEN 'Priorité 3 : Les travaux seront réalisés sur les exercices 2019 et 2020' 
  END::varchar as commentair, 
'S06/2018'::varchar as envoi_moe, 
date '2018-03-01' - integer '7' as date
FROM coordination.chaussee_2018_07_opp_linestring as a
JOIN  administratif.communes as b ON a.communes = b.commune
order by debut_trvx

*/


UPDATE administratif.communes a
SET phase_prog = phase
FROM rip2.adn_programmation b 
WHERE ST_INTERSECTS (a.geom, b.geom)