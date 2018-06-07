--- Schema : administratif
--- Vue : vue_communes

CREATE OR REPLACE VIEW administratif.vue_communes AS
SELECT *
FROM administratif.communes
WHERE communes.opp IS NOT NULL;

--- Schema : administratif
--- Vue : vue_adn_suf_majic_2016

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

--- Schema : orange
--- Vue : vue_arciti

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
--- Vue : vue_chambres

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
--- Vue : vue_adr_shl

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
--- Vue : vue_cables

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
--- Vue : vue_chambres

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
--- Vue : vue_souterrain

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
--- Vue : vue_troncon_aerien_bt

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
--- Vue : vue_troncon_aerien_hta

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
--- Vue : vue_starr_transport

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
--- Vue : vue_starr_liens
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

--- Schema : analyse_thematique
--- Vue : vue_grille_densite_50_nb_suf

CREATE OR REPLACE VIEW analyse_thematique.vue_grille_densite_50_nb_suf AS 
SELECT 
count(a.ogc_fid) as nb_suf, 
a.id, a.geom
FROM analyse_thematique.grille_densite_50 as a
join administratif.vue_adn_suf_majic_2016 as b on st_contains (a.geom, b.geom)
group by a.id;

--- Schema : analyse_thematique
--- Vue : vue_cluster_suf
CREATE OR REPLACE VIEW analyse_thematique.vue_cluster_suf AS 
SELECT a.id,
    a.st_numgeometries AS nb_suf,
    a.circle as geom,
    a.radius::int
  
FROM analyse_thematique.cluster_suf a
JOIN administratif.vue_communes b ON st_contains(b.geom, a.circle);


--- Schema : analyse_thematique 
--- Vue : vue_communes_centroides

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


--- Schema : analyse_thematique 
--- Vue : vue_emprises_mobilisables_26_07

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