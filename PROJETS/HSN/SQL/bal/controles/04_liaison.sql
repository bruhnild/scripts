--- Schema : rbal
--- Vue : v_liaison_hsn_linestring_2154

CREATE OR REPLACE VIEW rbal.v_liaison_hsn_linestring_2154 AS
SELECT liaison_id, geom, commentair, id_locaux, id_ban
FROM rbal.liaison_hsn_linestring_2154;

--- Schema : rbal
--- Table : liaison_hsn_linestring_2154
--- Traitement : Mise à jour du champ id_locaux à chaque nouvelle liaison


CREATE OR REPLACE FUNCTION fn_update_liaison_id_locaux()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.liaison_hsn_linestring_2154 a
SET    id_locaux=id
FROM   psd_orange.locaux_hsn_sian_zanro_point_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.1) ;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_liaison_id_locaux ON rbal.liaison_hsn_linestring_2154;
DROP TRIGGER IF EXISTS trg_update_liaison_id_locaux ON psd_orange.locaux_hsn_sian_zanro_point_2154;
CREATE TRIGGER trg_update_liaison_id_locaux
AFTER INSERT OR UPDATE OF geom
ON rbal.liaison_hsn_linestring_2154
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_liaison_id_locaux();

--- Schema : rbal
--- Table : liaison_hsn_linestring_2154
--- Traitement : Mise à jour du champ id_ban à chaque nouvelle liaison

CREATE OR REPLACE FUNCTION fn_update_liaison_id_ban()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.liaison_hsn_linestring_2154 a
SET    id_ban=id
FROM   ban.hsn_point_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.1) ;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_liaison_id_ban ON rbal.liaison_hsn_linestring_2154;
DROP TRIGGER IF EXISTS trg_update_liaison_id_ban ON ban.hsn_point_2154;
CREATE TRIGGER trg_update_liaison_id_ban
AFTER INSERT OR UPDATE OF geom
ON rbal.liaison_hsn_linestring_2154
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_liaison_id_ban();

--- Schema : rbal
--- Table : liaison_hsn_linestring_2154
--- Traitement : Mise à jour du champ ad_code à chaque nouvelle liaison

CREATE OR REPLACE FUNCTION fn_update_liaison_ad_code()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.liaison_hsn_linestring_2154 a
SET    ad_code=b.ad_code
FROM   rbal.bal_hsn_point_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.1) ;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_liaison_ad_code ON rbal.liaison_hsn_linestring_2154;
DROP TRIGGER IF EXISTS trg_update_liaison_ad_code ON rbal.bal_hsn_point_2154;
CREATE TRIGGER trg_update_liaison_ad_code
AFTER INSERT OR UPDATE OF geom
ON rbal.liaison_hsn_linestring_2154
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_liaison_ad_code();

--- Schema : rbal
--- Vue : v_liaison_out
--- Traitement : Vue qui contient pour id_liaison les déconnexions bal/ban/locaux

CREATE OR REPLACE VIEW rbal.v_liaison_out AS
SELECT ROW_NUMBER() OVER(ORDER BY liaison_id) gid, *
FROM
(SELECT distinct on (liaison.liaison_id) liaison.liaison_id,  array_to_string(ARRAY[objet_deco_bal, objet_deco_ban, objet_deco_locaux], ',', '*') AS objet_deco,  geom 
FROM rbal.liaison_hsn_linestring_2154 as liaison
LEFT JOIN 
(SELECT liaison_id, objet_deco as objet_deco_bal
FROM
(WITH liaison_bal AS
(
SELECT 
  hp.liaison_id,
  'BAL'::varchar as objet_deco,
  hp.geom
FROM
  rbal.liaison_hsn_linestring_2154 as hp
WHERE
  hp.liaison_id NOT IN 
  (
    SELECT 
      p.liaison_id
    FROM 
      rbal.liaison_hsn_linestring_2154 as p,
      rbal.bal_hsn_point_2154 as h
      WHERE ST_DWithin(h.geom, p.geom, 0.1) 
  ))
SELECT * FROM liaison_bal)a)liaison_bal ON liaison_bal.liaison_id=liaison.liaison_id

LEFT JOIN 
(SELECT liaison_id, objet_deco as objet_deco_ban
FROM
(WITH liaison_ban AS
(
  SELECT 
  hp.liaison_id,
  'BAN'::varchar as objet_deco,
  hp.geom
FROM
  rbal.liaison_hsn_linestring_2154 as hp
WHERE
  hp.liaison_id NOT IN 
  (
    SELECT 
      p.liaison_id
    FROM 
      rbal.liaison_hsn_linestring_2154 as p,
      ban.hsn_point_2154 as h
      WHERE ST_DWithin(h.geom, p.geom, 0.1) 
  ))
SELECT * FROM liaison_ban)a)liaison_ban ON liaison_ban.liaison_id=liaison.liaison_id

LEFT JOIN 
(SELECT liaison_id, objet_deco as objet_deco_locaux
FROM
(WITH liaison_locaux AS
(SELECT
  hp.liaison_id,
  'Locaux HSN'::varchar as objet_deco,
  hp.geom
FROM
  rbal.liaison_hsn_linestring_2154 as hp
WHERE
  hp.liaison_id NOT IN 
  (
    SELECT 
      p.liaison_id
    FROM 
      rbal.liaison_hsn_linestring_2154 as p,
      psd_orange.locaux_hsn_sian_zanro_point_2154 as h
      WHERE ST_DWithin(h.geom, p.geom, 0.1) 
  ))
SELECT * FROM liaison_locaux)a)liaison_locaux ON liaison_locaux.liaison_id=liaison.liaison_id)a
WHERE objet_deco NOT LIKE '*,*,*' AND geom IS NOT NULL; 

