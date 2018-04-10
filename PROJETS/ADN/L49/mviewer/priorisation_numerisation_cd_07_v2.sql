/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 09/03/2018
Objet : Préparation des tables pour la priorisation des phases de déploiements de la fibre optique 
via la numérisation du programme de réfection de voirie du département de l’Ardèche
Modification : Nom : // - Date : // - Motif/nature : //
-------------------------------------------------------------------------------------
*/

--- Schema : coordination
--- Table : tampon_numerisation_a_etudier
--- Traitement : buffer de 100m autour des numérisations

drop table if exists coordination.tampon_numerisation_a_etudier;
create table coordination.tampon_numerisation_a_etudier as 
SELECT 
a.id, st_buffer(a.geom,100)geom, a.id_opp, a.lot, a.id_prog, a.id_nro, a.id_reseau, a.insee, a.com_dep, a.statut, 
a.phase, a.emprise, a.nom, a.support, a.travaux, a.typ_reseau, a.longueur, a.debut_trvx, a.prog_dsp, a.moa, 
a.cdd, a.commentair, a.envoi_moe, a.date
FROM coordination.numerisation a
JOIN  administratif.communes as b
ON a.com_dep=b.commune
where statut LIKE 'A étudier' 
and envoi_moe LIKE 'S06_2018' 
and debut_trvx like '%2018%'
and phase_prog NOT LIKE 'phase 2' and phase_prog NOT LIKE 'AMII' 
order by a.moa;

--- Schema : rip2
--- Table : starr_liens_buffer
--- Traitement : buffer de 0.5 autour des starr liens

drop table if exists rip2.starr_liens_buffer;
create table rip2.starr_liens_buffer as 
SELECT 
ogc_fid, id_reseau, id_element, rang_opt, niveau, segment, support, nom, cle_ext, sites, prises, fibres, fibres_p2p, 
fibres_pon, fibres_res, cables, typ_cable, longueur, cout, id_nod_pri, id_nod_sup, capa_util, nom_nro, ancien_nom, st_buffer(geom, 0.5) geom
FROM  rip2.starr_liens as b;

CREATE INDEX starr_lien_buffer_gix ON rip2.starr_liens_buffer USING GIST (geom);

--- Schema : coordination
--- Table : tampon_liens
--- Traitement : Intersection entre les tampon_numerisation_a_etudier et  starr_liens_buffer (garde les tampon_numerisation_a_etudier)

drop table if exists coordination.tampon_liens;
create table coordination.tampon_liens as 
SELECT 
distinct on (a.id_opp)id_opp,a.id, a.geom, a.lot, a.id_prog, a.id_nro, a.id_reseau, a.insee, a.com_dep, a.statut, a.phase, a.emprise, 
a.nom, a.support, a.travaux, a.typ_reseau, a.longueur, a.debut_trvx, a.prog_dsp, a.moa, a.cdd, a.commentair, a.envoi_moe, a.date,
b.support as support_liens,  null::varchar as typ_cable, null::float (2) as lineaire_com, null::int as fibres, null::int as capa_util
FROM coordination.tampon_numerisation_a_etudier as a, rip2.starr_liens_buffer as b 
WHERE ST_INTERSECTS (a.geom, b.geom) ;

CREATE INDEX tampon_liens_gix ON coordination.tampon_liens USING GIST (geom);
ALTER TABLE coordination.tampon_liens ADD COLUMN gid SERIAL PRIMARY KEY;

--- Schema : coordination
--- Table : difference_liens
--- Traitement : Découpage entre le starr liens et le tampon_numerisation_a_etudier

drop table if exists coordination.difference_liens;
create table coordination.difference_liens as
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    tligne.ogc_fid AS idligne,
    tpolygone.gid AS idpolygone, 
	tpolygone.id_opp, 
	tligne.support,
	tligne.sites,
	tligne.prises,
	tligne.fibres,
	tligne.fibres_p2p,
	tligne.fibres_pon,
	tligne.fibres_res,
	tligne.capa_util,
    tligne.cables,
    tligne.typ_cable,
	tligne.longueur,
	st_length(tligne.geom) as longueur_com
    
FROM
    coordination.tampon_liens as tpolygone,
    rip2.starr_liens as tligne
WHERE
    tpolygone.geom && tligne.geom
AND
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.ogc_fid,
    tpolygone.gid
;

CREATE INDEX difference_liens_gix ON coordination.difference_liens USING GIST (geom);
ALTER TABLE  coordination.difference_liens ADD COLUMN gid SERIAL PRIMARY KEY;

--- Schema : coordination
--- Table : longueur_com_liens
--- Traitement : Pour chaque id_opp : la longueur totale de starr liens intersectant le buffer de numerisation, 
--- le type de cable selon le max de longueur de cables représenté
 
DROP TABLE IF EXISTS coordination.longueur_cable_liens;
CREATE TABLE coordination.longueur_cable_liens AS
SELECT
distinct on (a.id_opp) a.id_opp,
a.typ_cable_sup,
a.typ_cable,
a.lineaire_com,
a.fibres,
a.capa_util,
b.support
FROM
(
WITH attributs AS
(SELECT 
distinct on (a.id_opp) a.id_opp,
a.typ_cable_sup,
(CASE 
WHEN a.typ_cable_sup = 7 THEN 'X Cables >720'
WHEN a.typ_cable_sup = 6 THEN 'X Cables > 432'
WHEN a.typ_cable_sup = 5 THEN '1 Cable > 432' 
WHEN a.typ_cable_sup = 4 THEN 'X Cables > 144' 
WHEN a.typ_cable_sup = 3 THEN '1 Cable > 144' 
WHEN a.typ_cable_sup = 2 THEN 'X Cables > 24' 
WHEN a.typ_cable_sup = 1 THEN 'X Cables < 6' 
END) typ_cable,
b.longueur_max as lineaire_com,
c.max_fibres as fibres,
c.capa_util
FROM
(WITH cables AS (
SELECT  with_a.id_opp, with_a.longueur_max, with_a.typ_cable_max, with_b.typ_cable_sup
FROM
(WITH a AS 
		(SELECT SUM(longueur_com)::int as longueur_max, typ_cable, id_opp
		 FROM coordination.difference_liens
		 GROUP BY id_opp, typ_cable)

SELECT MAX(a.longueur_max)longueur_max, a.id_opp, 	
	(CASE 
	WHEN a.typ_cable like 'X Cables >720' and a.longueur_max >=200 THEN 'X Cables >720'
	WHEN a.typ_cable like 'X Cables >720' and a.longueur_max <200 or a.typ_cable like 'X Cables > 432'  and a.longueur_max >=200 THEN 'X Cables > 432'
	WHEN a.typ_cable like 'X Cables >720' and a.longueur_max >=200 or a.typ_cable like 'X Cables > 432'  and a.longueur_max >=200 or a.typ_cable like '1 Cable > 432' and a.longueur_max >=200 THEN '1 Cable > 432'
	WHEN a.typ_cable like 'X Cables >720' and a.longueur_max <200 or a.typ_cable like 'X Cables > 432'  and a.longueur_max >=200 or a.typ_cable like '1 Cable > 432' and a.longueur_max >=200 or a.typ_cable like 'X Cables > 144' and a.longueur_max >=200 THEN 'X Cables > 144'
	WHEN a.typ_cable like 'X Cables >720' and a.longueur_max <200 or a.typ_cable like 'X Cables > 432'  and a.longueur_max >=200 or a.typ_cable like '1 Cable > 432' and a.longueur_max >=200 or a.typ_cable like 'X Cables > 144' and a.longueur_max >=200 or a.typ_cable like '1 Cable > 144' and a.longueur_max >=200 THEN '1 Cable > 144'
    WHEN a.typ_cable like 'X Cables >720' and a.longueur_max <200 or a.typ_cable like 'X Cables > 432'  and a.longueur_max >=200 or a.typ_cable like '1 Cable > 432' and a.longueur_max >=200 or a.typ_cable like 'X Cables > 144' and a.longueur_max >=200 or a.typ_cable like '1 Cable > 144' and a.longueur_max >=200 or a.typ_cable like 'X Cables > 24' and a.longueur_max >=200 THEN 'X Cables > 24'
	WHEN a.typ_cable like 'X Cables >720' and a.longueur_max <200 or a.typ_cable like 'X Cables > 432'  and a.longueur_max >=200 or a.typ_cable like '1 Cable > 432' and a.longueur_max >=200 or a.typ_cable like 'X Cables > 144' and a.longueur_max >=200 or a.typ_cable like '1 Cable > 144' and a.longueur_max >=200 or a.typ_cable like 'X Cables > 24' and a.longueur_max >=200 or a.typ_cable like 'X Cables < 6' and a.longueur_max >=200 THEN 'X Cables < 6'
	END) as typ_cable_max
	FROM  a

	GROUP BY a.id_opp, a.typ_cable, a.longueur_max )with_a
LEFT JOIN 
(WITH b AS 
		(SELECT SUM(longueur_com)::int as longueur_max, typ_cable, id_opp
		 FROM coordination.difference_liens
		 GROUP BY id_opp, typ_cable)

SELECT MAX(b.longueur_max)longueur_max, b.id_opp, 	
	(CASE 
		WHEN typ_cable like 'X Cables >720' THEN 7 
		WHEN typ_cable like 'X Cables > 432' THEN 6
		WHEN typ_cable like '1 Cable > 432' THEN 5
		WHEN typ_cable like 'X Cables > 144' THEN 4
		WHEN typ_cable like '1 Cable > 144' THEN 3
		WHEN typ_cable like 'X Cables > 24' THEN 2
		WHEN typ_cable like 'X Cables < 6' THEN 1
		END) typ_cable_sup
	FROM  b

	GROUP BY b.id_opp, b.typ_cable, b.longueur_max ) with_b
	ON  with_a.longueur_max=with_b.longueur_max and with_a.id_opp = with_b.id_opp
  
	GROUP BY with_a.id_opp, with_a.typ_cable_max, with_b.typ_cable_sup, with_a.longueur_max )
	SELECT id_opp, max(typ_cable_sup)typ_cable_sup 
 	FROM cables
	GROUP BY id_opp)a	
LEFT JOIN 
	(WITH longueur AS
		(SELECT SUM(longueur_com)::int as longueur_max, id_opp
 		FROM coordination.difference_liens
 		GROUP BY id_opp)
 	SELECT *
 	FROM longueur
	) b ON a.id_opp = b.id_opp
LEFT JOIN 
	(WITH fibres_capa AS 
		(SELECT  id_opp, MAX(fibres) max_fibres
		FROM  coordination.difference_liens
		GROUP BY id_opp)
	SELECT  a.id_opp, b.max_fibres, a.capa_util
	FROM fibres_capa b 
	LEFT JOIN coordination.difference_liens a on a.id_opp=b.id_opp and b.max_fibres=a.fibres
	GROUP BY a.id_opp, max_fibres, capa_util ) c ON a.id_opp = c.id_opp	) 
	SELECT * from attributs	)a	
LEFT JOIN coordination.difference_liens as b on a.id_opp=b.id_opp 
group by a.id_opp, a.typ_cable_sup, a.typ_cable, a.lineaire_com, a.fibres, a.capa_util, b.support
ORDER BY a.id_opp;


--- Schema : coordination
--- Table : tampon_liens
--- Traitement : MAJ des attributs typ_cable et lineraire_com

update coordination.tampon_liens as a
set typ_cable = b.typ_cable
from coordination.longueur_cable_liens as b 
where a.id_opp = b.id_opp
;

update coordination.tampon_liens as a
set lineaire_com = b.lineaire_com
from coordination.longueur_cable_liens as b 
where a.id_opp = b.id_opp
;

update coordination.tampon_liens as a
set fibres = b.fibres
from coordination.longueur_cable_liens as b 
where a.id_opp = b.id_opp
;

update coordination.tampon_liens as a
set capa_util = b.capa_util
from coordination.longueur_cable_liens as b 
where a.id_opp = b.id_opp
;


--- Schema : rip2
--- Table : starr_transport_buffer
--- Traitement : buffer de 0.5 autour des starr transport

drop table if exists rip2.starr_transport_buffer;
create table rip2.starr_transport_buffer as 
SELECT ogc_fid, id_reseau, id_element, rang_opt, niveau, segment, support, nom, cle_ext, sites, prises, 
fibres, fibres_p2p, fibres_pon, fibres_res, cables, typ_cable, longueur, cout, id_nod_pri, id_nod_sup, nom_nro, 
ancien_nom, st_buffer(geom, 0.5) geom
FROM rip2.starr_transport;

CREATE INDEX starr_transport_buffer_gix ON rip2.starr_transport_buffer USING GIST (geom);

--- Schema : coordination
--- Table : tampon_transport
--- Traitement : Intersection entre les tampon_numerisation_a_etudier et  starr_transport_buffer (garde les tampon_numerisation_a_etudier)

drop table if exists coordination.tampon_transport;
create table coordination.tampon_transport as 
SELECT 
distinct on (a.id_opp)id_opp,a.id, a.geom, a.lot, a.id_prog, a.id_nro, a.id_reseau, a.insee, a.com_dep, a.statut, a.phase, a.emprise, 
a.nom, a.support, a.travaux, a.typ_reseau, a.longueur, a.debut_trvx, a.prog_dsp, a.moa, a.cdd, a.commentair, a.envoi_moe, a.date,
b.support as support_trans, null::varchar as typ_cable, null::float (2) as lineaire_com, null::int as fibres, null::int as capa_util
FROM coordination.tampon_numerisation_a_etudier as a, rip2.starr_transport_buffer as b 
WHERE ST_INTERSECTS (a.geom, b.geom);

CREATE INDEX tampon_transport_gix ON coordination.tampon_transport USING GIST (geom);
ALTER TABLE coordination.tampon_transport ADD COLUMN gid SERIAL PRIMARY KEY;

--- Schema : coordination
--- Table : difference_transport
--- Traitement : Découpage entre le starr transport et le tampon_numerisation_a_etudier

drop table if exists coordination.difference_transport;
create table coordination.difference_transport as
SELECT
    geom(st_dump(st_intersection(tligne.geom,tpolygone.geom))) AS geom,
    tligne.ogc_fid AS idligne,
    tpolygone.gid AS idpolygone, 
	tpolygone.id_opp, 
	tligne.support,
	tligne.sites,
	tligne.prises,
	tligne.fibres,
	tligne.fibres_p2p,
	tligne.fibres_pon,
	tligne.fibres_res,
	null::int as capa_util,
    tligne.cables,
    tligne.typ_cable,
	tligne.longueur,
	st_length(tligne.geom) as longueur_com
    
FROM
    coordination.tampon_transport as tpolygone,
    rip2.starr_transport as tligne
WHERE
    tpolygone.geom && tligne.geom
AND
    st_intersects(tpolygone.geom,tligne.geom)
ORDER BY
    tligne.ogc_fid,
    tpolygone.gid
;

CREATE INDEX difference_transport_gix ON coordination.difference_transport USING GIST (geom);
ALTER TABLE  coordination.difference_transport ADD COLUMN gid SERIAL PRIMARY KEY;

--- Schema : coordination
--- Table : longueur_com_transport
--- Traitement : Pour chaque id_opp : la longueur totale de starr transport intersectant le buffer de numerisation, 
--- le type de cable selon le max de longueur de cables représenté

DROP TABLE IF EXISTS coordination.longueur_cable_transport;
CREATE TABLE coordination.longueur_cable_transport AS
SELECT
distinct on (a.id_opp) a.id_opp,
a.typ_cable_sup,
a.typ_cable,
a.lineaire_com,
a.fibres,
a.capa_util,
b.support
FROM
(
WITH attributs AS
(SELECT 
distinct on (a.id_opp) a.id_opp,
a.typ_cable_sup,
(CASE 
WHEN a.typ_cable_sup = 7 THEN 'X Cables >720'
WHEN a.typ_cable_sup = 6 THEN 'X Cables > 432'
WHEN a.typ_cable_sup = 5 THEN '1 Cable > 432' 
WHEN a.typ_cable_sup = 4 THEN 'X Cables > 144' 
WHEN a.typ_cable_sup = 3 THEN '1 Cable > 144' 
WHEN a.typ_cable_sup = 2 THEN 'X Cables > 24' 
WHEN a.typ_cable_sup = 1 THEN 'X Cables < 6' 
END) typ_cable,
b.longueur_max as lineaire_com,
c.max_fibres as fibres,
c.capa_util
FROM
(WITH cables AS (
SELECT  with_a.id_opp, with_a.longueur_max, with_a.typ_cable_max, with_b.typ_cable_sup
FROM
(WITH a AS 
		(SELECT SUM(longueur_com)::int as longueur_max, typ_cable, id_opp
		 FROM coordination.difference_transport
		 GROUP BY id_opp, typ_cable)

SELECT MAX(a.longueur_max)longueur_max, a.id_opp, 	
	(CASE 
	WHEN a.typ_cable like 'X Cables >720' and a.longueur_max >=200 THEN 'X Cables >720'
	WHEN a.typ_cable like 'X Cables >720' and a.longueur_max <200 or a.typ_cable like 'X Cables > 432'  and a.longueur_max >=200 THEN 'X Cables > 432'
	WHEN a.typ_cable like 'X Cables >720' and a.longueur_max >=200 or a.typ_cable like 'X Cables > 432'  and a.longueur_max >=200 or a.typ_cable like '1 Cable > 432' and a.longueur_max >=200 THEN '1 Cable > 432'
	WHEN a.typ_cable like 'X Cables >720' and a.longueur_max <200 or a.typ_cable like 'X Cables > 432'  and a.longueur_max >=200 or a.typ_cable like '1 Cable > 432' and a.longueur_max >=200 or a.typ_cable like 'X Cables > 144' and a.longueur_max >=200 THEN 'X Cables > 144'
	WHEN a.typ_cable like 'X Cables >720' and a.longueur_max <200 or a.typ_cable like 'X Cables > 432'  and a.longueur_max >=200 or a.typ_cable like '1 Cable > 432' and a.longueur_max >=200 or a.typ_cable like 'X Cables > 144' and a.longueur_max >=200 or a.typ_cable like '1 Cable > 144' and a.longueur_max >=200 THEN '1 Cable > 144'
    WHEN a.typ_cable like 'X Cables >720' and a.longueur_max <200 or a.typ_cable like 'X Cables > 432'  and a.longueur_max >=200 or a.typ_cable like '1 Cable > 432' and a.longueur_max >=200 or a.typ_cable like 'X Cables > 144' and a.longueur_max >=200 or a.typ_cable like '1 Cable > 144' and a.longueur_max >=200 or a.typ_cable like 'X Cables > 24' and a.longueur_max >=200 THEN 'X Cables > 24'
	WHEN a.typ_cable like 'X Cables >720' and a.longueur_max <200 or a.typ_cable like 'X Cables > 432'  and a.longueur_max >=200 or a.typ_cable like '1 Cable > 432' and a.longueur_max >=200 or a.typ_cable like 'X Cables > 144' and a.longueur_max >=200 or a.typ_cable like '1 Cable > 144' and a.longueur_max >=200 or a.typ_cable like 'X Cables > 24' and a.longueur_max >=200 or a.typ_cable like 'X Cables < 6' and a.longueur_max >=200 THEN 'X Cables < 6'
	END) as typ_cable_max
	FROM  a

	GROUP BY a.id_opp, a.typ_cable, a.longueur_max )with_a
LEFT JOIN 
(WITH b AS 
		(SELECT SUM(longueur_com)::int as longueur_max, typ_cable, id_opp
		 FROM coordination.difference_transport
		 GROUP BY id_opp, typ_cable)

SELECT MAX(b.longueur_max)longueur_max, b.id_opp, 	
	(CASE 
		WHEN typ_cable like 'X Cables >720' THEN 7 
		WHEN typ_cable like 'X Cables > 432' THEN 6
		WHEN typ_cable like '1 Cable > 432' THEN 5
		WHEN typ_cable like 'X Cables > 144' THEN 4
		WHEN typ_cable like '1 Cable > 144' THEN 3
		WHEN typ_cable like 'X Cables > 24' THEN 2
		WHEN typ_cable like 'X Cables < 6' THEN 1
		END) typ_cable_sup
	FROM  b

	GROUP BY b.id_opp, b.typ_cable, b.longueur_max ) with_b
	ON  with_a.longueur_max=with_b.longueur_max and with_a.id_opp = with_b.id_opp
  
	GROUP BY with_a.id_opp, with_a.typ_cable_max, with_b.typ_cable_sup, with_a.longueur_max )
	SELECT id_opp, max(typ_cable_sup)typ_cable_sup 
 	FROM cables
	GROUP BY id_opp)a	
LEFT JOIN 
	(WITH longueur AS
		(SELECT SUM(longueur_com)::int as longueur_max, id_opp
 		FROM coordination.difference_transport
 		GROUP BY id_opp)
 	SELECT *
 	FROM longueur
	) b ON a.id_opp = b.id_opp
LEFT JOIN 
	(WITH fibres_capa AS 
		(SELECT  id_opp, MAX(fibres) max_fibres
		FROM  coordination.difference_transport
		GROUP BY id_opp)
	SELECT  a.id_opp, b.max_fibres, a.capa_util
	FROM fibres_capa b 
	LEFT JOIN coordination.difference_transport a on a.id_opp=b.id_opp and b.max_fibres=a.fibres
	GROUP BY a.id_opp, max_fibres, capa_util ) c ON a.id_opp = c.id_opp	) 
	SELECT * from attributs	)a	
LEFT JOIN coordination.difference_transport as b on a.id_opp=b.id_opp 
group by a.id_opp, a.typ_cable_sup, a.typ_cable, a.lineaire_com, a.fibres, a.capa_util, b.support
ORDER BY a.id_opp;


--- Schema : coordination
--- Table : tampon_transport
--- Traitement : MAJ des attributs typ_cable et lineraire_com

update coordination.tampon_transport as a
set typ_cable = b.typ_cable
from coordination.longueur_cable_transport as b 
where a.id_opp = b.id_opp
;

update coordination.tampon_transport as a
set lineaire_com = b.lineaire_com
from coordination.longueur_cable_transport as b 
where a.id_opp = b.id_opp
;
update coordination.tampon_transport as a
set fibres = b.fibres
from coordination.longueur_cable_transport as b 
where a.id_opp = b.id_opp
;

update coordination.tampon_transport as a
set capa_util = b.capa_util
from coordination.longueur_cable_transport as b 
where a.id_opp = b.id_opp
;


update coordination.tampon_transport as a
set capa_util = b.capa_util
from coordination.longueur_cable_transport as b 
where a.id_opp = b.id_opp
;




--- Schema : coordination
--- Table : tampon_union
--- Traitement : Union des deux tables tampon_liens et tampon_transport

DROP TABLE IF EXISTS coordination.tampon_union;
CREATE TABLE coordination.tampon_union as
SELECT id_opp, geom, lot, id_prog, id_nro, id_reseau, insee, com_dep, 
statut, phase, emprise, nom, support, travaux, typ_reseau, longueur, debut_trvx, 
prog_dsp, moa, cdd, commentair, envoi_moe, date, support_liens as support_sttar, null::varchar as prev_sttar, null::int as note_prev_sttar, typ_cable, lineaire_com,  null::int as note_lineaire, fibres, null::int as note_fibres, capa_util, 'tampon_liens'::varchar as source, null::int as note_source
FROM coordination.tampon_liens
UNION ALL
SELECT id_opp, geom, lot, id_prog, id_nro, id_reseau, insee, com_dep, 
statut, phase, emprise, nom, support, travaux, typ_reseau, longueur, debut_trvx, 
prog_dsp, moa, cdd, commentair, envoi_moe, date, support_trans as support_sttar, null::varchar as prev_sttar, null::int as note_prev_sttar, typ_cable, lineaire_com, null::int as note_lineaire, fibres, null::int as note_fibres, capa_util, 'tampon_transport'::varchar as source, null::int as note_source
FROM coordination.tampon_transport;

CREATE INDEX tampon_union_gix ON coordination.tampon_union USING GIST (geom);
ALTER TABLE coordination.tampon_union ADD COLUMN gid SERIAL PRIMARY KEY;


--- Schema : coordination
--- Table : difference_transport
--- Traitement : Mettre à jour les supports pour connaitre la prévision Sttar

		UPDATE coordination.tampon_union
		SET prev_sttar = case 
		when support_sttar  =  'conduite_ft' THEN 'Souterrain Orange'
		when support_sttar in('bt', 'bt <--> bt' ) AND  CAPA_UTIL <288 THEN 'Aérien BT'
	    when support_sttar in( 'aerien_ft', 'aerien_ft <--> aerien_ft' , 'aerien_ft <--> bt' ) AND  CAPA_UTIL <288 THEN 'Aérien FT'
		when support_sttar  =  'hta' THEN 'HTA'
 		when support_sttar  =  'adn_souterrain_DSP' THEN 'ADN'
		ELSE 'GC à créer'
		END;
	
--- Schema : coordination
--- Table : tampon_union
--- Traitement : Définition des règles pour classer les numérisations

/* Classement des types de cables
ALTER TABLE coordination.tampon_union ADD COLUMN clas_clabl integer;
		UPDATE coordination.tampon_union
		SET clas_clabl = case 
		when typ_cable like 'X Cables < 6' then 1
		when typ_cable like 'X Cables > 24' then 2
	    when typ_cable like '1 Cable > 144' then 3
		when typ_cable like 'X Cables > 144' then 4
		when typ_cable like '1 Cable > 432' then 5
		when typ_cable like 'X Cables > 432' then 6
		when typ_cable like 'X Cables >720' then 7
		end;
*/

/* Classement des nature de Starr	
		UPDATE coordination.tampon_union
		SET note_source = case 
		when source like 'tampon_transport' then 2 else 1
		end;
*/	


/* Classement es prévision sttar*/	
		UPDATE coordination.tampon_union
		SET note_prev_sttar = case 
		when prev_sttar LIKE 'ADN' THEN 0
		when prev_sttar LIKE 'Souterrain Orange' THEN 5
		when prev_sttar LIKE 'Aérien BT' OR prev_sttar LIKE 'Aérien FT' THEN 10
	    when prev_sttar LIKE 'GC à créer' THEN 20
		end;
		
/* Classement du nombre de fibres utiles*/		
		UPDATE coordination.tampon_union
		SET note_fibres = case 
		when fibres <=6 then 0
		when fibres BETWEEN 7 AND 24 then 1
	    when fibres BETWEEN 25 AND 48 then 1
		when fibres BETWEEN 48 AND 144 then 3
		when fibres BETWEEN 144 AND 288 then 5
		when fibres BETWEEN 288 AND 432 then 8
		when fibres >433 then 10
		end;

/* Classement des linéaires communs*/		
		UPDATE coordination.tampon_union
		SET note_lineaire = case 
		when lineaire_com <=2130 then 1
		when lineaire_com between 2131 and 4200 then 2
	    when lineaire_com between 4201 and 6300  then 3
		when lineaire_com between 6301 and 8400  then 4
		when lineaire_com between 8401 and 10500  then 5
		when lineaire_com between 10501 and 12500  then 6
		when lineaire_com between 12501 and 15000  then 7
		when lineaire_com between 15001 and 17000  then 8
		when lineaire_com between 17001 and 19000  then 9
		when lineaire_com >=19001  then 10
		end;

/* Classement total*/	
ALTER TABLE coordination.tampon_union ADD COLUMN note_total integer;
		UPDATE coordination.tampon_union
		SET note_total = note_prev_sttar+note_fibres+note_lineaire;

--- Schema : coordination
--- Table : tampon_union_classement
--- Traitement : Table sans doublons d'id_opp avec le lieaire commun, le type de cable, la source et le classement max 

DROP TABLE IF EXISTS coordination.tampon_union_classement;
CREATE TABLE coordination.tampon_union_classement as
  SELECT distinct on (id_opp) id_opp, MAX(note_total) as classement
  FROM coordination.tampon_union
  GROUP BY id_opp;

DROP TABLE IF EXISTS coordination.tampon_union_classement_final;
CREATE TABLE coordination.tampon_union_classement_final as
SELECT DISTINCT ON 
(a.id_opp) a.id_opp,  b.geom, b.lot, b.id_prog, b.id_nro, b.id_reseau, b.insee, 
b.com_dep, b.statut, b.phase, b.emprise, b.nom, b.support, b.travaux, b.typ_reseau, 
b.longueur, b.debut_trvx, b.prog_dsp, b.moa, b.cdd, b.commentair, b.envoi_moe, 
b.support_sttar, b.prev_sttar, b.note_prev_sttar, b.typ_cable, b.lineaire_com, 
b.note_lineaire, b.fibres, b.note_fibres, b.capa_util, CASE WHEN b.source like 'tampon_liens' THEN 'Sttar Liens' ELSE 'Sttar Transport' END as source, b.note_total as classement
FROM coordination.tampon_union_classement as a
LEFT JOIN coordination.tampon_union b 
ON a.id_opp = b.id_opp AND a.classement=b.note_total;
;
	
--- Schema : coordination
--- Table : numerisation_priorite_2018
--- Traitement : Table finale

DROP TABLE IF EXISTS coordination.numerisation_priorite_2018;
CREATE TABLE coordination.numerisation_priorite_2018 as
SELECT row_number() over() AS classement, *
FROM 
(select  ROW_NUMBER() OVER(PARTITION BY b.classement ORDER BY b.classement asc) AS id, a.id_opp, a.geom,  a.lot, a.id_prog, a.id_nro, a.id_reseau, 
a.insee, a.com_dep, a.statut, a.phase, a.emprise, a.nom, a.support, a.travaux, a.typ_reseau, 
a.longueur, a.debut_trvx, a.prog_dsp, a.moa, a.cdd, a.commentair, a.envoi_moe, 
b.support_sttar, b.prev_sttar, b.note_prev_sttar, b.typ_cable, b.lineaire_com, b.note_lineaire, b.fibres, 
b.note_fibres, b.capa_util, b.source, b.classement as note_totale
FROM coordination.tampon_union_classement_final b   
LEFT JOIN coordination.numerisation a ON a.id_opp like b.id_opp
)a
;

ALTER TABLE coordination.numerisation_priorite_2018 DROP COLUMN id RESTRICT;
CREATE INDEX numerisation_priorite_2018_gix ON coordination.numerisation_priorite_2018 USING GIST (geom);


--- Schema : coordination
--- Traitement : Suppression des tables intermédiaires

drop table if exists coordination.tampon_numerisation_a_etudier;
drop table if exists coordination.tampons_liens;
drop table if exists coordination.difference_liens;
DROP TABLE IF EXISTS coordination.longueur_cable_liens;
drop table if exists coordination.tampons_transport;
drop table if exists coordination.difference_transport;
DROP TABLE IF EXISTS coordination.longueur_cable_transport;
DROP TABLE IF EXISTS coordination.tampon_union ;
DROP TABLE IF EXISTS coordination.tampon_union_classement;
DROP TABLE IF EXISTS coordination.tampon_union_classement_final;