REM #### activation du mode verbeux
@echo on

REM ####
C:
REM #### condition si fichier existe 
IF NOT EXIST "C:\Program Files\PostgreSQL\10\bin" GOTO NOWINDIR
IF NOT EXIST %localappdata%\Programs\Python\Python36-32 GOTO NOWINDIR

REM #### aller dans postgres/bin
CD C:\Program Files\PostgreSQL\10\bin\

REM #### PHASE 1 : Création des triggers qui iront mettre à jour les champs des tables d'entrées du schema rbal
psql.exe -h 192.168.101.254 -p 5432 -U postgres -P l0cA!L8: -P l0cA!L8: -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\01_triggers\01_bal.sql -t
psql.exe -h 192.168.101.254 -p 5432 -U postgres -P l0cA!L8: -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\01_triggers\02_racco.sql -t
psql.exe -h 192.168.101.254 -p 5432 -U postgres -P l0cA!L8: -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\01_triggers\03_liaison.sql -t
psql.exe -h 192.168.101.254 -p 5432 -U postgres -P l0cA!L8: -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\01_triggers\04_liaison_voie.sql -t
psql.exe -h 192.168.101.254 -p 5432 -U postgres -P l0cA!L8: -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\01_triggers\05_liaison_voie_sanspci.sql -t
@echo Les triggers sont créés
REM #### PHASE 2 : Création des vues de controle
psql.exe -h 192.168.101.254 -p 5432 -U postgres -P l0cA!L8: -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\02_controles\01_bal.sql -t
psql.exe -h 192.168.101.254 -p 5432 -U postgres -P l0cA!L8: -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\02_controles\04_liaison.sql -t
@echo Les vues de controle sont créées
REM #### PHASE 3 : Création des vues pour la vue matérialisée - calcul des champs
psql.exe -h 192.168.101.254 -p 5432 -U postgres -P l0cA!L8: -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\03_vues\bal_ad_ban_id.sql -t
psql.exe -h 192.168.101.254 -p 5432 -U postgres -P l0cA!L8: -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\03_vues\bal_nom_sro.sql -t
psql.exe -h 192.168.101.254 -p 5432 -U postgres -P l0cA!L8: -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\03_vues\bal_ad_ban_x_y.sql -t
psql.exe -h 192.168.101.254 -p 5432 -U postgres -P l0cA!L8: -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\03_vues\bal_ad_distinf.sql -t
psql.exe -h 192.168.101.254 -p 5432 -U postgres -P l0cA!L8: -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\03_vues\bal_ad_fantoir.sql -t
psql.exe -h 192.168.101.254 -p 5432 -U postgres -P l0cA!L8: -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\03_vues\bal_ad_idpar_x_y.sql -t
psql.exe -h 192.168.101.254 -p 5432 -U postgres -P l0cA!L8: -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\03_vues\bal_ad_isole.sql -t
psql.exe -h 192.168.101.254 -p 5432 -U postgres -P l0cA!L8: -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\03_vues\bal_ad_nbprpro.sql -t
psql.exe -h 192.168.101.254 -p 5432 -U postgres -P l0cA!L8: -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\03_vues\bal_ad_nomvoie.sql -t
psql.exe -h 192.168.101.254 -p 5432 -U postgres -P l0cA!L8: -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\03_vues\bal_ad_numero.sql -t
psql.exe -h 192.168.101.254 -p 5432 -U postgres -P l0cA!L8: -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\03_vues\bal_ad_rep.sql -t
psql.exe -h 192.168.101.254 -p 5432 -U postgres -P l0cA!L8: -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\03_vues\bal_geom.sql -t
psql.exe -h 192.168.101.254 -p 5432 -U postgres -P l0cA!L8: -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\03_vues\bal_nb_prises_totale.sql -t
psql.exe -h 192.168.101.254 -p 5432 -U postgres -P l0cA!L8: -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\03_vues\bal_nom_id.sql -t
psql.exe -h 192.168.101.254 -p 5432 -U postgres -P l0cA!L8: -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\03_vues\bal_ad_nom_ld.sql -t
psql.exe -h 192.168.101.254 -p 5432 -U postgres -P l0cA!L8: -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\03_vues\bal_potentiel_ftte.sql -t
psql.exe -h 192.168.101.254 -p 5432 -U postgres -P l0cA!L8: -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\03_vues\bal_statut.sql -t
@echo Les vues sont créées
REM #### PHASE 4 : Création de la vue matérialisée 
psql.exe -h 192.168.101.254 -p 5432 -U postgres -P l0cA!L8: -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\04_processing\01_gracethd_metis_t_adresse.sql -t
psql.exe -h 192.168.101.254 -p 5432 -U postgres -P l0cA!L8: -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\04_processing\02_rbal_t_adresse.sql -t
psql.exe -h 192.168.101.254 -p 5432 -U postgres -P l0cA!L8: -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\04_processing\03_gracethd_t_adresse_calculchamps_vue.sql -t
psql.exe -h 192.168.101.254 -p 5432 -U postgres -P l0cA!L8: -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\03_vues\bal_cas_particuliers.sql -t
psql.exe -h 192.168.101.254 -p 5432 -U postgres -P l0cA!L8: -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\04_processing\04_gracethd_t_adresse_vue.sql -t
psql.exe -h 192.168.101.254 -p 5432 -U postgres -P l0cA!L8: -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\04_processing\05_gracethd_t_adresse_insert.sql -t
REM psql.exe -h 192.168.101.254 -p 5432 -U postgres -P l0cA!L8: -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\04_processing\06_gracethd_t_adresse_triggerinsert.sql -t
@echo La table t_adresse est créée
REM #### PHASE 6 : Export en SHP
pgsql2shp.exe -f "I:/20-MOE70-HSN/07-Scripts/SQL/gracethd/t_adresse/mode_nominal/06_exports/shp/export_v_adresse" -h 192.168.101.254 -p 5432 -U postgres -P l0cA!L8: -d hsn rbal.v_adresse_export
REM #### PHASE 6 : Export en CSV
psql.exe -h 192.168.101.254 -p 5432 -U postgres -P l0cA!L8: -d hsn  -f I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\06_exports\csv\export_v_adresse.sql -t
REM #### Aller dans I:\20-MOE70-HSN\07-Scripts\SQL\gracethd\t_adresse\mode_nominal\06_exports\csv pour exécuter le .py


PAUSE

REM #### mettre en attente
exit /b 0
:NOWINDIR
echo "Il manque psql ou python : impossible d'executer le script"
PAUSE
exit /b 1


