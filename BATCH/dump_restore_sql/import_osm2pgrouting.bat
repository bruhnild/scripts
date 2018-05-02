
osm2pgrouting --f cameroon-latest.osm --conf mapconfig.xml --host www.metis-reseaux.fr --dbname routing --port 5678 --username postgres  --addnode -- attributes --clean --tags

osm2pgrouting -f /home/metis/share/cameroon-latest.osm -c /home/metis/share/mapconfig.xml -h www.metis-reseaux.fr -d upap_demo_cameroun -p 5678 -U postgres   --schema routing --addnode -- attributes --clean --tags

osm2pgrouting --f cameroon-latest.osm --conf mapconfig.xml --host localhost --dbname routing --port 5432 --username postgres   --schema routing_cameroun --addnode -- attributes --clean --tags
