-- ALTER TABLE test_vu.ch_test ADD COLUMN maj TIMESTAMP
-- CREATE VIEW test_vu.vu_test AS
-- SELECT * FROM test_vu.ch_test

-- CREATE TABLE test_vu.t_test AS 
-- SELECT * FROM test_vu.ch_test

DROP TRIGGER IF EXISTS tg ON test_vu.ch_test CASCADE;
DROP FUNCTION IF EXISTS fn() CASCADE;

CREATE OR REPLACE FUNCTION fn()
RETURNS TRIGGER AS $$
  BEGIN
    IF TG_OP = 'INSERT' THEN
      INSERT INTO test_vu.t_test (id, att, maj, geom)
        SELECT
          id
          , att
          , maj
          , geom 
        FROM test_vu.vu_test v
        WHERE v.id = NEW.id;
        
      RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
      IF OLD.att IS DISTINCT FROM NEW.att 
        THEN UPDATE test_vu.t_test t
        SET 
          att = (
              SELECT
                v.att
              FROM test_vu.vu_test v
              WHERE NEW.id = v.id
            )
          , maj = now()
        WHERE t.id = (SELECT v.id FROM test_vu.vu_test v WHERE NEW.id = v.id);
      END IF;

      IF OLD.geom IS DISTINCT FROM NEW.geom
        THEN UPDATE test_vu.t_test t
        SET geom = (
            SELECT
              v.geom
            FROM test_vu.vu_test v
            WHERE NEW.id = v.id
          )
          , maj = now()
        WHERE t.id = (SELECT v.id FROM test_vu.vu_test v WHERE NEW.id = v.id);
      END IF;
      RETURN NEW;

  
    END IF;
  END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER tg
    AFTER INSERT OR UPDATE OR DELETE ON
      test_vu.ch_test FOR EACH ROW 
      EXECUTE PROCEDURE fn();


DROP TRIGGER IF EXISTS tg_del ON test_vu.ch_test CASCADE;
DROP FUNCTION IF EXISTS fn_del() CASCADE;

CREATE OR REPLACE FUNCTION fn_del()
RETURNS TRIGGER AS $$
  BEGIN
    UPDATE test_vu.t_test t
      SET 
        maj = now()
        WHERE t.id = (SELECT v.id FROM test_vu.vu_test v WHERE OLD.id = v.id);
      RETURN NULL;
  END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER tg_del
    BEFORE DELETE ON 
      test_vu.ch_test FOR EACH ROW 
      EXECUTE PROCEDURE fn_del();




---------------------------------------------------------------------------------------------------------
-- TEST SUR VRAIE DONNEES
---------------------------------------------------------------------------------------------------------
