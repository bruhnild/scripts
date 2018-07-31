- [Glossaire](#glossaire)
- [Specs](#specs)
    + [Création de chantier](#création-de-chantier)
        + [Mode de création d'un chantier](#mode-de-création-d-un-chantier)
        + [Métadonnées à renseigner par chantier](#métadonnées-à-renseigner-par-chantier)
        + [Association du chantier à une entité](#association-du-chantier-à-une-entité)
        + [Validation du chantier](#validation-du-chantier)
    + [Symbologie](#symbologie)
        + [Elements à représenter](#elements-à-représenter)
        + [Modes de représentation](#modes-de-représentation)
    + [Zoom](#zoom)
        + [Afficher l'emprise globale de ma zone d'étude](#afficher-l-emprise-globale-de-ma-zone-d-étude)
        + [Définir des géosignets](#définir-des-géosignets)
        + [Retrouver la dernière emprise travaillée](#retrouver-la-dernière-emprise-travaillée)
    + [Menu fond de carte](#menu-fond-de-carte)
        + [Choisir un fond de plan cartographique](#choisir-un-fond-de-plan-cartographique)
    + [Menu sélection des couches](#menu-sélection-des-couches)
        + [Sélectionner des données dans les groupes](#sélectionner-des-données-dans-les-groupes)
    + [Recherche](#recherche)
        + [Effectuer une recherche](#effectuer-une-recherche)
    + [Dessin et annotation](#dessin-et-annotation)
        + [Dessiner et ajouter des notes](#dessiner-et-ajouter-des-notes)
    + [Impression de carte](#impression-de-carte)
        + [Exporter une carte en PNG/PDF](#exporter-une-carte-en-png-pdf)
        + [Exporter une capture d’écran](#exporter-une-capture-d'écran)

| Item                 | Fonctionnalité                   | Etat      |
|:---------------------|:---------------------------------|:----------|
| Accueil              | Lien vers des pages de connexion | A décrire |
| Accueil              | Lien vers site Metis             | A décrire |
| Accueil              | Présentation Metis-Map           | A décrire |
| Accueil              | Présentation produit L49         | A décrire |
| Accueil              | Contact                          | A décrire |
| Accueil              | Maquette                         | A décrire |
| Accueil              | Choix technologique              | A décrire |
| Gestion documentaire | Création de chantier             | Décrit    |
| Viewer               | Menu fond de carte               | Décrit    |
| Viewer               | Menu sélection des couches       | Décrit    |
| Viewer               | Style, symbologie                | Décrit    |
| Viewer               | Recherche                        | Décrit    |
| Viewer               | Edition/numérisation couche      | Décrit    |
| Viewer               | Couche de dessin/annotation      | Décrit    |
| Viewer               | Impression de carte              | Décrit    |
| Tableau de suivi     | Création du tableau de suivi     | A décrire |
| Tableau de suivi     | Centre de notification           | A décrire |

# Glossaire 
*Définitions à discuter*
>L'**utilisateur basique** peut définir un **programme** de **chantiers** correspondant chacun à une **couche** qui compile des **entités**. Ces dernières servent à la qualification d'une **opportunité**.

**Utilisateur basique** : compte gratuit avec un accès restreint aux fonctionnalités de la plateforme.

**Programme** : Laps défini par une date de départ et une durée, dans lequel peuvent s'échelonner des chantiers.

=> Le laps est fixé à un an par défault (non modifiable en compte basique)

=> Le programme sert le calcul d'opportunité

**Chantier** : Projet de travaux de taille significative sur les réseaux aériens ou souterrains de toute nature (150 m en agglomération et 1000 m hors agglomération). 

=> Chaque chantier correspond obligatoirement à une emprise spatiale et temporelle définie lors de sa déclaration sur l'interface.  

=> Une fois déterminée lors de sa création, elle n'est plus modifiable.

**Couche** : Une couche correspond à une `ol.layer` dans Openlayers

+ Option 1 : Un chantier/programme comprend plusieurs couches (sans compilation)

=> Les entités des couches correspondent aux différents fichiers chargés

+ Option 2 : Un programme correspond à une couche (avec compilation)

=> Les entités détectées dans les Shapefiles sont reportées dans la couche du chantier dans un format standardisé à définir.

**Entité** : Une entité correspond à une ligne sur la table attributaire de la couche.

=> Une entité ne peut avoir qu'un seul type géométrique parmi les trois géométries suivantes : le point, la ligne, le polygone. 

=> L'utilisateur ne rentre que des géométries linéaires.

**Opportunité** : Intersection spatiale -des chantiers- et temporelle -des programmes. L’objectif d'une opportunité est de réaliser une économie à la fois financière et dans le temps en cherchant à optimiser l’utilisation d’infrastructures existantes et projetées des maîtres d’ouvrages tiers. 

=> Couche calculée (manuellement dans un premier temps) après le chargement du programme et sert à l’édition  de  rapports d’opportunités. 

**Emprise spatiale** : La bounding box de la couche, c'est à dire le rectangle comprenant les x et y min et max.

# Specs

## Création de chantier

La création d'un chantier utilisateur doit permettre de :

- **Créer une entité** de chantier (par dépôt ou numérisation)
- **Associer des informations** spatiales, temporelles, attributaires

### Mode de création d'un chantier

- Option 1 : Simple bouton de création qui active, par ex. un pop-up (Modal dans Bootstrap)
- Option 2 : Bouton associé à une fonctionnalité de localisation manuelle du chantier sur la carte (POI ou ROI ?). *Cette option permettrait de récupérer automatiquement la zone administrative du chantier.*

La création d'un chantier doit générer un ensemble de métadonnées automatiques ou renseignés par l'utilisateur (cf. ci-dessous)

### Métadonnées à renseigner par chantier

- Type de réseau
    + Option 1 : Associer un compte utilisateur à une catégorie de réseau à définir 
    + Option 2 : Catégorie des travaux renseignées par l'utilisateur suite au clic sur le bouton création
- Date de début et de fin des travaux (*information obligatoire*)
- Module sources et médias associés (optionnels) comprenant :
    + Champ titre, associé au titre de la légende de la carte + titre de la couche
    + Champ text avec mise en forme minimale qui peut s'afficher sous la carte ou dans un module *info* dépliable.
    + Champ ajout de pièce jointe avec un lecteur intégré pour les fichiers PDF
    + Zone administrative chargée automatiquement (cf ci-dessus)
    + Budget prévisionnel du chantier (?) *Permettrait de calculer une estimation des économies à réaliser. Peut aussi être estimé par la longeur de la entité rapporté au type de réseau*
- Zone administrative du chantier, granularité à définir (commune, EPCI, département...) *Permettrait un affichage différent en fonction de l'échelle cartographique et éventuellement une carte statistique en accueil*

### Association du chantier à une entité

- Option 1 : Chargement d'un fichier de données spatiales

=> Prévoir un ensemble de tests d'intégrité du fichier chargé :
    + Reprojection automatique en 2154 (ou 3857?)
    + Vérification du type de entité (que linéaire en entrée ?)
    + Compte des entités non null
    + Autres tests à prévoir ?

- Option 2 : Numérisation du tracé par l'utilisateur (en cas d'absence de données spatiales ou fichier invalide)

*L'interface devrait proposer les deux options afin de déléguer le travail de numérisation à l'utilisateur*

- Spécification du degré d'incertitude du chantier, par ex. avec un slider pour déterminer une fouchette de précision. Le degré d'incertitude peut ensuite créer un buffer autour de l'entité afin d'identifier plus efficacement les opportunités.
- En cas d'absence de fichier géom et d'absence de numérisation, la couche apparait grisée dans le menu des couches

### Validation du chantier

- Bancarisation du chantier
    + Associer le compte utilisateur à un espace de stockage dédié (et limité)
    + Modéliser une base PostGIS avec les entités et les attributs des chantiers
        * ID (généré automatiquement)
        * Nom du chantier (manuel ou récupéré depuis le nom du fichier source)
        * Emprise du chantier (récupéré du tracé du chantier)
        * Type de travaux (généré automatiquement avec la création du chantier, liste de valeurs prédéfinies)
        * Commune de départ (généré automatiquement)
        * Début des travaux (manuel : par saison)
        * Durée (manuel)
        * Budget prévisionnel
    + Le bouton valider fait le lien entre le module de création de chantier, les entités chargées la BDD, le viewer et la liste de couches

*Après validation du nouveau chantier, afficher la donnée sur le visualiseur selon une symbologie basique prédéterminée*

- L'apparence de l'interface (logo, couleur du header) est à lier au type de réseau représenté
- Prévoir un mode édition de chantier
- Prévoir le partage d'un chantier avec des collaborateurs (désactivée en mode basique (?))

## Symbologie

En mode basique, l'entité s'affiche selon une symbologie standardisée non-éditable.

### Elements à représenter

Couches ou groupes de couches (Z-index) :

- Opportunités (3)
- Chantier(s) (2) : Tracés et zones de travaux (buffer autour des chantiers)
- Donnée de base (1)
- Base map WMS (0)

Habillage :

- Métadonnées du chantier (cf. ci-dessus)
- Statistiques sur le tracé : longueur, parts selon zones urbaines(?)

### Modes de représentation

- Opportunités : implantation différentiée selon l'échelle cartographique
    + A petite échelle : cercles proportionnels (cluster)
    + A moyenne échelle : POI
    + A grande échelle : linéaire intersecté par un autre chantier (définition d'une "opportunité" à préciser). *Ce dernier mode de représentation pourrait être reservé aux comptes payants*

- Chantier : deux symbologies, *métier* (opérationnel) et *temporelle* (stratégique)
    + *Métier* : variable visuelle couleur pour différentier :
        * Soit le type de réseau
        * Soit son mode d'installation (aérien, souterrain, ...(?)). 
        * *Les deux informations peuvent être représentées en utilisant la graisse (contour éventuellement coloré) ou le grain (tirets)*
    + *Temporelle* : variable visuelle valeur (gradient) pour représenter la période du chantier, par ex. : 
        * Du rouge : travaux imminents
        * au violet : travaux lointains
        * et le gris pour les travaux passés

*Il faudrait donner la possibilité à l'utilisateur de switcher entre ces deux modes, par ex. avec un toggle à côté de la légende*

- Donnée de base et basemap : à préciser ultérieurement

## Zoom
### Afficher l'emprise globale de ma zone d'étude
*L'emprise est calculée sur la bounding box des chantiers numérisés ou chargés dans "Mes chantiers".*

### Définir des géosignets 
*Permet d'enregistrer un emplacement géographique particulier (ex: zone d'un chantier) pour pouvoir le retrouver ultérieurement.*

### Retrouver la dernière emprise travaillée
*Permet de retrouver facilement l'état du projet avant que l'utilisateur ne se déconnecte.*

## Menu fond de carte

En tant qu’utilisateur basique, je dois pouvoir :
### Choisir un fond de plan cartographique

**Fonds de plan gratuits disponibles :**

- OpenStreetMap:
     + Stamen Toner Light : http://{a-c}.tile.stamen.com/toner-lite/{z}/{x}/{y}.png
     + OpenStreetMap : http://{a-c}.tile.openstreetmap.org/{z}/{x}/{y}.png
- Esri :
     + Esri World Topo Map : https://server.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}.png
     + Esri World Imager : https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}.png
- Pitney Bows :
    + Pitney Bows Streets : http://{a-c}.basemaps.cartocdn.com/pitney-bowes-streets/{z}/{x}/{y}.png

*D'autres fond de plan peuvent être trouvés à cette adresse :*
https://wiki.openstreetmap.org/wiki/Tile_servers

## Menu sélection des couches

En tant qu’utilisateur basique, je dois pouvoir :

### Sélectionner des données dans les groupes 

- Mes chantiers
    + Soit les données shapefiles importées d’emprise de travaux prévus (chantier ou programmation)
    + Soit le tracé numérisé par le chargé d’étude (chantier ou programmation)
- Mes opportunités (les données numérisées par les différents utilisateurs s’intègreront dans la couche des opportunités)
- Données socles (référentiels cartographiques, fonds de plan cartographiques gratuits, flux open data…)

*Le menu des couches permet de visualiser le rendu graphique avec sa légende.*

## Recherche

En tant qu’utilisateur basique, je dois pouvoir :

### Effectuer une recherche 

- Dans l’emprise de la carte (ex : nom commune = Chamaret)

*Permet de rechercher en priorité des adresses proches de la zone géographiques visibles à l'écran*

- Parmi des adresse (ex : Grande rue)

*Interroge une base de données comme la BAN en France pour rechercher des adresses*

- Parmi des entités (ex : id_opp = OPP_4-36_LT_26146_GGAN_001)

*Permet de rechercher une entité parmi les couches qui ont été configurées pour cette fonctionnalité. Un géo pin apparait au centroide de la zone trouvée par le mode "Recherche".*
    
## Dessin et annotation

En tant qu’utilisateur basique, je dois pouvoir :

### Dessiner et ajouter des notes

 - Barre d'outil Dessiner:
    + Outils de lignes, points, marqueurs, polygones, rectangles
    + Feutre avec palette de couleurs et choix de la grosseur de trait
    + Règle de mesure en mètres
    + Gomme
    + Poubelle

*Permet à l'utilisateur de produire un premier travail d'analyse sur sa zone d'étude*

## Impression de carte 

En tant qu’utilisateur basique, je dois pouvoir :

### Exporter une carte en PNG/PDF
  - Titre (voir à la création du chantier)
  - Contexte cartographique (emprise de la carte)
  - Légende (dynamique en fonction des couches affichées)
  - Source (éditable)
  - Nord (par défaut)
  - Echelle (par défaut)

### Exporter une capture d’écran
*Exporter une capture d’écran du contexte cartographique en PNG/PDF*

