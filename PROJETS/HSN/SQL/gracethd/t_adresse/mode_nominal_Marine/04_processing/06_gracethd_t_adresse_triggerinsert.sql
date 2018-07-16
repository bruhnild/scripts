/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 09/04/2018
Objet : Triggers pour la mise à jour des champs de la table t_adresse (grace_thd)
Modification : Nom : ///// - Date : date_de_modif - Motif/nature : //////

Champs mis à jour :
- ad_code
- ad_ban_id
- ad_numero
- ad_rep
- ad_nblhab
- ad_nblpro
- ad_isole
- ad_nomvoie
- ad_racc
- ad_nombat
- ad_comment
- ad_creadat
- ad_nom_ld
- ad_fantoir
- x
- y
- ad_x_ban
- ad_y_ban
- ad_commune
- ad_insee
- nom_sro
- ad_postal
- ad_idpar
- ad_x_parc
- ad_y_parc
- ad_majdate
- nom_id
- ad_itypeim
- ad_imneuf
- statut
- ad_nbprpro
- ad_nbprhab
- potentiel_ftte
- nb_prises_totale
- nom_pro
- geom
-------------------------------------------------------------------------------------
*/



------========================================================------
------= ETAPE 4 : INSERTION DYNAMQUE DE v_adresse A t_adresse=------
------========================================================------

--- Schema : rbal
--- Trigger : trg_update_rbal_t_adresse
--- Traitement : Mets à jour la table t_adresse à partir de la vue v_adresse

CREATE OR REPLACE FUNCTION fn_update_rbal_t_adresse() RETURNS TRIGGER AS $$
BEGIN
INSERT INTO rbal.t_adresse  ( 
  	ad_code, 
	ad_ban_id, 
	ad_nomvoie, 
	ad_fantoir, 
	ad_numero, 
	ad_rep, 
	ad_insee, 
	ad_postal, 
	ad_alias, 
	ad_nom_ld, 
	ad_x_ban, 
	ad_y_ban, 
	ad_commune, 
	ad_section, 
	ad_idpar, 
	ad_x_parc, 
	ad_y_parc, 
	ad_nat, 
	ad_nblhab, 
	ad_nblpro, 
	ad_nbprhab, 
	ad_nbprpro, 
	ad_rivoli, 
	ad_hexacle, 
	ad_hexaclv, 
	ad_distinf, 
	ad_isole, 
	ad_prio, 
	ad_racc, 
	ad_batcode, 
	ad_nombat, 
	ad_ietat, 
	ad_itypeim, 
	ad_imneuf, 
	ad_idatimn, 
	ad_prop, 
	ad_gest, 
	ad_idatsgn, 
	ad_iaccgst, 
	ad_idatcab, 
	ad_idatcom, 
	ad_typzone, 
	ad_comment, 
	ad_geolqlt, 
	ad_geolmod, 
	ad_geolsrc, 
	ad_creadat, 
	ad_majdate, 
	ad_majsrc, 
	ad_abddate, 
	ad_abdsrc, 
	nom_sro, 
	nb_prises_totale, 
	statut, 
	cas_particuliers,
	nom_id, 
	nom_pro,
	typologie_pro,  
	x, 
	y, 
	potentiel_ftte, 
	geom
)
VALUES(
    new.ad_code, 
	new.ad_ban_id, 
	new.ad_nomvoie, 
	new.ad_fantoir, 
	new.ad_numero, 
	new.ad_rep, 
	new.ad_insee, 
	new.ad_postal, 
	new.ad_alias, 
	new.ad_nom_ld, 
	new.ad_x_ban, 
	new.ad_y_ban, 
	new.ad_commune, 
	new.ad_section, 
	new.ad_idpar, 
	new.ad_x_parc, 
	new.ad_y_parc, 
	new.ad_nat, 
	new.ad_nblhab, 
	new.ad_nblpro, 
	new.ad_nbprhab, 
	new.ad_nbprpro, 
	new.ad_rivoli, 
	new.ad_hexacle, 
	new.ad_hexaclv, 
	new.ad_distinf, 
	new.ad_isole, 
	new.ad_prio, 
	new.ad_racc, 
	new.ad_batcode, 
	new.ad_nombat, 
	new.ad_ietat, 
	new.ad_itypeim, 
	new.ad_imneuf, 
	new.ad_idatimn, 
	new.ad_prop, 
	new.ad_gest, 
	new.ad_idatsgn, 
	new.ad_iaccgst, 
	new.ad_idatcab, 
	new.ad_idatcom, 
	new.ad_typzone, 
	new.ad_comment, 
	new.ad_geolqlt, 
	new.ad_geolmod, 
	new.ad_geolsrc, 
	new.ad_creadat, 
	new.ad_majdate, 
	new.ad_majsrc, 
	new.ad_abddate, 
	new.ad_abdsrc, 
	new.nom_sro, 
	new.nb_prises_totale, 
	new.statut, 
	new.cas_particuliers,
	new.nom_id, 
	new.nom_pro, 
	new.typologie_pro,
	new.x, 
	new.y, 
	new.potentiel_ftte, 
	new.geom)
;
  RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';


DROP TRIGGER IF EXISTS trg_update_rbal_t_adresse ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_rbal_t_adresse ON rbal.v_adresse;
CREATE TRIGGER trg_update_rbal_t_adresse
INSTEAD OF INSERT ON rbal.v_adresse FOR EACH ROW EXECUTE PROCEDURE fn_update_rbal_t_adresse();

------=========================================------
------= ETAPE 5 : CREATION DE LA VUE v_adresse=------
------=========================================------

CREATE OR REPLACE VIEW rbal.v_adresse AS
SELECT
nom_id, 
nom_sro,
ad_code,
ad_numero,
ad_rep,
ad_nomvoie,
ad_nom_ld,
ad_commune,
ad_postal,
ad_insee,
x,
y,
ad_fantoir,
ad_ban_id,
ad_x_ban, 
ad_y_ban, 
ad_idpar, 
ad_x_parc, 
ad_y_parc, 
ad_nombat,
ad_rivoli, 
ad_hexacle, 
ad_hexaclv, 
ad_nblhab, 
ad_nblpro, 
ad_nbprhab, 
ad_nbprpro, 	
nb_prises_totale, 
potentiel_ftte, 
ad_comment,
ad_racc, 
ad_itypeim, 
ad_imneuf, 
ad_idatimn, 
ad_prop, 
ad_gest, 
ad_idatsgn, 
ad_iaccgst, 
ad_isole, 
statut, 
cas_particuliers,	
ad_creadat, 
ad_majdate, 
ad_majsrc, 
ad_abddate, 
ad_abdsrc, 
nom_pro, 
ad_typzone, 
ad_geolqlt, 
ad_geolsrc
FROM gracethd_metis.t_adresse;



--- Schema : rbal
--- Table : t_adresse
--- Traitement : Met à jour la table t_adresse quand v_bal_hsn_point_2154 est mis à jour



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

--- Schema : rbal
--- Table : t_adresse
--- Traitement : Met à jour la table t_adresse en supprimant les lignes supprimées dans v_bal_hsn_point_2154
CREATE OR REPLACE FUNCTION fn_delete_old_rows() RETURNS TRIGGER AS $$
BEGIN
 WITH a_supprimer AS
(
SELECT *
FROM rbal.t_adresse AS t_adresse
WHERE cast(t_adresse.ad_code as integer) NOT IN  
(SELECT DISTINCT ad_code
FROM rbal.v_bal_hsn_point_2154  bal
WHERE ad_code=bal.ad_code
GROUP BY ad_code, bal.ad_code
))
DELETE FROM rbal.t_adresse a
USING a_supprimer b
WHERE a.ad_code = b.ad_code;

  RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';



DROP TRIGGER IF EXISTS trg_delete_old_rows ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_delete_old_rows ON rbal.v_bal_hsn_point_2154 ;
CREATE TRIGGER trg_delete_old_rows
INSTEAD OF UPDATE OR DELETE ON rbal.v_bal_hsn_point_2154 
FOR EACH ROW
EXECUTE PROCEDURE fn_delete_old_rows();


--- Schema : rbal
--- Table : t_adresse
--- Traitement : Met à jour le champ ad_ban_id de t_adresse à la création d'entités


CREATE OR REPLACE FUNCTION fn_update_ad_ban_id()
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

DROP TRIGGER IF EXISTS trg_update_ad_ban_id ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_ad_ban_id ON rbal.liaison_hsn_linestring_2154;
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
--- Traitement : Mise à jour du champ ad_nomvoie lors de l'update ou insert de nouveaux ad_code quand ad_ban_id est null et qu'il y a des locaux

CREATE OR REPLACE FUNCTION fn_update_ad_nomvoie_locaux_liaison()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse b
SET    ad_nomvoie=voie
FROM   rbal.v_bal_idbanout_idlocauxin_voie a, rbal.liaison_hsn_linestring_2154 c 
WHERE  ST_DWithin(a.geom, c.geom, 0.001) and cast(a.id as varchar)=b.nom_id AND ad_ban_id IS NULL ;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_ad_nomvoie_locaux_liaison ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_ad_nomvoie_locaux_liaison ON rbal.v_bal_idbanout_idlocauxin_voie;
CREATE TRIGGER trg_update_ad_nomvoie_locaux_liaison
INSTEAD OF UPDATE OR INSERT ON rbal.v_bal_idbanout_idlocauxin_voie 
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_ad_nomvoie_locaux_liaison();

--- Schema : rbal
--- Table : t_adresse
--- Traitement : Mise à jour du champ ad_nomvoie lors de l'update ou insert de nouveaux ad_code quand ad_ban_id est null et qu'il n'y a pas de locaux

CREATE OR REPLACE FUNCTION fn_update_ad_nomvoie_liaison_voie()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse b
SET    ad_nomvoie=nomvoie
FROM   rbal.liaison_voie_hsn_linestring_2154 a
WHERE  ST_DWithin(a.geom, b.geom, 0.001) and ad_ban_id IS NULL;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_ad_nomvoie_liaison_voie ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_ad_nomvoie_liaison_voie ON rbal.liaison_voie_hsn_linestring_2154;
CREATE TRIGGER trg_update_ad_nomvoie_liaison_voie
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.t_adresse
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_ad_nomvoie_liaison_voie();

--- Schema : rbal
--- Table : t_adresse
--- Traitement : Mise à jour du champ ad_nomvoie lors de l'update ou insert de nouveaux ad_code quand ad_ban_id est null,qu'il n'y a pas de locaux ni de voie

CREATE OR REPLACE FUNCTION fn_update_ad_nomvoie_liaison_voiesanspci()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse b
SET    ad_nomvoie=nomvoie
FROM   rbal.liaison_voie_sanspci_hsn_linestring_2154 a
WHERE  ST_DWithin(a.geom, b.geom, 0.001) and ad_ban_id IS NULL;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_ad_nomvoie_liaison_voiesanspci ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_ad_nomvoie_liaison_voiesanspci ON rbal.liaison_voie_sanspci_hsn_linestring_2154;
CREATE TRIGGER trg_update_ad_nomvoie_liaison_voiesanspci
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.t_adresse
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_ad_nomvoie_liaison_voiesanspci();

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
--- Traitement : Met à jour le champ ad_numero de t_adresse à la création d'entités


CREATE OR REPLACE FUNCTION fn_update_ad_numero()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse b
SET    ad_numero=cast(numero as integer)
FROM   ban.hsn_point_2154 a
WHERE  ad_ban_id=id;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_ad_numero ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_ad_numero ON rbal.liaison_hsn_linestring_2154;
CREATE TRIGGER trg_update_ad_numero
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.t_adresse
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_ad_numero();


--- Schema : rbal
--- Table : t_adresse
--- Traitement : Met à jour le champ ad_numero de t_adresse à la création d'entités quand il n'a pas été trouvé dans la ban


CREATE OR REPLACE FUNCTION fn_update_ad_numero_bal()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse b
SET    ad_numero=cast(a.ad_numero as integer)
FROM   rbal.bal_hsn_point_2154 a
WHERE  a.ad_code=cast(b.ad_code as integer) AND b.ad_numero IS NULL;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_ad_numero_bal ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_ad_numero_bal ON rbal.liaison_hsn_linestring_2154;
CREATE TRIGGER trg_update_ad_numero_bal
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.t_adresse
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_ad_numero_bal();



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
--- Traitement : Mise à jour du champ ad_rep lors de l'update ou insert de nouveaux ad_ban_id quand il n'a pas été trouvé dans la ban

CREATE OR REPLACE FUNCTION fn_update_ad_rep_bal()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse b
SET    ad_rep=a.ad_rep
FROM   rbal.bal_hsn_point_2154 a
WHERE  a.ad_code=cast(b.ad_code as integer) AND b.ad_rep IS NULL;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;


DROP TRIGGER IF EXISTS trg_update_ad_rep_bal ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_ad_rep_bal ON ban.hsn_point_2154;
CREATE TRIGGER trg_update_ad_rep_bal
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.t_adresse
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_ad_rep_bal();


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
--- Traitement : Mise à jour du champ ad_nom_ld lors de l'update ou insert de nouveaux ad_ban_id quand ad_nomvoie est nul et qu'il existe dans le pci

CREATE OR REPLACE FUNCTION fn_update_ad_nom_ld_pci()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse b
SET    ad_nom_ld=tex
FROM   pci70_edigeo_majic.geo_lieudit a
WHERE  ST_CONTAINS(a.geom, b.geom) and ad_nomvoie IS NULL ;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_ad_nom_ld_pci ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_ad_nom_ld_pci ON pci70_edigeo_majic.geo_lieudit;
CREATE TRIGGER trg_update_ad_nom_ld_pci
AFTER INSERT OR UPDATE OF 
geom
ON rbal.t_adresse
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_ad_nom_ld_pci();


--- Schema : rbal
--- Table : t_adresse
--- Traitement : Mise à jour du champ ad_nom_ld lors de l'update ou insert de nouveaux ad_ban_id quand ad_nomvoie est nul et qu'il n'existe pas dans le pci

CREATE OR REPLACE FUNCTION fn_update_ad_nom_ld_sanspci()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse b
SET    ad_nom_ld=lieu_dit
FROM   rbal.liaison_voie_sanspci_hsn_linestring_2154 a
WHERE  ST_DWithin(a.geom, b.geom, 0.001) AND ad_ban_id IS NULL AND ad_nom_ld IS NULL ;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_ad_nom_ld_sanspci ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_ad_nom_ld_sanspci ON pci70_edigeo_majic.geo_lieudit;
CREATE TRIGGER trg_update_ad_nom_ld_sanspci
AFTER INSERT OR UPDATE OF 
geom
ON rbal.t_adresse
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_ad_nom_ld_sanspci();

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
--- Traitement : Mise à jour du champs ad_nbprpro (modification sur une entité)

CREATE OR REPLACE FUNCTION fn_update_ad_nbprpro()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse a
SET ad_nbprpro=nb_ftth
FROM  rbal.v_bal_hsn_point_2154_ftth_ftte b
WHERE a.ad_code=cast(b.ad_code as varchar);
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
--- Traitement : Met à jour le champ ad_isole de t_adresse à la création d'entités


CREATE OR REPLACE FUNCTION fn_update_ad_isole()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse a
SET    ad_isole=TRUE
FROM   rbal.racco_hsn_linestring_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.1) AND ST_LENGTH (b.geom) >= 150;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_ad_isole ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_ad_isole ON rbal.racco_hsn_linestring_2154;
CREATE TRIGGER trg_update_ad_isole
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.t_adresse
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_ad_isole();

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
WHERE a.ad_code= cast(b.ad_code as varchar);
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_ad_imneuf ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_ad_imneuf ON rbal.bal_hsn_point_2154;
CREATE TRIGGER trg_update_ad_imneuf
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.t_adresse
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_ad_imneuf();

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
--- Traitement : Mise à jour du champs nom_sro (modification sur une entité)

CREATE OR REPLACE FUNCTION fn_update_nom_sro()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse b
SET    nom_sro=code_sro
FROM   psd_orange.zasro_hsn_phase1_polygon_2154 a
WHERE  ST_CONTAINS (a.geom, b.geom) ;
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_nom_sro ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_nom_sro ON psd_orange.zasro_hsn_phase1_polygon_2154;
CREATE TRIGGER trg_update_nom_sro
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.t_adresse
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_nom_sro();


--- Schema : rbal
--- Table : t_adresse
--- Traitement : Mise à jour du champs nb_prises_totale  (modification sur une entité)

CREATE OR REPLACE FUNCTION fn_update_nb_prises_totale()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse a
SET nb_prises_totale=b.nb_ftth+ad_nbprhab
FROM  rbal.v_bal_hsn_point_2154_ftth_ftte b
WHERE a.ad_code=cast(b.ad_code as varchar);
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_nb_prises_totale ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_nb_prises_totale ON rbal.v_bal_hsn_point_2154_ftth_ftte ;
CREATE TRIGGER trg_update_nb_prises_totale
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.t_adresse
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_nb_prises_totale();


--- Schema : rbal
--- Table : t_adresse
--- Traitement : Mise à jour du champs statut (1ere partie) (modification sur une entité)

CREATE OR REPLACE FUNCTION fn_update_statut_1()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse a
SET statut=
CASE WHEN construction LIKE 'En construction' THEN 'N'
WHEN destruction LIKE  'Supprimé' THEN 'S' 
ELSE 'C' END
FROM rbal.bal_hsn_point_2154 b
WHERE a.ad_code= cast(b.ad_code as varchar);
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_statut_1 ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_statut_1 ON rbal.bal_hsn_point_2154;
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
CASE WHEN EXISTS (SELECT distinct on (liaison_id) liaison_id
				  FROM rbal.liaison_hsn_linestring_2154 c ) THEN 'E' END
FROM rbal.liaison_hsn_linestring_2154 b 
WHERE a.nom_id=cast(b.id_locaux as varchar);
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_statut_2 ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_statut_1 ON rbal.bal_hsn_point_2154;
CREATE TRIGGER trg_update_statut_2
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.t_adresse
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_statut_2();

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
--- Traitement : Mise à jour du champs nom_pro  (modification sur une entité)

CREATE OR REPLACE FUNCTION fn_update_nom_pro()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse a
SET nom_pro=b.nom_pro
FROM  rbal.v_bal_hsn_point_2154_ftth_ftte b
WHERE a.ad_code=cast(b.ad_code as varchar);
RETURN NULL;
END
$func$  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_nom_pro ON rbal.t_adresse;
DROP TRIGGER IF EXISTS trg_update_nom_pro ON rbal.v_bal_hsn_point_2154_ftth_ftte ;
CREATE TRIGGER trg_update_nom_pro
AFTER INSERT OR UPDATE OF 
geom 
ON rbal.t_adresse
FOR EACH ROW 
EXECUTE PROCEDURE fn_update_nom_pro();



--- Schema : rbal
--- Table : t_adresse
--- Traitement : Mise à jour du champs potentiel_ftte  (modification sur une entité)

CREATE OR REPLACE FUNCTION fn_update_potentiel_ftte()
RETURNS trigger AS
$func$
BEGIN
UPDATE rbal.t_adresse a
SET potentiel_ftte=nb_ftte
FROM  rbal.v_bal_hsn_point_2154_ftth_ftte b
WHERE a.ad_code=cast(b.ad_code as varchar);
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






