cd C:\Program Files\PostgreSQL\9.4\bin\
psql.exe -h www.metis-reseaux.fr -p 5678 -U postgres -d l49  -f C:\github_repo\github_repo_batch\batch\parse_csv_bat_launcher\opportunites_synthese.sql -t 
psql.exe -h www.metis-reseaux.fr -p 5678 -U postgres -d l49  -f C:\github_repo\github_repo_batch\batch\parse_csv_bat_launcher\opportunites_typegc.sql -t 
@echo off
cd C:\github_repo\github_repo_batch\batch\parse_csv_bat_launcher\
C:\Users\jean-Noel-11\AppData\Local\Programs\Python\Python36-32\
python.exe C:\github_repo\github_repo_batch\batch\parse_csv_bat_launcher\launcher.py
PAUSE
