
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
