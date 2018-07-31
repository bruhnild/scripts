--- Schema : gracethd_metis
--- Table : t_zpbo_patch201
--- Traitement : Initialise la table t_zpbo_patch201 en insérant les valeurs des tables d'origine (psd_orange.nro_hsn_phase1_point_2154/sro_hsn_point_2154) dans t_zpbo_patch201


TRUNCATE gracethd_metis.t_zpbo_patch201 CASCADE;

INSERT INTO gracethd_metis.t_zpbo_patch201 ( 
	zp_code
	,zp_bp_code
)

SELECT 
	zp_code -- REFERENCES t_zpbo(zp_code),
	,zp_bp_code -- REFERENCES t_ebp(bp_code), --ajout prévision 2.1
FROM 
