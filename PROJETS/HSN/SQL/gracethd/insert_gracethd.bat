REM #### activation du mode verbeux
@echo on

REM ####
C:
REM #### condition si fichier existe 
IF NOT EXIST "C:\Program Files\PostgreSQL\10\bin" GOTO NOWINDIR
REM #### aller dans postgres/bin
CD C:\Program Files\PostgreSQL\10\bin\

REM #### PHASE 4 : Création de t_adresse
psql.exe -h 192.168.101.254 -p 5432 -U postgres -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_noeud\01_gracethd_t_noeud_insert.sql 
psql.exe -h 192.168.101.254 -p 5432 -U postgres -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_znro\01_gracethd_t_znro_insert.sql
psql.exe -h 192.168.101.254 -p 5432 -U postgres -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_zsro\01_gracethd_t_zsro_insert.sql 
psql.exe -h 192.168.101.254 -p 5432 -U postgres -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_sitetech\01_gracethd_t_sitetech_insert.sql 
@echo La table t_adresse est créée

PAUSE

REM #### mettre en attente
exit /b 0
:NOWINDIR
echo "Il manque psql : impossible d'executer le script"
PAUSE
exit /b 1


