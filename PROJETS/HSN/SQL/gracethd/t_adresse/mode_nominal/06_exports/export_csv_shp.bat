REM #### activation du mode verbeux
@echo on

REM ####
C:
REM #### condition si fichier existe 
IF NOT EXIST "C:\Program Files\PostgreSQL\10\bin" GOTO NOWINDIR
IF NOT EXIST %localappdata%\Programs\Python\Python36-32 GOTO NOWINDIR

REM #### Chemin vers psql et pgsql2shp
CD C:\Program Files\PostgreSQL\10\bin\

REM #### Export t_adresse complet en SHP
pgsql2shp.exe -f "I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\06_exports\shp\t_adresse" -h 192.168.101.254 -p 5432 -u postgres -d hsn rbal.v_adresse_export

REM #### Création des tables par sro dans pg_admin
psql.exe -h 192.168.101.254 -p 5432 -U postgres -w -d hsn -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\06_exports\shp\gexec_t_adresse.sql

REM #### Export des tables t_adresse par sro en SHP
cd C:\OSGeo4W64\bin\
ogr2ogr -f "ESRI Shapefile" I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\06_exports\shp PG:"host=192.168.101.254 user=postgres password=l0cA!L8: schemas=gracethd_metis_livrables dbname=hsn " 

REM #### Export en CSV
psql.exe -h 192.168.101.254 -p 5432 -U postgres -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\06_exports\csv\export_v_adresse.sql -t

REM #### Decouper le CSV en autant de CSV qu'il y a de SRO
CD I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\06_exports\csv
CD %localappdata%\Programs\Python\Python36-32
python.exe I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\06_exports\csv\csv_parser.py

@echo Les CSV et le SHP sont crees

REM #### mettre en attente
exit /b 0
:NOWINDIR
echo "Il manque psql ou python: impossible d'executer le script"
PAUSE
exit /b 1
