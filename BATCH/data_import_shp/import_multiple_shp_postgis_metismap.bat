@ECHO OFF
cd C:\OSGeo4W64\bin\
for %%f in (C:\Users\jean-Noel-11\Documents\Atlas_AVP_ADN\*.shp) do ogr2ogr -skipfailures --config PGCLIENTENCODING UTF8 -lco "OVERWRITE=YES" -lco SCHEMA=itineraires -f "PostgreSQL" PG:"host=www.metis-reseaux.fr user=postgres password=UhtS.1Hd2 dbname=upap_demo_cameroun port=5678" -t_srs EPSG:2154 -nlt PROMOTE_TO_MULTI %%f
PAUSE