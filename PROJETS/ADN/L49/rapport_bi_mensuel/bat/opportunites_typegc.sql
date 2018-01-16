SET CLIENT_ENCODING TO 'UTF8';
\copy (SELECT * FROM coordination.vue_rapport_opportunites_typegc) TO 'I:\14-ADN\04-Scripts\rapport_bi_mensuel\bat\opportunites_typegc.csv'  DELIMITER ';' CSV HEADER;

