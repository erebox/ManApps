@echo off
title Scelta JDK

set dir_b=%~dp0python
set app_v=3.11.2

call scx.cmd "Scelta Python" "3.12|3.13|3.14" SCELTA #FFE #FD0 #CA0 #FFF 350 400
if not defined SCELTA goto ERRORE
if "%SCELTA%"=="3.12" set app_v=3.12.10
if "%SCELTA%"=="3.13" set app_v=3.13.8
if "%SCELTA%"=="3.14" set app_v=3.14.0

rmdir %dir_b%
mklink /D %dir_b% %dir_b%-lst\Python-%app_v%

goto FINE

:ERRORE
color 0c
echo Nessuna scelta...

:FINE
timeout /t 2
color 07
exit/b
