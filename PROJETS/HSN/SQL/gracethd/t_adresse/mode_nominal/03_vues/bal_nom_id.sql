CREATE OR REPLACE VIEW rbal.v_bal_nom_id AS
WITH nom_id_all AS
(SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, *
FROM
(

-- nom_id  = NULL
SELECT 
  hp.ad_code,
  NULL::integer as nom_id
  FROM
  rbal.bal_hsn_point_2154 as hp
WHERE
  hp.ad_code NOT IN
   
(SELECT ad_code FROM 
 (WITH bal_nom_id AS
(SELECT 
	 a.ad_code,
	 id_locaux
	
FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b 
WHERE ST_DWithin(a.geom, b.geom, 0.001))
SELECT ad_code, id_locaux as nom_id FROM bal_nom_id
WHERE id_locaux IS NOT NULL)a)

UNION ALL 
-- Recupere les nom_id 
(SELECT ad_code, nom_id FROM 
 (WITH bal_nom_id AS
(SELECT 
	 a.ad_code,
	 id_locaux
	
FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b 
WHERE ST_DWithin(a.geom, b.geom, 0.001))
SELECT ad_code, id_locaux as nom_id FROM bal_nom_id
WHERE id_locaux IS NOT NULL)a))a)
SELECT nom_id_all.gid, nom_id_all.ad_code, nom_id_all.nom_id FROM nom_id_all
WHERE nom_id_all.gid NOT IN 

(SELECT gid FROM 
(WITH doublons AS
(SELECT gid, ad_code, nom_id FROM
(WITH nom_id_all AS
(SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, *
FROM
(

-- nom_id  = NULL
SELECT 
  hp.ad_code,
  NULL::integer as nom_id
  FROM
  rbal.bal_hsn_point_2154 as hp
WHERE
  hp.ad_code NOT IN
   
(SELECT ad_code FROM 
 (WITH bal_nom_id AS
(SELECT 
	 a.ad_code,
	 id_locaux
	
FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b 
WHERE ST_DWithin(a.geom, b.geom, 0.001))
SELECT ad_code, id_locaux as nom_id FROM bal_nom_id
WHERE id_locaux IS NOT NULL)a)

UNION ALL 
-- Recupere les nom_id 
(SELECT ad_code, nom_id FROM 
 (WITH bal_nom_id AS
(SELECT 
	 a.ad_code,
	 id_locaux
	
FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b 
WHERE ST_DWithin(a.geom, b.geom, 0.001))
SELECT ad_code, id_locaux as nom_id FROM bal_nom_id
WHERE id_locaux IS NOT NULL)a))a)
SELECT nom_id_all.gid, nom_id_all.ad_code, nom_id_all.nom_id FROM nom_id_all


RIGHT JOIN 


(SELECT gid, row FROM 
(WITH ad_code_doublons AS
(SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, *
FROM
(

-- nom_id  = NULL
SELECT 
  hp.ad_code,
  NULL::integer as nom_id
  FROM
  rbal.bal_hsn_point_2154 as hp
WHERE
  hp.ad_code NOT IN
   
(SELECT ad_code FROM 
 (WITH bal_nom_id AS
(SELECT 
	 a.ad_code,
	 id_locaux
	
FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b 
WHERE ST_DWithin(a.geom, b.geom, 0.001))
SELECT ad_code, id_locaux as nom_id FROM bal_nom_id
WHERE id_locaux IS NOT NULL)a)

UNION ALL 
-- Recupere les nom_id 
(SELECT ad_code, nom_id FROM 
 (WITH bal_nom_id AS
(SELECT 
	 a.ad_code,
	 id_locaux
	
FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b 
WHERE ST_DWithin(a.geom, b.geom, 0.001))
SELECT ad_code, id_locaux as nom_id FROM bal_nom_id
WHERE id_locaux IS NOT NULL)a))a)
SELECT * FROM (
   SELECT gid,
   ROW_NUMBER() OVER(PARTITION BY ad_code ORDER BY gid asc) AS Row
   FROM ad_code_doublons
 ) dups
 WHERE
 dups.Row > 1)b)b ON b.gid = nom_id_all.gid)a)
 SELECT * FROM doublons)a);
 
 