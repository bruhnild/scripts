@echo on
C:
IF NOT EXIST "C:\Program Files\PostgreSQL\9.6\bin" GOTO NOWINDIR
IF NOT EXIST %localappdata%\Programs\Python\Python36-32 GOTO NOWINDIR
CD Program Files\PostgreSQL\9.6\bin\
psql.exe -h www.metis-reseaux.fr -p 5678 -U postgres -d l49  -f V:\ADN\04-Scripts\rapport_bi_mensuel\bat\opportunites_synthese.sql -t
psql.exe -h www.metis-reseaux.fr -p 5678 -U postgres -d l49  -f V:\ADN\04-Scripts\rapport_bi_mensuel\bat\opportunites_typegc.sql -t
CD V:\ADN\04-Scripts\rapport_bi_mensuel\bat
CD %localappdata%\Programs\Python\Python36-32
python.exe V:\ADN\04-Scripts\rapport_bi_mensuel\bat\launcher.py
PAUSE
exit /b 0
:NOWINDIR
echo "il manque psql ou python impossible d'executer le script"
PAUSE
exit /b 1
