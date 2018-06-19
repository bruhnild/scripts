@ECHO OFF
cd C:\OSGeo4W64\bin\
for %%f in (C:\Users\jean-Noel-11\Documents\Atlas_AVP_ADN\*.shp) do ogr2ogr -skipfailures --config PGCLIENTENCODING UTF8 -lco "OVERWRITE=YES" -lco SCHEMA=temp -f "PostgreSQL" PG:"host=localhost user=postgres password=postgres dbname=optimisation_diag" -t_srs EPSG:2154 -nlt PROMOTE_TO_MULTI %%f
PAUSE