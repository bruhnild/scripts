SET CLIENT_ENCODING TO 'LATIN1';
\copy (SELECT * FROM rapport.opportunites_synthese) TO 'V:\ADN\04-Scripts\rapport_bi_mensuel\bat\opportunites_synthese.csv'  DELIMITER ';' CSV HEADER;

