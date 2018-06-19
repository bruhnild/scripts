SET CLIENT_ENCODING TO 'LATIN1';
\copy (SELECT * FROM ban.t_ban_travail) TO 'C:\Users\jean-Noel-11\Documents\bdd_batch\csv\csv_qualif.csv'  DELIMITER ';' CSV HEADER;

