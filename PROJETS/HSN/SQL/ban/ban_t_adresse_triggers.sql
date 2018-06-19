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
--- Met à jour le champ ad_code de t_adresse à la création d'entités
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
--- Traitement : Met à jour le champ ad_ban_id de t_adresse à la création d'entités

CREATE OR REPLACE FUNCTION fn_update_ad_ban_id()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse b
SET    ad_ban_id=ban_id
FROM   pci70_majic_analyses.batiment_parcelle_ban_hsn_polygon_2154 a
WHERE  ST_CONTAINS (a.geom, b.geom);
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_ad_ban_id ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_ad_ban_id ON pci70_majic_analyses.batiment_parcelle_ban_hsn_polygon_2154;
CREATE TRIGGER trg_update_ad_ban_id
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.t_adresse
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_ad_ban_id();

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
--- Traitement : Mise à jour du champ ad_rep lors de l'update ou insert de nouveaux ad_ban_id

CREATE OR REPLACE FUNCTION fn_update_ad_rep()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse b
SET    ad_rep=rep
FROM   ban.hsn_point_2154 a
WHERE  ad_ban_id=id;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;


DROP TRIGGER IF EXISTS trg_update_ad_rep ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_ad_rep ON ban.hsn_point_2154;
CREATE TRIGGER trg_update_ad_rep
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.t_adresse
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_ad_rep();

--- Schema : rbal
--- Table : t_adresse
--- Traitement : Mise à jour du champ ad_nom_ld lors de l'update ou insert de nouveaux ad_ban_id

CREATE OR REPLACE FUNCTION fn_update_ad_nom_ld()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse b
SET    ad_nom_ld=nom_ld
FROM   ban.hsn_point_2154 a
WHERE  ad_ban_id=id;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_ad_nom_ld ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_ad_nom_ld ON ban.hsn_point_2154;
CREATE TRIGGER trg_update_ad_nom_ld
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.t_adresse
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_ad_nom_ld();

--- Schema : rbal
--- Table : t_adresse
--- Traitement : Mise à jour de l'identifiant fantoir

--- Schema : rbal
--- Table : t_adresse
--- Traitement : Mise à jour de l'identifiant fantoir

CREATE OR REPLACE FUNCTION fn_update_ad_fantoir()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse b
SET    ad_fantoir=id_fantoir
FROM   ban.hsn_point_2154 a
WHERE  ad_ban_id=id;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_ad_fantoir ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_ad_fantoir ON ban.hsn_point_2154;
CREATE TRIGGER trg_update_ad_fantoir
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.t_adresse
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_ad_fantoir();

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


DROP TRIGGER IF EXISTS trg_update_setXY ON rbal.t_adresse;
CREATE TRIGGER trg_update_setXY
    BEFORE UPDATE OR INSERT
    ON rbal.t_adresse 
    FOR EACH ROW
    EXECUTE PROCEDURE fn_update_setXY();

--- Schema : rbal
--- Table : t_adresse
--- Traitement : Mise à jour des champs ad_x_ban 

CREATE OR REPLACE FUNCTION fn_update_ad_x_ban()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse b
SET    ad_x_ban=st_x(a.geom)
FROM   ban.hsn_point_2154 a
WHERE  ad_ban_id=id;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_ad_x_ban ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_ad_x_ban ON ban.hsn_point_2154;
CREATE TRIGGER trg_update_ad_x_ban
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.t_adresse
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_ad_x_ban();    

--- Schema : rbal
--- Table : t_adresse
--- Traitement : Mise à jour du nom de la commune

CREATE OR REPLACE FUNCTION fn_update_ad_commune()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse b
SET    ad_commune=nom
FROM   osm.communes_hsn_multipolygon_2154 a
WHERE  ST_CONTAINS (a.geom, b.geom) ;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_ad_commune ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_ad_commune ON osm.communes_hsn_multipolygon_2154;
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
SET    ad_insee=insee
FROM   osm.communes_hsn_multipolygon_2154 a
WHERE  ST_CONTAINS (a.geom, b.geom) ;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_ad_insee ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_ad_insee ON osm.communes_hsn_multipolygon_2154;
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

--- Schema : rbal
--- Table : t_adresse
--- Traitement : Mise à jour de la coordonnée x du centroide de la parcelle où se situe le point adresse

CREATE OR REPLACE FUNCTION fn_update_ad_x_parc()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse b
SET    ad_x_parc=st_x((st_centroid(b.geom)))
FROM   pci70_edigeo_majic.geo_parcelle a
WHERE  ST_CONTAINS (a.geom, b.geom);
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_ad_x_parc ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_ad_x_parc ON pci70_edigeo_majic.geo_parcelle;
CREATE TRIGGER trg_update_ad_x_parc
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.t_adresse
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_ad_x_parc();



--- Schema : rbal
--- Table : t_adresse
--- Traitement : Mise à jour de la coordonnée x du centroide de la parcelle où se situe le point adresse

CREATE OR REPLACE FUNCTION fn_update_ad_y_parc()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse b
SET    ad_y_parc=st_y((st_centroid(b.geom)))
FROM   pci70_edigeo_majic.geo_parcelle a
WHERE  ST_CONTAINS (a.geom, b.geom);
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_ad_y_parc ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_ad_y_parc ON pci70_edigeo_majic.geo_parcelle;
CREATE TRIGGER trg_update_ad_y_parc
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.t_adresse
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_ad_y_parc();

--- Schema : rbal
--- Table : t_adresse
--- Traitement : Mise à jour du champs ad_majdate (modification sur une entité)

CREATE OR REPLACE FUNCTION fn_update_ad_majdate()   
RETURNS TRIGGER AS $$
BEGIN
    NEW.ad_majdate = now();
    RETURN NEW;   
END;
$$ language 'plpgsql';


CREATE TRIGGER trg_update_ad_majdate 
BEFORE UPDATE ON rbal.t_adresse 
FOR EACH ROW EXECUTE PROCEDURE  fn_update_ad_majdate();


--- Schema : rbal
--- Table : t_adresse
--- Traitement : Mise à jour du champs nom_sro (modification sur une entité)

CREATE OR REPLACE FUNCTION fn_update_nom_sro()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse b
SET    nom_sro=code_sro
FROM   psd_orange.zpm_hsn_polygon_2154 a
WHERE  ST_CONTAINS (a.geom, b.geom) ;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_nom_sro ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_nom_sro ON psd_orange.zpm_hsn_polygon_2154;
CREATE TRIGGER trg_update_nom_sro
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.t_adresse
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_nom_sro();

