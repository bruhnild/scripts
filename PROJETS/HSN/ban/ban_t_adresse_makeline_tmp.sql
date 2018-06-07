
drop table if exists ban.t_adresse;
create table ban.t_adresse as 
SELECT 
	row_number() OVER (ORDER BY sub_query.ad_ban_id) AS fid,
    sub_query.ad_ban_id,
    ST_Makeline(sub_query.geom_ban, sub_query.geom_adresse) AS geom
	FROM(
	SELECT 
  	ban.id,
  	(ST_Dump(ban.geom)).geom as geom_ban, 
  	t_adresse.ad_ban_id,
  	(ST_Dump(t_adresse.centroide)).geom as geom_adresse
	FROM 
  	ban.hsn_point_2154_500 as ban,
  	ban.batiments_hsn_polygon_2154_500 as t_adresse
	WHERE 
  	ban.id = t_adresse.ad_ban_id) AS sub_query;
	
/* mise à jour champ id_troncon */
ALTER TABLE ban.batiments_hsn_polygon_2154_500 DROP COLUMN IF EXISTS ad_code;
ALTER TABLE ban.batiments_hsn_polygon_2154_500 ADD COLUMN ad_code VARCHAR;

--- séquences d'incrémentations par type d'id tronçon 
DROP SEQUENCE IF EXISTS ban.t_adresse_incrementation_ad_code;
CREATE SEQUENCE ban.t_adresse_incrementation_ad_code
  INCREMENT 1
  MINVALUE 000000000
  MAXVALUE 999999999
  START 1
  CACHE 1;
ALTER TABLE ban.batiments_hsn_polygon_2154_500 OWNER TO postgres;

CREATE OR REPLACE FUNCTION
nextval_special()
RETURNS TEXT
LANGUAGE sql
AS
$$
    SELECT to_char(nextval('ban.t_adresse_incrementation_ad_code'), 'FM000000000'); 
$$;


UPDATE ban.batiments_hsn_polygon_2154_500  SET ad_code = concat('AD700',nextval_special());

select ad_code
from ban.batiments_hsn_polygon_2154_500

INSERT INTO rbal.t_adresse (
	ad_code,
   ad_ban_id,
   geom
)
SELECT
ad_code,
   ad_ban_id,
   centroide
FROM ban.batiments_hsn_polygon_2154_500
;



