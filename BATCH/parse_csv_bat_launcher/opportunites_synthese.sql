SET CLIENT_ENCODING TO 'LATIN1';
\copy (SELECT * FROM rapport.opportunites_synthese) TO 'C:\github_repo\github_repo_batch\batch\parse_csv_bat_launcher\opportunites_synthese.csv'  DELIMITER ';' CSV HEADER;

