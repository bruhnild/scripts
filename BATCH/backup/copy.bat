@echo off
REM Sauvegarde_xxxxxx.bat
REM SAUVEGARDE DATEE D'UN DOSSIER xxxxxx SUR PLUSIEURS SUPPORTS EN UNE SEULE FOIS
REM DANS UN REPERTOIRE APPELE Sauvegarde
REM SI LE REPERTOIRE N'EXISTE PAS, IL EST CREE AUTOMATIQUEMENT
REM CE FICHIER BATCH EST A METTRE DANS LE REPERTOIRE QUI CONTIENT LE DOSSIER xxxxxx
REM ET FAIRE UN RACCOURCI DE CE BATCH SUR LE BUREAU
REM TESTE AVEC WIN10 OK
 
set repertoire=Sauvegarde
set dossier=Projet Lizmap
set disque1=C:\Users\jean-Noel-11\Desktop\temp
rem disque2=D:
set disqueReseau=\\SERVEURMETIS\Public
rem usb1=E:
 
 
rem destination1=%disque1%\%repertoire%\/Sauvegarde-%dossier%-%date:/=-%/%dossier%
rem destination2=%disque2%\%repertoire%\/Sauvegarde-%dossier%-%date:/=-%/%dossier%
set destination3=%disqueReseau%\%repertoire%\Sauvegarde-%dossier%-%date:/=-%/%dossier%
rem destination4=%usb1%\%repertoire%\/Sauvegarde-%dossier%-%date:/=-%/%dossier%
 
echo Copie du dossier "%dossier%" dans les dossiers:
echo "%destination1%"
echo "%destination2%"
echo "%destination3%"
echo "%destination4%"
 
echo Si le dossier existe deja choisir "Tous" (Cas de plusieurs sauvegardes dans la meme journee)
 
pause
xcopy "%dossier%" "%destination1%" /I/E
xcopy "%dossier%" "%destination2%" /I/E
xcopy "%dossier%" "%destination3%" /I/E
xcopy "%dossier%" "%destination4%" /I/E
echo Si la sauvegarde s'est effectuee correctement elle apparait dans les differents supports a la date d'aujourd'hui
 
pause
explorer.exe "%disque1%\%repertoire%\"
explorer.exe "%disqueReseau%\%repertoire%\"
explorer.exe "%disque2%\%repertoire%\"
explorer.exe "%usb1%\%repertoire%\"
 
 rem cmd
 rem sauvegarde de "xxxxxx"
 rem ci-dessous exemple de resultat, le nom daté du dossier de sauvegarde est automatique ex: Sauvegarde-xxxxxx-06-03-2017
 rem le sous repertoire de  "Nouveau dossier" ne comprend qu'un seul fichier "Freebox.url"
  
  
 rem Copie du dossier "xxxxxx" dans les dossiers:
 rem "C:\Sauvegarde\/Sauvegarde-xxxxxx-06-03-2017/xxxxxx"
 rem "D:\Sauvegarde\/Sauvegarde-xxxxxx-06-03-2017/xxxxxx"
 rem "\\FREEBOX\Disque dur\Sauvegarde\Sauvegarde-xxxxxx-06-03-2017/xxxxxx"
 rem "E:\Sauvegarde\/Sauvegarde-xxxxxx-06-03-2017/xxxxxx"
 rem Si le dossier existe deja choisir "Tous" (Cas de plusieurs sauvegardes dans la meme journee)
 rem Appuyez sur une touche pour continuer...
 rem xxxxxx\Nouveau dossier\Freebox.url
 rem 1 fichier(s) copié(s)
 rem xxxxxx\Nouveau dossier\Freebox.url
 rem 1 fichier(s) copié(s)
 rem xxxxxx\Nouveau dossier\Freebox.url
 rem 1 fichier(s) copié(s)
 rem xxxxxx\Nouveau dossier\Freebox.url
 rem 1 fichier(s) copié(s)
 rem Si la sauvegarde s'est effectuee correctement elle apparait dans les differents supports a la date d'aujourd'hui
 rem Appuyez sur une touche pour continuer...
  
 rem .... ensuite explorer ouvre les differents supports dans windows pour vérification


pause