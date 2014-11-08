@echo off

:: Original Author: Nolan Sherwood
:: Licence: Open Source

:: Date: 07-NOV-14
color F8
title Event Shredder.exe
echo.
:echo.call
:ColorText /Fa "Event Shredder Ver 1.0"

echo.
set /p ".= " <nul
call :ColorText F8 "---------------------------------------------------------------------------"

echo.
echo.
set /p ".= " <nul
call :ColorText F9 "                          Event Shredder Ver 1.0"

echo.
echo.
set /p ".= " <nul
call :ColorText F8 "---------------------------------------------------------------------------"

echo.
set /p ".= " <nul
call :ColorText Fa "Welcome to Event Shredder, this is an open source project. Join the developer"
echo.


set /p ".= " <nul
call :ColorText Fa "team today and help us delete useless logs in Windows machines!"
echo.
set /p ".= " <nul
call :ColorText F8 "----------------------------------------------------------------------------"
echo.
pause
cls
set /p ".= " <nul
call :ColorText F8 "----------------------------------------------------------------------------"
echo.
set /p ".= " <nul
call :ColorText F9 "Thank you for using Event Shredder!"
echo.
set /p ".= " <nul
call :ColorText F9 "Author Nolan Sherwood"
echo.
set /p ".= " <nul
call :ColorText F9 "Visit github to contribute to this project!"
echo.
set /p ".= " <nul
call :ColorText F8 "----------------------------------------------------------------------------"
echo.
echo.
echo.
FOR /F "tokens=1,2*" %%V IN ('') DO SET adminTest=%%V
IF (%adminTest%)==(Access) goto noAdmin
for /F "tokens=*" %%G in ('wevtutil.exe el') DO (call :do_clear "%%G")
echo.
echo Event Logs have been shredded! ^<press any key^>
goto theEnd
:do_clear
echo clearing %1
wevtutil.exe cl %1
goto :eof
:noAdmin
echo You must run this script as an Administrator!
echo ^<press any key^>
:theEnd
pause>NUL
echo.
echo.
pause
exit


:: Keep this label exactly as it is and do not change anything here!

:ColorText [%1 = Color] [%2 = Text]
set /p ".=." > "%~2" <nul 
findstr /v /a:%1 /R "^$" "%~2" nul 2>nul
set /p ".=" <nul
if "%3" == "end" set /p ".=  " <nul
del "%~2" >nul 2>nul
exit /b
