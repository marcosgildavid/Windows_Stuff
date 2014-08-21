SetLocal
@echo off
cls
REM **************************************
REM USER VARIABLES
REM **************************************

SET VPNNAME=VPNNAME
SET VPNUSER=vpnuser
SET VPNPASS=vpnpass
REM If you do not use a Domain then set VPNDOMAIN to empty: SET VPNDOMAIN=
SET VPNDOMAIN=vpndomain

REM ROUTES TO ADD AFTER CONNECT
REM EXAMPLE: ROUTE1=route add 10.110.0.0 mask 255.255.0.0 10.255.255.2
SET ROUTE1=
SET ROUTE2=
SET ROUTE3=
SET ROUTE4=
SET ROUTE5=

REM **************************************

cls
SET IFNUMBER=-1

IF  defined VPNDOMAIN  (
    rasdial %VPNNAME% %VPNUSER% %VPNPASS%
) else (
    rasdial %VPNNAME% %VPNUSER% %VPNPASS% /domain:%VPNDOMAIN%
)

if %ERRORLEVEL% GEQ 1 (
	echo Error Activating VPN, please check if it is properly configured
	echo or if it is no already connected
	pause
	goto :disconnect
)

set done=0
For /f "eol== delims=. tokens=1,2 " %%i In ('route print Interface list') Do (
	IF %%j == %VPNNAME% set /a IFNUMBER=%%i
	
)

IF %IFNUMBER%==-1 (
		echo Interface name not found	
		pause
		goto :disconnect
)


call:setRoutes


echo . 
echo . 
echo CONNECTION ESTABLISHED!!!
echo . 
echo . 


REM echo PRESS ENTER TO DISCONNECT THE VPN

pause

:disconnect
REM echo DISCONNECTING VPN
REM rasdial %VPNNAME% /disconnect
echo .
echo .
echo .
echo PRESS ENTER TO EXIT
EndLocal


pause
exit


:setRoutes

if defined ROUTE1 (
    echo "Setting route1"
    set CMD=%ROUTE1% if %IFNUMBER%
    %CMD%
    IF %ERRORLEVEL% GEQ 1 (
        echo Error Setting %ROUTE1%!
        pause
        goto :disconnect
    )
)
echo . 
if defined ROUTE2 (
    echo "Setting route2"
    set CMD=%ROUTE2% if %IFNUMBER%
    %CMD%
    IF %ERRORLEVEL% GEQ 1 (
        echo Error Setting %ROUTE2%!
        pause
        goto :disconnect
    )
)
echo . 
if defined ROUTE3 (
    echo "Setting route3"
    set CMD=%ROUTE3% if %IFNUMBER%
    %CMD%
    IF %ERRORLEVEL% GEQ 1 (
        echo Error Setting %ROUTE3%!
        pause
        goto :disconnect
    )
)
echo . 
if defined ROUTE4 (
    set CMD=%ROUTE4% if %IFNUMBER%
    %CMD%
    IF %ERRORLEVEL% GEQ 1 (
        echo Error Setting %ROUTE4%!
        pause
        goto :disconnect
    )
)
echo . 
if defined ROUTE5 (
    set CMD=%ROUTE5% if %IFNUMBER%
    %CMD%
    IF %ERRORLEVEL% GEQ 1 (
        echo Error Setting %ROUTE5%!
        pause
        goto :disconnect
    )
)
echo . 
echo "ROUTES SET!"
echo . 
goto:eof
