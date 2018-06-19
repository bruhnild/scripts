/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 05/06/2017
Objet : Synchronisation des tables sttar v2 avec la v1
Modification : Nom : // - Date : // - Motif/nature : //
-------------------------------------------------------------------------------------
*/


--- Schema : rip2
--- Table : starr_transport_sync
--- Traitement : Union des deux tables sttar transport (v1 et v2)

DROP TABLE IF EXISTS rip2.starr_transport_sync;
CREATE TABLE rip2.starr_transport_sync as 
SELECT row_number() over () AS id, * 
FROM(
SELECT id_reseau, id_element, rang_opt, niveau, segment, support, nom, cle_ext, sites, 
prises, fibres, fibres_p2p, fibres_pon, fibres_res, cables, longueur, cout, id_nod_pri, id_nod_sup, 
nom_nro, typ_cable, 'v1'::varchar as source_file,  geom
FROM rip2.starr_transport
UNION ALL
SELECT id_reseau, id_element, rang_opt, niveau, segment, support, nom, cle_ext, sites, 
prises, fibres, fibres_p2p, fibres_pon, fibres_res, cables, longueur, cout, id_nod_pri, id_nod_sup, 
nro_ref,  typ_cable, 'v2'::varchar as source_file, geom
from rip2.resopt_lienstransport)a;

CREATE INDEX starr_transport_sync_gix ON rip2.starr_transport_sync USING GIST (geom);
	
--- Schema : rip2
--- Table : starr_transport_sync
--- Traitement : Suppression des lignes de sttar transport v1 (ne garde que v2) lorsque les nom nro existent dans les deux versions

WITH a_supprimer AS
(
SELECT *
FROM rip2.starr_transport_sync  AS num
WHERE num.nom_nro  IN 
(SELECT DISTINCT nom_nro 
FROM rip2.starr_transport_sync opp

WHERE num.source_file not LIKE  opp.source_file and num.source_file like 'v1'
GROUP BY nom_nro, source_file, id
HAVING num.nom_nro=opp.nom_nro
))

DELETE FROM rip2.starr_transport_sync a
USING a_supprimer b
WHERE a.id = b.id
;


--- Schema : rip2
--- Table : starr_liens_sync
--- Traitement : Union des deux tables sttar liens (v1 et v2)

DROP TABLE IF EXISTS rip2.starr_liens_sync;
CREATE TABLE rip2.starr_liens_sync as 
SELECT row_number() over () AS id, * 
FROM(
SELECT id_reseau, id_element, rang_opt, niveau, segment, support, nom, cle_ext, sites, 
prises, fibres, fibres_p2p, fibres_pon, fibres_res, cables, longueur, cout, id_nod_pri, id_nod_sup, 
nom_nro, typ_cable, 'v1'::varchar as source_file,  geom
FROM rip2.starr_liens
UNION ALL
SELECT id_reseau, id_element, rang_opt, niveau, segment, support, nom, cle_ext, sites, 
prises, fibres, fibres_p2p, fibres_pon, fibres_res, cables, longueur, cout, id_nod_pri, id_nod_sup, 
nro_ref,  typ_cable, 'v2'::varchar as source_file, geom
from rip2.resopt_liens)a;

CREATE INDEX starr_liens_sync_gix ON rip2.starr_liens_sync USING GIST (geom);
	
--- Schema : rip2
--- Table : starr_liens_sync
--- Traitement : Suppression des lignes de sttar liens v1 (ne garde que v2) lorsque les nom nro existent dans les deux versions

WITH a_supprimer AS
(
SELECT *
FROM rip2.starr_liens_sync  AS num
WHERE num.nom_nro  IN 
(SELECT DISTINCT nom_nro 
FROM rip2.starr_liens_sync opp

WHERE num.source_file not LIKE  opp.source_file and num.source_file like 'v1'
GROUP BY nom_nro, source_file, id
HAVING num.nom_nro=opp.nom_nro
))

DELETE FROM rip2.starr_liens_sync a
USING a_supprimer b
WHERE a.id = b.id
;