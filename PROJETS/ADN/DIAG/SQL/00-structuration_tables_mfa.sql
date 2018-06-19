/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 16/03/2017
Objet : Structuration des tables de cables et chambres/optimisation de production diagnostique réseaux
Modification : 
Nom : Faucher Marine - Date : 31/07/2017 - Motif/nature : Mise en pratique des scripts (export/import tables sources/resultats)
-------------------------------------------------------------------------------------
*/


--************* Export de tables sources vers le schema "chantier" **************
/* Tables importés depuis PSQL*/

drop table if exists chantier.ft_arciti ; 
create table chantier.ft_arciti as 
SELECT ogc_fid as id, statut, mode_pose, aut_passag, aut_pass_1, nature_con, 
       type_longu, longueur, note, compositio, id_proprie, shape_len, 
       source_fil, wkb_geometry as geom 
  FROM orange_ms7.ft_arciti_villeuneuve_de_berg
  WHERE mode_pose = '7';

drop table if exists chantier.ft_chambre ; 
create table chantier.ft_chambre as 
SELECT ogc_fid as id , statut, implant, nature_cha, ref_chambr, ref_note, code_com, 
       code_voie, num_voie, id_proprie, code_ch1, code_ch2, note, securisee, 
       cle_mkt1, cle_mkt2, code_ch1_c, code_ch2_p, wkb_geometry as geom, source_file
  FROM orange_ms7.ft_chambre_villeuneuve_de_berg;

--************* Export de tables sources vers le schema "chantier" **************
/* Tables importés depuis QGIS

drop table if exists chantier.ft_arciti ; 
create table chantier.ft_arciti as 
SELECT id, statut, mode_pose, aut_passag, aut_pass_1, nature_con, 
       type_longu, longueur, note, compositio, id_proprie, shape_len, 
       source_fil, geom 
  FROM orange_vol4.ft_arciti_livron
  WHERE mode_pose = '7';

drop table if exists chantier.ft_chambre ; 
create table chantier.ft_chambre as 
SELECT id , statut, implant, nature_cha, ref_chambr, ref_note, code_com, 
       code_voie, num_voie, id_proprie, code_ch1, code_ch2, note, securisee, 
       cle_mkt1, cle_mkt2, code_ch1_c, code_ch2_p, geom, source_fil
  FROM orange_vol4.ft_chambre_livron;

  */