

/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 25/08/2017
Objet : Formatage tables MCD pour phase PRO 
Modification : Nom : ///// - Date : date_de_modif - Motif/nature : //////

FAUCHER MARINE - 31/08/2017 - Nommage des objets (BPE/CABLE/PTCHAMBRE)

Prerequis:

Voir Annexe SIG : I:\13 - AXIANS\THD ISERE\02 - Réception données client\Axians\05_06_2017\Données d'entrée tr21_in\01_01_SIG_DOCUMENT_GENERAL_V2_201608.pdf
Voir NOMMAGE_DES_OBJETS_DANS_QGIS : I:\13 - AXIANS\THD ISERE\02 - Réception données\Axians\tr21_in - TR21\PRO\23_08_2017\POCHE_tr21_in
-------------------------------------------------------------------------------------
*/

/*
TEMPS DE TRAITEMENT TOTAL : 154 ms
*/

--- Schema : metis_livrable
--- Table : cable

DROP TABLE IF EXISTS metis_livrable.cable;
CREATE TABLE metis_livrable.cable
(
  cab_id integer NOT NULL,--Numéro d'ordre unique 
  cab_tr character varying(2) NOT NULL ,--Numéro du tronçon 
  cab_nom character varying(20) NOT NULL ,--Nom du câble 
  cab_long numeric NOT NULL,--Longueur du câble en mètre 
  cab_etat character varying(10) NOT NULL,--Statut de création du câble 
  cab_capac integer NOT NULL,--Nombre total de fibre du câble si création ou nombre total de fibres louées 
  cab_modul numeric NOT NULL,--Modularité du câble
  cab_prop text NOT NULL,--Propriétaire du câble 
  cab_coll integer NOT NULL,--Nombre de lignes de collecte 
  cab_secu integer NOT NULL,--Nombre de lignes de sécurisation 
  cab_dist integer NOT NULL,--Nombre de lignes de distribution 
  cab_inter integer NOT NULL,--Nombre de lignes d'interconnexion 
  cab_dess integer NOT NULL,--Nombre de lignes de desserte 
  cab_cont text NOT NULL ,--Type de contrat 
  geom geometry(Geometry,2154),
  CONSTRAINT cable_pkey PRIMARY KEY (cab_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE metis_livrable.cable
  OWNER TO postgres;

-- Index: metis_livrable.cable_geom

-- DROP INDEX metis_livrable.cable_geom;

CREATE INDEX cable_geom
  ON metis_livrable.cable
  USING gist
  (geom);


-- Insertion dans la table metis_livrable.cable les entités de tr21_in.cable
INSERT INTO metis_livrable.cable (
cab_id, cab_tr, cab_nom, cab_long, cab_etat, cab_capac, cab_modul, 
cab_prop, cab_coll, cab_secu, cab_dist, cab_inter, cab_dess, 
cab_cont, geom)
SELECT
cab_id, cab_tr, cab_nom, cab_long, cab_etat, cab_capac, 
cab_modul, cab_prop, cab_coll, cab_secu, cab_dist, cab_inter, 
cab_dess, cab_cont, wkb_geometry as geom
from tr21_in.cable
;

-- Précision de la colonne géométrie dans la table metis_livrable.cable
SELECT populate_geometry_columns('metis_livrable.cable'::regclass);

UPDATE metis_livrable.cable set cab_nom = replace(cab_nom, '1200','120C')
WHERE cab_nom like '%CRO%';

--- Schema : metis_livrable
-- Table: metis_livrable.bpe


DROP TABLE IF EXISTS metis_livrable.bpe;
CREATE TABLE metis_livrable.bpe
(
  
  bpe_id integer NOT NULL, --Numéro d'ordre unique 
  bpe_tr character varying(20) NOT NULL,--Numéro du tronçon 
  bpe_nom character varying(20),--Nom du bpe 
  bpe_nbe integer NOT NULL,--Nombre d'épissures 
  bpe_pos text NOT NULL,--Position du boitier 
  bpe_nbcab integer NOT NULL,--Nombre de câble entrant et sortant du boitier (un même câble entrant et sortant sera compté deux fois 
  bpe_etat character varying(10) NOT NULL, --Statut de création du boitier 
  bpe_prop  text NOT NULL,--Propriétaire du boitier 
  geom geometry(Geometry,2154),
  CONSTRAINT bpe_pkey PRIMARY KEY (bpe_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE metis_livrable.bpe
  OWNER TO postgres;

-- Insertion dans la table metis_livrable.bpe les entités de tr21_in.bpe
INSERT INTO metis_livrable.bpe (
bpe_id, bpe_tr, bpe_nbe, bpe_pos, bpe_nbcab, bpe_etat, bpe_prop, geom)
SELECT
bpe_id, '20' as bpe_tr, bpe_nbe, bpe_pos, bpe_nbcab, bpe_etat, bpe_prop, wkb_geometry as geom
from tr21_in.bpe
;

-- Précision de la colonne géométrie dans la table metis_livrable.bpe
SELECT populate_geometry_columns('metis_livrable.bpe'::regclass);

-- Mise à jour du champ "bpe_nom"
UPDATE metis_livrable.bpe as a
SET bpe_nom = concat('BPE',(left(BPE_PROP,3)),'_',ptch_id,'_1')
FROM tr21_in.ptchambre as b 

WHERE ST_Intersects(a.geom,st_buffer(b.wkb_geometry,5));

--- Schema : metis_livrable
-- Table: metis_livrable.lgfourreaux

DROP TABLE IF EXISTS metis_livrable.lgfourreaux;
CREATE TABLE metis_livrable.lgfourreaux
(

  
  lgfx_id integer NOT NULL, --Numéro d'ordre unique 
  lgfx_tr character varying(2) NOT NULL,--Numéro du tronçon 
  lgfx_natur character varying NOT NULL,--Nature du fourreau  
  lgfx_diam character varying (10) NOT NULL,--Diamètre intérieur et extérieur du fourreau (sous la forme --/--) 
  lgfx_gest text NOT NULL,--Principal gestionnaire du domaine 
  lgfx_etat character varying(10) NOT NULL,--Statut de création du câble 
  lgfx_prop text NOT NULL,--Propriétaire de l'infrastructure d'accueil 
  lgfx_cont text NOT NULL,--Type de contrat 
  lgfx_long float NOT NULL,--Longueur du fourreau
  segment integer NOT NULL,--Numéro de segment
  geom geometry(Geometry,2154),
  CONSTRAINT lgfourreaux_pkey PRIMARY KEY (lgfx_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE metis_livrable.lgfourreaux
  OWNER TO postgres;

-- Insertion dans la table metis_livrable.lgfourreaux les entités de tr21_in.lgfourreaux
INSERT INTO metis_livrable.lgfourreaux (
lgfx_id, lgfx_tr, lgfx_natur, lgfx_diam, lgfx_gest, lgfx_etat, 
       lgfx_prop, lgfx_cont, lgfx_long, segment, geom
)
SELECT
lgfx_id, lgfx_tr, lgfx_natur, lgfx_diam, lgfx_gest, lgfx_etat, 
lgfx_prop, lgfx_cont, lgfx_long, segment,wkb_geometry as geom
from tr21_in.lgfourreaux
;

-- Précision de la colonne géométrie dans la table metis_livrable.lgfourreaux
SELECT populate_geometry_columns('metis_livrable.lgfourreaux'::regclass);

--- Schema : metis_livrable
-- Table: metis_livrable.lgautre
DROP TABLE IF EXISTS metis_livrable.lgautre;
CREATE TABLE metis_livrable.lgautre
( 
  ptau_id integer NOT NULL, --Numéro d'ordre unique 
  ptau_tr character varying(2) NOT NULL,--Numéro du tronçon 
  ptau_type character varying NOT NULL,--Type de cheminement     
  ptau_gest text  NOT NULL,--Principal gestionnaire du domaine   
  ptau_prop text NOT NULL,--Propriétaire de l'infrastructure d'accueil 
  ptau_etat character varying(10) NOT NULL,--Statut de création 
  ptau_lg float NOT NULL,--Longueur du fourreau
  segment integer NOT NULL,--Numéro de segment  
  geom geometry(Geometry,2154),
  CONSTRAINT lgautre_pkey PRIMARY KEY (ptau_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE metis_livrable.lgautre
  OWNER TO postgres;


  -- Insertion dans la table metis_livrable.lgautre les entités de tr21_in.lgautre
INSERT INTO metis_livrable.lgautre (
ptau_id, ptau_tr, ptau_type, ptau_gest, ptau_prop, ptau_etat, ptau_lg, segment,
geom)
SELECT
ptau_id, ptau_tr, ptau_type, ptau_gest, ptau_prop, ptau_etat,  ptau_lg, segment,
wkb_geometry as geom
from tr21_in.lgautre
;

-- Précision de la colonne géométrie dans la table metis_livrable.lgautre
SELECT populate_geometry_columns('metis_livrable.lgautre'::regclass);

--- Précise le type de géométrie de la colonne geom
ALTER TABLE metis_livrable.lgautre
ADD CONSTRAINT enforce_geotype_geom
CHECK (geometrytype(geom) = 'Multilinestring');

--- Schema : metis_livrable
-- Table: metis_livrable.orange
DROP TABLE IF EXISTS metis_livrable.lgorange;
CREATE TABLE metis_livrable.lgorange
(

  
  lgfx_id integer NOT NULL, --Numéro d'ordre unique 
  lgfx_tr character varying(2) NOT NULL,--Numéro du tronçon 
  lgfx_natur character varying NOT NULL,--Nature du fourreau  
  lgfx_diam character varying (10) NOT NULL,--Diamètre intérieur et extérieur du fourreau (sous la forme --/--) 
  lgfx_gest text NOT NULL,--Principal gestionnaire du domaine 
  lgfx_etat character varying(10) NOT NULL,--Statut de création du câble 
  lgfx_prop text NOT NULL,--Propriétaire de l'infrastructure d'accueil 
  lgfx_cont text NOT NULL,--Type de contrat 
  lgfx_long float NOT NULL,--Longueur du fourreau
  segment integer NOT NULL,--Numéro de segment
  geom geometry(Geometry,2154),
  CONSTRAINT lgorange_pkey PRIMARY KEY (lgfx_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE metis_livrable.lgorange
  OWNER TO postgres;

-- Insertion dans la table metis_livrable.lgorange les entités de tr21_in.lgorange
INSERT INTO metis_livrable.lgorange (
lgfx_id, lgfx_tr, lgfx_natur, lgfx_diam, lgfx_gest, lgfx_etat, 
       lgfx_prop, lgfx_cont, lgfx_long, segment,geom
)
SELECT
lgfx_id, lgfx_tr, lgfx_natur, lgfx_diam, lgfx_gest, lgfx_etat, 
lgfx_prop, lgfx_cont,lgfx_long, segment::int, wkb_geometry as geom
from tr21_in.lgorange
;

-- Précision de la colonne géométrie dans la table metis_livrable.lgorange
SELECT populate_geometry_columns('metis_livrable.lgorange'::regclass);

--- Schema : metis_livrable
-- Table: metis_livrable.tranchee

DROP TABLE IF EXISTS metis_livrable.tranchee;
CREATE TABLE metis_livrable.tranchee
(

  
  trch_id integer NOT NULL, --Numéro d'ordre unique 
  trch_tr character varying(2) NOT NULL,--Numéro du tronçon 
  trch_nb_f integer NOT NULL,--Nombre de fourreaux   
  trch_type text  NOT NULL,--Type de tranchée (référence de la coupe de tranchée) 
  trch_prof integer NOT NULL,--Profondeur de tranchée 
  trch_long float NOT NULL,--Longueur de tranchée 
  segment integer NOT NULL, -- Segment du tronçon
  geom geometry(Geometry,2154),
  CONSTRAINT tranchee_pkey PRIMARY KEY (trch_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE metis_livrable.tranchee
  OWNER TO postgres;

  -- Insertion dans la table metis_livrable.tranchee les entités de tr21_in.tranchee
INSERT INTO metis_livrable.tranchee (
trch_id, trch_tr, trch_nb_f, trch_type, trch_prof,trch_long ,segment,geom)
SELECT
trch_id, trch_tr, trch_nb_f, trch_type, trch_prof, trch_long,segment,wkb_geometry as geom
from tr21_in.tranchee
;

-- Précision de la colonne géométrie dans la table metis_livrable.tranchee
SELECT populate_geometry_columns('metis_livrable.tranchee'::regclass);

--- Schema : metis_livrable
-- Table: metis_livrable.trace
DROP TABLE IF EXISTS metis_livrable.trace;
CREATE TABLE metis_livrable.trace
(

  
  t_id integer NOT NULL, --Numéro d'ordre unique 
  t_long float NOT NULL,--Longueur en mètre du câble optique  
  t_at float NOT NULL,--Atténuation     
  geom geometry(Geometry,2154),
  CONSTRAINT trace_pkey PRIMARY KEY (t_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE metis_livrable.trace
  OWNER TO postgres;


  -- Insertion dans la table metis_livrable.trace les entités de tr21_in.trace
INSERT INTO metis_livrable.trace (
t_id, t_long, t_at, geom)
SELECT
t_id, t_long, t_at, wkb_geometry as geom
from tr21_in.trace
;

-- Précision de la colonne géométrie dans la table metis_livrable.trace
SELECT populate_geometry_columns('metis_livrable.trace'::regclass);

--- Schema : metis_livrable
-- Table: metis_livrable.ptchambre
DROP TABLE IF EXISTS metis_livrable.ptchambre;
CREATE TABLE metis_livrable.ptchambre
(

  
  ptch_id integer NOT NULL, --Numéro d'ordre unique 
  ptch_tr character varying(2) NOT NULL,--Numéro du tronçon 
  ptch_nom character varying(20) NOT NULL,--Numéro du tronçon 
  ptch_type character varying NOT NULL,--Type de chambre    
  ptch_local text  NOT NULL,--Positionnement de la chambre  
  ptch_gest text NOT NULL,--Principal gestionnaire du domaine 
  ptch_prop text NOT NULL,--Propriétaire de l'infrastructure d'accueil  
  ptch_etat character varying(10) NOT NULL,--Statut de création du câble  
  ptch_nbcab integer NOT NULL,--Nombre de câble entrant et sortant de la chambre (un même câble entrant et sortant sera compté deux fois  
  segment integer NOT NULL,--Numéro de segment du tronçon
  insee character varying(5) NOT NULL,--Numéro INSEE de la commune
  love float NOT NULL,--Love total des cables dans la chambre
  geom geometry(Geometry,2154),
  CONSTRAINT ptchambre_pkey PRIMARY KEY (ptch_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE metis_livrable.ptchambre
  OWNER TO postgres;


  -- Insertion dans la table metis_livrable.ptchambre les entités de tr21_in.ptchambre
INSERT INTO metis_livrable.ptchambre (
ptch_id, ptch_tr, ptch_nom, ptch_type, ptch_local, ptch_gest, ptch_prop, 
       ptch_etat, ptch_nbcab, segment, insee, love, geom)
SELECT
ptch_id, ptch_tr, ptch_nom, ptch_type, ptch_local, ptch_gest, ptch_prop, 
       ptch_etat, ptch_nbcab, segment, insee, love,wkb_geometry as geom
from tr21_in.ptchambre
;

-- Précision de la colonne géométrie dans la table metis_livrable.ptchambre
SELECT populate_geometry_columns('metis_livrable.ptchambre'::regclass);

--- Schema : metis_livrable
-- Table: metis_livrable.zone
DROP TABLE IF EXISTS metis_livrable.zone;
CREATE TABLE metis_livrable.zone
(
  
  z_id integer NOT NULL, --Numéro d'ordre unique 
  z_id_nro character varying(10) NOT NULL,--Nom du NRO  
  z_id_pd character varying (20) NOT NULL,--Nom du PDC, PDINTERCO ou PDL      
  geom geometry(Geometry,2154),
  CONSTRAINT zone_pkey PRIMARY KEY (z_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE metis_livrable.zone
  OWNER TO postgres;


-- Insertion dans la table metis_livrable.zone les entités de tr21_in.zone
INSERT INTO metis_livrable.zone (
z_id, z_id_nro, z_id_pd, geom)
SELECT
z_id, z_id_nro, z_id_pd,wkb_geometry as geom
from tr21_in.zone
;

-- Précision de la colonne géométrie dans la table metis_livrable.zone
SELECT populate_geometry_columns('metis_livrable.zone'::regclass);

--- Schema : metis_livrable
-- Table: metis_livrable.ssc_tr
DROP TABLE IF EXISTS metis_livrable.ssc_tr;
CREATE TABLE metis_livrable.ssc_tr
(
  
  ssc_id character varying NOT NULL, --Numéro d'ordre unique 
  ssc_type text NOT NULL,--Type de SSC   
  ssc_nom text NOT NULL,--Nom du SSC   
  ssc_add character varying (30) NOT NULL,--Connectabilité d'un site  
  ssc_secu character varying (10),--Niveau de sécurisation 
  ssc_sds character varying NOT NULL,--NOM du SSC passé en SDS  
  geom geometry(Geometry,2154),
  CONSTRAINT ssc_tr_pkey PRIMARY KEY (ssc_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE metis_livrable.ssc_tr
  OWNER TO postgres;


-- Insertion dans la table metis_livrable.ssc_tr les entités de tr21_in.ssc_tr
INSERT INTO metis_livrable.ssc_tr (
ssc_id, ssc_type, ssc_nom, ssc_add,ssc_secu,ssc_sds,geom )
SELECT
id, cat, nom, adresse,null as ssc_secu,ssc_sds,wkb_geometry as geom
from tr21_in.ssc
;

-- Précision de la colonne géométrie dans la table metis_livrable.ssc_tr
SELECT populate_geometry_columns('metis_livrable.ssc_tr'::regclass);

--- Précise le type de géométrie de la colonne geom
ALTER TABLE metis_livrable.ssc_tr
ADD CONSTRAINT enforce_geotype_geom
CHECK (geometrytype(geom) = 'MultiPoint')
;


--- Schema : metis_livrable
-- Table: metis_livrable.sds_tr
DROP TABLE IF EXISTS metis_livrable.sds_tr;
CREATE TABLE metis_livrable.sds_tr
(
  
  sds_id character varying NOT NULL, --Numéro d'ordre unique 
  sds_type text NOT NULL,--Type de SDC   
  sds_nom text NOT NULL,--Nom du SDC   
  sds_add character varying (30) NOT NULL,--Connectabilité d'un site  
  sds_secu character varying (10),--Niveau de sécurisation 
  geom geometry(Geometry,2154),
  CONSTRAINT sds_tr_pkey PRIMARY KEY (sds_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE metis_livrable.sds_tr
  OWNER TO postgres;


-- Insertion dans la table metis_livrable.sds_tr les entités de tr21_in.sds_tr
INSERT INTO metis_livrable.sds_tr (
sds_id, sds_type, sds_nom, sds_add,sds_secu,geom )
SELECT
id, cat, nom, adresse,r_securisa as sds_secu,wkb_geometry as geom
from tr21_in.sds
;

-- Précision de la colonne géométrie dans la table metis_livrable.sds_tr
SELECT populate_geometry_columns('metis_livrable.sds_tr'::regclass);

--- Précise le type de géométrie de la colonne geom
ALTER TABLE metis_livrable.sds_tr
ADD CONSTRAINT enforce_geotype_geom
CHECK (geometrytype(geom) = 'MultiPoint')
;



--- Schema : metis_livrable
-- Table: metis_livrable.pi
DROP TABLE IF EXISTS metis_livrable.pi;
CREATE TABLE metis_livrable.pi
(
  
  pi_id integer NOT NULL, --Numéro d'ordre unique 
  pi_insee character varying (5) NOT NULL,--Code INSEE de la commune    
  pi_cnom text NOT NULL,--Nom de la commune   
  pi_ntd text NOT NULL,--Nom du tiers détenteur du PI  
  pi_n_amont character varying ,--Le numéro du NRO en amont sur l'infrastructure de collecte  
  geom geometry(Geometry,2154),
  CONSTRAINT pi_pkey PRIMARY KEY (pi_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE metis_livrable.pi
  OWNER TO postgres;


-- Insertion dans la table metis_livrable.pi les entités de tr21_in.pi
INSERT INTO metis_livrable.pi (
pi_id, pi_insee, pi_cnom, pi_ntd,pi_n_amont,geom )
SELECT
pi_id, pi_insee, pi_cnom, pi_ntd,pi_n_amont,wkb_geometry as geom
from tr21_in.pi
;

-- Précision de la colonne géométrie dans la table metis_livrable.pi
SELECT populate_geometry_columns('metis_livrable.pi'::regclass);

--- Précise le type de géométrie de la colonne geom
ALTER TABLE metis_livrable.pi
ADD CONSTRAINT enforce_geotype_geom
CHECK (geometrytype(geom) = 'MultiPoint')
;


--- Schema : metis_livrable
-- Table: metis_livrable.photo
DROP TABLE IF EXISTS metis_livrable.photo;
CREATE TABLE metis_livrable.photo
(
  
  ph_id integer NOT NULL, --Numéro d'ordre unique pour chaque photo  
  ph_tr character varying (2) NOT NULL, --Numéro du tronçon
  ph_lot character varying (2) NOT NULL,--Numéro du lot    
  ph_nom character varying  NOT NULL,--Nom de la photographie. Il correspond au nom du fichier de la photo sans l'extension    
  ph_date character varying (8) NOT NULL,--Date de prise de vue   
  ph_lieu character varying NOT NULL,--Lieu de la prise de vue. Description sommaire de l'endroit de la prise de vuelien character varying ,--Le numéro du NRO en amont sur l'infrastructure de collecte  
  lien character varying  NOT NULL,--Lien HyperText automatisé permettant de visualiser les photos dans le logiciel SIG 
  geom geometry(Geometry,2154),
  CONSTRAINT photo_pkey PRIMARY KEY (ph_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE metis_livrable.photo
  OWNER TO postgres;


-- Insertion dans la table metis_livrable.photo les entités de tr21_in.photo

INSERT INTO metis_livrable.photo (
ph_id,ph_tr, ph_lot, ph_nom,ph_date,ph_lieu, lien, geom)
SELECT
ph_id,ph_tr, ph_lot, ph_nom,ph_date,ph_lieu, lien, wkb_geometry as geom
from tr21_in.photo
;

-- Précision de la colonne géométrie dans la table metis_livrable.photo
SELECT populate_geometry_columns('metis_livrable.photo'::regclass);

--- Schema : metis_livrable
-- Table: metis_livrable.pdc_pdinterco_pdl
DROP TABLE IF EXISTS metis_livrable.pdc_pdinterco_pdl;
CREATE TABLE metis_livrable.pdc_pdinterco_pdl
(
  
  p_id integer NOT NULL, --Numéro d'ordre unique 
  p_nom character varying  NOT NULL, --Nom du point de desserte 
  p_type character varying (3) NOT NULL,--Type de point de desserte  
  p_nb_suf_pro integer  NOT NULL,--Nombre de SUF PRO présents dans la zone arrière du point de desserte 
  p_nb_suf_res integer NOT NULL,--Nombre de SUF résidentiels présents dans la zone arrière du point de desserte    
  p_nb_ldist integer NOT NULL,--Nombre de lignes de distribution du point de desserte 
  p_long_o float  NOT NULL,--Longueur en mètre du chemin optique entre le point de desserte et son NRO 
  p_type_site character varying  NOT NULL,--Type de site technique utilisé pour la réalisation du point de desserte 
  geom geometry(Geometry,2154),
  CONSTRAINT pdc_pdinterco_pdl_pkey PRIMARY KEY (p_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE metis_livrable.pdc_pdinterco_pdl
  OWNER TO postgres;


-- Insertion dans la table metis_livrable.pdc_pdinterco_pdl les entités de tr21_in.pdc_pdinterco_pdl

INSERT INTO metis_livrable.pdc_pdinterco_pdl (
p_id,p_nom, p_type, p_nb_suf_pro,p_nb_suf_res,p_nb_ldist, p_long_o, p_type_site, geom)
SELECT
p_id,p_nom, p_type, p_nb_suf_p,p_nb_suf_r,p_nb_ldist, trace_p_n, p_type_sit, wkb_geometry as geom
from tr21_in.pdc_pdinterco_pdl
;

-- Précision de la colonne géométrie dans la table metis_livrable.pdc_pdinterco_pdl
SELECT populate_geometry_columns('metis_livrable.pdc_pdinterco_pdl'::regclass);

--- Schema : metis_livrable
-- Table: metis_livrable.nro
DROP TABLE IF EXISTS metis_livrable.nro;
CREATE TABLE metis_livrable.nro
(
  
  n_id integer NOT NULL, --Numéro d'ordre unique 
  n_nom character varying (9) NOT NULL, --Nom du NRO  
  n_insee character varying (5) NOT NULL,--Code INSEE de la commune   
  n_cnom text  NOT NULL,--Nom de la commune  
  n_d_racco character varying (20) NOT NULL,--Date prévisionnelle du raccordement du NRO   
  n_d_co character varying (20) NOT NULL,--Date prévisionnelle de livraison de la continuité optique du NRO avec un NRO ou un PI permettant l'ouverture effective de l'infrastructure  
  n_secu character varying (3) NOT NULL,--Statut de sécurisation du NRO 
  n_prop_secu character varying  NOT NULL,--Propriétaire de l'infrastructure de sécurisation   
  n_id_amont character varying (20) NOT NULL,--Numéro du NRO en amont dans le sens de la sécurisation sur l'infrastructure de collecte  
  n_id_aval character varying (20) NOT NULL,--Numéro du NRO en aval dans le sens de la sécurisation sur l'infrastructure de collecte 
  n_suf integer  NOT NULL,--Nombre de SUF couvert de la zone arrière du NRO 
  n_ur integer  NOT NULL,--Nombre d'unité de réalisation couverte dans la zone arrière du NRO 
  geom geometry(Geometry,2154),
  CONSTRAINT nro_pkey PRIMARY KEY (n_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE metis_livrable.nro
  OWNER TO postgres;


-- Insertion dans la table metis_livrable.nro les entités de tr21_in.nro

INSERT INTO metis_livrable.nro (
n_id,n_nom, n_insee, n_cnom,n_d_racco,n_d_co, n_secu, n_prop_secu, n_id_amont, n_id_aval,n_suf,n_ur, geom)
SELECT
n_id,n_nom, n_insee, n_cnom,n_d_racco,n_d_co, n_secu, n_prop_sec, n_id_amont, n_id_aval,n_suf,n_ur, ST_Force2D((ST_Dump(wkb_geometry)).geom) as geom
from tr21_in.nro
;

-- Précision du type de géométrie dans la table metis_livrable.nro
SELECT populate_geometry_columns('metis_livrable.nro'::regclass);

--- Schema : metis_livrable
-- Table: metis_livrable.zde
DROP TABLE IF EXISTS metis_livrable.zde;
CREATE TABLE metis_livrable.zde
(
  
  id_za character varying (20), --Numéro d'ordre unique 
  insee character varying (9) NOT NULL, --Code INSEE de la commune 
  communes character varying (5) NOT NULL,--Nom de la commune 
  nom_za text  NOT NULL,--Nom de la zone
  adductabil character varying (20) NOT NULL,--Type d'adductabilité    
  securisati character varying (20) NOT NULL,--Type de sécurisation
  r_adductab character varying  NOT NULL,--Type d'adductabilité 
  r_securisa character varying (20) NOT NULL,--Type de sécurisation 
  type_aero character varying (20) NOT NULL,
  geom geometry(Geometry,2154),
  CONSTRAINT zde_pkey PRIMARY KEY (id_za)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE metis_livrable.zde
  OWNER TO postgres;


-- Précision du type de géométrie dans la table metis_livrable.zde
SELECT populate_geometry_columns('metis_livrable.zde'::regclass);

-- Insertion dans la table metis_livrable.zde les entités de tr21_in.zde

INSERT INTO metis_livrable.zde (
id_za,insee, communes, nom_za,adductabil,securisati, r_adductab, r_securisa, type_aero, geom)
SELECT
id_za,insee, communes, nom_za,adductabil,securisati, r_adductab, r_securisa, type_aero_, wkb_geometry as geom
from tr21_in.zde
;

--- Précise le type de géométrie de la colonne geom
ALTER TABLE metis_livrable.zde
ADD CONSTRAINT enforce_geotype_geom
CHECK (geometrytype(geom) = 'MultiPolygon')
;


