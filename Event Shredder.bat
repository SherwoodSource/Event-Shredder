@echo off

:: Original Author: Nolan Sherwood
:: Updated by: Jules
:: Licence: Open Source
:: Date: 19-JUN-24

color 0B
title Event Shredder v1.1

echo.
echo  ---------------------------------------------------------------------------
echo                            Event Shredder v1.1
echo  ---------------------------------------------------------------------------
echo.
echo  Welcome to Event Shredder, an open source project.
echo  Join the developer team today and help us delete useless logs in
echo  Windows machines!
echo.
echo  ---------------------------------------------------------------------------
echo.
pause
cls

echo.
echo  ---------------------------------------------------------------------------
echo  Thank you for using Event Shredder!
echo  Original Author: Nolan Sherwood
echo  Updated for Windows 10 and 11 compatibility.
echo  Visit GitHub to contribute to this project!
echo  ---------------------------------------------------------------------------
echo.
echo  Checking for Administrator privileges...

net session >nul 2>&1
if %errorLevel% neq 0 goto noAdmin

echo  Administrator privileges confirmed.
echo  Shredding logs, please wait...
echo.

for /F "tokens=*" %%G in ('wevtutil.exe el') DO (
    echo  Clearing: %%G
    wevtutil.exe cl "%%G" 2>nul
)

echo.
echo  ---------------------------------------------------------------------------
echo  Event Logs have been shredded!
echo  ---------------------------------------------------------------------------
echo.
goto theEnd

:noAdmin
echo.
echo  ERROR: You must run this script as an Administrator!
echo.

:theEnd
pause
exit
