 
@echo off
md C:\batch\backup\%DATE:/=-%\%datestr%
c:
net use Y: \\SERVEURMETIS\Public 
xcopy /s V:\ADN\03-Webmapping\QGIS
pause

