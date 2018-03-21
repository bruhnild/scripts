/*
####################################################################

                   GROUPE ITEMS - METIPOST

####################################################################
*/

---Requête de création des utilisateurs---
CREATE USER cgourraud WITH LOGIN ENCRYPTED PASSWORD 'Pi73n6Rr';
--- Requete de création des droits associés

/*Autorise l'utilisateur à se connecter à la base indiquée*/
GRANT CONNECT ON DATABASE metipost TO cgourraud;
/*Actions permises par les utilisateur*/
GRANT SELECT ON ALL TABLES IN SCHEMA administratif TO cgourraud;
GRANT SELECT ON ALL TABLES IN SCHEMA analyses TO cgourraud;
GRANT SELECT ON ALL TABLES IN SCHEMA ban TO cgourraud;
GRANT SELECT ON ALL TABLES IN SCHEMA batiments TO cgourraud;
GRANT SELECT ON ALL TABLES IN SCHEMA places TO cgourraud;
GRANT SELECT ON ALL TABLES IN SCHEMA pois TO cgourraud;
GRANT SELECT ON ALL TABLES IN SCHEMA poste TO cgourraud;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO cgourraud;
GRANT SELECT ON ALL TABLES IN SCHEMA routes TO cgourraud;
GRANT SELECT ON ALL TABLES IN SCHEMA topology TO cgourraud;
GRANT SELECT ON ALL TABLES IN SCHEMA statistiques TO cgourraud;

/*Droit d'usage de ces actions*/
GRANT USAGE ON SCHEMA administratif TO cgourraud;
GRANT USAGE ON SCHEMA analyses TO cgourraud;
GRANT USAGE ON SCHEMA ban TO cgourraud;
GRANT USAGE ON SCHEMA batiments TO cgourraud;
GRANT USAGE ON SCHEMA places TO cgourraud;
GRANT USAGE ON SCHEMA pois TO cgourraud;
GRANT USAGE ON SCHEMA poste TO cgourraud;
GRANT USAGE ON SCHEMA public TO cgourraud;
GRANT USAGE ON SCHEMA routes TO cgourraud;
GRANT USAGE ON SCHEMA statistiques TO cgourraud;
GRANT USAGE ON SCHEMA topology TO cgourraud;


/*Permission de création de séquences*/
REVOKE ALL ON DATABASE metipost FROM cgourraud;

/*Suppression des users
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA administratif FROM cgourraud;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA analyses FROM cgourraud;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA ban FROM cgourraud;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA batiments FROM cgourraud;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA places FROM cgourraud;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA pois FROM cgourraud;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA poste FROM cgourraud;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM cgourraud;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA routes FROM cgourraud;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA topology FROM cgourraud;
DROP USER cgourraud;
*/
