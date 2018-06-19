/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 09/04/2018
Objet : Préparer la table de suivi des coordination pour le tableau de bord en pf
Modification : Nom : ///// - Date : date_de_modif - Motif/nature : //////

-------------------------------------------------------------------------------------
*/

--- Schema : dashboard
--- Table : t_suivi
--- Traitement : Création table t_suivi


SET search_path TO adn_l49, dashboard;

DROP TABLE IF EXISTS t_suivi CASCADE;

CREATE TABLE t_suivi( 
  id SERIAL PRIMARY KEY,
  lot VARCHAR(1) NOT NULL, -- LOT GEO MS
  cdd VARCHAR(15) NOT NULL, -- CDD ADN
  realisation VARCHAR(30) , -- Etude d'opportunité réalisée par
  mission_moe VARCHAR(15), -- Mission MOE en cours
  id_prog VARCHAR(4) , -- ID prévision DSP
  prog_dsp VARCHAR(4) , -- Date prévision DSP
  numero VARCHAR (3) , -- n° oppportunité sur la PR (xyz)
  id_nro VARCHAR(15)  , -- Identifiant NRO
  nom VARCHAR(254) NOT NULL, -- Nom Coordination
  id_coord VARCHAR(30) NOT NULL, -- ID Chantier (METIS)
  statut VARCHAR(15) NOT NULL, -- Statut projet chez METIS
  insee VARCHAR(5) NOT NULL, -- INSEE
  com_dep VARCHAR(254) NOT NULL, -- Commune départ
  emprise VARCHAR(254) NOT NULL, -- Emprise
  travaux VARCHAR(50) NOT NULL, -- Type de travaux
  longueur INTEGER NOT NULL, -- Mètres linéaires estimés (ml)
  debut_trvx VARCHAR(20), -- Début des travaux
  duree_trvx VARCHAR(30), -- Durée des travaux
  moa VARCHAR(254), -- MOA  
  moa_del VARCHAR(50), -- MOA délégué
  moa_be VARCHAR(50), -- MOE / BE
  ent_tvx VARCHAR(50), -- ENT. TVX
  contacts VARCHAR(254), -- Contacts
  analys_cdd VARCHAR(254), -- Analyse CDD
  repons_cdd VARCHAR(254), -- Réponse CDD
  dat_repons VARCHAR(30), -- Date réponse
  valid_tech VARCHAR(30), -- Validation technique
  montant_ht VARCHAR(20), -- Montant € HT
  valid_fina VARCHAR(50), -- Validation financière
  date_aig VARCHAR(20), -- Date Aiguillage
  retour_ter VARCHAR(254), -- Retour terrain
  entrepris VARCHAR(50), -- Entreprise
  gestion VARCHAR(50), -- Géré par
  ouv_chanti VARCHAR(50), -- Ouverture chantier
  rec_ouvrag VARCHAR(50), -- Réception ouvrage
  doe_fourni VARCHAR(50), -- DOE fourni
  commentair VARCHAR(254), -- Commentaire
  envoi_moe VARCHAR(10) NOT NULL -- Envoi MOE
  );
  
DROP INDEX IF EXISTS lot_idx; CREATE INDEX  lot_idx ON t_suivi(lot);
DROP INDEX IF EXISTS cdd_idxidx; CREATE INDEX  cdd_idx ON t_suivi(cdd);
DROP INDEX IF EXISTS id_prog_idx; CREATE INDEX  id_prog_idx ON t_suivi(id_prog);
DROP INDEX IF EXISTS prog_dsp_idx; CREATE INDEX  prog_dsp_idx ON t_suivi(prog_dsp);
DROP INDEX IF EXISTS id_coord_idx; CREATE INDEX  id_coord_idx ON t_suivi(id_coord);
DROP INDEX IF EXISTS id_nro_idx; CREATE INDEX  id_nro_idx ON t_suivi(id_nro);
DROP INDEX IF EXISTS com_dep_idx; CREATE INDEX com_dep_idx ON t_suivi(com_dep);
DROP INDEX IF EXISTS travaux_idx; CREATE INDEX  travaux_idx ON t_suivi(travaux);
DROP INDEX IF EXISTS statut_idx; CREATE INDEX  statut_idx ON t_suivi(statut);
DROP INDEX IF EXISTS debut_trvx_idx; CREATE INDEX  debut_trvx_idx ON t_suivi(debut_trvx);
DROP INDEX IF EXISTS envoi_moe_idx; CREATE INDEX  envoi_moe_idx ON t_suivi(envoi_moe);


ALTER TABLE ONLY t_suivi ALTER COLUMN realisation SET DEFAULT 'MOE';
UPDATE t_suivi
SET realisation = 'MOE';


--- Schema : dashboard
--- Vue : v_num_opp_synthese_longueur
--- Traitement : Calcul le nombre de ml pour les numerisations et les opportunités

CREATE OR REPLACE VIEW dashboard.v_num_opp_synthese_longueur AS 
SELECT 
a.id_opp as id_num,
a.longueur_max as longueur_num,
b.id_opp as id_opp,
b.longueur_max as longueur_opp
from
(
(WITH sum AS (
         SELECT numerisation.id_opp,
            sum(numerisation.longueur) AS longueur_max
           FROM coordination.numerisation
          GROUP BY numerisation.id_opp
        )
 SELECT DISTINCT ON (sum.id_opp) sum.id_opp,
    sum.longueur_max
   FROM coordination.numerisation o,
    sum))a left join 
  (WITH sum AS (
         SELECT opportunite.id_opp,
            sum(opportunite.longueur) AS longueur_max
           FROM coordination.opportunite
          GROUP BY opportunite.id_opp
        )
 SELECT DISTINCT ON (sum.id_opp) sum.id_opp,
    sum.longueur_max 
   FROM coordination.opportunite o,
    sum)b on  a.id_opp = b.id_opp
;

--- Schema : dashboard
--- Vue : v_num_opp_synthese
--- Traitement : Création vue synthèse (une ligne par coordination)
--- opportunite prend le dessus sur la numerisation

CREATE OR REPLACE VIEW dashboard.v_num_opp_synthese AS
SELECT ROW_NUMBER() OVER(ORDER BY id_coord) id, * 
FROM
(
WITH vue_all AS
(
SELECT  * 
FROM(
SELECT 
  DISTINCT ON (a.id_opp) a.id_opp as id_coord,
  a.lot,
  a.cdd,
  'MOE'::varchar as realisation,
  a.phase as mission_moe,
  a.id_prog,
  a.prog_dsp,
  a.numero,
  a.id_nro,
  a.nom,
  a.statut,
  a.insee,
  a.com_dep,
  a.emprise,
  a.travaux,
  f.longueur_num as longueur,
  CASE WHEN a.debut_trvx IS NULL THEN 'Inconnue'::character varying ELSE a.debut_trvx END AS debut_trvx,
  null::varchar as duree_trvx,
  a.moa,
  null::varchar as moa_del, 
  null::varchar as moa_be, 
  null::varchar as ent_tvx, 
  null::varchar as contacts, 
  null::varchar as analys_cdd, 
  null::varchar as repons_cdd, 
  null::varchar as dat_repons, 
  null::varchar as valid_tech, 
  null::varchar as montant_ht, 
  null::varchar as valid_fina, 
  null::varchar as date_aig, 
  null::varchar as retour_ter, 
  null::varchar as entrepris, 
  null::varchar as gestion, 
  null::varchar as ouv_chanti, 
  null::varchar as rec_ouvrag, 
  null::varchar as doe_fourni, 
  a.commentair, 
  a.envoi_moe
FROM coordination.numerisation a
LEFT JOIN dashboard.v_num_opp_synthese_longueur f ON a.id_opp like f.id_num
GROUP BY 
a.id_opp,a.lot, a.cdd, a.phase, a.id_prog, a.prog_dsp, a.numero, a.id_nro, a.nom, a.statut, a.insee, a.com_dep,
a.emprise, a.travaux, a.debut_trvx, a.moa, f.longueur_num, a.commentair, a.envoi_moe
order by a.id_opp DESC
)num
UNION ALL
SELECT  * 
FROM(
SELECT 
  DISTINCT ON (a.id_opp) a.id_opp as id_coord,
  a.lot,
  a.cdd,
  'MOE'::varchar as realisation,
  a.phase as mission_moe,
  a.id_prog,
  a.prog_dsp,
  a.numero,
  a.id_nro,
  a.nom,
  a.statut,
  a.insee,
  a.com_dep,
  a.emprise,
  a.travaux,
  f.longueur_opp as longueur,
  CASE WHEN a.debut_trvx IS NULL THEN 'Inconnue'::character varying ELSE a.debut_trvx END AS debut_trvx,
  null::varchar as duree_trvx,
  a.moa,
  null::varchar as moa_del, 
  null::varchar as moa_be, 
  null::varchar as ent_tvx, 
  null::varchar as contacts, 
  null::varchar as analys_cdd, 
  null::varchar as repons_cdd, 
  null::varchar as dat_repons, 
  null::varchar as valid_tech, 
  null::varchar as montant_ht, 
  null::varchar as valid_fina, 
  null::varchar as date_aig, 
  null::varchar as retour_ter, 
  null::varchar as entrepris, 
  null::varchar as gestion, 
  null::varchar as ouv_chanti, 
  null::varchar as rec_ouvrag, 
  null::varchar as doe_fourni, 
  a.commentair, 
  a.envoi_moe
FROM coordination.opportunite a
LEFT JOIN dashboard.v_num_opp_synthese_longueur f ON a.id_opp like f.id_opp
GROUP BY 
a.id_opp,a.lot, a.cdd, a.phase, a.id_prog, a.prog_dsp, a.numero, a.id_nro, a.nom, a.statut, a.insee, a.com_dep,
a.emprise, a.travaux, a.debut_trvx, a.moa, f.longueur_opp, a.commentair, a.envoi_moe
order by a.id_opp DESC
)opp)
SELECT * FROM vue_all as num
WHERE num.id_coord  NOT IN 
(SELECT DISTINCT id_coord 
FROM vue_all opp
WHERE num.mission_moe not LIKE  opp.mission_moe and num.mission_moe like 'Numerisation'
GROUP BY id_coord, mission_moe
HAVING num.id_coord=opp.id_coord
))a
;

--- Schema : dashboard
--- Table : t_suivi
--- Traitement : Insertion des lignes pour mettre à jour la table suivi avec ---numerisation



INSERT INTO dashboard.t_suivi  ( 
  id_coord, 
  lot, 
  cdd,
  mission_moe,
  id_prog, 
  id_nro, 
  numero,
  insee, 
  com_dep, 
  statut, 
  emprise, 
  nom, 
  travaux, 
  longueur, 
  debut_trvx, 
  prog_dsp, 
  moa, 
  commentair, 
  envoi_moe
)
SELECT
  num_opp.id_coord, 
  num_opp.lot, 
  num_opp.cdd,
  num_opp.mission_moe,
  num_opp.id_prog, 
  num_opp.id_nro,  
  num_opp.numero,
  num_opp.insee, 
  num_opp.com_dep, 
  num_opp.statut, 
  num_opp.emprise, 
  num_opp.nom, 
  num_opp.travaux, 
  num_opp.longueur, 
  num_opp.debut_trvx, 
  num_opp.prog_dsp, 
  num_opp.moa, 
  num_opp.commentair, 
  num_opp.envoi_moe
FROM dashboard.v_num_opp_synthese num_opp

;


--- Schema : dashboard
--- Trigger : trg_update_num_opp_synthese
--- Traitement : Mets à jour la table t_suivi à partir de la vue v_num_opp_synthese

CREATE OR REPLACE FUNCTION update_num_opp_synthese() RETURNS TRIGGER AS $$
BEGIN
INSERT INTO dashboard.t_suivi  ( 
  id_coord, 
  lot, 
  cdd,
  mission_moe,
  id_prog, 
  id_nro, 
  numero,
  insee, 
  com_dep, 
  statut, 
  emprise, 
  nom, 
  travaux, 
  longueur, 
  debut_trvx, 
  prog_dsp, 
  moa, 
  commentair, 
  envoi_moe
)
VALUES(
 new.id_opp, 
  new.lot, 
  new.cdd,
  new.mission_moe,
  new.id_prog, 
  new.id_nro,  
  new.numero,
  new.insee, 
  new.com_dep, 
  new.statut, 
  new.emprise, 
  new.nom, 
  new.travaux, 
  new.longueur, 
  new.debut_trvx, 
  new.prog_dsp, 
  new.moa, 
  new.commentair, 
  new.envoi_moe)
;
  RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';



DROP TRIGGER IF EXISTS trg_update_num_opp_synthese ON dashboard.t_suivi;
DROP TRIGGER IF EXISTS trg_update_num_opp_synthese ON dashboard.v_num_opp_synthese;
CREATE TRIGGER trg_update_num_opp_synthese
INSTEAD OF INSERT OR UPDATE ON dashboard.v_num_opp_synthese FOR EACH ROW EXECUTE PROCEDURE update_num_opp_synthese();

/*--- Schema : dashboard
--- Table : t_suivi
--- Traitement : Trigger pour mettre à jour la table suivi avec numerisation et opportunite
--- (si ligne supprimée, supprimée aussi dans t_suivi)

CREATE OR REPLACE FUNCTION delete_t_suivi() RETURNS TRIGGER AS $$
BEGIN
 WITH a_supprimer AS
(
SELECT *
FROM dashboard.t_suivi AS num
WHERE num.id_coord  NOT IN  
(SELECT DISTINCT id_opp
FROM coordination.numerisation  opp
WHERE id_coord=id_opp
GROUP BY id_coord, id_opp
))
DELETE FROM dashboard.t_suivi a
USING a_supprimer b
WHERE a.id = b.id;

  RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';



DROP TRIGGER IF EXISTS trg_delete_t_suivi_num ON dashboard.t_suivi;
DROP TRIGGER IF EXISTS trg_delete_t_suivi_num ON coordination.numerisation;
CREATE TRIGGER trg_delete_t_suivi_num
AFTER UPDATE OR DELETE ON coordination.numerisation 
FOR EACH ROW
EXECUTE PROCEDURE delete_t_suivi();

DROP TRIGGER IF EXISTS trg_delete_t_suivi_opp ON dashboard.t_suivi;
DROP TRIGGER IF EXISTS trg_delete_t_suivi_opp ON coordination.opportunite;
CREATE TRIGGER trg_delete_t_suivi_opp
AFTER UPDATE OR DELETE ON coordination.opportunite 
FOR EACH ROW
EXECUTE PROCEDURE delete_t_suivi();



--- Schema : dashboard
--- Table : t_suivi
--- Traitement : Supprimer doublons lorsque plusieurs entités ont le même id_coord 
--- mais plusieurs mission_moe et supprimer mission_moe = 'Numerisation'

CREATE OR REPLACE FUNCTION delete_duplicate_rows_t_suivi() RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  WITH a_supprimer AS
(
SELECT *
FROM dashboard.t_suivi AS num
WHERE num.id_coord  IN 
(SELECT DISTINCT id_coord 
FROM dashboard.t_suivi opp
WHERE num.mission_moe not LIKE  opp.mission_moe and num.mission_moe like 'Numerisation'
GROUP BY id_coord, mission_moe
HAVING num.id_coord=opp.id_coord
))
DELETE FROM dashboard.t_suivi a
USING a_supprimer b
WHERE a.id = b.id;
  RETURN NULL;
END;
$$;


DROP TRIGGER IF EXISTS trg_delete_duplicate_rows_t_suivi ON dashboard.numerisation;
DROP TRIGGER IF EXISTS trg_delete_duplicate_rows_t_suivi ON dashboard.t_suivi;
CREATE TRIGGER trg_delete_duplicate_rows_t_suivi
AFTER INSERT OR UPDATE OR DELETE ON dashboard.t_suivi
FOR EACH ROW
EXECUTE PROCEDURE delete_duplicate_rows_t_suivi();


*/