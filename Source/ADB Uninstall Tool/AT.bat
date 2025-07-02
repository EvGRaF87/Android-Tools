MODE 150
@echo off
mode con cols=87 lines=40
set P0=1000
set quan=100
:prelaunch
TITLE Adb Tool
color 07
echo. 
----------------
SETLOCAL EnableDelayedExpansion

set "Logo=%~dp0\banner.bat"

:menu
cls
echo.
echo.     [%DATE%]   [%TIME:~0,5%]   [%CD%]
echo   -----------------------------------------------------------------------------------
call "%Logo%"
echo   ===================================================================================
echo                                      APK MENU
echo   ===================================================================================
echo.
echo           ________________________________________________________________
echo           _____________________________     ______________________________
echo                                          *
echo            [1] Uninstall System App       #   [2] Uninstall No System App
echo           _____________________________  *  ______________________________
echo                                          *
echo            [3] List of System App        #   [4] List of No System App
echo           _____________________________  *  ______________________________
echo.
echo           ________________________________________________________________
echo.
echo   ===================================================================================
echo                                    [%COMPUTERNAME%] 
echo   ===================================================================================
echo.
set  /a choise = 0
set /p choise=Please Select: 
echo.
if "%choise%"=="1" goto :unsys
if "%choise%"=="2" goto :unosys
if "%choise%"=="3" goto :lstsys
if "%choise%"=="4" goto :lstnosys
GOTO menu

:unosys
cls
echo.
adb shell pm list packages -3 > nonSystemApk.tmp && ATAHelper apkNS nonSystemApk.tmp && del nonSystemApk.tmp
pause
goto :unosys 

:unsys
cls
echo.
adb shell pm list packages -s > SystemApk.tmp && ATAHelper apkS SystemApk.tmp && del SystemApk.tmp
pause
goto :unsys

:lstsys
cls
echo.
adb shell pm list packages -s
pause
goto :menu 

:lstnosys
cls
echo.
adb shell pm list packages -3
pause
goto :menu 
