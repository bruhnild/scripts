``` sql
COMMENT ON SCHEMA gotmi                              IS 'Modele de donnees de l''interface MET                                                              IS -MAPS, specifique a la composante GOTMI';

COMMENT ON TABLE utilisateur                         IS 'Informations liees au compte utilisateur';
COMMENT ON COLUMN utilisateur.id_utilisateur         IS 'Identifiant unique';
COMMENT ON COLUMN utilisateur.nom_utilisateur        IS 'Pseudonyme';
COMMENT ON COLUMN utilisateur.offre_utilisateur      IS 'Type de compte [BASIQUE ; PAYANT ; ADMIN ; ..?]';
COMMENT ON COLUMN utilisateur.organisme_utilisateur  IS 'Appartenance institutionnelle';
COMMENT ON COLUMN utilisateur.dep_utilisateur        IS 'Departement d''action';
COMMENT ON COLUMN utilisateur.maitrise_utilisateur   IS 'Role [OUVRAGE ; OEUVRE ; MANDATAIRE]';
COMMENT ON COLUMN utilisateur.de_droit_utilisateur   IS 'Statut juridique [PUBLIC ; PRIVE]';
COMMENT ON COLUMN utilisateur.creadate_utilisateur   IS 'Date de creation du compte';

COMMENT ON TABLE programme                           IS 'Laps dans lequel s''echelonnent un ensemble de chantiers';
COMMENT ON COLUMN programme.id_programme             IS 'Identifiant unique';
COMMENT ON COLUMN programme.nom_programme            IS 'Reference pour le tableau de suivi';
COMMENT ON COLUMN programme.debut_programme          IS 'Date declaree OU Plus ancienne debut_chantier';
COMMENT ON COLUMN programme.fin_programme            IS 'Date declaree OU Plus recente debut_chantier + duree_chantier';
COMMENT ON COLUMN programme.cout_estim_programme     IS 'Cout (€) declare OU Somme des cout_estim_chantier';
COMMENT ON COLUMN programme.creadate_programme       IS 'Date de creation du programme';
COMMENT ON COLUMN programme.geom_poly_programme      IS 'Union des bounding-box';
COMMENT ON COLUMN programme.id_utilisateur           IS 'Identifiant utilisateur';

COMMENT ON TABLE programme                           IS 'Laps dans lequel s''echelonnent un ensemble de chantiers';
COMMENT ON COLUMN opportunite.id_opportunite         IS 'Identifiant unique';
COMMENT ON COLUMN opportunite.statut_opportunite     IS 'Etat de l''opportunite [IDENTIFIEE ; QUALIFIEE ; ETUDIEE]';
COMMENT ON COLUMN opportunite.debut_opportunite      IS 'Etat de l''opportunite [IDENTIFIEE ; QUALIFIEE ; ETUDIEE]';
COMMENT ON COLUMN opportunite.fin_opportunite        IS 'Etat de l''opportunite [IDENTIFIEE ; QUALIFIEE ; ETUDIEE]';
COMMENT ON COLUMN opportunite.nb_suf_opportunite     IS 'Nombre de sites utilisateurs finaux';
COMMENT ON COLUMN opportunite.length_opportunite     IS 'Longeur de la geometrie';
COMMENT ON COLUMN opportunite.geom_point_opportunite IS 'Centroide de la bbox';
COMMENT ON COLUMN opportunite.geom_line_opportunite  IS 'Trace propose dans un premier temps par l''etude';

COMMENT ON TABLE chantier                            IS 'Projet de travaux de taille significative sur les reseaux aeriens ou souterrains de toute nature';
COMMENT ON COLUMN chantier.id_chantier               IS 'Identifiant unique';
COMMENT ON COLUMN chantier.moa_chantier              IS 'Maitre d''oeuvre';
COMMENT ON COLUMN chantier.debut_chantier            IS 'Date declaree dans le media';
COMMENT ON COLUMN chantier.fin_chantier              IS 'Date estimee';
COMMENT ON COLUMN chantier.cout_estim_chantier       IS 'Cout estime';
COMMENT ON COLUMN chantier.com_depart_chantier       IS 'Commune de depart';
COMMENT ON COLUMN chantier.cat_trav_chantier         IS 'Categorie des travaux [EAU ; GAZ ; ...]';
COMMENT ON COLUMN chantier.incertitude_chantier      IS 'Incertitude geographique lie au trace';
COMMENT ON COLUMN chantier.creadate_chantier         IS 'Date de creation de l''item';
COMMENT ON COLUMN chantier.geom_point_chantier       IS 'Point place par l''utilisateur sur la carte lors de la declaration';
COMMENT ON COLUMN chantier.geom_line_chantier        IS 'Geometrie consecutive a la numerisation';
COMMENT ON COLUMN chantier.id_programme              IS 'Cle etrangere';
COMMENT ON COLUMN chantier.id_media                  IS 'Cle etrangere';

COMMENT ON TABLE media                               IS 'Document envoye par l''utilisateur';
COMMENT ON COLUMN media.id_media                     IS 'Identifiant unique';
COMMENT ON COLUMN media.url_media                    IS 'Lien vers BDD';
COMMENT ON COLUMN media.phase_media                  IS '[AVP, PRO, ...]';
COMMENT ON COLUMN media.creadate_media               IS 'Date d''envoie du document';
COMMENT ON COLUMN media.qualite_media                IS 'Appreciation de la qualite du media par le numerisateur [ECHELLE, SOURCES, ...]';
COMMENT ON COLUMN media.valide_media                 IS 'Validation manuelle de la reception d''un media integre';
COMMENT ON COLUMN media.etat_num_media               IS 'Trigger de notification de fin de numerisation';

COMMENT ON TABLE concerner                           IS 'Table de correspondance';
COMMENT ON COLUMN concerner.id1_concerner            IS 'Identifiant du primo-declarant';
COMMENT ON COLUMN concerner.id2_concerner            IS 'Identifiant du secondo-declarant';

COMMENT ON TABLE rapport                             IS 'Informations servant la generation de rapport';
COMMENT ON COLUMN rapport.economie_rapport           IS 'Estimation calculee';
COMMENT ON COLUMN rapport.note_rapport               IS 'Evalution Metis';
COMMENT ON COLUMN rapport.url_rapport                IS 'Lien vers PDF';

COMMENT ON TABLE declencher IS 'Table de correspondance';
``` 