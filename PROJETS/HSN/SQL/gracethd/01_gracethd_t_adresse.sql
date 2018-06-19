/*GraceTHD-MCD v2.0.1*/
/*Creation des tables qui vont accueillir les listes de valeurs*/
/* gracethd_10_lists.sql */
/*Insertion des valeurs dans les listes*/
/* gracethd_20_insert.sql */
/*Creation des tables*/
/* gracethd_30_tables.sql */
/*Creation des indexes*/
/* gracethd_50_index.sql */
/*PostGIS*/

/* Owner : GraceTHD-Community - http://gracethd-community.github.io/ */
/* Author : stephane dot byache at aleno dot eu */
/* Rev. date : 17/07/2017 */

/* ********************************************************************
    This file is part of GraceTHD.

    GraceTHD is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    GraceTHD is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with GraceTHD.  If not, see <http://www.gnu.org/licenses/>.
*********************************************************************** */

/* gracethd_10_lists.sql */

SET search_path TO rbal, public;


DROP TABLE IF EXISTS l_immeuble_type CASCADE;
DROP TABLE IF EXISTS l_implantation_type CASCADE;
DROP TABLE IF EXISTS l_zone_densite CASCADE;
DROP TABLE IF EXISTS l_statut CASCADE;

CREATE TABLE l_immeuble_type(code VARCHAR(1), libelle VARCHAR(254), definition VARCHAR(254), CONSTRAINT "l_immeuble_type_pk" PRIMARY KEY (code));
CREATE TABLE l_implantation_type(code VARCHAR(2), libelle VARCHAR(254), definition VARCHAR(254), CONSTRAINT "l_implantation_type_pk" PRIMARY KEY (code));
CREATE TABLE l_zone_densite(code VARCHAR(1), libelle VARCHAR(254), definition VARCHAR(254), CONSTRAINT "l_zone_densite_pk" PRIMARY KEY (code));
CREATE TABLE l_statut(code VARCHAR(1), libelle VARCHAR(254), definition VARCHAR(254), CONSTRAINT "l_statut_pk" PRIMARY KEY (code));


/* gracethd_20_insert.sql */

BEGIN;
INSERT INTO l_immeuble_type VALUES ('P', 'PAVILLON', '');
INSERT INTO l_immeuble_type VALUES ('I', 'IMMEUBLE', '');
INSERT INTO l_implantation_type VALUES ('0', 'AERIEN TELECOM', '');
INSERT INTO l_implantation_type VALUES ('1', 'AERIEN ENERGIE', '');
INSERT INTO l_implantation_type VALUES ('2', 'FACADE', '');
INSERT INTO l_implantation_type VALUES ('3', 'IMMEUBLE', '');
INSERT INTO l_implantation_type VALUES ('4', 'PLEINE TERRE', '');
INSERT INTO l_implantation_type VALUES ('5', 'CANIVEAU', '');
INSERT INTO l_implantation_type VALUES ('6', 'GALERIE', '');
INSERT INTO l_implantation_type VALUES ('7', 'CONDUITE', '');
INSERT INTO l_implantation_type VALUES ('8', 'EGOUT', '');
INSERT INTO l_implantation_type VALUES ('9', 'SPECIFIQUE', '');
INSERT INTO l_implantation_type VALUES ('91', 'AERO-SOUTERRAIN ENERGIE', '');
INSERT INTO l_implantation_type VALUES ('92', 'AERO-SOUTERRAIN FT', '');
INSERT INTO l_zone_densite VALUES ('2', 'ZTD BASSE DENSITE', '');
INSERT INTO l_zone_densite VALUES ('3', 'ZMD', '');
INSERT INTO l_statut VALUES ('C', 'CREE LORS DU RBAL', '');
INSERT INTO l_statut VALUES ('N', 'IMMEUBLE NEUF - EN CONSTRUCTION ', '');
INSERT INTO l_statut VALUES ('S', 'SUPPRIME', '');
INSERT INTO l_statut VALUES ('E', 'EXISTANT', '');
COMMIT;



/* gracethd_30_tables.sql */

DROP TABLE IF EXISTS t_adresse CASCADE;


CREATE TABLE t_adresse(	ad_code VARCHAR (254) PRIMARY KEY  ,
	ad_ban_id VARCHAR (24)   ,
	ad_nomvoie VARCHAR (254)   ,
	ad_fantoir VARCHAR (10)   ,
	ad_numero INTEGER   ,
	ad_rep VARCHAR (20)   ,
	ad_insee VARCHAR(6)   ,
	ad_postal VARCHAR(20)   ,
	ad_alias VARCHAR(254)   ,
	ad_nom_ld VARCHAR(254)   ,
	ad_x_ban NUMERIC   ,
	ad_y_ban NUMERIC   ,
	ad_commune VARCHAR (254)   ,
	ad_idpar VARCHAR (20)   ,
	ad_x_parc NUMERIC   ,
	ad_y_parc NUMERIC   ,
	ad_nblhab INTEGER   ,
	ad_nblpro INTEGER   ,
	ad_nbprhab INTEGER   ,
	ad_nbprpro INTEGER   ,
	ad_rivoli VARCHAR (254)   ,
	ad_hexacle VARCHAR (254)   ,
	ad_hexaclv VARCHAR (254)   ,
	ad_isole BOOLEAN   ,
	ad_racc VARCHAR(2)   REFERENCES l_implantation_type(code),
	ad_nombat VARCHAR(254)   ,
	ad_itypeim VARCHAR (1)   REFERENCES l_immeuble_type(code),
	ad_imneuf BOOLEAN   ,
	ad_idatimn DATE   ,
	ad_gest VARCHAR (20)   ,
	ad_idatsgn DATE   ,
	ad_iaccgst BOOLEAN   ,
	ad_typzone VARCHAR (1)   REFERENCES l_zone_densite(code),
	ad_comment VARCHAR(254)   ,
	ad_geolqlt NUMERIC(6,2)   ,
	ad_geolsrc VARCHAR(254)   ,
	ad_creadat TIMESTAMP  , 
	ad_majdate TIMESTAMP   ,
	ad_majsrc VARCHAR(254)   ,
	ad_abddate DATE   ,
	ad_abdsrc VARCHAR(254)   ,
	nom_sro VARCHAR(254)   ,
	nb_prises_totale INTEGER   ,
	statut VARCHAR(2)  REFERENCES l_statut(code), 
	nom_id VARCHAR(254)   ,
	nom_pro VARCHAR(254)   ,
	x NUMERIC ,
	y NUMERIC   ,
	potentiel_ftte INTEGER,
	categorie_adresse VARCHAR(254)   ,
	geom Geometry(Point,2154) NOT NULL  
	);	
	

/* gracethd_50_index.sql */

DROP INDEX IF EXISTS ad_ban_id_idx; CREATE INDEX  ad_ban_id_idx ON t_adresse(ad_ban_id);
DROP INDEX IF EXISTS ad_x_ban_idx; CREATE INDEX  ad_x_ban_idx ON t_adresse(ad_x_ban);
DROP INDEX IF EXISTS ad_y_ban_idx; CREATE INDEX  ad_y_ban_idx ON t_adresse(ad_y_ban);
DROP INDEX IF EXISTS ad_idpar_idx; CREATE INDEX  ad_idpar_idx ON t_adresse(ad_idpar);
DROP INDEX IF EXISTS ad_x_parc_idx; CREATE INDEX  ad_x_parc_idx ON t_adresse(ad_x_parc);
DROP INDEX IF EXISTS ad_y_parc_idx; CREATE INDEX  ad_y_parc_idx ON t_adresse(ad_y_parc);
DROP INDEX IF EXISTS ad_nbprhab_idx; CREATE INDEX  ad_nbprhab_idx ON t_adresse(ad_nbprhab);
DROP INDEX IF EXISTS ad_nbprpro_idx; CREATE INDEX  ad_nbprpro_idx ON t_adresse(ad_nbprpro);
DROP INDEX IF EXISTS ad_hexacle_idx; CREATE INDEX  ad_hexacle_idx ON t_adresse(ad_hexacle);
DROP INDEX IF EXISTS ad_hexaclv_idx; CREATE INDEX  ad_hexaclv_idx ON t_adresse(ad_hexaclv);
DROP INDEX IF EXISTS ad_racc_idx; CREATE INDEX  ad_racc_idx ON t_adresse(ad_racc);
DROP INDEX IF EXISTS ad_itypeim_idx; CREATE INDEX  ad_itypeim_idx ON t_adresse(ad_itypeim);
DROP INDEX IF EXISTS ad_typzone_idx; CREATE INDEX  ad_typzone_idx ON t_adresse(ad_typzone);


/* MAJ champs ad_creadat*/
ALTER TABLE t_adresse ALTER COLUMN ad_creadat SET DEFAULT NOW();



