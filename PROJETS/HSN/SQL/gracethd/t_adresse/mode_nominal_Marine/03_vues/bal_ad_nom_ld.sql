/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 26/06/2018
Objet : Création de la vue v_bal_ad_nom_ld pour calculer le champ nom_ld
Modification : Nom : ///// - Date : date_de_modif - Motif/nature : //////

Sources: rbal.liaison_hsn_linestring_2154 (nom_ld) via ban.hsn_point_2154 (id)/
         pci70_edigeo_majic.geo_lieudit (tex)/
         rbal.liaison_voie_sanspci_hsn_linestring_2154 (lieu_dit)/
         pci70_majic_analyses.batiment_parcelle_hsn_polygon_2154 (libvoi)
-------------------------------------------------------------------------------------
*/

CREATE OR REPLACE VIEW rbal.v_bal_ad_nom_ld AS
SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, *
FROM
(
/*
-------------------------------------------------------------------------------------
TOUT CE QUI EST SANS LIEU-DIT
-------------------------------------------------------------------------------------
*/

SELECT 
 hp.ad_code,
 NULL::varchar as ad_ban_id,
 NULL::varchar as ad_nom_ld
 
FROM
 rbal.bal_hsn_point_2154 as hp
WHERE
 hp.ad_code NOT IN 

(SELECT ad_code FROM 
(WITH ad_nom_ld AS
((SELECT ad_code, ad_ban_id, nom_ld FROM
(WITH ad_ban_id_liaison AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	b.id_ban as ad_ban_id
FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.1) )
SELECT ad_code, ad_ban_id,nom_ld FROM ad_ban_id_liaison

LEFT JOIN 

(SELECT nom_ld, id FROM
(WITH ad_nom_ld_ban AS
(SELECT 
 	nom_ld,
    id
FROM ban.hsn_point_2154 b
)
SELECT nom_ld , id FROM ad_nom_ld_ban)a)ad_nom_ld_ban ON ad_nom_ld_ban.id=ad_ban_id_liaison.ad_ban_id
WHERE nom_ld IS NOT NULL )a)


UNION ALL


(SELECT 
ad_code,
ad_ban_id,
ad_nom_ld
FROM
(SELECT ad_code, ad_ban_id, ad_nom_ld FROM
(WITH ad_numero_ban AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	ad_ban_id, 
 	tex as ad_nom_ld
FROM rbal.bal_hsn_point_2154 a, pci70_edigeo_majic.geo_lieudit b
WHERE ST_CONTAINS(b.geom, a.geom))
SELECT ad_code, ad_ban_id, ad_nom_ld FROM ad_numero_ban)a)a
 
WHERE
  a.ad_code NOT IN 

(SELECT ad_code FROM rbal.v_bal_ad_nomvoie ))


UNION ALL

 
(SELECT ad_code, ad_ban_id, ad_nom_ld FROM
(WITH ad_numero_ban AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	ad_ban_id, 
 	lieu_dit as ad_nom_ld
FROM rbal.bal_hsn_point_2154 a, rbal.liaison_voie_sanspci_hsn_linestring_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.001) and ad_ban_id IS NULL)
SELECT ad_code, ad_ban_id, ad_nom_ld FROM ad_numero_ban
WHERE ad_nom_ld IS NOT NULL) a
WHERE a.ad_code NOT IN

(SELECT ad_code FROM 
(WITH ad_ld_ban_geo_lieu_dit AS
((SELECT ad_code, ad_ban_id, nom_ld FROM
(WITH ad_ban_id_liaison AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	b.id_ban as ad_ban_id
FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.1) )
SELECT ad_code, ad_ban_id,nom_ld FROM ad_ban_id_liaison

LEFT JOIN 

(SELECT nom_ld, id FROM
(WITH ad_nom_ld_ban AS
(SELECT 
 	nom_ld,
    id
FROM ban.hsn_point_2154 b
)
SELECT nom_ld , id FROM ad_nom_ld_ban)a)ad_nom_ld_ban ON ad_nom_ld_ban.id=ad_ban_id_liaison.ad_ban_id
WHERE nom_ld IS NOT NULL )a)


UNION ALL


(SELECT 
ad_code,
ad_ban_id,
ad_nom_ld
FROM
(SELECT ad_code, ad_ban_id, ad_nom_ld FROM
(WITH ad_numero_ban AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	ad_ban_id, 
 	tex as ad_nom_ld
FROM rbal.bal_hsn_point_2154 a, pci70_edigeo_majic.geo_lieudit b
WHERE ST_CONTAINS(b.geom, a.geom))
SELECT ad_code, ad_ban_id, ad_nom_ld FROM ad_numero_ban)a)a
 
WHERE
  a.ad_code NOT IN 

(SELECT ad_code FROM rbal.v_bal_ad_nomvoie )))
SELECT * FROM ad_ld_ban_geo_lieu_dit)a))
 


UNION ALL

 
 
 
(SELECT ad_code,ad_ban_id, libvoi as ad_nom_ld FROM
(WITH geo_batiment_lieu_dit AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
 b.geo_batiment,
 b.fant_voie_majic,
 b.libvoi,
 b.typvoi,
 null::varchar as ad_ban_id
	FROM rbal.bal_hsn_point_2154 a, pci70_majic_analyses.batiment_parcelle_hsn_polygon_2154 b
	WHERE ST_CONTAINS(b.geom, a.geom) AND typvoi LIKE 'lieu-dit')
SELECT * FROM geo_batiment_lieu_dit 
 WHERE ad_code NOT IN
 
(SELECT ad_code FROM 
(WITH  ad_ld_ban_geo_lieu_dit_voiesanspci AS
(SELECT ad_code, ad_ban_id, ad_nom_ld FROM
(WITH ad_numero_ban AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	ad_ban_id, 
 	lieu_dit as ad_nom_ld
FROM rbal.bal_hsn_point_2154 a, rbal.liaison_voie_sanspci_hsn_linestring_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.001) and ad_ban_id IS NULL)
SELECT ad_code, ad_ban_id, ad_nom_ld FROM ad_numero_ban
WHERE ad_nom_ld IS NOT NULL) a
WHERE a.ad_code NOT IN

(SELECT ad_code FROM 
(WITH ad_ld_ban_geo_lieu_dit AS
((SELECT ad_code, ad_ban_id, nom_ld FROM
(WITH ad_ban_id_liaison AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	b.id_ban as ad_ban_id
FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.1) )
SELECT ad_code, ad_ban_id,nom_ld FROM ad_ban_id_liaison

LEFT JOIN 

(SELECT nom_ld, id FROM
(WITH ad_nom_ld_ban AS
(SELECT 
 	nom_ld,
    id
FROM ban.hsn_point_2154 b
)
SELECT nom_ld , id FROM ad_nom_ld_ban)a)ad_nom_ld_ban ON ad_nom_ld_ban.id=ad_ban_id_liaison.ad_ban_id
WHERE nom_ld IS NOT NULL )a)


UNION ALL


(SELECT 
ad_code,
ad_ban_id,
ad_nom_ld
FROM
(SELECT ad_code, ad_ban_id, ad_nom_ld FROM
(WITH ad_numero_ban AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	ad_ban_id, 
 	tex as ad_nom_ld
FROM rbal.bal_hsn_point_2154 a, pci70_edigeo_majic.geo_lieudit b
WHERE ST_CONTAINS(b.geom, a.geom))
SELECT ad_code, ad_ban_id, ad_nom_ld FROM ad_numero_ban)a)a
 
WHERE
  a.ad_code NOT IN 

(SELECT ad_code FROM rbal.v_bal_ad_nomvoie )))
SELECT * FROM ad_ld_ban_geo_lieu_dit)a))
SELECT * FROM ad_ld_ban_geo_lieu_dit_voiesanspci)a))a))
SELECT * FROM ad_nom_ld)a)
/*
-------------------------------------------------------------------------------------
TOUT CE QUI EST AVEC UN LIEU-DIT
-------------------------------------------------------------------------------------
*/
 
UNION ALL 
-----------------NOM LIEU DIT AVEC BAN
 
((SELECT ad_code, ad_ban_id, nom_ld FROM
(WITH ad_ban_id_liaison AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	b.id_ban as ad_ban_id
FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.1) )
SELECT ad_code, ad_ban_id,nom_ld FROM ad_ban_id_liaison

LEFT JOIN 

(SELECT nom_ld, id FROM
(WITH ad_nom_ld_ban AS
(SELECT 
 	nom_ld,
    id
FROM ban.hsn_point_2154 b
)
SELECT nom_ld , id FROM ad_nom_ld_ban)a)ad_nom_ld_ban ON ad_nom_ld_ban.id=ad_ban_id_liaison.ad_ban_id
WHERE nom_ld IS NOT NULL )a)

-----------------NOM LIEU DIT AVEC GEO_LIEUDIT (SANS BAN)
UNION ALL
-----------------NOM LIEU DIT AVEC GEO_LIEUDIT (SANS BAN)

(SELECT 
ad_code,
ad_ban_id,
ad_nom_ld
FROM
(SELECT ad_code, ad_ban_id, ad_nom_ld FROM
(WITH ad_numero_ban AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	ad_ban_id, 
 	tex as ad_nom_ld
FROM rbal.bal_hsn_point_2154 a, pci70_edigeo_majic.geo_lieudit b
WHERE ST_CONTAINS(b.geom, a.geom))
SELECT ad_code, ad_ban_id, ad_nom_ld FROM ad_numero_ban)a)a
 
WHERE
  a.ad_code NOT IN 

(SELECT ad_code FROM rbal.v_bal_ad_nomvoie ))

-----------------NOM LIEU DIT AVEC VOIE SANS PCI (SANS BAN/GEO_LIEUDIT)
UNION ALL
-----------------NOM LIEU DIT AVEC VOIE SANS PCI (SANS BAN/GEO_LIEUDIT)
 
(SELECT ad_code, ad_ban_id, ad_nom_ld FROM
(WITH ad_numero_ban AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	ad_ban_id, 
 	lieu_dit as ad_nom_ld
FROM rbal.bal_hsn_point_2154 a, rbal.liaison_voie_sanspci_hsn_linestring_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.001) and ad_ban_id IS NULL)
SELECT ad_code, ad_ban_id, ad_nom_ld FROM ad_numero_ban
WHERE ad_nom_ld IS NOT NULL) a
WHERE a.ad_code NOT IN

(SELECT ad_code FROM 
(WITH ad_ld_ban_geo_lieu_dit AS
((SELECT ad_code, ad_ban_id, nom_ld FROM
(WITH ad_ban_id_liaison AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	b.id_ban as ad_ban_id
FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.1) )
SELECT ad_code, ad_ban_id,nom_ld FROM ad_ban_id_liaison

LEFT JOIN 

(SELECT nom_ld, id FROM
(WITH ad_nom_ld_ban AS
(SELECT 
 	nom_ld,
    id
FROM ban.hsn_point_2154 b
)
SELECT nom_ld , id FROM ad_nom_ld_ban)a)ad_nom_ld_ban ON ad_nom_ld_ban.id=ad_ban_id_liaison.ad_ban_id
WHERE nom_ld IS NOT NULL )a)


UNION ALL


(SELECT 
ad_code,
ad_ban_id,
ad_nom_ld
FROM
(SELECT ad_code, ad_ban_id, ad_nom_ld FROM
(WITH ad_numero_ban AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	ad_ban_id, 
 	tex as ad_nom_ld
FROM rbal.bal_hsn_point_2154 a, pci70_edigeo_majic.geo_lieudit b
WHERE ST_CONTAINS(b.geom, a.geom))
SELECT ad_code, ad_ban_id, ad_nom_ld FROM ad_numero_ban)a)a
 
WHERE
  a.ad_code NOT IN 

(SELECT ad_code FROM rbal.v_bal_ad_nomvoie )))
SELECT * FROM ad_ld_ban_geo_lieu_dit)a))
 

-----------------NOM LIEU DIT AVEC VOIE MAJIC (SANS BAN/GEO_LIEUDIT/VOIE SANS PCI)
UNION ALL
-----------------NOM LIEU DIT AVEC VOIE MAJIC (SANS BAN/GEO_LIEUDIT/VOIE SANS PCI) 
 
 
 
(SELECT ad_code,ad_ban_id, libvoi as ad_nom_ld FROM
(WITH geo_batiment_lieu_dit AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
 b.geo_batiment,
 b.fant_voie_majic,
 b.libvoi,
 b.typvoi,
 null::varchar as ad_ban_id
	FROM rbal.bal_hsn_point_2154 a, pci70_majic_analyses.batiment_parcelle_hsn_polygon_2154 b
	WHERE ST_CONTAINS(b.geom, a.geom) AND typvoi LIKE 'lieu-dit')
SELECT * FROM geo_batiment_lieu_dit 
 WHERE ad_code NOT IN
 
(SELECT ad_code FROM 
(WITH  ad_ld_ban_geo_lieu_dit_voiesanspci AS
(SELECT ad_code, ad_ban_id, ad_nom_ld FROM
(WITH ad_numero_ban AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	ad_ban_id, 
 	lieu_dit as ad_nom_ld
FROM rbal.bal_hsn_point_2154 a, rbal.liaison_voie_sanspci_hsn_linestring_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.001) and ad_ban_id IS NULL)
SELECT ad_code, ad_ban_id, ad_nom_ld FROM ad_numero_ban
WHERE ad_nom_ld IS NOT NULL) a
WHERE a.ad_code NOT IN

(SELECT ad_code FROM 
(WITH ad_ld_ban_geo_lieu_dit AS
((SELECT ad_code, ad_ban_id, nom_ld FROM
(WITH ad_ban_id_liaison AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	b.id_ban as ad_ban_id
FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.1) )
SELECT ad_code, ad_ban_id,nom_ld FROM ad_ban_id_liaison

LEFT JOIN 

(SELECT nom_ld, id FROM
(WITH ad_nom_ld_ban AS
(SELECT 
 	nom_ld,
    id
FROM ban.hsn_point_2154 b
)
SELECT nom_ld , id FROM ad_nom_ld_ban)a)ad_nom_ld_ban ON ad_nom_ld_ban.id=ad_ban_id_liaison.ad_ban_id
WHERE nom_ld IS NOT NULL )a)


UNION ALL


(SELECT 
ad_code,
ad_ban_id,
ad_nom_ld
FROM
(SELECT ad_code, ad_ban_id, ad_nom_ld FROM
(WITH ad_numero_ban AS
(SELECT 
	DISTINCT ON (ad_code) a.ad_code,
	ad_ban_id, 
 	tex as ad_nom_ld
FROM rbal.bal_hsn_point_2154 a, pci70_edigeo_majic.geo_lieudit b
WHERE ST_CONTAINS(b.geom, a.geom))
SELECT ad_code, ad_ban_id, ad_nom_ld FROM ad_numero_ban)a)a
 
WHERE
  a.ad_code NOT IN 

(SELECT ad_code FROM rbal.v_bal_ad_nomvoie )))
SELECT * FROM ad_ld_ban_geo_lieu_dit)a))
SELECT * FROM ad_ld_ban_geo_lieu_dit_voiesanspci)a))a)))a