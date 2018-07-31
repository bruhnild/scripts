REM #### Chemin vers psql et pgsql2shp
cd C:\Program Files\PostgreSQL\10\bin\
REM #### Création des tables dans pg_admin
psql.exe -h 192.168.101.254 -p 5432 -U postgres -w -d hsn -f C:\github_repo\github_repo_scripts\scripts\BATCH\create_multiple_tables_with_valuecolumn\gexec_t_adresse.sql
REM #### Export en SHP
cd C:\OSGeo4W64\bin\
ogr2ogr -f "ESRI Shapefile" C:\github_repo\github_repo_scripts\scripts\BATCH\create_multiple_tables_with_valuecolumn\livrables_shp PG:"host=192.168.101.254 user=postgres password=l0cA!L8: schemas=gracethd_metis_livrables dbname=hsn " 

PAUSE

