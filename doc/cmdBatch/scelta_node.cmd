@echo off
title Scelta Node

set dir_b=%~dp0node
set app_v=1.21.4

call scx.cmd "Scelta Node" "18|20|22|24" SCELTA #EEF #08F #06A #FFF 300 400
if not defined SCELTA goto ERRORE
if "%SCELTA%"=="18" set app_v=18.20.8
if "%SCELTA%"=="20" set app_v=20.19.5
if "%SCELTA%"=="22" set app_v=22.20.0
if "%SCELTA%"=="24" set app_v=24.9.0

rmdir %dir_b%
mklink /D %dir_b% %dir_b%-lst\node-v%app_v%-win-x64

goto FINE

:ERRORE
color 0c
echo Nessuna scelta...

:FINE
timeout /t 2
color 07
exit/b
