--===================================================================================================
-- TRIGGER t_noeud POUR Y METTRE chambre ET boite
--===================================================================================================

DELETE FROM gracethd_metis.t_noeud WHERE nd_type LIKE 'PT';

CREATE OR REPLACE FUNCTION fn_chambre_maj_t_noeud() 
RETURNS TRIGGER AS $$
BEGIN

	IF (TG_OP = 'DELETE') THEN

	    UPDATE gracethd_metis.t_noeud
		SET 
			nd_abddate = now();
		RETURN OLD;

	ELSIF (TG_OP = 'UPDATE') THEN

	    DELETE FROM gracethd_metis.t_noeud tn
		WHERE tn.geom = OLD.geom;
	    
	    INSERT INTO gracethd_metis.t_noeud (
	    	nd_code
	    	, nd_type
	    	, nd_r1_code
	    	, nd_r2_code
	    	, nd_r3_code
	    	, nd_geolsrc
	    	, nd_creadat
	    	, nd_majdate
	    	, geom
	    	)
	    WITH new_ch AS (

	    	SELECT
	    		NEW.geom AS geom
	    		, OLD.nd_creadat AS nd_creadat
	    )
	    SELECT 
	    	nd_code
	    	, nd_type
	    	, nd_r1_code
	    	, nd_r2_code
	    	, nd_r3_code
	    	, nd_geolsrc
	    	, nd_creadat
	    	, now() AS nd_majdate
	    	, NEW.geom
	    FROM 
	    	(WITH ch_noeud AS (

	    	SELECT
	    		concat(
	    			'ND700',concat(b.digt_6, b.digt_7, '00') 
	    			, to_char(ROW_NUMBER() OVER (PARTITION BY concat(b.digt_6, b.digt_7, '00') ) 
	    				-- ID max de nd_code + 1
	    				+ (select max(substring(nd_code, 10, 5)::int)+1 from gracethd_metis.t_noeud)
	    			, 'FM00000')
	    		) as nd_code
	    		, 'PT' AS nd_type
	    		, 'DP70' AS nd_r1_code
	    		, code_nro_def AS nd_r2_code
	    		, '' AS nd_r3_code
	    		,'PSD'::varchar AS nd_geolsrc
	    		, now() AS nd_creadat
	    		, new_ch.geom
	    	FROM 
	    		new_ch 
	    		, psd_orange.zanro_hsn_polygon_2154 b
	    	WHERE ST_CONTAINS (b.geom, new_ch.geom)
	    	)

	    	SELECT
	    		nd_code
	    		, nd_type
	    		, nd_r1_code
	    		, nd_r2_code
	    		, nd_r3_code
	    		, nd_geolsrc
	    		, nd_creadat
	    		, geom
	    	FROM ch_noeud)new_ch;
	    RETURN NEW;

	ELSIF (TG_OP = 'INSERT') THEN
		INSERT INTO gracethd_metis.t_noeud (
			nd_code
			, nd_type
			, nd_r1_code
			, nd_r2_code
			, nd_r3_code
			, nd_geolsrc
			, nd_creadat
			, geom
			)
		WITH new_ch AS (

			SELECT
				NEW.geom AS geom
		)
		SELECT 
			nd_code
			, nd_type
			, nd_r1_code
			, nd_r2_code
			, nd_r3_code
			, nd_geolsrc
			, nd_creadat
			, NEW.geom
		FROM 
			(WITH ch_noeud AS (

			SELECT
				concat(
					'ND700',concat(b.digt_6, b.digt_7, '00') 
					, to_char(ROW_NUMBER() OVER (PARTITION BY concat(b.digt_6, b.digt_7, '00') ) 
						-- ID max de nd_code + 1
						+ (select max(substring(nd_code, 10, 5)::int)+1 from gracethd_metis.t_noeud)
					, 'FM00000')
				) as nd_code
				, 'PT' AS nd_type
				, 'DP70' AS nd_r1_code
				, code_nro_def AS nd_r2_code
				, '' AS nd_r3_code
				,'PSD'::varchar AS nd_geolsrc
				, now() AS nd_creadat
				, new_ch.geom
			FROM new_ch , psd_orange.zanro_hsn_polygon_2154 b
			WHERE ST_CONTAINS (b.geom, new_ch.geom)
			)

			SELECT
				nd_code
				, nd_type
				, nd_r1_code
				, nd_r2_code
				, nd_r3_code
				, nd_geolsrc
				, nd_creadat
				, geom
			FROM ch_noeud)new_ch;
		RETURN NEW;
	END IF;
-- RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_chambre_maj_t_noeud ON avp_n070gay.ft_chambre;
CREATE TRIGGER trg_chambre_maj_t_noeud 
	BEFORE INSERT OR UPDATE OR DELETE ON avp_n070gay.ft_chambre
	FOR EACH ROW EXECUTE PROCEDURE fn_chambre_maj_t_noeud();

