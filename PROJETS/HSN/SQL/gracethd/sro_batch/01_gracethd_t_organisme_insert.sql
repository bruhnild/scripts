-- COPY gracethd_metis.t_organisme(
-- 	or_code, 
-- 	or_nom, 
-- 	or_type, 
-- 	or_activ, 
-- 	or_l331, 
-- 	or_siret, 
-- 	or_nomvoie, 
-- 	or_numero,  
-- 	or_postal, 
-- 	or_commune, 
-- 	or_creadat
-- 	)
-- FROM '/tmp/t_organisme.csv' DELIMITER ';' CSV HEADER;

TRUNCATE gracethd_metis.t_organisme CASCADE; 
INSERT INTO gracethd_metis.t_organisme(
	or_code, 
	or_nom, 
	or_type, 
	or_activ, 
	or_l331, 
	or_siret, 
	or_nomvoie, 
	or_numero,  
	or_postal, 
	or_commune, 
	or_creadat
	)
SELECT 
	or_code, 
	or_nom, 
	or_type, 
	or_activ, 
	or_l331, 
	or_siret, 
	or_nomvoie, 
	or_numero,  
	or_postal, 
	or_commune, 
	now() AS or_creadat
	FROM gracethd_metis.t_organisme_ref
	WHERE or_nom IS NOT NULL;

