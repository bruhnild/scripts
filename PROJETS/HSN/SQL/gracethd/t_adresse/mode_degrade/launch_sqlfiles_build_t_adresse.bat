REM #### activation du mode verbeux
@echo on

REM ####
C:
REM #### condition si fichier existe 
IF NOT EXIST "C:\Program Files\PostgreSQL\10\bin" GOTO NOWINDIR


REM #### aller dans postgres/bin
CD C:\Program Files\PostgreSQL\10\bin\
REM #### exécuter export postgres vers CSV
psql.exe -h 192.168.101.254 -p 5432 -U postgres -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_degrade\01_gracethd_metis_t_adresse.sql -t
psql.exe -h 192.168.101.254 -p 5432 -U postgres -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_degrade\02_rbal_t_adresse.sql -t
psql.exe -h 192.168.101.254 -p 5432 -U postgres -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_degrade\03_gracethd_metis_t_adresse_update.sql -t
REM #### affichage verbeux
@echo Les tables sont créée

PAUSE

REM #### mettre en attente
exit /b 0
:NOWINDIR
echo "il manque psql impossible d'executer le script"
PAUSE
exit /b 1
