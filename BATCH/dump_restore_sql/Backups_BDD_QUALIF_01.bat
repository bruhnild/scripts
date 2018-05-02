  REM script to backup PostgresSQL databases
 @ECHO off



 FOR /f "tokens=1-4 delims=/ " %%i IN ("%date%") DO (

 SET dow=%%i
 SET month=%%j
 SET day=%%k
 SET year=%%l
 )
 
rem set fic=sav_%date:~6,4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%%time:~6,2%.dump
 
set vheure=%time:~0,2%
if /i %vheure% lss 10 set vheure=0%time:~1,1%
 
set vmin=%time:~3,2%
if /i %vmin% lss 10 set vmin=0%time:~4,1%
 
set vsec=%time:~6,2%
if /i %vsec% lss 10 set vsec=0%time:~7,1%
 
set fic=_%date:~6,4%%date:~3,2%%date:~0,2%_%vheure%%vmin%%vsec%.dump
 
 
 
 md C:\Users\jean-Noel-11\Documents\Atlas_AVP_ADN\%DATE:/=-%
 

 SET datestr=%DATE:/=_%
 REM SET datestr=%month%_%day%_%year%
 rem db1=upap_demo_cameroun
 set db1=adn_l49
 rem db1=adn_nro
 rem db1=territoire
 rem db1=thd_isere
 rem db1=reseaux

 
 ECHO datestr is %datestr%

 SET BACKUP_FILE1=C:\Users\jean-Noel-11\Documents\Atlas_AVP_ADN\%DATE:/=-%\%db1%_%datestr%.sql
 SET FIlLENAME1=%db1%_%datestr%.sql



 ECHO Backup file name is %FIlLENAME1% 

 ECHO off
 cd C:\Program Files\PostgreSQL\10\bin\

 pg_dump -U postgres -h qualification.metis-map.fr -p 5432 %db1%  > %BACKUP_FILE1%

 REM pg_dump -U postgres -h localhost -p 5432 %db5%  > %BACKUP_FILE5%

 ECHO DONE !
 PAUSE