/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 16/03/2017
Objet : Structuration des tables de cables et chambres/optimisation de production diagnostique réseaux
Modification : 
Nom : Faucher Marine - Date : 31/07/2017 - Motif/nature : Mise en pratique des scripts (export/import tables sources/resultats)
-------------------------------------------------------------------------------------
*/


--************* Formatage des tables ep **************

create table ep_ms7.chb_villeuneuve_de_berg as 
SELECT ogc_fid, classement, statut, implant, nature_cha, ref_chambr, 
       ref_note, code_com, code_voie, num_voie, id_proprie, code_ch1, 
       code_ch2, note, securisee, cle_mkt1, cle_mkt2, code_ch1_c, code_ch2_p, 
       source_file, wkb_geometry
  FROM chantier.chb;

CREATE INDEX idx_ep_ms7_chb_villeuneuve_de_berg ON ep_ms7.chb_villeuneuve_de_berg (classement) ; --- index attributaire
CREATE INDEX idx_ep_ms7_chb_villeuneuve_de_berg_geom ON ep_ms7.chb_villeuneuve_de_berg (wkb_geometry) ; --- index spatial
ALTER TABLE ep_ms7.chb_villeuneuve_de_berg ADD PRIMARY KEY (ogc_fid);
ALTER TABLE ep_ms7.chb_villeuneuve_de_berg ADD COLUMN choix_un smallint;
UPDATE ep_ms7.chb_villeuneuve_de_berg as a SET choix_un = 1;
ALTER TABLE ep_ms7.chb_villeuneuve_de_berg ADD COLUMN choix_deux smallint;
ALTER TABLE ep_ms7.chb_villeuneuve_de_berg ADD COLUMN choix_trois smallint;
ALTER TABLE ep_ms7.chb_villeuneuve_de_berg ADD COLUMN choix_quatre smallint;
ALTER TABLE ep_ms7.chb_villeuneuve_de_berg DROP COLUMN ogc_fid ;
ALTER TABLE ep_ms7.chb_villeuneuve_de_berg ADD COLUMN ogc_fid SERIAL PRIMARY KEY;

create table ep_ms7.infra_villeuneuve_de_berg as 
SELECT ogc_fid, statut, mode_pose, aut_passag, aut_pass_1, nature_con, 
       type_longu, longueur, note, compositio, id_proprie, shape_len, 
       source_fil, wkb_geometry
  FROM chantier.infra;

CREATE INDEX idx_ep_ms7_infra_villeuneuve_de_berg ON ep_ms7.infra_villeuneuve_de_berg (mode_pose) ; --- index attributaire
CREATE INDEX idx_ep_ms7_infra_villeuneuve_de_berg_geom ON ep_ms7.infra_meyras (wkb_geometry) ; --- index spatial
ALTER TABLE ep_ms7.infra_villeuneuve_de_berg ADD PRIMARY KEY (ogc_fid);
ALTER TABLE ep_ms7.infra_villeuneuve_de_berg ADD COLUMN choix_un smallint;
UPDATE ep_ms7.infra_villeuneuve_de_berg as a SET choix_un = 1;
ALTER TABLE ep_ms7.infra_villeuneuve_de_berg ADD COLUMN choix_deux smallint;
ALTER TABLE ep_ms7.infra_villeuneuve_de_berg ADD COLUMN choix_trois smallint;
ALTER TABLE ep_ms7.infra_villeuneuve_de_berg ADD COLUMN choix_quatre smallint;
ALTER TABLE ep_ms7.infra_villeuneuve_de_berg DROP COLUMN ogc_fid ;
ALTER TABLE ep_ms7.infra_villeuneuve_de_berg ADD COLUMN ogc_fid SERIAL PRIMARY KEY;

