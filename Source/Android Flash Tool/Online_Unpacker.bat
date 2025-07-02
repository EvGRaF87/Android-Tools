::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAjk
::fBw5plQjdCyDJGyX8VAjFBdRQwqLAE+/Fb4I5/jHzeuTnXkSa8cnfbD41bqYJfIH71fbJth/6ltKiPctHAtxcBSkUhs7pmIMv2eKVw==
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSjk=
::cBs/ulQjdF65
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpSI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBNQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+JeA==
::cxY6rQJ7JhzQF1fEqQJQ
::ZQ05rAF9IBncCkqN+0xwdVs0
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCyDJH+I9VE4FDRgbUSyPXmuD6EV5+bor9+JskweX+ctNorD39Q=
::YB416Ek+ZW8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
chcp 65001 > nul
reg query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || set OS=64BIT
if %OS%==32BIT set arch=x32
if %OS%==64BIT set arch=x64
----------------
mode con cols=87 lines=35
set P0=700
set quan=160
setlocal enabledelayedexpansion
set "unpack=%~dp0PAYLOAD\bin\dumper.py"
set "COLOR_BROWN=[33m"
set "COLOR_RESET=[0m"
color 0b
title                           Fastboot OTA Unpacker
ECHO                        ############################
ECHO                          #  Unpacker by SeRViP  #
ECHO                       ############################
echo.
echo.
set /p part=!COLOR_BROWN!Введите partitions: !COLOR_RESET!
echo.
echo.
set /p URL=!COLOR_BROWN!Введите URL: !COLOR_RESET!
echo.
cls
python %unpack% --partitions %part% %URL%
echo.
echo -----------------------------------------------------------------------------
echo                                Press any key . .
pause >nul
exit /b