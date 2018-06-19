 REM script to backup PostgresSQL databases
 @ECHO off



 FOR /f "tokens=1-4 delims=/ " %%i IN ("%date%") DO (

 SET dow=%%i
 SET month=%%j
 SET day=%%k
 SET year=%%l
 )

 
SET vheure=%time:~0,2%
IF /i %vheure% lss 10 set vheure=0%time:~1,1%
 
SET vmin=%time:~3,2%
IF /i %vmin% lss 10 set vmin=0%time:~4,1%
 
SET vsec=%time:~6,2%
IF /i %vsec% lss 10 set vsec=0%time:~7,1%
 
SET fic=_%date:~6,4%%date:~3,2%%date:~0,2%_%vheure%%vmin%%vsec%.dump
 
 
 
 md I:\6-AMOA-DIVERS\4-IBSE\1-ADN\11-Scripts\BACKUPS\%DATE:/=-%
 

 SET datestr=%DATE:/=_%
 SET db1=adn_nro

 
 ECHO datestr is %datestr%

 SET BACKUP_FILE1=I:\6-AMOA-DIVERS\4-IBSE\1-ADN\11-Scripts\BACKUPS\%DATE:/=-%\%db1%_%datestr%.sql
 SET FIlLENAME1=%db1%_%datestr%.sql

 ECHO Backup file name is %FIlLENAME1% 

 ECHO off
 cd C:\Program Files\PostgreSQL\10\bin\

 pg_dump -U postgres -h 192.168.101.254 -p 5432 %db1%  > %BACKUP_FILE1%

 REM pg_dump -U postgres -h localhost -p 5432 %db5%  > %BACKUP_FILE5%

 ECHO DONE !


 SET PGPASSWORD=leoHe:4?d
 psql.exe -h production.metis-map.fr -p 5432 -U postgres -d adn_nro -c "DROP DATABASE IF EXISTS adn_nro CASCADE;" 
 psql.exe -h production.metis-map.fr -p 5432 -U postgres -d adn_nro -c "CREATE DATABASE adn_nro;" -f I:\6-AMOA-DIVERS\4-IBSE\1-ADN\11-Scripts\BACKUPS\%DATE:/=-%\%db1%_%datestr%.sql
 psql.exe -h production.metis-map.fr -p 5432 -U postgres -d adn_nro -c "CREATE EXTENSION postgis;" 
 psql.exe -h production.metis-map.fr -p 5432 -U postgres -d adn_nro -c "CREATE EXTENSION postgis_topology;"
 psql.exe -h production.metis-map.fr -p 5432 -U postgres -d adn_nro -c "CREATE EXTENSION unaccent;"
 psql.exe -h production.metis-map.fr -p 5432 -U postgres -d adn_nro -c "CREATE EXTENSION pg_routing;" 
 psql.exe -h production.metis-map.fr -p 5432 -U postgres -d adn_nro -c "CREATE EXTENSION btree_gist;" 
 psql.exe -h production.metis-map.fr -p 5432 -U postgres -d adn_nro -c "CREATE EXTENSION btree_gin;" 
 psql.exe -h production.metis-map.fr -p 5432 -U postgres -d adn_nro -c "CREATE EXTENSION dblink;" 
 psql.exe -h production.metis-map.fr -p 5432 -U postgres -d adn_nro -c "CREATE EXTENSION plpgsql;" 

 PAUSE
