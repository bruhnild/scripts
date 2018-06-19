/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 30/05/2018
Projet : RIP - MOE 70 - HSN
Objet : Remplissage automatique des champs de t_adresse
Modification : Nom : ///// - Date : date_de_modif - Motif/nature : //////

-------------------------------------------------------------------------------------
*/
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

/*
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

*/

--- Schema : rbal
--- Table : t_adresse
--- Traitement : Mise à jour des coordonnées X et Y

CREATE OR REPLACE FUNCTION fn_update_setXY() RETURNS TRIGGER AS $$
    DECLARE
    
    BEGIN
        NEW.x := st_X(NEW.geom);
        NEW.y := st_Y(NEW.geom);
        RETURN NEW;
    END;
$$ LANGUAGE PLPGSQL;


DROP TRIGGER IF EXISTS trg_setXY ON rbal.t_adresse;
CREATE TRIGGER fn_update_setXY
    BEFORE UPDATE OR INSERT
    ON rbal.t_adresse 
    FOR EACH ROW
    EXECUTE PROCEDURE fn_setXY();

--- Schema : rbal
--- Table : t_adresse
--- Traitement : Mise à jour du nom de la commune

CREATE OR REPLACE FUNCTION fn_update_ad_commune()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse b
SET    ad_commune=tex2
FROM   pci70_edigeo_majic.geo_commune a
WHERE  ST_CONTAINS (a.geom, b.geom) ;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_ad_commune ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_ad_commune ON pci70_edigeo_majic.geo_commune;
CREATE TRIGGER trg_update_ad_commune
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.t_adresse
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_ad_commune();

--- Schema : rbal
--- Table : t_adresse
--- Traitement : Mise à jour du code insee

CREATE OR REPLACE FUNCTION fn_update_ad_insee()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse b
SET    ad_insee=concat('70',idu)
FROM   pci70_edigeo_majic.geo_commune a
WHERE  ST_CONTAINS (a.geom, b.geom) ;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_ad_insee ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_ad_insee ON pci70_edigeo_majic.geo_commune;
CREATE TRIGGER trg_update_ad_insee
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.t_adresse
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_ad_insee();

--- Schema : rbal
--- Table : t_adresse
--- Traitement : Mise à jour du code postal

CREATE OR REPLACE FUNCTION fn_update_ad_postal()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse b
SET    ad_postal=code_postal
FROM   la_poste.codcom_codpost_correspondance_hsn_2017 a
WHERE  ad_insee=code_commune_insee;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_ad_postal ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_ad_postal ON la_poste.codcom_codpost_correspondance_hsn_2017;
CREATE TRIGGER trg_update_ad_postal
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.t_adresse
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_ad_postal();

--- Schema : rbal
--- Table : t_adresse
--- Traitement : Mise à jour de l'id parcelle

CREATE OR REPLACE FUNCTION fn_update_ad_idpar()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse b
SET    ad_idpar=geo_parcelle
FROM   pci70_edigeo_majic.geo_parcelle a
WHERE  ST_CONTAINS (a.geom, b.geom);
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_ad_idpar ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_ad_idpar ON pci70_edigeo_majic.geo_parcelle;
CREATE TRIGGER trg_update_ad_idpar
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.t_adresse
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_ad_idpar();

