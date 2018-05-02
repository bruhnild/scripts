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
 
 
 
 md C:\Users\jean-Noel-11\Documents\bdd_batch\metipost\%DATE:/=-%
 

 SET datestr=%DATE:/=_%
 SET db1=metipost

 
 ECHO datestr is %datestr%

 SET BACKUP_FILE1=C:\Users\jean-Noel-11\Documents\bdd_batch\metipost\%DATE:/=-%\%db1%_%datestr%.sql
 SET FIlLENAME1=%db1%_%datestr%.sql

 ECHO Backup file name is %FIlLENAME1% 

 ECHO off
 cd C:\Program Files\PostgreSQL\10\bin\

 pg_dump -U postgres -h 192.168.101.254 -p 5432 %db1%  > %BACKUP_FILE1%

 REM pg_dump -U postgres -h localhost -p 5432 %db5%  > %BACKUP_FILE5%

 ECHO DONE !


 SET PGPASSWORD=leoHe:4?d
 psql.exe -h qualification.metis-map.fr -p 5432 -U postgres -d metipost -c "DROP DATABASE IF EXISTS metipost CASCADE;" 
 psql.exe -h qualification.metis-map.fr -p 5432 -U postgres -d metipost -c "CREATE DATABASE metipost;" -f C:\Users\jean-Noel-11\Documents\bdd_batch\metipost\%DATE:/=-%\%db1%_%datestr%.sql
 psql.exe -h qualification.metis-map.fr -p 5432 -U postgres -d metipost -c "CREATE EXTENSION postgis;" 
 psql.exe -h qualification.metis-map.fr -p 5432 -U postgres -d metipost -c "CREATE EXTENSION postgis_topology;" 
 psql.exe -h qualification.metis-map.fr -p 5432 -U postgres -d metipost -c "CREATE EXTENSION unaccent;" 
 psql.exe -h qualification.metis-map.fr -p 5432 -U postgres -d metipost -c "CREATE EXTENSION pg_routing;" 
 psql.exe -h qualification.metis-map.fr -p 5432 -U postgres -d metipost -c "CREATE EXTENSION btree_gist;" 
 psql.exe -h qualification.metis-map.fr -p 5432 -U postgres -d metipost -c "CREATE EXTENSION btree_gin;" 
 psql.exe -h qualification.metis-map.fr -p 5432 -U postgres -d metipost -c "CREATE EXTENSION dblink;" 
 psql.exe -h qualification.metis-map.fr -p 5432 -U postgres -d metipost -c "CREATE EXTENSION plpgsql;" 

 PAUSE
