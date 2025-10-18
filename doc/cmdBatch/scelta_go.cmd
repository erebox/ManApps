@echo off
title Scelta GO

set dir_b=%~dp0go
set app_v=1.21.4

call scx.cmd "Scelta GO" "1.23|1.25" SCELTA #EEF #08F #06A #FFF 300 400
if not defined SCELTA goto ERRORE
if "%SCELTA%"=="1.23" set app_v=1.23.2
if "%SCELTA%"=="1.25" set app_v=1.25.2

rmdir %dir_b%
mklink /D %dir_b% %dir_b%-lst\go-%app_v%

goto FINE

:ERRORE
color 0c
echo Nessuna scelta...

:FINE
timeout /t 2
color 07
exit/b
