/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 22/06/2018
Objet : Mise à jour de t_adresse en updates (mode dégradé)
Modification : Nom : ///// - Date : date_de_modif - Motif/nature : //////

Champs mis à jour :
- ad_code
- ad_ban_id
- ad_numero
- ad_rep
- ad_nblhab
- ad_nblpro
- ad_isole
- ad_nomvoie
- ad_racc
- ad_nombat
- ad_comment
- ad_creadat
- ad_nom_ld
- ad_fantoir
- x
- y
- ad_x_ban
- ad_y_ban
- ad_commune
- ad_insee
- nom_sro
- ad_postal
- ad_idpar
- ad_x_parc
- ad_y_parc
- nom_id
- ad_itypeim
- ad_imneuf
- statut
- ad_nbprpro
- ad_nbprhab
- potentiel_ftte
- nb_prises_totale
- nom_pro
- geom
-------------------------------------------------------------------------------------
*/

------=============================================================------
------= ETAPE 1 : INSERTION DES CHAMPS EN COMMUN DE BAL A ADRESSE =------
------=============================================================------
	
INSERT INTO rbal.t_adresse ( 
	ad_code,
	ad_ban_id, 
	ad_numero, 
	ad_rep, 
	ad_nblhab, 
	ad_nblpro, 
	ad_racc, 
	ad_nombat, 
	ad_comment, 
	ad_creadat, 
	geom
)
SELECT
	ad_code,
	ad_ban_id, 
	ad_numero, 
	ad_rep,  
	ad_nblhab, 
	ad_nblpro, 
	ad_racc, 
	ad_nombat, 
	ad_comment, 
	ad_creadat, 
	geom
FROM rbal.bal_hsn_point_2154

;

------=============================================================------
------= ETAPE 2 : MISES A JOUR DES CHAMPS DE LA TABLE ADRESSE =------

/*
-------------------------------------------------------------------------
4 SCENARIOS:

1)- MAJ de t_adresse avec la BAN
2)- MAJ de t_adresse sans la BAN=> MAJ avec locaux HSN
3)- MAJ de t_adresse sans la BAN/locaux HSN==> MAJ avec les voies du PCI
4)- MAJ de t_adresse sans la BAN/locaux/voies du PCI ==> MAJ avec les noeuds (saisie manuelle depuis google streets)
-------------------------------------------------------------------------
*/
------=============================================================------

--UPDATE rbal.t_adresse a
--SET ad_seq =  concat('AD700',rownum, digt_6, digt_7, nextval_special()) 
--FROM (SELECT t_adresse.*,  ROW_NUMBER() OVER() as rownum
--FROM rbal.t_adresse as t_adresse) t_adresse, psd_orange.ref_code_zasro
--WHERE t_adresse.ad_code = a.ad_code AND a.nom_sro = code_sro_initial;

--- Schema : rbal
--- Table : t_adresse
--- Traitement : MAJ ad_ban_id

UPDATE rbal.t_adresse a
SET    ad_ban_id=id_ban
FROM   rbal.liaison_hsn_linestring_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.1) ;


/*
-------------------------------------------------------------------------
ad_nomvoie

4 SCENARIOS:

1)- MAJ de t_adresse avec la BAN
2)- MAJ de t_adresse sans la BAN=> MAJ avec locaux HSN
3)- MAJ de t_adresse sans la BAN/locaux HSN==> MAJ avec les voies du PCI
4)- MAJ de t_adresse sans la BAN/locaux/voies du PCI ==> MAJ avec les noeuds (saisie manuelle depuis google streets)
-------------------------------------------------------------------------
*/

--- Schema : rbal
--- Table : t_adresse
--- Traitement : MAJ ad_nomvoie (sc1)
UPDATE rbal.t_adresse b
SET    ad_nomvoie=nom_voie
FROM   ban.hsn_point_2154 a
WHERE  b.ad_ban_id = a.id;

--- Schema : rbal
--- Table : t_adresse
--- Traitement : MAJ ad_nomvoie (sc2)
UPDATE rbal.t_adresse b
SET    ad_nomvoie=voie
FROM   rbal.v_bal_idbanout_idlocauxin_voie a, rbal.liaison_hsn_linestring_2154 c 
WHERE  ST_DWithin(a.geom, c.geom, 0.001) and cast(a.id as varchar)=b.nom_id AND ad_ban_id IS NULL ;

--- Schema : rbal
--- Table : t_adresse
--- Traitement : MAJ ad_nomvoie (sc3)
UPDATE rbal.t_adresse b
SET    ad_nomvoie=nomvoie
FROM   rbal.liaison_voie_hsn_linestring_2154 a
WHERE  ST_DWithin(a.geom, b.geom, 0.001) and ad_ban_id IS NULL;

--- Schema : rbal
--- Table : t_adresse
--- Traitement : MAJ ad_nomvoie (sc4)
UPDATE rbal.t_adresse b
SET    ad_nomvoie=nomvoie
FROM   rbal.liaison_voie_sanspci_hsn_linestring_2154 a
WHERE  ST_DWithin(a.geom, b.geom, 0.001) and ad_ban_id IS NULL;


--- Schema : rbal
--- Table : t_adresse
--- Traitement : MAJ ad_fantoir 
UPDATE rbal.t_adresse b
SET    ad_fantoir=id_fantoir
FROM   ban.hsn_point_2154 a
WHERE  ad_ban_id=id;

/*
-------------------------------------------------------------------------
ad_nomvoie

2 SCENARIOS:

1)- MAJ de t_adresse avec la BAN
2)- MAJ de t_adresse sans la BAN=> MAJ avec bal
-------------------------------------------------------------------------
*/
--- Schema : rbal
--- Table : t_adresse
--- Traitement : MAJ ad_nomvoie (sc1)
UPDATE rbal.t_adresse b
SET    ad_numero=cast(numero as integer)
FROM   ban.hsn_point_2154 a
WHERE  ad_ban_id=id;

--- Schema : rbal
--- Table : t_adresse
--- Traitement : MAJ ad_nomvoie (sc2)
UPDATE rbal.t_adresse b
SET    ad_numero=cast(a.ad_numero as integer)
FROM   rbal.bal_hsn_point_2154 a
WHERE  a.ad_code=cast(b.ad_code as integer) AND b.ad_numero IS NULL;

/*
-------------------------------------------------------------------------
ad_rep

2 SCENARIOS:

1)- MAJ de t_adresse avec la BAN
2)- MAJ de t_adresse sans la BAN=> MAJ avec bal
-------------------------------------------------------------------------
*/

--- Schema : rbal
--- Table : t_adresse
--- Traitement : MAJ ad_nomvoie (sc1)
UPDATE rbal.t_adresse b
SET    ad_rep=rep
FROM   ban.hsn_point_2154 a
WHERE  ad_ban_id=id;

--- Schema : rbal
--- Table : t_adresse
--- Traitement : MAJ ad_nomvoie (sc2)
UPDATE rbal.t_adresse b
SET    ad_rep=a.ad_rep
FROM   rbal.bal_hsn_point_2154 a
WHERE  a.ad_code=cast(b.ad_code as integer) AND b.ad_rep IS NULL;

--- Schema : rbal
--- Table : t_adresse
--- Traitement : MAJ ad_insee 
UPDATE rbal.t_adresse b
SET    ad_insee=insee
FROM   osm.communes_hsn_multipolygon_2154 a
WHERE  ST_CONTAINS (a.geom, b.geom) ;

--- Schema : rbal
--- Table : t_adresse
--- Traitement : MAJ ad_postal
UPDATE rbal.t_adresse b
SET    ad_postal=code_postal
FROM   la_poste.codcom_codpost_correspondance_hsn_2017 a
WHERE  ad_insee=code_commune_insee;

/*
-------------------------------------------------------------------------
ad_nom_ld

3 SCENARIOS:

1)- MAJ de t_adresse avec la BAN
2)- MAJ de t_adresse sans la BAN=> MAJ avec les voies du PCI
3)- MAJ de t_adresse sans la BAN/voies du PCI ==> MAJ avec les noeuds (saisie manuelle depuis google streets)
-------------------------------------------------------------------------
*/

--- Schema : rbal
--- Table : t_adresse
--- Traitement : MAJ ad_nom_ld (sc1)
UPDATE rbal.t_adresse b
SET    ad_nom_ld=nom_ld
FROM   ban.hsn_point_2154 a
WHERE  ad_ban_id=id;

--- Schema : rbal
--- Table : t_adresse
--- Traitement : MAJ ad_nom_ld (sc2)
UPDATE rbal.t_adresse b
SET    ad_nom_ld=tex
FROM   pci70_edigeo_majic.geo_lieudit a
WHERE  ST_CONTAINS(a.geom, b.geom) and ad_nomvoie IS NULL ;

--- Schema : rbal
--- Table : t_adresse
--- Traitement : MAJ ad_nom_ld (sc3)
UPDATE rbal.t_adresse b
SET    ad_nom_ld=lieu_dit
FROM   rbal.liaison_voie_sanspci_hsn_linestring_2154 a
WHERE  ST_DWithin(a.geom, b.geom, 0.001) and ad_ban_id IS NULL AND ad_nom_ld IS NULL ;

--- Schema : rbal
--- Table : t_adresse
--- Traitement : MAJ ad_x_ban 
UPDATE rbal.t_adresse b
SET    ad_x_ban=st_x(a.geom)
FROM   ban.hsn_point_2154 a
WHERE  ad_ban_id=id;

--- Schema : rbal
--- Table : t_adresse
--- Traitement : MAJ ad_y_ban 
UPDATE rbal.t_adresse b
SET    ad_y_ban=st_y(a.geom)
FROM   ban.hsn_point_2154 a
WHERE  ad_ban_id=id;

--- Schema : rbal
--- Table : t_adresse
--- Traitement : MAJ ad_commune 
UPDATE rbal.t_adresse b
SET    ad_commune=nom
FROM   osm.communes_hsn_multipolygon_2154 a
WHERE  ST_CONTAINS (a.geom, b.geom) ;

--- Schema : rbal
--- Table : t_adresse
--- Traitement : MAJ ad_idpar 
UPDATE rbal.t_adresse b
SET    ad_idpar=geo_parcelle
FROM   pci70_edigeo_majic.geo_parcelle a
WHERE  ST_CONTAINS (a.geom, b.geom);

--- Schema : rbal
--- Table : t_adresse
--- Traitement : MAJ ad_x_parc 
UPDATE rbal.t_adresse b
SET    ad_x_parc=st_x((st_centroid(b.geom)))
FROM   pci70_edigeo_majic.geo_parcelle a
WHERE  ST_CONTAINS (a.geom, b.geom);

--- Schema : rbal
--- Table : t_adresse
--- Traitement : MAJ ad_y_parc
UPDATE rbal.t_adresse b
SET    ad_y_parc=st_y((st_centroid(b.geom)))
FROM   pci70_edigeo_majic.geo_parcelle a
WHERE  ST_CONTAINS (a.geom, b.geom);

--- Schema : rbal
--- Table : t_adresse
--- Traitement : MAJ ad_nbprhab
UPDATE rbal.t_adresse a
SET ad_nbprhab=CASE WHEN ad_nblhab IS NOT NULL THEN ad_nblhab ELSE 0 END;

--- Schema : rbal
--- Table : t_adresse
--- Traitement : MAJ ad_nbprpro

UPDATE rbal.t_adresse a
SET ad_nbprpro=0;

UPDATE rbal.t_adresse a
SET ad_nbprpro=nb_ftth
FROM  rbal.v_bal_hsn_point_2154_ftth_ftte b
WHERE a.ad_code=cast(b.ad_code as varchar);

--- Schema : rbal
--- Table : t_adresse
--- Traitement : MAJ ad_isole
UPDATE rbal.t_adresse a
SET    ad_isole=TRUE
FROM   rbal.racco_hsn_linestring_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.1) AND ST_LENGTH (b.geom) >= 150;

--- Schema : rbal
--- Table : t_adresse
--- Traitement : MAJ ad_itypeim
UPDATE rbal.t_adresse a
SET    ad_itypeim=
CASE WHEN (ad_nblhab+ad_nblpro)>=3 THEN 'I' ELSE 'P' END;

--- Schema : rbal
--- Table : t_adresse
--- Traitement : MAJ ad_imneuf
UPDATE rbal.t_adresse a
SET    ad_imneuf=
CASE WHEN b.construction ='En construction' THEN TRUE ELSE NULL END
FROM rbal.bal_hsn_point_2154 as b 
WHERE a.ad_code= cast(b.ad_code as varchar);

--- Schema : rbal
--- Table : t_adresse
--- Traitement : MAJ nom_sro (complément)
UPDATE rbal.t_adresse b
SET    nom_sro=za_code
FROM   psd_orange.zpm_hsn_polygon_2154 a
WHERE  ST_CONTAINS (a.geom, b.geom) ;

--- Schema : rbal
--- Table : t_adresse
--- Traitement : MAJ nb_prises_totale (complément)
UPDATE rbal.t_adresse a
SET nb_prises_totale=ad_nbprhab+ad_nbprpro;

/*
-------------------------------------------------------------------------
statut (complément)

4 CAS:

1)- Quand construction = 'En construction' alors 'N'
2)- Quand destruction = 'Supprimé'' alors 'S'
3)- Quand la liaison existe alors 'E'
4)- Sinon 'C' (A créer)
-------------------------------------------------------------------------
*/

--- Schema : rbal
--- Table : t_adresse
--- Traitement : MAJ statut
UPDATE rbal.t_adresse a
SET statut=
CASE WHEN construction LIKE 'En construction' THEN 'N'
WHEN destruction LIKE  'Supprimé' THEN 'S' 
ELSE 'C' END
FROM rbal.bal_hsn_point_2154 b
WHERE a.ad_code= cast(b.ad_code as varchar);

--- Schema : rbal
--- Table : t_adresse
--- Traitement : MAJ statut
UPDATE rbal.t_adresse a
SET statut=  
CASE WHEN EXISTS (SELECT distinct on (liaison_id) liaison_id
				  FROM rbal.liaison_hsn_linestring_2154 c ) THEN 'E' END
FROM rbal.liaison_hsn_linestring_2154 b 
WHERE a.nom_id=cast(b.id_locaux as varchar);

--- Schema : rbal
--- Table : t_adresse
--- Traitement : MAJ nom_id (complément)
UPDATE rbal.t_adresse a
SET    nom_id=id_locaux
FROM   rbal.liaison_hsn_linestring_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.1) ;

--- Schema : rbal
--- Table : t_adresse
--- Traitement : MAJ nom_pro (complément)
UPDATE rbal.t_adresse a
SET nom_pro=b.nom_pro
FROM  rbal.v_bal_hsn_point_2154_ftth_ftte b
WHERE a.ad_code=cast(b.ad_code as varchar);

--- Schema : rbal
--- Table : t_adresse
--- Traitement : MAJ x (complément)
UPDATE rbal.t_adresse b
SET    x=st_x(geom);

--- Schema : rbal
--- Table : t_adresse
--- Traitement : MAJ y (complément)
UPDATE rbal.t_adresse b
SET    y=st_y(geom);

--- Schema : rbal
--- Table : t_adresse
--- Traitement : MAJ potentiel_ftte (complément)
UPDATE rbal.t_adresse a
SET potentiel_ftte=nb_ftte
FROM  rbal.v_bal_hsn_point_2154_ftth_ftte b
WHERE a.ad_code=cast(b.ad_code as varchar);


--UPDATE rbal.t_adresse b
--SET    ad_numero=cast("n°_dans_la" as integer)
--FROM   rbal.v_bal_idbanout_idlocauxin_voie a, rbal.liaison_hsn_linestring_2154 c 
--WHERE  ST_DWithin(a.geom, c.geom, 0.001) and cast(a.id as varchar)=b.nom_id AND ad_ban_id IS NULL ;

------==========================================================================------
------= ETAPE 3 : CREATION DE LA SEQUENCE UNIQUE ad_code et MAJ DANS t_adresse =------
/*
-------------------------------------------------------------------------
ad_code : XX DD G NS NNNNNNN

où

XX : Classe de l’objet (par exemple AD pour la table adresse)

DD : code du département (ici 70 pour HSN)

G : Identifiant du créateur de l’objet => 0 pour le Bureau d’Etudes ARTELIA / METIS

N : identifiant de A à Z pour le NRO (par exemple B pour le NRO N070GAY)

S : identifiant de A à Z pour le SRO (par exemple I pour le SRO N070GAY_S03I) ou le chiffre 0 pour les objets liés au Transport (car un cheminement transport est propre à un NRO et pas à un SRO)

NNNNNNN : nombre incrémental – Libre : le groupement choisi librement son choix (par exemple 000001 pour la première entité d’une table)

Soit le code ‘AD700TBI000001’ pour le premier objet de la t_adresse (en supposant qu’il se trouve dans la zone du SRO N070GAY_S03I)
-------------------------------------------------------------------------
*/
------==========================================================================------
	

DROP SEQUENCE IF EXISTS rbal.t_adresse_incrementation_ad_code_n1;
CREATE SEQUENCE rbal.t_adresse_incrementation_ad_code_n1
  INCREMENT 1
  MINVALUE 000000000
  MAXVALUE 999999999
  START 1
  CACHE 1;
ALTER TABLE rbal.t_adresse OWNER TO postgres;

CREATE OR REPLACE FUNCTION
nextval_special()
RETURNS TEXT
LANGUAGE sql
AS
$$
    SELECT to_char(nextval('rbal.t_adresse_incrementation_ad_code_n1'), 'FM000000000'); 
$$;


UPDATE rbal.t_adresse
SET ad_seq = concat('AD700', digt_6, digt_7, nextval_special())
FROM psd_orange.ref_code_zasro
WHERE nom_sro = code_sro_initial;

------======================================================================------
------= ETAPE 4 : INSERTION DE rbal.t_adresse DANS gracethd_metis.t_adresse=------
------======================================================================------

INSERT INTO gracethd_metis.t_adresse ( 
	ad_code, 
	ad_ban_id, 
	ad_nomvoie, 
	ad_fantoir, 
	ad_numero, 
	ad_rep, 
	ad_insee, 
	ad_postal, 
	ad_alias, 
	ad_nom_ld, 
	ad_x_ban, 
	ad_y_ban, 
	ad_commune, 
	ad_section, 
	ad_idpar, 
	ad_x_parc, 
	ad_y_parc, 
	ad_nat, 
	ad_nblhab, 
	ad_nblpro, 
	ad_nbprhab, 
	ad_nbprpro, 
	ad_rivoli, 
	ad_hexacle, 
	ad_hexaclv, 
	ad_distinf, 
	ad_isole, 
	ad_prio, 
	ad_racc, 
	ad_batcode, 
	ad_nombat, 
	ad_ietat, 
	ad_itypeim, 
	ad_imneuf, 
	ad_idatimn, 
	ad_prop, 
	ad_gest, 
	ad_idatsgn, 
	ad_iaccgst, 
	ad_idatcab, 
	ad_idatcom, 
	ad_typzone, 
	ad_comment, 
	ad_geolqlt, 
	ad_geolmod, 
	ad_geolsrc, 
	ad_creadat, 
	ad_majdate, 
	ad_majsrc, 
	ad_abddate, 
	ad_abdsrc, 
	nom_sro, 
	nb_prises_totale, 
	statut, 
	cas_particuliers,
	nom_id, 
	nom_pro, 
	x, 
	y, 
	potentiel_ftte, 
	geom
)
SELECT
	ad_seq, 
	ad_ban_id, 
	ad_nomvoie, 
	ad_fantoir, 
	ad_numero, 
	ad_rep, 
	ad_insee, 
	ad_postal, 
	ad_alias, 
	ad_nom_ld, 
	ad_x_ban, 
	ad_y_ban, 
	ad_commune, 
	ad_section, 
	ad_idpar, 
	ad_x_parc, 
	ad_y_parc, 
	ad_nat, 
	ad_nblhab, 
	ad_nblpro, 
	ad_nbprhab, 
	ad_nbprpro, 
	ad_rivoli, 
	ad_hexacle, 
	ad_hexaclv, 
	ad_distinf, 
	ad_isole, 
	ad_prio, 
	ad_racc, 
	ad_batcode, 
	ad_nombat, 
	ad_ietat, 
	ad_itypeim, 
	ad_imneuf, 
	ad_idatimn, 
	ad_prop, 
	ad_gest, 
	ad_idatsgn, 
	ad_iaccgst, 
	ad_idatcab, 
	ad_idatcom, 
	ad_typzone, 
	ad_comment, 
	ad_geolqlt, 
	ad_geolmod, 
	ad_geolsrc, 
	ad_creadat, 
	ad_majdate, 
	ad_majsrc, 
	ad_abddate, 
	ad_abdsrc, 
	nom_sro, 
	nb_prises_totale, 
	statut, 
	cas_particuliers,
	nom_id, 
	nom_pro, 
	x, 
	y, 
	potentiel_ftte, 
	geom
	FROM rbal.t_adresse;

;


------=========================================------
------= ETAPE 5 : CREATION DE LA VUE v_adresse=------
------=========================================------

CREATE OR REPLACE VIEW rbal.v_adresse AS
SELECT
nom_id, 
nom_sro,
ad_code,
ad_numero,
ad_rep,
ad_nomvoie,
ad_nom_ld,
ad_commune,
ad_postal,
ad_insee,
x,
y,
ad_fantoir,
ad_ban_id,
ad_x_ban, 
ad_y_ban, 
ad_idpar, 
ad_x_parc, 
ad_y_parc, 
ad_nombat,
ad_rivoli, 
ad_hexacle, 
ad_hexaclv, 
ad_nblhab, 
ad_nblpro, 
ad_nbprhab, 
ad_nbprpro, 	
nb_prises_totale, 
potentiel_ftte, 
ad_comment,
ad_racc, 
ad_itypeim, 
ad_imneuf, 
ad_idatimn, 
ad_prop, 
ad_gest, 
ad_idatsgn, 
ad_iaccgst, 
ad_isole, 
statut, 
cas_particuliers,	
ad_creadat, 
ad_majdate, 
ad_majsrc, 
ad_abddate, 
ad_abdsrc, 
nom_pro, 
ad_typzone, 
ad_geolqlt, 
ad_geolsrc
FROM gracethd_metis.t_adresse;


