@ECHO OFF
cd C:\OSGeo4W64\bin\
ogr2ogr -f "ESRI Shapefile" C:\Users\jean-Noel-11\Documents\bdd_batch\adn_nro\shp PG:"host=192.168.101.254 user=postgres password=l0cA!L8: schemas=ep_vol4 dbname=adn_nro " 
pause
