REM #### activation du mode verbeux
@echo on

REM ####
C:
REM #### condition si fichier existe 
IF NOT EXIST "C:\Program Files\PostgreSQL\10\bin" GOTO NOWINDIR


REM #### aller dans postgres/bin
CD C:\Program Files\PostgreSQL\10\bin\
REM #### exécuter export postgres vers CSV
psql.exe -h 192.168.101.254 -p 5432 -U postgres -d adn_nro  -f I:\6-AMOA-DIVERS\4-IBSE\1-ADN\11-Scripts\DIAG\SQL\CSV\export_diag_nro.sql -t
REM #### affichage verbeux
@echo Les CSV sont crees

PAUSE

REM #### mettre en attente
exit /b 0
:NOWINDIR
echo "il manque psql impossible d'executer le script"
PAUSE
exit /b 1
