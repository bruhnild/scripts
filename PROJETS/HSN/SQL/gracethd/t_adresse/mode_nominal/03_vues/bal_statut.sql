CREATE OR REPLACE VIEW rbal.v_bal_statut AS
SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, *
FROM
(
SELECT 
  hp.ad_code,
  'C'::varchar as statut
  FROM
  rbal.bal_hsn_point_2154 as hp
WHERE
  hp.ad_code NOT IN
 
----------------------------------------------------
-- Tout ce qui n'est pas contenu dans 'N', 'S' et 'E'
(SELECT ad_code
FROM
(WITH statut_s_n_s AS

-- statut = En construction/Supprimé
(SELECT ad_code, statut FROM 
(WITH bal_statut AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	(CASE WHEN construction LIKE 'En construction' THEN 'N'
WHEN destruction LIKE  'Supprimé' THEN 'S' 
END)::varchar as statut
	
FROM rbal.bal_hsn_point_2154 a)
SELECT * FROM bal_statut
WHERE statut IS NOT NULL
ORDER BY statut)a

WHERE a.ad_code NOT IN 

(SELECT ad_code FROM
(WITH bal_statut AS
(SELECT a.geom, (CASE WHEN EXISTS (SELECT distinct on (liaison_id) liaison_id
				  FROM rbal.liaison_hsn_linestring_2154 c ) THEN 'E' END)::varchar as statut
	
FROM rbal.bal_hsn_point_2154 a)
SELECT DISTINCT ON (ad_code) ad_code, statut FROM bal_statut,  rbal.liaison_hsn_linestring_2154 b
WHERE ST_DWithin(bal_statut.geom, b.geom, 0.001) AND id_locaux IS NOT NULL 
)a
)


UNION ALL
-- statut = Existant
SELECT ad_code, statut FROM
(WITH bal_statut AS
(SELECT a.geom, (CASE WHEN EXISTS (SELECT distinct on (liaison_id) liaison_id
				  FROM rbal.liaison_hsn_linestring_2154 c ) THEN 'E' END)::varchar as statut
	
FROM rbal.bal_hsn_point_2154 a)
SELECT DISTINCT ON (ad_code) ad_code, statut FROM bal_statut,  rbal.liaison_hsn_linestring_2154 b
WHERE ST_DWithin(bal_statut.geom, b.geom, 0.001) AND id_locaux IS NOT NULL 
)a)
SELECT * FROM statut_s_n_s)a)

------------------------------------------------------
-- Tout ce qui est contenu dans 'N', 'S' et 'E'

UNION ALL 


SELECT ad_code, statut
FROM
(WITH statut_s_n_s AS

-- statut = En construction/Supprimé
(SELECT ad_code, statut FROM 
(WITH bal_statut AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	(CASE WHEN construction LIKE 'En construction' THEN 'N'
WHEN destruction LIKE  'Supprimé' THEN 'S' 
END)::varchar as statut
	
FROM rbal.bal_hsn_point_2154 a)
SELECT * FROM bal_statut
WHERE statut IS NOT NULL
ORDER BY statut)a

WHERE a.ad_code NOT IN 

(SELECT ad_code FROM
(WITH bal_statut AS
(SELECT a.geom, (CASE WHEN EXISTS (SELECT distinct on (liaison_id) liaison_id
				  FROM rbal.liaison_hsn_linestring_2154 c ) THEN 'E' END)::varchar as statut
	
FROM rbal.bal_hsn_point_2154 a)
SELECT DISTINCT ON (ad_code) ad_code, statut FROM bal_statut,  rbal.liaison_hsn_linestring_2154 b
WHERE ST_DWithin(bal_statut.geom, b.geom, 0.001) AND id_locaux IS NOT NULL 
)a
)


UNION ALL
-- statut = Existant
SELECT ad_code, statut FROM
(WITH bal_statut AS
(SELECT a.geom, (CASE WHEN EXISTS (SELECT distinct on (liaison_id) liaison_id
				  FROM rbal.liaison_hsn_linestring_2154 c ) THEN 'E' END)::varchar as statut
	
FROM rbal.bal_hsn_point_2154 a)
SELECT DISTINCT ON (ad_code) ad_code, statut FROM bal_statut,  rbal.liaison_hsn_linestring_2154 b
WHERE ST_DWithin(bal_statut.geom, b.geom, 0.001) AND id_locaux IS NOT NULL 
)a)
SELECT * FROM statut_s_n_s)a)a
  
