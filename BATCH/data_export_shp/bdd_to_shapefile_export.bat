@ECHO OFF
cd C:\OSGeo4W64\bin\
ogr2ogr -f "ESRI Shapefile" C:\github_repo\github_repo_batch\batch\data_export_pgadmin_toshp\bdd_to_shapefile_export.shp PG:"host=localhost user=postgres password=postgres dbname=thd_isere" 
pause

