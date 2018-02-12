CREATE OR REPLACE VIEW emprises_mobilisables.route_adn_ign_2017_2154 AS 
SELECT t1.id, t1.type, t1.emprise, t1.geom FROM dblink('host=192.168.101.254 port=5432 dbname=reseaux user=postgres password=l0cA!L8:','select id, type, emprise , geom from emprises_mobilisables.route_07_ign_2017_2154')
AS t1(id varchar, type varchar, emprise varchar, geom geometry) 
join dblink('host=192.168.101.254 port=5432 dbname=adn_l49 user=postgres password=l0cA!L8:','select commune, opp, geom from administratif.communes')
AS t2(commune varchar, opp varchar, geom geometry) on st_contains(t2.geom,t1.geom)
where t2.opp is not null 
;

ALTER TABLE analyse_thematique.emprises_mobilisables_26_07  add COLUMN  longueur   integer;
UPDATE analyse_thematique.emprises_mobilisables_26_07 as a
SET longueur = st_length(geom)

CREATE INDEX emprises_mobilisables_26_07_gix ON analyse_thematique.emprises_mobilisables_26_07 USING GIST (geom);
VACUUM ANALYZE analyse_thematique.emprises_mobilisables_26_07
CLUSTER analyse_thematique.emprises_mobilisables_26_07 USING emprises_mobilisables_26_07_gix;

drop table if exists analyse_thematique.emprises_mobilisables_26_07_2;
create table analyse_thematique.emprises_mobilisables_26_07_2 as 
SELECT *
	FROM analyse_thematique.emprises_mobilisables_26_07;
	
	CREATE INDEX emprises_mobilisables_26_07_2_gix ON analyse_thematique.emprises_mobilisables_26_07_2 USING GIST (geom);
VACUUM ANALYZE analyse_thematique.emprises_mobilisables_26_07_2
CLUSTER analyse_thematique.emprises_mobilisables_26_07_2 USING emprises_mobilisables_26_07_2_gix;


	DELETE FROM analyse_thematique.emprises_mobilisables_26_07_2 
	WHERE longueur <25 and  emprise like  'GC_A_CREER' and  dn like  '>=42'  ;
	DELETE FROM analyse_thematique.emprises_mobilisables_26_07_2 
	WHERE longueur <25 and  emprise like  'GC_A_CREER' and  dn like  '21-41';
		DELETE FROM analyse_thematique.emprises_mobilisables_26_07_2 
	WHERE longueur <25 and  emprise like  'GC_A_CREER' and  dn like  '12-20'  ;
	DELETE FROM analyse_thematique.emprises_mobilisables_26_07_2 
	WHERE longueur <25 and  emprise like  'GC_A_CREER' and  dn like  '7-11';
		DELETE FROM analyse_thematique.emprises_mobilisables_26_07_2 
	WHERE longueur <25 and  emprise like  'GC_A_CREER' and  dn like  '0-6'  ;

ALTER TABLE analyse_thematique.emprises_mobilisables_26_07_2 RENAME TO emprises_mobilisables_26_07;