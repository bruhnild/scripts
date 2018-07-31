select * from gracethd_metis.t_organisme

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
	'ORMB0000000001' AS or_code
	,'ORANGE' AS or_nom 
	,'SA à conseil d''administration' AS or_type 
	,'Télécommunications filaires (6110Z)' AS or_activ 
	,'FRTE' AS or_l331 
	,'38013000000000' AS or_siret
	,'RUE OLIVIER DE SERRES' AS or_nomvoie
	,'78' AS or_numero  
	,'75505' AS or_postal
	,'PARIS CEDEX 15' AS or_commune
	,now() AS or_creadat
	
	;
	
	INSERT INTO gracethd_metis.t_organisme(
	or_code 
	,or_nom
	,or_creadat	

	)
SELECT 
	'OR700000000000' AS or_code
	,'HSN' AS or_nom
	,now() AS or_creadat
	
	; 