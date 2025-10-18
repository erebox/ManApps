@echo off
title Scelta Maven

set dir_b=%~dp0maven
set app_v=adopt-jdk-17.0.6

call scx.cmd "Scelta Maven" "3.8.4|3.8.8|3.9.8|3.9.9" SCELTA #FED #F80 #E60 #FFF 300 400
if not defined SCELTA goto ERRORE
if "%SCELTA%"=="3.8.4" set app_v=apache-maven-3.8.4
if "%SCELTA%"=="3.8.8" set app_v=apache-maven-3.8.8
if "%SCELTA%"=="3.9.8" set app_v=apache-maven-3.9.8
if "%SCELTA%"=="3.9.9" set app_v=apache-maven-3.9.9

rmdir %dir_b%
mklink /D %dir_b% %dir_b%-lst\%app_v%

goto FINE

:ERRORE
color 0c
echo Nessuna scelta...

:FINE
timeout /t 2
color 07
exit/b
