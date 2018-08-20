--- Schema : gracethd_metis
--- Table : t_reference
--- Traitement : Initialise la table t_reference

TRUNCATE gracethd_metis.t_reference CASCADE;

INSERT INTO gracethd_metis.t_reference ( 
	rf_code
	, rf_type
	, rf_fabric
	, rf_etat
	, rf_creadat
)

SELECT
	'RF700010100001' AS rf_code
	, 'CA' AS rf_type
	, 'OR700000000000' AS rf_fabric
	, 'N' AS rf_etat
	, now() AS rf_creadat
;