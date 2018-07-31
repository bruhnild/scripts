--- Schema : gracethd_metis
--- Trigger : fn_update_majdate_t_znro
--- Traitement : Mets à jour le champ zn_majdate la table t_znro à la mise à jour

CREATE OR REPLACE FUNCTION fn_update_majdate_t_znro()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  IF (
  	OLD.zn_nd_code IS DISTINCT FROM NEW.zn_nd_code OR
  	OLD.zn_r1_code IS DISTINCT FROM NEW.zn_r1_code OR
  	OLD.zn_r2_code IS DISTINCT FROM NEW.zn_r2_code OR
  	OLD.zn_r3_code IS DISTINCT FROM NEW.zn_r3_code OR
  	OLD.zn_r4_code IS DISTINCT FROM NEW.zn_r4_code OR
  	OLD.zn_nroref IS DISTINCT FROM NEW.zn_nroref OR
  	OLD.zn_nrotype IS DISTINCT FROM NEW.zn_nrotype OR
  	OLD.zn_etat IS DISTINCT FROM NEW.zn_etat OR
  	OLD.zn_etatlpm IS DISTINCT FROM NEW.zn_etatlpm OR
  	OLD.zn_datelpm IS DISTINCT FROM NEW.zn_datelpm OR
  	OLD.zn_comment IS DISTINCT FROM NEW.zn_comment OR
  	OLD.zn_geolsrc IS DISTINCT FROM NEW.zn_geolsrc OR
  	OLD.zn_creadat IS DISTINCT FROM NEW.zn_creadat OR
  	OLD.zn_majsrc IS DISTINCT FROM NEW.zn_majsrc OR
  	OLD.zn_abddate IS DISTINCT FROM NEW.zn_abddate OR
  	OLD.zn_abdsrc IS DISTINCT FROM NEW.zn_abdsrc OR
  	OLD.geom IS DISTINCT FROM NEW.geom
    ) THEN
    NEW.zn_majdate := now();
  END IF;
  RETURN new;
END;
$$;

DROP TRIGGER IF EXISTS trg_update_majdate_t_znro ON gracethd_metis.t_znro;
CREATE TRIGGER trg_update_majdate_t_znro
BEFORE UPDATE ON gracethd_metis.t_znro
FOR EACH ROW EXECUTE PROCEDURE fn_update_majdate_t_znro ();


