:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::IntecZeroo:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::https://www.youtube.com/channel/UCkIm0Fu5DdJ-va5Gp9n3Taw
::1.1 se añade una telemetria extra para evitar el uso de gafas virtuales 
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

%LOG%    "    Servicio de autenticacion de Xbox Live (XblAuthManager)...
%SCServicesDown% XblAuthManager

%LOG%    "    Servicio de almacenamiento de juegos de Xbox Live (XblGameSave)...
%SCServicesDown% XblGameSave

%LOG%    "    Servicio de conectividad de Xbox Live (XboxNetApiSvc)...
%SCServicesDown% XboxNetApiSvc

%LOG%    "    Servicio de transmision de medios en red (WMPNetworkSvc)...
%SCServicesDown% WMPNetworkSvc

%LOG%    "    Servicio de puerta de enlace de aplicaciones (ALG)...
%SCServicesDown% ALG

%LOG%    "    Servicio de administracion de sistema guardado (SgrmBroker)...
%SCServicesDown% SgrmBroker

%LOG%    "    Servicio de enumeracion de dispositivos de juego compartidos (ScDeviceEnum)...
%SCServicesDown% ScDeviceEnum

%RegAdd% "HKCU\Software\Microsoft\Windows\CurrentVersion\Holographic" "FirstRunSucceeded" REG_DWORD 0

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