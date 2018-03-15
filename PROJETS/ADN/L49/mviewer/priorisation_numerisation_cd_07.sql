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
ON ST_CONTAINS (b.geom , a.geom)
where statut LIKE 'A étudier' 
and envoi_moe LIKE 'S06_2018' 
and moa LIKE 'Département de l''Ardèche'
and debut_trvx like '%2018%'
and phase_prog != 'phase 2';

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
 null::varchar as typ_cable, null::float (2) as lineaire_com
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
	tligne.sites,
	tligne.prises,
	tligne.fibres,
	tligne.fibres_p2p,
	tligne.fibres_pon,
	tligne.fibres_res,
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
a.id_opp,
a.typ_cable,
b.longueur_max as lineaire_com
FROM
	(WITH typ_cables AS
		(SELECT a.id_opp, b.typ_cable, a.longueur_max
	FROM 
	(WITH typ_cable AS 
		(SELECT  SUM(longueur_com)::int as longueur_max, typ_cable, id_opp
	 FROM coordination.difference_liens
     GROUP BY id_opp, typ_cable
	  )
		SELECT MAX(longueur_max)longueur_max, id_opp
	FROM  typ_cable
	GROUP BY id_opp) a
	LEFT JOIN
	(WITH typ_cable AS 
		(SELECT SUM(longueur_com)::int as longueur_max, typ_cable, id_opp
		 FROM coordination.difference_liens
		 GROUP BY id_opp, typ_cable
		)
		SELECT MAX(longueur_max)longueur_max, id_opp, typ_cable
	FROM  typ_cable
	GROUP BY id_opp, typ_cable) b 
	ON a.longueur_max=b.longueur_max and a.id_opp = b.id_opp)
	SELECT * FROM typ_cables)a
LEFT JOIN 
	(WITH longueur AS
		(SELECT SUM(longueur_com)::int as longueur_max, id_opp
 		FROM coordination.difference_liens
 		GROUP BY id_opp)
 	SELECT *
 	FROM longueur
	) b 
ON a.id_opp = b.id_opp
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
 null::varchar as typ_cable, null::float (2) as lineaire_com
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
	tligne.sites,
	tligne.prises,
	tligne.fibres,
	tligne.fibres_p2p,
	tligne.fibres_pon,
	tligne.fibres_res,
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
a.id_opp,
a.typ_cable,
b.longueur_max as lineaire_com
FROM
	(WITH typ_cables AS
		(SELECT a.id_opp, b.typ_cable, a.longueur_max
	FROM 
	(WITH typ_cable AS 
		(SELECT  SUM(longueur_com)::int as longueur_max, typ_cable, id_opp
	 FROM coordination.difference_transport
     GROUP BY id_opp, typ_cable
	  )
		SELECT MAX(longueur_max)longueur_max, id_opp
	FROM  typ_cable
	GROUP BY id_opp) a
	LEFT JOIN
	(WITH typ_cable AS 
		(SELECT SUM(longueur_com)::int as longueur_max, typ_cable, id_opp
		 FROM coordination.difference_transport
		 GROUP BY id_opp, typ_cable
		)
		SELECT MAX(longueur_max)longueur_max, id_opp, typ_cable
	FROM  typ_cable
	GROUP BY id_opp, typ_cable) b 
	ON a.longueur_max=b.longueur_max and a.id_opp = b.id_opp)
	SELECT * FROM typ_cables)a
LEFT JOIN 
	(WITH longueur AS
		(SELECT SUM(longueur_com)::int as longueur_max, id_opp
 		FROM coordination.difference_transport
 		GROUP BY id_opp)
 	SELECT *
 	FROM longueur
	) b 
ON a.id_opp = b.id_opp
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

--- Schema : coordination
--- Table : tampon_union
--- Traitement : Union des deux tables tampon_liens et tampon_transport

DROP TABLE IF EXISTS coordination.tampon_union;
CREATE TABLE coordination.tampon_union as
SELECT id_opp, geom, lot, id_prog, id_nro, id_reseau, insee, com_dep, 
statut, phase, emprise, nom, support, travaux, typ_reseau, longueur, debut_trvx, 
prog_dsp, moa, cdd, commentair, envoi_moe, date, typ_cable, lineaire_com, 'tampon_liens'::varchar as source
FROM coordination.tampon_liens
UNION ALL
SELECT id_opp, geom, lot, id_prog, id_nro, id_reseau, insee, com_dep, 
statut, phase, emprise, nom, support, travaux, typ_reseau, longueur, debut_trvx, 
prog_dsp, moa, cdd, commentair, envoi_moe, date, typ_cable, lineaire_com, 'tampon_transport'::varchar as source
FROM coordination.tampon_transport;

CREATE INDEX tampon_union_gix ON coordination.tampon_union USING GIST (geom);
ALTER TABLE coordination.tampon_union ADD COLUMN gid SERIAL PRIMARY KEY;

--- Schema : coordination
--- Table : tampon_union
--- Traitement : Définition des règles pour classer les numérisations

/* Classement des types de cables*/
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

/* Classement des linéaires communs*/		
ALTER TABLE coordination.tampon_union ADD COLUMN clas_line integer;
		UPDATE coordination.tampon_union
		SET clas_line = case 
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

/* Classement des nature de Starr*/	
ALTER TABLE coordination.tampon_union ADD COLUMN class_typ integer;
		UPDATE coordination.tampon_union
		SET class_typ = case 
		when source like 'tampon_transport' then 2 else 1
		end;

/* Classement total*/	
ALTER TABLE coordination.tampon_union ADD COLUMN class_tot integer;
		UPDATE coordination.tampon_union
		SET class_tot = clas_clabl+clas_line+class_typ;

--- Schema : coordination
--- Table : tampon_union_classement
--- Traitement : Table sans doublons d'id_opp avec le lieaire commun, le type de cable, la source et le classement max 

DROP TABLE IF EXISTS coordination.tampon_union_classement;
CREATE TABLE coordination.tampon_union_classement as
  SELECT distinct on (id_opp) id_opp, MAX(class_tot) as classement
  FROM coordination.tampon_union
  GROUP BY id_opp;

DROP TABLE IF EXISTS coordination.tampon_union_classement_final;
CREATE TABLE coordination.tampon_union_classement_final as
SELECT DISTINCT ON 
(a.id_opp) a.id_opp,  b.geom ,b.id_prog, b.id_nro, b.id_reseau, b.insee, b.com_dep, b.statut, b.phase, 
b.emprise, b.nom, b.support, b.travaux, b.typ_reseau, b.longueur, b.debut_trvx, b.prog_dsp, b.moa, b.cdd, 
b.commentair, b.envoi_moe, b.date, b.typ_cable, b.lineaire_com as lineai_com,  b.source, b.class_tot as classement
FROM coordination.tampon_union_classement as a
LEFT JOIN coordination.tampon_union b 
ON a.id_opp = b.id_opp AND a.classement=b.class_tot;
;

--- Schema : coordination
--- Table : numerisation_priorite_2018
--- Traitement : Table finale

DROP TABLE IF EXISTS coordination.numerisation_priorite_2018;
CREATE TABLE coordination.numerisation_priorite_2018 as
SELECT distinct on (a.id_opp) a.id_opp,a.geom,  a.lot, a.id_prog, a.id_nro, a.id_reseau, 
a.insee, a.com_dep, a.statut, a.phase, a.emprise, a.nom, a.support, a.travaux, a.typ_reseau, 
a.longueur, a.debut_trvx, a.prog_dsp, a.moa, a.cdd, a.commentair, a.envoi_moe, a.date,
b.typ_cable, b.lineai_com,  b.source, b.classement
FROM coordination.tampon_union_classement_final b   
LEFT JOIN coordination.numerisation a
ON a.id_opp like b.id_opp
;
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