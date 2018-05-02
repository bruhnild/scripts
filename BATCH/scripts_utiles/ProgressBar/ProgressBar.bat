@echo off
title Chargement en cours... Veuillez patienter.
mode con cols=65 lines=9 &color 1A
:: stryk@live.fr
set NB_BAR=0
:UP_BAR
cls
set /a FULL = FULL + 1
set BAR=%BAR%Û
set /a NB_BAR = NB_BAR + 2
echo.
echo.
echo Chargement .... %NB_BAR%%%
echo ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
echo %BAR%
echo %BAR%
echo ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
echo.
if %FULL%==50 goto :END_BAR
@ping localhost -n 1 >nul
goto :UP_BAR
:END_BAR