@ECHO OFF
cd C:\OSGeo4W64\bin\
for %%f in (C:\Users\jean-Noel-11\Documents\Atlas_AVP_ADN\*.shp) do ogr2ogr -skipfailures --config PGCLIENTENCODING UTF8 -lco "OVERWRITE=YES" -lco SCHEMA=routing_cameroun -f "PostgreSQL" PG:"host=localhost user=postgres password=postgres dbname=routing" -t_srs EPSG:3857 -nlt PROMOTE_TO_MULTI %%f
PAUSE