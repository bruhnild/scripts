@echo on
C:
IF NOT EXIST "C:\Program Files\PostgreSQL\10\bin" GOTO NOWINDIR
CD Program Files\PostgreSQL\10\bin\
set PGPASSWORD=xxx
rem pg_dump.exe -h 192.168.101.254 -p 5432 -U postgres -v -f I:\20-MOE70-HSN\07-Scripts\Backups\Schemas\ban.sql -n ban  hsn
rem pg_dump.exe -h 192.168.101.254 -p 5432 -U postgres -v -f I:\20-MOE70-HSN\07-Scripts\Backups\Schemas\rbal.sql -n rbal  hsn
rem pg_dump.exe -h 192.168.101.254 -p 5432 -U postgres -v -f I:\20-MOE70-HSN\07-Scripts\Backups\Schemas\orange.sql -n orange  hsn
rem pg_dump.exe -h 192.168.101.254 -p 5432 -U postgres -v -f I:\20-MOE70-HSN\07-Scripts\Backups\Schemas\gracethd.sql -n  gracethd hsn
rem pg_dump.exe -h 192.168.101.254 -p 5432 -U postgres -v -f I:\20-MOE70-HSN\07-Scripts\Backups\Schemas\gracethd_metis.sql -n gracethd_metis  hsn
rem pg_dump.exe -h 192.168.101.254 -p 5432 -U postgres -v -f I:\20-MOE70-HSN\07-Scripts\Backups\Schemas\gracethdcheck.sql -n gracethdcheck  hsn
rem pg_dump.exe -h 192.168.101.254 -p 5432 -U postgres -v -f I:\20-MOE70-HSN\07-Scripts\Backups\Schemas\gracethdcheckpub.sql -n  gracethdcheckpub hsn
pg_dump.exe -h 192.168.101.254 -p 5432 -U postgres -v -f I:\20-MOE70-HSN\07-Scripts\Backups\Schemas\osm.sql -n  osm hsn
pg_dump.exe -h 192.168.101.254 -p 5432 -U postgres -v -f I:\20-MOE70-HSN\07-Scripts\Backups\Schemas\la_poste.sql -n  la_poste hsn
@echo Les schemas sont sauvegardes
set PGPASSWORD=xxx
rem psql.exe -h production.metis-map.fr -p 5432 -U postgres -d hsn -c "DROP SCHEMA IF EXISTS ban CASCADE;" 
rem psql.exe -h production.metis-map.fr -p 5432 -U postgres -d hsn -c "CREATE SCHEMA ban;" -f I:\20-MOE70-HSN\07-Scripts\Backups\Schemas\ban.sql
rem psql.exe -h production.metis-map.fr -p 5432 -U postgres -d hsn -c "DROP SCHEMA IF EXISTS rbal CASCADE;" 
rem psql.exe -h production.metis-map.fr -p 5432 -U postgres -d hsn -c "CREATE SCHEMA rbal;" -f I:\20-MOE70-HSN\07-Scripts\Backups\Schemas\rbal.sql
rem psql.exe -h production.metis-map.fr -p 5432 -U postgres -d hsn -c "DROP SCHEMA IF EXISTS orange CASCADE;" 
rem psql.exe -h production.metis-map.fr -p 5432 -U postgres -d hsn -c "CREATE SCHEMA orange;" -f I:\20-MOE70-HSN\07-Scripts\Backups\Schemas\orange.sql
rem psql.exe -h production.metis-map.fr -p 5432 -U postgres -d hsn -c "DROP SCHEMA IF EXISTS gracethd CASCADE;" 
rem psql.exe -h production.metis-map.fr -p 5432 -U postgres -d hsn -c "CREATE SCHEMA gracethd;" -f I:\20-MOE70-HSN\07-Scripts\Backups\Schemas\gracethd.sql
rem psql.exe -h production.metis-map.fr -p 5432 -U postgres -d hsn -c "DROP SCHEMA IF EXISTS gracethd_metis CASCADE;" 
rem psql.exe -h production.metis-map.fr -p 5432 -U postgres -d hsn -c "CREATE SCHEMA gracethd_metis;" -f I:\20-MOE70-HSN\07-Scripts\Backups\Schemas\gracethd_metis.sql
rem psql.exe -h production.metis-map.fr -p 5432 -U postgres -d hsn -c "DROP SCHEMA IF EXISTS gracethdcheck CASCADE;" 
rem psql.exe -h production.metis-map.fr -p 5432 -U postgres -d hsn -c "CREATE SCHEMA gracethdcheck;" -f I:\20-MOE70-HSN\07-Scripts\Backups\Schemas\gracethdcheck.sql
rem psql.exe -h production.metis-map.fr -p 5432 -U postgres -d hsn -c "DROP SCHEMA IF EXISTS gracethdcheckpub CASCADE;" 
rem psql.exe -h production.metis-map.fr -p 5432 -U postgres -d hsn -c "CREATE SCHEMA gracethdcheckpub;" -f I:\20-MOE70-HSN\07-Scripts\Backups\Schemas\gracethdcheckpub.sql
psql.exe -h production.metis-map.fr -p 5432 -U postgres -d hsn -c "DROP SCHEMA IF EXISTS osm CASCADE;" 
psql.exe -h production.metis-map.fr -p 5432 -U postgres -d hsn -c "CREATE SCHEMA osm;" -f I:\20-MOE70-HSN\07-Scripts\Backups\Schemas\osm.sql
psql.exe -h production.metis-map.fr -p 5432 -U postgres -d hsn -c "DROP SCHEMA IF EXISTS la_poste CASCADE;" 
psql.exe -h production.metis-map.fr -p 5432 -U postgres -d hsn -c "CREATE SCHEMA la_poste;" -f I:\20-MOE70-HSN\07-Scripts\Backups\Schemas\la_poste.sql

@echo La restauration s'est bien deroulee
PAUSE
exit /b 0
:NOWINDIR
echo "il manque psql : impossible d'executer le script"
PAUSE
exit /b 1
