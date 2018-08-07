@ECHO OFF
cd C:\OSGeo4W64\bin\
for %%f in (C:\Users\jean-Noel-11\Documents\Atlas_AVP_ADN\*.json) do ogr2ogr -skipfailures --config PGCLIENTENCODING UTF8 -lco "OVERWRITE=YES" -lco SCHEMA=pci_dep_01 -f "PostgreSQL" PG:"host=qualification.metis-map.fr user=postgres password=xxx dbname=territoire port=5432" -t_srs EPSG:2154 -nlt PROMOTE_TO_MULTI %%f
PAUSE