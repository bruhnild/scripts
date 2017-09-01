/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 03/07/2017
Objet : Formatage tables MCD pour MAJAP/aiguillage
Modification : Nom : ///// - Date : date_de_modif - Motif/nature : //////

Prerequis:

Voir Annexe SIG : I:\13 - AXIANS\THD ISERE\02 - Réception données client\Axians\05_06_2017\Données d'entrée TR20\01_01_SIG_DOCUMENT_GENERAL_V2_201608.pdf

-------------------------------------------------------------------------------------
*/

-- Création de la table intermédiaire mcd_tb_src_rivier_paute
drop table if exists aiguillage_tr.mcd_tb_src_rivier_paute;
create table aiguillage_tr.mcd_tb_src_rivier_paute as
SELECT 
ptch_id, 
ptch_id as ptch_objet, 
ptch_type, 
ptch_nom, 
ptch_ref_t as ptch_code, 
null::numeric as ptch_haut, 
null::numeric as ptch_larg, 
null::numeric as ptch_prof, 
'f'::boolean as ptch_secur,  
ptch_prop,  
ptch_gest,
null::date as ptch_dt_ps,  
ptch_etat, 
2::integer as ptch_stat, 
ptch_local, 
null::integer as ptch_ged, 
'20170703'::varchar (8) as datecr, 
null::varchar (8) as datemo, 
'MFA'::varchar (30) nomcr, 
null::varchar (30) nommo, 
geom
FROM aiguillage_tr.tb_src_rivier_paute;

-- Formatage de la table d'après le MCD
UPDATE aiguillage_tr.mcd_tb_src_rivier_paute
SET ptch_prop = (CASE ptch_prop
              WHEN 'DEPARTEMENT' THEN '1'
              WHEN 'ORANGE' THEN '3'
              END);

UPDATE aiguillage_tr.mcd_tb_src_rivier_paute
SET ptch_gest = (CASE ptch_gest
              WHEN 'DEPARTEMENT' THEN '1'
              WHEN 'ORANGE' THEN '3'
              END);

UPDATE aiguillage_tr.mcd_tb_src_rivier_paute
SET ptch_etat = (CASE ptch_etat
              WHEN 'A CREER' THEN '2'
              WHEN 'EXISTANT' THEN '1'
              END);


UPDATE aiguillage_tr.mcd_tb_src_rivier_paute
SET ptch_type = (CASE ptch_type

	      WHEN 'L1T' THEN '1'
	      WHEN 'L2T' THEN '2'
	      WHEN 'L3T' THEN '3'
	      WHEN 'L4T' THEN '4'
	      WHEN 'K1C' THEN '5'
	      WHEN 'K2C' THEN '6'
	      WHEN 'K3C' THEN '7'
	      WHEN 'L5T' THEN '8'
	      WHEN 'L6T' THEN '9'
	      WHEN 'M1C' THEN '10'
	      WHEN 'L2C' THEN '11'
              WHEN 'L3C' THEN '12'
              WHEN 'L0T' THEN '13'
              WHEN 'P1T' THEN '14'
              WHEN 'OHN' THEN '15'
              WHEN 'L1C' THEN '16'
              WHEN 'A2' THEN '17'
              WHEN 'A3' THEN '18'
              WHEN 'A4' THEN '19'
              WHEN 'B1' THEN '20'
              WHEN 'B2' THEN '21'
              WHEN 'D2' THEN '22'
              WHEN 'D3' THEN '23'
              WHEN 'D4' THEN '24'
              WHEN 'E4' THEN '25'
              WHEN 'M2T' THEN '26'
              WHEN 'P1C' THEN '27'
              WHEN 'P2C' THEN '28'
              WHEN 'M3C' THEN '29'
              WHEN 'P2T' THEN '30'
              WHEN 'RG' THEN '31'
              WHEN 'L4P' THEN '32'
              WHEN 'D1' THEN '33'
              WHEN 'C1' THEN '34'
              WHEN 'C2' THEN '35'
              WHEN 'L1P' THEN '36'
              WHEN 'L3P' THEN '37'
              WHEN 'L5P' THEN '38'
              END);


ALTER TABLE aiguillage_tr.mcd_tb_src_rivier_paute ALTER COLUMN ptch_type TYPE integer USING (ptch_type::integer);
ALTER TABLE aiguillage_tr.mcd_tb_src_rivier_paute ALTER COLUMN ptch_prop TYPE integer USING (ptch_prop::integer);
ALTER TABLE aiguillage_tr.mcd_tb_src_rivier_paute ALTER COLUMN ptch_gest TYPE integer USING (ptch_gest::integer);
ALTER TABLE aiguillage_tr.mcd_tb_src_rivier_paute ALTER COLUMN ptch_etat TYPE integer USING (ptch_etat::integer);

-- Insertion dans la table contenant la géométrie des noeuds
INSERT INTO crcd_livrable.nps (
 nps_id, nps_type, nps_loc, nps_etat, nps_stat, nps_dt_ms, nps_ged, 
nps_qgeo, the_geom, datecr, datemo, nomcr, nommo
)
SELECT
ptch_id, 1::integer as nps_type, ptch_local,  ptch_etat, ptch_stat,ptch_dt_ps, ptch_ged, 
1::integer as nps_qgeo, geom, datecr, datemo, nomcr, nommo
FROM aiguillage_tr.mcd_tb_src_rivier_paute;
;

-- Insertion dans la table contenant les attributs des chambres 
INSERT INTO crcd_livrable.ptchambre (
ptch_id, ptch_objet, ptch_type, ptch_nom, ptch_code, ptch_haut, 
       ptch_larg, ptch_prof, ptch_secur, ptch_prop, ptch_gest, ptch_dt_ps, 
       ptch_etat, ptch_stat, ptch_local, ptch_ged, datecr, datemo, nomcr, 
       nommo
)
SELECT

 ptch_id, ptch_objet, ptch_type, ptch_nom, ptch_code, ptch_haut, 
       ptch_larg, ptch_prof, ptch_secur, ptch_prop, ptch_gest, ptch_dt_ps, 
       ptch_etat, ptch_stat, ptch_local, ptch_ged, datecr, datemo, nomcr, 
       nommo
  FROM aiguillage_tr.mcd_tb_src_rivier_paute;
;

-- Création de la table intermédiaire mcd_tb_src_mairie_rivier
drop table if exists aiguillage_tr.mcd_tb_src_mairie_rivier;
create table aiguillage_tr.mcd_tb_src_mairie_rivier as 
SELECT id as ptch_id, id as ptch_objet, ref_chambr as ptch_type, 
cle_mkt2 as ptch_nom, concat(code_ch1,'-',code_ch2) as ptch_code, null::numeric as ptch_haut, 
null::numeric as ptch_larg, 
null::numeric as ptch_prof, 
'f'::boolean as ptch_secur,  
'ORANGE'::varchar as ptch_prop,
'ORANGE'::varchar as ptch_gest,
null::date as ptch_dt_ps,  
'EXISTANT'::varchar as ptch_etat, 
2::integer as ptch_stat, 
'TROTTOIR'::varchar as ptch_local, 
null::integer as ptch_ged, 
'20170703'::varchar (8) as datecr, 
null::varchar (8) as datemo, 
'MFA'::varchar (30) nomcr, 
null::varchar (30) nommo, 
geom
from 
aiguillage_tr.tb_src_mairie_rivier as a;

-- Formatage de la table d'après le MCD
UPDATE aiguillage_tr.mcd_tb_src_mairie_rivier as a 
SET ptch_id = b.ptch_id
FROM aiguillage_tr."PTCHAMBRE" as b 
WHERE ST_Intersects(a.geom,b.geom)
;

UPDATE aiguillage_tr.mcd_tb_src_mairie_rivier as a 
SET ptch_objet = b.ptch_id
FROM aiguillage_tr."PTCHAMBRE" as b 
WHERE ST_Intersects(a.geom,b.geom)
;

ALTER TABLE aiguillage_tr.mcd_tb_src_mairie_rivier ALTER COLUMN ptch_nom TYPE varchar (50) USING (ptch_nom::varchar);

UPDATE aiguillage_tr.mcd_tb_src_mairie_rivier as a 
SET ptch_nom = b.ptch_nom
FROM aiguillage_tr."PTCHAMBRE" as b 
WHERE ST_Intersects(a.geom,b.geom)
;

UPDATE aiguillage_tr.mcd_tb_src_mairie_rivier as a 
SET ptch_code = b.ptch_ref_t
FROM aiguillage_tr."PTCHAMBRE" as b 
WHERE ST_Intersects(a.geom,b.geom)
;

UPDATE aiguillage_tr.mcd_tb_src_mairie_rivier as a 
SET ptch_etat = b.ptch_etat
FROM aiguillage_tr."PTCHAMBRE" as b 
WHERE ST_Intersects(a.geom,b.geom)
;

UPDATE aiguillage_tr.mcd_tb_src_mairie_rivier as a 
SET ptch_gest = b.ptch_gest
FROM aiguillage_tr."PTCHAMBRE" as b 
WHERE ST_Intersects(a.geom,b.geom)
;

UPDATE aiguillage_tr.mcd_tb_src_mairie_rivier as a 
SET ptch_prop = b.ptch_prop
FROM aiguillage_tr."PTCHAMBRE" as b 
WHERE ST_Intersects(a.geom,b.geom)
;

UPDATE aiguillage_tr.mcd_tb_src_mairie_rivier as a 
SET ptch_local = b.ptch_local
FROM aiguillage_tr."PTCHAMBRE" as b 
WHERE ST_Intersects(a.geom,b.geom)
;

UPDATE aiguillage_tr.mcd_tb_src_mairie_rivier
SET ptch_prop = (CASE ptch_prop
              WHEN 'DEPARTEMENT' THEN '1'
              WHEN 'ORANGE' THEN '3'
              END);

UPDATE aiguillage_tr.mcd_tb_src_mairie_rivier
SET ptch_gest = (CASE ptch_gest
              WHEN 'DEPARTEMENT' THEN '1'
              WHEN 'ORANGE' THEN '3'
              END);

UPDATE aiguillage_tr.mcd_tb_src_mairie_rivier
SET ptch_etat = (CASE ptch_etat
              WHEN 'A CREER' THEN '2'
              WHEN 'EXISTANT' THEN '1'
              END);


UPDATE aiguillage_tr.mcd_tb_src_mairie_rivier
SET ptch_type = (CASE ptch_type

	      WHEN 'L1T' THEN '1'
	      WHEN 'L2T' THEN '2'
	      WHEN 'L3T' THEN '3'
	      WHEN 'L4T' THEN '4'
	      WHEN 'K1C' THEN '5'
	      WHEN 'K2C' THEN '6'
	      WHEN 'K3C' THEN '7'
	      WHEN 'L5T' THEN '8'
	      WHEN 'L6T' THEN '9'
	      WHEN 'M1C' THEN '10'
	      WHEN 'L2C' THEN '11'
              WHEN 'L3C' THEN '12'
              WHEN 'L0T' THEN '13'
              WHEN 'P1T' THEN '14'
              WHEN 'OHN' THEN '15'
              WHEN 'L1C' THEN '16'
              WHEN 'A2' THEN '17'
              WHEN 'A3' THEN '18'
              WHEN 'A4' THEN '19'
              WHEN 'B1' THEN '20'
              WHEN 'B2' THEN '21'
              WHEN 'D2' THEN '22'
              WHEN 'D3' THEN '23'
              WHEN 'D4' THEN '24'
              WHEN 'E4' THEN '25'
              WHEN 'M2T' THEN '26'
              WHEN 'P1C' THEN '27'
              WHEN 'P2C' THEN '28'
              WHEN 'M3C' THEN '29'
              WHEN 'P2T' THEN '30'
              WHEN 'RG' THEN '31'
              WHEN 'L4P' THEN '32'
              WHEN 'D1' THEN '33'
              WHEN 'C1' THEN '34'
              WHEN 'C2' THEN '35'
              WHEN 'L1P' THEN '36'
              WHEN 'L3P' THEN '37'
              WHEN 'L5P' THEN '38'
              END);


ALTER TABLE aiguillage_tr.mcd_tb_src_mairie_rivier ALTER COLUMN ptch_type TYPE integer USING (ptch_type::integer);
ALTER TABLE aiguillage_tr.mcd_tb_src_mairie_rivier ALTER COLUMN ptch_prop TYPE integer USING (ptch_prop::integer);
ALTER TABLE aiguillage_tr.mcd_tb_src_mairie_rivier ALTER COLUMN ptch_gest TYPE integer USING (ptch_gest::integer);
ALTER TABLE aiguillage_tr.mcd_tb_src_mairie_rivier ALTER COLUMN ptch_etat TYPE integer USING (ptch_etat::integer);

-- Insertion dans la table contenant la géométrie des noeuds
INSERT INTO crcd_livrable.nps (
 nps_id, nps_type, nps_loc, nps_etat, nps_stat, nps_dt_ms, nps_ged, 
nps_qgeo, the_geom, datecr, datemo, nomcr, nommo
)
SELECT
ptch_id, 1::integer as nps_type, ptch_local,  ptch_etat, ptch_stat,ptch_dt_ps, ptch_ged, 
1::integer as nps_qgeo, geom, datecr, datemo, nomcr, nommo
FROM aiguillage_tr.mcd_tb_src_mairie_rivier;
;

-- Insertion dans la table contenant les attributs des chambres
INSERT INTO crcd_livrable.ptchambre (
ptch_id, ptch_objet, ptch_type, ptch_nom, ptch_code, ptch_haut, 
       ptch_larg, ptch_prof, ptch_secur, ptch_prop, ptch_gest, ptch_dt_ps, 
       ptch_etat, ptch_stat, ptch_local, ptch_ged, datecr, datemo, nomcr, 
       nommo
)
SELECT

 ptch_id, ptch_objet, ptch_type, ptch_nom, ptch_code, ptch_haut, 
       ptch_larg, ptch_prof, ptch_secur, ptch_prop, ptch_gest, ptch_dt_ps, 
       ptch_etat, ptch_stat, ptch_local, ptch_ged, datecr, datemo, nomcr, 
       nommo
  FROM aiguillage_tr.mcd_tb_src_mairie_rivier;
;