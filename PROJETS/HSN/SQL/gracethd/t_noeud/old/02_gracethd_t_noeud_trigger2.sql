DROP TRIGGER IF EXISTS tg_edit_v_noeud_st_nd ON gracethd_metis.v_noeud CASCADE;
DROP FUNCTION IF EXISTS fn_edit_v_noeud_st_nd() CASCADE;

CREATE OR REPLACE FUNCTION fn_edit_v_noeud_st_nd()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $function$
   BEGIN
      -- IF TG_OP = 'INSERT' THEN
   --      INSERT INTO  t_noeud VALUES(
   --      	NEW.nd_code
   --      	, NEW.nb_type
   --      	, NEW.r1_code
   --      	, NEW.r2_code
   --      	, NEW.r3_code
   --      	, NEW.nd_geolsrc
   --      	, NEW.nd_creadat
   --      	, NEW.geom
			-- );
   --      RETURN NEW;


  --     ELSIF TG_OP = 'UPDATE' THEN
		UPDATE t_noeud SET 
        	nd_code = NEW.nd_code
        	, nb_type = NEW.nb_type
        	, r1_code = NEW.r1_code
        	, r2_code = NEW.r2_code
        	, r3_code = NEW.r3_code
        	, nd_geolsrc = NEW.nd_geolsrc
        	, nd_creadat = NEW.nd_creadat
        	, geom = NEW.geom
		WHERE nd_code = OLD.nd_code
		;
		-- RETURN NEW;


  --     ELSIF TG_OP = 'DELETE' THEN
        -- UPDATE gracethd_metis.t_noeud
        --   SET 
        --     nd_abddate = now();
        --   RETURN NULL;
      
  --     END IF;
  --     RETURN NEW;


    END;
$function$;

CREATE TRIGGER tg_edit_v_noeud_st_nd
    -- INSTEAD OF INSERT OR UPDATE OR DELETE ON
    INSTEAD OF UPDATE ON
      gracethd_metis.v_noeud FOR EACH ROW EXECUTE PROCEDURE fn_edit_v_noeud_st_nd();