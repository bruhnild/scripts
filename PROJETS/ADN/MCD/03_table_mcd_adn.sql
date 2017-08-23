/*Creation des tables*/
/*PostGIS*/

SET search_path TO optimisation_diag, public;

DROP TABLE IF EXISTS t_ltech CASCADE;
DROP TABLE IF EXISTS t_ptech CASCADE;
DROP TABLE IF EXISTS t_conduite CASCADE;
DROP TABLE IF EXISTS t_cheminement CASCADE;


CREATE TABLE t_ltech(	
	id VARCHAR(254) NOT NULL ,
	nom VARCHAR(254) ,
	nomvoie VARCHAR(254)  ,
	numero VARCHAR(20) ,
	rep VARCHAR(20) ,
	insee VARCHAR(5) ,
	postal VARCHAR(5) ,
	commune VARCHAR(100) ,
	priorite VARCHAR(1) REFERENCES l_priorite (code),
	version VARCHAR(2) REFERENCES l_version (code),
	prop VARCHAR(100)  ,
	gest VARCHAR(100) , 
	proptyp VARCHAR(3)  REFERENCES l_propriete_type (code),
	dateins DATE ,
	typephy VARCHAR(3) REFERENCES l_site_type_phy (code),
	typelog VARCHAR(4) REFERENCES l_site_type_log (code),
	elec BOOLEAN ,
	clim VARCHAR(4)   REFERENCES l_clim_type (code),
	comment VARCHAR(254),
	creadat TIMESTAMP ,
	majdate TIMESTAMP ,
	majsrc VARCHAR(254) ,
	abddate DATE ,
	abdsrc VARCHAR(254) ,
	geolmod VARCHAR(5)   REFERENCES l_geoloc_mode (code),
	geolsrc VARCHAR(100)  ,
	geom Geometry(Point,2154) NOT NULL  ,
CONSTRAINT "t_ltech_pk" PRIMARY KEY (id));	

DROP INDEX IF EXISTS lt_prop_idx; CREATE INDEX  lt_prop_idx ON t_ltech(prop);
DROP INDEX IF EXISTS lt_gest_idx; CREATE INDEX  lt_gest_idx ON t_ltech(gest);
DROP INDEX IF EXISTS lt_proptyp_idx; CREATE INDEX  lt_proptyp_idx ON t_ltech(proptyp);
DROP INDEX IF EXISTS lt_clim_idx; CREATE INDEX  lt_clim_idx ON t_ltech(clim);

CREATE TABLE t_ptech(	
	id VARCHAR(254) NOT NULL ,
	codeext VARCHAR (254) ,
	etiquet VARCHAR (254) ,
	nature VARCHAR(3)   REFERENCES l_ptech_nature (code),
	prop VARCHAR(20)  ,
	gest VARCHAR(20)  ,
	proptyp VARCHAR(3)   REFERENCES l_propriete_type (code),
	dateins DATE   ,
	avct VARCHAR(1)   REFERENCES l_avancement(code),
	comment VARCHAR(254)   ,
	creadat TIMESTAMP   ,
	majdate TIMESTAMP   ,
	majsrc VARCHAR(254)   ,
	abddate DATE   ,
	abdsrc VARCHAR(254)   ,
	geolmod VARCHAR(5)   REFERENCES l_geoloc_mode (code),
	geolsrc VARCHAR(100)  ,
	geom Geometry(Point,2154) NOT NULL  ,
CONSTRAINT "t_ptech_pk" PRIMARY KEY (id));	


DROP INDEX IF EXISTS pt_prop_idx; CREATE INDEX  pt_prop_idx ON t_ptech(prop);
DROP INDEX IF EXISTS pt_gest_idx; CREATE INDEX  pt_gest_idx ON t_ptech(gest);
DROP INDEX IF EXISTS pt_proptyp_idx; CREATE INDEX  pt_proptyp_idx ON t_ptech(proptyp);
DROP INDEX IF EXISTS pt_avct_idx; CREATE INDEX  pt_avct_idx ON t_ptech(avct);
DROP INDEX IF EXISTS pt_nature_idx; CREATE INDEX  pt_nature_idx ON t_ptech(nature);

CREATE TABLE t_conduite(	
	id VARCHAR(254) NOT NULL ,
	codeext Varchar(254)   ,
	etiquet VARCHAR(254)   ,
	prop VARCHAR(20)  ,
	gest VARCHAR(20),   
	proptyp VARCHAR(3)   REFERENCES l_propriete_type (code),
	etat VARCHAR(3)   REFERENCES l_etat_type (code),
	dia_int INTEGER   ,
	dia_ext INTEGER   ,
	color VARCHAR(254)   ,
	creadat TIMESTAMP   ,
	majdate TIMESTAMP   ,
	majsrc VARCHAR(254)   ,
	abddate DATE   ,
	abdsrc VARCHAR(254)   ,
	geom Geometry(Linestring,2154) NOT NULL ,
CONSTRAINT "t_conduite_pk" PRIMARY KEY (id));	

DROP INDEX IF EXISTS cd_prop_idx; CREATE INDEX  cd_prop_idx ON t_conduite(prop);
DROP INDEX IF EXISTS cd_gest_idx; CREATE INDEX  cd_gest_idx ON t_conduite(gest);
DROP INDEX IF EXISTS cd_proptyp_idx; CREATE INDEX  cd_proptyp_idx ON t_conduite(proptyp);
DROP INDEX IF EXISTS cd_etat_idx; CREATE INDEX  cd_etat_idx ON t_conduite(etat);


CREATE TABLE t_cheminement(	
	id VARCHAR(254) NOT NULL ,
	codeext VARCHAR(254)  ,
	voie VARCHAR(254)  ,
	gest VARCHAR(100) ,
	prop VARCHAR(100) ,
	etat VARCHAR(3)   REFERENCES l_etat_type (code),
	avct VARCHAR(1)   REFERENCES l_avancement(code),
	typelog VARCHAR(2)   REFERENCES l_infra_type_log (code),
	typ_imp VARCHAR(2)   REFERENCES l_implantation_type (code),
	compo VARCHAR(254)   ,
	cddispo INTEGER   ,
	fo_util INTEGER   ,
	mod_pos VARCHAR(20)   REFERENCES l_pose_type(code),
	passage VARCHAR(10)   REFERENCES l_passage_type(code),
	long NUMERIC(8,2)   ,
	lgreel NUMERIC(8,2)   ,
	comment VARCHAR(254)   ,
	dtclass VARCHAR(2)   REFERENCES l_geoloc_classe(code),
	geolmod VARCHAR(4)   REFERENCES l_geoloc_mode(code),
	geolsrc VARCHAR(254)   ,
	creadat TIMESTAMP   ,
	majdate TIMESTAMP   ,
	majsrc VARCHAR(254)   ,
	abddate DATE   ,
	abdsrc VARCHAR(254)   ,
	geom Geometry(Linestring,2154) NOT NULL , 
CONSTRAINT "t_cheminement_pk" PRIMARY KEY (id));	

DROP INDEX IF EXISTS cm_gest_do_idx; CREATE INDEX  cm_gest_do_idx ON t_cheminement(gest);
DROP INDEX IF EXISTS cm_prop_do_idx; CREATE INDEX  cm_prop_do_idx ON t_cheminement(prop);
DROP INDEX IF EXISTS cm_etat_idx; CREATE INDEX  cm_etat_idx ON t_cheminement(etat);
DROP INDEX IF EXISTS cm_avct_idx; CREATE INDEX  cm_avct_idx ON t_cheminement(avct);
DROP INDEX IF EXISTS cm_typelog_idx; CREATE INDEX  cm_typelog_idx ON t_cheminement(typelog);
DROP INDEX IF EXISTS cm_typ_imp_idx; CREATE INDEX  cm_typ_imp_idx ON t_cheminement(typ_imp);

CREATE INDEX t_cheminement_geom_gist ON t_cheminement USING GIST (geom); 





















