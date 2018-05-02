@ECHO OFF
cd C:\OSGeo4W64\bin\
ogr2ogr -f "ESRI Shapefile" C:\github_repo\github_repo_batch\batch\data_export_pgadmin_toshp\bdd_to_shapefile_export.shp PG:"host=www.metis-reseaux.fr user=postgres password=UhtS.1Hd2 port=5678 tables=test.buffer_difference_02 dbname=est" 
pause

