/*Préparation des formulaires de pré-saisie - ADN L49*/

/* adn_l49_lists.sql */
/*PostGIS*/

/* Owner : METIS RESEAUX */
/* Author : Marine FAUCHER */
/* Rev. date : dd/mm/yyyy */

/* ********************************************************************
    Creation des tables qui vont accueillir les listes de valeurs
*********************************************************************** */

SET search_path TO adn_l49, formulaires;

DROP TABLE IF EXISTS l_id_opp CASCADE; 
DROP TABLE IF EXISTS l_lot CASCADE; -- table : rip2.adn_lots_geographiques, champ : lot
DROP TABLE IF EXISTS l_cdd CASCADE; -- table : rip2.adn_lots_geographiques, champ : cdd
DROP TABLE IF EXISTS l_id_prog CASCADE; -- table : rip2.adn_programmation, champ : pr
DROP TABLE IF EXISTS l_prog_dsp CASCADE; -- table : rip2.adn_programmation, champ : prog_dsp
DROP TABLE IF EXISTS l_id_nro CASCADE; -- table : rip2.adn_znro, champ : nro_ref
DROP TABLE IF EXISTS l_id_reseau CASCADE; 
DROP TABLE IF EXISTS l_insee CASCADE; -- table : administratif.communes, champ : codinsee
DROP TABLE IF EXISTS l_com_dep CASCADE; -- table : administratif.communes, champ : commune
DROP TABLE IF EXISTS l_statut CASCADE;
DROP TABLE IF EXISTS l_phase CASCADE;
DROP TABLE IF EXISTS l_emprise CASCADE;
DROP TABLE IF EXISTS l_nom CASCADE;
DROP TABLE IF EXISTS l_support CASCADE;
DROP TABLE IF EXISTS l_travaux CASCADE;
DROP TABLE IF EXISTS l_typ_reseau CASCADE;
DROP TABLE IF EXISTS l_debut_trvx CASCADE;


CREATE TABLE l_id_opp(code VARCHAR(15), libelle VARCHAR(254), definition VARCHAR(254), CONSTRAINT "l_id_opp_pk" PRIMARY KEY (code));
CREATE TABLE l_lot(code VARCHAR(1), libelle VARCHAR(254), definition VARCHAR(254), CONSTRAINT "l_lot_pk" PRIMARY KEY (code));
CREATE TABLE l_cdd(code VARCHAR(20), libelle VARCHAR(254), definition VARCHAR(254), CONSTRAINT "l_cdd_pk" PRIMARY KEY (code));
CREATE TABLE l_id_prog(code VARCHAR(6), libelle VARCHAR(254), definition VARCHAR(254), CONSTRAINT "l_id_prog_pk" PRIMARY KEY (code));
CREATE TABLE l_prog_dsp(code VARCHAR(10), libelle VARCHAR(254), definition VARCHAR(254), CONSTRAINT "l_prog_dsp_pk" PRIMARY KEY (code));
CREATE TABLE l_id_nro(code VARCHAR(15), libelle VARCHAR(254), definition VARCHAR(254), CONSTRAINT "l_id_nro_pk" PRIMARY KEY (code));
CREATE TABLE l_id_reseau(code VARCHAR(4), libelle VARCHAR(254), definition VARCHAR(254), CONSTRAINT "l_id_reseau_pk" PRIMARY KEY (code));
CREATE TABLE l_insee(code VARCHAR(5), libelle VARCHAR(254), definition VARCHAR(254), CONSTRAINT "l_insee_pk" PRIMARY KEY (code));
CREATE TABLE l_com_dep(code VARCHAR(254), libelle VARCHAR(254), definition VARCHAR(254), CONSTRAINT "l_com_dep_pk" PRIMARY KEY (code));
CREATE TABLE l_statut(code VARCHAR(15), libelle VARCHAR(254), definition VARCHAR(254), CONSTRAINT "l_statut_pk" PRIMARY KEY (code));
CREATE TABLE l_phase(code VARCHAR(20), libelle VARCHAR(254), definition VARCHAR(254), CONSTRAINT "l_phase_pk" PRIMARY KEY (code));
CREATE TABLE l_emprise(code VARCHAR(254), libelle VARCHAR(254), definition VARCHAR(254), CONSTRAINT "l_emprise_pk" PRIMARY KEY (code));
CREATE TABLE l_nom(code VARCHAR(254), libelle VARCHAR(254), definition VARCHAR(254), CONSTRAINT "l_nom_pk" PRIMARY KEY (code));
CREATE TABLE l_support(code VARCHAR(20), libelle VARCHAR(254), definition VARCHAR(254), CONSTRAINT "l_support_pk" PRIMARY KEY (code));
CREATE TABLE l_travaux(code VARCHAR(20), libelle VARCHAR(254), definition VARCHAR(254), CONSTRAINT "l_travaux_pk" PRIMARY KEY (code));
CREATE TABLE l_typ_reseau(code VARCHAR(20), libelle VARCHAR(254), definition VARCHAR(254), CONSTRAINT "l_typ_reseau_pk" PRIMARY KEY (code));
CREATE TABLE l_debut_trvx(code VARCHAR(15), libelle VARCHAR(254), definition VARCHAR(254), CONSTRAINT "l_debut_trvx_pk" PRIMARY KEY (code));


/* ********************************************************************
     Insertion des valeurs dans les listes
*********************************************************************** */


--SET search_path TO gracethd, public;


BEGIN;

INSERT INTO l_lot VALUES ('1','Xavier Richard', 'Numéro lot');
INSERT INTO l_lot VALUES ('2','Julien Boutin', 'Numéro lot');
INSERT INTO l_lot VALUES ('3','Yohan Dufaud', 'Numéro lot');
INSERT INTO l_lot VALUES ('4','Gregory Alberti', 'Numéro lot');

INSERT INTO l_cdd VALUES ('Xavier Richard','1', 'Responsable lot');
INSERT INTO l_cdd VALUES ('Julien Boutin','2', 'Responsable lot');
INSERT INTO l_cdd VALUES ('Yohan Dufaud','3', 'Responsable lot');
INSERT INTO l_cdd VALUES ('Gregory Alberti','4', 'Responsable lot');

INSERT INTO l_id_nro VALUES ('LT_26292_WAOV','LT_26292_WAOV', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07269_WLAM','LT_07269_WLAM', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07236_WFLC','LT_07236_WFLC', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26215_MTCH','LT_26215_MTCH', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07334_VANS','LT_07334_VANS', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07011_ANVO','LT_07011_ANVO', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07080_DVES','LT_07080_DVES', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07330_VPAR','LT_07330_VPAR', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07129_LMAS','LT_07129_LMAS', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07275_WMNY','LT_07275_WMNY', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26307_WJRY','LT_26307_WJRY', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07071_CCON','LT_07071_CCON', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07128_LALO','LT_07128_LALO', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26338_SZET','LT_26338_SZET', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26035_BFSG','LT_26035_BFSG', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07346_VVRS','LT_07346_VVRS', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26056_BDEX','LT_26056_BDEX', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07005_ALRO','LT_07005_ALRO', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07176_PLZL','LT_07176_PLZL', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26063_BISB','LT_26063_BISB', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26321_WNDS','LT_26321_WNDS', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26329_WSGV','LT_26329_WSGV', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26168_LLCH','LT_26168_LLCH', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07341_VBRG','LT_07341_VBRG', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26001_AXDI','LT_26001_AXDI', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_48086_LUHA','LT_48086_LUHA', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07113_BSVR','LT_07113_BSVR', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26086_CDIO','LT_26086_CDIO', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07024_BANN','LT_07024_BANN', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07068_CBJN','LT_07068_CBJN', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07291_WRMZ','LT_07291_WRMZ', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07051_CPAG','LT_07051_CPAG', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26220_NYN1','LT_26220_NYN1', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07064_CHYR','LT_07064_CHYR', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07090_FLVC','LT_07090_FLVC', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07292_WRAY','LT_07292_WRAY', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26173_MCHE','LT_26173_MCHE', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26078_CRLS','LT_26078_CRLS', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07191_RCMR','LT_07191_RCMR', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26345_SZRS','LT_26345_SZRS', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26113_DIIE','LT_26113_DIIE', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26289_SLAN','LT_26289_SLAN', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07232_WELG','LT_07232_WELG', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26112_CURN','LT_26112_CURN', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26114_DLFT','LT_26114_DLFT', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07086_ETBL','LT_07086_ETBL', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07224_WCGM','LT_07224_WCGM', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07066_CRM1','LT_07066_CRM1', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07181_POUZ','LT_07181_POUZ', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07204_WAGV','LT_07204_WAGV', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26235_PRLT','LT_26235_PRLT', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26330_WSVL','LT_26330_WSVL', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07167_OLLI','LT_07167_OLLI', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26333_WVAL','LT_26333_WVAL', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26108_CRS2','LT_26108_CRS2', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26108_CRS1','LT_26108_CRS1', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26124_ETIL','LT_26124_ETIL', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07329_VLGR','LT_07329_VLGR', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07019_ABE1','LT_07019_ABE1', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07349_VLTE','LT_07349_VLTE', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07281_WPAY','LT_07281_WPAY', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07137_LVAT','LT_07137_LVAT', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26232_PYRU','LT_26232_PYRU', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26148_HTRV','LT_26148_HTRV', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07042_BGAD','LT_07042_BGAD', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07156_MYR1','LT_07156_MYR1', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26299_WCRX','LT_26299_WCRX', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07193_RCHR','LT_07193_RCHR', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26172_MNTH','LT_26172_MNTH', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26146_GGAN','LT_26146_GGAN', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26348_TLGN','LT_26348_TLGN', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26116_DZER','LT_26116_DZER', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07235_WEUL','LT_07235_WEUL', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26188_MOVZ','LT_26188_MOVZ', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26193_XBLB','LT_26193_XBLB', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26360_VLRI','LT_26360_VLRI', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26324_WPTC','LT_26324_WPTC', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26332_WUZE','LT_26332_WUZE', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26381_JLAN','LT_26381_JLAN', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07007_ALSR','LT_07007_ALSR', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26167_LCDI','LT_26167_LCDI', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07324_TRN1','LT_07324_TRN1', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26084_CISR','LT_26084_CISR', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_05097_ORPI','LT_05097_ORPI', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26006_ALLX','LT_26006_ALLX', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26264_RMZT','LT_26264_RMZT', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07215_WBTM','LT_07215_WBTM', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07247_WJCT','LT_07247_WJCT', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07322_THYE','LT_07322_THYE', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26347_TAI1','LT_26347_TAI1', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07348_VGUE','LT_07348_VGUE', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07338_VNVV','LT_07338_VNVV', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07340_VEYR','LT_07340_VEYR', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26368_VRCH','LT_26368_VRCH', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07319_TEIL','LT_07319_TEIL', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26174_MRGS','LT_26174_MRGS', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07201_RUMS','LT_07201_RUMS', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07259_WJST','LT_07259_WJST', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26074_CPVR','LT_26074_CPVR', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07267_WMTL','LT_07267_WMTL', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26315_WMVE','LT_26315_WMVE', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07253_WJGU','LT_07253_WJGU', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26301_WDHB','LT_26301_WDHB', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26165_LVON','LT_26165_LVON', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26216_MGLR','LT_26216_MGLR', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07231_WEFB','LT_07231_WEFB', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07107_JAUJ','LT_07107_JAUJ', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26369_VCLA','LT_26369_VCLA', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07138_LVDI','LT_07138_LVDI', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07158_MEZI','LT_07158_MEZI', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26340_SDRN','LT_26340_SDRN', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07055_CHSR','LT_07055_CHSR', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07331_VALS','LT_07331_VALS', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26212_XVND','LT_26212_XVND', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26166_LORI','LT_26166_LORI', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07110_JYES','LT_07110_JYES', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26040_BRIR','LT_26040_BRIR', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07266_WMGR','LT_07266_WMGR', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_26325_WRBA','LT_26325_WRBA', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07089_FLNS','LT_07089_FLNS', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07132_LAR1','LT_07132_LAR1', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07286_WPEV','LT_07286_WPEV', 'Référence NRO');
INSERT INTO l_id_nro VALUES ('LT_07339_VSSX','LT_07339_VSSX', 'Référence NRO');

INSERT INTO l_id_reseau VALUES ('R001','R001', 'Identifiant réseau');

INSERT INTO l_statut VALUES ('A étudier','Coordination à étudier', 'Statut de la coordination');
INSERT INTO l_statut VALUES ('Abandonnée','Coordination abandonnée', 'Coordination abandonnée');
INSERT INTO l_statut VALUES ('Diag','Coordination en phase diagnostic', 'Coordination en phase diagnostic');
INSERT INTO l_statut VALUES ('Opportunité','Coordination en phase opportunité', 'Coordination en phase opportunité');
INSERT INTO l_statut VALUES ('Pro','Coordination en phase pro', 'Coordination en phase pro');

INSERT INTO l_phase VALUES ('Numérisation','Etape de numérisation', 'Etape de numérisation');

INSERT INTO l_support VALUES ('Aerien FT','Support de réseau en aerien FT', 'Support  de réseau en aerien FT');
INSERT INTO l_support VALUES ('Aerien BT','Support de réseau en aerien BT', 'Support de réseau en aerien BT');
INSERT INTO l_support VALUES ('Assainissement','Support de réseau en  assainissement', 'Support de réseau en  assainissement');
INSERT INTO l_support VALUES ('Autre','Support indéterminé', 'Support indéterminé');
INSERT INTO l_support VALUES ('Conduite FT','Support de réseau en conduite FT', 'Support de réseau en conduite FT');
INSERT INTO l_support VALUES ('HTA','Support de réseau en HTA', 'Support de réseau en HTA');
INSERT INTO l_support VALUES ('Refection de voirie','Support de réseau en refection de voirie', 'Support de réseau en refection de voirie');
INSERT INTO l_support VALUES ('GC a creer','Support de réseau en GC a creer', 'Support de réseau en GC a creer');
INSERT INTO l_support VALUES ('Raccordement final','Support de réseau en raccordement final', 'Support de réseau en raccordement final');
INSERT INTO l_support VALUES ('ADN','Support de réseau ADN', 'Support de réseau ADN');

INSERT INTO l_travaux VALUES ('Assainissement','Travaux d''assainissement', 'Travaux d''assainissement');
INSERT INTO l_travaux VALUES ('Eau potable','Travaux d''eau potable', 'Travaux d''eau potable');
INSERT INTO l_travaux VALUES ('Enfouissement BT','Travaux d''enfouissement BT', 'Travaux d''enfouissement BT');
INSERT INTO l_travaux VALUES ('Enfouissement HTA','Travaux d''enfouissement HTA', 'Travaux d''enfouissement HTA');
INSERT INTO l_travaux VALUES ('Refection de voirie','Travaux de refection de voirie', 'Travaux de refection de voirie');
INSERT INTO l_travaux VALUES ('Travaux Telecom','Travaux Telecom', 'Travaux Telecom');
INSERT INTO l_travaux VALUES ('Travaux gaz','Travaux de gaz', 'Travaux de gaz');

INSERT INTO l_typ_reseau VALUES ('Desserte','Réseau de desserte', 'Réseau de desserte');
INSERT INTO l_typ_reseau VALUES ('Transport','Réseau de transport', 'Réseau de transport');

INSERT INTO l_debut_trvx VALUES ('Automne 2017','Travaux prévus en automne 2017', 'Travaux prévus en automne 2017');
INSERT INTO l_debut_trvx VALUES ('Automne 2018','Travaux prévus en automne 2018', 'Travaux prévus en automne 2018');
INSERT INTO l_debut_trvx VALUES ('Automne 2019','Travaux prévus en automne 2019', 'Travaux prévus en automne 2019');
INSERT INTO l_debut_trvx VALUES ('Automne 2020','Travaux prévus en automne 2020', 'Travaux prévus en automne 2020');
INSERT INTO l_debut_trvx VALUES ('Automne 2021','Travaux prévus en automne 2021', 'Travaux prévus en automne 2021');
INSERT INTO l_debut_trvx VALUES ('Automne 2022','Travaux prévus en automne 2022', 'Travaux prévus en automne 2022');
INSERT INTO l_debut_trvx VALUES ('Ete 2018','Travaux prévus en ete 2018', 'Travaux prévus en ete 2018');
INSERT INTO l_debut_trvx VALUES ('Ete 2019','Travaux prévus en ete 2019', 'Travaux prévus en ete 2019');
INSERT INTO l_debut_trvx VALUES ('Ete 2020','Travaux prévus en ete 2020', 'Travaux prévus en ete 2020');
INSERT INTO l_debut_trvx VALUES ('Ete 2021','Travaux prévus en ete 2021', 'Travaux prévus en ete 2021');
INSERT INTO l_debut_trvx VALUES ('Ete 2022','Travaux prévus en ete 2022', 'Travaux prévus en ete 2022');
INSERT INTO l_debut_trvx VALUES ('Hiver 2018','Travaux prévus en hiver 2018', 'Travaux prévus en hiver 2018');
INSERT INTO l_debut_trvx VALUES ('Hiver 2019','Travaux prévus en hiver 2019', 'Travaux prévus en hiver 2019');
INSERT INTO l_debut_trvx VALUES ('Hiver 2020','Travaux prévus en hiver 2020', 'Travaux prévus en hiver 2020');
INSERT INTO l_debut_trvx VALUES ('Hiver 2021','Travaux prévus en hiver 2021', 'Travaux prévus en hiver 2021');
INSERT INTO l_debut_trvx VALUES ('Hiver 2022','Travaux prévus en hiver 2022', 'Travaux prévus en hiver 2022');
INSERT INTO l_debut_trvx VALUES ('Printemps 2018','Travaux prévus au printemps 2018', 'Travaux prévus au printemps 2018');
INSERT INTO l_debut_trvx VALUES ('Printemps 2019','Travaux prévus au printemps 2019', 'Travaux prévus au printemps 2019');
INSERT INTO l_debut_trvx VALUES ('Printemps 2020','Travaux prévus au printemps 2020', 'Travaux prévus au printemps 2020');
INSERT INTO l_debut_trvx VALUES ('Printemps 2021','Travaux prévus au printemps 2021', 'Travaux prévus au printemps 2021');
INSERT INTO l_debut_trvx VALUES ('Printemps 2022','Travaux prévus au printemps 2022', 'Travaux prévus au printemps 2022');
INSERT INTO l_debut_trvx VALUES ('Inconnu','Date inconnue', 'Date inconnue');

COMMIT;




