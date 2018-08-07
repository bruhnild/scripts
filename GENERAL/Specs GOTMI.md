<!-- MarkdownTOC autolink="true" levels="1,2" -->

- [Glossaire](#glossaire)
- [MCD](#mcd)
- [Specs](#specs)
    - [Création de chantier](#cr%C3%A9ation-de-chantier)
    - [Symbologie](#symbologie)
    - [Zoom](#zoom)
    - [Menu fond de carte](#menu-fond-de-carte)
    - [Menu sélection des couches](#menu-s%C3%A9lection-des-couches)
    - [Recherche](#recherche)
    - [Dessin et annotation](#dessin-et-annotation)
    - [Impression de carte](#impression-de-carte)

<!-- /MarkdownTOC -->

# Glossaire 
*Définitions à discuter*
>L'**utilisateur basique** peut définir un **programme** de **chantiers** qui se compilent dans une même **couche**. Ces dernières servent à la qualification d'une **opportunité**.

**Utilisateur basique** : compte gratuit avec un accès restreint aux fonctionnalités de la plateforme.

**Programme** : Laps défini (en compte payant) par une date de départ et une durée, dans lequel peuvent s'échelonner des chantiers.
=> Le programme est associé à un type de chantier
=> Les bornes temporelles du programme servent le calcul d'opportunité

**Chantier** : Projet de travaux de taille significative sur les réseaux aériens ou souterrains de toute nature (150 m en agglomération et 1000 m hors agglomération).
=> Les bornes spatiales du chantier servent le calcul d'opportunité 

**Couche** : Une couche correspond à une `ol.layer` dans Openlayers
=> Les Chantiers / Opportunités sont compilés dans deux couches distinctes

**Entité** : Une entité correspond à une ligne sur les tables attributaires.
=> L'utilisateur ne rentre que des géométries linéaires.

**Opportunité** : Intersection spatiale -des chantiers- et temporelle -des programmes. L’objectif d'une opportunité est de réaliser une économie à la fois financière et dans le temps en cherchant à optimiser l’utilisation d’infrastructures existantes et projetées des maîtres d’ouvrages tiers. 
=> Couche calculée (manuellement dans un premier temps) après le chargement du programme et sert à l’édition de rapports d’opportunités. 

- **Opportunité identifiée** : Intersection de la bbox des chantiers
- **Opportunité qualifiée** : Intersection de buffers de chantiers variant sur l'attribut `incertitude`  de l'entité, en prenant en compte l'attribut `cat_trav` et les bornes temporelles du programme.
- **Opportunité étudiée** : Opportunité qualifiée, caractérisée par des attributs calculées : économie potentielle, ...


# MCD 
![gotmi_mcd_v8](/uploads/81ae6fc702ed8395e29933232c302dd5/gotmi_mcd_v8.png)

>Exemple de lecture : 
> - 0 ou plusieurs Utilisateurs déclarent un Programme 
> - Un Programme peut être déclaré que par un et un seul Utilisateur

# Specs

## Création de chantier

La création d'un chantier utilisateur doit permettre de :

- **Créer une entité** de chantier (par dépôt ou numérisation)
- **Associer des informations** spatiales, temporelles, attributaires

### Déclaration d'un chantier

- Option 1 : Simple bouton de création qui active, par ex. un pop-up (Modal dans Bootstrap)
- Option 2 : Bouton associé à une fonctionnalité de localisation manuelle du chantier sur la carte (POI ou ROI ?). *Cette option permettrait de récupérer automatiquement la zone administrative du chantier.*


### Création de la géométrie d'un chantier

- Option A : Par traitement interne de médias utilisateurs
    + Déclarer un chantier en important un média (PDF/PNG/JPEG) qui sera numérisée par Items selon la procédure suivante :
        * Déclaration d'un chantier suite à une géolocalisation par l'utilisateur > la geom est stockée dans `Chantier` (couche déclarée dans Geoserver)
        * Affichage d'un POI *En cours de numérisation*
        * Dépôt de média qui enclenche la procédure :
            - Notification à Items
            - Numérisation de la geom et remplissage des attributs de la table `Chantier` et de l'attribut `etat_num` > déclenchement d'une notification à l'utilisateur
            - Eventuellement, complétion des attributs manquants (`budget`) par l'utilisateur afin de valider le chantier

- Option B : Numérisation du tracé par l'utilisateur (en cas d'absence de données spatiales ou fichier invalide)
    + Déclarer un chantier en numérisant son tracé (linéaire)
    + Métadonnées à remplir (cf. ci-dessous)
    + Editer la géométrie et les attributs (echelle minimum d'édition ou nombre de noeuds minimum pour la longueur)
    + Associer un ou plusieurs médias (PDF/PNG/JPEG)

=> Spécification du degré d'incertitude du chantier :

    + Slider pour déterminer une fouchette de précision
    + Crée un buffer autour de l'entité afin d'identifier plus efficacement les opportunités.

*En cas d'absence de fichier géom et d'absence de numérisation, la couche apparait grisée dans le menu des couches*

- Option C : Par chargement du fichier de données spatiales
    + Importer un SHP avec un ou plusieurs tracés de chantiers
    + Faire un mapping des champs de manière à standardiser la donnée
      ==> ex: debut_trvx = date_trvx
    + Editer la géométrie et les attributs(echelle minimum d'édition ou nombre de noeuds minimum pour la longueur)
    + Associer un ou plusieurs médias (PDF/PNG/JPEG)

=> Prévoir un ensemble de tests d'intégrité du fichier chargé :

    + Reprojection automatique en 2154 (ou 3857?)
    + Vérification du type de entité (que linéaire en entrée ?)
    + Compte des entités non null
    + Autres tests à prévoir ?


### Attributs à renseigner par chantier

La création d'un chantier doit générer un ensemble d'attributs automatiques ou renseignés par l'utilisateur (cf. MCD)

- Type de réseau
- Date de début et de fin des travaux
- Module sources et médias associés (optionnels) comprenant :
    + ID (généré automatiquement)
    + ID_Programme (unique pour les basiques)
    + Type de travaux (généré automatiquement avec la création du chantier, liste de valeurs prédéfinies)
    + Maitre d'oeuvre
    + Zone administrative (commune de départ ?)
        * Option 1 : Menu déroulant / autocomplétion avec code INSEE ou nom de la commune
        * Option 2 : Zone administrative du chantier récupéré automatiquement du clic de création du chantier (granularité à définir commune, EPCI, département...) *Permettrait un affichage différent en fonction de l'échelle cartographique et éventuellement une carte statistique en accueil* 
    + Degré d'incertitude de la numérisation
    + Début des travaux (manuel : par saison)
    + Durée (manuel, en nb de mois) *Permet d'estimer la durée de vie du chantier avant de le passer en mode "fini".*
    + Budget prévisionnel (manuel) *Permet de calculer une estimation des économies à réaliser. Peut aussi être estimé par la longeur de la entité rapporté au type de réseau*
    + Champ ajout de pièce jointe

### Validation du chantier

- Bancarisation du chantier
    + Associer le compte utilisateur à un espace de stockage dédié (et limité)
    + Modéliser une base PostGIS avec les entités et les attributs des chantiers
    + Le bouton valider fait le lien entre le module de création de chantier, les entités chargées la BDD, le viewer et la liste de couches

*Après validation du nouveau chantier, afficher la donnée sur le visualiseur selon une symbologie basique prédéterminée*

- L'apparence de l'interface (logo, couleur du header) est à lier au type de réseau représenté
- Prévoir un mode édition de chantier
- Prévoir le partage d'un chantier avec des collaborateurs (désactivée en mode basique (?))

## Symbologie
### Elements à représenter

Couches ou groupes de couches (Z-index) :

- Mes opportunités (3)
- Mes travaux (2) : Tracés et zones de travaux (buffer autour des chantiers)
- Mes données (1) (Compte payant)
- Base map WMS (0)

Habillage :

- Métadonnées du chantier (cf. ci-dessus)
- Statistiques sur le tracé : longueur, parts selon zones urbaines(?)

### Modes de représentation

Les éléments cartographiques (lignes) doivent être représentés selon différents modes :

- Dans la couche chantier (dès la version basique) : 
    + En mode **stratégique** / **temporel** : les éléments sont représentés par un gradient de valeur (par ex. du rouge au blanc + gris pour les chantiers passés) selon un attribut temporel 
    + En mode **opérationnel** / **métier** : les éléments sont représentés par une couleur catégorielle (RGB) et selon un attribut *métier* (Eau, Gaz, Energie).

- Dans la couche opportunité
    + En compte basique : toutes les opportunités sont représentés sans distinction attributaire.
    + En compte payant : 
        * En mode **stratégique** / **temporel** : les éléments sont représentés par un gradient de valeur (par ex. du rouge au blanc + gris pour les chantiers passés) selon un attribut temporel 
        * En mode **opérationnel** / **métier** : les éléments sont représentés par une couleur catégorielle (voirie, eau, gaz, energie, souterrain) et selon un attribut *métier* (Eau, Gaz, Energie).
        * En mode **gestionnaire** / **économie** : les éléments sont représentés selon un attribut calculé sur l'économie potentielle de l'opportunité par un gradient de valeur (par ex. du blanc (€) au bleu (€€€)

*L'utilisateur peut switcher entre ces deux modes, par ex. avec un toggle à côté de la légende*

*L'utilisateur a la possibilité de modérer l'opacité des couches*     
+ Implantation différentiée selon l'échelle cartographique
    * A petite échelle : cercles proportionnels (cluster)
    * A moyenne échelle : POI
    * A grande échelle : linéaire

- Donnée de base et basemap : à préciser ultérieurement

## Zoom
### Afficher l'emprise globale
- Option A : Basique 
     + Affiche l'emprise globale du département concerné (déclaration manuelle à l'arrivée sur la plateforme)
     + Affiche l'emprise globale des chantiers (périmètre d'intervention)
     + Navigateur de chantier (avec des boutons avant/arrière) permettant de passer d'un chantier à un autre (ligne suivant dans la table `chantier`)
*L'emprise est calculée sur la bounding box des chantiers numérisés dans "Mes travaux".*

### Retrouver la dernière emprise travaillée
- Option B : Basique 
*Permet de retrouver facilement l'état du projet avant que l'utilisateur ne se déconnecte.*

### Définir des géosignets 
- Option C : Avancé 
*Permet d'enregistrer un emplacement géographique particulier (ex: zone d'un chantier) pour pouvoir le retrouver ultérieurement.*

## Menu fond de carte
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
### Sélectionner des données dans les groupes 

- Mes travaux
    + Soit les données shapefiles importées d’emprise de travaux prévus (chantier ou programmation)
    + Soit le tracé numérisé par le chargé d’étude (chantier ou programmation)
- Mes opportunités (les données numérisées par les différents utilisateurs s’intègreront dans la couche des opportunités):
    + Identifiées (tous les chantiers du département sur lequel travaille le chargé d'étude)
    + Qualifiées : Tous les chantiers contenus dans la bounding box (spatiale et temporelle) de la zone d'intervention. Une opportunité qualifiée est définie à partir des paramètres temporels, mètres linéaires, budgetaires)
    + Etudiées (rapports d'opportunités consultables)
- Mes données (affichage):
    + Projet:
        * Ajouter un SHP
    + Open data:
        * Ajouter un SHP
        * Ajouter un flux WMS

*Le menu des couches permet de visualiser le rendu graphique avec sa légende.*

## Recherche
### Effectuer une recherche 

- Option A 
    
    + Dans l’emprise de la carte (ex : nom commune = Chamaret)
*Permet de rechercher en priorité des adresses proches de la zone géographiques visibles à l'écran*

    + Parmi des adresse (ex : Grande rue)
*Interroge une base de données comme la BAN en France pour rechercher des adresses*

- Option B 
    + Parmi des entités (ex : id_opp = OPP_4-36_LT_26146_GGAN_001)
*Permet de rechercher une entité (id chantier, id opp, utilisateur) parmi les couches qui ont été configurées pour cette fonctionnalité. Un géo pin apparait au centroide de la zone trouvée par le mode "Recherche".*
    
## Dessin et annotation
### Dessiner et ajouter des notes

 - Barre d'outil Dessiner:
    + Outils de lignes, points, marqueurs, polygones, rectangles
    + Feutre avec palette de couleurs et choix de la grosseur de trait
    + Règle de mesure en mètres
    + Gomme
    + Poubelle

*Permet à l'utilisateur de produire un premier travail d'analyse sur sa zone d'étude*

## Impression de carte 
### Exporter

  - Option A : Basique (exporter une capture d'écran)
    + Export en PNG/PDN du contexte cartographique (dessin et annotations compris)

  - Option B : Intermédiaire (exporter une carte en PNG/PDF)
    + Titre (voir à la création du chantier)
    + Contexte cartographique (emprise de la carte)
    + Légende (dynamique en fonction des couches affichées)
    + Source (éditable)
    + Nord (par défaut)
    + Echelle (par défaut)

  - Option C : Avancé (partage de la donnée de chantier)
    + En CSV
    + En SHP
    + En flux WMS