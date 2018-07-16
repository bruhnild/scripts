/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 26/06/2018
Objet : Création de la vue v_bal_ad_isole pour calculer le champ ad_isole
Modification : Nom : ///// - Date : date_de_modif - Motif/nature : //////

Sources:  rbal.bal_hsn_point_2154 (construction = 'En construction alors 'N')/
		  rbal.bal_hsn_point_2154 (destruction = 'Site inexistant ou bati sans logement alors 'S')/
		  rbal.v_bal_nb_prises_totale (nb_prises_totale = 0 alors 'S')/
          rbal.racco_hsn_linestring_2154 (connexion = E) 
          reste :  à créer (C)
-------------------------------------------------------------------------------------
*/
CREATE OR REPLACE VIEW rbal.v_bal_statut AS
SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, *
FROM
(
/*
-------------------------------------------------------------------------------------
TOUT CE QUI N'EST PAS EN N, S, E
-------------------------------------------------------------------------------------
*/

SELECT 
  hp.ad_code,
  'C'::varchar as statut
  FROM
  rbal.bal_hsn_point_2154 as hp
WHERE
  hp.ad_code NOT IN
  

(SELECT ad_code FROM 
(WITH statut AS
(

(SELECT ad_code, statut FROM 
(WITH statut_n_s AS
((SELECT ad_code, statut FROM 
(WITH bal_statut AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	(CASE WHEN construction LIKE 'En construction' THEN 'N'
WHEN destruction LIKE  'Site inexistant ou bati sans logement' THEN 'S' 
END)::varchar as statut
	
FROM rbal.bal_hsn_point_2154 a)
SELECT * FROM bal_statut
WHERE statut IS NOT NULL
ORDER BY statut)a)
 
UNION ALL 
 

(SELECT ad_code, statut 
FROM (WITH nb_prises_s AS 
(SELECT a.ad_code, (CASE WHEN nb_prises_totale = 0 THEN 'S' END)::varchar as statut
FROM rbal.v_bal_nb_prises_totale a) 
SELECT * FROM nb_prises_s WHERE statut IS NOT NULL)a WHERE ad_code NOT IN 
(SELECT ad_code FROM 
(WITH bal_statut AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	(CASE WHEN construction LIKE 'En construction' THEN 'N'
WHEN destruction LIKE  'Site inexistant ou bati sans logement' THEN 'S' 
END)::varchar as statut
	
FROM rbal.bal_hsn_point_2154 a)
SELECT * FROM bal_statut
WHERE statut IS NOT NULL
ORDER BY statut)a)))
SELECT * FROM statut_n_s


WHERE ad_code NOT IN 

(SELECT ad_code FROM
(WITH bal_statut AS
(SELECT a.geom, (CASE WHEN EXISTS (SELECT distinct on (liaison_id) liaison_id
				  FROM rbal.liaison_hsn_linestring_2154 c ) THEN 'E' END)::varchar as statut
	
FROM rbal.bal_hsn_point_2154 a)
SELECT DISTINCT ON (ad_code) ad_code, statut FROM bal_statut,  rbal.liaison_hsn_linestring_2154 b
WHERE ST_DWithin(bal_statut.geom, b.geom, 0.001) AND id_locaux IS NOT NULL 
)a
))a)


UNION ALL


(SELECT ad_code, statut FROM
(WITH bal_statut AS
(SELECT a.geom, (CASE WHEN EXISTS (SELECT distinct on (liaison_id) liaison_id
				  FROM rbal.liaison_hsn_linestring_2154 c ) THEN 'E' END)::varchar as statut
	
FROM rbal.bal_hsn_point_2154 a)
SELECT DISTINCT ON (ad_code) ad_code, statut FROM bal_statut,  rbal.liaison_hsn_linestring_2154 b
WHERE ST_DWithin(bal_statut.geom, b.geom, 0.001) AND id_locaux IS NOT NULL 
)a)
)
SELECT * FROM statut)a)

/*
-------------------------------------------------------------------------------------
TOUT CE QUI EST EN N, S, E
-------------------------------------------------------------------------------------
*/

-----------------STATUT 
UNION ALL 
-----------------STATUT 


-----------------STATUT AVEC BAL : N/S
(SELECT ad_code, statut FROM 
(WITH statut AS
(
-- construction/destruction
(SELECT ad_code, statut FROM 
(WITH statut_n_s AS
((SELECT ad_code, statut FROM 
(WITH bal_statut AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	(CASE WHEN construction LIKE 'En construction' THEN 'N'
WHEN destruction LIKE  'Site inexistant ou bati sans logement' THEN 'S' 
END)::varchar as statut
	
FROM rbal.bal_hsn_point_2154 a)
SELECT * FROM bal_statut
WHERE statut IS NOT NULL
ORDER BY statut)a)
 
UNION ALL 
 
-- nombre de prises = 0
(SELECT ad_code, statut 
FROM (WITH nb_prises_s AS 
(SELECT a.ad_code, (CASE WHEN nb_prises_totale = 0 THEN 'S' END)::varchar as statut
FROM rbal.v_bal_nb_prises_totale a) 
SELECT * FROM nb_prises_s WHERE statut IS NOT NULL)a WHERE ad_code NOT IN 
(SELECT ad_code FROM 
(WITH bal_statut AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	(CASE WHEN construction LIKE 'En construction' THEN 'N'
WHEN destruction LIKE  'Site inexistant ou bati sans logement' THEN 'S' 
END)::varchar as statut
	
FROM rbal.bal_hsn_point_2154 a)
SELECT * FROM bal_statut
WHERE statut IS NOT NULL
ORDER BY statut)a)))
SELECT * FROM statut_n_s


WHERE ad_code NOT IN 

(SELECT ad_code FROM
(WITH bal_statut AS
(SELECT a.geom, (CASE WHEN EXISTS (SELECT distinct on (liaison_id) liaison_id
				  FROM rbal.liaison_hsn_linestring_2154 c ) THEN 'E' END)::varchar as statut
	
FROM rbal.bal_hsn_point_2154 a)
SELECT DISTINCT ON (ad_code) ad_code, statut FROM bal_statut,  rbal.liaison_hsn_linestring_2154 b
WHERE ST_DWithin(bal_statut.geom, b.geom, 0.001) AND id_locaux IS NOT NULL 
)a
))a)

-----------------STATUT AVEC LIAISON
UNION ALL
-----------------STATUT AVEC LIAISON

(SELECT ad_code, statut FROM
(WITH bal_statut AS
(SELECT a.geom, (CASE WHEN EXISTS (SELECT distinct on (liaison_id) liaison_id
				  FROM rbal.liaison_hsn_linestring_2154 c ) THEN 'E' END)::varchar as statut
	
FROM rbal.bal_hsn_point_2154 a)
SELECT DISTINCT ON (ad_code) ad_code, statut FROM bal_statut,  rbal.liaison_hsn_linestring_2154 b
WHERE ST_DWithin(bal_statut.geom, b.geom, 0.001) AND id_locaux IS NOT NULL 
)a)
)
SELECT * FROM statut)a)
)a
;
 

