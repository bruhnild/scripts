
SET search_path TO pci70_majic_analyses, public;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- jannat
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS jannat;
CREATE TABLE jannat AS
SELECT parcelle, CAST(jannat AS integer), CAST(jdatat AS character varying (20)) -- Date (jjmmaaaa) de l’acte de mutation du local ou de la parcelle idu, geo_parcelle 
FROM pci70_edigeo_majic.local10;

ALTER TABLE jannat
	ADD COLUMN idu character varying,
	ADD COLUMN jannath integer, -- Année d’achèvement de la construction harmonisée : l’harmonisation consiste à corriger certaines erreurs de saisie. L’emploi de jannat doit donc être privilégié par rapport à jannat 
	ADD COLUMN jannatmin integer, -- Année d’achèvement de la construction du local le plus ancien existant sur la parcelle à la date de mise à jour du millésime des fichiers fonciers
	ADD COLUMN jannatmax1 integer,
	ADD COLUMN jannatmax integer, -- Année d’achèvement de la construction du local le plus récent existant sur la parcelle à la date de mise à jour du millésime des fichiers fonciers
	ADD COLUMN jdatmut integer; -- Année de mutation



UPDATE jannat T1 SET idu = T2.idu FROM (SELECT geo_parcelle, idu FROM pci70_edigeo_majic.geo_parcelle)T2 WHERE T1.parcelle=T2.geo_parcelle;
UPDATE jannat SET jannath = CASE
	WHEN jannat>='1' AND jannat <='10' THEN jannat + '2000'
	WHEN jannat>='11' AND jannat <='20' THEN '0'
	WHEN jannat>='21' AND jannat <='99' THEN jannat + '1900'
	WHEN jannat>='100' AND jannat <= '119' THEN '0'
	WHEN jannat>='120' AND jannat <= '200' THEN CAST(CONCAT(CAST(jannat AS VARCHAR),'0') AS integer)
	WHEN jannat>='201' AND jannat <= '299' THEN '0' 
	WHEN jannat>='300' AND jannat <= '999' THEN jannat + '1000'
	WHEN jannat>='1000' AND jannat <= '1119' THEN	'0'
	WHEN jannat>='1120' AND jannat <= '1199' THEN CAST(REPLACE(CAST(jannat AS VARCHAR),LEFT(CAST(jannat AS VARCHAR),2),'19')AS integer)
	WHEN jannat>='2016' THEN '0'
	ELSE jannat
	END;
UPDATE jannat T1 SET jannatmin = T3.jannatmin FROM (SELECT T2.parcelle, MIN(jannath)AS jannatmin FROM jannat T2 WHERE jannath !='0' GROUP BY T2.parcelle)T3 WHERE T3.parcelle=T1.parcelle;
UPDATE jannat T1 SET jannatmax1 = T3.jannatmax1 FROM (SELECT T2.parcelle, MAX(jannath)AS jannatmax1 FROM jannat T2 WHERE jannath !='0' GROUP BY T2.parcelle)T3 WHERE T3.parcelle=T1.parcelle;
UPDATE jannat SET jannatmax = CASE
	WHEN jannatmax1>jannatmin THEN jannatmax1
	ELSE NULL
	END;
UPDATE jannat SET jdatmut = CAST(LEFT(jdatat,4)AS integer);


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- locaux 
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS locaux;
CREATE TABLE locaux AS
SELECT parcelle
FROM pci70_edigeo_majic.parcelle;

ALTER TABLE locaux
	ADD COLUMN nlocmaison integer, -- Nombre de locaux de type maison
	ADD COLUMN nlocappt integer, -- Nombre de locaux de type appartement
	ADD COLUMN nlochabit integer, -- Nombre de locaux de type maison ou appartement
	ADD COLUMN nlocdep integer,-- Nombre de locaux de type dépendances
	ADD COLUMN nloccom integer, -- Nombre de locaux de type commercial ou industriel
	ADD COLUMN nloccomrdc integer, -- Nombre de locaux de type commercial ou industriel situés au rezdechaussée
	ADD COLUMN tlocdomin character varying(66), -- Type de local dominant sur la parcelle (en nombre)
	ADD COLUMN nlocal integer, -- Nombre de locaux
	ADD COLUMN noccprop integer, -- Nombre de logements occupés par le propriétaire
	ADD COLUMN nocclocat integer, -- Nombre de logements occupés par un locataire
	ADD COLUMN nlocsaison integer, --Nombre de logements meublés destinés à la location occasionnelle ou saisonnière
	ADD COLUMN nvacant integer, -- Nombre de logements vacants
	ADD COLUMN nresec integer; -- Estimation du nombre de résidences secondaires

-- nlocmaison : somme des locaux de type DTELOC = 1 sur la parcelle
-- nlocappt : somme des locaux de type DTELOC = 2 sur la parcelle
-- nlochabit : somme : nlocappt+nlocmaison
-- nlocdep : somme des locaux de type DTELOC = 3 sur la parcelle
-- nloccom : somme des locaux de type DTELOC = 4 sur la parcelle
-- nlocal : somme totale des locaux
UPDATE locaux T1 SET 
	nlocmaison = T2.nlocmaison,
	nlocappt = T2.nlocappt,
	nlochabit = T2.nlochabit,
	nlocdep = T2.nlocdep,
	nloccom = T2.nloccom,
	nlocal = T2.nlocal
FROM(
	SELECT parcelle, 
	COUNT(CASE dteloc 
		WHEN '1' THEN 1 
		ELSE NULL END) AS nlocmaison,
	COUNT(CASE dteloc 
		WHEN '2' THEN 1 
		ELSE NULL END) AS nlocappt,
	COUNT(CASE dteloc 
		WHEN '1' THEN 1 
		WHEN '2' THEN 1 
		ELSE NULL END) AS nlochabit,
	COUNT(CASE dteloc 
		WHEN '3' THEN 1 
		ELSE NULL END) AS nlocdep,
	COUNT(CASE dteloc 
		WHEN '4' THEN 1 
		ELSE NULL END) AS nloccom,   
	COUNT(dteloc) AS nlocal 
	FROM pci70_edigeo_majic.local10 GROUP BY parcelle)T2 
WHERE T1.parcelle=T2.parcelle; 


-- nloccomrdc : somme des locaux de type DTELOC = 4 sur la parcelle et dniv = 00----------A TRAVAILLER
UPDATE locaux T1 SET 
	nloccomrdc = T5.nloccomrdc 
FROM(
	SELECT T2.parcelle, 
	COUNT(CASE  
		WHEN T2.dteloc = '4' AND T4.dniv='00' THEN 1 
		ELSE NULL END) AS nloccomrdc 
	FROM pci70_edigeo_majic.local10 T2 INNER JOIN pci70_edigeo_majic.local00 T4 ON T2.parcelle=T4.parcelle GROUP BY T2.parcelle)T5 
WHERE T5.parcelle=T1.parcelle;

-- tlocdomin : on retient le type (« maison », « appartement », « commercial », « dépendance ») dont le nombre de local est supérieur aux autres. S'il y a égalité, la valeur est « mixte » et s'il n'y a aucun local, la valeur est « aucun »
UPDATE locaux T1 SET tlocdomin = CASE 
	WHEN nlocmaison>nlocappt OR nlocmaison>nloccom OR nlocmaison>nlocdep THEN 'Maison' 
	WHEN nlocappt>nlocmaison OR nlocappt>nloccom OR nlocappt>nlocdep THEN 'Appartement'
	WHEN nlocdep>nlocmaison OR nlocdep>nlocappt OR nlocdep>nloccom THEN 'Dépendance'
	WHEN nloccom>nlocmaison OR nloccom>nlocappt OR nloccom>nlocdep THEN 'Commercial ou industriel'
	WHEN (nlocmaison=nlocappt OR nlocmaison=nloccom OR nlocmaison=nlocdep OR nlocappt=nloccom OR nlocappt=nlocdep OR nloccom=nlocdep) AND NOT NULL THEN 'Mixte'
	WHEN nlocmaison='0' OR nlocappt='0' OR nloccom='0' OR nlocdep='0' THEN 'Aucun'
	ELSE 'Aucune information'
	END;

-- noccprop : nombre de logements occupés par le propriétaire
-- nocclocat : nombre de logements occupés par un locataire
-- nlocsaison : nombre de logements meublés pour la location occasionnelle ou saisonnière
-- nvacant : nombre de logements vacants
UPDATE locaux T1 SET 
	noccprop=T2.noccprop,
	nocclocat=T2.nocclocat,
	nlocsaison=T2.nlocsaison,
	nvacant=T2.nvacant
FROM(
	SELECT T3.parcelle, T4.ccoaff, T4.dnupev,
	COUNT(CASE
		WHEN T4.ccthp='P' AND T4.ccoaff='H' AND T4.dnupev='001' THEN 1 ELSE NULL END) AS noccprop,
	COUNT(CASE
		WHEN T4.ccthp='L' AND T4.ccoaff='H' AND T4.dnupev='001' THEN 1 ELSE NULL END) AS nocclocat,
	COUNT(CASE
		WHEN T4.ccthp='B' AND T4.ccoaff='H' AND T4.dnupev='001' THEN 1 ELSE NULL END) AS nlocsaison,
	COUNT(CASE
		WHEN T4.ccthp='V' AND T4.ccoaff='H' AND T4.dnupev='001' THEN 1 ELSE NULL END) AS nvacant
	FROM pci70_edigeo_majic.local10 T3 INNER JOIN pci70_edigeo_majic.pev T4 ON T3.local10=T4.local10 GROUP BY T3.parcelle, T4.ccoaff, T4.dnupev)T2
WHERE T1.parcelle=T2.parcelle;

-- nresec : estimation des résidences secondaires
UPDATE locaux T1 SET nresec=T5.nresec
FROM(
	SELECT T2.parcelle, T4.dnulp, T3.dnupev,
	COUNT(CASE
		WHEN T3.ccthp='P' AND T3.dnupev='001' AND T4.dnulp='01' AND T4.ccocom_adr<>T4.ccocom THEN 1 ELSE NULL END) AS nresec
	FROM pci70_edigeo_majic.local10 T2 INNER JOIN pci70_edigeo_majic.pev T3 ON T2.local10=T3.local10 INNER JOIN pci70_edigeo_majic.proprietaire T4 ON T2.comptecommunal=T4.comptecommunal GROUP BY T2.parcelle, T4.dnulp, T3.dnupev)T5
WHERE T5.parcelle=T1.parcelle;
-- DELETE FROM logement WHERE nlocal=0;


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- prop_foncier 
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS prop_foncier2;

CREATE TABLE prop_foncier2 AS
SELECT comptecommunal, ddenom, dnulp
FROM pci70_edigeo_majic.proprietaire;

ALTER TABLE prop_foncier2
	ADD COLUMN ddenom1 character varying(60), -- Dénomination de personne physique ou morale
	ADD COLUMN adress1 character varying (250), -- Adresse concaténée
	ADD COLUMN ddenom2 character varying(60), -- Dénomination de personne physique ou morale
	ADD COLUMN adress2 character varying (250), -- Adresse concaténée
	ADD COLUMN ddenom3 character varying(60), -- Dénomination de personne physique ou morale
	ADD COLUMN adress3 character varying (250), -- Adresse concaténée
	ADD COLUMN ddenom4 character varying(60), -- Dénomination de personne physique ou morale
	ADD COLUMN adress4 character varying (250), -- Adresse concaténée
	ADD COLUMN ddenom5 character varying(60), -- Dénomination de personne physique ou morale
	ADD COLUMN adress5 character varying (250), -- Adresse concaténée
	ADD COLUMN ddenom6 character varying(60), -- Dénomination de personne physique ou morale
	ADD COLUMN adress6 character varying (250); -- Adresse concaténée

UPDATE prop_foncier2 T1 SET ddenom1 = CASE WHEN t1.dnulp='01' THEN t5.ddenom ELSE NULL END 
FROM(SELECT t3.comptecommunal, t2.ddenom ,t2.dnulp
	FROM pci70_edigeo_majic.proprietaire t2 INNER JOIN prop_foncier2 t3 ON t2.ddenom=t3.ddenom)t5 WHERE t5.ddenom = t1.ddenom;

UPDATE prop_foncier2 T1 SET adress1 = CASE WHEN t1.dnulp='01' THEN t5.dlign4 || t5.dlign6 ELSE NULL END 
FROM(SELECT t3.comptecommunal, t2.ddenom ,t2.dlign4, t2.dlign6, t2.dnulp
	FROM pci70_edigeo_majic.proprietaire t2 INNER JOIN prop_foncier2 t3 ON t2.ddenom=t3.ddenom)t5 WHERE t5.ddenom = t1.ddenom;
---------
UPDATE prop_foncier2 T1 SET ddenom2 = CASE WHEN t1.dnulp='02' THEN t5.ddenom ELSE NULL END 
FROM(SELECT t3.comptecommunal, t2.ddenom ,t2.dnulp
	FROM pci70_edigeo_majic.proprietaire t2 INNER JOIN prop_foncier2 t3 ON t2.ddenom=t3.ddenom)t5 WHERE t5.ddenom = t1.ddenom;

UPDATE prop_foncier2 T1 SET adress2 = CASE WHEN t1.dnulp='02' THEN t5.dlign4 || t5.dlign6 ELSE NULL END 
FROM(SELECT t3.comptecommunal, t2.ddenom ,t2.dlign4, t2.dlign6, t2.dnulp
	FROM pci70_edigeo_majic.proprietaire t2 INNER JOIN prop_foncier2 t3 ON t2.ddenom=t3.ddenom)t5 WHERE t5.ddenom = t1.ddenom;
---------
UPDATE prop_foncier2 T1 SET ddenom3 = CASE WHEN t1.dnulp='03' THEN t5.ddenom ELSE NULL END 
FROM(SELECT t3.comptecommunal, t2.ddenom ,t2.dnulp
	FROM pci70_edigeo_majic.proprietaire t2 INNER JOIN prop_foncier2 t3 ON t2.ddenom=t3.ddenom)t5 WHERE t5.ddenom = t1.ddenom;

UPDATE prop_foncier2 T1 SET adress3 = CASE WHEN t1.dnulp='03' THEN t5.dlign4 || t5.dlign6 ELSE NULL END 
FROM(SELECT t3.comptecommunal, t2.ddenom ,t2.dlign4, t2.dlign6, t2.dnulp
	FROM pci70_edigeo_majic.proprietaire t2 INNER JOIN prop_foncier2 t3 ON t2.ddenom=t3.ddenom)t5 WHERE t5.ddenom = t1.ddenom;
---------
UPDATE prop_foncier2 T1 SET ddenom4 = CASE WHEN t1.dnulp='04' THEN t5.ddenom ELSE NULL END 
FROM(SELECT t3.comptecommunal, t2.ddenom ,t2.dnulp
	FROM pci70_edigeo_majic.proprietaire t2 INNER JOIN prop_foncier2 t3 ON t2.ddenom=t3.ddenom)t5 WHERE t5.ddenom = t1.ddenom;

UPDATE prop_foncier2 T1 SET adress4 = CASE WHEN t1.dnulp='04' THEN t5.dlign4 || t5.dlign6 ELSE NULL END 
FROM(SELECT t3.comptecommunal, t2.ddenom ,t2.dlign4, t2.dlign6, t2.dnulp
	FROM pci70_edigeo_majic.proprietaire t2 INNER JOIN prop_foncier2 t3 ON t2.ddenom=t3.ddenom)t5 WHERE t5.ddenom = t1.ddenom;
---------
UPDATE prop_foncier2 T1 SET ddenom5 = CASE WHEN t1.dnulp='05' THEN t5.ddenom ELSE NULL END 
FROM(SELECT t3.comptecommunal, t2.ddenom ,t2.dnulp
	FROM pci70_edigeo_majic.proprietaire t2 INNER JOIN prop_foncier2 t3 ON t2.ddenom=t3.ddenom)t5 WHERE t5.ddenom = t1.ddenom;

UPDATE prop_foncier2 T1 SET adress5 = CASE WHEN t1.dnulp='05' THEN t5.dlign4 || t5.dlign6 ELSE NULL END 
FROM(SELECT t3.comptecommunal, t2.ddenom ,t2.dlign4, t2.dlign6, t2.dnulp
	FROM pci70_edigeo_majic.proprietaire t2 INNER JOIN prop_foncier2 t3 ON t2.ddenom=t3.ddenom)t5 WHERE t5.ddenom = t1.ddenom;
---------
UPDATE prop_foncier2 T1 SET ddenom6 = CASE WHEN t1.dnulp='06' THEN t5.ddenom ELSE NULL END 
FROM(SELECT t3.comptecommunal, t2.ddenom ,t2.dnulp
	FROM pci70_edigeo_majic.proprietaire t2 INNER JOIN prop_foncier2 t3 ON t2.ddenom=t3.ddenom)t5 WHERE t5.ddenom = t1.ddenom;

UPDATE prop_foncier2 T1 SET adress6 = CASE WHEN t1.dnulp='06' THEN t5.dlign4 || t5.dlign6 ELSE NULL END 
FROM(SELECT t3.comptecommunal, t2.ddenom ,t2.dlign4, t2.dlign6, t2.dnulp
	FROM pci70_edigeo_majic.proprietaire t2 INNER JOIN prop_foncier2 t3 ON t2.ddenom=t3.ddenom)t5 WHERE t5.ddenom = t1.ddenom;


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS prop_foncier;

CREATE TABLE prop_foncier AS
SELECT idu, geo_parcelle AS parcelle
FROM pci70_edigeo_majic.geo_parcelle;

ALTER TABLE prop_foncier
	ADD COLUMN comptecommunal character varying(15),
	ADD COLUMN ddenom1 character varying(60), -- Dénomination de personne physique ou morale
	ADD COLUMN adress1 character varying (250), -- Adresse concaténée
	ADD COLUMN ddenom2 character varying(60), -- Dénomination de personne physique ou morale
	ADD COLUMN adress2 character varying (250), -- Adresse concaténée
	ADD COLUMN ddenom3 character varying(60), -- Dénomination de personne physique ou morale
	ADD COLUMN adress3 character varying (250), -- Adresse concaténée
	ADD COLUMN ddenom4 character varying(60), -- Dénomination de personne physique ou morale
	ADD COLUMN adress4 character varying (250), -- Adresse concaténée
	ADD COLUMN ddenom5 character varying(60), -- Dénomination de personne physique ou morale
	ADD COLUMN adress5 character varying (250), -- Adresse concaténée
	ADD COLUMN ddenom6 character varying(60), -- Dénomination de personne physique ou morale
	ADD COLUMN adress6 character varying (250), -- Adresse concaténée
	ADD COLUMN ccodro character varying(1), -- code du droit réel ou particulier - Nouveau code en 2009 : C (fiduciaire)
	ADD COLUMN dnulp character varying(2), -- Libellé partiel : nombre de personnes exerçant un droit réel sur le bien.
	ADD COLUMN ccogrm character varying (2), -- Code groupe de personne morale
	ADD COLUMN ccogrmtxt character varying(46); -- Libellé code de personne morale

	UPDATE prop_foncier t1 
SET comptecommunal = t5.comptecommunal 
FROM (
	SELECT t3.parcelle, t2.comptecommunal 
	FROM pci70_edigeo_majic.proprietaire t2 
	INNER JOIN pci70_edigeo_majic.parcelle t3 ON t2.comptecommunal=t3.comptecommunal 
	INNER JOIN prop_foncier t4 ON t3.parcelle=t4.parcelle)t5 
	WHERE t5.parcelle = t1.parcelle;
	
	---------
UPDATE prop_foncier t1 SET ddenom1 = t5.ddenom1
FROM (SELECT t3.parcelle, t2.comptecommunal, MAX(t2.ddenom1) AS ddenom1 
	FROM prop_foncier2 t2  
	INNER JOIN pci70_edigeo_majic.parcelle t3 ON t2.comptecommunal=t3.comptecommunal 
	INNER JOIN prop_foncier t4 ON t3.parcelle=t4.parcelle 
	GROUP BY t3.parcelle, t2.comptecommunal)t5 
	WHERE t5.parcelle = t1.parcelle;

---------
UPDATE prop_foncier t1 SET ddenom2 = t5.ddenom2
FROM (SELECT t3.parcelle, t2.comptecommunal, MAX(t2.ddenom2) AS ddenom2 
	FROM prop_foncier2 t2  
	INNER JOIN pci70_edigeo_majic.parcelle t3 ON t2.comptecommunal=t3.comptecommunal 
	INNER JOIN prop_foncier t4 ON t3.parcelle=t4.parcelle 
	GROUP BY t3.parcelle, t2.comptecommunal)t5 
	WHERE t5.parcelle = t1.parcelle;

UPDATE prop_foncier t1 SET adress2 = t5.adress2
FROM (SELECT t3.parcelle, t2.comptecommunal, MAX(t2.adress2) AS adress2 
	FROM prop_foncier2 t2  
	INNER JOIN pci70_edigeo_majic.parcelle t3 ON t2.comptecommunal=t3.comptecommunal 
	INNER JOIN prop_foncier t4 ON t3.parcelle=t4.parcelle 
	GROUP BY t3.parcelle, t2.comptecommunal)t5 
	WHERE t5.parcelle = t1.parcelle;
---------
UPDATE prop_foncier t1 SET ddenom3 = t5.ddenom3
FROM (SELECT t3.parcelle, t2.comptecommunal, MAX(t2.ddenom3) AS ddenom3 
	FROM prop_foncier2 t2  
	INNER JOIN pci70_edigeo_majic.parcelle t3 ON t2.comptecommunal=t3.comptecommunal 
	INNER JOIN prop_foncier t4 ON t3.parcelle=t4.parcelle 
	GROUP BY t3.parcelle, t2.comptecommunal)t5 
	WHERE t5.parcelle = t1.parcelle;

UPDATE prop_foncier t1 SET adress3 = t5.adress3
FROM (SELECT t3.parcelle, t2.comptecommunal, MAX(t2.adress3) AS adress3 
	FROM prop_foncier2 t2  
	INNER JOIN pci70_edigeo_majic.parcelle t3 ON t2.comptecommunal=t3.comptecommunal 
	INNER JOIN prop_foncier t4 ON t3.parcelle=t4.parcelle 
	GROUP BY t3.parcelle, t2.comptecommunal)t5 
	WHERE t5.parcelle = t1.parcelle;
---------
UPDATE prop_foncier t1 SET ddenom4 = t5.ddenom4
FROM (SELECT t3.parcelle, t2.comptecommunal, MAX(t2.ddenom4) AS ddenom4 
	FROM prop_foncier2 t2  
	INNER JOIN pci70_edigeo_majic.parcelle t3 ON t2.comptecommunal=t3.comptecommunal 
	INNER JOIN prop_foncier t4 ON t3.parcelle=t4.parcelle 
	GROUP BY t3.parcelle, t2.comptecommunal)t5 
	WHERE t5.parcelle = t1.parcelle;

UPDATE prop_foncier t1 SET adress4 = t5.adress4
FROM (SELECT t3.parcelle, t2.comptecommunal, MAX(t2.adress4) AS adress4 
	FROM prop_foncier2 t2  
	INNER JOIN pci70_edigeo_majic.parcelle t3 ON t2.comptecommunal=t3.comptecommunal 
	INNER JOIN prop_foncier t4 ON t3.parcelle=t4.parcelle 
	GROUP BY t3.parcelle, t2.comptecommunal)t5 
	WHERE t5.parcelle = t1.parcelle;
---------
UPDATE prop_foncier t1 SET ddenom5 = t5.ddenom5
FROM (SELECT t3.parcelle, t2.comptecommunal, MAX(t2.ddenom5) AS ddenom5 
	FROM prop_foncier2 t2  
	INNER JOIN pci70_edigeo_majic.parcelle t3 ON t2.comptecommunal=t3.comptecommunal 
	INNER JOIN prop_foncier t4 ON t3.parcelle=t4.parcelle 
	GROUP BY t3.parcelle, t2.comptecommunal)t5 
	WHERE t5.parcelle = t1.parcelle;

UPDATE prop_foncier t1 SET adress5 = t5.adress5
FROM (SELECT t3.parcelle, t2.comptecommunal, MAX(t2.adress5) AS adress5 
	FROM prop_foncier2 t2  
	INNER JOIN pci70_edigeo_majic.parcelle t3 ON t2.comptecommunal=t3.comptecommunal 
	INNER JOIN prop_foncier t4 ON t3.parcelle=t4.parcelle 
	GROUP BY t3.parcelle, t2.comptecommunal)t5 
	WHERE t5.parcelle = t1.parcelle;
---------
UPDATE prop_foncier t1 SET ddenom6 = t5.ddenom6
FROM (SELECT t3.parcelle, t2.comptecommunal, MAX(t2.ddenom6) AS ddenom6 
	FROM prop_foncier2 t2  
	INNER JOIN pci70_edigeo_majic.parcelle t3 ON t2.comptecommunal=t3.comptecommunal 
	INNER JOIN prop_foncier t4 ON t3.parcelle=t4.parcelle 
	GROUP BY t3.parcelle, t2.comptecommunal)t5 
	WHERE t5.parcelle = t1.parcelle;

UPDATE prop_foncier t1 SET adress6 = t5.adress6
FROM (SELECT t3.parcelle, t2.comptecommunal, MAX(t2.adress6) AS adress6 
	FROM prop_foncier2 t2  
	INNER JOIN pci70_edigeo_majic.parcelle t3 ON t2.comptecommunal=t3.comptecommunal 
	INNER JOIN prop_foncier t4 ON t3.parcelle=t4.parcelle 
	GROUP BY t3.parcelle, t2.comptecommunal)t5 
	WHERE t5.parcelle = t1.parcelle;
---------
UPDATE prop_foncier t1 
SET ccodro = t5.ccodro 
FROM (
	SELECT t3.parcelle, t2.ccodro 
	FROM pci70_edigeo_majic.proprietaire t2 
	INNER JOIN pci70_edigeo_majic.parcelle t3 ON t2.comptecommunal=t3.comptecommunal 
	INNER JOIN prop_foncier t4 ON t3.parcelle=t4.parcelle)t5 
	WHERE t5.parcelle = t1.parcelle;

UPDATE prop_foncier t1 
SET dnulp = t5.dnulp 
FROM (
	SELECT t3.parcelle, t2.dnulp 
	FROM pci70_edigeo_majic.proprietaire t2 
	INNER JOIN pci70_edigeo_majic.parcelle t3 ON t2.comptecommunal=t3.comptecommunal 
	INNER JOIN prop_foncier t4 ON t3.parcelle=t4.parcelle)t5 
	WHERE t5.parcelle = t1.parcelle;

UPDATE prop_foncier t1 
SET ccogrm = t5.ccogrm 
FROM (
	SELECT t3.parcelle, t2.ccogrm
	FROM pci70_edigeo_majic.proprietaire t2 
	INNER JOIN pci70_edigeo_majic.parcelle t3 ON t2.comptecommunal=t3.comptecommunal 
	INNER JOIN prop_foncier t4 ON t3.parcelle=t4.parcelle)t5 
	WHERE t5.parcelle = t1.parcelle;

UPDATE prop_foncier t1 
SET ccogrmtxt = CASE
	WHEN ccogrm = '0' THEN 'Autres personnes morales'
	WHEN ccogrm = '1' THEN 'Etat'
	WHEN ccogrm = '2' THEN 'Région'
	WHEN ccogrm = '3' THEN 'Département'
	WHEN ccogrm = '4' THEN 'Commune'
	WHEN ccogrm = '5' THEN 'Office HLM'
	WHEN ccogrm = '6' THEN 'Personnes morales représentant des sociétés'
	WHEN ccogrm = '7' THEN 'Copropriété'
	WHEN ccogrm = '8' THEN 'Associés'
	WHEN ccogrm = '9' THEN 'Etablissement public'
	ELSE 'Particulier'
	END;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- geo_foncier_locaux 
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


DROP TABLE IF EXISTS geo_foncier_locaux;
CREATE TABLE geo_foncier_locaux AS
SELECT geo_parcelle AS parcelle, geom, idu
FROM pci70_edigeo_majic.geo_parcelle;

-- parcelle

ALTER TABLE geo_foncier_locaux
	ADD COLUMN code_insee character varying(5), -- Concaténation du code département et du code commune  	
	ADD COLUMN dcntpa integer, -- Contenance de la parcelle - en centiares
	ADD COLUMN comptecommunal character varying(15); -- Compte communal de propriétaires

UPDATE geo_foncier_locaux T1 SET 
		code_insee = T2.code_insee, 
		dcntpa = T2.dcntpa, 
		comptecommunal = T2.comptecommunal 
	FROM (SELECT 
		parcelle, 
		CONCAT(ccodep, ccocom)AS code_insee, 
		dcntpa, 
		comptecommunal 
	FROM pci70_edigeo_majic.parcelle)T2 
	WHERE T1.parcelle = T2.parcelle; 

-- locaux

ALTER TABLE geo_foncier_locaux
	ADD COLUMN nlocmaison integer, -- Nombre de locaux de type maison
	ADD COLUMN nlocappt integer, -- Nombre de locaux de type appartement
	ADD COLUMN nlochabit integer, -- Nombre de locaux de type maison ou appartement
	ADD COLUMN nlocdep integer,-- Nombre de locaux de type dépendances
	ADD COLUMN nloccom integer, -- Nombre de locaux de type commercial ou industriel
	ADD COLUMN nloccomrdc integer, -- Nombre de locaux de type commercial ou industriel situés au rezdechaussée
	ADD COLUMN tlocdomin character varying(66), -- Type de local dominant sur la parcelle (en nombre)
	ADD COLUMN nlocal integer, -- Nombre de locaux
	ADD COLUMN noccprop integer, -- Nombre de logements occupés par un propriétaire
	ADD COLUMN nocclocat integer, -- Nombre de logements occupés par un locataire
	ADD COLUMN nlocsaison integer, -- Nombre de logements meublés destinés à la location occasionnelle ou saisonnière
	ADD COLUMN nvacant integer, -- Nombre de logements vacants
	ADD COLUMN nresec integer; -- Estimation du nombre de résidences secondaires

UPDATE geo_foncier_locaux T1 SET 
		nlocmaison = T2.nlocmaison,  
		nlocappt = T2.nlocappt, 
		nlochabit = T2.nlochabit, 
		nlocdep = T2.nlocdep,
		nloccom = T2.nloccom,
		nloccomrdc = T2.nloccomrdc,
		tlocdomin = T2.tlocdomin,
		nlocal = T2.nlocal,
		noccprop = T2.noccprop,
		nocclocat = T2.nocclocat,
		nlocsaison = T2.nlocsaison,
		nvacant = T2.nvacant,
		nresec = T2.nresec
	FROM (SELECT 
		parcelle,
		nlocmaison,  
		nlocappt, 
		nlochabit, 
		nlocdep,
		nloccom,
		nloccomrdc,
		tlocdomin,
		nlocal,
		noccprop,
		nocclocat,
		nlocsaison,
		nvacant,
		nresec 
	FROM locaux)T2 
	WHERE T1.parcelle = T2.parcelle; 

-- jannat

ALTER TABLE geo_foncier_locaux
	ADD COLUMN jannatmin integer, -- Année d’achèvement de la construction du local le plus ancien existant sur la parcelle à la date de mise à jour de la matrice cadastrale
	ADD COLUMN jannatmax integer, -- Année d’achèvement de la construction du local le plus récent existant sur la parcelle à la date de mise à jour de la matrice cadastrale
	ADD COLUMN jdatmut character varying (4); -- Année de mutation du local ou de la parcelle

UPDATE geo_foncier_locaux T1 SET 
		jannatmin = T4.jannatmin,  
		jannatmax = T4.jannatmax, 
		jdatmut = T4.jdatmut
	FROM (SELECT 
		T2.parcelle,
		T2.jannatmin,  
		T2.jannatmax, 
		T2.jdatmut 
	FROM jannat T2 INNER JOIN geo_foncier_locaux T3 ON T2.parcelle=T3.parcelle)T4 
	WHERE T1.parcelle = T4.parcelle; 

-- prop_foncier

ALTER TABLE geo_foncier_locaux
	ADD COLUMN ddenom1 character varying(60), -- Dénomination de personne physique ou morale
	ADD COLUMN adress1 character varying (250), -- Adresse concaténée
	ADD COLUMN ddenom2 character varying(60), -- Dénomination de personne physique ou morale
	ADD COLUMN adress2 character varying (250), -- Adresse concaténée
	ADD COLUMN ddenom3 character varying(60), -- Dénomination de personne physique ou morale
	ADD COLUMN adress3 character varying (250), -- Adresse concaténée
	ADD COLUMN ddenom4 character varying(60), -- Dénomination de personne physique ou morale
	ADD COLUMN adress4 character varying (250), -- Adresse concaténée
	ADD COLUMN ddenom5 character varying(60), -- Dénomination de personne physique ou morale
	ADD COLUMN adress5 character varying (250), -- Adresse concaténée
	ADD COLUMN ddenom6 character varying(60), -- Dénomination de personne physique ou morale
	ADD COLUMN adress6 character varying (250), -- Adresse concaténée
	ADD COLUMN ccodro character varying(1), -- code du droit réel ou particulier - Nouveau code en 2009 : C (fiduciaire)
	ADD COLUMN dnulp character varying(2), -- Libellé partiel : nombre de personnes exerçant un droit réel sur le bien
	ADD COLUMN ccogrm character varying (2), -- Code groupe de personne morale
	ADD COLUMN ccogrmtxt character varying(46); -- Libellé code de personne morale

UPDATE geo_foncier_locaux T1 SET 
		ddenom1 = T4.ddenom1,
		adress1 = T4.adress1,
		ddenom2 = T4.ddenom2,
		adress2 = T4.adress2,
		ddenom3 = T4.ddenom3,
		adress3 = T4.adress3,
		ddenom4 = T4.ddenom4,
		adress4 = T4.adress4,
		ddenom5 = T4.ddenom5,
		adress5 = T4.adress5,
		ddenom6 = T4.ddenom6,
		adress6 = T4.adress6,
		ccodro = T4.ccodro, 
		dnulp = T4.dnulp,
		ccogrm = T4.ccogrm,
		ccogrmtxt = T4.ccogrmtxt
	FROM (SELECT
		T2.parcelle,
		T2.ddenom1,
		T2.adress1,
		T2.ddenom2,
		T2.adress2,
		T2.ddenom3,
		T2.adress3,
		T2.ddenom4,
		T2.adress4,
		T2.ddenom5,
		T2.adress5,
		T2.ddenom6,
		T2.adress6,
		T2.ccodro, 
		T2.dnulp, 
		T2.ccogrm,
		T2.ccogrmtxt
	FROM prop_foncier T2 INNER JOIN geo_foncier_locaux T3 ON T2.parcelle=T3.parcelle)T4 
	WHERE T1.parcelle = T4.parcelle; 

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Requête pour supprimer les doublons
DELETE FROM geo_foncier_locaux WHERE parcelle NOT IN (
  SELECT max(parcelle) FROM geo_foncier_locaux
  GROUP BY parcelle);

--DROP TABLE IF EXISTS locaux;
--DROP TABLE IF EXISTS jannat;
--DROP TABLE IF EXISTS prop_foncier;