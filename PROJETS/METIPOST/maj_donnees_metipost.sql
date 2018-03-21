/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 16/03/2018
Objet : MAJ données METIPOST
Modification : Nom : // - Date : // - Motif/nature : //
-------------------------------------------------------------------------------------
*/

/*
-------------------------------------------------------------------------------------
ETAPE 1 : DONNEES STATISTIQUES PAR SECTEUR
-------------------------------------------------------------------------------------
*/

--- Schema : batiments
--- Table : osm_2018
--- Traitement : MAJ nom_gou_fr

	ALTER TABLE batiments.osm_2018 ADD COLUMN nom_gou_fr varchar(254);
	
	UPDATE batiments.osm_2018 as a
	set nom_gou_fr = b.nom_gou_fr
	FROM administratif.gouvernorats_grand_tunis as b 
	where st_contains (b.geom, a.geom)
	;

--- Schema : batiments
--- Table : osm_2018
--- Traitement : MAJ nom_com_fr


	ALTER TABLE batiments.osm_2018 ADD COLUMN nom_com_fr varchar(254);
	
	UPDATE batiments.osm_2018 as a
	set nom_com_fr = b.nom_com_fr
	FROM administratif.communes_grand_tunis as b 
	where st_contains (b.geom, a.geom)
	;

--- Schema : batiments
--- Table : osm_2018
--- Traitement : MAJ nom_del_fr

	ALTER TABLE batiments.osm_2018 ADD COLUMN nom_del_fr varchar(254);
	
	UPDATE batiments.osm_2018 as a
	set nom_del_fr = b.nom_del_fr
	FROM administratif.delegations_grand_tunis as b 
	where st_contains (b.geom, a.geom)
	;

--- Schema : batiments
--- Table : osm_2018
--- Traitement : MAJ nom_sec_fr

	ALTER TABLE batiments.osm_2018 ADD COLUMN nom_sec_fr varchar(254);
	
	UPDATE batiments.osm_2018 as a
	set nom_sec_fr = b.nom_sec_fr
	FROM administratif.secteurs_grand_tunis as b 
	where st_contains (b.geom, a.geom)
	;
	
--- Schema : administratif
--- Table : secteurs_grand_tunis
--- Traitement : Enlever tous les caracteres accentues

	ALTER TABLE administratif.secteurs_grand_tunis ADD COLUMN sect_upper varchar(254);
	
	UPDATE administratif.secteurs_grand_tunis  as a
	set sect_upper = upper(replace(name2uri(secteurs), '-', ' '));

--- Schema : statistiques
--- Table : secteurs_ins_2014
--- Traitement : Enlever tous les caracteres accentues

	ALTER TABLE statistiques.secteurs_ins_2014 ADD COLUMN sect_upper varchar(254);
	
	UPDATE administratif.secteurs_grand_tunis  as a
	set sect_upper = upper(replace(name2uri(nom_sec_fr), '-', ' '));

--- Schema : statistiques
--- Table : gouvernorats_ins_2014
--- Traitement : Enlever tous les caracteres accentues
	
	ALTER TABLE statistiques.gouvernorats_ins_2014 ADD COLUMN gou_upper varchar(254);
	
	UPDATE statistiques.gouvernorats_ins_2014  as a
	set gou_upper = upper(replace(name2uri(gouv), 'gouvernorat-de-', ''));

--- Schema : statistiques
--- Table : delegations_ins_2014
--- Traitement : Enlever tous les caracteres accentues

	ALTER TABLE statistiques.delegations_ins_2014 ADD COLUMN del_upper varchar(254);
	
	UPDATE statistiques.delegations_ins_2014  as a
	set del_upper = upper(replace(name2uri(del), 'delegation-de-', ''));
	UPDATE statistiques.delegations_ins_2014  as a
	set del_upper = replace(del_upper, '-', ' ');

--- Schema : administratif
--- Table : delegations_grand_tunis
--- Traitement : Enlever tous les caracteres accentues

	ALTER TABLE administratif.delegations_grand_tunis ADD COLUMN del_upper varchar(254);
	
	UPDATE administratif.delegations_grand_tunis  as a
	set del_upper = upper(name2uri(nom_del_fr));
	UPDATE administratif.delegations_grand_tunis  as a
	set del_upper = replace(del_upper, '-', ' ');
	
--- Schema : administratif
--- Vue : secteurs_grand_tunis
--- Traitement : MAJ nom_del_fr

	UPDATE administratif.secteurs_grand_tunis as a
	set nom_del_fr = b.del_upper
	FROM administratif.delegations_grand_tunis as b 
	where st_contains (b.geom, st_centroid(a.geom))
	;

--- Schema : administratif
--- Vue : secteurs_grand_tunis
--- Traitement : MAJ nom_gou_fr

	UPDATE administratif.secteurs_grand_tunis as a
	set nom_gou_fr = b.nom_gou_fr
	FROM administratif.gouvernorats_grand_tunis as b 
	where st_contains (b.geom, st_centroid(a.geom))
	;

--- Schema : administratif
--- Vue : delegations_grand_tunis
--- Traitement : MAJ nom_gou_fr

	ALTER TABLE administratif.delegations_grand_tunis ADD COLUMN nom_gou_fr varchar(254);
	
	UPDATE administratif.delegations_grand_tunis as a
	set nom_gou_fr = b.nom_gou_fr
	FROM administratif.gouvernorats_grand_tunis as b 
	where st_contains (b.geom, st_centroid(a.geom))
	;
	
--- Schema : statistiques
--- Vue : secteurs_ins_2014
--- Traitement : MAJ CAST des champs statistiques en numerique

UPDATE statistiques.secteurs_ins_2014  as a
set pop_ur_tot = replace(pop_ur_tot, ',00', '');
UPDATE statistiques.secteurs_ins_2014  as a
set pop_ur_tot = replace(pop_ur_tot, ' ', '');
ALTER TABLE statistiques.secteurs_ins_2014 ALTER COLUMN pop_ur_tot TYPE integer USING (pop_ur_tot::integer);
UPDATE statistiques.secteurs_ins_2014  as a
set pop_ur_h = replace(pop_ur_h, ',00', '');
UPDATE statistiques.secteurs_ins_2014  as a
set pop_ur_h = replace(pop_ur_h, ' ', '');
ALTER TABLE statistiques.secteurs_ins_2014 ALTER COLUMN pop_ur_h TYPE integer USING (pop_ur_h::integer);
UPDATE statistiques.secteurs_ins_2014  as a
set pop_ur_f = replace(pop_ur_f, ',00', '');
UPDATE statistiques.secteurs_ins_2014  as a
set pop_ur_f = replace(pop_ur_f, ' ', '');
ALTER TABLE statistiques.secteurs_ins_2014 ALTER COLUMN pop_ur_f TYPE integer USING (pop_ur_f::integer);
UPDATE statistiques.secteurs_ins_2014  as a
set nb_ur_mena = replace(nb_ur_mena, ',00', '');
UPDATE statistiques.secteurs_ins_2014  as a
set nb_ur_mena = replace(nb_ur_mena, ' ', '');
ALTER TABLE statistiques.secteurs_ins_2014 ALTER COLUMN nb_ur_mena TYPE integer USING (nb_ur_mena::integer);
UPDATE statistiques.secteurs_ins_2014  as a
set nb_ur_log = replace(nb_ur_log, ',00', '');
UPDATE statistiques.secteurs_ins_2014  as a
set nb_ur_log = replace(nb_ur_log, ' ', '');
ALTER TABLE statistiques.secteurs_ins_2014 ALTER COLUMN nb_ur_log TYPE integer USING (nb_ur_log::integer);
UPDATE statistiques.secteurs_ins_2014  as a
set pop_ru_tot = replace(pop_ru_tot, ',00', '');
UPDATE statistiques.secteurs_ins_2014  as a
set pop_ru_tot = replace(pop_ru_tot, ' ', '');
ALTER TABLE statistiques.secteurs_ins_2014 ALTER COLUMN pop_ru_tot TYPE integer USING (pop_ru_tot::integer);
UPDATE statistiques.secteurs_ins_2014  as a
set pop_ru_h = replace(pop_ru_h, ',00', '');
UPDATE statistiques.secteurs_ins_2014  as a
set pop_ru_h = replace(pop_ru_h, ' ', '');
ALTER TABLE statistiques.secteurs_ins_2014 ALTER COLUMN pop_ru_h TYPE integer USING (pop_ru_h::integer);
UPDATE statistiques.secteurs_ins_2014  as a
set pop_ru_f = replace(pop_ru_f, ',00', '');
UPDATE statistiques.secteurs_ins_2014  as a
set pop_ru_f = replace(pop_ru_f, ' ', '');
ALTER TABLE statistiques.secteurs_ins_2014 ALTER COLUMN pop_ru_f TYPE integer USING (pop_ru_f::integer);
UPDATE statistiques.secteurs_ins_2014  as a
set nb_ru_mena = replace(nb_ru_mena, ',00', '');
UPDATE statistiques.secteurs_ins_2014  as a
set nb_ru_mena = replace(nb_ru_mena, ' ', '');
ALTER TABLE statistiques.secteurs_ins_2014 ALTER COLUMN nb_ru_mena TYPE integer USING (nb_ru_mena::integer);
UPDATE statistiques.secteurs_ins_2014  as a
set nb_ru_log = replace(nb_ru_log, ',00', '');
UPDATE statistiques.secteurs_ins_2014  as a
set nb_ru_log = replace(nb_ru_log, ' ', '');
ALTER TABLE statistiques.secteurs_ins_2014 ALTER COLUMN nb_ru_log TYPE integer USING (nb_ru_log::integer);
UPDATE statistiques.secteurs_ins_2014  as a
set nb_tot_pop = replace(nb_tot_pop, ',00', '');
UPDATE statistiques.secteurs_ins_2014  as a
set nb_tot_pop = replace(nb_tot_pop, ' ', '');
ALTER TABLE statistiques.secteurs_ins_2014 ALTER COLUMN nb_tot_pop TYPE integer USING (nb_tot_pop::integer);
UPDATE statistiques.secteurs_ins_2014  as a
set nb_tot_h = replace(nb_tot_h, ',00', '');
UPDATE statistiques.secteurs_ins_2014  as a
set nb_tot_h = replace(nb_tot_h, ' ', '');
ALTER TABLE statistiques.secteurs_ins_2014 ALTER COLUMN nb_tot_h TYPE integer USING (nb_tot_h::integer);
UPDATE statistiques.secteurs_ins_2014  as a
set nb_tot_f = replace(nb_tot_f, ',00', '');
UPDATE statistiques.secteurs_ins_2014  as a
set nb_tot_f = replace(nb_tot_f, ' ', '');
ALTER TABLE statistiques.secteurs_ins_2014 ALTER COLUMN nb_tot_f TYPE integer USING (nb_tot_f::integer);
UPDATE statistiques.secteurs_ins_2014  as a
set nb_tot_men = replace(nb_tot_men, ',00', '');
UPDATE statistiques.secteurs_ins_2014  as a
set nb_tot_men = replace(nb_tot_men, ' ', '');
ALTER TABLE statistiques.secteurs_ins_2014 ALTER COLUMN nb_tot_men TYPE integer USING (nb_tot_men::integer);
UPDATE statistiques.secteurs_ins_2014  as a
set nb_tot_log = replace(nb_tot_log, ',00', '');
UPDATE statistiques.secteurs_ins_2014  as a
set nb_tot_log = replace(nb_tot_log, ' ', '');
ALTER TABLE statistiques.secteurs_ins_2014 ALTER COLUMN nb_tot_log TYPE integer USING (nb_tot_log::integer);

--- Schema : statistiques
--- Vue : delegations_ins_2014
--- Traitement : MAJ CAST des champs statistiques en numerique

UPDATE statistiques.delegations_ins_2014  as a
set pop_ur_tot = replace(pop_ur_tot, ',00', '');
UPDATE statistiques.delegations_ins_2014  as a
set pop_ur_tot = replace(pop_ur_tot, ' ', '');
ALTER TABLE statistiques.delegations_ins_2014 ALTER COLUMN pop_ur_tot TYPE integer USING (pop_ur_tot::integer);
UPDATE statistiques.delegations_ins_2014  as a
set pop_ur_h = replace(pop_ur_h, ',00', '');
UPDATE statistiques.delegations_ins_2014  as a
set pop_ur_h = replace(pop_ur_h, ' ', '');
ALTER TABLE statistiques.delegations_ins_2014 ALTER COLUMN pop_ur_h TYPE integer USING (pop_ur_h::integer);
UPDATE statistiques.delegations_ins_2014  as a
set pop_ur_f = replace(pop_ur_f, ',00', '');
UPDATE statistiques.delegations_ins_2014  as a
set pop_ur_f = replace(pop_ur_f, ' ', '');
ALTER TABLE statistiques.delegations_ins_2014 ALTER COLUMN pop_ur_f TYPE integer USING (pop_ur_f::integer);
UPDATE statistiques.delegations_ins_2014  as a
set nb_ur_mena = replace(nb_ur_mena, ',00', '');
UPDATE statistiques.delegations_ins_2014  as a
set nb_ur_mena = replace(nb_ur_mena, ' ', '');
ALTER TABLE statistiques.delegations_ins_2014 ALTER COLUMN nb_ur_mena TYPE integer USING (nb_ur_mena::integer);
UPDATE statistiques.delegations_ins_2014  as a
set nb_ur_log = replace(nb_ur_log, ',00', '');
UPDATE statistiques.delegations_ins_2014  as a
set nb_ur_log = replace(nb_ur_log, ' ', '');
ALTER TABLE statistiques.delegations_ins_2014 ALTER COLUMN nb_ur_log TYPE integer USING (nb_ur_log::integer);
UPDATE statistiques.delegations_ins_2014  as a
set pop_ru_tot = replace(pop_ru_tot, ',00', '');
UPDATE statistiques.delegations_ins_2014  as a
set pop_ru_tot = replace(pop_ru_tot, ' ', '');
ALTER TABLE statistiques.delegations_ins_2014 ALTER COLUMN pop_ru_tot TYPE integer USING (pop_ru_tot::integer);
UPDATE statistiques.delegations_ins_2014  as a
set pop_ru_h = replace(pop_ru_h, ',00', '');
UPDATE statistiques.delegations_ins_2014  as a
set pop_ru_h = replace(pop_ru_h, ' ', '');
ALTER TABLE statistiques.delegations_ins_2014 ALTER COLUMN pop_ru_h TYPE integer USING (pop_ru_h::integer);
UPDATE statistiques.delegations_ins_2014  as a
set pop_ru_f = replace(pop_ru_f, ',00', '');
UPDATE statistiques.delegations_ins_2014  as a
set pop_ru_f = replace(pop_ru_f, ' ', '');
ALTER TABLE statistiques.delegations_ins_2014 ALTER COLUMN pop_ru_f TYPE integer USING (pop_ru_f::integer);
UPDATE statistiques.delegations_ins_2014  as a
set nb_ru_mena = replace(nb_ru_mena, ',00', '');
UPDATE statistiques.delegations_ins_2014  as a
set nb_ru_mena = replace(nb_ru_mena, ' ', '');
ALTER TABLE statistiques.delegations_ins_2014 ALTER COLUMN nb_ru_mena TYPE integer USING (nb_ru_mena::integer);
UPDATE statistiques.delegations_ins_2014  as a
set nb_ru_log = replace(nb_ru_log, ',00', '');
UPDATE statistiques.delegations_ins_2014  as a
set nb_ru_log = replace(nb_ru_log, ' ', '');
ALTER TABLE statistiques.delegations_ins_2014 ALTER COLUMN nb_ru_log TYPE integer USING (nb_ru_log::integer);
UPDATE statistiques.delegations_ins_2014  as a
set nb_tot_pop = replace(nb_tot_pop, ',00', '');
UPDATE statistiques.delegations_ins_2014  as a
set nb_tot_pop = replace(nb_tot_pop, ' ', '');
ALTER TABLE statistiques.delegations_ins_2014 ALTER COLUMN nb_tot_pop TYPE integer USING (nb_tot_pop::integer);
UPDATE statistiques.delegations_ins_2014  as a
set nb_tot_h = replace(nb_tot_h, ',00', '');
UPDATE statistiques.delegations_ins_2014  as a
set nb_tot_h = replace(nb_tot_h, ' ', '');
ALTER TABLE statistiques.delegations_ins_2014 ALTER COLUMN nb_tot_h TYPE integer USING (nb_tot_h::integer);
UPDATE statistiques.delegations_ins_2014  as a
set nb_tot_f = replace(nb_tot_f, ',00', '');
UPDATE statistiques.delegations_ins_2014  as a
set nb_tot_f = replace(nb_tot_f, ' ', '');
ALTER TABLE statistiques.delegations_ins_2014 ALTER COLUMN nb_tot_f TYPE integer USING (nb_tot_f::integer);
UPDATE statistiques.delegations_ins_2014  as a
set nb_tot_men = replace(nb_tot_men, ',00', '');
UPDATE statistiques.delegations_ins_2014  as a
set nb_tot_men = replace(nb_tot_men, ' ', '');
ALTER TABLE statistiques.delegations_ins_2014 ALTER COLUMN nb_tot_men TYPE integer USING (nb_tot_men::integer);
UPDATE statistiques.delegations_ins_2014  as a
set nb_tot_log = replace(nb_tot_log, ',00', '');
UPDATE statistiques.delegations_ins_2014  as a
set nb_tot_log = replace(nb_tot_log, ' ', '');
ALTER TABLE statistiques.delegations_ins_2014 ALTER COLUMN nb_tot_log TYPE integer USING (nb_tot_log::integer);


--- Schema : statistiques
--- Vue : gouvernorats_ins_2014
--- Traitement : MAJ CAST des champs statistiques en numerique

ALTER TABLE statistiques.gouvernorats_ins_2014 ALTER COLUMN pop_ur_tot TYPE integer USING (pop_ur_tot::integer);
ALTER TABLE statistiques.gouvernorats_ins_2014 ALTER COLUMN pop_ur_h TYPE integer USING (pop_ur_h::integer);
ALTER TABLE statistiques.gouvernorats_ins_2014 ALTER COLUMN pop_ur_f TYPE integer USING (pop_ur_f::integer);
ALTER TABLE statistiques.gouvernorats_ins_2014 ALTER COLUMN nb_ur_mena TYPE integer USING (nb_ur_mena::integer);
ALTER TABLE statistiques.gouvernorats_ins_2014 ALTER COLUMN nb_ur_log TYPE integer USING (nb_ur_log::integer);
ALTER TABLE statistiques.gouvernorats_ins_2014 ALTER COLUMN pop_ru_tot TYPE integer USING (pop_ru_tot::integer);
ALTER TABLE statistiques.gouvernorats_ins_2014 ALTER COLUMN pop_ru_h TYPE integer USING (pop_ru_h::integer);
ALTER TABLE statistiques.gouvernorats_ins_2014 ALTER COLUMN pop_ru_f TYPE integer USING (pop_ru_f::integer);
ALTER TABLE statistiques.gouvernorats_ins_2014 ALTER COLUMN nb_ru_mena TYPE integer USING (nb_ru_mena::integer);
ALTER TABLE statistiques.gouvernorats_ins_2014 ALTER COLUMN nb_ru_log TYPE integer USING (nb_ru_log::integer);
ALTER TABLE statistiques.gouvernorats_ins_2014 ALTER COLUMN nb_tot_pop TYPE integer USING (nb_tot_pop::integer);
ALTER TABLE statistiques.gouvernorats_ins_2014 ALTER COLUMN nb_tot_h TYPE integer USING (nb_tot_h::integer);
ALTER TABLE statistiques.gouvernorats_ins_2014 ALTER COLUMN nb_tot_f TYPE integer USING (nb_tot_f::integer);
ALTER TABLE statistiques.gouvernorats_ins_2014 ALTER COLUMN nb_tot_men TYPE integer USING (nb_tot_men::integer);
ALTER TABLE statistiques.gouvernorats_ins_2014 ALTER COLUMN nb_tot_log TYPE integer USING (nb_tot_log::integer);

--- Schema : statistiques
--- Vue : pop_log_menages_secteurs_2014
--- Traitement : Vue des secteurs avec données stats de l'INS 2014

	CREATE OR REPLACE VIEW statistiques.pop_log_menages_secteurs_2014 AS 
	SELECT 
	distinct on (a.id) a.id,
	secteurs, a.sect_upper as nom_sec_fr, 
	a.nom_del_fr, nom_gou_fr,
	a.pop_ur_tot, a.pop_ur_h, a.pop_ur_f, a.nb_ur_mena, a.nb_ur_log, 
	a.pop_ru_tot, a.pop_ru_h, a.pop_ru_f, a.nb_ru_mena, a.nb_ru_log, a.nb_tot_pop, 
	a.nb_tot_h, a.nb_tot_f, a.nb_tot_men, a.nb_tot_log, b.geom
	from statistiques.secteurs_ins_2014 a
	left join administratif.secteurs_grand_tunis b on a.sect_upper=b.sect_upper and a.nom_del_fr=b.nom_del_fr
	;
		
--- Schema : statistiques
--- Vue : pop_log_menages_delegations_2014
--- Traitement : Vue des delegations avec données stats de l'INS 2014

	CREATE OR REPLACE VIEW statistiques.pop_log_menages_delegations_2014 AS 	
	SELECT 
	distinct on (a.id) a.id,
	del, a.del_upper as nom_del_fr, b.nom_gou_fr,
	a.pop_ur_tot, a.pop_ur_h, a.pop_ur_f, a.nb_ur_mena, a.nb_ur_log, 
	a.pop_ru_tot, a.pop_ru_h, a.pop_ru_f, a.nb_ru_mena, a.nb_ru_log, a.nb_tot_pop, 
	a.nb_tot_h, a.nb_tot_f, a.nb_tot_men, a.nb_tot_log, b.geom
	from statistiques.delegations_ins_2014 a
	left join administratif.delegations_grand_tunis b
	on a.del_upper=b.del_upper
	;

--- Schema : statistiques
--- Vue : pop_log_menages_gouvernorats_2014
--- Traitement : Vue des gouvernorats avec données stats de l'INS 2014

	CREATE OR REPLACE VIEW statistiques.pop_log_menages_gouvernorats_2014 AS 	
	SELECT 
	distinct on (a.id) a.id,
	gouv, gou_upper as nom_gou_fr,
	a.pop_ur_tot, a.pop_ur_h, a.pop_ur_f, a.nb_ur_mena, a.nb_ur_log, 
	a.pop_ru_tot, a.pop_ru_h, a.pop_ru_f, a.nb_ru_mena, a.nb_ru_log, a.nb_tot_pop, 
	a.nb_tot_h, a.nb_tot_f, a.nb_tot_men, a.nb_tot_log, b.geom
	from statistiques.gouvernorats_ins_2014 a
	left join administratif.gouvernorats_grand_tunis b
	on a.gou_upper=b.nom_gou_fr

	;

/*
-------------------------------------------------------------------------------------
ETAPE 2 : CALCUL DU NOMBRE D'HABITANTS PAR BATIMENT DE TYPE 'PARTICULIER'
-------------------------------------------------------------------------------------
*/

--- Schema : batiments
--- Vue : osm_2018
--- Traitement : Creation champ surface

	ALTER TABLE batiments.osm_2018 ADD COLUMN surface integer;
	
	UPDATE batiments.osm_2018 as a
	set surface = st_area(geom)
	where nom_del_fr = 'CITE ETTADHAMEN'
	;

--- Schema : batiments
--- Vue : osm_2018_surf_hab
--- Traitement : Calcul du nombre de m2 par habitant : somme de la surface par secteur/pop total par secteur

	drop table if exists batiments.osm_2018_surf_hab;
	create table batiments.osm_2018_surf_hab as 
	select (sum((surface)*0.99999)/nb_tot_pop)::int as nb_hab_m, nb_tot_pop, sum(surface) as surface, nom_sec_fr, a.nom_del_fr
	from batiments.osm_2018 as a
	left join statistiques.secteurs_ins_2014 as b on a.nom_sec_fr=b.sect_upper and a.nom_del_fr=b.nom_del_fr
    where a.nom_del_fr like 'CITE ETTADHAMEN' and usage like 'Particulier'
	group by nb_tot_pop, nom_sec_fr, a.nom_del_fr;

--- Schema : batiments
--- Vue : osm_2018
--- Traitement : Calcul du nombre d'habitant par logement

	ALTER TABLE batiments.osm_2018 ADD COLUMN surf_hab integer;
	
	UPDATE batiments.osm_2018 as a
	set surf_hab = a.surface/nb_hab_m
	from batiments.osm_2018_surf_hab as b 
	where a.nom_sec_fr=b.nom_sec_fr and a.nom_del_fr=b.nom_del_fr
	;
	
/*
-------------------------------------------------------------------------------------
ETAPE 3 : ANALYSES THEMATIQUES : CALCUL D'ISOCHRONES
-------------------------------------------------------------------------------------
*/

--- Schema : routes
--- Vue : osm_2018
--- Traitement : MAJ nom_gou_fr

ALTER TABLE routes.osm_2018 ADD COLUMN nom_gou_fr varchar(254);
	
	UPDATE routes.osm_2018 as a
	set nom_gou_fr = b.nom_gou_fr
	FROM administratif.gouvernorats_grand_tunis as b 
	where st_intersects (b.geom, a.geom)
	;

--- Schema : routes
--- Vue : osm_2018
--- Traitement : MAJ nom_com_fr

ALTER TABLE routes.osm_2018 ADD COLUMN nom_com_fr varchar(254);
	
	UPDATE routes.osm_2018 as a
	set nom_com_fr = b.nom_com_fr
	FROM administratif.communes_grand_tunis as b 
	where st_contst_intersectsains (b.geom, a.geom)
	;

--- Schema : routes
--- Vue : osm_2018
--- Traitement : MAJ nom_del_fr

ALTER TABLE routes.osm_2018 ADD COLUMN nom_del_fr varchar(254);
	
	UPDATE routes.osm_2018 as a
	set nom_del_fr = b.nom_del_fr
	FROM administratif.delegations_grand_tunis as b 
	where st_intersects (b.geom, a.geom)
	;

--- Schema : routes
--- Vue : osm_2018
--- Traitement : MAJ nom_sec_fr

ALTER TABLE routes.osm_2018 ADD COLUMN nom_sec_fr varchar(254);
	
	UPDATE routes.osm_2018 as a
	set nom_sec_fr = b.nom_sec_fr
	FROM administratif.secteurs_grand_tunis as b 
	where st_intersects (b.geom, a.geom)
	;

--- Schema : routes
--- Vue : osm_2018
--- Traitement : MAJ nom_sec_fr

ALTER TABLE analyses.heatmap_batiments_nb_pop_tot
ADD range_id_rupture integer ;

update analyses.heatmap_batiments_nb_pop_tot  set range_id_rupture = 1 where dn <= 31;
update analyses.heatmap_batiments_nb_pop_tot  set range_id_rupture = 2 where dn between 32 and 69;
update analyses.heatmap_batiments_nb_pop_tot  set range_id_rupture = 3 where dn between 70 and 105;
update analyses.heatmap_batiments_nb_pop_tot  set range_id_rupture = 4 where dn between 106 and 135;
update analyses.heatmap_batiments_nb_pop_tot  set range_id_rupture = 5 where dn between 136 and 163;
update analyses.heatmap_batiments_nb_pop_tot  set range_id_rupture = 6 where dn between 164 and 191;
update analyses.heatmap_batiments_nb_pop_tot  set range_id_rupture = 7 where dn between 192 and 219;
update analyses.heatmap_batiments_nb_pop_tot  set range_id_rupture = 8 where dn >=220;

drop table if exists analyses.heatmap_batiments_nb_pop_tot_merge;
create table analyses.heatmap_batiments_nb_pop_tot_merge as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, range_id_rupture
FROM 
   analyses.heatmap_batiments_nb_pop_tot
    group by range_id_rupture
;

update analyses.heatmap_batiments_nb_pop_tot_merge  set geom = ST_Buffer (ST_Buffer (geom, 15), -10) ;

drop table if exists analyses.heatmap_batiments_nb_pop_tot;
ALTER TABLE analyses.heatmap_batiments_nb_pop_tot_merge RENAME TO heatmap_batiments_nb_pop_tot;

CREATE EXTENSION pgrouting;

DROP SCHEMA IF EXISTS topology CASCADE;
DROP SCHEMA IF EXISTS routing CASCADE;
CREATE EXTENSION postgis_topology;

-- Action 3: Création du schéma topologique en 32632
SELECT topology.CreateTopology('routing', 32632);

UPDATE routes.osm_2018
SET geom=ST_MakeValid(geom);

-- Action 6: Ajouter une colonne topologique 'topo'
SELECT topology.AddTopoGeometryColumn('routing', 'routes', 'osm_2018', 'topo', 'LINESTRING');

-- Action 7: Convertir les lignes brisées en noeuds et arrêtes au sein de la topologie  
UPDATE routes.osm_2018 SET topo = topology.toTopoGeom(geom, 'routing', 1, 0)
where nom_del_fr like 'CITE ETTADHAMEN';

-- Enrichir notre table en rajoutant les noms et  les type de voiries.

ALTER TABLE routing.edge_data  add COLUMN  fclass   character varying;
ALTER TABLE routing.edge_data  add COLUMN  name  character varying;

-- Créer une table intermédiaire « route_edge_data » pour stocker les noms et types.

drop table if exists routing.route_edge_data;
create table routing.route_edge_data as
SELECT 
	e.edge_id,
	r.fclass, 
	r.oneway,
	r.name 
FROM routing.edge_data e, routing.relation rel, routes.osm_2018 r
WHERE e.edge_id = rel.element_id  AND rel.topogeo_id = (r.topo).id;

-- Mettre à jour attributs depuis la table « route_edge_data »

UPDATE routing.edge_data  a 
SET (fclass, name) = (r.fclass, r.name) 
FROM routing.route_edge_data  r 
WHERE a.edge_id=r.edge_id;

--Pour enrichir notre table en rajoutant le sens de la circulation voici la requête.
drop table if exists routing.route_edge_data;
create table routing.route_edge_data as
SELECT 
	e.edge_id,
	r.oneway 
FROM routing.edge_data e, routing.relation rel, routes.osm_2018 r
WHERE e.edge_id = rel.element_id  AND rel.topogeo_id = (r.topo).id ;

--Ajouter les colonnes à remplir
ALTER TABLE routing.edge_data  add COLUMN  oneway character varying;
--Maj attributs depuis la table route
UPDATE routing.edge_data  a 
SET oneway = r.oneway
FROM routing.route_edge_data  r 
WHERE a.edge_id=r.edge_id;


-- Action 8: Ajout de la colonne  colonne tps_distance pour l'agorithme de plus court chemin
ALTER TABLE routing.edge_data  add COLUMN tps_distance   double precision;
UPDATE routing.edge_data a  SET tps_distance=st_length(st_transform(geom,32632))/1000;

--Donc on ajoute l’attribut tps_pieton dans notre table « edge_data »  
 ALTER TABLE routing.edge_data  ADD COLUMN tps_pieton   double precision; 

--MAJ tps_pieton   
UPDATE routing.edge_data  SET tps_pieton =tps_distance/4;
--Calcul en minutes
update routing.edge_data set tps_pieton  =tps_pieton*60;
--Cependant on sait aussi qu’un piéton ne doit pas 
--emprunter les autoroutes et voix expresses donc nous allons les restreindre. 
--Mais il faut également avoir en tête  qu’il peut circuler dans les deux sens.


--MAJ restreinte tps_pieton   
UPDATE routing.edge_data  SET tps_pieton =-1 WHERE fclass IN ('trunk','trunk_link','motorway','motorway_link','primary_link','primary');

--Le plus court chemin à vélo 
--On ajoute l’attribut tps_velo dans notre table « edge_data »
ALTER TABLE routing.edge_data  ADD COLUMN tps_velo double precision;

--MAJ tps_velo
UPDATE routing.edge_data SET tps_velo =tps_distance /15 ;
UPDATE routing.edge_data SET tps_velo=tps_distance /12 WHERE fclass IN ('footway','pedestrian' ) ;
UPDATE routing.edge_data SET tps_velo =tps_distance /2 WHERE fclass ='steps' ;
--Calcul en minutes
update routing.edge_data set tps_velo  =tps_velo*60;
-- Restriction
UPDATE routing.edge_data SET tps_velo  =-1 WHERE tps_velo  IS NULL ;

--Le plus court chemin en voiture 
--Couts tps_voiture
ALTER TABLE routing.edge_data  ADD COLUMN tps_voiture double precision;
--MAJ tps_voiture
update routing.edge_data set tps_voiture  =tps_distance /90 where fclass =  'trunk' ;
update routing.edge_data set tps_voiture  =tps_distance /45 where fclass = 'trunk_link';  
update routing.edge_data set tps_voiture  =tps_distance /85 where fclass ='motorway';
update routing.edge_data set tps_voiture  =tps_distance /40 where fclass = 'motorway_link'  ;
update routing.edge_data set tps_voiture  =tps_distance /65 where fclass ='primary'  ;
update routing.edge_data set tps_voiture  =tps_distance /30 where fclass = 'primary_link' ;
update routing.edge_data set tps_voiture  =tps_distance /55 where fclass = 'secondary'  ;
update routing.edge_data set tps_voiture  =tps_distance /25 where fclass = 'secondary_link' ;
update routing.edge_data set tps_voiture  =tps_distance /40 where fclass = 'tertiary' ;
update routing.edge_data set tps_voiture  =tps_distance /20 where fclass = 'tertiary_link' ;
update routing.edge_data set tps_voiture  =tps_distance /30 where fclass = 'service' ;
update routing.edge_data set tps_voiture  =tps_distance /25 where fclass = 'residential' ;
update routing.edge_data set tps_voiture  =tps_distance /25 where fclass = 'road'  ;
update routing.edge_data set tps_voiture  =tps_distance /25 where fclass = 'track' ;
update routing.edge_data set tps_voiture  =tps_distance /25 where fclass = 'unclassified';
update routing.edge_data set tps_voiture  =tps_distance /10 where fclass = 'living_street';
--Calcul en minutes
update routing.edge_data set tps_voiture  =tps_voiture*60;

--Coûts inverses
update routing.edge_data set tps_voiture  =-1 WHERE tps_voiture IS NULL ;


/*--- Schema : administratif
--- Vue : cluster_suf
--- Traitement : Cluster autour des batiments qui se touchent à moins d'un mètre de rayon

drop table if exists administratif.cluster_suf;
create table administratif.cluster_suf as 
SELECT row_number() over () AS id,
  ST_NumGeometries(gc),
  gc AS geom_collection,
  ST_Centroid(gc) AS centroid,
  ST_MinimumBoundingCircle(gc) AS circle,
  sqrt(ST_Area(ST_MinimumBoundingCircle(gc)) / pi()) AS radius
FROM (
  SELECT unnest(ST_ClusterWithin(geom, 1)) gc
  FROM batiments.osm_2018
	 where nom_del_fr like 'CITE ETTADHAMEN'
) f;

--- Schema : administratif
--- Vue : cluster_suf
--- Traitement : Calcul du nombre d'habitant dans chaque cluster

ALTER TABLE administratif.cluster_suf ADD COLUMN nom_sec_fr varchar(254);

	UPDATE administratif.cluster_suf as a
	set nom_sec_fr = b.nom_sec_fr
	FROM administratif.secteurs_grand_tunis as b 
	where st_intersects (b.geom, st_centroid(a.circle))
	;
	
	ALTER TABLE administratif.cluster_suf ADD COLUMN surf_hab integer;
	
	drop table if exists administratif.cluster_suf_cluster_suf_sum_surf_hab;
	create table administratif.cluster_suf_cluster_suf_sum_surf_hab as 
	select sum(b.surf_hab) surf_hab, a.id
	from administratif.cluster_suf as a, batiments.osm_2018 as b 
	where st_contains (a.circle, b.geom)
	group by a.id;
	
	UPDATE administratif.cluster_suf as a
	set surf_hab = b.surf_hab
	FROM administratif.cluster_suf_cluster_suf_sum_surf_hab as b 
	where a.id=b.id
	;

--- Schema : administratif
--- Vue : cluster_suf_cluster_suf_sum_surf_hab
--- Traitement : Centroide du cluster ayant le nombre d'habitant le plus élevé


   drop table if exists administratif.cluster_suf_cluster_suf_sum_surf_hab;

   drop table if exists administratif.cluster_suf_cluster_suf_sum_surf_hab_max;
	create table administratif.cluster_suf_cluster_suf_sum_surf_hab_max as
	select  max(surf_hab)max_surf_hab,nom_sec_fr
	from administratif.cluster_suf
	group by nom_sec_fr;


drop table if exists administratif.cluster_suf_cluster_suf_sum_surf_hab_max_centr;
	create table administratif.cluster_suf_cluster_suf_sum_surf_hab_max_centr as
select st_centroid(b.circle), max_surf_hab, a.nom_sec_fr
from administratif.cluster_suf_cluster_suf_sum_surf_hab_max a
left join administratif.cluster_suf b 
on a.max_surf_hab=b.surf_hab and a.nom_sec_fr=b.nom_sec_fr;

*/