CREATE OR REPLACE VIEW rbal.v_bal_hsn_point_2154 AS
SELECT ad_numero, ad_rep, ad_nombat, ad_racc, ad_comment, ad_nblhab, ad_nblpro, 
construction, destruction, type_pro1, nom_pro1, type_pro2, nom_pro2, type_pro3, nom_pro3, 
type_pro4, nom_pro4, type_pro5, nom_pro5, type_pro6, nom_pro6, type_pro7, nom_pro7, type_pro8, nom_pro8, 
type_pro9, nom_pro9, type_pro10, nom_pro10, ad_creadat, ad_code, ad_ban_id, geom
FROM rbal.bal_hsn_point_2154;

--- Schema : rbal
--- Table : t_adresse
--- Traitement : Met à jour la table t_adresse quand bal_hsn_point_2154 est mis à jour

CREATE OR REPLACE FUNCTION fn_update_bal() RETURNS TRIGGER AS $$
BEGIN

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

VALUES(
	new.ad_code,
	new.ad_ban_id, 
	new.ad_numero, 
	new.ad_rep, 
	new.ad_nblhab, 
	new.ad_nblpro, 
	new.ad_racc, 
	new.ad_nombat, 
	new.ad_comment, 
	new.ad_creadat, 
	new.geom)
;
  RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';



DROP TRIGGER IF EXISTS trg_update_bal ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_bal ON rbal.bal_hsn_point_2154;
CREATE TRIGGER trg_update_bal
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.bal_hsn_point_2154
FOR EACH ROW  EXECUTE PROCEDURE fn_update_bal();

/*

CREATE OR REPLACE FUNCTION fn_update_bal() RETURNS TRIGGER AS $$
BEGIN

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

VALUES(
	new.ad_code,
	new.ad_ban_id, 
	new.ad_numero, 
	new.ad_rep, 
	new.ad_nblhab, 
	new.ad_nblpro, 
	new.ad_racc, 
	new.ad_nombat, 
	new.ad_comment, 
	new.ad_creadat, 
	new.geom)
;
  RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';



DROP TRIGGER IF EXISTS trg_update_bal ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_bal ON rbal.v_bal_hsn_point_2154;
CREATE TRIGGER trg_update_bal
INSTEAD OF INSERT OR UPDATE ON rbal.v_bal_hsn_point_2154 FOR EACH ROW EXECUTE PROCEDURE fn_update_bal();

*/


--- Schema : rbal
--- Table : t_adresse
--- Traitement : Met à jour le champ ad_ban_id de t_adresse à la création d'entités


CREATE OR REPLACE FUNCTION fn_update_nom_id()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse a
SET    ad_ban_id=id_ban
FROM   rbal.liaison_hsn_linestring_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.1) ;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_nom_id ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_nom_id ON rbal.liaison_hsn_linestring_2154;
CREATE TRIGGER trg_update_nom_id
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.t_adresse
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_nom_id();



--- Schema : rbal
--- Table : t_adresse
--- Traitement : Mise à jour du champ ad_nomvoie lors de l'update ou insert de nouveaux ad_code

CREATE OR REPLACE FUNCTION fn_update_ad_nomvoie()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse b
SET    ad_nomvoie=nom_voie
FROM   ban.hsn_point_2154 a
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
--- Traitement : Mise à jour des champs ad_y_ban 

CREATE OR REPLACE FUNCTION fn_update_ad_y_ban()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse b
SET    ad_y_ban=st_y(a.geom)
FROM   ban.hsn_point_2154 a
WHERE  ad_ban_id=id;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_ad_y_ban ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_ad_y_ban ON ban.hsn_point_2154;
CREATE TRIGGER trg_update_ad_y_ban
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.t_adresse
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_ad_y_ban();

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


DROP TRIGGER IF EXISTS trg_update_ad_majdate ON rbal.t_adresse;
CREATE TRIGGER trg_update_ad_majdate 
BEFORE UPDATE ON rbal.t_adresse 
FOR EACH ROW EXECUTE PROCEDURE  fn_update_ad_majdate();

--- Schema : rbal
--- Table : t_adresse
--- Traitement : Mise à jour du champs nom_id (modification sur une entité)

CREATE OR REPLACE FUNCTION fn_update_nom_id()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse a
SET    nom_id=id_locaux
FROM   rbal.liaison_hsn_linestring_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.1) ;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_nom_id ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_nom_id ON rbal.liaison_hsn_linestring_2154;
CREATE TRIGGER trg_update_nom_id
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.t_adresse
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_nom_id();

--- Schema : rbal
--- Table : t_adresse
--- Traitement : Mise à jour du champs ad_itypeim (modification sur une entité)


CREATE OR REPLACE FUNCTION fn_update_ad_itypeim()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse a
SET    ad_itypeim=
CASE WHEN (ad_nblhab+ad_nblpro)>=3 THEN 'I' ELSE 'P' END;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_ad_itypeim ON rbal.t_adresse;
CREATE TRIGGER trg_update_ad_itypeim
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.t_adresse
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_ad_itypeim();

--- Schema : rbal
--- Table : t_adresse
--- Traitement : Mise à jour du champs ad_imneuf (modification sur une entité)

CREATE OR REPLACE FUNCTION fn_update_ad_imneuf()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse a
SET    ad_imneuf=
CASE WHEN b.construction ='En construction' THEN TRUE ELSE NULL END
FROM rbal.bal_hsn_point_2154 as b 
WHERE a.ad_code=b.ad_code;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_ad_imneuf ON rbal.t_adresse;
CREATE TRIGGER trg_update_ad_imneuf
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.t_adresse
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_ad_imneuf();

--- Schema : rbal
--- Table : t_adresse
--- Traitement : Mise à jour du champs statut (1ere partie) (modification sur une entité)

CREATE OR REPLACE FUNCTION fn_update_statut_1()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse a
SET statut=
CASE WHEN liaison_id IS NOT null THEN 'E' ELSE 'C'END
FROM   rbal.liaison_hsn_linestring_2154 b
WHERE a.nom_id=b.liaison_id;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_statut_1 ON rbal.t_adresse;
CREATE TRIGGER trg_update_statut_1
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.t_adresse
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_statut_1();

--- Schema : rbal
--- Table : t_adresse
--- Traitement : Mise à jour du champs statut (2eme partie) (modification sur une entité)

CREATE OR REPLACE FUNCTION fn_update_statut_2()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse a
SET statut=
CASE WHEN construction LIKE 'En construction' THEN 'N'
WHEN destruction LIKE  'Supprimé' THEN 'S' END
FROM   rbal.bal_hsn_point_2154 b
WHERE a.ad_code=b.ad_code;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_statut_2 ON rbal.t_adresse;
CREATE TRIGGER trg_update_statut_2
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.t_adresse
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_statut_2();

--- Schema : rbal
--- Table : t_adresse
--- Traitement : Mise à jour du champs ad_nbprpro (modification sur une entité)

CREATE OR REPLACE FUNCTION fn_update_ad_nbprpro()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse a
SET ad_nbprpro=nb_ftth
FROM  rbal.v_bal_hsn_point_2154_ftth_ftte b
WHERE a.ad_code=b.ad_code;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_ad_nbprpro ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_ad_nbprpro ON rbal.v_bal_hsn_point_2154_ftth_ftte ;
CREATE TRIGGER trg_update_ad_nbprpro
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.t_adresse
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_ad_nbprpro();

--- Schema : rbal
--- Table : t_adresse
--- Traitement : Mise à jour du champs ad_nbprhab (modification sur une entité)

CREATE OR REPLACE FUNCTION fn_update_ad_nbprhab()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse a
SET ad_nbprhab=ad_nblhab;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_ad_nbprhab ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_ad_nbprhab ON rbal.v_bal_hsn_point_2154_ftth_ftte ;
CREATE TRIGGER trg_update_ad_nbprhab
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.t_adresse
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_ad_nbprhab();

--- Schema : rbal
--- Table : t_adresse
--- Traitement : Mise à jour du champs potentiel_ftte (2eme partie) (modification sur une entité)

CREATE OR REPLACE FUNCTION fn_update_potentiel_ftte()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse a
SET nb_prises_totale=nb_ftte
FROM  rbal.v_bal_hsn_point_2154_ftth_ftte b
WHERE a.ad_code=b.ad_code;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_potentiel_ftte ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_potentiel_ftte ON rbal.v_bal_hsn_point_2154_ftth_ftte ;
CREATE TRIGGER trg_update_potentiel_ftte
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.t_adresse
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_potentiel_ftte();