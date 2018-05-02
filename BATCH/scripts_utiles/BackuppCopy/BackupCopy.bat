@ECHO.
@echo.	"OPERATION DE SAUVEGARDE AVANT D'ETEINDRE L'ORDINATEUR" ;
@echo.		" SAUVEGARDE DE MES FICHIERS SUR UN AUTRE SUPPORT"

rem  ***** mise en place des variables pour le fichier log (si créé) *****

set data=Copie du: %Date% a %Time%

rem *****  En-tête  ******

echo           ************************************
echo           *                                   *
echo           *    Programme de sauvegarde        *
echo           *                                   *
echo           ************************************

rem ***** Début du programme *****

:C
xcopy /K "C:\batch\data_import_shp\*.bat" "C:\batch\scripts_utiles" /H/E/D/C/I/R/V/Y/J/Q



@echo.
@echo.	 "La Copie est terminee!"
@echo.
PAUSE
goto end


