/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 26/06/2018
Objet : Création de la vue v_bal_ad_nomvoie pour calculer le champ ad_nomvoie
Modification : Nom : ///// - Date : date_de_modif - Motif/nature : //////

Sources: rbal.liaison_hsn_linestring_2154 (nom_voie) via ban.hsn_point_2154 (id)/
         rbal.liaison_voie_hsn_linestring_2154 (nomvoie)/
         pci70_majic_analyses.batiment_parcelle_hsn_polygon_2154 
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
  


(
(WITH ad_nomvoie AS
((SELECT ad_code, ad_nomvoie FROM
(
	
WITH ad_nomvoie AS
(


(SELECT 
	ad_code
	, ad_nomvoie 
	FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) 
		a.ad_code
		, b.id_ban
		, b.ad_nomvoie
	FROM 
		rbal.bal_hsn_point_2154 a
		, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1) AND ad_nomvoie IS NOT NULL
)
SELECT ad_code, ad_nomvoie
FROM nomvoie_ban_liaison)a)	


-----------------NOM VOIE AVEC LAISON VOIE (SANS BAN)
UNION ALL 
-----------------NOM VOIE AVEC LAISON VOIE (SANS BAN)

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

(SELECT 
	ad_code
	 
	FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) 
		a.ad_code
		, b.id_ban
		, b.ad_nomvoie
	FROM 
		rbal.bal_hsn_point_2154 a
		, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1) AND ad_nomvoie IS NOT NULL
)
SELECT ad_code, ad_nomvoie
FROM nomvoie_ban_liaison)a)	

)

-----------------NOM VOIE FANTOIR (SANS BAN/LIASON VOIE)
UNION ALL 
-----------------NOM VOIE FANTOIR (SANS BAN/LIASON VOIE)

(SELECT ad_code, ad_nomvoie FROM
(WITH parcelle_info_voie AS
(SELECT 
adresse.ad_code,
substring(pci.adresse,'([A-Z](.){1,255})') as ad_nomvoie
FROM rbal.bal_hsn_point_2154 adresse
LEFT JOIN pci70_edigeo_majic.parcelle_info AS pci ON st_within(adresse.geom,pci.geom)
WHERE (adresse.ad_numero IS NULL
OR adresse.nom_voie_relevee IS NULL)
AND pci.adresse IS NOT NULL
AND adresse.ad_ban_id IS NULL)
SELECT * FROM parcelle_info_voie WHERE ad_code NOT IN


(SELECT ad_code
FROM 
(WITH ban_liaisovoie AS
(
(SELECT 
	ad_code
	, ad_nomvoie 
	FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) 
		a.ad_code
		, b.id_ban
		, b.ad_nomvoie
	FROM 
		rbal.bal_hsn_point_2154 a
		, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1) AND ad_nomvoie IS NOT NULL
)
SELECT ad_code, ad_nomvoie
FROM nomvoie_ban_liaison)a)	

UNION ALL 

(
SELECT 
ad_code 
, ad_nomvoie
FROM 
(WITH nomvoie_liaison_voie AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban,
    nomvoie
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_voie_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1) and id_ban IS NULL AND nomvoie IS NOT NULL )
SELECT ad_code, id_ban as ad_ban_id, nomvoie as ad_nomvoie FROM nomvoie_liaison_voie)a


WHERE ad_code NOT IN 

(SELECT 
	ad_code
	 
	FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) 
		a.ad_code
		, b.id_ban
		, b.ad_nomvoie
	FROM 
		rbal.bal_hsn_point_2154 a
		, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1) AND ad_nomvoie IS NOT NULL
)
SELECT ad_code, ad_nomvoie
FROM nomvoie_ban_liaison)a)	

))
SELECT 
ad_code
, ad_nomvoie
FROM ban_liaisovoie)a
)

)a)

 

 
) 
SELECT * FROM ad_nomvoie)a)


 
-----------------NOM VOIE AVEC LIAISON VOIE SANS PCI (SANS BAN/LIASON VOIE )
UNION ALL 
-----------------NOM VOIE AVEC LIAISON VOIE SANS PCI (SANS BAN/LIASON VOIE)
	
	
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
	
WITH ad_nomvoie AS
(


(SELECT 
	ad_code
	, ad_nomvoie 
	FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) 
		a.ad_code
		, b.id_ban
		, b.ad_nomvoie
	FROM 
		rbal.bal_hsn_point_2154 a
		, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1) AND ad_nomvoie IS NOT NULL
)
SELECT ad_code, ad_nomvoie
FROM nomvoie_ban_liaison)a)	


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

(SELECT 
	ad_code
	 
	FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) 
		a.ad_code
		, b.id_ban
		, b.ad_nomvoie
	FROM 
		rbal.bal_hsn_point_2154 a
		, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1) AND ad_nomvoie IS NOT NULL
)
SELECT ad_code, ad_nomvoie
FROM nomvoie_ban_liaison)a)	

)


UNION ALL 


(SELECT ad_code, ad_nomvoie FROM
(WITH parcelle_info_voie AS
(SELECT 
adresse.ad_code,
substring(pci.adresse,'([A-Z](.){1,255})') as ad_nomvoie
FROM rbal.bal_hsn_point_2154 adresse
LEFT JOIN pci70_edigeo_majic.parcelle_info AS pci ON st_within(adresse.geom,pci.geom)
WHERE (adresse.ad_numero IS NULL
OR adresse.nom_voie_relevee IS NULL)
AND pci.adresse IS NOT NULL
AND adresse.ad_ban_id IS NULL)
SELECT * FROM parcelle_info_voie WHERE ad_code NOT IN


(SELECT ad_code
FROM 
(WITH ban_liaisovoie AS
(
(SELECT 
	ad_code
	, ad_nomvoie 
	FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) 
		a.ad_code
		, b.id_ban
		, b.ad_nomvoie
	FROM 
		rbal.bal_hsn_point_2154 a
		, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1) AND ad_nomvoie IS NOT NULL
)
SELECT ad_code, ad_nomvoie
FROM nomvoie_ban_liaison)a)	

UNION ALL 

(
SELECT 
ad_code 
, ad_nomvoie
FROM 
(WITH nomvoie_liaison_voie AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban,
    nomvoie
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_voie_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1) and id_ban IS NULL AND nomvoie IS NOT NULL )
SELECT ad_code, id_ban as ad_ban_id, nomvoie as ad_nomvoie FROM nomvoie_liaison_voie)a


WHERE ad_code NOT IN 

(SELECT 
	ad_code
	 
	FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) 
		a.ad_code
		, b.id_ban
		, b.ad_nomvoie
	FROM 
		rbal.bal_hsn_point_2154 a
		, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1) AND ad_nomvoie IS NOT NULL
)
SELECT ad_code, ad_nomvoie
FROM nomvoie_ban_liaison)a)	

))
SELECT 
ad_code
, ad_nomvoie
FROM ban_liaisovoie)a
)

)a)

 

 
) 
SELECT * FROM ad_nomvoie)a)
		

)
)
SELECT ad_code FROM ad_nomvoie)	


)
 
 
 
/*
-------------------------------------------------------------------------------------
TOUT CE QUI A UNE VOIE
-------------------------------------------------------------------------------------
*/
 
-------------------------------------------------------------------------------------
UNION ALL
-------------------------------------------------------------------------------------
 
-----------------NOM VOIE AVEC BAN)


(

(SELECT ad_code, ad_nomvoie FROM
(
	
WITH ad_nomvoie AS
(


(SELECT 
	ad_code
	, ad_nomvoie 
	FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) 
		a.ad_code
		, b.id_ban
		, b.ad_nomvoie
	FROM 
		rbal.bal_hsn_point_2154 a
		, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1) AND ad_nomvoie IS NOT NULL
)
SELECT ad_code, ad_nomvoie
FROM nomvoie_ban_liaison)a)	


-----------------NOM VOIE AVEC LAISON VOIE (SANS BAN)
UNION ALL 
-----------------NOM VOIE AVEC LAISON VOIE (SANS BAN)

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

(SELECT 
	ad_code
	 
	FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) 
		a.ad_code
		, b.id_ban
		, b.ad_nomvoie
	FROM 
		rbal.bal_hsn_point_2154 a
		, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1) AND ad_nomvoie IS NOT NULL
)
SELECT ad_code, ad_nomvoie
FROM nomvoie_ban_liaison)a)	

)

-----------------NOM VOIE FANTOIR (SANS BAN/LIASON VOIE)
UNION ALL 
-----------------NOM VOIE FANTOIR (SANS BAN/LIASON VOIE)

(SELECT ad_code, ad_nomvoie FROM
(WITH parcelle_info_voie AS
(SELECT 
adresse.ad_code,
substring(pci.adresse,'([A-Z](.){1,255})') as ad_nomvoie
FROM rbal.bal_hsn_point_2154 adresse
LEFT JOIN pci70_edigeo_majic.parcelle_info AS pci ON st_within(adresse.geom,pci.geom)
WHERE (adresse.ad_numero IS NULL
OR adresse.nom_voie_relevee IS NULL)
AND pci.adresse IS NOT NULL
AND adresse.ad_ban_id IS NULL)
SELECT * FROM parcelle_info_voie WHERE ad_code NOT IN


(SELECT ad_code
FROM 
(WITH ban_liaisovoie AS
(
(SELECT 
	ad_code
	, ad_nomvoie 
	FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) 
		a.ad_code
		, b.id_ban
		, b.ad_nomvoie
	FROM 
		rbal.bal_hsn_point_2154 a
		, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1) AND ad_nomvoie IS NOT NULL
)
SELECT ad_code, ad_nomvoie
FROM nomvoie_ban_liaison)a)	

UNION ALL 

(
SELECT 
ad_code 
, ad_nomvoie
FROM 
(WITH nomvoie_liaison_voie AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban,
    nomvoie
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_voie_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1) and id_ban IS NULL AND nomvoie IS NOT NULL )
SELECT ad_code, id_ban as ad_ban_id, nomvoie as ad_nomvoie FROM nomvoie_liaison_voie)a


WHERE ad_code NOT IN 

(SELECT 
	ad_code
	 
	FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) 
		a.ad_code
		, b.id_ban
		, b.ad_nomvoie
	FROM 
		rbal.bal_hsn_point_2154 a
		, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1) AND ad_nomvoie IS NOT NULL
)
SELECT ad_code, ad_nomvoie
FROM nomvoie_ban_liaison)a)	

))
SELECT 
ad_code
, ad_nomvoie
FROM ban_liaisovoie)a
)

)a)

 

 
) 
SELECT * FROM ad_nomvoie)a)


 
-----------------NOM VOIE AVEC LIAISON VOIE SANS PCI (SANS BAN/LIASON VOIE )
UNION ALL 
-----------------NOM VOIE AVEC LIAISON VOIE SANS PCI (SANS BAN/LIASON VOIE)
	
	
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
	
WITH ad_nomvoie AS
(


(SELECT 
	ad_code
	, ad_nomvoie 
	FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) 
		a.ad_code
		, b.id_ban
		, b.ad_nomvoie
	FROM 
		rbal.bal_hsn_point_2154 a
		, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1) AND ad_nomvoie IS NOT NULL
)
SELECT ad_code, ad_nomvoie
FROM nomvoie_ban_liaison)a)	


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

(SELECT 
	ad_code
	 
	FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) 
		a.ad_code
		, b.id_ban
		, b.ad_nomvoie
	FROM 
		rbal.bal_hsn_point_2154 a
		, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1) AND ad_nomvoie IS NOT NULL
)
SELECT ad_code, ad_nomvoie
FROM nomvoie_ban_liaison)a)	

)


UNION ALL 


(SELECT ad_code, ad_nomvoie FROM
(WITH parcelle_info_voie AS
(SELECT 
adresse.ad_code,
substring(pci.adresse,'([A-Z](.){1,255})') as ad_nomvoie
FROM rbal.bal_hsn_point_2154 adresse
LEFT JOIN pci70_edigeo_majic.parcelle_info AS pci ON st_within(adresse.geom,pci.geom)
WHERE (adresse.ad_numero IS NULL
OR adresse.nom_voie_relevee IS NULL)
AND pci.adresse IS NOT NULL
AND adresse.ad_ban_id IS NULL)
SELECT * FROM parcelle_info_voie WHERE ad_code NOT IN


(SELECT ad_code
FROM 
(WITH ban_liaisovoie AS
(
(SELECT 
	ad_code
	, ad_nomvoie 
	FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) 
		a.ad_code
		, b.id_ban
		, b.ad_nomvoie
	FROM 
		rbal.bal_hsn_point_2154 a
		, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1) AND ad_nomvoie IS NOT NULL
)
SELECT ad_code, ad_nomvoie
FROM nomvoie_ban_liaison)a)	

UNION ALL 

(
SELECT 
ad_code 
, ad_nomvoie
FROM 
(WITH nomvoie_liaison_voie AS
(SELECT 
	DISTINCT ON (a.ad_code) a.ad_code,
	id_ban,
    nomvoie
	FROM rbal.bal_hsn_point_2154 a, rbal.liaison_voie_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1) and id_ban IS NULL AND nomvoie IS NOT NULL )
SELECT ad_code, id_ban as ad_ban_id, nomvoie as ad_nomvoie FROM nomvoie_liaison_voie)a


WHERE ad_code NOT IN 

(SELECT 
	ad_code
	 
	FROM 
(WITH nomvoie_ban_liaison AS
(SELECT 
	DISTINCT ON (a.ad_code) 
		a.ad_code
		, b.id_ban
		, b.ad_nomvoie
	FROM 
		rbal.bal_hsn_point_2154 a
		, rbal.liaison_hsn_linestring_2154 b
	WHERE ST_DWithin(a.geom, b.geom, 0.1) AND ad_nomvoie IS NOT NULL
)
SELECT ad_code, ad_nomvoie
FROM nomvoie_ban_liaison)a)	

))
SELECT 
ad_code
, ad_nomvoie
FROM ban_liaisovoie)a
)

)a)

 

 
) 
SELECT * FROM ad_nomvoie)a)
		

)



)
 
)a


