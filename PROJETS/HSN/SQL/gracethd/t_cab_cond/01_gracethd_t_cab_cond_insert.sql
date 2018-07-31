--- Schema : gracethd_metis
--- Table : t_cab_cond
--- Traitement : Initialise la table t_cab_cond en insérant les valeurs de la table d'origine (avp.cable) dans t_cab_cond

TRUNCATE gracethd_metis.t_cab_cond CASCADE;

INSERT INTO gracethd_metis.t_cab_cond ( 
	cc_cb_code 
    ,cc_cd_code 
	,cc_creadat
)

SELECT
	cc_cb_code --REFERENCES t_cable(cb_code)
	,cc_cd_code -- REFERENCES t_conduite(cd_code),
    ,now() AS cc_creadat
FROM avp.cable