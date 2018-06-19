/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 06/06/2017
Objet : Création des tables nécessaires au remplissage de la table bal_hsn_point_2154
Modification : Nom : // - Date : // - Motif/nature : //
-------------------------------------------------------------------------------------
*/

--- Schema : rbal
--- Table : l_bal_pro_hsn
--- Traitement : Création de la table des types de pro



SET search_path TO rbal, public;
DROP TABLE IF EXISTS l_bal_pro_hsn CASCADE;
CREATE TABLE l_bal_pro_hsn(code VARCHAR(10),nb_ftth INTEGER, nb_ftte INTEGER, type_pro VARCHAR(254), CONSTRAINT "l_bal_pro_hsn_pk" PRIMARY KEY (code));

BEGIN;
INSERT INTO l_bal_pro_hsn VALUES ('1',1, 0,'Transformateurs Electriques');
INSERT INTO l_bal_pro_hsn VALUES ('2',1, 0,'Poste de refoulement');
INSERT INTO l_bal_pro_hsn VALUES ('3',1, 0,'Poste de gaz');
INSERT INTO l_bal_pro_hsn VALUES ('4',1, 1,'Parc Eolien');
INSERT INTO l_bal_pro_hsn VALUES ('5',1, 1,'Hôpital / Clinique');
INSERT INTO l_bal_pro_hsn VALUES ('6',1, 1,'Maison médicale');
INSERT INTO l_bal_pro_hsn VALUES ('7',1, 1,'Ecole primaire');
INSERT INTO l_bal_pro_hsn VALUES ('8',1, 1,'Collège / Lycée');
INSERT INTO l_bal_pro_hsn VALUES ('9',1, 1,'Université / Supérieur');
INSERT INTO l_bal_pro_hsn VALUES ('10',1, 1,'Mairie');
INSERT INTO l_bal_pro_hsn VALUES ('11',1, 1,'Bâtiment administratif (EPCI, Tribunal, …)');
INSERT INTO l_bal_pro_hsn VALUES ('12',1, 0,'Commerce de proximité');
INSERT INTO l_bal_pro_hsn VALUES ('13',1, 1,'Banque');
INSERT INTO l_bal_pro_hsn VALUES ('14',2, 0,'PMU (Bar)');
INSERT INTO l_bal_pro_hsn VALUES ('15',1, 0,'Artisans ou libérales');
INSERT INTO l_bal_pro_hsn VALUES ('16',1, 1,'Entreprises');
INSERT INTO l_bal_pro_hsn VALUES ('17',1, 4,'Antenne telecom');
INSERT INTO l_bal_pro_hsn VALUES ('18',1, 4,'Château d’eau avec antenne telecom');
INSERT INTO l_bal_pro_hsn VALUES ('19',2, 0,'Résidences étudiantes');
INSERT INTO l_bal_pro_hsn VALUES ('20',2, 0,'Foyers');
INSERT INTO l_bal_pro_hsn VALUES ('21',2, 0,'Maison de retraite');
INSERT INTO l_bal_pro_hsn VALUES ('22',2, 0,'Hotels');
INSERT INTO l_bal_pro_hsn VALUES ('23',2, 0,'Camping');
COMMIT;


--- Schema : rbal
--- Table : bal_hsn_point_2154
--- Traitement : Création de la table bal à partir de t_adresse


DROP TABLE IF EXISTS bal_hsn_point_2154 CASCADE;
CREATE TABLE bal_hsn_point_2154(	
	
	ad_numero INTEGER   ,
	ad_rep VARCHAR (20)   ,
	ad_nombat VARCHAR(254)   ,
	ad_racc VARCHAR(2)   REFERENCES l_implantation_type(code),
	ad_comment VARCHAR(254)   ,
	ad_nblhab INTEGER   ,
	ad_nblpro INTEGER   ,
	construction VARCHAR(254)   ,
	destruction VARCHAR(254)   ,
	type_pro1 VARCHAR(254)  REFERENCES l_bal_pro_hsn(code) ,
	nom_pro1 VARCHAR(254)   ,
	type_pro2 VARCHAR(254)  REFERENCES l_bal_pro_hsn(code) ,
	nom_pro2 VARCHAR(254)   ,
	type_pro3 VARCHAR(254)  REFERENCES l_bal_pro_hsn(code) ,
	nom_pro3 VARCHAR(254)   ,
	type_pro4 VARCHAR(254)  REFERENCES l_bal_pro_hsn(code) ,
	nom_pro4 VARCHAR(254)   ,
	type_pro5 VARCHAR(254)  REFERENCES l_bal_pro_hsn(code) ,
	nom_pro5 VARCHAR(254)   ,
	type_pro6 VARCHAR(254)  REFERENCES l_bal_pro_hsn(code) ,
	nom_pro6 VARCHAR(254)   ,
	type_pro7 VARCHAR(254)  REFERENCES l_bal_pro_hsn(code) ,
	nom_pro7 VARCHAR(254)   ,
	type_pro8 VARCHAR(254)  REFERENCES l_bal_pro_hsn(code) ,
	nom_pro8 VARCHAR(254)   ,
	type_pro9 VARCHAR(254)  REFERENCES l_bal_pro_hsn(code) ,
	nom_pro9 VARCHAR(254)   ,
	type_pro10 VARCHAR(254)  REFERENCES l_bal_pro_hsn(code) ,
	nom_pro10 VARCHAR(254)   ,
	ad_creadat TIMESTAMP DEFAULT NOW() , 
	ad_code SERIAL,
	ad_ban_id VARCHAR (24)   ,
	geom Geometry(Point,2154) NOT NULL  ,
	
CONSTRAINT "bal_hsn_point_2154_pk" PRIMARY KEY (ad_code));	
	










SET search_path TO rbal, public;
DROP TABLE IF EXISTS l_bal_pro_hsn CASCADE;
CREATE TABLE l_bal_pro_hsn(code VARCHAR(10),nb_ftth INTEGER, nb_ftte INTEGER, type_pro VARCHAR(254));

BEGIN;
INSERT INTO l_bal_pro_hsn VALUES ('1',1, 0,'Transformateurs Electriques');
INSERT INTO l_bal_pro_hsn VALUES ('2',1, 0,'Poste de refoulement');
INSERT INTO l_bal_pro_hsn VALUES ('3',1, 0,'Poste de gaz');
INSERT INTO l_bal_pro_hsn VALUES ('4',1, 1,'Parc Eolien');
INSERT INTO l_bal_pro_hsn VALUES ('5',1, 1,'Hôpital / Clinique');
INSERT INTO l_bal_pro_hsn VALUES ('6',1, 1,'Maison médicale');
INSERT INTO l_bal_pro_hsn VALUES ('7',1, 1,'Ecole primaire');
INSERT INTO l_bal_pro_hsn VALUES ('8',1, 1,'Collège / Lycée');
INSERT INTO l_bal_pro_hsn VALUES ('9',1, 1,'Université / Supérieur');
INSERT INTO l_bal_pro_hsn VALUES ('10',1, 1,'Mairie');
INSERT INTO l_bal_pro_hsn VALUES ('11',1, 1,'Bâtiment administratif (EPCI, Tribunal, …)');
INSERT INTO l_bal_pro_hsn VALUES ('12',1, 0,'Commerce de proximité');
INSERT INTO l_bal_pro_hsn VALUES ('13',1, 1,'Banque');
INSERT INTO l_bal_pro_hsn VALUES ('14',2, 0,'PMU (Bar)');
INSERT INTO l_bal_pro_hsn VALUES ('15',1, 0,'Artisans ou libérales');
INSERT INTO l_bal_pro_hsn VALUES ('16',1, 1,'Entreprises');
INSERT INTO l_bal_pro_hsn VALUES ('17',1, 4,'Antenne telecom');
INSERT INTO l_bal_pro_hsn VALUES ('18',1, 4,'Château d’eau avec antenne telecom');
INSERT INTO l_bal_pro_hsn VALUES ('19',2, 0,'Résidences étudiantes');
INSERT INTO l_bal_pro_hsn VALUES ('20',2, 0,'Foyers');
INSERT INTO l_bal_pro_hsn VALUES ('21',2, 0,'Maison de retraite');
INSERT INTO l_bal_pro_hsn VALUES ('22',2, 0,'Hotels');
INSERT INTO l_bal_pro_hsn VALUES ('23',2, 0,'Camping');
COMMIT;



--SET search_path TO rbal, public;

DROP TABLE IF EXISTS bal_hsn_point_2154 CASCADE;
CREATE TABLE bal_hsn_point_2154(	
	
	ad_numero INTEGER   ,
	ad_rep VARCHAR (20)   ,
	ad_nombat VARCHAR(254)   ,
	ad_racc VARCHAR(2)   REFERENCES l_implantation_type(code),
	ad_nblhab INTEGER   ,
	ad_nblpro INTEGER   ,
	construction VARCHAR(254)   ,
	destruction VARCHAR(254)   ,
	type_pro1 VARCHAR(254)  REFERENCES l_bal_pro_hsn(code) ,
	nom_pro1 VARCHAR(254)   ,
	type_pro2 VARCHAR(254)  REFERENCES l_bal_pro_hsn(code) ,
	nom_pro2 VARCHAR(254)   ,
	type_pro3 VARCHAR(254)  REFERENCES l_bal_pro_hsn(code) ,
	nom_pro3 VARCHAR(254)   ,
	type_pro4 VARCHAR(254)  REFERENCES l_bal_pro_hsn(code) ,
	nom_pro4 VARCHAR(254)   ,
	type_pro5 VARCHAR(254)  REFERENCES l_bal_pro_hsn(code) ,
	nom_pro5 VARCHAR(254)   ,
	type_pro6 VARCHAR(254)  REFERENCES l_bal_pro_hsn(code) ,
	nom_pro6 VARCHAR(254)   ,
	type_pro7 VARCHAR(254)  REFERENCES l_bal_pro_hsn(code) ,
	nom_pro7 VARCHAR(254)   ,
	type_pro8 VARCHAR(254)  REFERENCES l_bal_pro_hsn(code) ,
	nom_pro8 VARCHAR(254)   ,
	type_pro9 VARCHAR(254)  REFERENCES l_bal_pro_hsn(code) ,
	nom_pro9 VARCHAR(254)   ,
	type_pro10 VARCHAR(254)  REFERENCES l_bal_pro_hsn(code) ,
	nom_pro10 VARCHAR(254)   ,
	ad_creadat TIMESTAMP  , 
	ad_code VARCHAR (254) NOT NULL  ,
	ad_ban_id VARCHAR (24)   ,
	geom Geometry(Point,2154) NOT NULL  ,
	
CONSTRAINT "bal_hsn_point_2154_pk" PRIMARY KEY (ad_code));	
	

