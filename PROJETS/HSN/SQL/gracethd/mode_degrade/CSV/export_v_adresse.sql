SET CLIENT_ENCODING TO 'CP1252';
\copy (SELECT * FROM rbal.v_adresse) TO 'I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\mode_degrade\CSV\export_v_adresse.csv'  DELIMITER ';' CSV HEADER;

