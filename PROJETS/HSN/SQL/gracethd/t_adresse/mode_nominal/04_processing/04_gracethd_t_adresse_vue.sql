/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 26/06/2018
Objet : Création de la vue v_adresse au format grace_thd
Modification : Nom : ///// - Date : date_de_modif - Motif/nature : //////

-------------------------------------------------------------------------------------
*/

------==========================================================================------
------= ETAPE 1 : CREATION DE LA SEQUENCE UNIQUE ad_code  =------
/*
-------------------------------------------------------------------------
ad_code : XX DD G NS NNNNNNN

où

XX : Classe de l’objet (par exemple AD pour la table adresse)

DD : code du département (ici 70 pour HSN)

G : Identifiant du créateur de l’objet => 0 pour le Bureau d’Etudes ARTELIA / METIS

N : identifiant de A à Z pour le NRO (par exemple B pour le NRO N070GAY)

S : identifiant de A à Z pour le SRO (par exemple I pour le SRO N070GAY_S03I) ou le chiffre 0 pour les objets liés au Transport (car un cheminement transport est propre à un NRO et pas à un SRO)

NNNNNNN : nombre incrémental – Libre : le groupement choisi librement son choix (par exemple 000001 pour la première entité d’une table)

Soit le code ‘AD700BI000001’ pour le premier objet de la t_adresse (en supposant qu’il se trouve dans la zone du SRO N070GAY_S03I)
-------------------------------------------------------------------------
*/
------==========================================================================------
	
-- DROP SEQUENCE IF EXISTS rbal.bal_incrementation_ad_seq;
-- CREATE SEQUENCE rbal.bal_incrementation_ad_seq
--   INCREMENT 1
--   MINVALUE 000000000
--   MAXVALUE 999999999
--   START 1
--   CACHE 1;
-- ALTER TABLE rbal.bal_hsn_point_2154 OWNER TO postgres;

-- CREATE OR REPLACE FUNCTION
-- nextval_special()
-- RETURNS TEXT
-- LANGUAGE sql
-- AS
-- $$
--     SELECT to_char(nextval('rbal.bal_incrementation_ad_seq'), 'FM00000'); 
-- $$;

------==========================================================================------
------= ETAPE 2 : CREATION DE LA VUE v_adresse AU FORMAT GRACETHD=------
------==========================================================================------
--- Schema : rbal
--- Vue : v_adresse
--- Traitement : Crée la vue v_adresse à partir de la vue matérialisée vm_bal_columns_gracethdview
CREATE OR REPLACE VIEW rbal.v_adresse AS
SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, *
FROM
(
SELECT
	a.ad_code as ad_code_bal,
	concat('AD700', digt_6, digt_7, digt_8, digt_9, to_char(a.ad_code, 'FM00000')) as ad_code , 
	ad_ban_id, 
	ad_nomvoie, 
	ad_fantoir, 
	ad_numero, 
	ad_rep, 
	ad_insee, 
	ad_postal, 
	NULL::varchar as ad_alias, 
	ad_nom_ld, 
	ad_x_ban, 
	ad_y_ban, 
	ad_commune, 
	NULL::varchar as ad_section, 
	ad_idpar, 
	ad_x_parc, 
	ad_y_parc, 
	NULL::boolean as ad_nat, 
	ad_nblhab, 
	ad_nblpro, 
	ad_nbprhab, 
	ad_nbprpro, 
	NULL::varchar as ad_rivoli, 
	NULL::varchar as ad_hexacle, 
	NULL::varchar as ad_hexaclv, 
	ad_distinf, 
	ad_isole, 
	NULL::boolean as ad_prio, 
	(CASE WHEN ad_racc LIKE '91' OR ad_racc LIKE '92' THEN '9' ELSE ad_racc END)::varchar as ad_racc,
	NULL::varchar as ad_batcode, 
	ad_nombat, 
	NULL::varchar as ad_ietat, 
	ad_itypeim, 
	ad_imneuf, 
	NULL::date as ad_idatimn, 
	NULL::varchar as ad_prop, 
	NULL::varchar as ad_gest, 
	NULL::date as ad_idatsgn, 
	NULL::boolean as ad_iaccgst, 
	NULL::date as ad_idatcab, 
	NULL::date as ad_idatcom, 
	NULL::varchar as ad_typzone, 
	(CASE 
	 WHEN ad_racc LIKE '91' THEN 'Aero-souterrain ENEDIS' 
	 WHEN ad_racc LIKE '92' THEN 'Aero-souterrain Orange' ELSE ad_comment END)::varchar as ad_comment, 
	NULL::numeric as ad_geolqlt, 
	NULL::varchar as ad_geolmod, 
	NULL::varchar as ad_geolsrc, 
	now() as ad_creadat, 
	NULL::timestamp as ad_majdate, 
	NULL::timestamp as ad_majsrc, 
	NULL::date as ad_abddate, 
	NULL::varchar as ad_abdsrc, 
	nom_sro, 
	nb_prises_totale, 
	(CASE 
	 WHEN nb_prises_totale =0 THEN 'S' 
	 ELSE statut END)::varchar as statut, 
	b.cas_particuliers,
	nom_id, 
	nom_pro, 
	typologie_pro,
	x, 
	y, 
	potentiel_ftte, 
	geom
	FROM rbal.vm_bal_columns_gracethdview a
	LEFT JOIN rbal.v_bal_cas_particuliers b ON a.ad_code=b.ad_code)a;



------=============================================================================------
------= ETAPE 3 : CREATION DE LA VUE v_adresse_export_csv (nouvel ordre des champs=------
------=============================================================================------

CREATE OR REPLACE VIEW rbal.v_adresse_export AS
SELECT
nom_id, 
nom_sro,
ad_code,
ad_numero,
ad_rep,
ad_nomvoie,
ad_nom_ld,
ad_commune,
ad_postal,
ad_insee,
x,
y,
ad_fantoir,
ad_ban_id,
ad_x_ban, 
ad_y_ban, 
ad_idpar, 
ad_x_parc, 
ad_y_parc, 
ad_nombat,
ad_rivoli, 
ad_hexacle, 
ad_hexaclv, 
ad_nblhab, 
ad_nblpro, 
ad_nbprhab, 
ad_nbprpro, 	
nb_prises_totale, 
potentiel_ftte, 
ad_comment,
ad_racc, 
ad_itypeim, 
ad_imneuf, 
ad_idatimn, 
ad_prop, 
ad_gest, 
ad_idatsgn, 
ad_iaccgst, 
ad_isole, 
statut, 
cas_particuliers,	
ad_creadat, 
ad_majdate, 
ad_majsrc, 
ad_abddate, 
ad_abdsrc, 
nom_pro,
typologie_pro, 
ad_typzone, 
ad_geolqlt, 
ad_geolsrc,
geom
FROM rbal.v_adresse;



