--- Schema : gracethd_metis
--- Trigger : fn_update_majdate_t_noeud
--- Traitement : Mets à jour la table t_noeud à partir de la modification des tables métier et par le truchement de v_noeud

DROP TRIGGER IF EXISTS trg_after_ed_t_noeud_chb ON avp_n070gay.ft_chambre CASCADE;
DROP FUNCTION IF EXISTS fn_after_ed_t_noeud_chb() CASCADE;

CREATE OR REPLACE FUNCTION fn_after_ed_t_noeud_chb()
RETURNS TRIGGER AS $$
	BEGIN
	CASE TG_OP
		WHEN 'INSERT' THEN
			INSERT INTO gracethd_metis.t_noeud (  
				nd_code 
				, nd_codeext
				, nd_type
				, nd_r1_code 
				, nd_r2_code 
				, nd_r3_code
				, nd_geolsrc
				, nd_creadat
				, geom
			)
			SELECT  
				nd_code
				, nd_codeext
				, nd_type
				, nd_r1_code
				, nd_r2_code
				, nd_r3_code
				, nd_geolsrc
				, nd_creadat
				, geom
			FROM gracethd_metis.v_noeud v
			WHERE v.pt_code = concat('PT700', NEW.digt_6, NEW.digt_7, '00', to_char(NEW.gid, 'FM00000'));

		RETURN NEW;

		WHEN 'UPDATE' THEN
			IF OLD.geom IS DISTINCT FROM NEW.geom THEN 

				UPDATE gracethd_metis.t_noeud t SET 
					geom = (
					SELECT v.geom
					FROM gracethd_metis.v_noeud v
					WHERE v.pt_code = concat('PT700', NEW.digt_6, NEW.digt_7, '00', to_char(NEW.gid, 'FM00000'))
					)
					, nd_majdate = now()
					, nd_majsrc = user
				WHERE t.nd_code = (
					SELECT v.nd_code 
					FROM gracethd_metis.v_noeud v 
					WHERE v.pt_code = concat('PT700', NEW.digt_6, NEW.digt_7, '00', to_char(NEW.gid, 'FM00000'))
				);

				UPDATE avp_n070gay.ft_chambre ch SET
					code_sro_def = b.za_code_def
					FROM psd_orange.zasro_hsn_polygon_2154 b 
					WHERE ST_CONTAINS (b.geom, ch.geom);

				UPDATE avp_n070gay.ft_chambre ch SET
					code_nro_def = b.code_nro_def
					FROM psd_orange.zanro_hsn_polygon_2154 b 
					WHERE ST_CONTAINS (b.geom, ch.geom);

			END IF;

			IF OLD.pt_codeext IS DISTINCT FROM NEW.pt_codeext THEN 

				UPDATE gracethd_metis.t_noeud t SET 
					nd_codeext = (
					SELECT v.nd_codeext
					FROM gracethd_metis.v_noeud v
					WHERE v.pt_code = concat('PT700', NEW.digt_6, NEW.digt_7, '00', to_char(NEW.gid, 'FM00000'))
					)
					, nd_majdate = now()
					, nd_majsrc = user
				WHERE t.nd_code = (
					SELECT v.nd_code 
					FROM gracethd_metis.v_noeud v 
					WHERE v.pt_code = concat('PT700', NEW.digt_6, NEW.digt_7, '00', to_char(NEW.gid, 'FM00000'))
				);

			END IF;

			IF OLD.code_nro_def IS DISTINCT FROM NEW.code_nro_def THEN 

				UPDATE gracethd_metis.t_noeud t SET 
					nd_r2_code = (
					SELECT v.nd_r2_code
					FROM gracethd_metis.v_noeud v
					WHERE v.pt_code = concat('PT700', NEW.digt_6, NEW.digt_7, '00', to_char(NEW.gid, 'FM00000'))
					)
					, nd_majdate = now()
					, nd_majsrc = user
				WHERE t.nd_code = (
					SELECT v.nd_code 
					FROM gracethd_metis.v_noeud v 
					WHERE v.pt_code = concat('PT700', NEW.digt_6, NEW.digt_7, '00', to_char(NEW.gid, 'FM00000'))
				);

			END IF;

			IF OLD.code_sro_def IS DISTINCT FROM NEW.code_sro_def THEN 

				UPDATE gracethd_metis.t_noeud t SET 
					nd_r3_code = (
					SELECT v.nd_r3_code
					FROM gracethd_metis.v_noeud v
					WHERE v.pt_code = concat('PT700', NEW.digt_6, NEW.digt_7, '00', to_char(NEW.gid, 'FM00000'))
					)
					, nd_majdate = now()
					, nd_majsrc = user
				WHERE t.nd_code = (
					SELECT v.nd_code 
					FROM gracethd_metis.v_noeud v 
					WHERE v.pt_code = concat('PT700', NEW.digt_6, NEW.digt_7, '00', to_char(NEW.gid, 'FM00000'))
				);

			END IF;
			RETURN NEW;
	END CASE;
	END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER trg_after_ed_t_noeud_chb
	AFTER INSERT OR UPDATE ON
	 avp_n070gay.ft_chambre FOR EACH ROW 
	 EXECUTE PROCEDURE fn_after_ed_t_noeud_chb();




DROP TRIGGER IF EXISTS trg_before_ed_t_noeud_chb ON avp_n070gay.ft_chambre CASCADE;
DROP FUNCTION IF EXISTS fn_before_ed_t_noeud_chb() CASCADE;

CREATE OR REPLACE FUNCTION fn_before_ed_t_noeud_chb()
RETURNS TRIGGER AS $$
	BEGIN
	CASE TG_OP
		-- WHEN 'UPDATE' THEN
		-- 	IF 
		-- 		OLD.digt_6 IS DISTINCT FROM NEW.digt_6
		-- 		OR OLD.digt_7 IS DISTINCT FROM NEW.digt_7
		-- 		OR OLD.digt_8 IS DISTINCT FROM NEW.digt_8
		-- 		OR OLD.digt_9 IS DISTINCT FROM NEW.digt_9
		-- 	THEN 
		-- 		UPDATE gracethd_metis.t_noeud t SET 
		-- 			nd_r2_code = (
		-- 				SELECT v.nd_r2_code
		-- 				FROM gracethd_metis.v_noeud v
		-- 				WHERE v.pt_code = concat('PT700', NEW.digt_6, NEW.digt_7, '00', to_char(NEW.gid, 'FM00000'))
		-- 			)

		-- 			nd_r3_code = (
		-- 				SELECT
		-- 				v.nd_r3_code
		-- 				FROM gracethd_metis.v_noeud v
		-- 				WHERE v.pt_code = concat('PT700', NEW.digt_6, NEW.digt_7, '00', to_char(NEW.gid, 'FM00000'))
		-- 			)

		-- 			, nd_majdate = now()
		-- 			, nd_majsrc = user
		-- 		WHERE t.nd_code = (
		-- 			SELECT v.nd_code 
		-- 			FROM gracethd_metis.v_noeud v 
		-- 			WHERE v.pt_code = concat('PT700', NEW.digt_6, NEW.digt_7, '00', to_char(NEW.gid, 'FM00000'))
		-- 		);
		-- 	END IF;
		-- RETURN NEW;

		WHEN 'DELETE' THEN

			UPDATE gracethd_metis.t_noeud t
			  SET 
				  nd_abddate = now()
				  , nd_abdsrc = user
			    WHERE t.nd_code = (
			    	SELECT v.nd_code 
			    	FROM gracethd_metis.v_noeud v 
			    	WHERE v.pt_code = concat('PT700', OLD.digt_6, OLD.digt_7, '00', to_char(OLD.gid, 'FM00000'))
	    	);

		ELSE NULL;
	END CASE;
	RETURN NULL;
	END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER trg_before_ed_t_noeud_chb
	-- BEFORE UPDATE OR DELETE ON
	BEFORE DELETE ON
	 avp_n070gay.ft_chambre FOR EACH ROW 
	 EXECUTE PROCEDURE fn_before_ed_t_noeud_chb();