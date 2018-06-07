@echo on
C:
IF NOT EXIST "C:\Program Files\PostgreSQL\10\bin" GOTO NOWINDIR
CD Program Files\PostgreSQL\10\bin\
set PGPASSWORD=l0cA!L8:
pg_dump.exe -h 192.168.101.254 -p 5432 -U postgres -v -f I:\14-ADN\04-Scripts\backups\Schemas\coordination.sql -n coordination  adn_l49
pg_dump.exe -h 192.168.101.254 -p 5432 -U postgres -v -f I:\14-ADN\04-Scripts\backups\Schemas\administratif.sql -t administratif.communes adn_l49
pg_dump.exe -h 192.168.101.254 -p 5432 -U postgres -v -f I:\14-ADN\04-Scripts\backups\Schemas\rapport.sql -n  rapport adn_l49
@echo Les schemas sont sauvegardes
set PGPASSWORD=leoHe:4?d
psql.exe -h production.metis-map.fr -p 5432 -U postgres -d adn_l49 -c "DROP SCHEMA IF EXISTS coordination CASCADE;" 
psql.exe -h production.metis-map.fr -p 5432 -U postgres -d adn_l49 -c "CREATE SCHEMA coordination;" -f I:\14-ADN\04-Scripts\backups\Schemas\coordination.sql
psql.exe -h production.metis-map.fr -p 5432 -U postgres -d adn_l49 -c "DROP TABLE IF EXISTS administratif.communes CASCADE;" 
psql.exe -h production.metis-map.fr -p 5432 -U postgres -d adn_l49 -f I:\14-ADN\04-Scripts\backups\Schemas\administratif.sql
psql.exe -h production.metis-map.fr -p 5432 -U postgres -d adn_l49 -c "DROP SCHEMA IF EXISTS rapport CASCADE;" 
psql.exe -h production.metis-map.fr -p 5432 -U postgres -d adn_l49 -c "CREATE SCHEMA rapport;" -f I:\14-ADN\04-Scripts\backups\Schemas\rapport.sql

@echo La restauration s'est bien deroulee
PAUSE
exit /b 0
:NOWINDIR
echo "il manque psql : impossible d'executer le script"
PAUSE
exit /b 1
