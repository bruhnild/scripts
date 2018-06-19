	
INSERT INTO rbal.t_adresse ( 
	ad_code,
	ad_ban_id, 
	ad_numero, 
	ad_rep, 
	ad_nblhab, 
	ad_nblpro, 
	ad_racc, 
	ad_nombat, 
	ad_comment, 
	ad_creadat, 
	geom
)
SELECT
	ad_code,
	ad_ban_id, 
	ad_numero, 
	ad_rep,  
	ad_nblhab, 
	ad_nblpro, 
	ad_racc, 
	ad_nombat, 
	ad_comment, 
	ad_creadat, 
	geom
FROM rbal.bal_hsn_point_2154

;

/*
INSERT INTO rbal.t_adresse ( 
	ad_code,
	ad_ban_id, 
	ad_numero, 
	ad_rep, 
	ad_nblhab, 
	ad_nblpro, 
	ad_racc, 
	ad_nombat, 
	ad_comment, 
	ad_creadat, 
	statut, 
	geom
)
SELECT
	concat('AD700',nextval_special()) ad_code,
	ad_ban_id, 
	ad_numero, 
	ad_rep,  
	ad_nblhab, 
	ad_nblpro, 
	ad_racc, 
	ad_nombat, 
	ad_comment, 
	ad_creadat, 
	(case 
	when construction like 'En construction' then 'N'
	when construction like 'Existant' then 'N'
	when destruction like 'Supprimé' then 'S'
	when  destruction like 'Existant' then 'E' end) as statut, 
	geom
FROM rbal.bal_hsn_point_2154 

;
*/