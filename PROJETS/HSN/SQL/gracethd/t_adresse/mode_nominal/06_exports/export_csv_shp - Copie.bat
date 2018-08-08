REM #### activation du mode verbeux
@echo on

REM ####
C:
REM #### condition si fichier existe 
IF NOT EXIST "C:\Program Files\PostgreSQL\10\bin" GOTO NOWINDIR
IF NOT EXIST %localappdata%\Programs\Python\Python36-32 GOTO NOWINDIR

REM #### Chemin vers psql et pgsql2shp
CD C:\Program Files\PostgreSQL\10\bin\

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
