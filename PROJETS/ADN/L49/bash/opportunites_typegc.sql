SET CLIENT_ENCODING TO 'UTF8';
\copy (SELECT * FROM rapport.opportunites_typegc) TO '/home/public/FTTH RIP/14-ADN/04-Scripts/rapport_bi_mensuel/bash/opportunites_typegc.csv'  DELIMITER ';' CSV HEADER;

