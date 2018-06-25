SET search_path TO rbal, public;

/*ALTER TABLE rbal.bal_hsn_point_2154 ADD COLUMN ad_code SERIAL PRIMARY KEY;
ALTER TABLE rbal.bal_hsn_point_2154  ALTER COLUMN ad_code TYPE varchar USING (ad_code::varchar);
*/

DROP SEQUENCE IF EXISTS rbal.s_bal_hsn_point_2154 CASCADE;
CREATE SEQUENCE rbal.s_bal_hsn_point_2154
  INCREMENT 1
  MINVALUE 000000000
  MAXVALUE 999999999
  START 1
  CACHE 1;
  ALTER TABLE rbal.s_bal_hsn_point_2154 OWNER TO postgres;

CREATE OR REPLACE FUNCTION
nextval_special()
RETURNS TEXT
LANGUAGE sql
AS
$$
    SELECT to_char(nextval('rbal.s_bal_hsn_point_2154'), 'FM000000000'); 
$$;

ALTER TABLE rbal.bal_hsn_point_2154_old  ALTER COLUMN ad_code TYPE varchar USING (ad_code::varchar);


UPDATE rbal.bal_hsn_point_2154_old 
SET ad_code = concat('AD700',nextval_special());


DROP SEQUENCE IF EXISTS rbal.s_bal_hsn_point_2154_new CASCADE;
CREATE SEQUENCE rbal.s_bal_hsn_point_2154_new
  INCREMENT 1
  MINVALUE 000000000
  MAXVALUE 999999999
  START 1
  CACHE 1;

CREATE OR REPLACE FUNCTION
nextval_special()
RETURNS TEXT
LANGUAGE sql
AS
$$
    SELECT to_char(nextval('rbal.s_bal_hsn_point_2154_new'), 'FM000000000'); 
$$;


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
	ad_code VARCHAR DEFAULT concat('AD700',nextval_special()),
	ad_ban_id VARCHAR (24)   ,
	geom Geometry(Point,2154) NOT NULL  ,
	
CONSTRAINT "bal_hsn_point_2154_new_pk" PRIMARY KEY (ad_code));	


INSERT INTO rbal.bal_hsn_point_2154 (
ad_numero, ad_rep, ad_nombat, ad_racc, ad_comment, ad_nblhab, ad_nblpro, construction, destruction, 
type_pro1, nom_pro1, type_pro2, nom_pro2, type_pro3, nom_pro3, type_pro4, nom_pro4, type_pro5, nom_pro5, 
type_pro6, nom_pro6, type_pro7, nom_pro7, type_pro8, nom_pro8, type_pro9, nom_pro9, type_pro10, nom_pro10, 
ad_creadat, ad_code, ad_ban_id, geom
)
SELECT ad_numero, ad_rep, ad_nombat, ad_racc, ad_comment, ad_nblhab, ad_nblpro, construction, destruction, 
type_pro1, nom_pro1, type_pro2, nom_pro2, type_pro3, nom_pro3, type_pro4, nom_pro4, type_pro5, nom_pro5, 
type_pro6, nom_pro6, type_pro7, nom_pro7, type_pro8, nom_pro8, type_pro9, nom_pro9, type_pro10, nom_pro10, 
ad_creadat, ad_code, ad_ban_id, geom
FROM rbal.bal_hsn_point_2154_old;


DROP SEQUENCE IF EXISTS rbal.s_bal_hsn_point_2154_new CASCADE;
CREATE SEQUENCE rbal.s_bal_hsn_point_2154_new
  INCREMENT 1
  MINVALUE 000000000
  MAXVALUE 999999999
  START 1142
  CACHE 1;

CREATE OR REPLACE FUNCTION
nextval_special()
RETURNS TEXT
LANGUAGE sql
AS
$$
    SELECT to_char(nextval('rbal.s_bal_hsn_point_2154_new'), 'FM000000000'); 
$$;

