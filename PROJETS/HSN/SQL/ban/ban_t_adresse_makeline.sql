/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 30/05/2018
Projet : RIP - MOE 70 - HSN
Objet : Relier les points ban et les point adresses (rbal) par des segments
Modification : Nom : ///// - Date : date_de_modif - Motif/nature : //////

-------------------------------------------------------------------------------------
*/

/*
-------------------------------------------------------------------------------------
CREATION SEGMENTS BAL-RBAL
-------------------------------------------------------------------------------------
*/


--- Schema : rbal
--- Vue : segment_ban_rbal
--- Traitement : Création de segments entre les points ban et points rbal en fonction de ad_ban_id (id ban)

CREATE OR REPLACE VIEW rbal.segment_ban_adresse AS 
SELECT 
	row_number() OVER (ORDER BY sub_query.ad_ban_id) AS fid,
    sub_query.ad_ban_id,
    ST_Makeline(sub_query.geom_ban, sub_query.geom_adresse) AS geom
	FROM(
	SELECT 
  	ban.id,
  	(ST_Dump(ban.geom)).geom as geom_ban, 
  	rbal.ad_ban_id,
  	(ST_Dump(rbal.centroide)).geom as geom_adresse
	FROM 
  	ban.hsn_point_2154_500 as ban,
  	rbal.t_adresse as rbal
	WHERE 
  	ban.id = rbal.ad_ban_id) AS sub_query;



CREATE OR REPLACE VIEW rbal.segment_ban_bal_hsn_linestring_2154 AS 
SELECT 
  row_number() OVER (ORDER BY sub_query.ban_id) AS fid,
    sub_query.ban_id,
    ST_Makeline(sub_query.geom_ban, sub_query.geom_adresse) AS geom
  FROM(
  SELECT 
    ban.id as ban_id,
    (ST_Dump(ban.geom)).geom as geom_ban, 
    rbal.id as rbal_id,
     (ST_Dump(rbal.geom)).geom geom_adresse
  FROM 
    ban.hsn_point_2154 as ban,
    rbal.bal_hsn_point_2154 as rbal
  WHERE 
    ban.id = rbal.id) AS sub_query;


SELECT distinct on (a.geo_numvoie)a.geo_numvoie, b.geo_parcelle, tex, geom
  FROM pci70_edigeo_majic.geo_numvoie as a
  LEFT JOIN pci70_edigeo_majic.geo_numvoie_parcelle as b ON a.geo_numvoie=b.geo_numvoie
  group by a.geo_numvoie, b.geo_parcelle
  
  

with fantoir as
(
select voie, concat (ccodep, ccocom,'_',ccoriv, clerivili) as fant_voie_majic, ccodep, ccocom, ccoriv, clerivili,natvoi, libvoi, codvoi, typvoi
from pci70_edigeo_majic.voie)
select voie, fant_voie_majic, ccodep, ccocom, ccoriv, clerivili, natvoi, libvoi,codvoi ,typvoi, b.numero, b.id as ban_id, b.geom  from fantoir
left join ban.hsn_point_2154_500 b on fant_voie_majic=fant_voie
where fant_voie like '70401_0025F'

with voie_parcelle as
(
select distinct on (parcelle) parcelle, voie
from pci70_edigeo_majic.local00)
select voie_parcelle.voie, parcelle, concat (ccodep, ccocom,'_',ccoriv, clerivili) as fant_voie_majic, ccodep, ccocom, ccoriv, clerivili,natvoi, libvoi, codvoi, typvoi from voie_parcelle
left join pci70_edigeo_majic.voie b on voie_parcelle.voie=b.voie


WITH voie_parcelle AS
(
SELECT DISTINCT ON (parcelle) parcelle, a.voie,  concat (b.ccodep, b.ccocom,'_',b.ccoriv, b.clerivili) as fant_voie_majic, 
b.ccodep, b.ccocom, b.ccoriv, b.clerivili,b.natvoi, b.libvoi, b.codvoi, b.typvoi
FROM pci70_edigeo_majic.local00 AS a
LEFT JOIN pci70_edigeo_majic.voie b ON a.voie=b.voie)
SELECT * FROM voie_parcelle





WITH voie_parcelle AS
(
SELECT DISTINCT ON (parcelle) parcelle, a.voie,  concat (b.ccodep, b.ccocom,'_',b.ccoriv, b.clerivili) as fant_voie_majic, 
b.ccodep, b.ccocom, b.ccoriv, b.clerivili,b.natvoi, b.libvoi, b.codvoi, b.typvoi
FROM pci70_edigeo_majic.local00 AS a
LEFT JOIN pci70_edigeo_majic.voie b ON a.voie=b.voie
)
SELECT parcelle, voie, fant_voie_majic, ccodep, ccocom, ccoriv, clerivili, natvoi,libvoi,codvoi,typvoi    FROM voie_parcelle


WITH fantoir as
(
select a.voie, concat (ccodep, ccocom,'_',ccoriv, clerivili) as fant_voie_majic, b.numero, b.id as ban_id, b.geom
FROM pci70_edigeo_majic.voie AS a
LEFT JOIN ban.hsn_point_2154_500 b ON concat (ccodep, ccocom,'_',ccoriv, clerivili) =b.fant_voie
)
SELECT voie, fant_voie_majic, numero, ban_id, geom FROM fantoir



WITH fantoir as
(
select a.voie, concat (ccodep, ccocom,'_',ccoriv, clerivili) as fant_voie_majic, b.numero, b.rep, b.id as ban_id
FROM pci70_edigeo_majic.voie AS a
LEFT JOIN ban.hsn_point_2154 b ON concat (ccodep, ccocom,'_',ccoriv, clerivili) =b.fant_voie
)
SELECT voie, fant_voie_majic, numero, rep, ban_id FROM fantoir
group by fant_voie_majic, numero, rep, ban_id, voie


create table rbal.numvoi_test as 
SELECT distinct on (a.geo_numvoie)a.geo_numvoie, b.geo_parcelle, tex, geom
  FROM pci70_edigeo_majic.geo_numvoie as a
  LEFT JOIN pci70_edigeo_majic.geo_numvoie_parcelle as b ON a.geo_numvoie=b.geo_numvoie
  group by a.geo_numvoie, b.geo_parcelle
  
  
WITH voie_parcelle AS
(
SELECT DISTINCT ON (parcelle) parcelle, a.voie,  concat (b.ccodep, b.ccocom,'_',b.ccoriv, b.clerivili) as fant_voie_majic, 
b.ccodep, b.ccocom, b.ccoriv, b.clerivili,b.natvoi, b.libvoi, b.codvoi, b.typvoi
FROM pci70_edigeo_majic.local00 AS a
LEFT JOIN pci70_edigeo_majic.voie b ON a.voie=b.voie
)
SELECT parcelle, voie, fant_voie_majic, ccodep, ccocom, ccoriv, clerivili, natvoi,libvoi,codvoi,typvoi FROM voie_parcelle




DROP TABLE IF EXISTS rbal.voie_parcelle ;
CREATE TABLE rbal.voie_parcelle AS
WITH voie_parcelle AS
(SELECT DISTINCT ON (parcelle) parcelle, a.voie,  concat (b.ccodep, b.ccocom,'_',b.ccoriv, b.clerivili) AS fant_voie_majic, 
b.ccodep, b.ccocom, b.ccoriv, b.clerivili,b.natvoi, b.libvoi, b.codvoi, b.typvoi, c.geom
  FROM pci70_edigeo_majic.local00 AS a
  LEFT JOIN pci70_edigeo_majic.voie b ON a.voie=b.voie
  LEFT JOIN pci70_edigeo_majic.geo_parcelle c ON a.parcelle=c.geo_parcelle )
  SELECT DISTINCT ON (parcelle) parcelle, voie, fant_voie_majic, ccodep, ccocom, ccoriv, clerivili, natvoi,libvoi,codvoi,typvoi, geom FROM voie_parcelle
  WHERE geom is not null ;

DROP TABLE IF EXISTS rbal.numvoie_parcelle ;
CREATE TABLE rbal.numvoie_parcelle AS
WITH numvoie_parcelle AS
(SELECT DISTINCT ON (a.geo_numvoie)a.geo_numvoie, b.geo_parcelle, tex, geom
  FROM pci70_edigeo_majic.geo_numvoie AS a
  LEFT JOIN pci70_edigeo_majic.geo_numvoie_parcelle AS b ON a.geo_numvoie=b.geo_numvoie
  GROUP BY a.geo_numvoie, b.geo_parcelle)
  SELECT * FROM numvoie_parcelle
  
DROP TABLE IF EXISTS rbal.banid_voie ;
CREATE TABLE rbal.banid_voie AS
WITH banid_voie as
(
SELECT a.voie, concat (ccodep, ccocom,'_',ccoriv, clerivili) AS fant_voie_majic, b.numero, b.rep, b.id as ban_id
FROM pci70_edigeo_majic.voie AS a
LEFT JOIN ban.hsn_point_2154 b ON concat (ccodep, ccocom,'_',ccoriv, clerivili) =b.fant_voie
)
SELECT voie, fant_voie_majic, numero, rep, ban_id FROM banid_voie
GROUP BY fant_voie_majic, numero, rep, ban_id, voie;


DROP TABLE IF EXISTS rbal.finale ;
CREATE TABLE rbal.finale AS
SELECT b.voie, b.fant_voie_majic, ban_id, geo_numvoie, geo_parcelle, tex, numero, rep,ccodep, ccocom, ccoriv, clerivili, natvoi, libvoi, codvoi, typvoi,  geom
  FROM rbal.numvoie_parcelle AS a
  LEFT JOIN rbal.voie_parcelle AS b ON a.geo_parcelle=b.parcelle
  LEFT JOIN rbal.banid_voie AS c ON b.fant_voie_majic=c.fant_voie_majic 
  WHERE geo_parcelle is NOT NULL;

--- Schema : pci70_majic_analyses
--- Vue : batiment_parcelle_hsn_polygon_2154
--- Traitement : Positionne un batiment (surface max) par parcelle

DROP TABLE IF EXISTS pci70_majic_analyses.batiment_parcelle_hsn_polygon_2154;
CREATE TABLE pci70_majic_analyses.batiment_parcelle_hsn_polygon_2154 as 
WITH max_area_bati_parcelle AS
(SELECT geo_parcelle, surface
FROM
(WITH max_area_bati AS
(SELECT a.geo_batiment, ST_Area(geom) as surface , b.geo_parcelle
FROM pci70_edigeo_majic.geo_batiment a
LEFT JOIN pci70_edigeo_majic.geo_batiment_parcelle b ON a.geo_batiment=b.geo_batiment
ORDER BY ST_Area(geom) )
SELECT  max_area_bati.geo_parcelle, max(surface) as surface FROM max_area_bati
GROUP BY geo_parcelle)a)
SELECT max_area_bati_parcelle.geo_parcelle,bati_parcelle_geom.geo_batiment, bati_parcelle_geom.geo_dur, bati_parcelle_geom.geom, max_area_bati_parcelle.surface::int FROM max_area_bati_parcelle
LEFT JOIN
(SELECT geo_parcelle, geo_batiment, geo_dur, geom
FROM
(WITH bati_parcelle_geom AS
(SELECT DISTINCT ON (b.geo_batiment)b.geo_batiment, c.geo_dur, a.*, c.geom
FROM max_area_bati_parcelle a
LEFT JOIN pci70_edigeo_majic.geo_batiment_parcelle  b ON a.geo_parcelle=b.geo_parcelle
LEFT JOIN pci70_edigeo_majic.geo_batiment c ON b.geo_batiment=c.geo_batiment AND a.surface=ST_Area(c.geom)) 
SELECT * FROM bati_parcelle_geom)a)bati_parcelle_geom ON max_area_bati_parcelle.geo_parcelle=bati_parcelle_geom.geo_parcelle ;

--- Schema : pci70_majic_analyses
--- Vue : voie_parcelle_hsn_polygon_2154
--- Traitement : Crée une table de parcelles qui ont une voie

DROP TABLE IF EXISTS pci70_majic_analyses.voie_parcelle_hsn_polygon_2154 ;
CREATE TABLE pci70_majic_analyses.voie_parcelle_hsn_polygon_2154 AS
WITH voie_parcelle AS
(SELECT DISTINCT ON (parcelle) parcelle, a.voie,  concat (b.ccodep, b.ccocom,'_',b.ccoriv, b.clerivili) AS fant_voie_majic, 
b.ccodep, b.ccocom, b.ccoriv, b.clerivili,b.natvoi, b.libvoi, b.codvoi, b.typvoi, c.geom
  FROM pci70_edigeo_majic.local00 AS a
  LEFT JOIN pci70_edigeo_majic.voie b ON a.voie=b.voie
  LEFT JOIN pci70_edigeo_majic.geo_parcelle c ON a.parcelle=c.geo_parcelle )
  SELECT DISTINCT ON (parcelle) parcelle, voie, fant_voie_majic, ccodep, ccocom, ccoriv, clerivili, natvoi,libvoi,codvoi,typvoi, geom FROM voie_parcelle
  WHERE geom IS NOT NULL ;
  
  
DROP TABLE IF EXISTS pci70_majic_analyses.batiment_parcelle_voie_hsn_polygon_2154 ;
CREATE TABLE pci70_majic_analyses.batiment_parcelle_voie_hsn_polygon_2154 AS
SELECT parcelle, geo_batiment, geo_dur, voie, fant_voie_majic, ccodep, ccocom, ccoriv, clerivili, natvoi, libvoi, codvoi, typvoi, b.geom
FROM pci70_majic_analyses.voie_parcelle_hsn_polygon_2154 a
LEFT JOIN pci70_majic_analyses.batiment_parcelle_hsn_polygon_2154 b on a.parcelle=b.geo_parcelle;


  
  DROP TABLE IF EXISTS ban.batiment_parcelle_voie_hsn_polygon_2154 ;
CREATE TABLE ban.batiment_parcelle_voie_hsn_polygon_2154 AS
SELECT parcelle, geo_batiment, geo_dur, voie, fant_voie_majic, ccodep, ccocom, ccoriv, clerivili, natvoi, libvoi, codvoi, typvoi, c.numero, c.rep, c.id as ban_id, b.geom
  FROM ban.voie_parcelle_hsn_polygon_2154 a
  LEFT JOIN ban.batiment_parcelle_hsn_polygon_2154 b on a.parcelle=b.geo_parcelle
  LEFT JOIN ban.hsn_point_2154 c on a.fant_voie_majic=c.fant_voie;


DROP TABLE IF EXISTS ban.test ;
CREATE TABLE ban.test AS
SELECT l10.jannat, parcelle.geo_parcelle, parcelle.geo_batiment, bat.geom 
FROM pci70_edigeo_majic.local10 AS l10
INNER JOIN pci70_edigeo_majic.geo_batiment_parcelle AS parcelle ON parcelle.geo_parcelle = l10.parcelle
INNER JOIN pci70_edigeo_majic.geo_batiment AS bat ON parcelle.geo_batiment = bat.geo_batiment
GROUP BY l10.jannat, geo_parcelle, parcelle.geo_batiment, geom;




DROP TABLE IF EXISTS ban.test3 ;
CREATE TABLE ban.test3 AS
SELECT 

-- identifiant du local00,local10
A.ccosec, A.dnupla, A.invar, A.dnubat, A.descr, A.dpor,
D.dteloc_lib AS Type, E.cconlc_lib AS Nature,
C.dnupro,B.jdatat AS mutation,

--PEV

F.ccoeva_lib, pev.dvlper,
B.cc48lc, B.dloy48a, B.top48a,

--Propriétaire nom et prénom d'usage 

C.ddenom, C.epxnee, C.dnomcp, C.dprncp,

-- adresse du propriétaire 
C.dlign3,C.dlign4,C.dlign5,C.dlign6,

-- Affectation du local (pev)
G.ccoaff_lib, H.detent, pev.dsupot, pev.dcapec,
 pev.dvlpera


FROM pci70_edigeo_majic.local00 AS A

INNER JOIN pci70_edigeo_majic.local10 AS B ON B.invar = A.invar
INNER JOIN pci70_edigeo_majic.proprietaire AS C ON C.comptecommunal = B.comptecommunal
INNER JOIN pci70_edigeo_majic.dteloc AS D ON D.dteloc = B.dteloc
INNER JOIN pci70_edigeo_majic.cconlc AS E ON E.cconlc = B.cconlc
INNER JOIN pci70_edigeo_majic.ccoeva AS F ON F.ccoeva = B.ccoeva
INNER JOIN pci70_edigeo_majic.pev ON pev.local10 = B.local10
INNER JOIN pci70_edigeo_majic.ccoaff AS G ON G.ccoaff = pev.ccoaff
INNER JOIN pci70_edigeo_majic.pevprincipale AS H ON H.invar = A.invar
INNER JOIN pci70_edigeo_majic.pevtaxation AS M ON M.dnupev = pev.dnupev

WHERE A.ccosec = 'AP' AND A.dnupla = '0109'