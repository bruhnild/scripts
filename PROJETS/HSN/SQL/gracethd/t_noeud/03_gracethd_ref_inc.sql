/*
-------------------------------------------------------------------------------------

Date de création : 20/07/2018
Objet : Système d'attribution des codes noeuds
Modification : Nom : ///// - Date : date_de_modif - Motif/nature : //////

-------------------------------------------------------------------------------------
*/

--================================================
--1. Table de référence gracethd_metis.code_noeud
--================================================

DROP TABLE IF EXISTS gracethd_metis.code_noeud;
CREATE TABLE gracethd_metis.code_noeud AS
SELECT 
	s::int AS val
	, json_object('{0101,null,0102,null,0103,null,0104,null,0201,null,0202,null,0203,null,0204,null,0205,null,0206,null,0207,null,0208,null,0209,null,0210,null,0211,null,0212,null,0213,null,0214,null,0215,null,0216,null,0217,null,0218,null,0219,null,0220,null,0221,null,0222,null,0223,null,0224,null,0225,null,0226,null,0315,null,0316,null,0317,null,0318,null,0319,null,0320,null,0321,null,0309,null,0310,null,0311,null,0312,null,0313,null,0314,null,0301,null,0302,null,0303,null,0304,null,0305,null,0306,null,0307,null,0308,null,0401,null,0402,null,0403,null,0404,null,0405,null,0406,null,0407,null,0408,null,0409,null,0410,null,0411,null,0412,null,0413,null,0414,null,0415,null,0416,null,0417,null,0418,null,0419,null,0420,null,0421,null,0422,null,0508,null,0509,null,0510,null,0511,null,0512,null,0513,null,0514,null,0501,null,0502,null,0503,null,0504,null,0505,null,0506,null,0507,null,0515,null,0601,null,0602,null,0603,null,0604,null,0605,null,0701,null,0702,null,0703,null,0704,null,0705,null,0706,null,0707,null,0801,null,0802,null,0803,null,0901,null,0902,null,0903,null,0904,null,0905,null,0906,null,0907,null,0908,null,1001,null,1002,null,1003,null,1004,null,1005,null,1006,null,1007,null,1008,null,1101,null,1102,null,1103,null,1104,null,1105,null,1201,null,1202,null,1203,null,1204,null,1205,null,1206,null,1207,null,1208,null,1209,null,1210,null,1301,null,1302,null,1303,null,1304,null}')::jsonb AS ref
FROM generate_series(152, 99999, 1) AS s;

COMMENT ON TABLE gracethd_metis.code_noeud IS 'Table intermédiaire d''attribution des codes de noeuds';

CREATE INDEX idx ON gracethd_metis.code_noeud USING gin(ref);


--================================================
--2. Table des objets métier gracethd_metis.code_metier
--================================================

DROP TABLE IF EXISTS code_metier;
CREATE TABLE code_metier (
	id serial
	, ref text);

INSERT INTO code_metier
SELECT 
st_code
FROM gracethd_metis.t_sitetech 
UNION ALL
(
	SELECT 
	sf_code
	FROM gracethd_metis.t_suf
);

--================================================
--3. Trigger sur la màj du code_metier
--================================================

CREATE OR REPLACE FUNCTION update_code_noeud()

	RETURNS TRIGGER
	LANGUAGE plpgsql
	AS $$
BEGIN

	UPDATE code_noeud
	SET ref = 
		jsonb_set(
			ref
			, concat('{'
				, substring(NEW.ref, 4,2)
				,'}')::text[]
			, to_jsonb(NEW.ref::text)
		) 
	WHERE val = 
		(
			select min(val) from code_noeud
			where ref-> substring(NEW.ref, 4,2)::text = 'null'
		);

	RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS create_ref ON code_metier;
CREATE TRIGGER create_ref
	BEFORE INSERT
	ON code_metier
	FOR EACH ROW
	EXECUTE PROCEDURE update_code_noeud();


