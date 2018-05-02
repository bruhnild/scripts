/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 05/05/2018
Objet : Création du processus de geocodage inversé avec les routes et les tournées facteurs
Modification : Nom : ///// - Date : date_de_modif - Motif/nature : //////

-------------------------------------------------------------------------------------
*/

/*

--- Schema : ban
--- Vue : t_ban_travail							
--- Traitement : Création des tables t_ban_travail et t_ban_tournee

SET search_path TO metiposte_tunisie, ban;

DROP TABLE IF EXISTS t_ban_travail CASCADE;

CREATE TABLE t_ban_travail(	
	id_voie VARCHAR(254) NOT NULL,
	typ_voi_fr VARCHAR(50),
	typ_voi_ar VARCHAR(50),
	nom_voi_fr VARCHAR(100),
	nom_voi_ar VARCHAR(100),
	num_deb_fr INTEGER,
	num_deb_ar INTEGER,
	num_fin_fr INTEGER,
	num_fin_ar INTEGER,
	cd_post_fr VARCHAR(5),
	cd_post_ar VARCHAR(5),
	cd_tour_fr VARCHAR(10), 
	cd_tour_ar VARCHAR(10),
	ctr_rat_fr VARCHAR(10) ,
	ctr_rat_ar VARCHAR(3),
	source VARCHAR(50),
	dat_maj DATE,
	long FLOAT,
	lat FLOAT,
CONSTRAINT "t_ban_travail_pk" PRIMARY KEY (id_voie));	

DROP INDEX IF EXISTS typ_voi_fr_idx; CREATE INDEX  typ_voi_fr_idx ON t_ban_travail(typ_voi_fr);
DROP INDEX IF EXISTS typ_voi_ar_idx; CREATE INDEX  typ_voi_ar_idx ON t_ban_travail(typ_voi_ar);
DROP INDEX IF EXISTS nom_voi_fr_idx; CREATE INDEX  nom_voi_fr_idx ON t_ban_travail(nom_voi_fr);
DROP INDEX IF EXISTS nom_voi_ar_idx; CREATE INDEX  nom_voi_ar_idx ON t_ban_travail(nom_voi_ar);
DROP INDEX IF EXISTS cd_post_fr_idx; CREATE INDEX  cd_post_fr_idx ON t_ban_travail(cd_post_fr);
DROP INDEX IF EXISTS cd_post_ar_idx; CREATE INDEX  cd_post_ar_idx ON t_ban_travail(cd_post_ar);
DROP INDEX IF EXISTS cd_tour_fr_idx; CREATE INDEX  cd_tour_fr_idx ON t_ban_travail(cd_tour_fr);
DROP INDEX IF EXISTS cd_tour_ar_idx; CREATE INDEX  cd_tour_ar_idx ON t_ban_travail(cd_tour_ar);
DROP INDEX IF EXISTS ctr_rat_fr_idx; CREATE INDEX  ctr_rat_fr_idx ON t_ban_travail(ctr_rat_fr);
DROP INDEX IF EXISTS ctr_rat_ar_idx; CREATE INDEX  ctr_rat_ar_idx ON t_ban_travail(ctr_rat_ar);

DROP TABLE IF EXISTS ban.t_ban_tournee CASCADE;

CREATE TABLE ban.t_ban_tournee(	
	id SERIAL,
	remarqu_fr VARCHAR(254),
	typ_voi_fr VARCHAR(50),
	nom_voi_fr VARCHAR(100),
	cd_post_fr VARCHAR(5),
	typ_par_fr VARCHAR(50),
	num_deb_fr VARCHAR(5),
	num_fin_fr VARCHAR(5),
	cd_tour_fr INTEGER,
	ville_fr VARCHAR(50),
	pays_fr VARCHAR(50),
	comment_fr VARCHAR(254),
	statut_fr VARCHAR(50),
	source VARCHAR(50));

DROP INDEX IF EXISTS typ_voi_fr_idx; CREATE INDEX  typ_voi_fr_idx ON ban.t_ban_tournee(typ_voi_fr);
DROP INDEX IF EXISTS nom_voi_fr_idx; CREATE INDEX  nom_voi_fr_idx ON ban.t_ban_tournee(nom_voi_fr);
DROP INDEX IF EXISTS cd_post_fr_idx; CREATE INDEX  cd_post_fr_idx ON ban.t_ban_tournee(cd_post_fr);
DROP INDEX IF EXISTS cd_tour_fr_idx; CREATE INDEX  cd_tour_fr_idx ON ban.t_ban_tournee(cd_tour_fr);
DROP INDEX IF EXISTS ville_fr_idx; CREATE INDEX  ville_fr_idx ON ban.t_ban_tournee(ville_fr);

/*
-------------------------------------------------------------------------------------
ETAPE 0 : PREPARATION DES DONNEES DE TOURNEES
-------------------------------------------------------------------------------------
*/

--- Schema : ban
--- Vue : t_ban_tournee							
--- Traitement : Insertion des nouvelles entités de routes dans la table principale

INSERT INTO ban.t_ban_tournee  ( 
remarqu_fr, 
typ_voi_fr, 
nom_voi_fr, 
cd_post_fr, 
typ_par_fr, 
num_deb_fr, 
num_fin_fr, 
cd_tour_fr, 
ville_fr,
pays_fr,
comment_fr, 
statut_fr,
source
)
SELECT
remarque, 
"type voie", 
"nom de la voie", 
"code postal", 
"type parit�e", 
"num�ro debut", 
"num�ro fin", 
"code tourn�e", 
'Lamarsa' as ville_fr,
'Tunisie'::varchar as pays_fr,
commentaire, 
statut,
'tournee_lamarsa'::varchar as source
from ban.t_tournee_lamarsa

/*
-------------------------------------------------------------------------------------
ETAPE 1 : PREPARATION DES DONNEES DE ROUTES
-------------------------------------------------------------------------------------
*/

--- Schema : routes
--- Vue : t_delegations							
--- Traitement : Insertion des nouvelles entités de routes dans la table principale

INSERT INTO routes.t_delegations  ( 
geom, 
objectid,
adresse, 
sensnav, 
vitesse, 
classrue, 
adresseara, 
typeroute, 
id, 
num_debut, num_fin, 
paritee, 
commentair, 
statut, 
xcoord, ycoord, 
nom_del_fr

)
SELECT
geom, 
objectid,
adresse, 
sensnav, 
vitesse, 
classrue, 
adresseara, 
typeroute, 
id, 
num_debut::varchar, num_fin:int, 
paritee, 
commentair, 
null::varchar as statut, 
st_x(st_centroid(geom)) as xcoord, st_y(st_centroid(geom)) as ycoord, 
'nom del fr'::varchar as nom_del_fr
from routes.t_nouvelles_routes)

--- Schema : routes
--- Vue : arianaville_merge							
--- Traitement : Merge les lignes de routes par adresse

CREATE OR REPLACE VIEW routes.v_delegations AS
SELECT row_number() over() AS gid, * 
FROM(
SELECT 
ST_LineMerge(ST_Collect(geom)) as geom, 
lower(replace(name2uri(adresse), '-', ' '))adresse, nom_del_fr, 
concat(lower(replace(name2uri(adresse), '-', ' ')), '_', nom_del_fr)adresse_del
FROM routes.t_delegations
where adresse is not null 
GROUP BY adresse, nom_del_fr)a;

--- Schema : routes
--- Vue : arianaville_merge_multilinestring							
--- Traitement : Isole les lignes mergées qui sont en multilinestring


CREATE OR REPLACE VIEW routes.v_delegations_multilinestring AS
SELECT row_number() over() AS gid, * 
FROM 
(SELECT
 result.merge_geom as geom,
 st_geometrytype(merge_geom) as type,
 result.adresse,
 result.nom_del_fr,
 result.adresse_del
FROM
 (SELECT st_linemerge(geom) as merge_geom, st_geometrytype(geom) as type, adresse, nom_del_fr, adresse_del FROM routes.v_delegations ) AS result
WHERE st_geometrytype(merge_geom) = 'ST_MultiLineString')a;
/*
-------------------------------------------------------------------------------------
ETAPE 2 : MAJ ban.t_ban_travail
-------------------------------------------------------------------------------------
*/

--- Schema : ban
--- Vue : t_ban_travail							
--- Traitement : Insertion des nouvelles entités de routes dans la table principale
/*
INSERT INTO ban.t_ban_travail (
id_voie, geom, 
typ_voi_fr, typ_voi_ar, 
nom_voi_fr, nom_voi_ar, 
num_deb_fr, num_deb_ar, 
num_fin_fr, num_fin_ar, 
cd_post_fr, cd_post_ar, 
ville_fr, ville_ar, 
pays_fr, pays_ar, 
cd_tour_fr, cd_tour_ar, 
ctr_rat_fr, ctr_rat_ar, 
source, dat_maj, 
xcoord, ycoord
)
SELECT
concat(cd_post_fr,'_',num_deb_fr,'-',num_fin_fr,'_',typ_voi_fr,'_',nom_voi_fr,'_',ville_fr) as id_voie, 
geom, 
typ_voi_fr, typ_voi_ar, 
nom_voi_fr, nom_voi_ar, 
num_deb_fr::varchar, num_deb_ar::varchar, 
num_fin_fr::varchar, num_fin_ar::varchar, 
cd_post_fr, cd_post_ar, 
ville_fr, ville_ar, 
pays_fr, pays_ar, 
cd_tour_fr, cd_tour_ar, 
ctr_rat_fr, ctr_rat_ar, 
source, dat_maj, 
xcoord, ycoord
FROM ban.t_ban_travail_nouvelletournee;
*/

INSERT INTO ban.t_ban_travail (
id_voie, 
typ_voi_fr,
nom_voi_fr,
num_deb_fr, 
num_fin_fr, 
cd_post_fr, 
ville_fr, 
pays_fr,
cd_tour_fr, 
source
)
SELECT
concat(cd_post_fr,'_',num_deb_fr,'-',num_fin_fr,'_',typ_voi_fr,'_',nom_voi_fr,'_',ville_fr) as id_voie, 
typ_voi_fr, 
nom_voi_fr,
num_deb_fr::varchar, 
num_fin_fr::varchar,
cd_post_fr, 
ville_fr,
pays_fr, 
cd_tour_fr::int, 
source
FROM ban.t_ban_tournee;



/*
-------------------------------------------------------------------------------------
ETAPE 3 : GEOCODAGE
-------------------------------------------------------------------------------------
*/

--- Schema : ban
--- Vue : v_ban_travail             
--- Traitement : Fait matcher les adresse de routes avec celles de la tournée en 
--- ne prenant que les linestrings.

CREATE OR REPLACE VIEW ban.v_ban_travail AS 
SELECT row_number() over() AS gid, * 
FROM
(WITH adresse_all AS 
(SELECT 
 typ_voi_fr, 
 nom_voi_fr, 
 num_deb_fr, num_fin_fr, 
 cd_post_fr,
 ville_fr,
 pays_fr, 
 cd_tour_fr,
 ctr_rat_fr, 
 source, 
 dat_maj, 
 id_voie,
 concat(typ_voi_fr, ' ',nom_voi_fr,'_',ville_fr) as adresse_ban, 
 a.adresse_del as adresse_route, 
 a.geom from (
WITH a_conserver AS
(
SELECT DISTINCT adresse_del, geom
FROM routes.v_delegations AS num
WHERE num.adresse_del  NOT IN  
(SELECT DISTINCT adresse_del
FROM routes.v_delegations_multilinestring  opp
WHERE adresse_del=adresse_del
GROUP BY adresse_del
))
select *
from a_conserver
order by adresse_del)a, ban.t_ban_travail b )
SELECT 
typ_voi_fr, null::varchar as typ_voi_ar, 
nom_voi_fr, null::varchar as nom_voi_ar,
num_deb_fr::int, null::int as num_deb_ar,
num_fin_fr::int, null::int as num_fin_ar,
cd_post_fr, null::varchar as cd_post_ar,
ville_fr,null::varchar as ville_ar,
pays_fr, null::varchar as pays_ar,
null::varchar as suffixe_fr, null::varchar as suffixe_ar, 
null::varchar as nom_imm_fr, null::varchar as nom_imm_ar, 
cd_tour_fr, null::varchar as cd_tour_ar,
ctr_rat_fr, null::varchar as ctr_rat_ar,
null::int as nb_pro_fr, null::int as nb_pro_ar, 
null::int as nb_ind_fr, null::int as nb_ind_ar, 
null::int as nb_tot_af, null::int as nb_tot_ar, 
source, 
dat_maj, 
id_voie,
null::varchar as geonyme, 
geom
FROM adresse_all as a
where a.adresse_ban=a.adresse_route and ASCII(SUBSTR(num_deb_fr, 1, 1)) BETWEEN 48 AND 57
group by  id_voie, adresse_route, adresse_ban, geom, typ_voi_fr, nom_voi_fr, num_deb_fr, num_fin_fr, cd_post_fr, ville_fr, pays_fr, cd_tour_fr, ctr_rat_fr, source, dat_maj
)a




--- Schema : ban
--- Vue : v_ban_repositionnement							
--- Traitement : Interpole les lignes en points adresse et crée l'id

CREATE OR REPLACE VIEW ban.v_ban_repositionnement AS 
SELECT 
a.gid, 
concat(b.cd_post_fr,'_',b.num_voi_fr,'_',b.suffixe_fr,'_',b.nom_imm_fr,'_',b.typ_voi_fr,'_',b.nom_voi_fr,'_',b.ville_fr)::varchar  as id,
b.typ_voi_fr, b.typ_voi_ar, 
b.nom_voi_fr, b.nom_voi_ar, 
b.num_voi_fr, b.num_voi_ar,
b.suffixe_fr, b.suffixe_ar,
b.nom_imm_fr, b.nom_imm_ar, 
b.cd_post_fr, b.cd_post_ar,
b.ville_fr,b.ville_ar,
b.pays_fr, b.pays_ar,
b.cd_tour_fr, b.cd_tour_ar, 
b.ctr_rat_fr, b.ctr_rat_ar, 
b.nb_pro_fr, b.nb_pro_ar, 
b.nb_ind_fr, b.nb_ind_ar, 
b.nb_tot_af, b.nb_tot_ar, 
b.source, 
'A repositionner'::varchar  as statut,
b.dat_maj, 
b.geonyme,  
st_x(a.geom) as xcoord,
st_y(a.geom) as ycoord,
a.geom
FROM
(SELECT
gid,
id_voie,
typ_voi_fr,
nom_voi_fr,
num_voi_fr+1 as num_voi_fr,
geom_add as geom
FROM
(WITH num_voi AS (
    SELECT
	  id_voie,
	  typ_voi_fr,
	  nom_voi_fr,
      num_fin_fr - num_deb_fr AS num_voi_fr,
      geom
    FROM ban.v_ban_travail
), genere_add AS (
    SELECT
      t.*,
      g,
      g / num_voi_fr :: FLOAT AS fraction
    FROM num_voi t CROSS JOIN generate_series(0, num_voi_fr) AS g
) select row_number() over() AS gid, id_voie, typ_voi_fr,nom_voi_fr,g as num_voi_fr, st_lineinterpolatepoint(ST_LineMerge(geom), fraction) as geom_add
from genere_add)a)a
LEFT JOIN
(
SELECT   row_number() over() AS gid, * 
FROM
(SELECT
id_voie,
typ_voi_fr, typ_voi_ar, 
nom_voi_fr, nom_voi_ar, 
generate_series(num_deb_fr,num_fin_fr)as num_voi_fr,null::int as num_voi_ar, 
suffixe_fr, suffixe_ar, 
nom_imm_fr, nom_imm_ar, 
cd_post_fr, cd_post_ar,
ville_fr,ville_ar,
pays_fr, pays_ar,
cd_tour_fr, cd_tour_ar, 
ctr_rat_fr, ctr_rat_ar, 
nb_pro_fr, nb_pro_ar, 
nb_ind_fr, nb_ind_ar, 
nb_tot_af, nb_tot_ar, 
source, 
dat_maj, 
geonyme, 
geom
from ban.v_ban_travail)a)b
ON a.gid=b.gid
;



/*
-------------------------------------------------------------------------------------
ETAPE 4 : CREATION DE LA TABLE ban.t_ban_repositionnement
-------------------------------------------------------------------------------------



WITH a_supprimer AS
(
SELECT DISTINCT id
FROM ban.v_ban_repositionnement   AS num
WHERE num.id  NOT IN  
(SELECT DISTINCT id
from ban.t_ban_repositionnement_test 
where id=id
group by id))
select *
from a_supprimer
order by id



drop table if exists ban.t_ban_repositionnement_test;
create table ban.t_ban_repositionnement_test  as 
SELECT *
FROM ban.t_ban_repositionnement;

 
CREATE OR REPLACE FUNCTION update_t_ban_repositionnement() RETURNS TRIGGER AS $$
BEGIN
INSERT INTO t_ban_repositionnement_test  ( 
id, 
geom, 
typ_voi_fr, typ_voi_ar, 
nom_voi_fr, nom_voi_ar, 
num_voi_fr, num_voi_ar,
suffixe_fr, suffixe_ar, 
nom_imm_fr, nom_imm_ar, 
cd_post_fr, cd_post_ar, 
ville_fr, ville_ar, 
pays_fr, pays_ar, 
cd_tour_fr, cd_tour_ar, 
ctr_rat_fr, ctr_rat_ar, 
nb_pro_fr, nb_pro_ar, 
nb_ind_fr, nb_ind_ar, 
nb_tot_fr, nb_tot_ar, 
source, 
statut,
dat_maj, 
geonyme, 
x, y
)
VALUES(
new.d, 
new.geom, 
new.typ_voi_fr, new.typ_voi_ar, 
new.nom_voi_fr, new.nom_voi_ar, 
new.num_voi_fr, new.num_voi_ar,
new.suffixe_fr, new.suffixe_ar, 
new.nom_imm_fr, new.nom_imm_ar, 
new.cd_post_fr, new.cd_post_ar, 
new.ville_fr, new.ville_ar, 
new.pays_fr, new.pays_ar, 
new.cd_tour_fr, new.cd_tour_ar, 
new.ctr_rat_fr, new.ctr_rat_ar, 
new.nb_pro_fr, new.nb_pro_ar, 
new.nb_ind_fr, new.nb_ind_ar, 
new.nb_tot_fr, new.nb_tot_ar, 
new.source, 
new.statut,
new.dat_maj, 
new.geonyme, 
new.x, new.y)
;
  RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

DROP TRIGGER IF EXISTS trg_update_t_ban_repositionnement ON ban.v_ban_repositionnement;
DROP TRIGGER IF EXISTS trg_update_t_ban_repositionnement ON ban.t_ban_repositionnement_test;
CREATE TRIGGER trg_update_t_ban_repositionnement
INSTEAD OF INSERT OR UPDATE ON
ban.v_ban_repositionnement FOR EACH ROW EXECUTE PROCEDURE update_t_ban_repositionnement();

CREATE INDEX t_ban_travail_gix ON ban.t_ban_travail USING GIST (geom);
ALTER TABLE ban.t_ban_travail ADD COLUMN gid SERIAL PRIMARY KEY;

*/


/*
-------------------------------------------------------------------------------------
ETAPE 5 : CREATION DE LA VUE ban.v_ban
-------------------------------------------------------------------------------------
*/

--- Schema : ban
--- Vue : v_ban_repositionnement_controlduplicate							
--- Traitement : Controle l'existence de doublons dans la table ban.t_ban_repositionnement

CREATE OR REPLACE VIEW ban.v_ban_repositionnement_controlduplicate AS 
SELECT 
	row_number() OVER () AS id,
    a.nbr_doublon,
    a.geom
 FROM ( SELECT 
 			count(t_ban_repositionnement.geom) AS nbr_doublon,
            t_ban_repositionnement.geom
        FROM ban.t_ban_repositionnement
        GROUP BY t_ban_repositionnement.geom
        HAVING count(*) > 1) a;

--- Schema : ban
--- Vue : v_ban							
--- Traitement : Création de la vue finale

CREATE OR REPLACE VIEW ban.v_ban AS 
SELECT row_number() over() AS gid, * 
FROM
(SELECT 
  	a.id,
    a.geom,
    a.typ_voi_fr, a.typ_voi_ar,
    a.nom_voi_fr, a.nom_voi_ar,
    a.num_voi_fr, a.num_voi_ar,
    a.suffixe_fr, a.suffixe_ar,
    a.nom_imm_fr, a.nom_imm_ar,
    a.cd_post_fr, a.cd_post_ar,
    a.ville_fr, a.ville_ar,
    a.pays_fr, a.pays_ar,
    a.cd_tour_fr, a.cd_tour_ar,
    a.ctr_rat_fr, a.ctr_rat_ar,
    a.nb_pro_fr, a.nb_pro_ar,
    a.nb_ind_fr, a.nb_ind_ar,
    a.nb_tot_fr, a.nb_tot_ar ,
    a.source,
    a.statut,
    a.dat_maj,
    a.geonyme, 
    a.xcoord, a.ycoord,
    b.nbr_doublon
   FROM ban.t_ban_repositionnement a
   LEFT JOIN ban.v_ban_repositionnement_controlduplicate b ON a.geom = b.geom)a;

/*
-------------------------------------------------------------------------------------
ETAPE 5 : CONTROLES MAJ t_ban_repositionnement
-------------------------------------------------------------------------------------
*/

--- Schema : ban
--- Table : t_ban_repositionnement							
--- Traitement : Mise à jour du statut en fonction des doublons de geom

CREATE OR REPLACE FUNCTION update_statut_t_ban_repositionnement() RETURNS TRIGGER AS $$
BEGIN
--  IF NEW.url != OLD.url  THEN
UPDATE ban.t_ban_repositionnement as a
SET statut = 'A repositionner'
FROM ban.v_ban_repositionnement_controlduplicate as b 
WHERE a.geom=b.geom;
--  END IF;
--  RETURN NEW;
  RETURN NULL;
END;
$$ LANGUAGE 'plpgsql';

DROP TRIGGER IF EXISTS trg_update_statut_t_ban_repositionnement ON ban.t_ban_repositionnement;
DROP TRIGGER IF EXISTS trg_update_statut_t_ban_repositionnement ON ban.v_ban_repositionnement_controlduplicate;
CREATE TRIGGER trg_update_statut_t_ban_repositionnement
INSTEAD OF INSERT OR UPDATE ON ban.v_ban_repositionnement_controlduplicate
FOR EACH ROW EXECUTE PROCEDURE update_statut_t_ban_repositionnement();


--- Schema : ban
--- Table : t_ban_repositionnement							
--- Traitement : Mise à jour de l'id


CREATE OR REPLACE FUNCTION update_id_t_ban_repositionnement() RETURNS TRIGGER AS $$
BEGIN

    NEW.id :=        
    
     concat(NEW.cd_post_fr,
      '_',
	 NEW.num_voi_fr,
      '_',
     NEW.suffixe_fr,
      '_',
	 NEW.nom_imm_fr,
      '_',
	 NEW.typ_voi_fr,
      '_',
	 NEW.nom_voi_fr,
      '_',
	 NEW.ville_fr);
  RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';



DROP TRIGGER IF EXISTS trg_update_id_t_ban_repositionnement ON ban.t_ban_repositionnement;
CREATE TRIGGER trg_update_id_t_ban_repositionnement
BEFORE INSERT OR UPDATE ON ban.t_ban_repositionnement
FOR EACH ROW 
EXECUTE PROCEDURE update_id_t_ban_repositionnement();

/*
-------------------------------------------------------------------------------------
ETAPE 5 : ADRESSES NON TROUVEES
-------------------------------------------------------------------------------------
*/

--- Schema : ban
--- Vue : v_ban_travail_adresses_non_trouvees              
--- Traitement : Fait le mapping entre les adresses géocodées (t_ban_repositionnement) et 
--- les adresses de la table t_ban_travail

CREATE OR REPLACE VIEW ban.v_ban_travail_adresses_non_trouvees AS 
SELECT row_number() over() AS gid, * from
(SELECT 
 id_voie, 
 geom, 
 typ_voi_fr, typ_voi_ar, 
 nom_voi_fr, nom_voi_ar, 
 num_deb_fr, num_deb_ar, 
 num_fin_fr, num_fin_ar, 
 cd_post_fr, cd_post_ar, 
 ville_fr, ville_ar, 
 pays_fr, pays_ar, 
 cd_tour_fr, cd_tour_ar, 
 ctr_rat_fr, ctr_rat_ar, 
 source, 
 dat_maj, 
 xcoord, ycoord 
 FROM
(WITH adresse_t_ban_repositionnement AS
(
SELECT 
 concat (typ_voi_fr, '_', nom_voi_fr, '_' , ville_fr) as adresse, 
 id_voie, 
 geom, 
 typ_voi_fr, typ_voi_ar, 
 nom_voi_fr, nom_voi_ar, 
 num_deb_fr, num_deb_ar, 
 num_fin_fr, num_fin_ar, 
 cd_post_fr, cd_post_ar, 
 ville_fr, ville_ar, 
 pays_fr, pays_ar, 
 cd_tour_fr, cd_tour_ar, 
 ctr_rat_fr, ctr_rat_ar, 
 source, 
 dat_maj, 
 xcoord, ycoord
FROM ban.t_ban_travail AS t_ban_repositionnement)
SELECT * FROM adresse_t_ban_repositionnement)a

WHERE adresse NOT IN  

(SELECT adresse FROM
(WITH adresse_t_ban_repositionnement AS
(
SELECT concat (typ_voi_fr, '_', nom_imm_fr, '_' , ville_fr) as adresse_imm
FROM ban.t_ban_repositionnement AS t_ban_repositionnement)
SELECT * FROM adresse_t_ban_repositionnement
order by adresse_imm)b
WHERE adresse=adresse_imm 
GROUP BY adresse_imm
)
 AND adresse NOT IN  
(SELECT adresse FROM
(WITH adresse_t_ban_repositionnement AS
(
SELECT concat (typ_voi_fr, '_', nom_voi_fr, '_' , ville_fr) as adresse
FROM ban.t_ban_repositionnement AS t_ban_repositionnement)
SELECT * FROM adresse_t_ban_repositionnement)b
WHERE adresse=adresse 
GROUP BY adresse
)
)a
WHERE  geom <> '';

/*
-------------------------------------------------------------------------------------
ETAPE 6 : SUIVI STATISTIQUE
-------------------------------------------------------------------------------------
*/
--- Schema : ban
--- Vue : v_ban_suivi_statistiques              
--- Traitement : Calcul le nombre d'adresses restant à géocoder

CREATE OR REPLACE VIEW ban.v_ban_suivi_statistiques AS 
WITH adr_tournees AS (
        select count ( concat(typ_voi_fr, ' ',nom_voi_fr,'_',ville_fr)) as adresses_tournees
    from ban.t_ban_travail
     ), adr_tournees_non_trouvees AS (
        select count ( concat(typ_voi_fr, ' ',nom_voi_fr,'_',ville_fr)) as adresses_tournees_non_trouvees
    from ban.v_ban_travail_adresses_non_trouvees
     )
SELECT adresses_tournees,
       adresses_tournees_non_trouvees,
     adresses_tournees_non_trouvees*100/adresses_tournees as per_adresses_non_trouvees,
     adresses_tournees-adresses_tournees_non_trouvees as adresses_tournees_trouvees
FROM adr_tournees, adr_tournees_non_trouvees
;