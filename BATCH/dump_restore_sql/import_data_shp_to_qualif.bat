
REM *******************************************************************
REM ** Ce ci est un fichier  batch Windows  pour l imprtation de     **
REM ** shapefiles  dans Postgres/Postgis . Ce fichier est compatible **
REM ** Le batch importe chaque fichier shp  dans la base de donnees  ** 
REM **                                                               **
REM ** Parametres a changer:                                         **					
REM ** Creer un dossier pour les  shapefiles                         **
REM ** Creer un dossier pour les resultats des fichiers sql          **
REM ** Definisser la variable  PATH_SHP vers 						 **
REM **  								le dossier des shapefiles    **
REM ** Definisser la variable PATH_PSQL vers psql.exe                **
REM ** Definisser la variable PATH_SHP2SQL vers sh2pgsql.exe         **
REM ** Definisser la variable PATH_SQL vers le dossier 				 **
REM **  								des fichiers SQL 			 **
REM ** Definisser la variable pghost avec l'adresse de votre 		 **
REM **  								server PostgreSQL 			 **
REM ** Definisser la variable pgport avec votre port de postgres     **
REM ** Definisser la variable pgdb  : votre base de donnees cible    **
REM ** Definisser la variable pgsrid avec le SRID de vos shapefiles  **
REM ** Definisser la variable pggeom pour choisir le nom de 		 **
REM **									votre colonne "geometry"     **
REM **                               								 **
REM ** Definisser la variable pgencoding avec un type  encodage      **
REM ** Definisser la variable pgschema avec le schema cible pour     **
REM ** 			 						les tables a integrer 		 **
REM ** Definisser la variable pgtable optionnelle pour des prefixes  **
REM ** Definisser la variable pguser pour le nom d utilisateur       **
REM ** Definisser la  variable pgpassword pour le mot de passe       **
REM **                                                               **
REM ** Apres ces changements enregistrer le fichier au format .bat   **
REM ** Exemple  shapefiles2postgis.bat   						     **
REM ** Double cliquer sur le fichier .bat pour l'executer            **                                      
REM ** Et attendre les resultats .... :)                             **
REM **                                                               **
REM *******************************************************************

set PATH_SHP="C:\Users\jean-Noel-11\Documents\Atlas_AVP_ADN\shp3"
set PATH_PSQL=C:\Program Files\PostgreSQL\10\bin\psql.exe
set PATH_SHP2SQL=C:\Program Files\PostgreSQL\10\bin\shp2pgsql.exe
set PATH_SQL="C:\Users\jean-Noel-11\Documents\Atlas_AVP_ADN\sql"

set pghost=qualification.metis-map.fr
set pgport=5432
set pgdb=territoire
set pgsrid=2154
set pggeom=geom
set pgencoding="CP1252"
set pgschema=region
 
::set pgtable_prefix=""

set pguser=postgres
set pgpassword=leoHe:4?d


REM "Parcourir le dossier et creer un fichier sql pour chaque shp "
for %%f in (%PATH_SHP%\*.shp) do "%PATH_SHP2SQL%" -s %pgsrid%   -g %pggeom% -d -D -i -I -W %pgencoding% %%f %pgschema%.%%~nf > %PATH_SQL%\%%~nf.sql

REM "Parcourir le dossier sql et integrer les fichiers SQL dans la base de donnees Postgres et creer un fichier log pour chaque donnees integrer"
for %%f in (%PATH_SQL%\*.sql) do "%PATH_PSQL%" -h %pghost% -p %pgport% -d %pgdb% -L %%~nxf.log -U %pguser% -f %%f

REM " Suppimer tous les fichiers sql dans le dossier SQL "
for %%f in (%PATH_SQL%\*.sql) do del %%f
pause