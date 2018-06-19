SET CLIENT_ENCODING TO 'CP1252';
\copy (SELECT * FROM chantier.diag_nro) TO 'I:\6-AMOA-DIVERS\4-IBSE\1-ADN\11-Scripts\DIAG\SQL\CSV\export_diag_nro.csv'  DELIMITER ';' CSV HEADER;

