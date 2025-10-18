@echo off
title Scelta GIT

set dir_b=%~dp0git
set app_v=2.21.0

call scx.cmd "Scelta GIT" "2.39|2.51" SCELTA #FEE #F00 #A00 #FFF 300 400
if not defined SCELTA goto ERRORE
if "%SCELTA%"=="2.39" set app_v=2.39.1
if "%SCELTA%"=="2.51" set app_v=2.51.0.2

rmdir %dir_b%
mklink /D %dir_b% %dir_b%-lst\git-%app_v%

goto FINE

:ERRORE
color 0c
echo Nessuna scelta...

:FINE
timeout /t 2
color 07
exit/b
