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

%LOG%    "    Deshabilita el servicio de autenticación en dominios (solo necesario en redes empresariales)"
%SCServicesDown% Netlogon

%LOG%    "    Deshabilita el servicio de políticas de tarjetas inteligentes"
%SCServicesDown% SCPolicySvc

%LOG%    "    Deshabilita el servicio de soporte para tarjetas inteligentes"
%SCServicesDown% SCardSvr

%LOG%    "    Deshabilita el servicio de cola de impresión (necesario solo si usas impresoras en red)"
%SCServicesDown% Spooler

%LOG%    "    Deshabilita el servicio de archivos sin conexión"
%SCServicesDown% CscService

%LOG%    "    Deshabilita el servicio de propagación de certificados de usuario"
%SCServicesDown% CertPropSvc

%LOG%    "    Deshabilita el servicio de distribución entre pares (utilizado en redes empresariales)"
%SCServicesDown% PeerDistSvc

%LOG%    "    Deshabilita el servicio de almacenamiento en red iSCSI"
%SCServicesDown% MSiSCSI

%LOG%    "    Deshabilita el servicio de monitoreo de SNMP (redes empresariales)"
%SCServicesDown% SNMPTRAP

%LOG%    "    Deshabilita el servicio de carpetas de trabajo en red"
%SCServicesDown% workfolderssvc

%LOG%    "    Deshabilita el sistema de archivos cifrados (EFS)"
%SCServicesDown% EFS

%LOG%    "    Deshabilita el servicio de modo demo de Windows"
%SCServicesDown% RetailDemo

%LOG%    "    Deshabilita el servicio de modo empresa de Internet Explorer"
%SCServicesDown% Emndp

%LOG%    "    Deshabilita el servicio de compatibilidad con tarjetas inteligentes"
%SCServicesDown% SCardSvr

%LOG%    "    Deshabilita el servicio de gestión de pagos NFC"
%SCServicesDown% SEMgrSvc

%LOG%    "    Deshabilita el servicio de telefonía de Windows"
%SCServicesDown%  PhoneSvc

%LOG%    "    Deshabilita el servicio de administración de dispositivos compartidos"
%SCServicesDown%  shpamsvc

::========================================================================================================================================
::========================================================================================================================================

:fin
::popd
%LOG% "    Ha finalizado el script "%~nx0""
%LOG%    "     ."
%LOG%    "     ."
%LOG%    "     ."
%LOG%    "    pausar si estamos realizando una ejecucion independiente
if %STANDALONE%==yes pause
if %STANDALONE%==yes %Suscribete%
if %STANDALONE%==ind exit
if %STANDALONE%==no goto :eof
if %STANDALONE%==API goto :eof