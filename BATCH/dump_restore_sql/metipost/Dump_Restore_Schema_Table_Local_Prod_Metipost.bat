cd C:\Program Files\PostgreSQL\10\bin\
set PGPASSWORD=l0cA!L8:
pg_dump.exe -h 192.168.101.254 -p 5432 -U postgres -v -f C:\Users\jean-Noel-11\Documents\bdd_batch\metipost\administratif.sql -n administratif  metipost
pg_dump.exe -h 192.168.101.254 -p 5432 -U postgres -v -f C:\Users\jean-Noel-11\Documents\bdd_batch\metipost\analyses.sql -n analyses  metipost
pg_dump.exe -h 192.168.101.254 -p 5432 -U postgres -v -f C:\Users\jean-Noel-11\Documents\bdd_batch\metipost\ban.sql -n ban  metipost
pg_dump.exe -h 192.168.101.254 -p 5432 -U postgres -v -f C:\Users\jean-Noel-11\Documents\bdd_batch\metipost\routes.sql -n routes  metipost
pg_dump.exe -h 192.168.101.254 -p 5432 -U postgres -v -f C:\Users\jean-Noel-11\Documents\bdd_batch\metipost\statistiques.sql -n statistiques  metipost
pg_dump.exe -h 192.168.101.254 -p 5432 -U postgres -v -f C:\Users\jean-Noel-11\Documents\bdd_batch\metipost\topology.sql -n topology  metipost
set PGPASSWORD=leoHe:4?d
psql.exe -h qualification.metis-map.fr -p 5432 -U postgres -d metipost -c "DROP SCHEMA IF EXISTS administratif CASCADE;" 
psql.exe -h qualification.metis-map.fr -p 5432 -U postgres -d metipost -c "CREATE SCHEMA administratif;" -f C:\Users\jean-Noel-11\Documents\bdd_batch\metipost\administratif.sql
psql.exe -h qualification.metis-map.fr -p 5432 -U postgres -d metipost -c "DROP SCHEMA IF EXISTS analyses CASCADE;" 
psql.exe -h qualification.metis-map.fr -p 5432 -U postgres -d metipost -c "CREATE SCHEMA analyses;" -f C:\Users\jean-Noel-11\Documents\bdd_batch\metipost\analyses.sql
psql.exe -h qualification.metis-map.fr -p 5432 -U postgres -d metipost -c "DROP SCHEMA IF EXISTS ban CASCADE;" 
psql.exe -h qualification.metis-map.fr -p 5432 -U postgres -d metipost -c "CREATE SCHEMA ban;" -f C:\Users\jean-Noel-11\Documents\bdd_batch\metipost\ban.sql
psql.exe -h qualification.metis-map.fr -p 5432 -U postgres -d metipost -c "DROP SCHEMA IF EXISTS routes CASCADE;" 
psql.exe -h qualification.metis-map.fr -p 5432 -U postgres -d metipost -c "CREATE SCHEMA routes;" -f C:\Users\jean-Noel-11\Documents\bdd_batch\metipost\routes.sql
psql.exe -h qualification.metis-map.fr -p 5432 -U postgres -d metipost -c "DROP SCHEMA IF EXISTS statistiques CASCADE;" 
psql.exe -h qualification.metis-map.fr -p 5432 -U postgres -d metipost -c "CREATE SCHEMA administratif;" -f C:\Users\jean-Noel-11\Documents\bdd_batch\metipost\statistiques.sql
psql.exe -h qualification.metis-map.fr -p 5432 -U postgres -d metipost -c "DROP SCHEMA IF EXISTS topology CASCADE;" 
psql.exe -h qualification.metis-map.fr -p 5432 -U postgres -d metipost -c "CREATE SCHEMA topology;" -f C:\Users\jean-Noel-11\Documents\bdd_batch\metipost\topology.sql

PAUSE