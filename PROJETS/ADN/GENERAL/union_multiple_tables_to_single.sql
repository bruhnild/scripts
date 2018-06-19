/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 28032017
Objet : Fonction d'union de tables
Modification : Nom : ///// - Date : date_de_modif - Motif/nature : //////

Prerequis:

- Schéma "temp"
- Des couches vecteur postgres/postgis  dans le schéma temp

@ECHO OFF
cd C:\OSGeo4W64\bin\
for %%f in (C:\Users\jean-Noel-11\Desktop\temp\shp\*.shp) do ogr2ogr -skipfailures --config PGCLIENTENCODING UTF8 -lco "OVERWRITE=YES" -lco SCHEMA=ep -f "PostgreSQL" PG:"host=localhost user=postgres password=postgres dbname=optimisation_diag" -t_srs EPSG:2154 -nlt PROMOTE_TO_MULTI %%f
PAUSE

C:\Program Files\PostgreSQL\9.4\bin>for %f in (C:\Users\jean-Noel-11\Desktop\temp\shp\*.shp) do ogr2ogr -update -append -lco SCHEMA=temp -f "PostgreSQL" PG:"host=localhost user=postgres password=postgres dbname=optimisation_diag" -t_srs EPSG:2154 -nlt PROMOTE_TO_MULTI %f

-------------------------------------------------------------------------------------
*/

DO $$
DECLARE
    cTable CURSOR FOR SELECT demo.table_name FROM 
    (SELECT * FROM information_schema.tables WHERE table_schema = 'temp') as demo;
    tStatement text;
    nFlag integer;
BEGIN
    tStatement := '';
    nFlag := 0;
    FOR table_record IN cTable LOOP
        -- for every table in the temp schema add a new column
        -- having the table name inserted in each table row
        EXECUTE 'ALTER TABLE temp.' || table_record.table_name || 
        E' ADD COLUMN source_file character varying(64) DEFAULT \'' 
        || table_record.table_name || E'\'::character varying';

        -- build the UNION statement for all the tables
    IF nFlag > 0 THEN
        tStatement := 'SELECT * FROM temp.' || table_record.table_name || ' UNION ALL ' || tStatement;      
    ELSE
        nFlag := 1;
        tStatement := 'SELECT * FROM temp.' || table_record.table_name; 
    END IF;
    END LOOP;
    -- create a new table (in an other schema) based on UNION result
    tStatement := 'CREATE TABLE public.demo_union WITH OIDS AS ' || tStatement; 
    -- RAISE NOTICE 'sql statement: %', tStatement;
    EXECUTE tStatement;
END$$;


