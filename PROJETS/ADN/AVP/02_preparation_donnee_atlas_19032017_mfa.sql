/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 21032017
Objet : Structuration des tables de cadastre pour projet d'atlas
Modification : Nom : ///// - Date : date_de_modif - Motif/nature : //////

Prerequis:

- batiment (I:\6 - AMOA DIVERS\4 - IBSE\1 - ADN\MS2\0-Données d'entrée\Recavp
tion\CADASTRE\batiment) 
- parcelle (I:\6 - AMOA DIVERS\4 - IBSE\1 - ADN\MS2\0-Données d'entrée\Recavp
tion\CADASTRE\parcelle) 
- numero_de_voirie_text (I:\6 - AMOA DIVERS\4 - IBSE\1 - ADN\MS2\0-Données d'entrée\Recavp
tion\CADASTRE\numero_de_voirie_text) 
- zone_de_communication_text (I:\6 - AMOA DIVERS\4 - IBSE\1 - ADN\MS2\0-Données d'entrée\Recavp
tion\CADASTRE\zone_de_communication_text) 

-------------------------------------------------------------------------------------
*/

--********************* Structuration des tables ***************************

--- Remplace les caractères spéciaux à l'import en base 

--- Schema : avp

--- Table : NRO

ALTER TABLE IF EXISTS avp.site_marches RENAME TO nro;
ALTER TABLE avp.nro RENAME COLUMN wkb_geometry TO geom;

DELETE FROM avp.nro
WHERE order != 1;

--- Table : INF

ALTER TABLE IF EXISTS avp.infra_marches RENAME TO inf;
ALTER TABLE avp.inf RENAME COLUMN wkb_geometry TO geom;

--- Table : CHB

ALTER TABLE IF EXISTS avp.chb_marches RENAME TO chb;
ALTER TABLE avp.chb RENAME COLUMN wkb_geometry TO geom;

drop table if exists avp.chb;
create table avp.chb as
select *
from avp.ft_chambre 
where "code_ch1" = '41' or 
"code_ch1" = '45' and "code_com" = '26173' or
"code_ch1" = '46' or
"code_ch1" = '47' or
"code_ch1" = '48' or
"code_ch1" = '40' or
"code_ch1" = '124' or
"code_ch1" = '125' or
"code_ch1" = '123' or
"code_ch1" = '127' or
"code_ch1" = '71' or
"code_ch1" = '65' or 
"code_ch1" ='73' or
"code_ch1" = '74'

--- Tables chambres/infra

ALTER TABLE avp.ft_arciti RENAME COLUMN wkb_geometry TO geom;
ALTER TABLE avp.ft_chambre RENAME COLUMN wkb_geometry TO geom;

--- Copie des tables pour style


DROP TABLE IF EXISTS avp.chb_atlas;
CREATE TABLE avp.chb_atlas AS
SELECT *
FROM avp.chb
;
ALTER TABLE avp.chb_atlas
ADD PRIMARY KEY (gid);

DROP TABLE IF EXISTS avp.inf_atlas;
CREATE TABLE avp.inf_atlas AS
SELECT *
FROM avp.inf
;
ALTER TABLE avp.inf_atlas
ADD PRIMARY KEY (gid);


DROP TABLE IF EXISTS avp.nro_atlas;
CREATE TABLE avp.nro_atlas AS
SELECT *
FROM avp.nro
;
ALTER TABLE avp.nro_atlas
ADD PRIMARY KEY (gid);


DROP TABLE IF EXISTS avp.car_atlas;
CREATE TABLE avp.car_atlas AS
SELECT *
FROM avp.car
;
ALTER TABLE avp.car_atlas ADD COLUMN rang SERIAL PRIMARY KEY;



DROP TABLE IF EXISTS avp.communes_atlas;
CREATE TABLE avp.communes_atlas AS
SELECT *
FROM avp.communes
;
ALTER TABLE avp.communes_atlas
ADD PRIMARY KEY (id);



/*
-------------------------------------------------------------------------------------
DROP TABLE IF EXISTS avp.ft_arciti;
DROP TABLE IF EXISTS avp.ft_chambre;
DROP TABLE IF EXISTS avp.chb;
DROP TABLE IF EXISTS avp.chb_atlas;
DROP TABLE IF EXISTS avp.inf;
DROP TABLE IF EXISTS avp.inf_atlas;
DROP TABLE IF EXISTS avp.nro;
DROP TABLE IF EXISTS avp.nro_atlas;
-------------------------------------------------------------------------------------
*/

--- Table : batiment

UPDATE avp.batiment
SET dur = REPLACE(dur, 'B�ti l�ger' , 'Bâti léger');
UPDATE avp.batiment
SET dur = REPLACE(dur, 'B�ti dur' , 'Bâti dur');

--- Sélection des batiments dans l'emprise du carroyage


DROP TABLE IF EXISTS avp.batiment_atlas;
CREATE TABLE avp.batiment_atlas AS 
SELECT 
 distinct on (a.id) a.id,
 id_com, 
 code_com, 
 dur, 
 pre, 
 section, 
 dur_code,
 a.geom
FROM avp.batiment AS a, avp.car AS b 
WHERE st_intersects(a.geom, b.geom)
;

ALTER TABLE avp.batiment_atlas
ADD PRIMARY KEY (id);


--- Sélection des parcelles dans l'emprise du "CAR_Charmes"


--- Schema : avp

--- Table : parcelle

UPDATE avp.parcelle
SET indp = REPLACE(indp, 'figur�e' , 'figurée');

DROP TABLE IF EXISTS avp.parcelle_atlas;
CREATE TABLE avp.parcelle_atlas AS
SELECT  
 distinct on (a.id) a.id,
 id_com, 
 code_com, 
 parcelle, 
 section, 
 pre, 
 coar, 
 codm, 
 codm_code, 
 indp, 
 indp_code, 
 idu, 
 id_par, 
 supf, 
 tex, 
 tex2, 
 texte, 
 feuille,
 a.geom
FROM avp.parcelle AS a,  avp.car
 AS b 
WHERE st_intersects(a.geom, b.geom)
;

ALTER TABLE avp.parcelle_atlas
ADD PRIMARY KEY (id);

--- Sélection des zones de communication dans l'emprise du "CAR_Charmes"


--- Schema : avp

--- Table : zone_de_communication_text

DROP TABLE IF EXISTS avp.zone_de_communication_atlas;
CREATE TABLE avp.zone_de_communication_atlas AS
SELECT  
 distinct on (a.id) a.id,
 a.id_com, 
 a.code_com, 
 a.pre, 
 a.section, 
 fon, 
 hei, 
 tyu, 
 cef, 
 csp, 
 di1, 
 di2, 
 di3, 
 di4, 
 tpa, 
 hta, 
 vta, 
 atr, 
 texte, 
 rotation, 
 taille, 
 a.geom
 FROM avp.zone_de_communication_text AS a, avp.car
 AS b
 WHERE ST_INTERSECTS (a.geom, b.geom)
;

ALTER TABLE avp.zone_de_communication_atlas
ADD PRIMARY KEY (id);

--- Sélection des numéros de voirie dans l'emprise du "CAR_Charmes"


--- Schema : avp

--- Table : numero_de_voirie_text

DROP TABLE IF EXISTS avp.numero_de_voirie_atlas
;
CREATE TABLE avp.numero_de_voirie_atlas
 AS 
SELECT 
 distinct on (a.id) a.id,
 id_com, 
 code_com, 
 pre, 
 section, 
 fon, 
 hei, 
 tyu, 
 cef, 
 csp, 
 di1, 
 di2, 
 di3, 
 di4, 
 tpa, 
 hta, 
 vta, 
 atr, 
 texte, 
 rotation, 
 taille, 
 a.geom 
 FROM avp.numero_de_voirie_text AS a, avp.car
 AS b
 WHERE ST_INTERSECTS (a.geom, b.geom)
 ;

ALTER TABLE avp.numero_de_voirie_atlas
ADD PRIMARY KEY (id);
