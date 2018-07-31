--- Schema : gracethd_metis
--- Trigger : fn_update_majdate_t_noeud
--- Traitement : Mets à jour le champ nd_majdate la table t_noeud à la mise à jour

CREATE OR REPLACE FUNCTION fn_update_majdate_t_noeud()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  IF (OLD.nd_code IS DISTINCT FROM NEW.nd_code OR
      OLD.nd_codeext IS DISTINCT FROM NEW.nd_codeext OR
      OLD.nd_nom IS DISTINCT FROM NEW.nd_nom OR
	  OLD.nd_coderat IS DISTINCT FROM NEW.nd_coderat OR
	  OLD.nd_r1_code IS DISTINCT FROM NEW.nd_r1_code OR
	  OLD.nd_r2_code IS DISTINCT FROM NEW.nd_r2_code OR
	  OLD.nd_r3_code IS DISTINCT FROM NEW.nd_r3_code OR
	  OLD.nd_r4_code IS DISTINCT FROM NEW.nd_r4_code OR
	  OLD.nd_voie IS DISTINCT FROM NEW.nd_voie OR
	  OLD.nd_type IS DISTINCT FROM NEW.nd_type OR
	  OLD.nd_type_ep IS DISTINCT FROM NEW.nd_type_ep OR
	  OLD.nd_comment IS DISTINCT FROM NEW.nd_comment OR
	  OLD.nd_dtclass IS DISTINCT FROM NEW.nd_dtclass OR
	  OLD.nd_geolqlt IS DISTINCT FROM NEW.nd_geolqlt OR
	  OLD.nd_geolmod IS DISTINCT FROM NEW.nd_geolmod OR
	  OLD.nd_geolsrc IS DISTINCT FROM NEW.nd_geolsrc OR
	  OLD.nd_creadat IS DISTINCT FROM NEW.nd_creadat OR
	  OLD.nd_majsrc IS DISTINCT FROM NEW.nd_majsrc OR
	  OLD.nd_abddate IS DISTINCT FROM NEW.nd_abddate OR
	  OLD.nd_abdsrc IS DISTINCT FROM NEW.nd_abdsrc OR
	  OLD.geom IS DISTINCT FROM NEW.geom
     ) THEN
    NEW.nd_majdate := now();
  END IF;
  RETURN new;
END;
$$;

DROP TRIGGER IF EXISTS trg_update_majdate_t_noeud ON gracethd_metis.t_noeud;
CREATE TRIGGER trg_update_majdate_t_noeud
BEFORE UPDATE ON gracethd_metis.t_noeud
FOR EACH ROW EXECUTE PROCEDURE fn_update_majdate_t_noeud ();
