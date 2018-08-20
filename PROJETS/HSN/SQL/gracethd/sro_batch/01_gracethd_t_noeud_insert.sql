-- Schema : gracethd_metis
-- Table : t_noeud
-- Traitement : Initialise la table t_noeud en insérant les valeurs des tables d'origine (psd_orange.nro_hsn_phase1_point_2154/sro_hsn_point_2154) dans t_noeud


TRUNCATE gracethd_metis.t_noeud CASCADE;

-- Donnée issue de la table v_noeud (chambre, boite, nro, sro)
INSERT INTO gracethd_metis.t_noeud (  
	nd_code 
	, nd_codeext
	, nd_type
	, nd_r1_code 
	, nd_r2_code 
	, nd_r3_code
	, nd_geolsrc
	, nd_creadat
	, geom
)
	SELECT  
		nd_code
		, nd_codeext
		, nd_type
		, nd_r1_code
		, nd_r2_code
		, nd_r3_code
		, nd_geolsrc
		, nd_creadat
		, geom
	FROM gracethd_metis.v_noeud v;