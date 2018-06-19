/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 16/03/2017
Objet : Mise à jour du champs source_fil
Modification : 
Nom : Faucher Marine - Date : 31/07/2017 - Motif/nature : Mise en pratique des scripts (export/import tables sources/resultats)
-------------------------------------------------------------------------------------
*/

--************* Formatage des tables ep **************
UPDATE ep_vol3.chb_jaujac
SET source_fil = 'chb_jaujac'; -- nom à adapter selon la table

UPDATE ep_vol3.infra_jaujac
SET source_fil = 'infra_jaujac'; -- nom à adapter selon la table