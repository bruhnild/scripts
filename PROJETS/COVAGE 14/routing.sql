/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 24/01/2018
Objet : Création d'itinéraire à destinations multiples
Projet : COVAGE Normandie
Modification : Nom : ///// - Date : date_de_modif - Motif/nature : //////

Prerequis:
- Import de la couche infra en linestring
- Création des extensions postgis, postgis_topology et pgrouting

-------------------------------------------------------------------------------------
*/

------===============================================------
------= ETAPE 1 : PREPARATION DE LA BASE DE DONNEES =------
------===============================================------

-- Base de données: covage_14 (SERVEUR METIS LOCAL)

-- Action 1: Import des données projet dans le schéma mdz14/mai14/scf14/til14 (Depuis QGIS ou psql)
-- Liste des tables:

-- bpe (type Point)
-- infra (type Linestring) /!\ CORRIGER LA GEOMETRIE AVANT IMPORT
-- site (type Point)
-- supports (type Point)
-- zone_bpe (type Point)

-- Action 2: Suppression des paramètres précents et créations des nouveaux
ALTER TABLE mdz14.infra DROP COLUMN IF EXISTS topo CASCADE;
DROP SCHEMA IF EXISTS topology CASCADE;
DROP SCHEMA IF EXISTS routing CASCADE;
CREATE EXTENSION postgis_topology;
ALTER SCHEMA mdz14 RENAME TO mdz14%pm%; -- ou ALTER SCHEMA mai14/scf14/til14 RENAME TO mai14%pm%/scf14%pm%/til14%pm%
CREATE SCHEMA IF NOT EXISTS mdz14; -- ou mai14/scf14/til14

-- Action 3: Création du schéma topologique en 2154
SELECT topology.CreateTopology('routing', 2154);

-- Action 4: Correction de la géométrie
UPDATE mdz14.infra
SET geom=ST_MakeValid(geom);

-- Action 5: Passer la colonne geom de 3D à 2D
ALTER TABLE mdz14.infra
  ALTER COLUMN geom TYPE geometry(linestring, 2154) 
    USING ST_Force2D(geom);

-- Action 6: Ajouter une colonne topologique 'topo'
SELECT topology.AddTopoGeometryColumn('routing', 'mdz14', 'infra', 'topo', 'LINESTRING');

-- Action 7: Convertir les lignes brisées en noeuds et arrêtes au sein de la topologie  
UPDATE mdz14.infra SET topo = topology.toTopoGeom(geom, 'routing', 1, 0); -- /!\ LA GEOMETRIE DOIT ETRE PROPRE SINON PLANTAGE

-- Action 8: Ajout de la colonne  colonne tps_distance pour l'agorithme de plus court chemin
ALTER TABLE routing.edge_data  add COLUMN tps_distance    double precision;
UPDATE routing.edge_data a  SET tps_distance=st_length(st_transform(geom,2154))/1000;

------===============================================------
------= ETAPE 2 : PREPARATION DES DONNEES DE TRAVAIL =-----
------===============================================------

-- Action 1: Mettre les tables bpe et site dans le schema travail
-- Table bpe
drop table if exists travail.bpe;
create table travail.bpe as 
SELECT *
FROM mdz14.bpe
;
--Table site
drop table if exists travail.site;
create table travail.site as 
SELECT *
FROM mdz14.site
;

-- Action 2: Rajouter deux champs dans les tables bpe et site.
ALTER TABLE travail.bpe  add COLUMN  id_bpe   integer;
ALTER TABLE travail.site  add COLUMN  site_array  integer;

-- Action 3: Mettre à jour attributs depuis la table node
-- Champ id_bpe
UPDATE travail.bpe as a
SET id_bpe = b.node_id
FROM routing.node as b 
WHERE ST_intersects(st_buffer(a.geom,0.2),b.geom)
;

-- Champ site_array
UPDATE travail.site as a
SET site_array = b.node_id
FROM routing.node as b 
WHERE ST_intersects(st_buffer(a.geom,0.2),b.geom)
;

-- Action 4: Isoler les valeurs nulles
-- Table site_notfound
drop table if exists travail.site_notfound;
create table travail.site_notfound as
select *
from travail.site 
where site_array is null
;

-- Table bpe_notfound
drop table if exists travail.bpe_notfound;
create table travail.bpe_notfound as
select *
from travail.bpe 
where id_bpe is null
;

-- Action 5: Supprimer les valeurs nulles dans les tables bpe et site
DELETE FROM travail.site WHERE site_array is null ;
DELETE FROM travail.bpe WHERE id_bpe is null ;

------=================================================================================------
------= ETAPE 3 : pgr_kDijkstra - Plus court chemin Dijkstra à multiples destinations =------
------=================================================================================------

-- Action 1: Calcul des routes pour toutes les destinations (site) depuis le noeud source (bpe.)
drop table if exists routing.pgr_kdijkstraPath;
create table routing.pgr_kdijkstraPath as 

-- La première partie de la requete stocke les id_bpe et site_array (tableau) qui seront appelés dans l'algorithme
WITH input AS
(
SELECT 
a.id_bpe,
array_agg(c.site_array) site_array
FROM travail.bpe as a
JOIN mdz14.zone_bpe as b ON st_contains(b.geom, a.geom)
JOIN travail.site as c ON st_contains(b.geom, c.geom)
GROUP BY a.id_bpe
)
-- Algorithme pgr_kdijkstraPath avec jointure latérale 
SELECT 

	id1 AS path, 
 st_linemerge(st_union(b.geom)) as geom

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
        id_bpe,
        site_array,
        false, 
        false
)a, routing.edge_data b
WHERE a.id3=b.edge_id
GROUP by id1
ORDER by id1;

/* Pour obtenir le cheminement (sans la geom)

WITH input AS
(
SELECT 
a.id_bpe,
array_agg(c.site_array) site_array
FROM travail.bpe as a
JOIN mdz14.zone_pbo as b ON st_contains(b.geom, a.geom)
JOIN travail.site as c ON st_contains(b.geom, c.geom)
GROUP BY a.id_bpe 
)

SELECT 
*
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
    FROM routing_mdz14.edge_data',
        id_bpe,
        site_array,
        false, 
        false
)
;
*/

-- Action 2:  Obtenir le différentiel des lignes ne faisant pas partie du résultat de pgr_kdijkstraPath
DROP TABLE IF EXISTS travail.difference_edge_data_pgr_kdijkstraPath;
CREATE TABLE travail.difference_edge_data_pgr_kdijkstraPath AS
with temp as 
(
  select   b.edge_id, st_union(a.geom) as geom
  from     routing.edge_data  as b join routing.pgr_kdijkstraPath a on st_intersects(a.geom, b.geom)
  group by b.edge_id
) 
select st_difference(b.geom,coalesce(t.geom, 'GEOMETRYCOLLECTION EMPTY'::geometry)) as geom
from routing.edge_data b left join temp t on b.edge_id = t.edge_id;

-- Action 3: Union des deux tables (pgr_kdijkstraPath et difference_edge_data_pgr_kdijkstraPath )pour constituer la table cable
drop table if exists travail.cable;
create table travail.cable as 
select geom
from travail.difference_edge_data_pgr_kdijkstraPath
union all
select geom
from routing.pgr_kdijkstraPath;

------==============================================================------
------= ETAPE 4 : MISE A JOUR DES ATTRIBUTS DANS LA TABLE RESULTAT =------
------==============================================================------

-- Action 1: Ajout et mise à jour des champs permettant d'identifier le type et la nature du support
-- Rajouter champs type_struc
ALTER TABLE travail.cable  add COLUMN  type_struc   character varying;
-- Rajouter champs type_ptech
ALTER TABLE travail.cable  add COLUMN  type_ptech   character varying;
-- Mettre à jour les attributs 
-- Champs type_struc
UPDATE travail.cable as a 
SET type_struc = b.type_struc
FROM mdz14.supports as b 
WHERE ST_intersects (b.geom,(st_buffer(a.geom,0.2)))
;
-- Champs type_ptech
UPDATE travail.cable as a 
SET type_ptech = b.type_ptech
FROM mdz14.supports as b 
WHERE ST_intersects (b.geom,(st_buffer(a.geom,0.2)))
;