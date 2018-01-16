@echo on
C:
IF NOT EXIST "C:\Program Files\PostgreSQL\9.4\bin" GOTO NOWINDIR
IF NOT EXIST %localappdata%\Programs\Python\Python36-32 GOTO NOWINDIR
CD Program Files\PostgreSQL\9.4\bin\
psql.exe -h qualification.metis-map.fr -p 5432 -U postgres -d adn_l49  -f I:\14-ADN\04-Scripts\rapport_bi_mensuel\bat\opportunites_synthese.sql -t
psql.exe -h qualification.metis-map.fr -p 5432 -U postgres -d adn_l49  -f I:\14-ADN\04-Scripts\rapport_bi_mensuel\bat\opportunites_typegc.sql -t
@echo Les CSV sont crees
CD I:\14-ADN\04-Scripts\rapport_bi_mensuel\bat
CD %localappdata%\Programs\Python\Python36-32
python.exe I:\14-ADN\04-Scripts\rapport_bi_mensuel\bat\launcher.py
@echo Fin du programme, merci d'avoir joue avec nous :)
PAUSE
exit /b 0
:NOWINDIR
echo "il manque psql ou python impossible d'executer le script"
PAUSE
exit /b 1