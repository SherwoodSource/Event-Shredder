@ECHO OFF
:start
title Event Shredder
echo.
echo ----------------------------------------------------------------------------
echo.
echo                          Event Shredder Ver 1.0
echo.
echo ----------------------------------------------------------------------------
echo Welcome to Event Shredder, this is an open source project. Join the
echo developer team today and help us delete useless logs in Windows machines!
echo If you want to clear useless computer logs . . .
echo ----------------------------------------------------------------------------

color F0
pause
cls
echo ----------------------------------------------------------------------------
echo Thank you for using Event Shredder!
echo Author Nolan Sherwood
echo http://www.webdesignportfolio.wix.com/home
echo ----------------------------------------------------------------------------
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
