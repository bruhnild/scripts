SET CLIENT_ENCODING TO 'UTF8';
\copy (SELECT * FROM chantier.diag_nro) TO 'C:\Users\jean-Noel-11\Documents\bdd_batch\csv\csv_local.csv'  DELIMITER ';' CSV HEADER;

