
/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 30/05/2017
Objet : Permet de mettre à jour les noms des attributs dans les champs selon règles de nommages CIRCET
Modifications : Nom : // - Date :  //- Motif/nature : //
-------------------------------------------------------------------------------------
*/
/*
TEMPS DE TRAITEMENT TOTAL : 48 secondes
*/

--- Schema : covage
--- Table : infrastructures_renommage

/* mise à jour champ id_troncon */
ALTER TABLE covage.infrastructures_renommage DROP COLUMN IF EXISTS codinf;
ALTER TABLE covage.infrastructures_renommage ADD COLUMN codinf VARCHAR;
ALTER TABLE covage.infrastructures_renommage DROP COLUMN IF EXISTS idtroncon;
ALTER TABLE covage.infrastructures_renommage ADD COLUMN idtroncon VARCHAR;

UPDATE covage.infrastructures_renommage
SET idtroncon = (CASE id_tronc
              WHEN 'LCR1' THEN 'A_S8'
        ELSE id_tronc
              END);
              
/* mise à jour champ code_inf */
UPDATE covage.infrastructures_renommage
SET codinf = null;

--- séquences d'incrémentations par type d'id tronçon 
DROP SEQUENCE IF EXISTS covage.incrementation;
CREATE SEQUENCE covage.incrementation
  INCREMENT 1
  MINVALUE 0000
  MAXVALUE 9999
  START 1
  CACHE 1;
ALTER TABLE covage.incrementation OWNER TO postgres;


CREATE OR REPLACE FUNCTION
nextval_special()
RETURNS TEXT
LANGUAGE sql
AS
$$
    SELECT to_char(nextval('covage.incrementation'), 'FM0000'); 
$$;

--- concaténation du champ codinf et de la séquence d'incrémentation
UPDATE covage.infrastructures_renommage  SET codinf = concat('GL-INF-320_',nextval_special())
WHERE idtroncon = 'A_S8';


DROP SEQUENCE IF EXISTS covage.incrementation;
CREATE SEQUENCE covage.incrementation
  INCREMENT 1
  MINVALUE 0000
  MAXVALUE 9999
  START 1
  CACHE 1;
ALTER TABLE covage.incrementation OWNER TO postgres;


CREATE OR REPLACE FUNCTION
nextval_special()
RETURNS TEXT
LANGUAGE sql
AS
$$
    SELECT to_char(nextval('covage.incrementation'), 'FM0000'); 
$$;

--- concaténation du champ codinf et de la séquence d'incrémentation
UPDATE covage.infrastructures_renommage  SET codinf = concat('GL-INF-108_',nextval_special())
WHERE idtroncon = 'S8';


DROP SEQUENCE IF EXISTS covage.incrementation;
CREATE SEQUENCE covage.incrementation
  INCREMENT 1
  MINVALUE 0000
  MAXVALUE 9999
  START 1
  CACHE 1;
ALTER TABLE covage.incrementation OWNER TO postgres;


CREATE OR REPLACE FUNCTION
nextval_special()
RETURNS TEXT
LANGUAGE sql
AS
$$
    SELECT to_char(nextval('covage.incrementation'), 'FM0000'); 
$$;

--- concaténation du champ codinf et de la séquence d'incrémentation
UPDATE covage.infrastructures_renommage  SET codinf = concat('GL-INF-107_',nextval_special())
WHERE idtroncon = 'S7';


DROP SEQUENCE IF EXISTS covage.incrementation;
CREATE SEQUENCE covage.incrementation
  INCREMENT 1
  MINVALUE 0000
  MAXVALUE 9999
  START 1
  CACHE 1;
ALTER TABLE covage.incrementation OWNER TO postgres;


CREATE OR REPLACE FUNCTION
nextval_special()
RETURNS TEXT
LANGUAGE sql
AS
$$
    SELECT to_char(nextval('covage.incrementation'), 'FM0000'); 
$$;

--- concaténation du champ codinf et de la séquence d'incrémentation
UPDATE covage.infrastructures_renommage  SET codinf = concat('GL-INF-228_',nextval_special())
WHERE idtroncon = 'R28';


--- Schema : covage
--- Table : points_techniques_renommage

/* mise à jour champ id_troncon */
ALTER TABLE covage.points_techniques_renommage DROP COLUMN IF EXISTS codcov;
ALTER TABLE covage.points_techniques_renommage ADD COLUMN codcov VARCHAR;
ALTER TABLE covage.points_techniques_renommage DROP COLUMN IF EXISTS idtroncon;
ALTER TABLE covage.points_techniques_renommage ADD COLUMN idtroncon VARCHAR;

UPDATE covage.points_techniques_renommage
SET idtroncon = (CASE id_tronc
              WHEN 'LCR1' THEN 'A_S8'
        ELSE id_tronc
              END);

/* mise à jour codcov et incrémentation  */

--- séquences d'incrémentations par type d'id tronçon 
DROP SEQUENCE IF EXISTS covage.incrementation;
CREATE SEQUENCE covage.incrementation
  INCREMENT 1
  MINVALUE 0000
  MAXVALUE 9999
  START 1
  CACHE 1;
ALTER TABLE covage.incrementation OWNER TO postgres;


CREATE OR REPLACE FUNCTION
nextval_special()
RETURNS TEXT
LANGUAGE sql
AS
$$
    SELECT to_char(nextval('covage.incrementation'), 'FM0000'); 
$$;

--- concaténation du champ codcov et de la séquence d'incrémentation
UPDATE covage.points_techniques_renommage  SET codcov = concat('GL-CH-320_',nextval_special())
WHERE idtroncon = 'A_S8';

DROP SEQUENCE IF EXISTS covage.incrementation;
CREATE SEQUENCE covage.incrementation
  INCREMENT 1
  MINVALUE 0000
  MAXVALUE 9999
  START 1
  CACHE 1;
ALTER TABLE covage.incrementation OWNER TO postgres;


CREATE OR REPLACE FUNCTION
nextval_special()
RETURNS TEXT
LANGUAGE sql
AS
$$
    SELECT to_char(nextval('covage.incrementation'), 'FM0000'); 
$$;

--- concaténation du champ codcov et de la séquence d'incrémentation
UPDATE covage.points_techniques_renommage  SET codcov = concat('GL-CH-108_',nextval_special())
WHERE idtroncon = 'S8';



DROP SEQUENCE IF EXISTS covage.incrementation;
CREATE SEQUENCE covage.incrementation
  INCREMENT 1
  MINVALUE 0000
  MAXVALUE 9999
  START 1
  CACHE 1;
ALTER TABLE covage.incrementation OWNER TO postgres;


CREATE OR REPLACE FUNCTION
nextval_special()
RETURNS TEXT
LANGUAGE sql
AS
$$
    SELECT to_char(nextval('covage.incrementation'), 'FM0000'); 
$$;


--- concaténation du champ codcov et de la séquence d'incrémentation
UPDATE covage.points_techniques_renommage  SET codcov = concat('GL-CH-107_',nextval_special())
WHERE idtroncon = 'S7';

DROP SEQUENCE IF EXISTS covage.incrementation;
CREATE SEQUENCE covage.incrementation
  INCREMENT 1
  MINVALUE 0000
  MAXVALUE 9999
  START 1
  CACHE 1;
ALTER TABLE covage.incrementation OWNER TO postgres;


CREATE OR REPLACE FUNCTION
nextval_special()
RETURNS TEXT
LANGUAGE sql
AS
$$
    SELECT to_char(nextval('covage.incrementation'), 'FM0000'); 
$$;

--- concaténation du champ codcov et de la séquence d'incrémentation
UPDATE covage.points_techniques_renommage  SET codcov = concat('GL-CH-228_',nextval_special())
WHERE idtroncon = 'R28';

DROP SEQUENCE IF EXISTS covage.incrementation;
CREATE SEQUENCE covage.incrementation
  INCREMENT 1
  MINVALUE 0000
  MAXVALUE 9999
  START 1
  CACHE 1;
ALTER TABLE covage.incrementation OWNER TO postgres;


CREATE OR REPLACE FUNCTION
nextval_special()
RETURNS TEXT
LANGUAGE sql
AS
$$
    SELECT to_char(nextval('covage.incrementation'), 'FM0000'); 
$$;

--- concaténation du champ codcov et de la séquence d'incrémentation
UPDATE covage.points_techniques_renommage  SET codcov = concat('GL-POT-320_',nextval_special())
WHERE idtroncon = 'A_S8' AND code_cov LIKE 'GL-PO%';


--- Schema : covage
--- Table : boitiers_renommage

/* mise à jour champ id_troncon */
ALTER TABLE covage.boitiers_renommage DROP COLUMN IF EXISTS codbpe;
ALTER TABLE covage.boitiers_renommage ADD COLUMN codbpe VARCHAR;
ALTER TABLE covage.boitiers_renommage DROP COLUMN IF EXISTS idtroncon;
ALTER TABLE covage.boitiers_renommage ADD COLUMN idtroncon VARCHAR;

UPDATE covage.boitiers_renommage
SET idtroncon = (CASE id_tronc
              WHEN 'LCR1' THEN 'A_S8'
        ELSE id_tronc
              END);

                  
/* mise à jour codbpe et incrémentation  */
UPDATE covage.boitiers_renommage as a 
SET codbpe = codcov
FROM covage.points_techniques_renommage as b 

WHERE ST_Intersects(st_buffer(b.geom,3),a.geom)
;

UPDATE covage.boitiers_renommage
SET codbpe = 
    (CASE 
    WHEN codbpe LIKE 'GL-CH%' THEN REPLACE(codbpe, 'GL-CH', 'GL-BP01')
    ELSE REPLACE (codbpe, 'GL-POT', 'GL-BP01')
    END);


--- Schema : covage
--- Table : cables_renommage

/* mise à jour champ id_troncon */
ALTER TABLE covage.cables_renommage DROP COLUMN IF EXISTS codcb;
ALTER TABLE covage.cables_renommage ADD COLUMN codcb VARCHAR;
ALTER TABLE covage.cables_renommage DROP COLUMN IF EXISTS idtroncon;
ALTER TABLE covage.cables_renommage ADD COLUMN idtroncon VARCHAR;

UPDATE covage.cables_renommage
SET idtroncon = (CASE id_tronc
              WHEN 'LCR1' THEN 'A_S8'
        ELSE id_tronc
              END);
              
/* mise à jour codcb et incrémentation  */

UPDATE covage.cables_renommage
SET codcb = 
  (CASE
  WHEN id_tronc LIKE 'A_S8' THEN code_cb
  WHEN id_tronc LIKE 'S8' THEN code_cb
  WHEN id_tronc LIKE 'S7' THEN code_cb
  WHEN id_tronc LIKE 'R28' THEN code_cb
  END);

UPDATE covage.cables_renommage
SET codcb = code_cb WHERE id_tronc LIKE 'LCR1';

UPDATE covage.cables_renommage
SET codcb =
substring(codcb from '(GL-.*-).*_.*') ||
right('00000' || CAST(substring(codcb from 'GL-.*-(.*)_.*') AS INTEGER) + 32, 5) ||
substring(codcb from 'GL-.*-.*(_.*)') WHERE id_tronc LIKE 'LCR1';



/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 30/05/2017
Objet : Permet de mettre à jour les noms des attributs dans les champs selon règles de nommages CIRCET
Modifications : Nom : // - Date :  //- Motif/nature : //
-------------------------------------------------------------------------------------
*/

/*
TEMPS DE TRAITEMENT TOTAL : 48 secondes
*/

--- Schema : covage
--- Table : infrastructures_renommage

/* mise à jour champ id_troncon */
ALTER TABLE covage.infrastructures_renommage DROP COLUMN IF EXISTS codinf;
ALTER TABLE covage.infrastructures_renommage ADD COLUMN codinf VARCHAR;
ALTER TABLE covage.infrastructures_renommage DROP COLUMN IF EXISTS idtroncon;
ALTER TABLE covage.infrastructures_renommage ADD COLUMN idtroncon VARCHAR;

UPDATE covage.infrastructures_renommage
SET idtroncon = (CASE id_tronc
              WHEN 'LCR1' THEN 'A_S8'
        ELSE id_tronc
              END);
              
/* mise à jour champ code_inf */
UPDATE covage.infrastructures_renommage
SET codinf = null;

DROP SEQUENCE IF EXISTS covage.incrementation;
CREATE SEQUENCE covage.incrementation
  INCREMENT 1
  MINVALUE 0000
  MAXVALUE 9999
  START 1
  CACHE 1;
ALTER TABLE covage.incrementation OWNER TO postgres;


CREATE OR REPLACE FUNCTION
nextval_special()
RETURNS TEXT
LANGUAGE sql
AS
$$
    SELECT to_char(nextval('covage.incrementation'), 'FM0000'); 
$$;

--- concaténation du champ codinf et de la séquence d'incrémentation
UPDATE covage.infrastructures_renommage  SET codinf = concat('GL-INF-320_',nextval_special())
WHERE idtroncon = 'A_S8';


DROP SEQUENCE IF EXISTS covage.incrementation;
CREATE SEQUENCE covage.incrementation
  INCREMENT 1
  MINVALUE 0000
  MAXVALUE 9999
  START 1
  CACHE 1;
ALTER TABLE covage.incrementation OWNER TO postgres;


CREATE OR REPLACE FUNCTION
nextval_special()
RETURNS TEXT
LANGUAGE sql
AS
$$
    SELECT to_char(nextval('covage.incrementation'), 'FM0000'); 
$$;

--- concaténation du champ codinf et de la séquence d'incrémentation
UPDATE covage.infrastructures_renommage  SET codinf = concat('GL-INF-108_',nextval_special())
WHERE idtroncon = 'S8';


DROP SEQUENCE IF EXISTS covage.incrementation;
CREATE SEQUENCE covage.incrementation
  INCREMENT 1
  MINVALUE 0000
  MAXVALUE 9999
  START 1
  CACHE 1;
ALTER TABLE covage.incrementation OWNER TO postgres;


CREATE OR REPLACE FUNCTION
nextval_special()
RETURNS TEXT
LANGUAGE sql
AS
$$
    SELECT to_char(nextval('covage.incrementation'), 'FM0000'); 
$$;

--- concaténation du champ codinf et de la séquence d'incrémentation
UPDATE covage.infrastructures_renommage  SET codinf = concat('GL-INF-107_',nextval_special())
WHERE idtroncon = 'S7';


DROP SEQUENCE IF EXISTS covage.incrementation;
CREATE SEQUENCE covage.incrementation
  INCREMENT 1
  MINVALUE 0000
  MAXVALUE 9999
  START 1
  CACHE 1;
ALTER TABLE covage.incrementation OWNER TO postgres;


CREATE OR REPLACE FUNCTION
nextval_special()
RETURNS TEXT
LANGUAGE sql
AS
$$
    SELECT to_char(nextval('covage.incrementation'), 'FM0000'); 
$$;

--- concaténation du champ codinf et de la séquence d'incrémentation
UPDATE covage.infrastructures_renommage  SET codinf = concat('GL-INF-228_',nextval_special())
WHERE idtroncon = 'R28';


--- Schema : covage
--- Table : points_techniques_renommage

/* mise à jour champ id_troncon */
ALTER TABLE covage.points_techniques_renommage DROP COLUMN IF EXISTS codcov;
ALTER TABLE covage.points_techniques_renommage ADD COLUMN codcov VARCHAR;
ALTER TABLE covage.points_techniques_renommage DROP COLUMN IF EXISTS idtroncon;
ALTER TABLE covage.points_techniques_renommage ADD COLUMN idtroncon VARCHAR;

UPDATE covage.points_techniques_renommage
SET idtroncon = (CASE id_tronc
              WHEN 'LCR1' THEN 'A_S8'
        ELSE id_tronc
              END);

/* mise à jour codcov et incrémentation  */
DROP SEQUENCE IF EXISTS covage.incrementation;
CREATE SEQUENCE covage.incrementation
  INCREMENT 1
  MINVALUE 0000
  MAXVALUE 9999
  START 1
  CACHE 1;
ALTER TABLE covage.incrementation OWNER TO postgres;


CREATE OR REPLACE FUNCTION
nextval_special()
RETURNS TEXT
LANGUAGE sql
AS
$$
    SELECT to_char(nextval('covage.incrementation'), 'FM0000'); 
$$;


UPDATE covage.points_techniques_renommage  SET codcov = concat('GL-CH-320_',nextval_special())
WHERE idtroncon = 'A_S8';

DROP SEQUENCE IF EXISTS covage.incrementation;
CREATE SEQUENCE covage.incrementation
  INCREMENT 1
  MINVALUE 0000
  MAXVALUE 9999
  START 1
  CACHE 1;
ALTER TABLE covage.incrementation OWNER TO postgres;


CREATE OR REPLACE FUNCTION
nextval_special()
RETURNS TEXT
LANGUAGE sql
AS
$$
    SELECT to_char(nextval('covage.incrementation'), 'FM0000'); 
$$;

--- concaténation du champ codcov et de la séquence d'incrémentation
UPDATE covage.points_techniques_renommage  SET codcov = concat('GL-CH-108_',nextval_special())
WHERE idtroncon = 'S8';



DROP SEQUENCE IF EXISTS covage.incrementation;
CREATE SEQUENCE covage.incrementation
  INCREMENT 1
  MINVALUE 0000
  MAXVALUE 9999
  START 1
  CACHE 1;
ALTER TABLE covage.incrementation OWNER TO postgres;


CREATE OR REPLACE FUNCTION
nextval_special()
RETURNS TEXT
LANGUAGE sql
AS
$$
    SELECT to_char(nextval('covage.incrementation'), 'FM0000'); 
$$;

--- concaténation du champ codcov et de la séquence d'incrémentation
UPDATE covage.points_techniques_renommage  SET codcov = concat('GL-CH-107_',nextval_special())
WHERE idtroncon = 'S7';

DROP SEQUENCE IF EXISTS covage.incrementation;
CREATE SEQUENCE covage.incrementation
  INCREMENT 1
  MINVALUE 0000
  MAXVALUE 9999
  START 1
  CACHE 1;
ALTER TABLE covage.incrementation OWNER TO postgres;


CREATE OR REPLACE FUNCTION
nextval_special()
RETURNS TEXT
LANGUAGE sql
AS
$$
    SELECT to_char(nextval('covage.incrementation'), 'FM0000'); 
$$;

--- concaténation du champ codcov et de la séquence d'incrémentation
UPDATE covage.points_techniques_renommage  SET codcov = concat('GL-CH-228_',nextval_special())
WHERE idtroncon = 'R28';

DROP SEQUENCE IF EXISTS covage.incrementation;
CREATE SEQUENCE covage.incrementation
  INCREMENT 1
  MINVALUE 0000
  MAXVALUE 9999
  START 1
  CACHE 1;
ALTER TABLE covage.incrementation OWNER TO postgres;


CREATE OR REPLACE FUNCTION
nextval_special()
RETURNS TEXT
LANGUAGE sql
AS
$$
    SELECT to_char(nextval('covage.incrementation'), 'FM0000'); 
$$;

--- concaténation du champ codcov et de la séquence d'incrémentation
UPDATE covage.points_techniques_renommage  SET codcov = concat('GL-POT-320_',nextval_special())
WHERE idtroncon = 'A_S8' AND code_cov LIKE 'GL-PO%'
;


--- Schema : covage
--- Table : boitiers_renommage

/* mise à jour champ id_troncon */
ALTER TABLE covage.boitiers_renommage DROP COLUMN IF EXISTS codbpe;
ALTER TABLE covage.boitiers_renommage ADD COLUMN codbpe VARCHAR;
ALTER TABLE covage.boitiers_renommage DROP COLUMN IF EXISTS idtroncon;
ALTER TABLE covage.boitiers_renommage ADD COLUMN idtroncon VARCHAR;

UPDATE covage.boitiers_renommage
SET idtroncon = (CASE id_tronc
              WHEN 'LCR1' THEN 'A_S8'
        ELSE id_tronc
              END);

                  
/* mise à jour codbpe et incrémentation  */
UPDATE covage.boitiers_renommage as a 
SET codbpe = codcov
FROM covage.points_techniques_renommage as b 

WHERE ST_Intersects(st_buffer(b.geom,3),a.geom)
;

UPDATE covage.boitiers_renommage
SET codbpe = 
    (CASE 
    WHEN codbpe LIKE 'GL-CH%' THEN REPLACE(codbpe, 'GL-CH', 'GL-BP01')
    ELSE REPLACE (codbpe, 'GL-POT', 'GL-BP01')
    END);


--- Schema : covage
--- Table : cables_renommage

/* mise à jour champ id_troncon */
ALTER TABLE covage.cables_renommage DROP COLUMN IF EXISTS codcb;
ALTER TABLE covage.cables_renommage ADD COLUMN codcb VARCHAR;
ALTER TABLE covage.cables_renommage DROP COLUMN IF EXISTS idtroncon;
ALTER TABLE covage.cables_renommage ADD COLUMN idtroncon VARCHAR;

UPDATE covage.cables_renommage
SET idtroncon = (CASE id_tronc
              WHEN 'LCR1' THEN 'A_S8'
        ELSE id_tronc
              END);
              
/* mise à jour codcb et incrémentation  */

--- synchronisation des codes cb pour tous type de cable sauf LCR1
UPDATE covage.cables_renommage
SET codcb = 
  (CASE
  WHEN id_tronc LIKE 'A_S8' THEN code_cb
  WHEN id_tronc LIKE 'S8' THEN code_cb
  WHEN id_tronc LIKE 'S7' THEN code_cb
  WHEN id_tronc LIKE 'R28' THEN code_cb
  END);

--- concaténation à 5 chiffres à partir de 32 sans toucher au sections de cables (deuxième incrémentation : _01, _02, _03, _04, etc)
UPDATE covage.cables_renommage
SET codcb = code_cb WHERE id_tronc LIKE 'LCR1';

UPDATE covage.cables_renommage
SET codcb =
substring(codcb from '(GL-.*-).*_.*') ||
right('00000' || CAST(substring(codcb from 'GL-.*-(.*)_.*') AS INTEGER) + 32, 5) ||
substring(codcb from 'GL-.*-.*(_.*)') WHERE id_tronc LIKE 'LCR1';


/* report des origines/extrémités de bpe dans les cables */
ALTER TABLE covage.cables_renommage DROP COLUMN IF EXISTS start_point;
SELECT AddGeometryColumn ('covage','cables_renommage','start_point',2154,'POINT',2);
UPDATE covage.cables_renommage SET start_point = ST_StartPoint(geom);
ALTER TABLE covage.cables_renommage DROP COLUMN IF EXISTS end_point;
SELECT AddGeometryColumn ('covage','cables_renommage','end_point',2154,'POINT',2);
UPDATE covage.cables_renommage SET end_point = ST_EndPoint(geom);

UPDATE covage.cables_renommage as a
   SET origine=b.codbpe
   FROM covage.boitiers_renommage as b 
   where st_intersects (a.start_point, st_buffer(b.geom, 2))
   ;

UPDATE covage.cables_renommage as a
   SET extremite=b.codbpe
   FROM covage.boitiers_renommage as b 
   where st_intersects (a.end_point, st_buffer(b.geom, 2))
;
