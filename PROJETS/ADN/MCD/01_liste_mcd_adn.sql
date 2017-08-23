/*Creation des tables qui vont accueillir les listes de valeurs*/
/*PostGIS*/

SET search_path TO optimisation_diag, public;

DROP TABLE IF EXISTS l_avancement;
DROP TABLE IF EXISTS l_clim_type;
DROP TABLE IF EXISTS l_etat_type;
DROP TABLE IF EXISTS l_geoloc_classe;
DROP TABLE IF EXISTS l_geoloc_mode;
DROP TABLE IF EXISTS l_immeuble_type;
DROP TABLE IF EXISTS l_implantation_type;
DROP TABLE IF EXISTS l_infra_type_log;
DROP TABLE IF EXISTS l_passage_type;
DROP TABLE IF EXISTS l_pose_type;
DROP TABLE IF EXISTS l_priorite;
DROP TABLE IF EXISTS l_propriete_type;
DROP TABLE IF EXISTS l_ptech_nature;
DROP TABLE IF EXISTS l_site_type_log;
DROP TABLE IF EXISTS l_site_type_phy;
DROP TABLE IF EXISTS l_version;


CREATE TABLE l_avancement(code VARCHAR(1), libelle VARCHAR(254), definition VARCHAR(254), CONSTRAINT "l_avancement_pk" PRIMARY KEY (code));
CREATE TABLE l_clim_type(code VARCHAR(6), libelle VARCHAR(254), definition VARCHAR(254), CONSTRAINT "l_clim_type_pk" PRIMARY KEY (code));
CREATE TABLE l_etat_type(code VARCHAR(3), libelle VARCHAR(254), definition VARCHAR(254), CONSTRAINT "l_etat_type_pk" PRIMARY KEY (code));
CREATE TABLE l_geoloc_classe(code VARCHAR(2), libelle VARCHAR(254), definition VARCHAR(254), CONSTRAINT "l_geoloc_classe_pk" PRIMARY KEY (code));
CREATE TABLE l_geoloc_mode(code VARCHAR(4), libelle VARCHAR(254), definition VARCHAR(254), CONSTRAINT "l_geoloc_mode_pk" PRIMARY KEY (code));
CREATE TABLE l_immeuble_type(code VARCHAR(1), libelle VARCHAR(254), definition VARCHAR(254), CONSTRAINT "l_immeuble_type_pk" PRIMARY KEY (code));
CREATE TABLE l_implantation_type(code VARCHAR(2), libelle VARCHAR(254), definition VARCHAR(254), CONSTRAINT "l_implantation_type_pk" PRIMARY KEY (code));
CREATE TABLE l_infra_type_log(code VARCHAR(2), libelle VARCHAR(254), definition VARCHAR(254), CONSTRAINT "l_infra_type_log_pk" PRIMARY KEY (code));
CREATE TABLE l_passage_type(code VARCHAR(10), libelle VARCHAR(254), definition VARCHAR(254), CONSTRAINT "l_passage_type_pk" PRIMARY KEY (code));
CREATE TABLE l_pose_type(code VARCHAR(20), libelle VARCHAR(254), definition VARCHAR(254), CONSTRAINT "l_pose_type_pk" PRIMARY KEY (code));
CREATE TABLE l_priorite(code VARCHAR(1), libelle VARCHAR(254), definition VARCHAR(254), CONSTRAINT "l_priorite_pk" PRIMARY KEY (code));
CREATE TABLE l_propriete_type(code VARCHAR(3), libelle VARCHAR(254), definition VARCHAR(254), CONSTRAINT "l_propriete_type_pk" PRIMARY KEY (code));
CREATE TABLE l_ptech_nature(code VARCHAR(20), libelle VARCHAR(254), definition VARCHAR(254), CONSTRAINT "l_ptech_nature_pk" PRIMARY KEY (code));
CREATE TABLE l_site_type_log(code VARCHAR(10), libelle VARCHAR(254), definition VARCHAR(254), CONSTRAINT "l_site_type_log_pk" PRIMARY KEY (code));
CREATE TABLE l_site_type_phy(code VARCHAR(3), libelle VARCHAR(254), definition VARCHAR(254), CONSTRAINT "l_site_type_phy_pk" PRIMARY KEY (code));
CREATE TABLE l_version(code VARCHAR(2), libelle VARCHAR(254), definition VARCHAR(254), CONSTRAINT "l_version_pk" PRIMARY KEY (code));


