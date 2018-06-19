AALTER TABLE rip_2018.resopt_boitiers ADD COLUMN nro_ref varchar(30);
UPDATE rip_2018.resopt_boitiers SET nro_ref ='NRO_LT_07007_ALSR';
ALTER TABLE rip_2018.resopt_boitiers RENAME TO resopt_boitiers_1;

ALTER TABLE rip_2018.resopt_liens ADD COLUMN nro_ref varchar(30);
UPDATE rip_2018.resopt_liens SET nro_ref ='NRO_LT_07007_ALSR';
ALTER TABLE rip_2018.resopt_liens RENAME TO resopt_liens_1;

ALTER TABLE rip_2018.resopt_liensdistribution ADD COLUMN nro_ref varchar(30);
UPDATE rip_2018.resopt_liensdistribution SET nro_ref ='NRO_LT_07007_ALSR';
ALTER TABLE rip_2018.resopt_liensdistribution RENAME TO resopt_liensdistribution_1;

ALTER TABLE rip_2018.resopt_lienstransport ADD COLUMN nro_ref varchar(30);
UPDATE rip_2018.resopt_lienstransport SET nro_ref ='NRO_LT_07007_ALSR';
ALTER TABLE rip_2018.resopt_lienstransport RENAME TO resopt_lienstransport_1;

ALTER TABLE rip_2018.resopt_noeuds ADD COLUMN nro_ref varchar(30);
UPDATE rip_2018.resopt_noeuds SET nro_ref ='NRO_LT_07007_ALSR';
ALTER TABLE rip_2018.resopt_noeuds RENAME TO resopt_noeuds_1;

ALTER TABLE rip_2018.resopt_sites ADD COLUMN nro_ref varchar(30);
UPDATE rip_2018.resopt_sites SET nro_ref ='NRO_LT_07007_ALSR';
ALTER TABLE rip_2018.resopt_sites RENAME TO resopt_sites_1;

ALTER TABLE rip_2018.resopt_sitesdesservis ADD COLUMN nro_ref varchar(30);
UPDATE rip_2018.resopt_sitesdesservis SET nro_ref ='NRO_LT_07007_ALSR';
ALTER TABLE rip_2018.resopt_sitesdesservis RENAME TO resopt_sitesdesservis_1;

ALTER TABLE rip_2018.resopt_sitesnondesservis ADD COLUMN nro_ref varchar(30);
UPDATE rip_2018.resopt_sitesnondesservis SET nro_ref ='NRO_LT_07007_ALSR';
ALTER TABLE rip_2018.resopt_sitesnondesservis RENAME TO resopt_sitesnondesservis_1;

ALTER TABLE rip_2018.resopt_zonesdesservies ADD COLUMN nro_ref varchar(30);
UPDATE rip_2018.resopt_zonesdesservies SET nro_ref ='NRO_LT_07007_ALSR';
ALTER TABLE rip_2018.resopt_zonesdesservies RENAME TO resopt_zonesdesservies_1;

ALTER TABLE rip_2018.infras_liens ADD COLUMN nro_ref varchar(30);
UPDATE rip_2018.infras_liens SET nro_ref ='NRO_LT_07007_ALSR';
ALTER TABLE rip_2018.infras_liens RENAME TO infras_liens_1;

drop table if exists rip_2018.resopt_boitiers;
create table rip_2018.resopt_boitiers as 
select *
from rip_2018.resopt_boitiers_1
union all
select *
from rip_2018.resopt_boitiers_2
union all
select *
from rip_2018.resopt_boitiers_3
union all
select *
from rip_2018.resopt_boitiers_4
union all
select *
from rip_2018.resopt_boitiers_5
union all
select *
from rip_2018.resopt_boitiers_6
union all
select *
from rip_2018.resopt_boitiers_7
union all
select *
from rip_2018.resopt_boitiers_8
union all
select *
from rip_2018.resopt_boitiers_9
union all
select *
from rip_2018.resopt_boitiers_10
union all
select *
from rip_2018.resopt_boitiers_11
union all
select *
from rip_2018.resopt_boitiers_12
union all
select *
from rip_2018.resopt_boitiers_13
union all
select *
from rip_2018.resopt_boitiers_14
union all
select *
from rip_2018.resopt_boitiers_15
union all
select *
from rip_2018.resopt_boitiers_16
union all
select *
from rip_2018.resopt_boitiers_17
union all
select *
from rip_2018.resopt_boitiers_18
union all
select *
from rip_2018.resopt_boitiers_19
union all
select *
from rip_2018.resopt_boitiers_20;



drop table if exists rip_2018.resopt_liens;
create table rip_2018.resopt_liens as 
select *
from rip_2018.resopt_liens_1
union all
select *
from rip_2018.resopt_liens_2
union all
select *
from rip_2018.resopt_liens_3
union all
select *
from rip_2018.resopt_liens_4
union all
select *
from rip_2018.resopt_liens_5
union all
select *
from rip_2018.resopt_liens_6
union all
select *
from rip_2018.resopt_liens_7
union all
select *
from rip_2018.resopt_liens_8
union all
select *
from rip_2018.resopt_liens_9
union all
select *
from rip_2018.resopt_liens_10
union all
select *
from rip_2018.resopt_liens_11
union all
select *
from rip_2018.resopt_liens_12
union all
select *
from rip_2018.resopt_liens_13
union all
select *
from rip_2018.resopt_liens_14
union all
select *
from rip_2018.resopt_liens_15
union all
select *
from rip_2018.resopt_liens_16
union all
select *
from rip_2018.resopt_liens_17
union all
select *
from rip_2018.resopt_liens_18
union all
select *
from rip_2018.resopt_liens_19
union all
select *
from rip_2018.resopt_liens_20;


drop table if exists rip_2018.resopt_liensdistribution;
create table rip_2018.resopt_liensdistribution as 
select *
from rip_2018.resopt_liensdistribution_1
union all
select *
from rip_2018.resopt_liensdistribution_2
union all
select *
from rip_2018.resopt_liensdistribution_3
union all
select *
from rip_2018.resopt_liensdistribution_4
union all
select *
from rip_2018.resopt_liensdistribution_5
union all
select *
from rip_2018.resopt_liensdistribution_6
union all
select *
from rip_2018.resopt_liensdistribution_7
union all
select *
from rip_2018.resopt_liensdistribution_8
union all
select *
from rip_2018.resopt_liensdistribution_9
union all
select *
from rip_2018.resopt_liensdistribution_10
union all
select *
from rip_2018.resopt_liensdistribution_11
union all
select *
from rip_2018.resopt_liensdistribution_12
union all
select *
from rip_2018.resopt_liensdistribution_13
union all
select *
from rip_2018.resopt_liensdistribution_14
union all
select *
from rip_2018.resopt_liensdistribution_15
union all
select *
from rip_2018.resopt_liensdistribution_16
union all
select *
from rip_2018.resopt_liensdistribution_17
union all
select *
from rip_2018.resopt_liensdistribution_18
union all
select *
from rip_2018.resopt_liensdistribution_19
union all
select *
from rip_2018.resopt_liensdistribution_20;



drop table if exists rip_2018.resopt_lienstransport;
create table rip_2018.resopt_lienstransport as 
select *
from rip_2018.resopt_lienstransport_1
union all
select *
from rip_2018.resopt_lienstransport_2
union all
select *
from rip_2018.resopt_lienstransport_3
union all
select *
from rip_2018.resopt_lienstransport_4
union all
select *
from rip_2018.resopt_lienstransport_5
union all
select *
from rip_2018.resopt_lienstransport_6
union all
select *
from rip_2018.resopt_lienstransport_7
union all
select *
from rip_2018.resopt_lienstransport_8
union all
select *
from rip_2018.resopt_lienstransport_9
union all
select *
from rip_2018.resopt_lienstransport_10
union all
select *
from rip_2018.resopt_lienstransport_11
union all
select *
from rip_2018.resopt_lienstransport_12
union all
select *
from rip_2018.resopt_lienstransport_13
union all
select *
from rip_2018.resopt_lienstransport_14
union all
select *
from rip_2018.resopt_lienstransport_15
union all
select *
from rip_2018.resopt_lienstransport_16
union all
select *
from rip_2018.resopt_lienstransport_17
union all
select *
from rip_2018.resopt_lienstransport_18
union all
select *
from rip_2018.resopt_lienstransport_19
union all
select *
from rip_2018.resopt_lienstransport_20;


drop table if exists rip_2018.resopt_noeuds;
create table rip_2018.resopt_noeuds as 
select *
from rip_2018.resopt_noeuds_1
union all
select *
from rip_2018.resopt_noeuds_2
union all
select *
from rip_2018.resopt_noeuds_3
union all
select *
from rip_2018.resopt_noeuds_4
union all
select *
from rip_2018.resopt_noeuds_5
union all
select *
from rip_2018.resopt_noeuds_6
union all
select *
from rip_2018.resopt_noeuds_7
union all
select *
from rip_2018.resopt_noeuds_8
union all
select *
from rip_2018.resopt_noeuds_9
union all
select *
from rip_2018.resopt_noeuds_10
union all
select *
from rip_2018.resopt_noeuds_11
union all
select *
from rip_2018.resopt_noeuds_12
union all
select *
from rip_2018.resopt_noeuds_13
union all
select *
from rip_2018.resopt_noeuds_14
union all
select *
from rip_2018.resopt_noeuds_15
union all
select *
from rip_2018.resopt_noeuds_16
union all
select *
from rip_2018.resopt_noeuds_17
union all
select *
from rip_2018.resopt_noeuds_18
union all
select *
from rip_2018.resopt_noeuds_19
union all
select *
from rip_2018.resopt_noeuds_20;


drop table if exists rip_2018.resopt_sites;
create table rip_2018.resopt_sites as 
select *
from rip_2018.resopt_sites_1
union all
select *
from rip_2018.resopt_sites_2
union all
select *
from rip_2018.resopt_sites_3
union all
select *
from rip_2018.resopt_sites_4
union all
select *
from rip_2018.resopt_sites_5
union all
select *
from rip_2018.resopt_sites_6
union all
select *
from rip_2018.resopt_sites_7
union all
select *
from rip_2018.resopt_sites_8
union all
select *
from rip_2018.resopt_sites_9
union all
select *
from rip_2018.resopt_sites_10
union all
select *
from rip_2018.resopt_sites_11
union all
select *
from rip_2018.resopt_sites_12
union all
select *
from rip_2018.resopt_sites_13
union all
select *
from rip_2018.resopt_sites_14
union all
select *
from rip_2018.resopt_sites_15
union all
select *
from rip_2018.resopt_sites_16
union all
select *
from rip_2018.resopt_sites_17
union all
select *
from rip_2018.resopt_sites_18
union all
select *
from rip_2018.resopt_sites_19
union all
select *
from rip_2018.resopt_sites_20;


drop table if exists rip_2018.resopt_sitesdesservis;
create table rip_2018.resopt_sitesdesservis as 
select *
from rip_2018.resopt_sitesdesservis_1
union all
select *
from rip_2018.resopt_sitesdesservis_2
union all
select *
from rip_2018.resopt_sitesdesservis_3
union all
select *
from rip_2018.resopt_sitesdesservis_4
union all
select *
from rip_2018.resopt_sitesdesservis_5
union all
select *
from rip_2018.resopt_sitesdesservis_6
union all
select *
from rip_2018.resopt_sitesdesservis_7
union all
select *
from rip_2018.resopt_sitesdesservis_8
union all
select *
from rip_2018.resopt_sitesdesservis_9
union all
select *
from rip_2018.resopt_sitesdesservis_10
union all
select *
from rip_2018.resopt_sitesdesservis_11
union all
select *
from rip_2018.resopt_sitesdesservis_12
union all
select *
from rip_2018.resopt_sitesdesservis_13
union all
select *
from rip_2018.resopt_sitesdesservis_14
union all
select *
from rip_2018.resopt_sitesdesservis_15
union all
select *
from rip_2018.resopt_sitesdesservis_16
union all
select *
from rip_2018.resopt_sitesdesservis_17
union all
select *
from rip_2018.resopt_sitesdesservis_18
union all
select *
from rip_2018.resopt_sitesdesservis_19
union all
select *
from rip_2018.resopt_sitesdesservis_20;


drop table if exists rip_2018.resopt_zonesdesservies;
create table rip_2018.resopt_zonesdesservies as 
select *
from rip_2018.resopt_zonesdesservies_1
union all
select *
from rip_2018.resopt_zonesdesservies_2
union all
select *
from rip_2018.resopt_zonesdesservies_3
union all
select *
from rip_2018.resopt_zonesdesservies_4
union all
select *
from rip_2018.resopt_zonesdesservies_5
union all
select *
from rip_2018.resopt_zonesdesservies_6
union all
select *
from rip_2018.resopt_zonesdesservies_7
union all
select *
from rip_2018.resopt_zonesdesservies_8
union all
select *
from rip_2018.resopt_zonesdesservies_9
union all
select *
from rip_2018.resopt_zonesdesservies_10
union all
select *
from rip_2018.resopt_zonesdesservies_11
union all
select *
from rip_2018.resopt_zonesdesservies_12
union all
select *
from rip_2018.resopt_zonesdesservies_13
union all
select *
from rip_2018.resopt_zonesdesservies_14
union all
select *
from rip_2018.resopt_zonesdesservies_15
union all
select *
from rip_2018.resopt_zonesdesservies_16
union all
select *
from rip_2018.resopt_zonesdesservies_17
union all
select *
from rip_2018.resopt_zonesdesservies_18
union all
select *
from rip_2018.resopt_zonesdesservies_19
union all
select *
from rip_2018.resopt_zonesdesservies_20;

drop table if exists rip_2018.resopt_sitesnondesservis;
create table rip_2018.resopt_sitesnondesservis as 
--select *
--from rip_2018.resopt_sitesnondesservis_1
--union all
select *
from rip_2018.resopt_sitesnondesservis_2
union all
select *
from rip_2018.resopt_sitesnondesservis_3
union all
--select *
--from rip_2018.resopt_sitesnondesservis_4
--union all
--select *
--from rip_2018.resopt_sitesnondesservis_5
--union all
select *
from rip_2018.resopt_sitesnondesservis_6
union all
select *
from rip_2018.resopt_sitesnondesservis_7
union all
select *
from rip_2018.resopt_sitesnondesservis_8
union all
select *
from rip_2018.resopt_sitesnondesservis_9
union all
select *
from rip_2018.resopt_sitesnondesservis_10
union all
--select *
--from rip_2018.resopt_sitesnondesservis_11
--union all
--select *
--from rip_2018.resopt_sitesnondesservis_12
--union all
--select *
--from rip_2018.resopt_sitesnondesservis_13
--union all
select *
from rip_2018.resopt_sitesnondesservis_14
union all
--select *
--from rip_2018.resopt_sitesnondesservis_15
--union all
select *
from rip_2018.resopt_sitesnondesservis_16
union all
--select *
--from rip_2018.resopt_sitesnondesservis_17
--union all
--select *
--from rip_2018.resopt_sitesnondesservis_18
--union all
select *
from rip_2018.resopt_sitesnondesservis_19
--union all
--select *
--from rip_2018.resopt_sitesnondesservis_20;


drop table if exists rip_2018.infras_liens;
create table rip_2018.infras_liens as 
select *
from rip_2018.infras_liens_1
union all
select *
from rip_2018.infras_liens_2
union all
select *
from rip_2018.infras_liens_3
union all
select *
from rip_2018.infras_liens_4
union all
select *
from rip_2018.infras_liens_5
union all
select *
from rip_2018.infras_liens_6
union all
select *
--from rip_2018.infras_liens_7
--union all
--select *
from rip_2018.infras_liens_8
union all
select *
from rip_2018.infras_liens_9
union all
select *
from rip_2018.infras_liens_10
union all
select *
from rip_2018.infras_liens_11
union all
--select *
--from rip_2018.infras_liens_12
--union all
select *
from rip_2018.infras_liens_13
union all
select *
from rip_2018.infras_liens_14
union all
select *
from rip_2018.infras_liens_15
union all
select *
from rip_2018.infras_liens_16
union all
select *
from rip_2018.infras_liens_17
union all
select *
from rip_2018.infras_liens_18
union all
select *
from rip_2018.infras_liens_19
union all
select *
from rip_2018.infras_liens_20;



INSERT INTO rip2.resopt_boitiers (
 	id_reseau, 
	id_element, 
	rang_opt, 
	niveau, 
	support, 
	ref_prod, 
	usage, 
	cables, 
	epissures, 
	cout, 
	id_nod_pri, 
	id_nod_sup, 
	geom, 
	nro_ref
)
SELECT
   id_reseau, 
	id_element, 
	rang_opt, 
	niveau, 
	support, 
	ref_prod, 
	usage, 
	cables, 
	epissures, 
	cout, 
	id_nod_pri, 
	id_nod_sup, 
	geom, 
	nro_ref
FROM rip_2018.resopt_boitiers
;

INSERT INTO rip2.resopt_liens (
	id_reseau, 
	id_element, 
	rang_opt, 
	niveau, 
	segment, 
	support, 
	nom, 
	cle_ext, 
	sites, 
	prises, 
	fibres, 
	fibres_p2p, 
	fibres_pon, 
	fibres_res, 
	cables, 
	longueur, 
	cout, 
	id_nod_pri, 
	id_nod_sup, 
	geom, 
	nro_ref

)
SELECT
   	id_reseau, 
	id_element, 
	rang_opt, 
	niveau, 
	segment, 
	support, 
	nom, 
	cle_ext, 
	sites, 
	prises, 
	fibres, 
	fibres_p2p, 
	fibres_pon, 
	fibres_res, 
	cables, 
	longueur, 
	cout, 
	id_nod_pri, 
	id_nod_sup, 
	geom, 
	nro_ref
FROM rip_2018.resopt_liens
;

INSERT INTO rip2.resopt_liensdistribution (
	id_reseau, 
	id_element, 
	rang_opt, 
	niveau, 
	segment, 
	support, 
	nom, 
	cle_ext, 
	sites, 
	prises, 
	fibres, 
	fibres_p2p, 
	fibres_pon, 
	fibres_res, 
	cables, 
	longueur, 
	cout, 
	id_nod_pri, 
	id_nod_sup, 
	geom, 
	nro_ref


)
SELECT
   	id_reseau, 
	id_element, 
	rang_opt, 
	niveau, 
	segment, 
	support, 
	nom, 
	cle_ext, 
	sites, 
	prises, 
	fibres, 
	fibres_p2p, 
	fibres_pon, 
	fibres_res, 
	cables, 
	longueur, 
	cout, 
	id_nod_pri, 
	id_nod_sup, 
	geom, 
	nro_ref
FROM rip_2018.resopt_liensdistribution
;

INSERT INTO rip2.resopt_lienstransport (
	id_reseau, 
	id_element, 
	rang_opt, 
	niveau, 
	segment, 
	support, 
	nom, 
	cle_ext, 
	sites, 
	prises, 
	fibres, 
	fibres_p2p, 
	fibres_pon, 
	fibres_res, 
	cables, 
	longueur, 
	cout, 
	id_nod_pri, 
	id_nod_sup, 
	geom, 
	nro_ref


)
SELECT
   	id_reseau, 
	id_element, 
	rang_opt, 
	niveau, 
	segment, 
	support, 
	nom, 
	cle_ext, 
	sites, 
	prises, 
	fibres, 
	fibres_p2p, 
	fibres_pon, 
	fibres_res, 
	cables, 
	longueur, 
	cout, 
	id_nod_pri, 
	id_nod_sup, 
	geom, 
	nro_ref
FROM rip_2018.resopt_lienstransport
;

INSERT INTO rip2.resopt_noeuds (
	id_reseau, 
	id_element, 
	rang_opt, 
	niveau, 
	etat_racco, 
	supp_racco, 
	support, 
	nom, 
	cle_ext, 
	sites, 
	prises, 
	equip, 
	cout, 
	id_nod_pri, 
	l_nod_pri, 
	id_nod_sup, 
	l_nod_sup, 
	l_pto_min, 
	l_pto_max, 
	l_pto_tot, 
	c_noeud, 
	c_reseau, 
	c_prise, 
	geom, 
	nro_ref
)
SELECT
   	id_reseau, 
	id_element, 
	rang_opt, 
	niveau, 
	etat_racco, 
	supp_racco, 
	support, 
	nom, 
	cle_ext, 
	sites, 
	prises, 
	equip, 
	cout, 
	id_nod_pri, 
	l_nod_pri, 
	id_nod_sup, 
	l_nod_sup, 
	l_pto_min, 
	l_pto_max, 
	l_pto_tot, 
	c_noeud, 
	c_reseau, 
	c_prise, 
	geom, 
	nro_ref
FROM rip_2018.resopt_noeuds
;

INSERT INTO rip2.resopt_sites (
	id_reseau, 
	id_element, 
	rang_opt, 
	etat_racco, 
	supp_racco, 
	support, 
	nom, 
	cle_ext, 
	prises, 
	cout, 
	id_nod_pri, 
	l_nod_pri, 
	id_nod_sup, 
	l_nod_sup, 
	c_site, 
	c_prise, 
	geom, 
	nro_ref
)
SELECT
  	id_reseau, 
	id_element, 
	rang_opt, 
	etat_racco, 
	supp_racco, 
	support, 
	nom, 
	cle_ext, 
	prises, 
	cout, 
	id_nod_pri, 
	l_nod_pri, 
	id_nod_sup, 
	l_nod_sup, 
	c_site, 
	c_prise, 
	geom, 
	nro_ref
FROM rip_2018.resopt_sites
;

INSERT INTO rip2.resopt_sitesdesservis (
	id_reseau, 
	id_element, 
	rang_opt, 
	etat_racco, 
	supp_racco, 
	support, 
	nom, 
	cle_ext, 
	prises, 
	cout, 
	id_nod_pri, 
	l_nod_pri, 
	id_nod_sup, 
	l_nod_sup, 
	c_site, 
	c_prise, 
	geom, 
	nro_ref

)
SELECT
  		id_reseau, 
	id_element, 
	rang_opt, 
	etat_racco, 
	supp_racco, 
	support, 
	nom, 
	cle_ext, 
	prises, 
	cout, 
	id_nod_pri, 
	l_nod_pri, 
	id_nod_sup, 
	l_nod_sup, 
	c_site, 
	c_prise, 
	geom, 
	nro_ref
FROM rip_2018.resopt_sitesdesservis
;

INSERT INTO rip2.resopt_sitesnondesservis (
	id_reseau, 
	id_element, 
	rang_opt, 
	etat_racco, 
	supp_racco, 
	support, 
	nom, 
	cle_ext, 
	prises, 
	cout, 
	id_nod_pri, 
	l_nod_pri, 
	id_nod_sup, 
	l_nod_sup, 
	c_site, 
	c_prise, 
	geom, 
	nro_ref

)
SELECT
  	id_reseau, 
	id_element, 
	rang_opt, 
	etat_racco, 
	supp_racco, 
	support, 
	nom, 
	cle_ext, 
	prises, 
	cout, 
	id_nod_pri, 
	l_nod_pri, 
	id_nod_sup, 
	l_nod_sup, 
	c_site, 
	c_prise, 
	geom, 
	nro_ref
FROM rip_2018.resopt_sitesnondesservis
;

INSERT INTO rip2.resopt_zonesdesservies (
	id_reseau, 
	id_element, 
	rang_opt, 
	niveau, 
	etat_racco, 
	support, 
	nom, 
	cle_ext, 
	sites, 
	prises, 
	equip, 
	cout, 
	id_nod_pri, 
	l_nod_pri, 
	id_nod_sup, 
	l_nod_sup, 
	l_pto_min, 
	l_pto_max, 
	l_pto_tot, 
	c_noeud, 
	c_reseau, 
	c_prise, 
	geom, 
	nro_ref
)
SELECT
  	id_reseau, 
	id_element, 
	rang_opt, 
	niveau, 
	etat_racco, 
	support, 
	nom, 
	cle_ext, 
	sites, 
	prises, 
	equip, 
	cout, 
	id_nod_pri, 
	l_nod_pri, 
	id_nod_sup, 
	l_nod_sup, 
	l_pto_min, 
	l_pto_max, 
	l_pto_tot, 
	c_noeud, 
	c_reseau, 
	c_prise, 
	geom, 
	nro_ref
FROM rip_2018.resopt_zonesdesservies
;

UPDATE rip2.infras_liens
SET nro_ref = REPLACE(nro_ref, 'NRO_' , '')