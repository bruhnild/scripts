@echo off

rem definition des variables

set user=%USERNAME%
set chemin=/home/public/FTTH\ RIP/14-ADN/04-Scripts/rapport_bi_mensuel/bash/
set server=192.168.101.254
set script=call_python_script.sh

rem test de l'existance du dossier PuTTy
for /f "delims=" %%a in ('where.exe plink') do @set progpath="%%a"
if not exist %progpath% (
	echo "Putty n'est pas installe"
	pause
	exit 1
) else (
	echo ------======================================------
	echo ------= Lancement du script sur le serveur =------
	echo ------======================================------
	echo .	
	echo Merci de saisir le mot de passe de l'utilisateur %user% :
	plink %user%@%server% %chemin%%script%
	pause
)

