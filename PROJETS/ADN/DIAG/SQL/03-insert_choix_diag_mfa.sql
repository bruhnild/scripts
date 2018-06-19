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
INSERT INTO ep_ms7.infra_villeuneuve_de_berg (
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



INSERT INTO ep_ms7.chb_villeuneuve_de_berg (
 classement, statut, implant, nature_cha, ref_chambr, 
       ref_note, code_com, code_voie, num_voie, id_proprie, code_ch1, 
       code_ch2, note, securisee, cle_mkt1, cle_mkt2, code_ch1_c, code_ch2_p, 
       source_file, wkb_geometry


)
SELECT
 classement, statut, implant, nature_cha, ref_chambr, 
       ref_note, code_com, code_voie, num_voie, id_proprie, code_ch1, 
       code_ch2, note, securisee, cle_mkt1, cle_mkt2, code_ch1_c, code_ch2_p, 
       source_file, wkb_geometry
FROM chantier.chb
;
