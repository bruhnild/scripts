--- Schema : gracethd_metis
--- Trigger : fn_update_majdate_t_sitetech
--- Traitement : Mets à jour le champ zn_majdate la table t_sitetech à la mise à jour

CREATE OR REPLACE FUNCTION fn_update_majdate_t_sitetech()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  IF (
      OLD.st_code IS DISTINCT FROM NEW.st_code OR
      OLD.st_nd_code IS DISTINCT FROM NEW.st_nd_code OR
      OLD.st_codeext IS DISTINCT FROM NEW.st_codeext OR
      OLD.st_nom IS DISTINCT FROM NEW.st_nom OR
      OLD.st_prop IS DISTINCT FROM NEW.st_prop OR
      OLD.st_gest IS DISTINCT FROM NEW.st_gest OR
      OLD.st_user IS DISTINCT FROM NEW.st_user OR
      OLD.st_proptyp IS DISTINCT FROM NEW.st_proptyp OR
      OLD.st_statut IS DISTINCT FROM NEW.st_statut OR
      OLD.st_etat IS DISTINCT FROM NEW.st_etat OR
      OLD.st_dateins IS DISTINCT FROM NEW.st_dateins OR
      OLD.st_datemes IS DISTINCT FROM NEW.st_datemes OR
      OLD.st_avct IS DISTINCT FROM NEW.st_avct OR
      OLD.st_typephy IS DISTINCT FROM NEW.st_typephy OR
      OLD.st_typelog IS DISTINCT FROM NEW.st_typelog OR
      OLD.st_nblines IS DISTINCT FROM NEW.st_nblines OR
      OLD.st_ad_code IS DISTINCT FROM NEW.st_ad_code OR
      OLD.st_comment IS DISTINCT FROM NEW.st_comment OR
      OLD.st_creadat IS DISTINCT FROM NEW.st_creadat OR
      OLD.st_majsrc IS DISTINCT FROM NEW.st_majsrc OR
      OLD.st_abddate IS DISTINCT FROM NEW.st_abddate OR
      OLD.st_abdsrc IS DISTINCT FROM NEW.st_abdsrc
    ) THEN
    NEW.st_majdate := now();
  END IF;
  RETURN new;
END;
$$;

DROP TRIGGER IF EXISTS trg_update_majdate_t_sitetech ON gracethd_metis.t_sitetech;
CREATE TRIGGER trg_update_majdate_t_sitetech
BEFORE UPDATE ON gracethd_metis.t_sitetech
FOR EACH ROW EXECUTE PROCEDURE fn_update_majdate_t_sitetech ();


