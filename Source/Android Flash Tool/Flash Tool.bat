@echo off
chcp 65001 > nul
----------------
reg query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || set OS=64BIT
if %OS%==32BIT set arch=x32
if %OS%==64BIT set arch=x64
----------------
mode con cols=87 lines=35
set P0=700
set quan=160
----------------
SETLOCAL EnableExtensions DisableDelayedExpansion
for /F %%a in ('echo prompt $E ^| cmd') do (
  set "ESC=%%a"
)
----------------
SETLOCAL EnableDelayedExpansion

set clr=%~dp0bin\cmdcolor.exe
set "vFd=%~dp0ROM"
set "vTr=%~dp0BOOTLOADER"
set "comprel=%~dp0bin\bin"
set "list=%~dp0bin\adb.exe shell pm list package > Device-list-apk.txt"
set adb=%~dp0bin\adb.exe
set fastboot=%~dp0bin\fastboot.exe
set "deviceNames=ossi Android"
set "deviceNames=Android"
set aria=%~dp0bin/aria2c.exe
set txt=%~dp0bin\remove.txt
set sus=%~dp0bin\suspend.txt
set unsus=%~dp0bin\unsuspend.txt
set curl=%~dp0bin\curl.exe
set wintee=%~dp0bin\wtee.exe
set ddr=%~dp0ROM\ddr.img
set "iboot=%~dp0PAYLOAD\bin\dumper.exe"
set "patch=%~dp0bin\Patcher\magiskpatcher.exe"
set "uninst=%~dp0\bin\adb.exe shell pm uninstall -k --user 0"
set "disab=%~dp0\bin\adb.exe shell pm disable-user --user 0"
set "susp=%~dp0\bin\adb.exe shell cmd package suspend"
set "unsusp=%~dp0\bin\adb.exe shell pm unsuspend"
set "unzip=%~dp0bin\7z.exe"
set "bz=%~dp0bin\bz.exe"
----------------
:check_driver
pnputil -e > %temp%\driver.txt

>nul find "LeMobile" %temp%\driver.txt 2>nul
if %errorlevel%==0 (
set var=Installed
)

if %errorlevel%==1 (
set var=Not Installed
)
:start
cls
chcp 65001>nul
----------------
-----------------------------------------------------------------------
Set   A1=!ESC![36mFlash ROM (FLASH and COW)!ESC![0m          
Set   A2=!ESC![36mCHECK Device!ESC![0m
Set   A3=!ESC![36mFlash BOOT/ INIT_BOOT/ RECOVERY!ESC![0m
Set   A4=!ESC![36mMenu "Reboot"!ESC![0m
Set   A5=!ESC![36mFormat Data (Clear userdata)!ESC![0m
Set   A6=!ESC![36mAPPS Uninstall/Install!ESC![0m
Set   A7=!ESC![36mUnlock/Lock the Bootloader!ESC![0m
Set   A8=!ESC![36mUnPack Firmware!ESC![0m
Set   A9=!ESC![36mMAGISK Patching!ESC![0m
Set   A10=!ESC![36mDownload FIRMWARE!ESC![0m
Set   A11=!ESC![36mPlatform-Tool!ESC![0m
Set   A0=Введите номер
Set   A13=Процесс успешно завершён!
Set   A12=Нажмите любую клавишу для выхода...
chcp 65001>nul
color 0b
title                                 Flasher By SeRViP
cls
echo.
echo.    [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]	
echo.!ESC![31m_______________________________________________________________________________________!ESC![0m
echo.
echo.                       !ESC![37mdMMMb  dMMMMMP dMMMMb  dMP dMP dMP dMMMMb!ESC![0m 
echo.                     !ESC![37mdMP" VP dMP     dMP.dMP dMP dMP amr dMP.dMP!ESC![0m 
echo.                     !ESC![37mVMMMb  dMMMP   dMMMMK" dMP dMP dMP dMMMMP"!ESC![0m  
echo.                   !ESC![37mdP .dMP dMP     dMP" AMF YMvAP" dMP dMP!ESC![0m       
echo.                   !ESC![37mVMMMP" dMMMMMP dMP  dMP   VP"  dMP dMP!ESC![0m                                                 
echo.!ESC![31m_______________________________________________________________________________________!ESC![0m
echo.
echo.
echo     [1] %A1%   [2] %A2%
echo    \033[33m--------------------------------------    \033[33m--------------------------------------| %clr%
echo     [3] %A3%       [4] %A4%
echo    \033[33m--------------------------------------    \033[33m--------------------------------------| %clr%
echo     [5] %A5%          [6] %A6%
echo    \033[33m--------------------------------------    \033[33m--------------------------------------| %clr%
echo     [7] %A7%            [8] %A8%
echo    \033[33m--------------------------------------    \033[33m--------------------------------------| %clr%
echo     [9] %A9%                       [10] %A10%
echo    \033[33m--------------------------------------    \033[33m--------------------------------------| %clr%
echo.
echo                                 [11] %A11%
echo.                        \033[33m--------------------------------------| %clr%
echo !ESC![31m_______________________________________________________________________________________!ESC![0m
echo.
echo                             !ESC![36mFastboot Driver!ESC![0m:!ESC![37m%var%!ESC![0m 
echo.
echo                 !ESC![36mAuthor!ESC![0m: !ESC![4mSeRViP!ESC![0m                      !ESC![36mBoot Mode!ESC![0m:!ESC![37m%var1%!ESC![0m
echo !ESC![31m_______________________________________________________________________________________!ESC![0m
echo.
set  /a choise = 0
set  /p choise=%a0%: 
if "%choise%" == "1" goto M1
if "%choise%" == "2" goto M2
if "%choise%" == "3" goto M3
if "%choise%" == "4" goto M4
if "%choise%" == "5" goto M5
if "%choise%" == "6" goto M6
if "%choise%" == "7" goto M7
if "%choise%" == "8" goto M8
if "%choise%" == "9" goto M9
if "%choise%" == "10" goto M10
if "%choise%" == "11" goto M11
goto start
---------------------------------- 
:M1
cls
set "count=0"
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo ---------------------------------------------------------------------------------------
echo.
echo                                   \033[33mFlash Firmware| %clr% ***
echo                            !ESC![31m****************************!ESC![0m
echo ---------------------------------------------------------------------------------------
echo.
echo          !ESC![31m_________________________________________________________________!ESC![0m
echo          !ESC![33m______________________________     !ESC![33m______________________________!ESC![0m
echo                                          !ESC![31m*!ESC![0m
echo           [1] !ESC![36mFlash \ Update!ESC![0m             !ESC![31m#!ESC![0m   [2] !ESC![36mFlash SUPER Partition!ESC![0m
echo          !ESC![33m______________________________  !ESC![31m*!ESC![0m  !ESC![33m______________________________!ESC![0m
echo                                          !ESC![31m*!ESC![0m
echo           [3] !ESC![36mDELETE COW Partitions!ESC![0m      !ESC![31m#!ESC![0m   [4] !ESC![36mERASE (Clear) FRP!ESC![0m
echo          !ESC![33m______________________________  !ESC![31m*!ESC![0m  !ESC![33m______________________________!ESC![0m
echo.
echo          !ESC![31m_________________________________________________________________!ESC![0m
echo.
echo           !ESC![36mFastboot Driver!ESC![0m:!ESC![37m%var%!ESC![0m           !ESC![36mBoot Mode!ESC![0m:!ESC![37m%var1%!ESC![0m
echo          !ESC![31m_________________________________________________________________!ESC![0m
echo.
echo.
set  /a choise = 0
set  /p choise=%a0%: 
IF "%choise%" == "0" GOTO M1
IF "%choise%" == "4" GOTO :FRP
IF "%choise%" == "3" GOTO :cow
IF "%choise%" == "2" GOTO :flsup
IF "%choise%" == "1" GOTO :flash
GOTO start

:flash
cls
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo.-------------------------------------------------------------------------------------
title                               Fastboot ROM Installer
echo.
echo.                         !ESC![31m********!ESC![0m !ESC![33mSeRViP production!ESC![0m !ESC![31m********!ESC![0m
echo.                               !ESC![31m***********************!ESC![0m
echo -------------------------------------------------------------------------------------
echo.
@echo off
set "vFd=ROM"
set "vTr=BOOTLOADER"
if not exist "%cd%\%vFd%" echo Directory "%vFd%" not found&goto :End
if not exist "%cd%\%vTr%" echo Directory "%vTr%" not found&goto :End
echo  !ESC![31mConnect your device to PC.!ESC![0m
echo.
set "log_file=Flash_log.txt"
set "timestamp=%DATE:~-4,4%-%DATE:~3,2%-%DATE:~0,2%_%TIME:~0,2%-%TIME:~3,2%-%TIME:~6,2%"
set "log_file=%log_file:.txt=_%%timestamp%.txt"

echo. > "%log_file%"
echo   --- Начало процесса: %timestamp% --- >> "%log_file%"
echo. >> "%log_file%"
:Lst
call :Slp&set /a "vN+=1"&for /f "tokens=2* delims=): " %%i in ('%fastboot% getvar all 2^>^&1 ^| findstr /i "is-userspace: current-slot: unlocked:"') do set "%%i=%%j"
if "%unlocked:yes=%"=="%unlocked%" echo Unlock your device in Bootloader mode to run&goto :End
if not "%is-userspace:yes=%"=="%is-userspace%" if "%vN%"=="1" (call :Pfd %is-userspace% %current-slot% %vN%&call :Pcs&goto :Lst
) else if "%vN%"=="2" call :Pfd %is-userspace% %current-slot% %vN%&call :Pcs&call :Prb&goto :Lst
if "%vN%"=="1" (set "vN=3"&set "vEo=3")
if not "%is-userspace:no=%"=="%is-userspace%" if "%vN%"=="3" (call :Pfb %is-userspace% %current-slot% %vN%&call :Pcs&goto :Lst
) else if "%vN%"=="4" (call :Pfb %is-userspace% %current-slot% %vN%&call :Pcs&goto :fnl)
:fnl
del %vFd%\*.img
del %vTr%\*.img
cls
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo.-------------------------------------------------------------------------------------
title                               Fastboot ROM Installer
echo.
echo.                         !ESC![31m********!ESC![0m !ESC![33mSeRViP production!ESC![0m !ESC![31m********!ESC![0m
echo.                               !ESC![31m***********************!ESC![0m
echo -------------------------------------------------------------------------------------
echo.
echo.
echo.
echo.
echo.                  !ESC![31m***********************************************!ESC![0m
echo.                        !ESC![36mF-L-A-S-H-I-N-G   C-O-M-P-L-E-T-E-D!ESC![0m
echo.                  !ESC![31m***********************************************!ESC![0m
echo.                                  !ESC![36mMade by SeRViP!ESC![0m
echo.                  !ESC![31m***********************************************!ESC![0m
echo.                           !ESC![36mDonate: 89228876595 VTB Bank!ESC![0m
echo.                  !ESC![31m***********************************************!ESC![0m
echo.
:end
goto end
:Pfb
del /q "%ddr%" >nul 2>&1
cls
echo.
if "%3"=="3" echo                ****** MAKE SURE THAT PHONE BOOTED TO BOOTLOADER ******
if "%3"=="3" echo.
if "%3"=="3" echo              ***********************************************************
if "%3"=="3" echo              *    Press any button if your phone in Bootloader mode    *
if "%3"=="3" echo              *             to continue flashing process                *
if "%3"=="3" echo              ***********************************************************
if "%3"=="3" echo.
if "%3"=="3" echo                                  Enter any Key . .
if "%3"=="3" pause >nul
call :Slp&echo.&%fastboot% devices 2>&1
echo.
if "%is-userspace%"=="yes" (
    echo Device Mode: FastbootD | %wintee% -a "%log_file%"
) else if "%is-userspace%"=="no" (
    echo Device Mode: Bootloader | %wintee% -a "%log_file%"
) else (
    echo Errors: Unable to determine Mode state.
)
echo.
if "%unlocked%"=="yes" (
    echo Device State: Unlocked | %wintee% -a "%log_file%"
)
echo.
echo			 =========================================
echo			 =      FLASHING to Bootloader Mode      =
echo			 =========================================
echo.
call :Pfi vbmeta_%2
call :Pfi init_boot_%2
call :Pfi boot_%2
call :Pfi recovery_%2
call :Pfi vendor_boot_%2
call :Pfi vbmeta_vendor_%2
call :Pfi vbmeta_system_%2
call :Pfp modem_%2
if "%3"=="3" call :Slp&for /f "tokens=2 delims=:" %%i in ('%fastboot% getvar all 2^>^&1 ^| findstr /irc:"partition-type:.*:" ^| findstr /ivrc:"_[ab]\>"') do call :Pfp %%i
exit /b
:Pfd
call :Slp&echo.&%fastboot% devices 2>&1 | %wintee% -a "%log_file%"
echo.
if "%is-userspace%"=="yes" (
    echo Device Mode: FastbootD | %wintee% -a "%log_file%"
) else if "%is-userspace%"=="no" (
    echo Device Mode: Bootloader | %wintee% -a "%log_file%"
) else (
    echo Errors: Unable to determine Mode state.
)
echo.
if "%unlocked%"=="yes" (
    echo Device State: Unlocked | %wintee% -a "%log_file%"
)
echo.
echo================================================================== | %wintee% -a "%log_file%"
echo			 =       FLASHING to FastbootD Mode      = | %wintee% -a "%log_file%"
echo			 =      ****************************     = | %wintee% -a "%log_file%"
echo			 =     FLASHING no Logical Partitions    = | %wintee% -a "%log_file%"
echo================================================================== | %wintee% -a "%log_file%"
echo. | %wintee% -a "%log_file%"
call :Psf
echo.
if "%vEo%"=="1" call :Slp&for /f "tokens=2 delims=:" %%i in ('%fastboot% getvar all 2^>^&1 ^| findstr /irc:"is-logical:.*: *no" ^| findstr /ivrc:"_[ab]\>"') do call :Pfi %%i
call :Slp&for /f "tokens=2 delims=:" %%i in ('%fastboot% getvar all 2^>^&1 ^| findstr /irc:"is-logical:.*_%2: *no"') do call :Pfi %%i
if "%3"=="1" echo.
if "%3"=="1" echo			 =========================================
if "%3"=="1" echo			 =        DELETING COW Partitions        =
if "%3"=="1" echo			 =========================================
if "%3"=="1" echo.
if "%3"=="1" call :Slp&for /f "tokens=2 delims=:" %%i in ('%fastboot% getvar all 2^>^&1 ^| findstr /irc:"is-logical:.*_%2-cow: *yes"') do call :Slp&%fastboot% delete-logical-partition %%i 2>&1
if "%3"=="1" echo.
if "%3"=="1" echo			 =========================================
if "%3"=="1" echo			 =      DELETING Logical Partitions      =
if "%3"=="1" echo			 =========================================
if "%3"=="1" echo.
if "%3"=="1" call :Slp&for /f "tokens=2 delims=:" %%i in ('%fastboot% getvar all 2^>^&1 ^| findstr /irc:"is-logical:.*_%2: *yes"') do call :Slp&%fastboot% delete-logical-partition %%i 2>&1
if "%3"=="1" echo.
if "%3"=="1" echo			 =========================================
if "%3"=="1" echo			 =      CREATING Logical Partitions      =
if "%3"=="1" echo			 =========================================
if "%3"=="1" echo.
if "%3"=="1" call :Clp 2>&1
if "%3"=="1" echo. | %wintee% -a "%log_file%"
if "%3"=="1" echo			 ========================================= | %wintee% -a "%log_file%"
if "%3"=="1" echo			 =      FLASHING Logical Partitions      = | %wintee% -a "%log_file%"
if "%3"=="1" echo			 ========================================= | %wintee% -a "%log_file%"
if "%3"=="1" echo. | %wintee% -a "%log_file%"
if "%3"=="1" call :Slp&for /f "tokens=2 delims=:" %%i in ('%fastboot% getvar all 2^>^&1 ^| findstr /irc:"is-logical:.*_%2: *yes"') do call :Pfi %%i
exit /b
:Pcs
set "vPn=%1"
if defined vPn (set "vPn=%vPn: =%"
) else if "%current-slot:a=%"=="%current-slot%" (set "vPn=a") else set "vPn=b"
call :Slp&for /f "delims=" %%i in ('%fastboot% --set-active^=%vPn% 2^>^&1') do set "vPn=%%i"
exit /b
:Psf
if "%current-slot:a=%"=="%current-slot%" (for /f "tokens=1* delims=:" %%i in ("%vSfb%") do set "vSfb=%%j"&echo Scheduled flashing '%%i'&call :Pfi %%i&goto :Psf
) else for /f "tokens=1* delims=:" %%i in ("%vSfa%") do set "vSfa=%%j"&echo Scheduled flashing '%%i'&call :Pfi %%i&goto :Psf
exit /b
:Pfi
set "vPn=%1"
set "vPn=%vPn: =%"
if "%vPn:~-2%"=="_%current-slot: =%" (set "vFn=%vPn:~,-2%.img") else set "vFn=%vPn%.img"
if not exist "%cd%\%vFd%\%vFn%" exit /b
call :Slp&for /f "delims=" %%i in ('%fastboot% %vEo%flash %vPn% %vFd%\%vFn% 2^>^&1') do set "vLs=%%i"&echo %%i | %wintee% -a "%log_file%"
if "%is-userspace:yes=%"=="%is-userspace%" if not "%vLs:error=%"=="%vLs%" echo '%vPn%' scheduled for flashing later&if "%current-slot:a=%"=="%current-slot%" (set "vSfb=%vSfb%:%vPn%") else set "vSfa=%vSfa%:%vPn%" | %wintee% -a "%log_file%"
exit /b
:Pfp
set "vPn=%1"
set "vPn=%vPn: =%"
if "%vPn:~-2%"=="_%current-slot: =%" (set "vFn=%vPn:~,-2%.img") else set "vFn=%vPn%.img"
if not exist "%cd%\%vTr%\%vFn%" exit /b
call :Slp&for /f "delims=" %%i in ('%fastboot% %vEo%flash %vPn% %vTr%\%vFn% 2^>^&1') do set "vLs=%%i"&echo %%i
if "%is-userspace:yes=%"=="%is-userspace%" if not "%vLs:error=%"=="%vLs%" echo '%vPn%' scheduled for flashing later&if "%current-slot:a=%"=="%current-slot%" (set "vSfb=%vSfb%:%vPn%") else set "vSfa=%vSfa%:%vPn%"
exit /b
:Prb
echo.
%fastboot% flash oplusstanvbk "%vFd%"\oplusstanvbk.img
echo.
echo. >> "%log_file%"
echo   --- Окончание процесса: %DATE:~-4,4%-%DATE:~3,2%-%DATE:~0,2%_%TIME:~0,2%-%TIME:~3,2%-%TIME:~6,2% --- >> "%log_file%"
echo. >> "%log_file%"
echo.
echo===================================================================
echo                    FLASHING FastbootD COMPLETED
echo===================================================================
echo.
echo.
echo===================================================================
echo.
echo              Open "Flash_log.txt" and check for errors
echo               in flashing system logical partitions. 
echo         If there are no errors, press any key to continue.
echo.
echo===================================================================
echo.
echo                     Enter any Key for Continue . .
pause >nul
call :Slp&call :Slp&%fastboot% reboot bootloader 2>&1 | %wintee% -a "%log_file%"
call :Slp&call :Slp
exit /b
:Slp
timeout /t 2 /nobreak>nul | %wintee% -a "%log_file%"
exit /b
:Clp
for %%p in (
        my_bigball_a my_bigball_b
        my_carrier_a my_carrier_b
        my_company_a my_company_b
        my_engineering_a my_engineering_b
        my_heytap_a my_heytap_b
        my_manifest_a my_manifest_b
        my_preload_a my_preload_b
        my_product_a my_product_b
        my_region_a my_region_b
        my_stock_a my_stock_b
        odm_a odm_b
        odm_dlkm_a odm_dlkm_b
        product_a product_b
        system_a system_b
        system_ext_a system_ext_b
		system_dlkm_a system_dlkm_b
        vendor_a vendor_b
        vendor_dlkm_a vendor_dlkm_b
    ) do (
	    timeout /nobreak /t 1 > nul
        %fastboot% create-logical-partition %%p 0
)
exit /b
goto start
---------------------------------- 
:flsup
cls
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo.---------------------------------------------------------------------------------------
title                                Fastboot Installer
echo.
echo.                        !ESC![31m********!ESC![0m !ESC![33mSeRViP production!ESC![0m !ESC![31m********!ESC![0m
echo.                              !ESC![31m***********************!ESC![0m
echo ---------------------------------------------------------------------------------------
echo.
echo.                         !ESC![31m********!ESC![0m   FLASH SUPER    !ESC![31m********!ESC![0m
echo.
echo.
echo                              Waiting for Connecting...
%fastboot% wait-for-device >nul 2>&1
echo.
call :Slp&echo.&%fastboot% devices 2>&1&echo.
echo.
set /a "vN+=1"&for /f "tokens=2* delims=): " %%i in ('%fastboot% getvar all 2^>^&1 ^| findstr /i "is-userspace: unlocked:"') do set "%%i=%%j"
if "%is-userspace%"=="yes" (
    echo Device Mode: FastbootD
) else if "%is-userspace%"=="no" (
    echo Device Mode: Bootloader
) else (
    echo Errors: Unable to determine Mode state.
)
echo.
if "%unlocked%"=="yes" (
    echo Device State: Unlocked
) else if "%unlocked%"=="no" (
    echo Device State: Locked
) else (
    echo Errors: Unable to determine bootloader state.
)
echo.
echo.
%fastboot% flash super SUPER\super.img
echo.
%fastboot% reboot bootloader
goto end
----------------------------------
:cow
cls
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo.-------------------------------------------------------------------------------------
title                                Fastboot COW Deleting
echo.
echo.                         !ESC![31m********!ESC![0m !ESC![33mSeRViP production!ESC![0m !ESC![31m********!ESC![0m
echo.                               !ESC![31m***********************!ESC![0m
echo -------------------------------------------------------------------------------------
echo.
echo                              Waiting for Connecting...
%fastboot% wait-for-device >nul 2>&1
echo.
%fastboot% devices 2>&1
set /a "vN+=1"&for /f "tokens=2* delims=): " %%i in ('%fastboot% getvar all 2^>^&1 ^| findstr /i "is-userspace: unlocked:"') do set "%%i=%%j"
echo.
if "%is-userspace%"=="yes" (
    echo Device Mode: FastbootD
) else if "%is-userspace%"=="no" (
    echo Device Mode: Bootloader
) else (
    echo Errors: Unable to determine Mode state.
)
echo.
if "%unlocked%"=="yes" (
    echo Device State: Unlocked
) else if "%unlocked%"=="no" (
    echo Device State: Locked
) else (
    echo Errors: Unable to determine bootloader state.
)
echo.
echo.
echo			   =========================================
echo			   =        DELETING COW Partitions        =
echo			   =========================================
echo.
echo.
call :Slp&for  /f "tokens=2 delims=:" %%a in ('%fastboot% getvar all 2^>^&1 ^| findstr /i "is-logical:.*-cow: *yes"') do call :Slp&%fastboot% delete-logical-partition %%a 2>&1
echo.
echo -----------------------------------------------------------------------------
echo.
echo                                  \033[33mDeleting SUCCESSFUL| %clr% 
echo.   
echo -----------------------------------------------------------------------------
echo.
echo                                    Enter any Key . .
pause >nul
echo.
:Slp
timeout /t 1 /nobreak>nul
exit /b
goto end
----------------------------------
:FRP
cls
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo.-------------------------------------------------------------------------------------
title                                Fastboot Clear FRP
echo.
echo.                         !ESC![31m********!ESC![0m !ESC![33mSeRViP production!ESC![0m !ESC![31m********!ESC![0m
echo.                               !ESC![31m***********************!ESC![0m
echo -------------------------------------------------------------------------------------
echo.
echo                              Waiting for Connecting...
%fastboot% wait-for-device >nul 2>&1
echo.
%fastboot% devices 2>&1
set /a "vN+=1"&for /f "tokens=2* delims=): " %%i in ('%fastboot% getvar all 2^>^&1 ^| findstr /i "is-userspace: unlocked:"') do set "%%i=%%j"
echo.
if "%is-userspace%"=="yes" (
    echo Device Mode: FastbootD
) else if "%is-userspace%"=="no" (
    echo Device Mode: Bootloader
) else (
    echo Errors: Unable to determine Mode state.
)
echo.
if "%unlocked%"=="yes" (
    echo Device State: Unlocked
) else if "%unlocked%"=="no" (
    echo Device State: Locked
) else (
    echo Errors: Unable to determine bootloader state.
)
echo.
echo.
echo			   =========================================
echo			   =               CLEAR FRP               =
echo			   =========================================
echo.
echo.
%fastboot% erase frp
echo.
echo -----------------------------------------------------------------------------
echo.
echo                                  \033[33mCLEAR SUCCESSFUL| %clr% 
echo.   
echo -----------------------------------------------------------------------------
echo.
echo                                    Enter any Key . .
pause >nul
echo.
:Slp
timeout /t 1 /nobreak>nul
exit /b
goto end
----------------------------------

----------------------------------  
:M2
cls
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo ---------------------------------------------------------------------------------------
echo.
echo                                     \033[33mCheck Device| %clr% ***
echo                            !ESC![31m****************************!ESC![0m
echo ---------------------------------------------------------------------------------------
echo.
echo          !ESC![31m_________________________________________________________________!ESC![0m
echo          !ESC![33m______________________________     !ESC![33m______________________________!ESC![0m
echo                                          !ESC![31m*!ESC![0m
echo           [1] !ESC![36mADB Check Device!ESC![0m           !ESC![31m#!ESC![0m   [2] !ESC![36mFASTBOOT Check Device!ESC![0m
echo          !ESC![33m______________________________  !ESC![31m*!ESC![0m  !ESC![33m______________________________!ESC![0m
echo.
echo          !ESC![31m_________________________________________________________________!ESC![0m
echo          !ESC![31m_________________________________________________________________!ESC![0m
echo.
echo.
set  /a choise = 0
set  /p choise=%a0%: 
IF "%choise%" == "0" GOTO M2
IF "%choise%" == "2" GOTO :fastcheck
IF "%choise%" == "1" GOTO :adbcheck
GOTO start

:adbcheck
cls
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo.---------------------------------------------------------------------------------------
title                                CHECK Device
echo.
echo.                        !ESC![31m********!ESC![0m !ESC![33mSeRViP production!ESC![0m !ESC![31m********!ESC![0m
echo.                              !ESC![31m***********************!ESC![0m
echo ---------------------------------------------------------------------------------------
echo.

set "COLOR_BROWN=[33m"
set "COLOR_BLUE=[36m"
set "COLOR_RESET=[0m"

echo                              Waiting for ADB Connecting...
%adb% wait-for-device >nul 2>&1
%adb% devices > nul
if errorlevel 1 (
    echo Убедитесь, что ADB установлен и устройство подключено.
    pause
    exit /b
)
echo.
echo                          !COLOR_BLUE!Получаем информацию об устройстве...!COLOR_RESET!
echo.
%adb% get-state > nul

for /f "tokens=*" %%i in ('%adb% shell getprop ro.product.brand') do set BRAND=%%i
for /f "tokens=*" %%i in ('%adb% shell getprop ro.vendor.oplus.market.name') do set DEVICE=%%i
for /f "tokens=*" %%i in ('%adb% shell getprop ro.product.model') do set PRODUCT=%%i
for /f "tokens=*" %%i in ('%adb% shell getprop ro.product.name') do set PRODUCT_NAME=%%i
for /f "tokens=*" %%i in ('%adb% shell getprop ro.oplus.image.my_region.version_name') do set MY_REGION=%%i
for /f "tokens=*" %%i in ('%adb% shell getprop ro.build.version.release') do set VERSION=%%i
for /f "tokens=*" %%i in ('%adb% shell getprop ro.boot.slot_suffix') do set SLOT=%%i
for /f "tokens=*" %%i in ('%adb% shell getprop ro.build.version.security_patch') do set SECURITY=%%i
for /f "tokens=*" %%i in ('%adb% shell getprop ro.build.display.id') do set VERS=%%i

echo !COLOR_BLUE!Brand:!COLOR_RESET! !COLOR_BROWN!%BRAND%!COLOR_RESET!
echo.
echo !COLOR_BLUE!Device:!COLOR_RESET! !COLOR_BROWN!%DEVICE%!COLOR_RESET!
echo.
echo !COLOR_BLUE!Model:!COLOR_RESET! !COLOR_BROWN!%PRODUCT%!COLOR_RESET!
echo.
echo !COLOR_BLUE!Product:!COLOR_RESET! !COLOR_BROWN!%PRODUCT_NAME%!COLOR_RESET!
echo.
echo !COLOR_BLUE!Region:!COLOR_RESET! !COLOR_BROWN!%MY_REGION%!COLOR_RESET!
echo.
echo !COLOR_BLUE!Android Version:!COLOR_RESET! !COLOR_BROWN!%VERSION%!COLOR_RESET!
echo.
echo !COLOR_BLUE!Current Active Slot:!COLOR_RESET! !COLOR_BROWN!%SLOT%!COLOR_RESET!
echo.
echo !COLOR_BLUE!Security Patch:!COLOR_RESET! !COLOR_BROWN!%SECURITY%!COLOR_RESET!
echo.
echo !COLOR_BLUE!Firmware Version:!COLOR_RESET! !COLOR_BROWN!%VERS%!COLOR_RESET!
echo.
echo !COLOR_BLUE!Наличие ROOT:!COLOR_RESET!
%adb% shell which su > nul
if %errorlevel%==0 (
    echo !COLOR_BROWN!Устройство имеет Root права.!COLOR_RESET!
) else (
    echo !COLOR_BROWN!Root права не найдены.!COLOR_RESET!
)
echo.
echo                                !COLOR_BLUE!Нажмите любую клавишу . .!COLOR_RESET!
pause >nul
goto start

:fastcheck
cls
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo.---------------------------------------------------------------------------------------
title                                CHECK Device
echo.
echo.                        !ESC![31m********!ESC![0m !ESC![33mSeRViP production!ESC![0m !ESC![31m********!ESC![0m
echo.                              !ESC![31m***********************!ESC![0m
echo ---------------------------------------------------------------------------------------
echo.
set "COLOR_BROWN=[33m"
set "COLOR_BLUE=[36m"
set "COLOR_RESET=[0m"
echo.
echo                              Waiting for Connecting...
%fastboot% wait-for-device >nul 2>&1
echo.
%fastboot% devices > nul
if errorlevel 1 (
    echo Убедитесь, что ADB установлен и устройство подключено.
    pause
    exit /b
)
echo.
echo                                Check States Device...
echo.
echo.
set /a "vN+=1"&for /f "tokens=2* delims=): " %%i in ('%fastboot% getvar all 2^>^&1 ^| findstr /i "is-userspace: serialno: current-slot: unlocked:"') do set "%%i=%%j"
if "%is-userspace%"=="yes" (
    echo !COLOR_BLUE!Device Mode:!COLOR_RESET! !COLOR_BROWN!FastbootD!COLOR_RESET!
) else if "%is-userspace%"=="no" (
    echo !COLOR_BLUE!Device Mode:!COLOR_RESET! !COLOR_BROWN!Bootloader!COLOR_RESET!
) else (
    echo !COLOR_BLUE!Errors: !COLOR_BROWN!Unable to determine Mode state.!COLOR_RESET!
)
echo.
if "%current-slot%"=="" (
    echo !COLOR_BLUE!Errors: !COLOR_BROWN!Unable to determine Active slot.!COLOR_RESET!
) else (
    echo !COLOR_BLUE!Active Slot:!COLOR_RESET! !COLOR_BROWN!"%current-slot%"!COLOR_RESET!
)
echo.
if "%unlocked%"=="yes" (
    echo !COLOR_BLUE!Device State:!COLOR_RESET! !COLOR_BROWN!Unlocked!COLOR_RESET!
) else if "%unlocked%"=="no" (
    echo !COLOR_BLUE!Device State:!COLOR_RESET! !COLOR_BROWN!Locked!COLOR_RESET!
) else (
    echo !COLOR_BLUE!Errors: !COLOR_BROWN!Unable to determine bootloader state.!COLOR_RESET!
)
echo.
if "%serialno%"=="" (
    echo !COLOR_BLUE!Errors: !COLOR_BROWN!Unable to determine Serial number.!COLOR_RESET!
) else (
    echo !COLOR_BLUE!Serial Number:!COLOR_RESET! !COLOR_BROWN!%serialno%!COLOR_RESET!
)
echo.
echo.
echo.
echo                                !COLOR_BLUE!Нажмите любую клавишу . .!COLOR_RESET!
pause >nul
goto start
----------------------------------- 
:M3
cls
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo.---------------------------------------------------------------------------------------
title                                Fastboot Installer
echo.
echo.                        !ESC![31m********!ESC![0m !ESC![33mSeRViP production!ESC![0m !ESC![31m********!ESC![0m
echo.                              !ESC![31m***********************!ESC![0m
echo ---------------------------------------------------------------------------------------
echo.
echo                             [INIT_BOOT/BOOT/RECOVERY]
echo          !ESC![31m_________________________________________________________________!ESC![0m
echo          !ESC![33m______________________________     !ESC![33m______________________________!ESC![0m
echo                                          !ESC![31m*!ESC![0m
echo            [1] !ESC![36mFlash Boot!ESC![0m                !ESC![31m#!ESC![0m    [2] !ESC![36mFlash Recovery!ESC![0m
echo          !ESC![33m______________________________  !ESC![31m*!ESC![0m  !ESC![33m______________________________!ESC![0m
echo.
echo                             [3] !ESC![36mFlash Init_Boot!ESC![0m
echo                           !ESC![33m______________________________!ESC![0m
echo          !ESC![31m_________________________________________________________________!ESC![0m
echo.
echo           !ESC![36mFastboot Driver!ESC![0m:!ESC![37m%var%!ESC![0m           !ESC![36mBoot Mode!ESC![0m:!ESC![37m%var1%!ESC![0m
echo          !ESC![31m_________________________________________________________________!ESC![0m
echo.

set  /a choise = 0
set  /p choise=%a0%: 
if "%choise%" == "0" goto start
if "%choise%" == "3" goto init_boot
if "%choise%" == "2" goto recovery
if "%choise%" == "1" goto boot
goto start


:boot
cls
set "count=0"
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo ---------------------------------------------------------------------------------------
echo.
echo                                   \033[33mFlash the Boot| %clr%
echo                               !ESC![31m**********************!ESC![0m
echo ---------------------------------------------------------------------------------------
echo  !ESC![36mList images!ESC![0m:
echo.
for %%i in (%~dp0BOOT\*.img) do (
	set /a count+=1
	echo [!count!] %%~nxi
)
echo.
set /p choice=!ESC![33mSelect the file number, or enter "Q" to go back!ESC![0m: 
echo.
if "%choice%" equ "q" goto M3
if "%choice%" geq "1" if "%choice%" leq "!count!" (
	set "selectedFile="
	set "fileCount=0"
	for %%i in (%~dp0BOOT\*.img) do (
		set /a fileCount+=1
		if "!fileCount!"=="%choice%" (
			set "selectedFile=%%i"
			goto flash_boot
		)
	)
) else (
	echo The entered number is invalid.
	goto boot
)
echo.

:flash_boot
echo.
echo                              Waiting for Connecting...
%fastboot% wait-for-device >nul 2>&1
echo.
%fastboot% devices > nul
if errorlevel 1 (
    echo Убедитесь, что ADB установлен и устройство подключено.
    pause
    exit /b
)
echo.
set /a "vN+=1"&for /f "tokens=2* delims=): " %%i in ('%fastboot% getvar all 2^>^&1 ^| findstr /i "is-userspace: unlocked:"') do set "%%i=%%j"
if "%is-userspace%"=="yes" (
    echo Device Mode: FastbootD
) else if "%is-userspace%"=="no" (
    echo Device Mode: Bootloader
) else (
    echo Errors: Unable to determine Mode state.
)
echo.
if "%unlocked%"=="yes" (
    echo Device State: Unlocked
) else if "%unlocked%"=="no" (
    echo Device State: Locked
) else (
    echo Errors: Unable to determine bootloader state.
)
echo.
echo.
%fastboot% flash boot "%selectedFile%"
echo.
echo \033[31mPress any key to return to Menu...| %clr%
pause >nul && goto start


:recovery
cls
set "count=0"
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo --------------------------------------------------------------------------------------
echo.
echo                                   \033[33mFlash the RECOVERY| %clr%
echo                                 !ESC![31m**********************!ESC![0m     
echo --------------------------------------------------------------------------------------
echo  !ESC![36mList images!ESC![0m:
echo.
for %%i in (%~dp0RECOVERY\*.img) do (
	set /a count+=1
	echo [!count!] %%~nxi
)
echo.
set /p choice=!ESC![33mSelect the file number, or enter "Q" to go back!ESC![0m: 
echo.
if "%choice%" equ "q" goto M3
if "%choice%" geq "1" if "%choice%" leq "!count!" (
	set "selectedFile="
	set "fileCount=0"
	for %%i in (%~dp0RECOVERY\*.img) do (
		set /a fileCount+=1
		if "!fileCount!"=="%choice%" (
			set "selectedFile=%%i"
			goto flash_recovery
		)
	)
) else (
	echo The entered number is invalid.
	goto recovery
)
echo.

:flash_recovery
echo.
echo                              Waiting for Connecting...
%fastboot% wait-for-device >nul 2>&1
echo.
%fastboot% devices > nul
if errorlevel 1 (
    echo Убедитесь, что ADB установлен и устройство подключено.
    pause
    exit /b
)
echo.
set /a "vN+=1"&for /f "tokens=2* delims=): " %%i in ('%fastboot% getvar all 2^>^&1 ^| findstr /i "is-userspace: unlocked:"') do set "%%i=%%j"
if "%is-userspace%"=="yes" (
    echo Device Mode: FastbootD
) else if "%is-userspace%"=="no" (
    echo Device Mode: Bootloader
) else (
    echo Errors: Unable to determine Mode state.
)
echo.
if "%unlocked%"=="yes" (
    echo Device State: Unlocked
) else if "%unlocked%"=="no" (
    echo Device State: Locked
) else (
    echo Errors: Unable to determine bootloader state.
)
echo.
echo.
%fastboot% flash recovery "%selectedFile%"
echo.
echo \033[31mPress any key to return to Menu...| %clr%
pause >nul && goto start


:init_boot
cls
set "count=0"
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo ---------------------------------------------------------------------------------------
echo.
echo                                  \033[33mFlash the Init_Boot| %clr%
echo                                !ESC![31m***********************!ESC![0m
echo ---------------------------------------------------------------------------------------
echo  !ESC![36mList images!ESC![0m:
echo.
for %%i in (%~dp0INIT_BOOT\*.img) do (
	set /a count+=1
	echo [!count!] %%~nxi
)
echo.
set /p choice=!ESC![33mSelect the file number, or enter "Q" to go back!ESC![0m: 
echo.
if "%choice%" equ "q" goto M3
if "%choice%" geq "1" if "%choice%" leq "!count!" (
	set "selectedFile="
	set "fileCount=0"
	for %%i in (%~dp0INIT_BOOT\*.img) do (
		set /a fileCount+=1
		if "!fileCount!"=="%choice%" (
			set "selectedFile=%%i"
			goto flash_init_boot
		)
	)
) else (
	echo The entered number is invalid.
	goto init_boot
)
echo.

:flash_init_boot
echo.
echo                              Waiting for Connecting...
%fastboot% wait-for-device >nul 2>&1
echo.
%fastboot% devices > nul
if errorlevel 1 (
    echo Убедитесь, что ADB установлен и устройство подключено.
    pause
    exit /b
)
echo.
set /a "vN+=1"&for /f "tokens=2* delims=): " %%i in ('%fastboot% getvar all 2^>^&1 ^| findstr /i "is-userspace: unlocked:"') do set "%%i=%%j"
if "%is-userspace%"=="yes" (
    echo Device Mode: FastbootD
) else if "%is-userspace%"=="no" (
    echo Device Mode: Bootloader
) else (
    echo Errors: Unable to determine Mode state.
)
echo.
if "%unlocked%"=="yes" (
    echo Device State: Unlocked
) else if "%unlocked%"=="no" (
    echo Device State: Locked
) else (
    echo Errors: Unable to determine bootloader state.
)
echo.
echo.
%fastboot% flash init_boot "%selectedFile%"
echo.
echo \033[31mPress any key to return to Menu...| %clr%
pause >nul && goto start
----------------------------------- 
:M4
cls
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo.---------------------------------------------------------------------------------------
title                                Fastboot Installer
echo.
echo.                        !ESC![31m********!ESC![0m !ESC![33mSeRViP production!ESC![0m !ESC![31m********!ESC![0m
echo.                              !ESC![31m***********************!ESC![0m
echo ---------------------------------------------------------------------------------------
echo.
echo                                    [Menu "Reboot"]
echo           !ESC![31m_________________________________________________________________| %clr%
echo.                                        
echo                        !ESC![33mADB!ESC![0m                             !ESC![33mFastboot!ESC![0m
echo           \033[33m______________________________     \033[33m______________________________| %clr%
echo.                                            
echo            [1] Reboot to Bootloader       !ESC![31m#!ESC![0m   [4] Reboot to Bootloader
echo           \033[33m______________________________     \033[33m______________________________| %clr%
echo.                                            
echo            [2] Reboot to Fastbootd        !ESC![31m#!ESC![0m   [5] Reboot to Fastbootd
echo           \033[33m______________________________     \033[33m______________________________| %clr%
echo.                                            
echo            [3] Reboot to Recovery         !ESC![31m#!ESC![0m   [6] Reboot to System
echo           \033[33m______________________________     \033[33m______________________________| %clr%
echo           !ESC![31m_________________________________________________________________| %clr%
echo.
echo                                 !ESC![36mBoot Mode!ESC![0m:!ESC![37m%var1%!ESC![0m
echo           !ESC![31m_________________________________________________________________| %clr%
echo.

set  /a choise = 0
set  /p choise=%a0%: 
if "%choise%" == "0" goto start
if "%choise%" == "6" %cd%\bin\fastboot reboot && goto start
if "%choise%" == "5" %cd%\bin\fastboot reboot fastboot && goto check_connection_status && goto start
if "%choise%" == "4" %cd%\bin\fastboot reboot bootloader && goto check_connection_status && goto start
if "%choise%" == "3" goto reboot_recovery
if "%choise%" == "2" goto reboot_fastboot
if "%choise%" == "1" goto reboot_bootloader
goto M4

:reboot_bootloader
%adb% devices
pause
%adb% reboot bootloader
goto check_connection_status
goto start

:reboot_fastboot
%adb% devices
pause
%adb% reboot fastboot
goto check_connection_status
goto start

:reboot_recovery
%adb% devices
pause
%adb% reboot recovery
goto start

:check_connection_status
%cd%\bin\fastboot oem device-info 2> %temp%\bootlog.txt
>nul find "bootloader" %temp%\bootlog.txt
if %errorlevel%==0 (
set var1=Bootloader
)

if %errorlevel%==1 (
del /s /q /f %temp%\bootlog.txt >nul 2>nul
)

%cd%\bin\fastboot getvar all 2> %temp%\fastdlog.txt
>nul find "fingerprint:oplus" %temp%\fastdlog.txt
if %errorlevel%==0 (
set var1=FastbootD
)

if %errorlevel%==1 (
del /s /q /f %temp%\fastdlog.txt >nul 2>nul
)

%cd%\bin\adb devices 2> %temp%\syslog.txt >nul
goto start
----------------------------------- 
:M5
cls
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo.-------------------------------------------------------------------------------------
title                               Fastboot ROM Installer
echo.
echo.                        !ESC![31m********!ESC![0m !ESC![33mSeRViP production!ESC![0m !ESC![31m********!ESC![0m
echo.                              !ESC![31m***********************!ESC![0m
echo -------------------------------------------------------------------------------------
echo.
%fastboot% devices 2>&1
echo.
%fastboot% -w
goto end
----------------------------------- 
:M6
cls
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo ---------------------------------------------------------------------------------------
title                                    Uninstaller Applications
echo.
echo                           \033[33mInstall/Uninstall Applications| %clr% ***
echo                         !ESC![31m**********************************!ESC![0m
echo ---------------------------------------------------------------------------------------
echo.
echo.
echo          !ESC![31m_________________________________________________________________!ESC![0m
echo          !ESC![33m______________________________     !ESC![33m______________________________!ESC![0m
echo                                          !ESC![31m*!ESC![0m
echo           [1] !ESC![36mUninstall Applications!ESC![0m     !ESC![31m#!ESC![0m   [2] !ESC![36mDisable Applications!ESC![0m
echo          !ESC![33m______________________________  !ESC![31m*!ESC![0m  !ESC![33m______________________________!ESC![0m
echo                                          !ESC![31m*!ESC![0m
echo           [3] !ESC![36mSuspend Applications!ESC![0m       !ESC![31m#!ESC![0m   [4] !ESC![36mUnsuspend Applications!ESC![0m
echo          !ESC![33m______________________________  !ESC![31m*!ESC![0m  !ESC![33m______________________________!ESC![0m
echo.
echo                              [5] !ESC![36mInstall Applications!ESC![0m
echo                           !ESC![33m______________________________!ESC![0m
echo          !ESC![31m_________________________________________________________________!ESC![0m
echo          !ESC![31m_________________________________________________________________!ESC![0m
echo.
echo.
set  /a choise = 0
set  /p choise=%a0%: 
IF "%choise%" == "0" GOTO M6
IF "%choise%" == "5" GOTO Install
IF "%choise%" == "4" GOTO unsuspend
IF "%choise%" == "3" GOTO suspend
IF "%choise%" == "2" GOTO disable
IF "%choise%" == "1" GOTO Uninstall
GOTO start

:Uninstall
cls
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo.-------------------------------------------------------------------------------------
title                                       Uninstaller by SeRViP
echo.
echo.                             !ESC![31m********!ESC![0m !ESC![33mUninstaller!ESC![0m !ESC![31m********!ESC![0m
echo.                                !ESC![31m***********************!ESC![0m
echo -------------------------------------------------------------------------------------
echo.
echo                              Waiting for ADB Connecting...
%adb% wait-for-device >nul 2>&1
%adb% devices
echo.
echo                                !ESC![33mНажмите любую клавишу . . .!ESC![0m
pause >nul
echo.
%list%
cls
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo.-------------------------------------------------------------------------------------
title                               Uninstaller by SeRViP
echo.
echo.                        !ESC![31m********!ESC![0m !ESC![33mSeRViP production!ESC![0m !ESC![31m********!ESC![0m
echo.                              !ESC![31m***********************!ESC![0m
echo -------------------------------------------------------------------------------------
echo.
echo                        [Uninstalling APPLICATIONS from Device]
echo.
for /F "tokens=*" %%L in (%txt%) do (
    echo Uninstalling %%L
	timeout /t 1 /nobreak>nul
    %uninst% %%L
)
echo.
echo.                               Удаление завершено!
echo.
echo                                !ESC![33mНажмите любую клавишу . . .!ESC![0m
pause >nul
goto start

:disable
cls
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo.-------------------------------------------------------------------------------------
title                                       Disable Apps by SeRViP
echo.
echo.                              !ESC![31m********!ESC![0m !ESC![33mDisabler!ESC![0m !ESC![31m*********!ESC![0m
echo.                                !ESC![31m***********************!ESC![0m
echo -------------------------------------------------------------------------------------
echo.
echo                              Waiting for ADB Connecting...
%adb% wait-for-device >nul 2>&1
%adb% devices
echo.
echo                                !ESC![33mНажмите любую клавишу . . .!ESC![0m
pause >nul
echo.
%list%
cls
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo.-------------------------------------------------------------------------------------
title                               Disable Apps by SeRViP
echo.
echo.                        !ESC![31m********!ESC![0m !ESC![33mSeRViP production!ESC![0m !ESC![31m********!ESC![0m
echo.                              !ESC![31m***********************!ESC![0m
echo -------------------------------------------------------------------------------------
echo.
echo                          [Disable APPLICATIONS from Device]
echo.
for /F "tokens=*" %%L in (%txt%) do (
    echo Disable %%L
	timeout /t 1 /nobreak>nul
    %disab% %%L
)
echo.
echo.                               Disabling Completed!
echo.
echo                                !ESC![33mНажмите любую клавишу . . .!ESC![0m
pause >nul
goto start

:suspend
cls
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo.-------------------------------------------------------------------------------------
title                                       Suspend Apps by SeRViP
echo.
echo.                              !ESC![31m********!ESC![0m !ESC![33mSuspende!ESC![0m !ESC![31m*********!ESC![0m
echo.                                !ESC![31m***********************!ESC![0m
echo -------------------------------------------------------------------------------------
echo.
echo                              Waiting for ADB Connecting...
%adb% wait-for-device >nul 2>&1
%adb% devices
echo.
echo                                !ESC![33mНажмите любую клавишу . . .!ESC![0m
pause >nul
echo.
%list%
cls
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo.-------------------------------------------------------------------------------------
title                               Suspende Apps by SeRViP
echo.
echo.                        !ESC![31m********!ESC![0m !ESC![33mSeRViP production!ESC![0m !ESC![31m********!ESC![0m
echo.                              !ESC![31m***********************!ESC![0m
echo -------------------------------------------------------------------------------------
echo.
@echo off
echo                            [Suspende APPLICATIONS from Device]
echo.
for /F "tokens=*" %%L in (%sus%) do (
    echo Suspende %%L
	timeout /t 1 /nobreak>nul
    %susp% %%L
)
echo.
echo.                               Suspended Completed!
echo.
echo                                !ESC![33mНажмите любую клавишу . . .!ESC![0m
pause >nul
goto start

:unsuspend
cls
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo.-------------------------------------------------------------------------------------
title                                       Unsuspend Apps by SeRViP
echo.
echo.                            !ESC![31m********!ESC![0m !ESC![33mUnsuspende!ESC![0m !ESC![31m*********!ESC![0m
echo.                                !ESC![31m***********************!ESC![0m
echo -------------------------------------------------------------------------------------
echo.
echo                              Waiting for ADB Connecting...
%adb% wait-for-device >nul 2>&1
%adb% devices
echo.
echo                                !ESC![33mНажмите любую клавишу . . .!ESC![0m
pause >nul
echo.
%list%
cls
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo.-------------------------------------------------------------------------------------
title                               Unsuspende Apps by SeRViP
echo.
echo.                        !ESC![31m********!ESC![0m !ESC![33mSeRViP production!ESC![0m !ESC![31m********!ESC![0m
echo.                              !ESC![31m***********************!ESC![0m
echo -------------------------------------------------------------------------------------
echo.
@echo off
echo                         [Unsuspende APPLICATIONS from Device]
echo.
for /F "tokens=*" %%L in (%unsus%) do (
    echo Unsuspende %%L
	timeout /t 1 /nobreak>nul
    %unsusp% %%L
)
echo.
echo.                               Unsuspended Completed!
echo.
echo                                !ESC![33mНажмите любую клавишу . . .!ESC![0m
pause >nul
goto start

:Install
cls
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo.-------------------------------------------------------------------------------------
title                                         Installer by SeRViP
echo.
echo.                              !ESC![31m********!ESC![0m !ESC![33mInstaller!ESC![0m !ESC![31m********!ESC![0m
echo.                                !ESC![31m***********************!ESC![0m
echo -------------------------------------------------------------------------------------
echo.
echo                              Waiting for ADB Connecting...
%adb% wait-for-device >nul 2>&1
%adb% devices
echo.
echo                                !ESC![33mНажмите любую клавишу . . .!ESC![0m
pause >nul
echo.
cls
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo.-------------------------------------------------------------------------------------
title                                 Installer by SeRViP
echo.
echo.                        !ESC![31m********!ESC![0m !ESC![33mSeRViP production!ESC![0m !ESC![31m********!ESC![0m
echo.                              !ESC![31m***********************!ESC![0m
echo -------------------------------------------------------------------------------------
echo.
echo                          [Installing APPLICATIONS in Device]
echo.
pushd "%~dp0bin\apps_install"
for /f "usebackq delims=|" %%W in (`dir /b *.apk`) do (
    echo Installing %%W
	timeout /t 2 /nobreak>nul
    %adb% install %%W
)
echo.
echo.                             Установка завершена!
echo.
echo                                !ESC![33mНажмите любую клавишу . . .!ESC![0m
pause >nul
goto start
----------------------------------- 
:M7
cls
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo.---------------------------------------------------------------------------------------
title                                  Fastboot Tool
echo.
echo.                        !ESC![31m********!ESC![0m !ESC![33mSeRViP production!ESC![0m !ESC![31m********!ESC![0m
echo.                              !ESC![31m***********************!ESC![0m
echo ---------------------------------------------------------------------------------------
echo.
echo                               [Lock/Unlock Bootloader]
echo          !ESC![31m_________________________________________________________________!ESC![0m
echo          !ESC![33m______________________________     !ESC![33m______________________________!ESC![0m
echo                                          !ESC![31m*!ESC![0m
echo           [1] !ESC![36mUnlock the Bootloader!ESC![0m      !ESC![31m#!ESC![0m   [2] !ESC![36mLock the Bootloader!ESC![0m
echo          !ESC![33m______________________________  !ESC![31m*!ESC![0m  !ESC![33m______________________________!ESC![0m
echo          !ESC![31m_________________________________________________________________!ESC![0m
echo.
echo           !ESC![36mFastboot Driver!ESC![0m:!ESC![37m%var%!ESC![0m           !ESC![36mBoot Mode!ESC![0m:!ESC![37m%var1%!ESC![0m
echo          !ESC![31m_________________________________________________________________!ESC![0m
echo.

set  /a choise = 0
set  /p choise=%a0%: 
if "%choise%" == "0" goto start
if "%choise%" == "2" goto lock_bootloader
if "%choise%" == "1" goto unlock_bootloader
goto start


:unlock_bootloader
cls
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo.---------------------------------------------------------------------------------------
title                                  Fastboot Tool
echo.
echo.                        !ESC![31m********!ESC![0m !ESC![33mSeRViP production!ESC![0m !ESC![31m********!ESC![0m
echo.                              !ESC![31m***********************!ESC![0m
echo ---------------------------------------------------------------------------------------
echo.
echo                                  [Unlock Bootloader]
echo.
echo.
%fastboot% devices 2>&1
echo.
%fastboot% flashing unlock
echo.
echo.
echo                                !ESC![33mНажмите любую клавишу . . .!ESC![0m
pause >nul
goto start


:lock_bootloader
cls
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo.---------------------------------------------------------------------------------------
title                                  Fastboot Tool
echo.
echo.                        !ESC![31m********!ESC![0m !ESC![33mSeRViP production!ESC![0m !ESC![31m********!ESC![0m
echo.                              !ESC![31m***********************!ESC![0m
echo ---------------------------------------------------------------------------------------
echo.
echo                                  [Lock Bootloader]
echo.
echo.
%fastboot% devices 2>&1
echo.
%fastboot% flashing lock
echo.
echo.
echo                                !ESC![33mНажмите любую клавишу . . .!ESC![0m
pause >nul
goto start
----------------------------------- 
:M8
cls
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo.---------------------------------------------------------------------------------------
title                                  Fastboot Tool
echo.
echo.                        !ESC![31m********!ESC![0m !ESC![33mSeRViP production!ESC![0m !ESC![31m********!ESC![0m
echo.                              !ESC![31m***********************!ESC![0m
echo ---------------------------------------------------------------------------------------
echo.
echo                                       [UNPACK]
echo          !ESC![31m_________________________________________________________________!ESC![0m
echo          !ESC![33m______________________________     !ESC![33m______________________________!ESC![0m
echo                                          !ESC![31m*!ESC![0m
echo            [1] !ESC![36mUnPack ROM (*rar)!ESC![0m         !ESC![31m#!ESC![0m    [2] !ESC![36mUnPack Firmware (*zip)!ESC![0m
echo          !ESC![33m______________________________  !ESC![31m*!ESC![0m  !ESC![33m______________________________!ESC![0m
echo.
echo                             [3] !ESC![36mUnPack Payload.bin!ESC![0m
echo                           !ESC![33m______________________________!ESC![0m
echo          !ESC![31m_________________________________________________________________!ESC![0m
echo.
echo.

set  /a choise = 0
set  /p choise=%a0%: 
if "%choise%" == "0" goto start
if "%choise%" == "3" goto unpack_payload
if "%choise%" == "2" goto unzip
if "%choise%" == "1" goto unrar
goto start

:unrar
cls
set "count=0"
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%USERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo ---------------------------------------------------------------------------------------
echo.
echo                                   \033[33mUnPack Firmware| %clr%
echo                                !ESC![31m*********************!ESC![0m
echo ---------------------------------------------------------------------------------------
echo.
set /a count+=1
echo [!count!] Select the File
echo.
set /p choice=!ESC![33mSelect the file number, or enter "Q" to go back!ESC![0m: 
echo.
if "%choice%" equ "Q" goto M8
if "%choice%" equ "!count!" (
    for /f "delims=" %%F in ('powershell -command "Add-Type -AssemblyName System.Windows.Forms; $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog; if ($openFileDialog.ShowDialog() -eq 'OK') { $openFileDialog.FileName }"') do set "selectedFile=%%F"
    if not defined selectedFile (
        echo No file selected.
		goto unrar
	)
	goto unpack_rar
)

:unpack_rar
cls
echo.
echo -----------------------------------------------------------------------------
echo                                 \033[33mUnpack ROM firmware| %clr%
echo -----------------------------------------------------------------------------
echo.
echo                                   In processing...
echo.
set "currentDir=%cd%"
"%unzip%" x "%selectedFile%"
echo.
echo                                !ESC![33mНажмите любую клавишу . . .!ESC![0m
pause >nul
goto start

:unzip
cls
set "count=0"
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo ---------------------------------------------------------------------------------------
echo.
echo                              \033[33mUnPack Services Firmware| %clr% ***
echo                            !ESC![31m****************************!ESC![0m
echo ---------------------------------------------------------------------------------------
echo.
echo                                     [UNPACK OFP]
echo          !ESC![31m_________________________________________________________________!ESC![0m
echo          !ESC![33m______________________________     !ESC![33m______________________________!ESC![0m
echo                                          !ESC![31m*!ESC![0m
echo           [1] !ESC![36mCreate Fastboot Firmware!ESC![0m   !ESC![31m#!ESC![0m   [2] !ESC![36mUnPack OFP Firmware!ESC![0m
echo          !ESC![33m______________________________  !ESC![31m*!ESC![0m  !ESC![33m______________________________!ESC![0m
echo          !ESC![31m_________________________________________________________________!ESC![0m
echo          !ESC![31m_________________________________________________________________!ESC![0m
echo.
echo.
set  /a choise = 0
set  /p choise=%a0%: 
IF "%choise%" == "0" GOTO M8
IF "%choise%" == "2" GOTO unfirm
IF "%choise%" == "1" GOTO fastfirm
GOTO start

:fastfirm
cls
set "count=0"
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo ---------------------------------------------------------------------------------------
echo.
echo                                   \033[33mUnPack Firmware| %clr%
echo                                !ESC![31m*********************!ESC![0m
echo ---------------------------------------------------------------------------------------
echo.
set /a count+=1
echo [!count!] Select the File
echo.
set /p choice=!ESC![33mSelect the file number, or enter "Q" to go back!ESC![0m: 
echo.
if "%choice%" equ "Q" goto M8
if "%choice%" equ "!count!" (
    for /f "delims=" %%F in ('powershell -command "Add-Type -AssemblyName System.Windows.Forms; $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog; if ($openFileDialog.ShowDialog() -eq 'OK') { $openFileDialog.FileName }"') do set "selectedFile=%%F"
    if not defined selectedFile (
        echo No file selected.
		goto fastfirm
	)
	goto unpack_zip
)

:unpack_zip
cls
"%bz%" x "%selectedFile%" FIRMWARE\Unpacked
echo.
echo -----------------------------------------------------------------------------
echo                               \033[33mFull services firmware| %clr%
echo -----------------------------------------------------------------------------
echo.
echo                                   In processing...
echo.
echo.
echo                                !ESC![33mНажмите любую клавишу . . .!ESC![0m
pause >nul

:timeout
timeout /t 2 /nobreak >nul
	goto moving
) else (
	goto timeout
)
	goto moving2
) else (
	goto timeout
)
	goto moving3
) else (
	goto timeout
)
	goto moving4
) else (
	goto timeout
)

:moving
echo.
echo                               \033[33mUnpacking completed| %clr%
echo -----------------------------------------------------------------------------
echo                           \033[33mMoving image to other folder| %clr%
echo.   
for /d %%D in ("%~dp0FIRMWARE\Unpacked\RADIO") do (
	echo Moving files from "%%D"
	for %%F in ("%%D\*.img") do (
		for %%P in (
			vbmeta_system init_boot vendor_boot dtbo vbmeta abl aop aop_config bluetooth cpucp devcfg dsp engineering_cdt featenabler hyp imagefv keymaster modem
			oplus_sec oplusstanvbk qupfw shrm tz uefi uefisecapp cpucp_dtb vbmeta_vendor xbl xbl_config xbl_ramdump ddr logfs apdp apdpb spuservice soccp_debug
			soccp_dcd pdp_cdb pdp
		) do (
			if "%%~nF"=="%%P" (
				move "%%F" "%vFd%"
			)
		)
	)
	rd /s /q "%%D"
)
				
:moving2		
for /d %%D in ("%~dp0FIRMWARE\Unpacked\IMAGES") do (
	echo Moving files from "%%D"
	for %%F in ("%%D\*.img") do (
		for %%P in (
			system system_ext init_boot product boot recovery vendor vendor_dlkm system_dlkm
			my_product my_engineering metadata oplusreserve2 odm_dlkm splash odm pvmfw
		) do (
			if "%%~nF"=="%%P" (
				move "%%F" "%vFd%"
			)
		)
	)
)

:moving3		
for /d %%D in ("%~dp0FIRMWARE\Unpacked\IMAGES\my_carrier") do (
	echo Moving files from "%%D"
	for %%F in ("%%D\*.img") do (
		for %%P in (
			my_carrier.empty
		) do (
			if "%%~nF"=="%%P" (
				move "%%F" "%vFd%"
			)
		)
	)
)

:moving4
for /d %%D in ("%~dp0FIRMWARE\Unpacked\META") do (
	echo Moving files from "%%D"
	for %%F in ("%%D\*.csv") do (
		for %%P in (
			super_map.in
		) do (
			if "%%~nF"=="%%P" (
				move "%%F" "%~dp0"
			)
		)
	)
	rd /s /q "%%D"
)
for /d %%D in ("%vFd%") do (
	echo Moving files from "%%D"
	for %%F in ("%%D\*.img") do (
		for %%P in (
			oplusreserve2 metadata modem logfs apdp apdpb
		) do (
			if "%%~nF"=="%%P" (
				move "%%F" "%vTr%"
			)
		)
	)
)
%unzip% e "%comprel%" -o"%vFd%" -y  >nul 2>&1
echo.   
echo -----------------------------------------------------------------------------
echo.
echo                        \033[33mUNPACK FIRMWARE AND MOVING SUCCESSFUL| %clr% 
echo.   
echo -----------------------------------------------------------------------------
echo.
goto end
goto start

:unfirm
cls
set "count=0"
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo ----------------------------------------------------------------------------------------
echo.
echo                                   \033[33mUnPack Firmware| %clr%
echo                                !ESC![31m*********************!ESC![0m
echo ----------------------------------------------------------------------------------------
echo.
set /a count+=1
echo [!count!] Select the File
echo.
set /p choice=!ESC![33mSelect the file number, or enter "Q" to go back!ESC![0m: 
echo.
if "%choice%" equ "Q" goto M8
if "%choice%" equ "!count!" (
    for /f "delims=" %%F in ('powershell -command "Add-Type -AssemblyName System.Windows.Forms; $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog; if ($openFileDialog.ShowDialog() -eq 'OK') { $openFileDialog.FileName }"') do set "selectedFile=%%F"
    if not defined selectedFile (
        echo No file selected.
		goto unfirm
	)
	goto unpacked
)

:unpacked
cls
echo.
"%bz%" x "%selectedFile%" FIRMWARE\Unpacked
echo.
echo                                !ESC![33mНажмите любую клавишу . . .!ESC![0m
pause >nul
goto start

:unpack_payload
cls
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo.--------------------------------------------------------------------------------------
title                                  Fastboot Tool
echo.
echo.                        !ESC![31m********!ESC![0m !ESC![33mSeRViP production!ESC![0m !ESC![31m********!ESC![0m
echo.                              !ESC![31m***********************!ESC![0m
echo --------------------------------------------------------------------------------------
echo.
echo                                      [UNPACK]
echo          !ESC![31m_________________________________________________________________!ESC![0m
echo          !ESC![33m______________________________     !ESC![33m______________________________!ESC![0m
echo                                          !ESC![31m*!ESC![0m
echo           [1] !ESC![36mИзвлечение boot/init_boot!ESC![0m  !ESC![31m#!ESC![0m    [2] !ESC![36mИзвлечение recovery!ESC![0m
echo          !ESC![33m______________________________  !ESC![31m*!ESC![0m  !ESC![33m______________________________!ESC![0m
echo.
echo                             [3] !ESC![36mUnpack Payload!ESC![0m
echo                           !ESC![33m______________________________!ESC![0m
echo          !ESC![31m_________________________________________________________________!ESC![0m
echo.
echo.

set  /a choise = 0
set  /p choise=%a0%: 
if "%choise%" == "0" goto start
if "%choise%" == "3" goto payload
if "%choise%" == "2" goto rec
if "%choise%" == "1" goto iboot
goto start

:iboot
cls
set "count=0"
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo ---------------------------------------------------------------------------------------
echo.
echo                                   \033[33mUnPack Firmware| %clr%
echo                                !ESC![31m*********************!ESC![0m
echo ---------------------------------------------------------------------------------------
echo.
echo  "Do you want to unpack boot or init_boot?"
echo.
echo   1 - boot
echo   2 - init_boot
echo.
set  /a choise = 0
set  /p choise=%a0%: 
IF "%choise%" == "0" GOTO M8
IF "%choise%" == "2" GOTO inBoot
IF "%choise%" == "1" GOTO Boot

GOTO next

:Boot
cls
set "currentDir=%cd%"
cd /d "%~dp0PAYLOAD"
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo ---------------------------------------------------------------------------------------
echo.
echo                                   \033[33mUnPack Firmware| %clr%
echo                                !ESC![31m*********************!ESC![0m
echo ---------------------------------------------------------------------------------------
echo.
set /a count+=1
echo.
echo [!count!] Select the File
echo.
set /p choice=!ESC![33mSelect the file number, or enter "Q" to go back!ESC![0m: 
echo.
if "%choice%" equ "Q" goto M8
if "%choice%" equ "!count!" (
    for /f "delims=" %%F in ('powershell -command "Add-Type -AssemblyName System.Windows.Forms; $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog; if ($openFileDialog.ShowDialog() -eq 'OK') { $openFileDialog.FileName }"') do set "selectedFile=%%F"
    if not defined selectedFile (
        echo No file selected.
		goto iboot
	)
	goto ext_boot
)
echo.
:ext_boot
cls
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo -----------------------------------------------------------------------------
echo                                      !ESC![33mBoot| %clr%
echo -----------------------------------------------------------------------------
echo.
echo                                  In processing...
echo.
"%bz%" e "%selectedFile%" payload.bin
echo.
echo.
"%iboot%" --partitions boot payload.bin -o %~dp0BOOT
del /q "%~dp0PAYLOAD\payload.bin" >nul 2>&1
cd /d "%currentDir%"
echo.
echo -----------------------------------------------------------------------------
echo.
echo                          \033[33mUNPACK PAYLOAD AND MOVING SUCCESSFUL| %clr% 
echo.   
echo -----------------------------------------------------------------------------
echo.
goto end
goto start

:inBoot
cls
set "currentDir=%cd%"
cd /d "%~dp0PAYLOAD"
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo ---------------------------------------------------------------------------------------
echo.
echo                                   \033[33mUnPack Firmware| %clr%
echo                                !ESC![31m*********************!ESC![0m
echo ---------------------------------------------------------------------------------------
echo.
set /a count+=1
echo.
echo [!count!] Select the File
echo.
set /p choice=!ESC![33mSelect the file number, or enter "Q" to go back!ESC![0m: 
echo.
if "%choice%" equ "Q" goto M8
if "%choice%" equ "!count!" (
    for /f "delims=" %%F in ('powershell -command "Add-Type -AssemblyName System.Windows.Forms; $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog; if ($openFileDialog.ShowDialog() -eq 'OK') { $openFileDialog.FileName }"') do set "selectedFile=%%F"
    if not defined selectedFile (
        echo No file selected.
		goto iboot
	)
	goto ext_inboot
)
echo.
:ext_inboot
cls
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo -----------------------------------------------------------------------------
echo                                     !ESC![33mInit_Boot| %clr%
echo -----------------------------------------------------------------------------
echo.
echo                                  In processing...
echo.
"%bz%" e "%selectedFile%" payload.bin
echo.
echo.
"%iboot%" --partitions init_boot payload.bin -o %~dp0INIT_BOOT
del /q "%~dp0PAYLOAD\payload.bin" >nul 2>&1
cd /d "%currentDir%"
echo.
echo -----------------------------------------------------------------------------
echo.
echo                          \033[33mUNPACK PAYLOAD AND MOVING SUCCESSFUL| %clr% 
echo.   
echo -----------------------------------------------------------------------------
echo.
goto end
goto start

:rec
cls
set "currentDir=%cd%"
cd /d "%~dp0PAYLOAD"
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo ---------------------------------------------------------------------------------------
echo.
echo                                   \033[33mUnPack Firmware| %clr%
echo                                !ESC![31m*********************!ESC![0m
echo ---------------------------------------------------------------------------------------
echo.
set /a count+=1
echo.
echo [!count!] Select the File
echo.
set /p choice=!ESC![33mSelect the file number, or enter "Q" to go back!ESC![0m: 
echo.
if "%choice%" equ "Q" goto M8
if "%choice%" equ "!count!" (
    for /f "delims=" %%F in ('powershell -command "Add-Type -AssemblyName System.Windows.Forms; $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog; if ($openFileDialog.ShowDialog() -eq 'OK') { $openFileDialog.FileName }"') do set "selectedFile=%%F"
    if not defined selectedFile (
        echo No file selected.
		goto rec
	)
	goto ext_rec
)
echo.
:ext_rec
cls
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo -----------------------------------------------------------------------------
echo                                     !ESC![33mRecovery| %clr%
echo -----------------------------------------------------------------------------
echo.
echo                                  In processing...
echo.
"%bz%" e "%selectedFile%" payload.bin
echo.
echo.
"%iboot%" --partitions recovery payload.bin -o %~dp0RECOVERY
del /q "%~dp0PAYLOAD\payload.bin" >nul 2>&1
cd /d "%currentDir%"
echo.
echo -----------------------------------------------------------------------------
echo.
echo                          \033[33mUNPACK PAYLOAD AND MOVING SUCCESSFUL| %clr% 
echo.   
echo -----------------------------------------------------------------------------
echo.
goto end
goto start

:payload
cls
set "currentDir=%cd%"
cd /d "%~dp0PAYLOAD"
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo ---------------------------------------------------------------------------------------
echo.
echo                                   \033[33mUnPack FULL OTA| %clr%
echo                                !ESC![31m*********************!ESC![0m
echo ---------------------------------------------------------------------------------------
echo.
set /a count+=1
echo.
echo [!count!] Select the File
echo.
set /p choice=!ESC![33mSelect the file number, or enter "Q" to go back!ESC![0m: 
echo.
if "%choice%" equ "Q" goto M8
if "%choice%" equ "!count!" (
    for /f "delims=" %%F in ('powershell -command "Add-Type -AssemblyName System.Windows.Forms; $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog; if ($openFileDialog.ShowDialog() -eq 'OK') { $openFileDialog.FileName }"') do set "selectedFile=%%F"
    if not defined selectedFile (
        echo No file selected.
		goto payload
	)
	goto metainf
)
:metainf
cls
echo.
echo Информация о пакете "%selectedFile%":
echo.

powershell -Command "Expand-Archive -Path '%selectedFile%' -DestinationPath temp_ota"

if exist "temp_ota\META-INF\com\android\metadata" (
    for /f "tokens=1* delims==" %%a in ('findstr /i "ota-id= version_name= security_patch= android_version= oplus_hex_nv_id=" temp_ota\META-INF\com\android\metadata') do (
        echo !ESC![33m%%a!ESC![0m: %%b
    )
) else (
    echo metadata не найден в архиве.
)

rd /s /q temp_ota
echo.
echo.
echo                       !ESC![33mНажмите любую клавишу для продолжения . .!ESC![0m
pause >nul
goto :ext_payload
echo.
:ext_payload
cls
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo -----------------------------------------------------------------------------
echo                                   !ESC![33mUnPack Payload| %clr%
echo -----------------------------------------------------------------------------
echo.
echo                                  In processing...
echo.
"%bz%" e "%selectedFile%" payload.bin
echo.
echo.
"%iboot%" payload.bin -o %vFd%
del /q "%~dp0PAYLOAD\payload.bin" >nul 2>&1
%unzip% e "%comprel%" -o"%vFd%" -y  >nul 2>&1
for /d %%D in ("%vFd%") do (
	echo Moving files from "%%D"
	for %%F in ("%%D\*.img") do (
		for %%P in (
			modem
		) do (
			if "%%~nF"=="%%P" (
				move "%%F" "%vTr%"
			)
		)
	)
)
cd /d "%currentDir%"
echo. 
echo -----------------------------------------------------------------------------
echo.
echo                          \033[33mUNPACK PAYLOAD AND MOVING SUCCESSFUL| %clr% 
echo.   
echo -----------------------------------------------------------------------------
echo.
goto end
goto start
----------------------------------- 
:M9
cls
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo.-------------------------------------------------------------------------------------
title                               Magisk Patcher
echo.
echo.                         !ESC![31m********!ESC![0m !ESC![33mSeRViP production!ESC![0m !ESC![31m********!ESC![0m
echo.                               !ESC![31m***********************!ESC![0m
echo -------------------------------------------------------------------------------------
echo.
"%patch%"
goto start
::====================================SeRViP================================::
:M10
cls
title    Downloader
set "COLOR_UNDERSCORE=[4m"
set "COLOR_RED=[31m"
set "COLOR_BROWN=[33m"
set "COLOR_BLUE=[36m"
set "COLOR_RESET=[0m"
echo.
echo.    [!COLOR_BLUE!%DATE%!COLOR_RESET!]   [!COLOR_BLUE!%TIME:~0,5%!COLOR_RESET!]   [!COLOR_BLUE!%COMPUTERNAME%!COLOR_RESET!]  [!COLOR_BLUE!%CD%!COLOR_RESET!]	
echo.!COLOR_RED!_______________________________________________________________________________________!COLOR_RESET!
echo.
echo.                         !ESC![31m********!ESC![0m !ESC![33mSeRViP production!ESC![0m !ESC![31m********!ESC![0m
echo.                               !ESC![31m***********************!ESC![0m
echo.!COLOR_RED!_______________________________________________________________________________________!COLOR_RESET!
echo.
echo.
echo			     !COLOR_BROWN!==========================================!COLOR_RESET!
echo			     !COLOR_BROWN!=!COLOR_RESET!      !COLOR_BLUE!Введите ссылку для загрузки!COLOR_RESET!       !COLOR_BROWN!=!COLOR_RESET!
echo			     !COLOR_BROWN!==========================================!COLOR_RESET!
echo.
echo. 
set /p URL=!COLOR_BROWN!Введите URL: !COLOR_RESET!
if "%URL%" equ "" (
goto :M10
)
cls
echo.
echo.                                !COLOR_BLUE!Download from URL:!COLOR_RESET!
echo.
echo.
%aria% -x16 -s16 -j5 --file-allocation=none %URL%
echo.
echo.
echo.
echo                             !COLOR_BROWN!Загрузка по URL завершена.!COLOR_RESET!
echo.
echo.
echo                               !COLOR_BROWN!Нажмите любую клавишу . .!COLOR_RESET!
pause >nul
goto start
::====================================SeRViP================================::
:M11
cls
set "currentDir=%cd%"
cd /d "%~dp0bin"
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo.-------------------------------------------------------------------------------------
title                               Platform Tool
echo.
echo.                         !ESC![31m********!ESC![0m !ESC![33mSeRViP production!ESC![0m !ESC![31m********!ESC![0m
echo.                               !ESC![31m***********************!ESC![0m
echo -------------------------------------------------------------------------------------
echo.
@cmd
goto start
-----------------------------------
:end
echo.
echo                                !ESC![33mНажмите любую клавишу . .!ESC![0m
pause >nul
cls
echo.
echo.     [!ESC![33m%DATE%!ESC![0m]   [!ESC![33m%TIME:~0,5%!ESC![0m]   [!ESC![33m%COMPUTERNAME%!ESC![0m]  [!ESC![33m%CD%!ESC![0m]
echo.------------------------------------------------------------------------------------
title                               Fastboot ROM Installer
echo.
echo.                        !ESC![31m********!ESC![0m !ESC![33mSeRViP production!ESC![0m !ESC![31m********!ESC![0m
echo.                              !ESC![31m***********************!ESC![0m
echo ---------------------------------------------------------------------------
echo.
echo.
echo                           %A13%
echo.
echo.
echo.
echo                       %A12%
echo.
echo.
echo.
echo.
echo ---------------------------------------------------------------------------
pause >> nul
goto start