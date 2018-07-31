--- Schema : gracethd_metis
--- Trigger : fn_update_majdate_t_zsro
--- Traitement : Mets à jour le champ zs_majdate la table t_zsro à la mise à jour

CREATE OR REPLACE FUNCTION fn_update_majdate_t_zsro()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  IF (OLD.zs_code IS DISTINCT FROM NEW.zs_code OR
      OLD.zs_nd_code IS DISTINCT FROM NEW.zs_nd_code OR
      OLD.zs_zn_code IS DISTINCT FROM NEW.zs_zn_code OR
	  OLD.zs_r1_code IS DISTINCT FROM NEW.zs_r1_code OR
	  OLD.zs_r2_code IS DISTINCT FROM NEW.zs_r2_code OR
	  OLD.zs_r3_code IS DISTINCT FROM NEW.zs_r3_code OR
	  OLD.zs_r4_code IS DISTINCT FROM NEW.zs_r4_code OR
	  OLD.zs_refpm IS DISTINCT FROM NEW.zs_refpm OR
	  OLD.zs_etatpm IS DISTINCT FROM NEW.zs_etatpm OR
	  OLD.zs_dateins IS DISTINCT FROM NEW.zs_dateins OR
	  OLD.zs_typeemp IS DISTINCT FROM NEW.zs_typeemp OR
	  OLD.zs_capamax IS DISTINCT FROM NEW.zs_capamax OR
	  OLD.zs_ad_code IS DISTINCT FROM NEW.zs_ad_code OR
	  OLD.zs_typeing IS DISTINCT FROM NEW.zs_typeing OR
	  OLD.zs_nblogmt IS DISTINCT FROM NEW.zs_nblogmt OR
	  OLD.zs_datcomr IS DISTINCT FROM NEW.zs_datcomr OR
	  OLD.zs_actif IS DISTINCT FROM NEW.zs_actif OR
	  OLD.zs_datemad IS DISTINCT FROM NEW.zs_datemad OR
	  OLD.zs_accgest IS DISTINCT FROM NEW.zs_accgest OR
	  OLD.zs_brassoi IS DISTINCT FROM NEW.zs_brassoi OR
	  OLD.zs_comment IS DISTINCT FROM NEW.zs_comment OR
	  OLD.zs_geolsrc IS DISTINCT FROM NEW.zs_geolsrc OR
	  OLD.zs_creadat IS DISTINCT FROM NEW.zs_creadat OR
	  OLD.zs_majsrc IS DISTINCT FROM NEW.zs_majsrc OR
	  OLD.zs_abddate IS DISTINCT FROM NEW.zs_abddate OR
	  OLD.zs_abdsrc IS DISTINCT FROM NEW.zs_abdsrc OR
	  OLD.geom IS DISTINCT FROM NEW.geom
     ) THEN
    NEW.zs_majdate := now();
  END IF;
  RETURN new;
END;
$$;

DROP TRIGGER IF EXISTS trg_update_majdate_t_zsro ON gracethd_metis.t_zsro;
CREATE TRIGGER trg_update_majdate_t_zsro
BEFORE UPDATE ON gracethd_metis.t_zsro
FOR EACH ROW EXECUTE PROCEDURE fn_update_majdate_t_zsro ();
