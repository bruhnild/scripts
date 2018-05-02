@echo off
set user=m.faucher
set pass=Ev8_a7Jb
set Serveur=192.168.101.254
rem Suppression de toutes les connexion en place
net use * /delete /y
timeout  2 > NUL
rem Remise en place des Lecteurs Réseaux
net use F: "\\%Serveur%\Public\Affaire Metis" /persistent:yes /USER:%user% %pass%
net use G: "\\%Serveur%\Public\PROCESSUS METIS" /persistent:yes
net use H: "\\%Serveur%\Public\TUNISIE" /persistent:yes
net use I: "\\%Serveur%\Public\FTTH RIP" /persistent:yes
net use J: "\\%Serveur%\Public\AUTRES RESEAUX" /persistent:yes
net use K: "\\%Serveur%\Public\FTTH PRIVE" /persistent:yes
net use L: "\\%Serveur%\ORANGE" /persistent:yes
net use M: "\\%Serveur%\Public\Corolle" /persistent:yes
net use N: "\\%Serveur%\Public\ADMINISTRATIF" /persistent:yes
net use O: "\\%Serveur%\Public\FINANCIER" /persistent:yes
net use P: "\\%Serveur%\Public\ACHAT" /persistent:yes
net use Q: "\\%Serveur%\Public\OFFRE - COMMUNICATION" /persistent:yes
net use R: "\\%Serveur%\Public\PERFORMANCE" /persistent:yes
net use S: "\\%Serveur%\Public\COMPTABILITE" /persistent:yes
net use T: "\\%Serveur%\Public\RH" /persistent:yes
net use U: "\\%Serveur%\Entreprise_Metis" /persistent:yes
net use V: "\\%Serveur%\Public\Repertoire client" /persistent:yes
net use W: "\\%Serveur%\Public\Documentation technique" /persistent:yes
net use X: "\\%Serveur%\perso" /persistent:yes
net use Y: "\\%Serveur%\Public\METIS MAP" /persistent:yes
net use
pause