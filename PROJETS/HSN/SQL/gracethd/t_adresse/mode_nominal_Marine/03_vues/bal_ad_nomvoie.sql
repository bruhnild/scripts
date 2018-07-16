/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 26/06/2018
Objet : Création de la vue v_bal_ad_nomvoie pour calculer le champ ad_nomvoie
Modification : Nom : ///// - Date : date_de_modif - Motif/nature : //////

Sources: rbal.liaison_hsn_linestring_2154 (nom_voie) via ban.hsn_point_2154 (id)/
         psd_orange.locaux_hsn_sian_zanro_point_2154 (voie)/
         rbal.liaison_voie_hsn_linestring_2154 (nomvoie)/
         rbal.liaison_voie_sanspci_hsn_linestring_2154 (nomvoie)
-------------------------------------------------------------------------------------
*/


CREATE OR REPLACE VIEW rbal.v_bal_ad_nomvoie AS
SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, *
FROM
(
/*
-------------------------------------------------------------------------------------
TOUT CE QUI EST SANS VOIE
-------------------------------------------------------------------------------------
*/


SELECT 
  hp.ad_code,
  NULL::varchar as ad_nomvoie
FROM
  rbal.bal_hsn_point_2154 as hp
WHERE
  hp.ad_code NOT IN 
 
(SELECT ad_code FROM
(WITH ad_nomvoie AS
(
-----------------NOM VOIE AVEC BAN)

(SELECT ad_code, ad_nomvoie FROM
(WITH ad_nomvoie AS
(
	
(SELECT ad_code, ad_nomvoie FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1))
SELECT ad_code, id_ban as ad_ban_id, nom_voie as ad_nomvoie FROM nomvoie_ban_liaison
LEFT JOIN ban.hsn_point_2154 AS c ON nomvoie_ban_liaison.id_ban=c.id
WHERE nom_voie IS NOT NULL)a )

-----------------NOM VOIE AVEC LOCAUX (SANS BAN)
UNION ALL
-----------------NOM VOIE AVEC LOCAUX (SANS BAN)
(SELECT ad_code, ad_nomvoie FROM
(WITH nomvoie_locaux AS 
(SELECT DISTINCT ON (c.ad_code)c.ad_code, voie as ad_nomvoie
FROM psd_orange.locaux_hsn_sian_zanro_point_2154 a, rbal.liaison_hsn_linestring_2154 c 
WHERE  ST_DWithin(a.geom, c.geom, 0.001) AND id_ban IS NULL )
SELECT * from nomvoie_locaux where ad_code NOT IN 
(SELECT ad_code FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1))
SELECT ad_code, id_ban as ad_ban_id, nom_voie as ad_nomvoie FROM nomvoie_ban_liaison
LEFT JOIN ban.hsn_point_2154 AS c ON nomvoie_ban_liaison.id_ban=c.id
WHERE nom_voie IS NOT NULL)a ))a)




-----------------NOM VOIE AVEC LAISON VOIE (SANS BAN/LOCAUX)
UNION ALL 
-----------------NOM VOIE AVEC LAISON VOIE (SANS BAN/LOCAUX)

(
SELECT ad_code, ad_nomvoie FROM 
(WITH nomvoie_liaison_voie AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban,
    nomvoie
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_voie_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1) and id_ban IS NULL AND nomvoie IS NOT NULL )
SELECT ad_code, id_ban as ad_ban_id, nomvoie as ad_nomvoie FROM nomvoie_liaison_voie)a


WHERE ad_code NOT IN 

(SELECT ad_code FROM
(
WITH nomvoie_ban_locaux AS
(
((SELECT ad_code, ad_nomvoie FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1))
SELECT ad_code, id_ban as ad_ban_id, nom_voie as ad_nomvoie FROM nomvoie_ban_liaison
LEFT JOIN ban.hsn_point_2154 AS c ON nomvoie_ban_liaison.id_ban=c.id
WHERE nom_voie IS NOT NULL)a )


UNION ALL

(SELECT ad_code, ad_nomvoie FROM
(WITH nomvoie_locaux AS 
(SELECT DISTINCT ON (c.ad_code)c.ad_code, voie as ad_nomvoie
FROM psd_orange.locaux_hsn_sian_zanro_point_2154 a, rbal.liaison_hsn_linestring_2154 c 
WHERE  ST_DWithin(a.geom, c.geom, 0.001) AND id_ban IS NULL )
SELECT * from nomvoie_locaux where ad_code NOT IN 
(SELECT ad_code FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1))
SELECT ad_code, id_ban as ad_ban_id, nom_voie as ad_nomvoie FROM nomvoie_ban_liaison
LEFT JOIN ban.hsn_point_2154 AS c ON nomvoie_ban_liaison.id_ban=c.id
WHERE nom_voie IS NOT NULL)a ))a
))
)
SELECT * FROM nomvoie_ban_locaux
)a)
)

-----------------NOM VOIE AVEC LIAISON VOIE SANS PCI (SANS BAN/LOCAUX/LIASON VOIE )
UNION ALL 
-----------------NOM VOIE AVEC LIAISON VOIE SANS PCI (SANS BAN/LOCAUX/LIASON VOIE)


(
SELECT ad_code, ad_nomvoie FROM 
(WITH nom_voie_liaison_voie_sanspci AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	ad_ban_id,
    nomvoie
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_voie_sanspci_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1) and ad_ban_id IS NULL AND nomvoie IS NOT NULL )
SELECT ad_code, ad_ban_id, nomvoie as ad_nomvoie FROM nom_voie_liaison_voie_sanspci)a

WHERE ad_code NOT IN 

(SELECT ad_code FROM 
(
WITH nomvoie_ban_locaux_voie AS
(
(SELECT ad_code, ad_nomvoie FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1))
SELECT ad_code, id_ban as ad_ban_id, nom_voie as ad_nomvoie FROM nomvoie_ban_liaison
LEFT JOIN ban.hsn_point_2154 AS c ON nomvoie_ban_liaison.id_ban=c.id
WHERE nom_voie IS NOT NULL)a )


UNION ALL

(SELECT ad_code, ad_nomvoie FROM
(WITH nomvoie_locaux AS 
(SELECT DISTINCT ON (c.ad_code)c.ad_code, voie as ad_nomvoie
FROM psd_orange.locaux_hsn_sian_zanro_point_2154 a, rbal.liaison_hsn_linestring_2154 c 
WHERE  ST_DWithin(a.geom, c.geom, 0.001) AND id_ban IS NULL )
SELECT * from nomvoie_locaux where ad_code NOT IN 
(SELECT ad_code FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1))
SELECT ad_code, id_ban as ad_ban_id, nom_voie as ad_nomvoie FROM nomvoie_ban_liaison
LEFT JOIN ban.hsn_point_2154 AS c ON nomvoie_ban_liaison.id_ban=c.id
WHERE nom_voie IS NOT NULL)a ))a)

UNION ALL 

(
SELECT ad_code, ad_nomvoie FROM 
(WITH nomvoie_liaison_voie AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban,
    nomvoie
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_voie_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1) and id_ban IS NULL AND nomvoie IS NOT NULL )
SELECT ad_code, id_ban as ad_ban_id, nomvoie as ad_nomvoie FROM nomvoie_liaison_voie)a


WHERE ad_code NOT IN 

(SELECT ad_code FROM
(
WITH nomvoie_ban_locaux AS
(
((SELECT ad_code, ad_nomvoie FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1))
SELECT ad_code, id_ban as ad_ban_id, nom_voie as ad_nomvoie FROM nomvoie_ban_liaison
LEFT JOIN ban.hsn_point_2154 AS c ON nomvoie_ban_liaison.id_ban=c.id
WHERE nom_voie IS NOT NULL)a )


UNION ALL

(SELECT ad_code, ad_nomvoie FROM
(WITH nomvoie_locaux AS 
(SELECT DISTINCT ON (c.ad_code)c.ad_code, voie as ad_nomvoie
FROM psd_orange.locaux_hsn_sian_zanro_point_2154 a, rbal.liaison_hsn_linestring_2154 c 
WHERE  ST_DWithin(a.geom, c.geom, 0.001) AND id_ban IS NULL )
SELECT * from nomvoie_locaux where ad_code NOT IN 
(SELECT ad_code FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1))
SELECT ad_code, id_ban as ad_ban_id, nom_voie as ad_nomvoie FROM nomvoie_ban_liaison
LEFT JOIN ban.hsn_point_2154 AS c ON nomvoie_ban_liaison.id_ban=c.id
WHERE nom_voie IS NOT NULL)a ))a
))
)
SELECT * FROM nomvoie_ban_locaux
)a)
)
)
SELECT * FROM nomvoie_ban_locaux_voie)a)
)




-----------------NOM VOIE FANTOIR (SANS BAN/LOCAUX/LIASON VOIE/LIAISON VOIE SANS PCI )
UNION ALL 
-----------------NOM VOIE FANTOIR (SANS BAN/LOCAUX/LIASON VOIE/LIAISON VOIE SANS PCI)

(SELECT ad_code, ad_nomvoie FROM
(WITH geo_batiment_voie AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
 b.geo_batiment,
 b.fant_voie_majic,
 b.ad_nomvoie,
 b.typvoi
	FROM rbal.bal_hsn_point_2154 a, pci70_majic_analyses.batiment_parcelle_hsn_polygon_2154 b
	WHERE ST_CONTAINS(b.geom, a.geom) AND typvoi NOT LIKE 'lieu-dit')
SELECT * FROM geo_batiment_voie WHERE ad_code NOT IN



(SELECT ad_code FROM 
(WITH ad_nomvoie_ban_locaux_voie_voiesanspci AS
(SELECT ad_code, ad_nomvoie FROM
(WITH ad_nomvoie AS
(
	
(SELECT ad_code, ad_nomvoie FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1))
SELECT ad_code, id_ban as ad_ban_id, nom_voie as ad_nomvoie FROM nomvoie_ban_liaison
LEFT JOIN ban.hsn_point_2154 AS c ON nomvoie_ban_liaison.id_ban=c.id
WHERE nom_voie IS NOT NULL)a )


UNION ALL
 

(SELECT ad_code, ad_nomvoie FROM
(WITH nomvoie_locaux AS 
(SELECT DISTINCT ON (c.ad_code)c.ad_code, voie as ad_nomvoie
FROM psd_orange.locaux_hsn_sian_zanro_point_2154 a, rbal.liaison_hsn_linestring_2154 c 
WHERE  ST_DWithin(a.geom, c.geom, 0.001) AND id_ban IS NULL )
SELECT * from nomvoie_locaux where ad_code NOT IN 
(SELECT ad_code FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1))
SELECT ad_code, id_ban as ad_ban_id, nom_voie as ad_nomvoie FROM nomvoie_ban_liaison
LEFT JOIN ban.hsn_point_2154 AS c ON nomvoie_ban_liaison.id_ban=c.id
WHERE nom_voie IS NOT NULL)a ))a)



UNION ALL 


(
SELECT ad_code, ad_nomvoie FROM 
(WITH nomvoie_liaison_voie AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban,
    nomvoie
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_voie_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1) and id_ban IS NULL AND nomvoie IS NOT NULL )
SELECT ad_code, id_ban as ad_ban_id, nomvoie as ad_nomvoie FROM nomvoie_liaison_voie)a


WHERE ad_code NOT IN 

(SELECT ad_code FROM
(
WITH nomvoie_ban_locaux AS
(
((SELECT ad_code, ad_nomvoie FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1))
SELECT ad_code, id_ban as ad_ban_id, nom_voie as ad_nomvoie FROM nomvoie_ban_liaison
LEFT JOIN ban.hsn_point_2154 AS c ON nomvoie_ban_liaison.id_ban=c.id
WHERE nom_voie IS NOT NULL)a )


UNION ALL

(SELECT ad_code, ad_nomvoie FROM
(WITH nomvoie_locaux AS 
(SELECT DISTINCT ON (c.ad_code)c.ad_code, voie as ad_nomvoie
FROM psd_orange.locaux_hsn_sian_zanro_point_2154 a, rbal.liaison_hsn_linestring_2154 c 
WHERE  ST_DWithin(a.geom, c.geom, 0.001) AND id_ban IS NULL )
SELECT * from nomvoie_locaux where ad_code NOT IN 
(SELECT ad_code FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1))
SELECT ad_code, id_ban as ad_ban_id, nom_voie as ad_nomvoie FROM nomvoie_ban_liaison
LEFT JOIN ban.hsn_point_2154 AS c ON nomvoie_ban_liaison.id_ban=c.id
WHERE nom_voie IS NOT NULL)a ))a
))
)
SELECT * FROM nomvoie_ban_locaux
)a)
)


UNION ALL 



(
SELECT ad_code, ad_nomvoie FROM 
(WITH nom_voie_liaison_voie_sanspci AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	ad_ban_id,
    nomvoie
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_voie_sanspci_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1) and ad_ban_id IS NULL AND nomvoie IS NOT NULL )
SELECT ad_code, ad_ban_id, nomvoie as ad_nomvoie FROM nom_voie_liaison_voie_sanspci)a

WHERE ad_code NOT IN 

(SELECT ad_code FROM 
(
WITH nomvoie_ban_locaux_voie AS
(
(SELECT ad_code, ad_nomvoie FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1))
SELECT ad_code, id_ban as ad_ban_id, nom_voie as ad_nomvoie FROM nomvoie_ban_liaison
LEFT JOIN ban.hsn_point_2154 AS c ON nomvoie_ban_liaison.id_ban=c.id
WHERE nom_voie IS NOT NULL)a )


UNION ALL

(SELECT ad_code, ad_nomvoie FROM
(WITH nomvoie_locaux AS 
(SELECT DISTINCT ON (c.ad_code)c.ad_code, voie as ad_nomvoie
FROM psd_orange.locaux_hsn_sian_zanro_point_2154 a, rbal.liaison_hsn_linestring_2154 c 
WHERE  ST_DWithin(a.geom, c.geom, 0.001) AND id_ban IS NULL )
SELECT * from nomvoie_locaux where ad_code NOT IN 
(SELECT ad_code FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1))
SELECT ad_code, id_ban as ad_ban_id, nom_voie as ad_nomvoie FROM nomvoie_ban_liaison
LEFT JOIN ban.hsn_point_2154 AS c ON nomvoie_ban_liaison.id_ban=c.id
WHERE nom_voie IS NOT NULL)a ))a)

UNION ALL 

(
SELECT ad_code, ad_nomvoie FROM 
(WITH nomvoie_liaison_voie AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban,
    nomvoie
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_voie_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1) and id_ban IS NULL AND nomvoie IS NOT NULL )
SELECT ad_code, id_ban as ad_ban_id, nomvoie as ad_nomvoie FROM nomvoie_liaison_voie)a


WHERE ad_code NOT IN 

(SELECT ad_code FROM
(
WITH nomvoie_ban_locaux AS
(
((SELECT ad_code, ad_nomvoie FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1))
SELECT ad_code, id_ban as ad_ban_id, nom_voie as ad_nomvoie FROM nomvoie_ban_liaison
LEFT JOIN ban.hsn_point_2154 AS c ON nomvoie_ban_liaison.id_ban=c.id
WHERE nom_voie IS NOT NULL)a )


UNION ALL

(SELECT ad_code, ad_nomvoie FROM
(WITH nomvoie_locaux AS 
(SELECT DISTINCT ON (c.ad_code)c.ad_code, voie as ad_nomvoie
FROM psd_orange.locaux_hsn_sian_zanro_point_2154 a, rbal.liaison_hsn_linestring_2154 c 
WHERE  ST_DWithin(a.geom, c.geom, 0.001) AND id_ban IS NULL )
SELECT * from nomvoie_locaux where ad_code NOT IN 
(SELECT ad_code FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1))
SELECT ad_code, id_ban as ad_ban_id, nom_voie as ad_nomvoie FROM nomvoie_ban_liaison
LEFT JOIN ban.hsn_point_2154 AS c ON nomvoie_ban_liaison.id_ban=c.id
WHERE nom_voie IS NOT NULL)a ))a
))
)
SELECT * FROM nomvoie_ban_locaux
)a)
)
)
SELECT * FROM nomvoie_ban_locaux_voie)a)
)
)
SELECT * FROM ad_nomvoie)a)
SELECT * FROM ad_nomvoie_ban_locaux_voie_voiesanspci)a))a))

SELECT * FROM ad_nomvoie)a))
SELECT * FROM ad_nomvoie)a)

/*
-------------------------------------------------------------------------------------
TOUT CE QUI A UNE VOIE
-------------------------------------------------------------------------------------
*/
 
-------------------------------------------------------------------------------------
UNION ALL
-------------------------------------------------------------------------------------
 
-----------------NOM VOIE AVEC BAN)

 
(SELECT ad_code, ad_nomvoie FROM
(WITH ad_nomvoie AS
(
	
(SELECT ad_code, ad_nomvoie FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1))
SELECT ad_code, id_ban as ad_ban_id, nom_voie as ad_nomvoie FROM nomvoie_ban_liaison
LEFT JOIN ban.hsn_point_2154 AS c ON nomvoie_ban_liaison.id_ban=c.id
WHERE nom_voie IS NOT NULL)a )

-----------------NOM VOIE AVEC LOCAUX (SANS BAN)
UNION ALL
-----------------NOM VOIE AVEC LOCAUX (SANS BAN)
(SELECT ad_code, ad_nomvoie FROM
(WITH nomvoie_locaux AS 
(SELECT DISTINCT ON (c.ad_code)c.ad_code, voie as ad_nomvoie
FROM psd_orange.locaux_hsn_sian_zanro_point_2154 a, rbal.liaison_hsn_linestring_2154 c 
WHERE  ST_DWithin(a.geom, c.geom, 0.001) AND id_ban IS NULL )
SELECT * from nomvoie_locaux where ad_code NOT IN 
(SELECT ad_code FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1))
SELECT ad_code, id_ban as ad_ban_id, nom_voie as ad_nomvoie FROM nomvoie_ban_liaison
LEFT JOIN ban.hsn_point_2154 AS c ON nomvoie_ban_liaison.id_ban=c.id
WHERE nom_voie IS NOT NULL)a ))a)




-----------------NOM VOIE AVEC LAISON VOIE (SANS BAN/LOCAUX)
UNION ALL 
-----------------NOM VOIE AVEC LAISON VOIE (SANS BAN/LOCAUX)

(
SELECT ad_code, ad_nomvoie FROM 
(WITH nomvoie_liaison_voie AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban,
    nomvoie
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_voie_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1) and id_ban IS NULL AND nomvoie IS NOT NULL )
SELECT ad_code, id_ban as ad_ban_id, nomvoie as ad_nomvoie FROM nomvoie_liaison_voie)a


WHERE ad_code NOT IN 

(SELECT ad_code FROM
(
WITH nomvoie_ban_locaux AS
(
((SELECT ad_code, ad_nomvoie FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1))
SELECT ad_code, id_ban as ad_ban_id, nom_voie as ad_nomvoie FROM nomvoie_ban_liaison
LEFT JOIN ban.hsn_point_2154 AS c ON nomvoie_ban_liaison.id_ban=c.id
WHERE nom_voie IS NOT NULL)a )


UNION ALL

(SELECT ad_code, ad_nomvoie FROM
(WITH nomvoie_locaux AS 
(SELECT DISTINCT ON (c.ad_code)c.ad_code, voie as ad_nomvoie
FROM psd_orange.locaux_hsn_sian_zanro_point_2154 a, rbal.liaison_hsn_linestring_2154 c 
WHERE  ST_DWithin(a.geom, c.geom, 0.001) AND id_ban IS NULL )
SELECT * from nomvoie_locaux where ad_code NOT IN 
(SELECT ad_code FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1))
SELECT ad_code, id_ban as ad_ban_id, nom_voie as ad_nomvoie FROM nomvoie_ban_liaison
LEFT JOIN ban.hsn_point_2154 AS c ON nomvoie_ban_liaison.id_ban=c.id
WHERE nom_voie IS NOT NULL)a ))a
))
)
SELECT * FROM nomvoie_ban_locaux
)a)
)

-----------------NOM VOIE AVEC LIAISON VOIE SANS PCI (SANS BAN/LOCAUX/LIASON VOIE )
UNION ALL 
-----------------NOM VOIE AVEC LIAISON VOIE SANS PCI (SANS BAN/LOCAUX/LIASON VOIE)


(
SELECT ad_code, ad_nomvoie FROM 
(WITH nom_voie_liaison_voie_sanspci AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	ad_ban_id,
    nomvoie
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_voie_sanspci_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1) and ad_ban_id IS NULL AND nomvoie IS NOT NULL )
SELECT ad_code, ad_ban_id, nomvoie as ad_nomvoie FROM nom_voie_liaison_voie_sanspci)a

WHERE ad_code NOT IN 

(SELECT ad_code FROM 
(
WITH nomvoie_ban_locaux_voie AS
(
(SELECT ad_code, ad_nomvoie FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1))
SELECT ad_code, id_ban as ad_ban_id, nom_voie as ad_nomvoie FROM nomvoie_ban_liaison
LEFT JOIN ban.hsn_point_2154 AS c ON nomvoie_ban_liaison.id_ban=c.id
WHERE nom_voie IS NOT NULL)a )


UNION ALL

(SELECT ad_code, ad_nomvoie FROM
(WITH nomvoie_locaux AS 
(SELECT DISTINCT ON (c.ad_code)c.ad_code, voie as ad_nomvoie
FROM psd_orange.locaux_hsn_sian_zanro_point_2154 a, rbal.liaison_hsn_linestring_2154 c 
WHERE  ST_DWithin(a.geom, c.geom, 0.001) AND id_ban IS NULL )
SELECT * from nomvoie_locaux where ad_code NOT IN 
(SELECT ad_code FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1))
SELECT ad_code, id_ban as ad_ban_id, nom_voie as ad_nomvoie FROM nomvoie_ban_liaison
LEFT JOIN ban.hsn_point_2154 AS c ON nomvoie_ban_liaison.id_ban=c.id
WHERE nom_voie IS NOT NULL)a ))a)

UNION ALL 

(
SELECT ad_code, ad_nomvoie FROM 
(WITH nomvoie_liaison_voie AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban,
    nomvoie
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_voie_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1) and id_ban IS NULL AND nomvoie IS NOT NULL )
SELECT ad_code, id_ban as ad_ban_id, nomvoie as ad_nomvoie FROM nomvoie_liaison_voie)a


WHERE ad_code NOT IN 

(SELECT ad_code FROM
(
WITH nomvoie_ban_locaux AS
(
((SELECT ad_code, ad_nomvoie FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1))
SELECT ad_code, id_ban as ad_ban_id, nom_voie as ad_nomvoie FROM nomvoie_ban_liaison
LEFT JOIN ban.hsn_point_2154 AS c ON nomvoie_ban_liaison.id_ban=c.id
WHERE nom_voie IS NOT NULL)a )


UNION ALL

(SELECT ad_code, ad_nomvoie FROM
(WITH nomvoie_locaux AS 
(SELECT DISTINCT ON (c.ad_code)c.ad_code, voie as ad_nomvoie
FROM psd_orange.locaux_hsn_sian_zanro_point_2154 a, rbal.liaison_hsn_linestring_2154 c 
WHERE  ST_DWithin(a.geom, c.geom, 0.001) AND id_ban IS NULL )
SELECT * from nomvoie_locaux where ad_code NOT IN 
(SELECT ad_code FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1))
SELECT ad_code, id_ban as ad_ban_id, nom_voie as ad_nomvoie FROM nomvoie_ban_liaison
LEFT JOIN ban.hsn_point_2154 AS c ON nomvoie_ban_liaison.id_ban=c.id
WHERE nom_voie IS NOT NULL)a ))a
))
)
SELECT * FROM nomvoie_ban_locaux
)a)
)
)
SELECT * FROM nomvoie_ban_locaux_voie)a)
)




-----------------NOM VOIE FANTOIR (SANS BAN/LOCAUX/LIASON VOIE/LIAISON VOIE SANS PCI )
UNION ALL 
-----------------NOM VOIE FANTOIR (SANS BAN/LOCAUX/LIASON VOIE/LIAISON VOIE SANS PCI)

(SELECT ad_code, ad_nomvoie FROM
(WITH geo_batiment_voie AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
 b.geo_batiment,
 b.fant_voie_majic,
 b.ad_nomvoie,
 b.typvoi
	FROM rbal.bal_hsn_point_2154 a, pci70_majic_analyses.batiment_parcelle_hsn_polygon_2154 b
	WHERE ST_CONTAINS(b.geom, a.geom) AND typvoi NOT LIKE 'lieu-dit')
SELECT * FROM geo_batiment_voie WHERE ad_code NOT IN



(SELECT ad_code FROM 
(WITH ad_nomvoie_ban_locaux_voie_voiesanspci AS
(SELECT ad_code, ad_nomvoie FROM
(WITH ad_nomvoie AS
(
	
(SELECT ad_code, ad_nomvoie FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1))
SELECT ad_code, id_ban as ad_ban_id, nom_voie as ad_nomvoie FROM nomvoie_ban_liaison
LEFT JOIN ban.hsn_point_2154 AS c ON nomvoie_ban_liaison.id_ban=c.id
WHERE nom_voie IS NOT NULL)a )


UNION ALL
 

(SELECT ad_code, ad_nomvoie FROM
(WITH nomvoie_locaux AS 
(SELECT DISTINCT ON (c.ad_code)c.ad_code, voie as ad_nomvoie
FROM psd_orange.locaux_hsn_sian_zanro_point_2154 a, rbal.liaison_hsn_linestring_2154 c 
WHERE  ST_DWithin(a.geom, c.geom, 0.001) AND id_ban IS NULL )
SELECT * from nomvoie_locaux where ad_code NOT IN 
(SELECT ad_code FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1))
SELECT ad_code, id_ban as ad_ban_id, nom_voie as ad_nomvoie FROM nomvoie_ban_liaison
LEFT JOIN ban.hsn_point_2154 AS c ON nomvoie_ban_liaison.id_ban=c.id
WHERE nom_voie IS NOT NULL)a ))a)



UNION ALL 


(
SELECT ad_code, ad_nomvoie FROM 
(WITH nomvoie_liaison_voie AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban,
    nomvoie
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_voie_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1) and id_ban IS NULL AND nomvoie IS NOT NULL )
SELECT ad_code, id_ban as ad_ban_id, nomvoie as ad_nomvoie FROM nomvoie_liaison_voie)a


WHERE ad_code NOT IN 

(SELECT ad_code FROM
(
WITH nomvoie_ban_locaux AS
(
((SELECT ad_code, ad_nomvoie FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1))
SELECT ad_code, id_ban as ad_ban_id, nom_voie as ad_nomvoie FROM nomvoie_ban_liaison
LEFT JOIN ban.hsn_point_2154 AS c ON nomvoie_ban_liaison.id_ban=c.id
WHERE nom_voie IS NOT NULL)a )


UNION ALL

(SELECT ad_code, ad_nomvoie FROM
(WITH nomvoie_locaux AS 
(SELECT DISTINCT ON (c.ad_code)c.ad_code, voie as ad_nomvoie
FROM psd_orange.locaux_hsn_sian_zanro_point_2154 a, rbal.liaison_hsn_linestring_2154 c 
WHERE  ST_DWithin(a.geom, c.geom, 0.001) AND id_ban IS NULL )
SELECT * from nomvoie_locaux where ad_code NOT IN 
(SELECT ad_code FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1))
SELECT ad_code, id_ban as ad_ban_id, nom_voie as ad_nomvoie FROM nomvoie_ban_liaison
LEFT JOIN ban.hsn_point_2154 AS c ON nomvoie_ban_liaison.id_ban=c.id
WHERE nom_voie IS NOT NULL)a ))a
))
)
SELECT * FROM nomvoie_ban_locaux
)a)
)


UNION ALL 



(
SELECT ad_code, ad_nomvoie FROM 
(WITH nom_voie_liaison_voie_sanspci AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	ad_ban_id,
    nomvoie
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_voie_sanspci_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1) and ad_ban_id IS NULL AND nomvoie IS NOT NULL )
SELECT ad_code, ad_ban_id, nomvoie as ad_nomvoie FROM nom_voie_liaison_voie_sanspci)a

WHERE ad_code NOT IN 

(SELECT ad_code FROM 
(
WITH nomvoie_ban_locaux_voie AS
(
(SELECT ad_code, ad_nomvoie FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1))
SELECT ad_code, id_ban as ad_ban_id, nom_voie as ad_nomvoie FROM nomvoie_ban_liaison
LEFT JOIN ban.hsn_point_2154 AS c ON nomvoie_ban_liaison.id_ban=c.id
WHERE nom_voie IS NOT NULL)a )


UNION ALL

(SELECT ad_code, ad_nomvoie FROM
(WITH nomvoie_locaux AS 
(SELECT DISTINCT ON (c.ad_code)c.ad_code, voie as ad_nomvoie
FROM psd_orange.locaux_hsn_sian_zanro_point_2154 a, rbal.liaison_hsn_linestring_2154 c 
WHERE  ST_DWithin(a.geom, c.geom, 0.001) AND id_ban IS NULL )
SELECT * from nomvoie_locaux where ad_code NOT IN 
(SELECT ad_code FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1))
SELECT ad_code, id_ban as ad_ban_id, nom_voie as ad_nomvoie FROM nomvoie_ban_liaison
LEFT JOIN ban.hsn_point_2154 AS c ON nomvoie_ban_liaison.id_ban=c.id
WHERE nom_voie IS NOT NULL)a ))a)

UNION ALL 

(
SELECT ad_code, ad_nomvoie FROM 
(WITH nomvoie_liaison_voie AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban,
    nomvoie
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_voie_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1) and id_ban IS NULL AND nomvoie IS NOT NULL )
SELECT ad_code, id_ban as ad_ban_id, nomvoie as ad_nomvoie FROM nomvoie_liaison_voie)a


WHERE ad_code NOT IN 

(SELECT ad_code FROM
(
WITH nomvoie_ban_locaux AS
(
((SELECT ad_code, ad_nomvoie FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1))
SELECT ad_code, id_ban as ad_ban_id, nom_voie as ad_nomvoie FROM nomvoie_ban_liaison
LEFT JOIN ban.hsn_point_2154 AS c ON nomvoie_ban_liaison.id_ban=c.id
WHERE nom_voie IS NOT NULL)a )


UNION ALL

(SELECT ad_code, ad_nomvoie FROM
(WITH nomvoie_locaux AS 
(SELECT DISTINCT ON (c.ad_code)c.ad_code, voie as ad_nomvoie
FROM psd_orange.locaux_hsn_sian_zanro_point_2154 a, rbal.liaison_hsn_linestring_2154 c 
WHERE  ST_DWithin(a.geom, c.geom, 0.001) AND id_ban IS NULL )
SELECT * from nomvoie_locaux where ad_code NOT IN 
(SELECT ad_code FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1))
SELECT ad_code, id_ban as ad_ban_id, nom_voie as ad_nomvoie FROM nomvoie_ban_liaison
LEFT JOIN ban.hsn_point_2154 AS c ON nomvoie_ban_liaison.id_ban=c.id
WHERE nom_voie IS NOT NULL)a ))a
))
)
SELECT * FROM nomvoie_ban_locaux
)a)
)
)
SELECT * FROM nomvoie_ban_locaux_voie)a)
)
)
SELECT * FROM ad_nomvoie)a)
SELECT * FROM ad_nomvoie_ban_locaux_voie_voiesanspci)a))a))

SELECT * FROM ad_nomvoie)a)
)a;