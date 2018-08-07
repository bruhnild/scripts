cd C:\Program Files\PostgreSQL\10\bin\
set PGPASSWORD=xxx
pg_dump.exe -h 192.168.101.254 -p 5432 -U postgres -v -f C:\Users\jean-Noel-11\Documents\bdd_batch\coordination.sql -n coordination  adn_l49
pg_dump.exe -h 192.168.101.254 -p 5432 -U postgres -v -f C:\Users\jean-Noel-11\Documents\bdd_batch\administratif.sql -t administratif.communes adn_l49
pg_dump.exe -h 192.168.101.254 -p 5432 -U postgres -v -f C:\Users\jean-Noel-11\Documents\bdd_batch\rapport.sql -n  rapport adn_l49
set PGPASSWORD=xxx
psql.exe -h production.metis-map.fr -p 5432 -U postgres -d adn_l49 -c "DROP SCHEMA IF EXISTS coordination CASCADE;" 
psql.exe -h production.metis-map.fr -p 5432 -U postgres -d adn_l49 -c "CREATE SCHEMA coordination;" -f C:\Users\jean-Noel-11\Documents\bdd_batch\coordination.sql
psql.exe -h production.metis-map.fr -p 5432 -U postgres -d adn_l49 -c "DROP TABLE IF EXISTS administratif.communes CASCADE;" 
psql.exe -h production.metis-map.fr -p 5432 -U postgres -d adn_l49 -f C:\Users\jean-Noel-11\Documents\bdd_batch\administratif.sql
psql.exe -h production.metis-map.fr -p 5432 -U postgres -d adn_l49 -c "DROP SCHEMA IF EXISTS rapport CASCADE;" 
psql.exe -h production.metis-map.fr -p 5432 -U postgres -d adn_l49 -c "CREATE SCHEMA rapport;" -f C:\Users\jean-Noel-11\Documents\bdd_batch\rapport.sql
PAUSE