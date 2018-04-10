/*
 CALCULS D'ITINERAIRES (BOUCLES) PAR POSTE - TOURNEE DESSERTE POINTS RELAIS
-------------------------------------------------------------------------------------
*/

--- Traitement : Calcul itinéraires multiples depuis chaque poste


/*drop table if exists analyses.secteurs_merges;
create table analyses.secteurs_merges as 
select st_union (geom) geom, 'Poste relocalisée'::VARCHAR AS nom
from administratif.secteurs_grand_tunis
where nom_sec_fr like '14 JANVIER' or  
nom_sec_fr like 'KHAIREDDINE PACHA' or
nom_sec_fr like 'ABULKASSEM ECH-CHEBBI' or
nom_sec_fr like 'MONGI SLIM' or 
nom_sec_fr like '20 MARS'
union all
select st_union (geom)geom, 'Poste 2'::VARCHAR AS nom
from administratif.secteurs_grand_tunis
where nom_sec_fr like '18 JANVIER' or  
nom_sec_fr like 'IBN KHALDOUN' or
nom_sec_fr like '09 AVRIL' or
nom_sec_fr like 'CITE ETTADHAMEN' ;


drop table if exists batiments.pointsrelais_ettadhamen;
create table  batiments.pointsrelais_ettadhamen as 
SELECT 
geom, osm_id, code, fclass, name, type, id, usage, nom_gou_fr, 
nom_com_fr, nom_del_fr, nom_sec_fr, surface, surf_hab, relais, null::int as startnode, 'Poste relocalisée'::VARCHAR AS nom
FROM batiments.osm_2018
where relais like 'Relais Poste relocalisée' 
union all
SELECT 
geom, osm_id, code, fclass, name, type, id, usage, nom_gou_fr, 
nom_com_fr, nom_del_fr, nom_sec_fr, surface, surf_hab, relais, null::int as startnode, 'Poste 2'::VARCHAR AS nom
FROM batiments.osm_2018
where relais like 'Relais Poste 2';


drop table if exists batiments.postes_ettadhamen;
create table  batiments.postes_ettadhamen as 
SELECT 
geom, osm_id, code, fclass, name, type, id, usage, nom_gou_fr, 
nom_com_fr, nom_del_fr, nom_sec_fr, surface, surf_hab, relais, null::int as idposte
FROM batiments.osm_2018
where name like 'Scénario : Relocalisation poste' 
or name like 'bureau de poste ettedhamen';
 
drop view if exists batiments.points_relais_ettadhamen_startnode;
create view batiments.points_relais_ettadhamen_startnode as 
 SELECT a.id, b.start_node, min(a.dist)
   FROM
     (SELECT poi.id, 
             min(ST_distance(poi.geom,  edge_data.geom)) AS dist
      FROM batiments.pointsrelais_ettadhamen poi, routing.edge_data 
    where relais is not null
      GROUP BY poi.id) AS a,
     (SELECT poi.id, start_node, 
             ST_distance(poi.geom, edge_data.geom) AS dist
   FROM batiments.pointsrelais_ettadhamen poi , routing.edge_data
    where relais is not null) AS b
   WHERE a.dist = b. dist
   AND a.id = b.id
   GROUP BY a.id, b.start_node;

UPDATE batiments.pointsrelais_ettadhamen poi
SET startnode = 
   (SELECT start_node 
    FROM batiments.points_relais_ettadhamen_startnode as b 
    WHERE b.id = poi.id );

drop view if exists batiments.postes_ettadhamen_idposte;
create view batiments.postes_ettadhamen_idposte as 
 SELECT a.id, b.start_node, min(a.dist)
   FROM
     (SELECT poi.id, 
             min(ST_distance(poi.geom,  edge_data.geom)) AS dist
      FROM batiments.postes_ettadhamen poi, routing.edge_data 
    where relais is null
      GROUP BY poi.id) AS a,
     (SELECT poi.id, start_node, 
             ST_distance(poi.geom, edge_data.geom) AS dist
   FROM batiments.postes_ettadhamen poi , routing.edge_data
    where relais is null) AS b
   WHERE a.dist = b. dist
   AND a.id = b.id
   GROUP BY a.id, b.start_node;

UPDATE batiments.postes_ettadhamen poi
SET idposte = 
   (SELECT start_node 
    FROM batiments.postes_ettadhamen_idposte as b 
    WHERE b.id = poi.id );
 
drop table if exists routing.pgr_kdijkstraPath;
create table routing.pgr_kdijkstraPath as 
WITH input AS
(
SELECT 
a.idposte,
array_agg(startnode) startnode
FROM batiments.postes_ettadhamen as a
JOIN analyses.secteurs_merges as b ON st_contains(b.geom, a.geom) 
JOIN batiments.pointsrelais_ettadhamen as c ON c.nom=b.nom
GROUP BY a.idposte
)
-- Algorithme pgr_kdijkstraPath avec jointure latérale 
SELECT 

  id1 AS path, 
  id2 AS node, 
  id3 AS edge

FROM 
input
CROSS JOIN LATERAL
pgr_kdijkstraPath
(
      'SELECT 
  edge_id as id, 
  start_node as source, 
  end_node as target, 
  tps_distance as cost 
  FROM routing.edge_data',
        idposte,
        startnode,
        false, 
        false
)a, routing.edge_data b
WHERE a.id3=b.edge_id
GROUP by id1, id2, id3
ORDER by id1;


-- Ajout de la géométrie et attributs multimodaux
drop table if exists analyses.pgr_kdijkstraPath_isodistance;
create table analyses.pgr_kdijkstraPath_isodistance as 
SELECT  
  path, 
  round(sum(tps_pieton)) as tps_pieton, 
  round(sum(tps_velo))as tps_velo, 
  round(sum(tps_voiture)) as tps_voiture,
  st_linemerge(st_union(geom))
FROM routing.pgr_kdijkstraPath as a
left join routing.edge_data as b
on a.edge=b.edge_id
group by path
;
*/


--- Schema : analyses
--- Table : pgr_dijkstra_isodistance_boucle1_poste2
--- Traitement : Calcul itinéraire depuis poste 2 (boucle 1) pour desservir les points relais de sa zone


drop table if exists analyses.pgr_dijkstra_isodistance_boucle1_poste2;
create table analyses.pgr_dijkstra_isodistance_boucle1_poste2 as 
SELECT 1::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',453, 971, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 2::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',971, 1228, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 3::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',1228, 1226, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 4::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',1226, 1480, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 5::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',1480, 924, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 6::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',924, 168, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id
union all 
SELECT 7::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',168, 447, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 8::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',447, 171, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 9::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',171, 775, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 10::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',775, 453, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id
;


--- Schema : analyses
--- Table : pgr_dijkstra_isodistance_boucle2_poste2
--- Traitement : Calcul itinéraire depuis poste 2 (boucle 2) pour desservir les points relais de sa zone

drop table if exists analyses.pgr_dijkstra_isodistance_boucle2_poste2;
create table analyses.pgr_dijkstra_isodistance_boucle2_poste2 as 
SELECT 1::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',453, 1018, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 2::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',1018, 1390, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 3::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',1390, 391, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 4::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',391, 1317, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 5::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',1317, 1465, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 6::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',1465, 1111, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 7::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',1111, 62, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 8::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',62, 376, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 9::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',376, 453, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id
;

--- Schema : analyses
--- Table : pgr_dijkstra_isodistance_boucle1_postereloc
--- Traitement : Calcul itinéraire depuis poste relocalisee (boucle 1) pour desservir les points relais de sa zone

drop table if exists analyses.pgr_dijkstra_isodistance_boucle1_postereloc;
create table analyses.pgr_dijkstra_isodistance_boucle1_postereloc as 
SELECT 1::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',545, 574, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 2::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',574, 854, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 3::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',854, 218, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 4::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',218, 1543, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 5::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',1543, 1547, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 6::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',1547, 1301, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 7::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',1301, 1395, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 8::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',1395, 148, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 9::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',148, 524, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 10::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',524, 1206, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 11::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',1206, 545, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id;


--- Schema : analyses
--- Table : pgr_dijkstra_isodistance_boucle2_postereloc
--- Traitement : Calcul itinéraire depuis poste relocalisee (boucle 2) pour desservir les points relais de sa zone

drop table if exists analyses.pgr_dijkstra_isodistance_boucle2_postereloc;
create table analyses.pgr_dijkstra_isodistance_boucle2_postereloc as 
SELECT 1::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',545, 133, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 2::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',133, 747, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 3::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',747, 1401, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 4::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',1401, 1450, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 5::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',1450, 22, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 6::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',22, 669, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 7::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',669, 1156, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id
union all
SELECT 8::int as path, seq, id1 AS node, id2 AS edge, tps_distance as cost, tps_pieton, tps_velo, tps_voiture, geom 
FROM pgr_dijkstra
('SELECT edge_id as id, start_node as source, end_node as target,  tps_distance as  cost from routing.edge_data',1156, 545, false, false)            
as di JOIN routing.edge_data pt ON di.id2 = pt.edge_id
;


--- Traitement : Somme du temps voiture pour chaque itineraire

select sum(cost), (sum (tps_voiture)+45)::int as tps_voiture
from analyses.pgr_dijkstra_isodistance_boucle2_poste2
where tps_voiture != -60

select sum(cost), (sum (tps_voiture)+45)::int as tps_voiture
from analyses.pgr_dijkstra_isodistance_boucle1_poste2
where tps_voiture != -60

select sum(cost), (sum (tps_voiture)+45)::int as tps_voiture
from analyses.pgr_dijkstra_isodistance_boucle1_postereloc
where tps_voiture != -60

select sum(cost), (sum (tps_voiture)+45)::int as tps_voiture
from analyses.pgr_dijkstra_isodistance_boucle2_postereloc
where tps_voiture != -60

;

--- Schema : analyses
--- Table : pgr_dijkstra_isodistance_boucle1_poste2_merge
--- Traitement : Aggregation geom et attribut par path


drop table if exists analyses.pgr_dijkstra_isodistance_boucle1_poste2_merge;
create table analyses.pgr_dijkstra_isodistance_boucle1_poste2_merge as 
SELECT  
  path, 
  round(sum(b.tps_pieton)+5) as tps_pieton, 
  round(sum(b.tps_velo)+5)as tps_velo, 
  round(sum(b.tps_voiture)+5) as tps_voiture,
  st_linemerge(st_union(a.geom))
FROM analyses.pgr_dijkstra_isodistance_boucle1_poste2 as a
left join routing.edge_data as b
on a.edge=b.edge_id
group by path
;

--- Schema : analyses
--- Table : pgr_dijkstra_isodistance_boucle2_poste2_merge
--- Traitement : Aggregation geom et attribut par path

drop table if exists analyses.pgr_dijkstra_isodistance_boucle2_poste2_merge;
create table analyses.pgr_dijkstra_isodistance_boucle2_poste2_merge as 
SELECT  
  path, 
  round(sum(b.tps_pieton)+5) as tps_pieton, 
  round(sum(b.tps_velo)+5)as tps_velo, 
  round(sum(b.tps_voiture)+5) as tps_voiture,
  st_linemerge(st_union(a.geom))
FROM analyses.pgr_dijkstra_isodistance_boucle2_poste2 as a
left join routing.edge_data as b
on a.edge=b.edge_id
group by path
;

--- Schema : analyses
--- Table : pgr_dijkstra_isodistance_boucle1_postereloc_merge
--- Traitement : Aggregation geom et attribut par path

drop table if exists analyses.pgr_dijkstra_isodistance_boucle1_postereloc_merge;
create table analyses.pgr_dijkstra_isodistance_boucle1_postereloc_merge as 
SELECT  
  path, 
  round(sum(b.tps_pieton)+5) as tps_pieton, 
  round(sum(b.tps_velo)+5)as tps_velo, 
  round(sum(b.tps_voiture)+5) as tps_voiture,
  st_linemerge(st_union(a.geom))
FROM analyses.pgr_dijkstra_isodistance_boucle1_postereloc as a
left join routing.edge_data as b
on a.edge=b.edge_id
group by path
;

--- Schema : analyses
--- Table : pgr_dijkstra_isodistance_boucle2_postereloc_merge
--- Traitement : Aggregation geom et attribut par path

drop table if exists analyses.pgr_dijkstra_isodistance_boucle2_postereloc_merge;
create table analyses.pgr_dijkstra_isodistance_boucle2_postereloc_merge as 
SELECT  
  path, 
  round(sum(b.tps_pieton)+5) as tps_pieton, 
  round(sum(b.tps_velo)+5)as tps_velo, 
  round(sum(b.tps_voiture)+5) as tps_voiture,
  st_linemerge(st_union(a.geom))
FROM analyses.pgr_dijkstra_isodistance_boucle2_postereloc as a
left join routing.edge_data as b
on a.edge=b.edge_id
group by path
;