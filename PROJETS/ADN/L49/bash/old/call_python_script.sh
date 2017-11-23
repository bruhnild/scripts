#!/bin/bash
#
#Version:1.0
#Auteur: m.faucher@metis-reseaux.fr}
#Actions:
# -export bdd vers csv
# -lancement scripts python
# -gÃ©nÃ©ration de dossier par opportunitÃ©
# -copie des csv" et du fichier modÃ¨le dans chaque dossier
# -suppression dans les csv des lignes dont le numÃ©ro opportunitÃ© est diffÃ©rent du nom du dossier
path=$(pwd)
sql1="/opportunites_synthese.sql"
sql2="/opportunites_typegc.sql"

echo "Start script ===================="
# find sql files
[[ -f ${path}${sql1} ]] && echo $sql1" exist" || echo $sql1" File does not exist - END ==========" exit 1

[[ -f ${path}${sql2} ]] && echo $sql2" exist" || echo $sql2" File does not exist - END ==========" exit 1

# test if python exist
if ! command -v python3
then
  echo "Error : python was not find"
  exit 1
else
  echo "find psql"
fi

# test if psql exist
if ! command -v psql
then
  echo "Error : psql was not find"
  exit 1
else
  echo "Export DB to CSV =========="
fi

# Create CSV files
echo $(pwd)
# test if folder exists
if [ -d /tmp ]
then
 cd /tmp
 echo "PSQL COMMAND ================"
 command export PGPASSWORD='UhtS.1Hd2'; psql -U postgres -h www.metis-reseaux.fr -p 5678 -d l49 -f "${path}${sql1}" -t
 command export PGPASSWORD='UhtS.1Hd2'; psql -U postgres -h www.metis-reseaux.fr -p 5678 -d l49 -f "${path}${sql2}" -t
 echo "END Export ================="

 echo "Python COMMAND ============="
 python3 "${path}/launcher.py" "${path}"

 #Â wait during folder creation
 sleep 10s

else
  echo "No directory to work"
  exit 1
fi

echo $(pwd)
#rm *.csv

echo "END SCRIPT ============="

