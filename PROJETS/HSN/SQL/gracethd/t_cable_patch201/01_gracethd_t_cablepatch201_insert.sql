--- Schema : gracethd_metis
--- Table : t_cable_patch201
--- Traitement : Initialise la table t_cable_patch201 en insérant les valeurs de la table d'origine (avp.cable) dans t_cable_patch201

TRUNCATE gracethd_metis.t_cable_patch201 CASCADE;

INSERT INTO gracethd_metis.t_cable_patch201 ( 
	cb_code 
	,cb_bp1 
	,cb_ba1 
	,cb_bp2 
	,cb_ba2 
)

SELECT
	concat('CB700', digt_6, digt_7, digt_8, digt_9, to_char(id, 'FM00000')) AS cb_code
	,cb_bp1 -- REFERENCES t_ebp(bp_code)
	,cb_ba1 -- REFERENCES t_baie(ba_code)
	,cb_bp2 -- REFERENCES t_ebp(bp_code)
	,cb_ba2 -- REFERENCES t_baie(ba_code)
FROM avp.cable