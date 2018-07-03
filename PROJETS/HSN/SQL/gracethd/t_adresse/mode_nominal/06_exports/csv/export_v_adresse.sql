SET CLIENT_ENCODING TO 'WIN1252';
\copy (SELECT * FROM rbal.v_adresse_export) TO 'I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\06_exports\csv\export_v_adresse.csv'  DELIMITER ';' CSV HEADER;

