
--- Schema : cadastre
--- Table : parcelles

SELECT AddGeometryColumn ('cadastre','parcelles','centroide',2154,'POINT',2);
UPDATE cadastre.parcelles SET centroide = ST_PointOnSurface(geom);

--- Schema : convention
--- Table : tableur

DROP TABLE IF EXISTS convention.tableur;
CREATE TABLE conventions.tableur
(
  id integer NOT NULL,	
  commune character varying(100) NOT NULL ,
  ref_cad character varying(100) NOT NULL ,
  sect_parc character varying(100) NOT NULL ,
  plan_parc character varying(100) NOT NULL ,
  CONSTRAINT cable_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE conventions.tableur
  OWNER TO postgres;

--- Schema : pm160_conventions
--- Table : parcelles

CREATE OR REPLACE VIEW pm160_conventions.parcelles AS 
SELECT a.id, a.geom, objectid_1, a.objectid, ccodep, ccodir, ccocom, ccopre, 
       ccosec, section, a.parcelle, codcomm, feuille, ident, codeident, 
       surface, dsrpar, idprop, dateacte, dreflf, pdl, cprsecr, ccoseccr, 
       dnuplar, idparpdl, numpdl, urbain, dparpi, ccoarp, figplan, batie, 
       ndeb, sdeb, ccovoi, rivoli, ccocif, ssurf, ssurfb, scos, nonrej, 
       shape_leng, shape_area, shape_len, centroide
FROM cadastre.parcelles as a
JOIN pm160_conventions.conventions as b
ON ST_CONTAINS (a.geom , b.geom)
;

--- Schema : pm160_conventions
--- Table : parcelles

CREATE OR REPLACE VIEW pm162_conventions.parcelles AS 
SELECT a.id, a.geom, objectid_1, a.objectid, ccodep, ccodir, ccocom, ccopre, 
       ccosec, section, a.parcelle, codcomm, feuille, ident, codeident, 
       surface, dsrpar, idprop, dateacte, dreflf, pdl, cprsecr, ccoseccr, 
       dnuplar, idparpdl, numpdl, urbain, dparpi, ccoarp, figplan, batie, 
       ndeb, sdeb, ccovoi, rivoli, ccocif, ssurf, ssurfb, scos, nonrej, 
       shape_leng, shape_area, shape_len, centroide
FROM cadastre.parcelles as a
JOIN pm162_conventions.conventions as b
ON ST_CONTAINS (a.geom , b.geom)
;
