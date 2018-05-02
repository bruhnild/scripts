@Echo Off
mode con: cols=120 lines=8
color 1a
setlocal EnableDelayedExpansion
if not exist genere.bat  (echo @Echo Off
                          echo :::GENERATION D'un fichier de 200 000 Octest
                          echo if exist #nul#.val del #nul#.val
                          echo for /l %%%%a in ^(1=1=50000^) do echo 0 ^>^>#nul#.val)>>genere.bat

set $taille=200000
set $fichier=#nul#.val
set /a $pas=%$taille:~0,-2%*4
set $graph=°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
set $graph1=%$graph%
set $pc=0
set $pc1=100
set $val_temp=%$pas%

start /min genere.bat ^& echo.^>end.tst ^& exit

cls
echo Taille du fichier : 0
echo.
echo    [%$graph%] !$pc! %% Trait‚
echo.
echo    [%$graph1%] !$pc! %% Trait‚
echo.
echo    [ - By SachaDee - 2013 - ] 

:progression

call:affiche %$fichier%
goto:progression
goto:eof

:affiche
>nul PING localhost -n 2 -w 1000
cls

echo Taille du fichier : %~z1
echo.

if %~z1 geq !$val_temp! (set /a $val_temp=!$val_temp!+%$pas%
                         set /a $pc+=4
                         set /a $pc1-=4
                         set $graph=!$graph:~0,-4!
                         set $graph=²²²²!$graph!
                         set $graph1=!$graph1:~4!
                         set $graph1=!$graph1!²²²²)

echo    [%$graph%] !$pc! %% Trait‚
echo.
echo    [%$graph1%] !$pc1! %% Restant
echo.
echo    [ - By SachaDee - 2013 - ] 

if !$pc!==100 goto:termine

goto :eof

:termine
endlocal
echo Traitement termin‚
pause
exit