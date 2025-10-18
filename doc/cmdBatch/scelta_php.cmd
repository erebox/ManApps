@echo off
title Scelta PHP

set dir_b=%~dp0php
set app_v=8.1.16

call scx.cmd "Scelta PHP" "7.4|8.1|8.2|8.3|8.4" SCELTA #EDF #639 #306 #FFF 350 400
if not defined SCELTA goto ERRORE
if "%SCELTA%"=="7.4" set app_v=7.4.20
if "%SCELTA%"=="8.1" set app_v=8.1.32
if "%SCELTA%"=="8.2" set app_v=8.2.28
if "%SCELTA%"=="8.3" set app_v=8.3.21
if "%SCELTA%"=="8.4" set app_v=8.4.7
rmdir %dir_b%
mklink /D %dir_b% %dir_b%-lst\php-%app_v%

goto FINE

:ERRORE
color 0c
echo Nessuna scelta...

:FINE
timeout /t 2
color 07
exit/b
