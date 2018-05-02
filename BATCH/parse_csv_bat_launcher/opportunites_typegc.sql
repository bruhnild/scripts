SET CLIENT_ENCODING TO 'LATIN1';
\copy (SELECT * FROM rapport.opportunites_typegc) TO 'C:\github_repo\github_repo_batch\batch\parse_csv_bat_launcher\opportunites_typegc.csv'  DELIMITER ';' CSV HEADER;

