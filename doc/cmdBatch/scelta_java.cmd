@echo off
title Scelta JDK

set dir_b=%~dp0java
set app_v=adopt-jdk-11.0.17

call scx.cmd "Scelta JDK" "OpenJDK 8|OpenJDK 11|OpenJDK 17|OpenJDK 21|AdoptJDK 8|AdoptJDK 11|AdoptJDK 17|AdoptJDK 21" SCELTA #FEE #F88 #B66 #FFF 300 650
if not defined SCELTA goto ERRORE
if "%SCELTA%"=="OpenJDK 8" set app_v=jdk-8u441
if "%SCELTA%"=="OpenJDK 11" set app_v=jdk-11.0.26
if "%SCELTA%"=="OpenJDK 17" set app_v=jdk-17.0.14
if "%SCELTA%"=="OpenJDK 21" set app_v=jdk-21.0.7
if "%SCELTA%"=="AdoptJDK 8" set app_v=adopt-jdk-8u452
if "%SCELTA%"=="AdoptJDK 11" set app_v=adopt-jdk-11.0.27
if "%SCELTA%"=="AdoptJDK 17" set app_v=adopt-jdk-17.0.15
if "%SCELTA%"=="AdoptJDK 21" set app_v=adopt-jdk-21.0.7
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
