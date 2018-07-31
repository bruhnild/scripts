--- Schema : gracethd_metis
--- Table : t_ltech_patch201
--- Traitement : Initialise la table t_ltech_patch201 à partir de ??

TRUNCATE gracethd_metis.t_ltech_patch201 CASCADE;

INSERT INTO gracethd_metis.t_ltech_patch201 ( 
	lt_code -- VARCHAR(254) NOT NULL REFERENCES t_ltech(lt_code),
	, lt_bat -- VARCHAR(100), --Bâtiment (NULL si adresse = bâtiment)
	, lt_escal -- VARCHAR (20), --Escalier (NULL si adresse = entrée)
	, lt_etage -- VARCHAR (20), --Etage du local
)
SELECT
	'??'
FROM ??
