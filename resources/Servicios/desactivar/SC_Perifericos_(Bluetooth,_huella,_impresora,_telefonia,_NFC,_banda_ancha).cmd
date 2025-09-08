:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::IntecZeroo:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::https://www.youtube.com/channel/UCkIm0Fu5DdJ-va5Gp9n3Taw
::========================================================================================================================================
::========================================================================================================================================

set "STANDALONE=%1"
if "%STANDALONE%"=="" set "STANDALONE=no"

:: API llamada de otros bat
if "%STANDALONE%"=="ind" (
    @echo off
    chcp 65001
    %LOGO%
)

:: API llamada de otros bat
if "%STANDALONE%"=="API" (
    @echo off
    chcp 65001
    %LOGO%
    pushd "%~dp0"
    set "RUTA=%~dp0"
    call :API
    popd
    exit /b
)    

:: Comprobar ejecución independiente
if /i not "%LOGFILE%"=="" goto :start
    setlocal EnableDelayedExpansion
    @echo off
    chcp 65001

    if exist "%~dp0resources" set "RUTA=%~dp0" & goto :cargar

    :: Numero de busquedas de la carpeta resources
    set N=10
        for /L %%A in (0,1,%N%) do (
            set "X=!X!..\"
            if exist "%~dp0!X!resources" (
                pushd "%~dp0!X!"
                for %%I in (.) do set "RUTA=%%~fI"
                goto :Cargar
            )
        )

    echo No se encontro la carpeta resources
    pause
    exit

    :Cargar
    endlocal & set "RUTA=%RUTA%"
    set "STANDALONE=yes"
    pushd %RUTA%
    call "%RUTA%\resources\Funciones\Version.bat"
    call "%RUTA%\resources\Funciones\Logo.bat"

:start


title "%~nx0"
%LOG% "    Iniciando script "%~nx0"."

::========================================================================================================================================
::========================================================================================================================================

%LOG%    "    Deshabilita el servicio de Bluetooth"
%SCServicesDown% bthserv

%LOG%    "    Deshabilita el soporte para dispositivos HID (teclados multimedia, botones especiales)"
%SCServicesDown% hidserv

%LOG%    "    Deshabilita el servicio de entrada de tabletas digitales"
%SCServicesDown% TabletInputService

%LOG%    "    Deshabilita el servicio de huellas digitales y biometría"
%SCServicesDown% WbioSrvc

%LOG%    "    Deshabilita el servicio de fax"
%SCServicesDown% Fax

%LOG%    "    Deshabilita el servicio de telefonía de Windows"
%SCServicesDown% PhoneSvc

%LOG%    "    Deshabilita el servicio de administración de pagos NFC"
%SCServicesDown% SEMgrSvc

%LOG%    "    Deshabilita el servicio de sensores de ubicación"
%SCServicesDown% SensorService

%LOG%    "    Deshabilita el servicio de autenticación de tarjetas inteligentes"
%SCServicesDown% SCPolicySvc

%LOG%    "    Deshabilita el servicio de soporte para tarjetas inteligentes"
%SCServicesDown% SCardSvr

%LOG%    "    Deshabilita el servicio de conexión de banda ancha móvil"
%SCServicesDown% WwanSvc

%LOG%    "    Deshabilita el servicio de cola de impresión"
%SCServicesDown% Spooler

::========================================================================================================================================
::========================================================================================================================================

:fin
::popd
%LOG%    "     Ha finalizado el script "%~nx0""
%LOG%    "     ."
%LOG%    "     ."
%LOG%    "     ."
:: pausar si estamos realizando una ejecucion independiente
if %STANDALONE%==yes pause
if %STANDALONE%==yes %Suscribete%
if %STANDALONE%==ind exit
if %STANDALONE%==no goto :eof
if %STANDALONE%==API goto :eof


