REM #### activation du mode verbeux
@echo on

REM ####
C:
REM #### condition si fichier existe 
IF NOT EXIST "C:\Program Files\PostgreSQL\10\bin" GOTO NOWINDIR


REM #### aller dans postgres/bin
CD C:\Program Files\PostgreSQL\10\bin\
REM #### exécuter export postgres vers CSV
psql.exe -h 192.168.101.254 -p 5432 -U postgres -d hsn  -f C:\github_repo\github_repo_scripts\scripts\PROJETS\HSN\SQL\bal\controles\01_bal_controles.sql -t
psql.exe -h 192.168.101.254 -p 5432 -U postgres -d hsn  -f C:\github_repo\github_repo_scripts\scripts\PROJETS\HSN\SQL\bal\controles\controles\02_locaux.sql -t
psql.exe -h 192.168.101.254 -p 5432 -U postgres -d hsn  -f C:\github_repo\github_repo_scripts\scripts\PROJETS\HSN\SQL\bal\controles\03_racco.sql -t
psql.exe -h 192.168.101.254 -p 5432 -U postgres -d hsn  -f C:\github_repo\github_repo_scripts\scripts\PROJETS\HSN\SQL\bal\controles\04_liaison.sql -t
psql.exe -h 192.168.101.254 -p 5432 -U postgres -d hsn  -f C:\github_repo\github_repo_scripts\scripts\PROJETS\HSN\SQL\bal\controles\05_liaison_voie.sql -t
psql.exe -h 192.168.101.254 -p 5432 -U postgres -d hsn  -f C:\github_repo\github_repo_scripts\scripts\PROJETS\HSN\SQL\bal\controles\06_liaison_voie_sanspci.sql -t

REM #### affichage verbeux
@echo Les tables sont créée

PAUSE

REM #### mettre en attente
exit /b 0
:NOWINDIR
echo "il manque psql impossible d'executer le script"
PAUSE
exit /b 1
