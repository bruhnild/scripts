#!/bin/bash

# psql.exe -h 192.168.101.254 -p 5432 -U postgres -d hsn -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_noeud\01_gracethd_t_noeud_insert.sql -t
# psql.exe -h 192.168.101.254 -p 5432 -U postgres -d hsn -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_znro\01_gracethd_t_znro_insert.sql -t
# psql.exe -h 192.168.101.254 -p 5432 -U postgres -d hsn -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_zsro\01_gracethd_t_zsro_insert.sql -t
# psql.exe -h 192.168.101.254 -p 5432 -U postgres -d hsn -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_sitetech\01_gracethd_t_sitetech_insert.sql -t

psqluser="postgres"   # Database username
psqlpass="l0cA!L8:"  # Database password
psqldb="hsn"   # Database name

path="/home/public/20-MOE70-HSN/07-Scripts/SQL/gracethd"
sql1="/t_noeud/01_gracethd_t_noeud_insert.sql"
sql2="/t_znro/01_gracethd_t_znro_insert.sql"
sql3="/t_zsro/01_gracethd_t_zsro_insert.sql"
sql4="/t_sitetech/01_gracethd_t_sitetech_insert.sql"
# sudo printf "CREATE USER $psqluser WITH PASSWORD '$psqlpass';" > cartaro.sql
# sudo -u postgres psql -f cartaro.sql

echo "Running 01_gracethd_t_noeud_insert.sql"
# psql -U postgres -d hsn -f
"C:\Program Files\PostgreSQL\10\bin\psql.exe" -d $psqldb [[ -f ${path}${sql1} ]] && echo $sql1" exist" || echo $sql1" File does not exist - END ==========" exit 1

echo "END SCRIPT ============="

read -p "Appuyer sur une touche pour continuer ..."