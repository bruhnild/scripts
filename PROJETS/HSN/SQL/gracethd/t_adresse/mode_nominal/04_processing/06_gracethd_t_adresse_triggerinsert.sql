-------------------------------------------------------------------------------------
-- Date de création : 09/04/2018
-- Objet : Triggers pour la mise à jour des champs de la table t_adresse (grace_thd)
-- Modification : Nom : ///// - Date : date_de_modif - Motif/nature : //////
-------------------------------------------------------------------------------------

DROP TRIGGER IF EXISTS trg_t_adresse_after_ed_rbal ON rbal.bal_hsn_point_2154 CASCADE;
DROP FUNCTION IF EXISTS fn_t_adresse_after_ed_rbal() CASCADE;

CREATE OR REPLACE FUNCTION fn_t_adresse_after_ed_rbal()
RETURNS TRIGGER AS $$
	BEGIN
	CASE TG_OP
		WHEN 'INSERT' THEN
			INSERT INTO gracethd_metis.t_adresse ( 
				ad_code
				, ad_ban_id
				, ad_nomvoie
				, ad_fantoir
				, ad_numero
				, ad_rep
				, ad_insee
				, ad_postal
				, ad_alias
				, ad_nom_ld
				, ad_x_ban
				, ad_y_ban
				, ad_commune
				, ad_section
				, ad_idpar
				, ad_x_parc
				, ad_y_parc
				, ad_nat
				, ad_nblhab
				, ad_nblpro
				, ad_nbprhab
				, ad_nbprpro
				, ad_rivoli
				, ad_hexacle
				, ad_hexaclv
				, ad_distinf
				, ad_isole
				, ad_prio
				, ad_racc
				, ad_batcode
				, ad_nombat
				, ad_ietat
				, ad_itypeim
				, ad_imneuf
				, ad_idatimn
				, ad_prop
				, ad_gest
				, ad_idatsgn
				, ad_iaccgst
				, ad_idatcab
				, ad_idatcom
				, ad_typzone
				, ad_comment
				, ad_geolqlt
				, ad_geolmod
				, ad_geolsrc
				, ad_creadat
				, ad_majdate
				, ad_majsrc
				, ad_abddate
				, ad_abdsrc
				, nom_sro
				, nb_prises_totale
				, statut
				, cas_particuliers
				, nom_id
				, nom_pro
				, typologie_pro
				, x
				, y
				, potentiel_ftte
				, geom
			)
			SELECT  
				ad_code
				, ad_ban_id
				, ad_nomvoie
				, ad_fantoir
				, ad_numero
				, ad_rep
				, ad_insee
				, ad_postal
				, ad_alias
				, ad_nom_ld
				, ad_x_ban
				, ad_y_ban
				, ad_commune
				, ad_section
				, ad_idpar
				, ad_x_parc
				, ad_y_parc
				, ad_nat
				, ad_nblhab
				, ad_nblpro
				, ad_nbprhab
				, ad_nbprpro
				, ad_rivoli
				, ad_hexacle
				, ad_hexaclv
				, ad_distinf
				, ad_isole
				, ad_prio
				, ad_racc
				, ad_batcode
				, ad_nombat
				, ad_ietat
				, ad_itypeim
				, ad_imneuf
				, ad_idatimn
				, ad_prop
				, ad_gest
				, ad_idatsgn
				, ad_iaccgst
				, ad_idatcab
				, ad_idatcom
				, ad_typzone
				, ad_comment
				, ad_geolqlt
				, ad_geolmod
				, ad_geolsrc
				, now() --ad_creadat
				, ad_majdate
				, ad_majsrc
				, ad_abddate
				, ad_abdsrc
				, nom_sro
				, nb_prises_totale
				, statut
				, cas_particuliers
				, nom_id
				, nom_pro
				, typologie_pro
				, x
				, y
				, potentiel_ftte
				, geom
			FROM rbal.v_adresse v
			WHERE v.ad_code_bal = NEW.ad_code 
			AND ad_racc NOT LIKE '';
		RETURN NEW;

		WHEN 'UPDATE' THEN
			IF NEW.* <> OLD.* THEN
				INSERT INTO gracethd_metis.t_adresse ( 
					ad_code
					, ad_ban_id
					, ad_nomvoie
					, ad_fantoir
					, ad_numero
					, ad_rep
					, ad_insee
					, ad_postal
					, ad_alias
					, ad_nom_ld
					, ad_x_ban
					, ad_y_ban
					, ad_commune
					, ad_section
					, ad_idpar
					, ad_x_parc
					, ad_y_parc
					, ad_nat
					, ad_nblhab
					, ad_nblpro
					, ad_nbprhab
					, ad_nbprpro
					, ad_rivoli
					, ad_hexacle
					, ad_hexaclv
					, ad_distinf
					, ad_isole
					, ad_prio
					, ad_racc
					, ad_batcode
					, ad_nombat
					, ad_ietat
					, ad_itypeim
					, ad_imneuf
					, ad_idatimn
					, ad_prop
					, ad_gest
					, ad_idatsgn
					, ad_iaccgst
					, ad_idatcab
					, ad_idatcom
					, ad_typzone
					, ad_comment
					, ad_geolqlt
					, ad_geolmod
					, ad_geolsrc
					, ad_creadat
					, ad_majdate
					, ad_majsrc
					, ad_abddate
					, ad_abdsrc
					, nom_sro
					, nb_prises_totale
					, statut
					, cas_particuliers
					, nom_id
					, nom_pro
					, typologie_pro
					, x
					, y
					, potentiel_ftte
					, geom
				)
				SELECT  
					ad_code
					, ad_ban_id
					, ad_nomvoie
					, ad_fantoir
					, ad_numero
					, ad_rep
					, ad_insee
					, ad_postal
					, ad_alias
					, ad_nom_ld
					, ad_x_ban
					, ad_y_ban
					, ad_commune
					, ad_section
					, ad_idpar
					, ad_x_parc
					, ad_y_parc
					, ad_nat
					, ad_nblhab
					, ad_nblpro
					, ad_nbprhab
					, ad_nbprpro
					, ad_rivoli
					, ad_hexacle
					, ad_hexaclv
					, ad_distinf
					, ad_isole
					, ad_prio
					, ad_racc
					, ad_batcode
					, ad_nombat
					, ad_ietat
					, ad_itypeim
					, ad_imneuf
					, ad_idatimn
					, ad_prop
					, ad_gest
					, ad_idatsgn
					, ad_iaccgst
					, ad_idatcab
					, ad_idatcom
					, ad_typzone
					, ad_comment
					, ad_geolqlt
					, ad_geolmod
					, ad_geolsrc
					, ad_creadat
					, now() --ad_majdate
					, user --ad_majsrc
					, ad_abddate
					, ad_abdsrc
					, nom_sro
					, nb_prises_totale
					, statut
					, cas_particuliers
					, nom_id
					, nom_pro
					, typologie_pro
					, x
					, y
					, potentiel_ftte
					, geom
				FROM rbal.v_adresse v
				WHERE v.ad_code_bal = NEW.ad_code
				AND ad_racc NOT LIKE '';
			END IF;
		RETURN NEW;
	ELSE NULL;
	END CASE;
	
	-- COMMIT;
	-- BEGIN;
	-- REFRESH MATERIALIZED VIEW rbal.vm_bal_columns_gracethdview;
	-- COMMIT;

	END;

$$ LANGUAGE PLPGSQL;

CREATE TRIGGER trg_t_adresse_after_ed_rbal
	AFTER INSERT OR UPDATE ON
	 rbal.bal_hsn_point_2154 FOR EACH ROW 
	 EXECUTE PROCEDURE fn_t_adresse_after_ed_rbal();
