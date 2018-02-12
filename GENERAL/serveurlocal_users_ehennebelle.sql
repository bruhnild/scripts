/*
####################################################################

                   UTILISATEURS x

####################################################################
*/

---Requête de création des utilisateurs---
CREATE USER ehennebelle WITH LOGIN ENCRYPTED PASSWORD '5Uv5tJ5x';
--- Requete de création des droits associés

/*Autorise l'utilisateur à se connecter à la base indiquée*/
GRANT CONNECT ON DATABASE reseaux TO ehennebelle;
GRANT CONNECT ON DATABASE territoire TO ehennebelle;
GRANT CONNECT ON DATABASE covage_14 TO ehennebelle;


/*Actions permises par les utilisateur*/
GRANT SELECT ON ALL TABLES IN SCHEMA erdf TO ehennebelle;
GRANT SELECT ON ALL TABLES IN SCHEMA lotim TO ehennebelle;
GRANT SELECT ON ALL TABLES IN SCHEMA orange TO ehennebelle;
GRANT SELECT ON ALL TABLES IN SCHEMA siel TO ehennebelle;
GRANT SELECT ON ALL TABLES IN SCHEMA arrondissement_dep TO ehennebelle;
GRANT SELECT ON ALL TABLES IN SCHEMA batiment TO ehennebelle;
GRANT SELECT ON ALL TABLES IN SCHEMA cadastre_client TO ehennebelle;
GRANT SELECT ON ALL TABLES IN SCHEMA chef_lieu TO ehennebelle;
GRANT SELECT ON ALL TABLES IN SCHEMA commune TO ehennebelle;
GRANT SELECT ON ALL TABLES IN SCHEMA departement TO ehennebelle;
GRANT SELECT ON ALL TABLES IN SCHEMA epci TO ehennebelle;
GRANT SELECT ON ALL TABLES IN SCHEMA hydrographie TO ehennebelle;
GRANT SELECT ON ALL TABLES IN SCHEMA lieu_dit TO ehennebelle;
GRANT SELECT ON ALL TABLES IN SCHEMA pci_dep_01 TO ehennebelle;
GRANT SELECT ON ALL TABLES IN SCHEMA pci_dep_03 TO ehennebelle;
GRANT SELECT ON ALL TABLES IN SCHEMA pci_dep_07 TO ehennebelle;
GRANT SELECT ON ALL TABLES IN SCHEMA pci_dep_15 TO ehennebelle;
GRANT SELECT ON ALL TABLES IN SCHEMA pci_dep_26 TO ehennebelle;
GRANT SELECT ON ALL TABLES IN SCHEMA pci_dep_38 TO ehennebelle;
GRANT SELECT ON ALL TABLES IN SCHEMA pci_dep_42 TO ehennebelle;
GRANT SELECT ON ALL TABLES IN SCHEMA pci_dep_43 TO ehennebelle;
GRANT SELECT ON ALL TABLES IN SCHEMA pci_dep_69 TO ehennebelle;
GRANT SELECT ON ALL TABLES IN SCHEMA pci_dep_73 TO ehennebelle;
GRANT SELECT ON ALL TABLES IN SCHEMA pci_dep_74 TO ehennebelle;
GRANT SELECT ON ALL TABLES IN SCHEMA region TO ehennebelle;
GRANT SELECT ON ALL TABLES IN SCHEMA route TO ehennebelle;
GRANT INSERT,SELECT,UPDATE,DELETE ON ALL TABLES IN SCHEMA mdz14 TO ehennebelle;
GRANT INSERT,SELECT,UPDATE,DELETE ON ALL TABLES IN SCHEMA mai14 TO ehennebelle;
GRANT INSERT,SELECT,UPDATE,DELETE ON ALL TABLES IN SCHEMA scf14 TO ehennebelle;
GRANT INSERT,SELECT,UPDATE,DELETE ON ALL TABLES IN SCHEMA til14 TO ehennebelle;
GRANT INSERT,SELECT,UPDATE,DELETE ON ALL TABLES IN SCHEMA cadastre TO ehennebelle;
GRANT INSERT,SELECT,UPDATE,DELETE ON ALL TABLES IN SCHEMA travail TO ehennebelle;
GRANT INSERT,SELECT,UPDATE,DELETE ON ALL TABLES IN SCHEMA routing TO ehennebelle;
GRANT ALL ON ALL TABLES IN SCHEMA mdz14 TO ehennebelle;
GRANT ALL ON ALL TABLES IN SCHEMA mai14 TO ehennebelle;
GRANT ALL ON ALL TABLES IN SCHEMA scf14 TO ehennebelle;
GRANT ALL ON ALL TABLES IN SCHEMA til14 TO ehennebelle;
GRANT ALL ON ALL TABLES IN SCHEMA cadastre TO ehennebelle;
GRANT ALL ON ALL TABLES IN SCHEMA travail TO ehennebelle;
GRANT ALL ON ALL TABLES IN SCHEMA routing TO ehennebelle;
/*Droit d'usage de ces actions*/
GRANT USAGE ON SCHEMA erdf TO ehennebelle;
GRANT USAGE ON SCHEMA lotim TO ehennebelle;
GRANT USAGE ON SCHEMA orange TO ehennebelle;
GRANT USAGE ON SCHEMA siel TO ehennebelle;
GRANT USAGE ON SCHEMA arrondissement_dep TO ehennebelle;
GRANT USAGE ON SCHEMA batiment TO ehennebelle;
GRANT USAGE ON SCHEMA cadastre_client TO ehennebelle;
GRANT USAGE ON SCHEMA chef_lieu TO ehennebelle;
GRANT USAGE ON SCHEMA commune TO ehennebelle;
GRANT USAGE ON SCHEMA departement TO ehennebelle;
GRANT USAGE ON SCHEMA epci TO ehennebelle;
GRANT USAGE ON SCHEMA hydrographie TO ehennebelle;
GRANT USAGE ON SCHEMA lieu_dit TO ehennebelle;
GRANT USAGE ON SCHEMA pci_dep_01 TO ehennebelle;
GRANT USAGE ON SCHEMA pci_dep_03 TO ehennebelle;
GRANT USAGE ON SCHEMA pci_dep_07 TO ehennebelle;
GRANT USAGE ON SCHEMA pci_dep_15 TO ehennebelle;
GRANT USAGE ON SCHEMA pci_dep_26 TO ehennebelle;
GRANT USAGE ON SCHEMA pci_dep_38 TO ehennebelle;
GRANT USAGE ON SCHEMA pci_dep_42 TO ehennebelle;
GRANT USAGE ON SCHEMA pci_dep_43 TO ehennebelle;
GRANT USAGE ON SCHEMA pci_dep_69 TO ehennebelle;
GRANT USAGE ON SCHEMA pci_dep_73 TO ehennebelle;
GRANT USAGE ON SCHEMA pci_dep_74 TO ehennebelle;
GRANT USAGE ON SCHEMA region TO ehennebelle;
GRANT USAGE ON SCHEMA route TO ehennebelle;
GRANT USAGE ON SCHEMA mdz14 TO ehennebelle;
GRANT USAGE ON SCHEMA mai14 TO ehennebelle;
GRANT USAGE ON SCHEMA scf14 TO ehennebelle;
GRANT USAGE ON SCHEMA til14 TO ehennebelle;
GRANT USAGE ON SCHEMA cadastre TO ehennebelle;
GRANT USAGE ON SCHEMA travail TO ehennebelle;
GRANT USAGE ON SCHEMA routing TO ehennebelle;

/*Permission de création de séquences*/
GRANT USAGE ON ALL SEQUENCES IN SCHEMA mdz14 TO ehennebelle;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA mai14 TO ehennebelle;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA scf14 TO ehennebelle;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA til14 TO ehennebelle;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA cadastre TO ehennebelle;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA travail TO ehennebelle;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA routing TO ehennebelle;

/*Suppression des users
REVOKE ALL ON SCHEMA erdf FROM ehennebelle;
REVOKE ALL ON SCHEMA lotim FROM ehennebelle;
REVOKE ALL ON SCHEMA orange FROM ehennebelle;
REVOKE ALL ON SCHEMA siel FROM ehennebelle;
REVOKE ALL ON SCHEMA arrondissement_dep TO ehennebelle;
REVOKE ALL ON SCHEMA batiment TO ehennebelle;
REVOKE ALL ON SCHEMA cadastre_client TO ehennebelle;
REVOKE ALL ON SCHEMA chef_lieu TO ehennebelle;
REVOKE ALL ON SCHEMA commune TO ehennebelle;
REVOKE ALL ON SCHEMA departement TO ehennebelle;
REVOKE ALL ON SCHEMA epci TO ehennebelle;
REVOKE ALL ON SCHEMA hydrographie TO ehennebelle;
REVOKE ALL ON SCHEMA lieu_dit TO ehennebelle;
REVOKE ALL ON SCHEMA pci_dep_01 TO ehennebelle;
REVOKE ALL ON SCHEMA pci_dep_03 TO ehennebelle;
REVOKE ALL ON SCHEMA pci_dep_07 TO ehennebelle;
REVOKE ALL ON SCHEMA pci_dep_15 TO ehennebelle;
REVOKE ALL ON SCHEMA pci_dep_26 TO ehennebelle;
REVOKE ALL ON SCHEMA pci_dep_38 TO ehennebelle;
REVOKE ALL ON SCHEMA pci_dep_42 TO ehennebelle;
REVOKE ALL ON SCHEMA pci_dep_43 TO ehennebelle;
REVOKE ALL ON SCHEMA pci_dep_69 TO ehennebelle;
REVOKE ALL ON SCHEMA pci_dep_73 TO ehennebelle;
REVOKE ALL ON SCHEMA pci_dep_74 TO ehennebelle;
REVOKE ALL ON SCHEMA region TO ehennebelle;
REVOKE ALL ON SCHEMA route TO ehennebelle;
REVOKE ALL ON SCHEMA mdz14 TO ehennebelle;
REVOKE ALL ON SCHEMA mai14 TO ehennebelle;
REVOKE ALL ON SCHEMA scf14 TO ehennebelle;
REVOKE ALL ON SCHEMA til14 TO ehennebelle;
REVOKE ALL ON SCHEMA cadastre TO ehennebelle;
REVOKE ALL ON SCHEMA travail TO ehennebelle;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA erdf FROM ehennebelle;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA lotim FROM ehennebelle;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA orange FROM ehennebelle;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA siel FROM ehennebelle;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA arrondissement_dep TO ehennebelle;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA batiment TO ehennebelle;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA cadastre_client TO ehennebelle;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA chef_lieu TO ehennebelle;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA commune TO ehennebelle;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA departement TO ehennebelle;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA epci TO ehennebelle;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA hydrographie TO ehennebelle;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA lieu_dit TO ehennebelle;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA pci_dep_01 TO ehennebelle;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA pci_dep_03 TO ehennebelle;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA pci_dep_07 TO ehennebelle;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA pci_dep_15 TO ehennebelle;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA pci_dep_26 TO ehennebelle;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA pci_dep_38 TO ehennebelle;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA pci_dep_42 TO ehennebelle;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA pci_dep_43 TO ehennebelle;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA pci_dep_69 TO ehennebelle;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA pci_dep_73 TO ehennebelle;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA pci_dep_74 TO ehennebelle;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA region TO ehennebelle;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA route TO ehennebelle;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA mdz14 TO ehennebelle;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA mai14 TO ehennebelle;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA scf14 TO ehennebelle;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA til14 TO ehennebelle;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA cadastre TO ehennebelle;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA travail TO ehennebelle;
REVOKE ALL ON DATABASE reseaux FROM ehennebelle;
REVOKE ALL ON DATABASE territoire FROM ehennebelle;
REVOKE ALL ON DATABASE covage_14 FROM ehennebelle;
DROP USER ehennebelle;

*/



DO $do$
DECLARE
    sch text;
BEGIN
    FOR sch IN SELECT nspname FROM pg_namespace
    LOOP
        EXECUTE format($$ GRANT USAGE ON SCHEMA %I TO ehennebelle $$, sch);
    END LOOP;
END;
$do$;
SELECT nspname
  FROM pg_namespace;
  
  
-- REA1SSIGNE LES DROITS A ehennebelle

-- GRANT
SELECT DISTINCT 'GRANT '
    || CASE schemaname WHEN 'pg_catalog' THEN 'USAGE' ELSE 'ALL' END
    || ' ON SCHEMA ' || quote_ident(schemaname) || ' TO ehennebelle;'
FROM pg_tables;

-- TABLES 
	SELECT 'ALTER TABLE '|| schemaname || '.' || tablename ||' OWNER TO ehennebelle;'
FROM pg_tables WHERE NOT schemaname IN ('pg_catalog', 'information_schema')
ORDER BY schemaname, tablename;

-- SEQUENCES 
SELECT 'ALTER SEQUENCE '|| sequence_schema || '.' || sequence_name ||' OWNER TO ehennebelle;'
FROM information_schema.sequences WHERE NOT sequence_schema IN ('pg_catalog', 'information_schema')
ORDER BY sequence_schema, sequence_name;

-- VUES 
SELECT 'ALTER VIEW '|| table_schema || '.' || table_name ||' OWNER TO ehennebelle;'
FROM information_schema.views WHERE NOT table_schema IN ('pg_catalog', 'information_schema')
ORDER BY table_schema, table_name;

-- VUES MATERIALISEES
SELECT 'ALTER TABLE '|| oid::regclass::text ||' OWNER TO ehennebelle;'
FROM pg_class WHERE relkind = 'm'
ORDER BY oid;

