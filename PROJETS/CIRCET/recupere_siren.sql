/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 01/05/2017
Objet : Permet de rapatrier les identifiants SIRET de la base de données SIREN
dans les sites.
Modifications : Nom : // - Date :  //- Motif/nature : //
  Nom : Faucher Marine - Date :  16/05/2017- Motif/nature : Réduit la zone de siren_geo
  pour gagner en temps de traitement, prend la valeur l2_normalisee et si null l1_normalisee pour proprio.
  Nom : Faucher Marine - Date :  17/05/2017- Motif/nature : Applique un vaccum sur la table geo_siren
  Nom : Faucher Marine - Date :  26/05/2017- Motif/nature : Simplication du script (passe de 30 minutes à 48 secondes d'exécution)
-------------------------------------------------------------------------------------
*/
/*
TEMPS DE TRAITEMENT TOTAL : 48 secondes
*/

/*
ETAPE 1 : Import et mise en forme des données SIREN
TEMPS DE TRAITEMENT : 44 secondes
*/

/* création de la table sirene_geo */
DROP TABLE IF EXISTS covage.sirene_geo_complet;
CREATE TABLE covage.sirene_geo_complet (SIREN text,NIC text,L1_NORMALISEE text,L2_NORMALISEE text,L3_NORMALISEE text,L4_NORMALISEE text,L5_NORMALISEE text,L6_NORMALISEE text,L7_NORMALISEE text,L1_DECLAREE text,L2_DECLAREE text,L3_DECLAREE text,L4_DECLAREE text,L5_DECLAREE text,L6_DECLAREE text,L7_DECLAREE text,NUMVOIE text,INDREP text,TYPVOIE text,LIBVOIE text,CODPOS text,CEDEX text,DEPET text,COMET text,TCD text,SIEGE text,ENSEIGNE text,IND_PUBLIPO text,DIFFCOM text,AMINTRET text,NATETAB text,APET700 text,DAPET text,TEFET text,EFETCENT text,DEFET text,ORIGINE text,DCRET text,DDEBACT text,ACTIVNAT text,LIEUACT text,ACTISURF text,SAISONAT text,MODET text,PRODET text,PRODPART text,AUXILT text,NOMEN_LONG text,SIGLE text,NOM text,PRENOM text,CIVILITE text,RNA text,NICSIEGE text,RPEN text,DEPCOMEN text,ADR_MAIL text,NJ text,APEN700 text,DAPEN text,APRM text,ESS text,DATEESS text,TEFEN text,EFENCENT text,DEFEN text,CATEGORIE text,DCREN text,AMINTREN text,MONOACT text,MODEN text,PRODEN text,ESAANN text,TCA text,ESAAPEN text,ESASEC1N text,ESASEC2N text,ESASEC3N text,ESASEC4N text,VMAJ text,VMAJ1 text,VMAJ2 text,VMAJ3 text,DATEMAJ text,longitude numeric,latitude numeric,geo_score numeric,geo_type text,geo_adresse text,geo_id text,geo_ligne text);

/* import des fichiers CSV issus du géocodage */
COPY covage.sirene_geo_complet FROM 'C:\csv\geo-sirene_69.csv' WITH (format csv, header true);

/* ajoute la colonne géométrique */
ALTER TABLE covage.sirene_geo_complet ADD geom geometry(point, 4326);

/* mise à jour de la colonne géométrique */
UPDATE covage.sirene_geo_complet SET geom = st_setsrid(st_makepoint(longitude, latitude),4326);

/* reprojection en 2154 */
ALTER TABLE covage.sirene_geo_complet 
ALTER COLUMN geom 
TYPE Geometry(Point, 2154) 
USING ST_Transform(geom, 2154);

/* création de l'index géométrique */
CREATE INDEX sirene_geo_geom ON covage.sirene_geo_complet USING  gist (geom);

/* création de la clé primaire */
ALTER TABLE covage.sirene_geo_complet ADD COLUMN gid SERIAL PRIMARY KEY;

/* faire un filtre sur la/les commune(s) concernées*/
DROP TABLE IF EXISTS covage.sirene_geo;
CREATE TABLE covage.sirene_geo AS 
SELECT *
FROM covage.sirene_geo_complet
WHERE codpos like '69230' or codpos like '69310';

/* concatène le numero siren et nic pour obtenir le numero siret*/
ALTER TABLE covage.sirene_geo
ADD siret varchar ;
update covage.sirene_geo set siret = concat(siren, nic);

/* création de la clé primaire */

ALTER TABLE covage.sirene_geo
  ADD PRIMARY KEY (siret);

/*
ETAPE 2.1 : Affectation des données SIREN aux sites
TEMPS DE TRAITEMENT : 2 secondes
*/

/* création de la table avec l'id et la distance */
DROP TABLE IF EXISTS covage.distance_to_site;
CREATE TABLE covage.distance_to_site AS 
    SELECT 
        a.code_st as code_st,
        b.siret,
        ST_Distance(a.geom, b.geom)::double precision as distance
    FROM
       covage.site as a,covage.sirene_geo as b 
    ORDER BY distance;
    

/* parce qu'un point site peut être près de plusieurs points siren, ne conserver que le point siren le plus proche*/
DROP TABLE IF EXISTS covage.distance_to_site_min;
CREATE TABLE covage.distance_to_site_min AS
     SELECT 
       siret,
       min(distance) as min_distance
     FROM 
       covage.distance_to_site
     WHERE distance <=50
     GROUP BY 
       siret;
       
/* création de l'index attributaire */
CREATE INDEX ON covage.distance_to_site_min (siret ASC NULLS LAST);


/* affecter l'id site*/
ALTER TABLE covage.distance_to_site_min ADD COLUMN code_st varchar;

UPDATE covage.distance_to_site_min as dis_min 
   SET code_st=dis.code_st
   FROM covage.distance_to_site as dis
   WHERE dis_min.siret=dis.siret AND dis_min.min_distance=dis.distance;

/* affecter la géométrie*/
ALTER TABLE covage.distance_to_site_min ADD COLUMN geom geometry(Point, 2154);

UPDATE covage.distance_to_site_min as dis_min
   SET geom=ST_ClosestPoint(a.geom, b.geom)
   FROM  covage.site as a, covage.sirene_geo as b 
   WHERE a.code_st=dis_min.code_st AND b.siret=dis_min.siret;

/* création de l'index géométrique */
CREATE INDEX distance_to_site_min_geom2 ON covage.distance_to_site_min USING  gist (geom);

/* creer table site temp*/
DROP TABLE IF EXISTS covage.temp;
CREATE TABLE covage.temp as 
SELECT 
  code_st, 
  siret, 
  min(min_distance) as distance,   
  geom
FROM covage.distance_to_site_min
GROUP BY 
  min_distance,
  siret,
  code_st, 
  geom
ORDER BY code_st;

/* création de la table temp_min pour ne garder que la plus petite distance par code_st*/
DROP TABLE IF EXISTS covage.temp_min;
CREATE TABLE covage.temp_min as 
SELECT 
  distinct on (code_st) code_st, 
  min(distance) distance
FROM covage.temp
GROUP BY  code_st;

/* mettre à jour le champs siret de la table temp_min avec les informations de la table temp*/
ALTER TABLE covage.temp_min ADD COLUMN siret varchar;

UPDATE covage.temp_min as a
   SET siret=b.siret
   FROM covage.temp as b
   WHERE a.code_st=b.code_st AND a.distance=b.distance;

/* création de la clé primaire */

ALTER TABLE covage.temp_min
  ADD PRIMARY KEY (siret);

/* mettre à jour la table site avec les informations de la table siren_geo*/
UPDATE covage.site as a
   SET id_site=null;
   
UPDATE covage.site as a
   SET id_site=siret
   FROM covage.temp_min as b 
   WHERE a.code_st=b.code_st ;

UPDATE covage.site as a
   SET proprio=b.l2_normalisee
   FROM covage.sirene_geo as b 
   WHERE  a.id_site=b.siret ;
   
UPDATE covage.site as a
   SET proprio=b.l1_normalisee
   FROM covage.sirene_geo as b 
   WHERE proprio is null and a.id_site=b.siret ;

UPDATE covage.site as a
   SET numero=b.numvoie
   FROM covage.sirene_geo as b 
   WHERE a.id_site=b.siret ;

UPDATE covage.site as a
   SET type_voie=b.typvoie
   FROM covage.sirene_geo as b 
   WHERE a.id_site=b.siret ;

UPDATE covage.site as a
   SET nom_voie=b.libvoie
   FROM covage.sirene_geo as b 
   WHERE a.id_site=b.siret ;

UPDATE covage.site as a
   SET c_postal=b.codpos
   FROM covage.sirene_geo as b 
   WHERE a.id_site=b.siret ;
   
/*
ETAPE 2.2 : Affectation des données SIREN aux sites restants ceux qui n'ont pas été trouvé en 2.1) == A REEXECUTER AUTANT DE FOIS QUE NECESSAIRE
TEMPS DE TRAITEMENT : 1 seconde
*/

/* conserve tous les enregistrement non référencés (sans numero SIRET)*/
DROP TABLE IF EXISTS covage.site_left;
CREATE TABLE covage.site_left as 
SELECT *
FROM covage.site
WHERE id_site is null ;

/* création de la table avec l'id et la distance */
DROP TABLE IF EXISTS covage.distance_to_site;
CREATE TABLE covage.distance_to_site AS 
    SELECT 
        a.code_st as code_st,
        b.siret,
        ST_Distance(a.geom, b.geom)::double precision as distance
    FROM
       covage.site_left as a,covage.sirene_geo as b 
    ORDER BY distance;
    

/* parce qu'un point site peut être près de plusieurs points siren, ne conserver que le point siren le plus proche*/
DROP TABLE IF EXISTS covage.distance_to_site_min;
CREATE TABLE covage.distance_to_site_min AS
     SELECT 
       a.siret,
       min(distance) as min_distance
     FROM 
       covage.distance_to_site as a, covage.site as b 
     WHERE distance <=50 
     GROUP BY 
       siret;

/* supprimer les numéros siret doublons de la table site*/
DELETE FROM covage.distance_to_site_min o
USING (
    SELECT o2.siret
    FROM covage.distance_to_site_min o2
    LEFT JOIN covage.site t ON t.id_site = o2.siret
    WHERE t.id_site IS NULL
    ) sq
WHERE sq.siret = o.siret
    ;


/* recrée la table distance_to_site_min pour pouvoir supprimer les lignes en commun*/
DROP TABLE IF EXISTS covage.distance_to_site_min_left;
CREATE TABLE covage.distance_to_site_min_left AS
     SELECT 
       a.siret,
       min(distance) as min_distance
     FROM 
       covage.distance_to_site as a, covage.site as b
     WHERE distance <=50 
     GROUP BY 
       a.siret;

DELETE FROM covage.distance_to_site_min_left USING covage.distance_to_site_min
WHERE covage.distance_to_site_min_left.siret = covage.distance_to_site_min.siret 
;
  
/* création de l'index attributaire */
CREATE INDEX ON covage.distance_to_site_min_left (siret ASC NULLS LAST);


/* affecter l'id site*/
ALTER TABLE covage.distance_to_site_min_left ADD COLUMN code_st varchar;

UPDATE covage.distance_to_site_min_left as dis_min 
   SET code_st=dis.code_st
   FROM covage.distance_to_site as dis
   WHERE dis_min.siret=dis.siret AND dis_min.min_distance=dis.distance;

/* affecter la géométrie*/

ALTER TABLE covage.distance_to_site_min_left ADD COLUMN geom geometry(Point, 2154);

UPDATE covage.distance_to_site_min_left as dis_min
   SET geom=ST_ClosestPoint(a.geom, b.geom)
   FROM  covage.site as a, covage.sirene_geo as b 
   WHERE a.code_st=dis_min.code_st AND b.siret=dis_min.siret;

/* création de l'index géométrique */
CREATE INDEX distance_to_site_min_geom ON covage.distance_to_site_min_left USING  gist (geom);

/* creer table site temp*/
DROP TABLE IF EXISTS covage.temp;
CREATE TABLE covage.temp as 
SELECT 
  code_st, 
  siret, 
  min(min_distance) as distance,   
  geom
FROM covage.distance_to_site_min_left
GROUP BY 
  min_distance,
  siret,
  code_st, 
  geom
ORDER BY code_st;

/* création de la table temp_min pour ne garder que la plus petite distance par code_st*/
DROP TABLE IF EXISTS covage.temp_min;
CREATE TABLE covage.temp_min as 
SELECT 
  distinct on (code_st) code_st, 
  min(distance) distance
FROM covage.temp
GROUP BY  code_st;

/* mettre à jour la table temp_min avec les informations de la table temp*/
ALTER TABLE covage.temp_min ADD COLUMN siret varchar;

UPDATE covage.temp_min as a
   SET siret=b.siret
   FROM covage.temp as b
   WHERE a.code_st=b.code_st AND a.distance=b.distance;

/* création de la clé primaire */

ALTER TABLE covage.temp_min
  ADD PRIMARY KEY (siret);

/* mettre à jour la table site avec les informations de la table temp*/

UPDATE covage.site as a
   SET id_site=siret
   FROM covage.temp_min as b 
   WHERE a.code_st=b.code_st ;

UPDATE covage.site as a
   SET proprio=b.l2_normalisee
   FROM covage.sirene_geo as b 
   WHERE  a.id_site=b.siret ;
   
UPDATE covage.site as a
   SET proprio=b.l1_normalisee
   FROM covage.sirene_geo as b 
   WHERE proprio is null and a.id_site=b.siret ;

UPDATE covage.site as a
   SET numero=b.numvoie
   FROM covage.sirene_geo as b 
   WHERE a.id_site=b.siret ;

UPDATE covage.site as a
   SET type_voie=b.typvoie
   FROM covage.sirene_geo as b 
   WHERE a.id_site=b.siret ;

UPDATE covage.site as a
   SET nom_voie=b.libvoie
   FROM covage.sirene_geo as b 
   WHERE a.id_site=b.siret ;

UPDATE covage.site as a
   SET c_postal=b.codpos
   FROM covage.sirene_geo as b 
   WHERE a.id_site=b.siret ;

/* relancer la partie 2.2 autant de fois que le script trouve des numéros siret*/

/* FACULTATIF
pour connaitre le nombre de doublons dans les proprios

SELECT   COUNT(proprio) AS nbr_doublon, proprio
FROM     covage.site
GROUP BY proprio
HAVING   COUNT(*) > 1

pour vérifier qu'il n'existe pas de doublons dans l'affectation des numéros siret aux sites

SELECT   COUNT(id_site) AS nbr_doublon, id_site
FROM     covage.site
GROUP BY id_site
HAVING   COUNT(*) > 1

*/

/*
ETAPE 3 : Formatage du champ "id_site"
TEMPS DE TRAITEMENT : 2 secondes
*/

/* formatage du champ id_site*/
ALTER TABLE covage.site ALTER COLUMN id_site TYPE bigint USING (id_site::bigint);

DROP TABLE IF EXISTS covage.site_format;
CREATE TABLE covage.site_format as 
SELECT to_char(id_site, '999 999 999 99999')id_site, code_st
FROM covage.site;

ALTER TABLE covage.site ALTER COLUMN id_site TYPE varchar USING (id_site::varchar);

UPDATE covage.site as a
   SET id_site=b.id_site
   FROM covage.site_format as b 
   WHERE a.code_st=b.code_st ;

/* suppression des tables intermédiaires*/
DROP TABLE IF EXISTS covage.distance_to_site;
DROP TABLE IF EXISTS covage.distance_to_site_min;
DROP TABLE IF EXISTS covage.distance_to_site_min_left;
DROP TABLE IF EXISTS covage.temp;
DROP TABLE IF EXISTS covage.temp_min;
DROP TABLE IF EXISTS covage.site_left;
DROP TABLE IF EXISTS covage.site_format;

ALTER TABLE covage.sirene_geo SET (autovacuum_vacuum_scale_factor = 0.0);  
ALTER TABLE covage.sirene_geo SET (autovacuum_vacuum_threshold = 5000);  
ALTER TABLE covage.sirene_geo SET (autovacuum_analyze_scale_factor = 0.0);  
ALTER TABLE covage.sirene_geo SET (autovacuum_analyze_threshold = 5000);  