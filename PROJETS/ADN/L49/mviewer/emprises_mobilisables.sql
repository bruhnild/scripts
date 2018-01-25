CREATE OR REPLACE VIEW emprises_mobilisables.route_adn_ign_2017_2154 AS 
SELECT t1.id, t1.type, t1.emprise, t1.geom FROM dblink('host=192.168.101.254 port=5432 dbname=reseaux user=postgres password=l0cA!L8:','select id, type, emprise , geom from emprises_mobilisables.route_07_ign_2017_2154')
AS t1(id varchar, type varchar, emprise varchar, geom geometry) 
join dblink('host=192.168.101.254 port=5432 dbname=adn_l49 user=postgres password=l0cA!L8:','select commune, opp, geom from administratif.communes')
AS t2(commune varchar, opp varchar, geom geometry) on st_contains(t2.geom,t1.geom)
where t2.opp is not null 

