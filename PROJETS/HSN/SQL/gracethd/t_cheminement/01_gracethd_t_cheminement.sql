--- Schema : gracethd_metis
--- Table : t_cheminement
--- Traitement : Initialise la table t_cheminement à partir de orange.ft_arciti_hsn_linestring_2154

TRUNCATE gracethd_metis.t_cheminement CASCADE;

INSERT INTO gracethd_metis.t_cheminement ( 
	cm_code
	-- , cm_ndcode1
	-- , cm_ndcode2
	, cm_typ_imp
	, cm_mod_pos
	, cm_long
	, cm_creadat
	, geom
)
SELECT
	concat('CM700', digt_6, digt_7, digt_8, digt_9, to_char(id, 'FM00000')) AS cm_code --cm_code VARCHAR(254) NOT NULL  ,
	-- , ST_AsText(ST_StartPoint(geom) AS cm_ndcode1 -- PTECH -> 'PT' t_noeud(nd_code),
	-- , AS cm_ndcode2 -- PTECH -> 'PT'  t_noeud(nd_code),
	, mode_pose AS cm_typ_imp --	cm_typ_imp VARCHAR(2)   REFERENCES l_implantation_type (code),
	, 'NC' AS cm_mod_pos --	Non communiqué (?),
	, ST_LENGTH(geom)::NUMERIC(8,2) AS cm_long
	, now() AS cm_creadat
	, geom
FROM orange.ft_arciti_hsn_linestring_2154