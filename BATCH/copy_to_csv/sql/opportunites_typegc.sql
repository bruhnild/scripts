SET CLIENT_ENCODING TO 'LATIN1';
\copy (SELECT * FROM rapport.opportunites_typegc) TO 'C:\github_repo\github_repo_batch\batch\copy_to_csv\sql\opportunites_typegc.csv'  DELIMITER ';' CSV HEADER;

