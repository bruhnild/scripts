--- Schema : gracethd_metis
--- Table : t_cond_chem
--- Traitement : Initialise la table t_cond_chem en insérant les valeurs de la table d'origine (orange.ft_arciti_hsn_linestring_2154) dans t_conduite

TRUNCATE gracethd_metis.t_cond_chem CASCADE;

INSERT INTO gracethd_metis.t_cond_chem ( 
	dm_cd_code
	, dm_cm_code
	, dm_creadat 
)

SELECT
	dm_cd_code -- REFERENCES t_conduite(cd_code),
	, dm_cm_code -- REFERENCES t_cheminement(cm_code),
	, dm_creadat 
FROM orange.ft_arciti_hsn_linestring_2154