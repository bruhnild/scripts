/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 04/06/2018
Projet : RIP - MOE 70 - HSN
Objet : Supprimer les entités duppliqué dans les tables geo
Modification : Nom : ///// - Date : date_de_modif - Motif/nature : //////

-------------------------------------------------------------------------------------
*/

/*
-------------------------------------------------------------------------------------
SUPPRESSION DOUBLONS geo_parcelle
-------------------------------------------------------------------------------------
*/

SET search_path TO pci70_edigeo_majic, public;

--- Schema : pci70_edigeo_majic
--- Vue : geo_parcelle
--- Traitement : Suppression de doublons dans la table des parcelles (ne garde qu'une ligne sur les 4)

DELETE FROM geo_parcelle
WHERE ogc_fid IN (
  SELECT 
   ogc_fid
    FROM (
      SELECT 
       ogc_fid,
       ROW_NUMBER() OVER (partition BY object_rid, geo_parcelle ORDER BY ogc_fid) AS rnum
        FROM geo_parcelle ) t
        WHERE t.rnum > 1);

/*
-------------------------------------------------------------------------------------
SUPPRESSION DOUBLONS parcelle_info
-------------------------------------------------------------------------------------
*/


--- Schema : pci70_edigeo_majic
--- Vue : parcelle_info
--- Traitement : Suppression de doublons dans la table des parcelles consolidées (ne garde qu'une ligne sur les 4)

DELETE FROM parcelle_info
WHERE ogc_fid IN (
  SELECT 
   ogc_fid
    FROM (
      SELECT 
       ogc_fid,
       ROW_NUMBER() OVER (partition BY idu, geo_parcelle ORDER BY ogc_fid) AS rnum
        FROM parcelle_info ) t
        WHERE t.rnum > 1);

/*
-------------------------------------------------------------------------------------
SUPPRESSION DOUBLONS geo_zoncommuni
-------------------------------------------------------------------------------------
*/

--- Schema : pci70_edigeo_majic
--- Vue : geo_zoncommuni
--- Traitement : Suppression de doublons dans la table voies du domaine non cadastré (ne garde qu'une ligne sur les 4)

DELETE FROM geo_zoncommuni
WHERE geo_zoncommuni IN (
  SELECT 
   geo_zoncommuni
    FROM (
      SELECT 
       geo_zoncommuni,
       ROW_NUMBER() OVER (partition BY object_rid, creat_date ORDER BY geo_zoncommuni) AS rnum
        FROM geo_zoncommuni ) t
        WHERE t.rnum > 1);
/*
-------------------------------------------------------------------------------------
SUPPRESSION DOUBLONS geo_batiment
-------------------------------------------------------------------------------------
*/

--- Schema : pci70_edigeo_majic
--- Vue : geo_batiment
--- Traitement : Suppression de doublons dans la table des batiments (ne garde qu'une ligne sur les 4)	

DELETE FROM geo_batiment
WHERE geo_batiment IN (
  SELECT 
   geo_batiment
    FROM (
      SELECT 
       geo_batiment,
       ROW_NUMBER() OVER (partition BY object_rid, creat_date ORDER BY geo_batiment) AS rnum
        FROM geo_batiment ) t
        WHERE t.rnum > 1);
		
/*
-------------------------------------------------------------------------------------
SUPPRESSION DOUBLONS geo_borne
-------------------------------------------------------------------------------------
*/

--- Schema : pci70_edigeo_majic
--- Vue : geo_borne
--- Traitement : Suppression de doublons dans la table des bornes (ne garde qu'une ligne sur les 4)	

DELETE FROM geo_borne
WHERE geo_borne IN (
  SELECT 
   geo_borne
    FROM (
      SELECT 
       geo_borne,
       ROW_NUMBER() OVER (partition BY object_rid, creat_date ORDER BY geo_borne) AS rnum
        FROM geo_borne ) t
        WHERE t.rnum > 1);

/*
-------------------------------------------------------------------------------------
SUPPRESSION DOUBLONS charge_id
-------------------------------------------------------------------------------------
*/

--- Schema : pci70_edigeo_majic
--- Vue : charge_id
--- Traitement : Suppression de doublons dans la table des charges (ne garde qu'une ligne sur les 4)	

DELETE FROM charge_id
WHERE ogc_fid IN (
  SELECT 
   ogc_fid
    FROM (
      SELECT 
       ogc_fid,
       ROW_NUMBER() OVER (partition BY object_rid, creat_date ORDER BY ogc_fid) AS rnum
        FROM charge_id ) t
        WHERE t.rnum > 1);

/*
-------------------------------------------------------------------------------------
SUPPRESSION DOUBLONS geo_croix
-------------------------------------------------------------------------------------
*/

--- Schema : pci70_edigeo_majic
--- Vue : geo_croix
--- Traitement : Suppression de doublons dans la table des croix (ne garde qu'une ligne sur les 4)	

DELETE FROM geo_croix
WHERE geo_croix IN (
  SELECT 
   geo_croix
    FROM (
      SELECT 
       geo_croix,
       ROW_NUMBER() OVER (partition BY object_rid, creat_date ORDER BY geo_croix) AS rnum
        FROM geo_croix ) t
        WHERE t.rnum > 1);

/*
-------------------------------------------------------------------------------------
SUPPRESSION DOUBLONS geo_label
-------------------------------------------------------------------------------------
*/

--- Schema : pci70_edigeo_majic
--- Vue : geo_label
--- Traitement : Suppression de doublons dans la table des labels (ne garde qu'une ligne sur les 4)	

DELETE FROM geo_label
WHERE ogc_fid IN (
  SELECT 
   ogc_fid
    FROM (
      SELECT 
       ogc_fid,
       ROW_NUMBER() OVER (partition BY object_rid ORDER BY ogc_fid) AS rnum
        FROM geo_label ) t
        WHERE t.rnum > 1);

/*
-------------------------------------------------------------------------------------
SUPPRESSION DOUBLONS geo_lieudit
-------------------------------------------------------------------------------------
*/

--- Schema : pci70_edigeo_majic
--- Vue : geo_lieudit
--- Traitement : Suppression de doublons dans la table des lieux dits (ne garde qu'une ligne sur les 4)	

DELETE FROM geo_lieudit
WHERE geo_lieudit IN (
  SELECT 
   geo_lieudit
    FROM (
      SELECT 
       geo_lieudit,
       ROW_NUMBER() OVER (partition BY object_rid, creat_date ORDER BY geo_lieudit) AS rnum
        FROM geo_lieudit ) t
        WHERE t.rnum > 1);

/*
-------------------------------------------------------------------------------------
SUPPRESSION DOUBLONS geo_numvoie
-------------------------------------------------------------------------------------
*/

--- Schema : pci70_edigeo_majic
--- Vue : geo_numvoie
--- Traitement : Suppression de doublons dans la table des numeros de voies (ne garde qu'une ligne sur les 4)	

DELETE FROM geo_numvoie
WHERE geo_numvoie IN (
  SELECT 
   geo_numvoie
    FROM (
      SELECT 
       geo_numvoie,
       ROW_NUMBER() OVER (partition BY object_rid, creat_date ORDER BY geo_numvoie) AS rnum
        FROM geo_numvoie ) t
        WHERE t.rnum > 1);


/*
-------------------------------------------------------------------------------------
SUPPRESSION DOUBLONS geo_ptcanv
-------------------------------------------------------------------------------------
*/

--- Schema : pci70_edigeo_majic
--- Vue : geo_ptcanv
--- Traitement : Suppression de doublons dans la table des objets ponctuels servant d''appui aux opérations de lever des plans (ne garde qu'une ligne sur les 4)	

DELETE FROM geo_ptcanv
WHERE geo_ptcanv IN (
  SELECT 
   geo_ptcanv
    FROM (
      SELECT 
       geo_ptcanv,
       ROW_NUMBER() OVER (partition BY object_rid, creat_date ORDER BY geo_ptcanv) AS rnum
        FROM geo_ptcanv ) t
        WHERE t.rnum > 1);

/*
-------------------------------------------------------------------------------------
SUPPRESSION DOUBLONS geo_subdfisc
-------------------------------------------------------------------------------------
*/

--- Schema : pci70_edigeo_majic
--- Vue : geo_subdfisc
--- Traitement : Suppression de doublons dans la table subdivisions fiscales (ne garde qu'une ligne sur les 4)	

DELETE FROM geo_subdfisc
WHERE geo_subdfisc IN (
  SELECT 
   geo_subdfisc
    FROM (
      SELECT 
       geo_subdfisc,
       ROW_NUMBER() OVER (partition BY object_rid, creat_date ORDER BY geo_subdfisc) AS rnum
        FROM geo_subdfisc ) t
        WHERE t.rnum > 1);

/*
-------------------------------------------------------------------------------------
SUPPRESSION DOUBLONS geo_subdsect
-------------------------------------------------------------------------------------
*/

--- Schema : pci70_edigeo_majic
--- Vue : geo_subdfisc
--- Traitement : Suppression de doublons dans la table des portinos de sections cadastrales (ne garde qu'une ligne sur les 4)	

DELETE FROM geo_subdsect
WHERE geo_subdsect IN (
  SELECT 
   geo_subdsect
    FROM (
      SELECT 
       geo_subdsect,
       ROW_NUMBER() OVER (partition BY object_rid, creat_date ORDER BY geo_subdsect) AS rnum
        FROM geo_subdsect ) t
        WHERE t.rnum > 1);

/*
-------------------------------------------------------------------------------------
SUPPRESSION DOUBLONS geo_subdsect
-------------------------------------------------------------------------------------
*/

--- Schema : pci70_edigeo_majic
--- Vue : geo_subdfisc
--- Traitement : Suppression de doublons dans la table des portinos de sections cadastrales (ne garde qu'une ligne sur les 4)	
ALTER TABLE geo_subdsect ADD COLUMN ogc_fid SERIAL PRIMARY KEY;
	
DELETE FROM geo_subdsect
WHERE ogc_fid IN (
  SELECT 
   ogc_fid
    FROM (
      SELECT 
       ogc_fid,
       ROW_NUMBER() OVER (partition BY object_rid, geo_subdsect ORDER BY ogc_fid) AS rnum
        FROM geo_subdsect ) t
        WHERE t.rnum > 1);

/*
-------------------------------------------------------------------------------------
SUPPRESSION DOUBLONS geo_voiep
-------------------------------------------------------------------------------------
*/


--- Schema : pci70_edigeo_majic
--- Vue : geo_voiep
--- Traitement : Suppression de doublons dans la table des éléments ponctuels permettant la gestion de lensemble immobilier  (ne garde qu'une ligne sur les 4)

DELETE FROM geo_voiep
WHERE geo_voiep IN (
  SELECT 
   geo_voiep
    FROM (
      SELECT 
       geo_voiep,
       ROW_NUMBER() OVER (partition BY object_rid, creat_date ORDER BY geo_voiep) AS rnum
        FROM geo_voiep ) t
        WHERE t.rnum > 1);

/*
-------------------------------------------------------------------------------------
SUPPRESSION DOUBLONS geo_tsurf
-------------------------------------------------------------------------------------
*/


--- Schema : pci70_edigeo_majic
--- Vue : geo_tsurf
--- Traitement : Suppression de doublons dans la table des détails topographiques surfaciques (ne garde qu'une ligne sur les 4)

DELETE FROM geo_tsurf
WHERE geo_tsurf IN (
  SELECT 
   geo_tsurf
    FROM (
      SELECT 
       geo_tsurf,
       ROW_NUMBER() OVER (partition BY object_rid, creat_date ORDER BY geo_tsurf) AS rnum
        FROM geo_tsurf ) t
        WHERE t.rnum > 1);

/*
-------------------------------------------------------------------------------------
SUPPRESSION DOUBLONS geo_tronroute
-------------------------------------------------------------------------------------
*/


--- Schema : pci70_edigeo_majic
--- Vue : geo_tronroute
--- Traitement : Suppression de doublons dans la table des éléments surfaciques (fermés) utilisés pour tous les tronçons de routes (ne garde qu'une ligne sur les 4)

DELETE FROM geo_tronroute
WHERE geo_tronroute IN (
  SELECT 
   geo_tronroute
    FROM (
      SELECT 
       geo_tronroute,
       ROW_NUMBER() OVER (partition BY object_rid, creat_date ORDER BY geo_tronroute) AS rnum
        FROM geo_tronroute ) t
        WHERE t.rnum > 1);

/*
-------------------------------------------------------------------------------------
SUPPRESSION DOUBLONS geo_tpoint
-------------------------------------------------------------------------------------
*/


--- Schema : pci70_edigeo_majic
--- Vue : geo_tpoint
--- Traitement : Suppression de doublons dans la table des détails topographiques ponctuels (ne garde qu'une ligne sur les 4)

DELETE FROM geo_tpoint
WHERE geo_tpoint IN (
  SELECT 
   geo_tpoint
    FROM (
      SELECT 
       geo_tpoint,
       ROW_NUMBER() OVER (partition BY object_rid, creat_date ORDER BY geo_tpoint) AS rnum
        FROM geo_tpoint ) t
        WHERE t.rnum > 1);

/*
-------------------------------------------------------------------------------------
SUPPRESSION DOUBLONS geo_tronfluv
-------------------------------------------------------------------------------------
*/


--- Schema : pci70_edigeo_majic
--- Vue : geo_tronfluv
--- Traitement : Suppression de doublons dans la table des éléments surfaciques (fermés) utilisés pour tous les cours d''eau et les rivages de mers (ne garde qu'une ligne sur les 4)

DELETE FROM geo_tronfluv
WHERE geo_tronfluv IN (
  SELECT 
   geo_tronfluv
    FROM (
      SELECT 
       geo_tronfluv,
       ROW_NUMBER() OVER (partition BY object_rid, creat_date ORDER BY geo_tronfluv) AS rnum
        FROM geo_tronfluv ) t
        WHERE t.rnum > 1);

/*
-------------------------------------------------------------------------------------
SUPPRESSION DOUBLONS geo_tline
-------------------------------------------------------------------------------------
*/


--- Schema : pci70_edigeo_majic
--- Vue : geo_tline
--- Traitement : Suppression de doublons dans la table des détails topographiques linéaires (ne garde qu'une ligne sur les 4)

DELETE FROM geo_tline
WHERE geo_tline IN (
  SELECT 
   geo_tline
    FROM (
      SELECT 
       geo_tline,
       ROW_NUMBER() OVER (partition BY object_rid, creat_date ORDER BY geo_tline) AS rnum
        FROM geo_tline ) t
        WHERE t.rnum > 1);

/*
-------------------------------------------------------------------------------------
SUPPRESSION DOUBLONS geo_symblim
-------------------------------------------------------------------------------------
*/


--- Schema : pci70_edigeo_majic
--- Vue : geo_symblim
--- Traitement : Suppression de doublons dans la table des symboles de limites de propriété  (ne garde qu'une ligne sur les 4)

DELETE FROM geo_symblim
WHERE geo_symblim IN (
  SELECT 
   geo_symblim
    FROM (
      SELECT 
       geo_symblim,
       ROW_NUMBER() OVER (partition BY object_rid, creat_date ORDER BY geo_symblim) AS rnum
        FROM geo_symblim ) t
        WHERE t.rnum > 1);