/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 16/03/2017
Objet : Insertion des entités dans les tables infra et chambre (choix par choix)
Modification : 
Nom : Faucher Marine - Date : 31/07/2017 - Motif/nature : Mise en pratique des scripts (export/import tables sources/resultats)
-------------------------------------------------------------------------------------
*/

--************* Formatage des tables ep **************
-- Choix 1



drop table if exists  ep_vol4.chb_alboussiere;
create table ep_vol4.chb_alboussiere as 
SELECT ogc_fid, classement, statut, implant, nature_cha, ref_chambr, 
       ref_note, code_com, code_voie, num_voie, id_proprie, code_ch1, 
       code_ch2, note, securisee, cle_mkt1, cle_mkt2, code_ch1_c, code_ch2_p, 
       source_fil, wkb_geometry
  FROM chantier.chb;

CREATE INDEX idx_ep_vol4_chb_alboussiere ON ep_vol4.chb_alboussiere(classement) ; --- index attributaire
CREATE INDEX idx_ep_vol4_chb_alboussiere_geom ON ep_vol4.chb_alboussiere(wkb_geometry) ; --- index spatial
ALTER TABLE ep_vol4.chb_alboussiere ADD PRIMARY KEY (ogc_fid);
ALTER TABLE ep_vol4.chb_alboussiere ADD COLUMN choix_1 smallint;
UPDATE ep_vol4.chb_alboussiere as a SET choix_1 = 1;
ALTER TABLE ep_vol4.chb_alboussiere ADD COLUMN choix_2 smallint;
ALTER TABLE ep_vol4.chb_alboussiere ADD COLUMN choix_3 smallint;
ALTER TABLE ep_vol4.chb_alboussiere ADD COLUMN choix_4 smallint;
ALTER TABLE ep_vol4.chb_alboussiere DROP COLUMN ogc_fid ;
ALTER TABLE ep_vol4.chb_alboussiere ADD COLUMN ogc_fid SERIAL PRIMARY KEY;

drop table if exists ep_vol4.infra_alboussiere;
create table ep_vol4.infra_alboussiere as 
SELECT ogc_fid, statut, mode_pose, aut_passag, aut_pass_1, nature_con, 
       type_longu, longueur, note, compositio, id_proprie, shape_len, 
       source_fil, wkb_geometry
  FROM chantier.infra;

CREATE INDEX idx_ep_vol4_infra_alboussiere ON ep_vol4.infra_alboussiere(mode_pose) ; --- index attributaire
CREATE INDEX idx_ep_vol4_infra_alboussiere_geom ON ep_vol4.infra_alboussiere (wkb_geometry) ; --- index spatial
ALTER TABLE ep_vol4.infra_alboussiere ADD PRIMARY KEY (ogc_fid);
ALTER TABLE ep_vol4.infra_alboussiere ADD COLUMN choix_1 smallint;
UPDATE ep_vol4.infra_alboussiere as a SET choix_1 = 1;
ALTER TABLE ep_vol4.infra_alboussiere ADD COLUMN choix_2 smallint;
ALTER TABLE ep_vol4.infra_alboussiere ADD COLUMN choix_3 smallint;
ALTER TABLE ep_vol4.infra_alboussiere ADD COLUMN choix_4 smallint;
ALTER TABLE ep_vol4.infra_alboussiere DROP COLUMN ogc_fid ;
ALTER TABLE ep_vol4.infra_alboussiere ADD COLUMN ogc_fid SERIAL PRIMARY KEY;


-- Choix 2


INSERT INTO ep_vol4.infra_alboussiere (
 statut, mode_pose, aut_passag, aut_pass_1, nature_con, 
       type_longu, longueur, note, compositio, id_proprie, shape_len, 
       source_fil, wkb_geometry
)
SELECT
statut, mode_pose, aut_passag, aut_pass_1, nature_con, 
       type_longu, longueur, note, compositio, id_proprie, shape_len, 
       source_fil, wkb_geometry
FROM chantier.infra
;

UPDATE ep_vol4.infra_alboussiere
SET choix_2 = 2;

INSERT INTO ep_vol4.chb_alboussiere (
 classement, statut, implant, nature_cha, ref_chambr, 
       ref_note, code_com, code_voie, num_voie, id_proprie, code_ch1, 
       code_ch2, note, securisee, cle_mkt1, cle_mkt2, code_ch1_c, code_ch2_p, 
       source_fil, wkb_geometry


)
SELECT
 classement, statut, implant, nature_cha, ref_chambr, 
       ref_note, code_com, code_voie, num_voie, id_proprie, code_ch1, 
       code_ch2, note, securisee, cle_mkt1, cle_mkt2, code_ch1_c, code_ch2_p, 
       source_fil, wkb_geometry
FROM chantier.chb
;

UPDATE ep_vol4.chb_alboussiere
SET choix_2 = 2;

-- Choix_3

INSERT INTO ep_vol4.infra_alboussiere (
 statut, mode_pose, aut_passag, aut_pass_1, nature_con, 
       type_longu, longueur, note, compositio, id_proprie, shape_len, 
       source_fil, wkb_geometry
)
SELECT
statut, mode_pose, aut_passag, aut_pass_1, nature_con, 
       type_longu, longueur, note, compositio, id_proprie, shape_len, 
       source_fil, wkb_geometry
FROM chantier.infra
;

UPDATE ep_vol4.infra_alboussiere
SET choix_3 = 3;

INSERT INTO ep_vol4.chb_alboussiere (
 classement, statut, implant, nature_cha, ref_chambr, 
       ref_note, code_com, code_voie, num_voie, id_proprie, code_ch1, 
       code_ch2, note, securisee, cle_mkt1, cle_mkt2, code_ch1_c, code_ch2_p, 
       source_fil, wkb_geometry


)
SELECT
 classement, statut, implant, nature_cha, ref_chambr, 
       ref_note, code_com, code_voie, num_voie, id_proprie, code_ch1, 
       code_ch2, note, securisee, cle_mkt1, cle_mkt2, code_ch1_c, code_ch2_p, 
       source_fil, wkb_geometry
FROM chantier.chb
;

UPDATE ep_vol4.chb_alboussiere
SET choix_3 = 3;

-- Choix_4


INSERT INTO ep_vol4.infra_alboussiere (
 statut, mode_pose, aut_passag, aut_pass_1, nature_con, 
       type_longu, longueur, note, compositio, id_proprie, shape_len, 
       source_fil, wkb_geometry
)
SELECT
statut, mode_pose, aut_passag, aut_pass_1, nature_con, 
       type_longu, longueur, note, compositio, id_proprie, shape_len, 
       source_fil, wkb_geometry
FROM chantier.infra
;

UPDATE ep_vol4.infra_alboussiere
SET choix_4 = 4;

INSERT INTO ep_vol4.chb_alboussiere (
 classement, statut, implant, nature_cha, ref_chambr, 
       ref_note, code_com, code_voie, num_voie, id_proprie, code_ch1, 
       code_ch2, note, securisee, cle_mkt1, cle_mkt2, code_ch1_c, code_ch2_p, 
       source_fil, wkb_geometry


)
SELECT
 classement, statut, implant, nature_cha, ref_chambr, 
       ref_note, code_com, code_voie, num_voie, id_proprie, code_ch1, 
       code_ch2, note, securisee, cle_mkt1, cle_mkt2, code_ch1_c, code_ch2_p, 
       source_fil, wkb_geometry
FROM chantier.chb
;

UPDATE ep_vol4.chb_alboussiere
SET choix_4 =4 ;

--************* Suppression doublons **************

DELETE FROM ep_ms7.chb_villeuneuve_de_berg
WHERE ogc_fid IN (
  SELECT 
   ogc_fid
    FROM (
      SELECT 
       ogc_fid,
       ROW_NUMBER() OVER (partition BY code_ch1, cle_mkt2 ORDER BY ogc_fid) AS rnum
        FROM ep_ms7.chb_villeuneuve_de_berg ) t
        WHERE t.rnum > 1);
              
              
DELETE FROM ep_ms7.infra_villeuneuve_de_berg
WHERE ogc_fid IN (
  SELECT 
   ogc_fid
    FROM (
      SELECT 
       ogc_fid,
       ROW_NUMBER() OVER (partition BY compositio, longueur ORDER BY ogc_fid) AS rnum
        FROM ep_ms7.infra_villeuneuve_de_berg ) t
        WHERE t.rnum > 1);