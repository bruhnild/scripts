REM #### activation du mode verbeux
@echo on

REM ####
C:
REM #### condition si fichier existe 
IF NOT EXIST "C:\Program Files\PostgreSQL\9.6\bin" GOTO NOWINDIR
REM #### condition si python exist
IF NOT EXIST %localappdata%\Programs\Python\Python36-32 GOTO NOWINDIR


REM #### aller dans postgres/bin
CD Program Files\PostgreSQL\9.6\bin\
REM #### exécuter export postgres vers CSV
psql.exe -h qualification.metis-map.fr -p 5432 -U postgres -d adn_l49  -f I:\14-ADN\04-Scripts\rapport_bi_mensuel\bat\opportunites_synthese.sql -t
REM #### exécuter export postgres vers CSV
psql.exe -h qualification.metis-map.fr -p 5432 -U postgres -d adn_l49  -f I:\14-ADN\04-Scripts\rapport_bi_mensuel\bat\opportunites_typegc.sql -t
REM #### affichage verbeux
@echo Les CSV sont crees

REM #### aller dans /bat
CD I:\14-ADN\04-Scripts\rapport_bi_mensuel\bat
REM #### aller dans /python.exe pour exécuter les scripts TODO : vérifier si obligatorie
CD %localappdata%\Programs\Python\Python36-32

REM #### exécuter scripts python
python.exe I:\14-ADN\04-Scripts\rapport_bi_mensuel\bat\launcher.py

REM #### affichage verbeux
@echo Fin du programme, merci d'avoir joue avec nous :)
REM #### mettre en attente
PAUSE

REM #### mettre en attente
exit /b 0
:NOWINDIR
echo "il manque psql ou python impossible d'executer le script"
PAUSE
exit /b 1
