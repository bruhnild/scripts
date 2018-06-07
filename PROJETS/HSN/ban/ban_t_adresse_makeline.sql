/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 30/05/2018
Projet : RIP - MOE 70 - HSN
Objet : Relier les points ban et les point adresses (rbal) par des segments
Modification : Nom : ///// - Date : date_de_modif - Motif/nature : //////

-------------------------------------------------------------------------------------
*/

/*
-------------------------------------------------------------------------------------
CREATION SEGMENTS BAL-RBAL
-------------------------------------------------------------------------------------
*/


--- Schema : rbal
--- Vue : segment_ban_rbal
--- Traitement : Création de segments entre les points ban et points rbal en fonction de ad_ban_id (id ban)

CREATE OR REPLACE VIEW rbal.segment_ban_rbal AS 
SELECT 
	row_number() OVER (ORDER BY sub_query.ad_ban_id) AS fid,
    sub_query.ad_ban_id,
    ST_Makeline(sub_query.geom_ban, sub_query.geom_adresse) AS geom
	FROM(
	SELECT 
  	ban.id,
  	(ST_Dump(ban.geom)).geom as geom_ban, 
  	rbal.ad_ban_id,
  	(ST_Dump(rbal.centroide)).geom as geom_adresse
	FROM 
  	ban.hsn_point_2154_500 as ban,
  	rbal.t_adresse as rbal
	WHERE 
  	ban.id = rbal.ad_ban_id) AS sub_query;


/*
-------------------------------------------------------------------------------------
CREATION ad_code (NOT NULL)
-------------------------------------------------------------------------------------
*/


--- Schema : rbal
--- Table : t_adresse
--- Traitement : Incrémentation de ad_code 

--- Séquence d'incrémentations sur 9 caractères (000000001)
DROP SEQUENCE IF EXISTS rbal.t_adresse_incrementation_ad_code;
CREATE SEQUENCE rbal.t_adresse_incrementation_ad_code
  INCREMENT 1
  MINVALUE 000000000
  MAXVALUE 999999999
  START 1
  CACHE 1;
ALTER TABLE rbal.t_adresse OWNER TO postgres;

CREATE OR REPLACE FUNCTION
nextval_special()
RETURNS TEXT
LANGUAGE sql
AS
$$
    SELECT to_char(nextval('rbal.t_adresse_incrementation_ad_code'), 'FM000000000'); 
$$;

--- Mise à jour du champs ad_code
UPDATE rbal.t_adresse  SET ad_code = concat('AD700',nextval_special());

/*
-------------------------------------------------------------------------------------
TRIGGERS
-------------------------------------------------------------------------------------
*/
--- Schema : rbal
--- Table : t_adresse
-- Met à jour le champ id_opp de numerisation à la création d'entités
CREATE OR REPLACE FUNCTION fn_update_ad_code() RETURNS TRIGGER AS $$
BEGIN

    NEW.ad_code :=  'AD' ||mAX(CAST(REPLACE(REPLACE(ad_code, 'AD', ''), '', '') as numeric)+1)from rbal.t_adresse;
   RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

DROP TRIGGER IF EXISTS trg_update_ad_code ON rbal.t_adresse;
CREATE TRIGGER trg_update_ad_code
BEFORE INSERT OR UPDATE OF 
geom 
ON rbal.t_adresse
FOR EACH ROW EXECUTE PROCEDURE fn_update_ad_code();


--- Schema : rbal
--- Table : t_adresse
--- Traitement : Mise à jour du champ ad_nomvoie lors de l'update ou insert de nouveaux ad_code

CREATE OR REPLACE FUNCTION fn_update_ad_nomvoie()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse b
SET    ad_nomvoie=nom_voie
FROM   ban.hsn_point_2154_500 a
WHERE  b.ad_ban_id = a.id;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_ad_nomvoie ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_ad_nomvoie ON ban.hsn_point_2154_500;
CREATE TRIGGER trg_update_ad_nomvoie
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.t_adresse
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_ad_nomvoie();


--- Schema : rbal
--- Table : t_adresse
--- Traitement : Mise à jour du champ ad_numero lors de l'update ou insert de nouveaux ad_code

CREATE OR REPLACE FUNCTION fn_update_ad_numero()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse b
SET    ad_numero=numero
FROM   ban.hsn_point_2154_500 a
WHERE  b.ad_ban_id = a.id;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_ad_nomvoie ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_ad_nomvoie ON ban.hsn_point_2154_500;
CREATE TRIGGER trg_update_ad_nomvoie
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.t_adresse
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_ad_numero();




WITH fibres_capa AS 
    (SELECT  a.id, st_area(b.geom) area
    FROM  rbal.grille_500_polygon_2154 a
    LEFT JOIN pci70_edigeo_majic.geo_commune b
     ON ST_intersects (b.geom , a.geom)
    GROUP BY a.id, b.geom)
  SELECT  a.id, max(area) max_area
  FROM fibres_capa b 
  LEFT JOIN rbal.grille_500_polygon_2154 a on a.id=b.id and b.area=a.max_area
  GROUP BY a.id, max_area 