CREATE OR REPLACE VIEW rbal.v_ctrl_liaison_out_bal_locaux AS
SELECT row_number() OVER (ORDER BY a.liaison_id) AS gid,
    a.liaison_id,
    a.objet_deco,
    a.geom
   FROM ( SELECT DISTINCT ON (liaison.liaison_id) liaison.liaison_id,
            array_to_string(ARRAY[liaison_bal.objet_deco_bal, liaison_locaux.objet_deco_locaux], ','::text, '*'::text) AS objet_deco,
            liaison.geom
           FROM rbal.liaison_hsn_linestring_2154 liaison
             LEFT JOIN ( SELECT a_1.liaison_id,
                    a_1.objet_deco AS objet_deco_bal
                   FROM ( WITH liaison_bal AS (
                                 SELECT hp.liaison_id,
                                    'BAL'::character varying AS objet_deco,
                                    hp.geom
                                   FROM rbal.liaison_hsn_linestring_2154 hp
                                  WHERE NOT (hp.liaison_id::text IN ( SELECT p.liaison_id
   FROM rbal.liaison_hsn_linestring_2154 p,
    rbal.bal_hsn_point_2154 h
  WHERE st_dwithin(h.geom, p.geom, 0.1::double precision)))
                                )
                         SELECT liaison_bal_1.liaison_id,
                            liaison_bal_1.objet_deco,
                            liaison_bal_1.geom
                           FROM liaison_bal liaison_bal_1) a_1) liaison_bal ON liaison_bal.liaison_id::text = liaison.liaison_id::text
             LEFT JOIN ( SELECT a_1.liaison_id,
                    a_1.objet_deco AS objet_deco_locaux
                   FROM ( WITH liaison_locaux AS (
                                 SELECT hp.liaison_id,
                                    'Locaux HSN'::character varying AS objet_deco,
                                    hp.geom
                                   FROM rbal.liaison_hsn_linestring_2154 hp
                                  WHERE NOT (hp.liaison_id::text IN ( SELECT p.liaison_id
   FROM rbal.liaison_hsn_linestring_2154 p,
    psd_orange.locaux_hsn_sian_zanro_point_2154 h
  WHERE st_dwithin(h.geom, p.geom, 0.1::double precision)))
                                )
                         SELECT liaison_locaux_1.liaison_id,
                            liaison_locaux_1.objet_deco,
                            liaison_locaux_1.geom
                           FROM liaison_locaux liaison_locaux_1) a_1) liaison_locaux ON liaison_locaux.liaison_id::text = liaison.liaison_id::text) a
  WHERE a.objet_deco ~~ 'BAL,Locaux HSN'::text AND a.geom IS NOT NULL;
  
--- Schema : rbal
--- Vue : v_liaison_out
--- Traitement : Vue qui contient pour id_liaison les déconnexions bal/ban/locaux

CREATE OR REPLACE VIEW rbal.v_ctrl_liaison_out AS
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

