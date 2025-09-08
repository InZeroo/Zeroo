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

%LOG%    "    Interfaz de red de Hyper-V..."
%SCServicesDown% vmicguestinterface

%LOG%    "    Servicio de apagado de Hyper-V..."
%SCServicesDown% vmicshutdown

%LOG%    "    Servicio de sincronización de hora de Hyper-V..."
%SCServicesDown% vmictimesync

%LOG%    "    Servicio de sesión de máquina virtual..."
%SCServicesDown% vmicvmsession

%LOG%    "    Servicio de respaldo en máquinas virtuales..."
%SCServicesDown% vmicvss

%LOG%    "    Servicio de latido de Hyper-V..."
%SCServicesDown% vmicheartbeat

%LOG%    "    Servicio de intercambio de datos entre host y VM..."
%SCServicesDown% vmickvpexchange

%LOG%    "    Servicio de Hyper-V Host Compute Service..."
%SCServicesDown% HvHost

Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Hypervisor

::========================================================================================================================================
::========================================================================================================================================

:fin
::popd
%LOG% "    Ha finalizado el script "%~nx0""
%LOG%    "     ."
%LOG%    "     ."
%LOG%    "     ."
:: pausar si estamos realizando una ejecucion independiente
if %STANDALONE%==yes pause
if %STANDALONE%==yes %Suscribete%
if %STANDALONE%==ind exit
if %STANDALONE%==no goto :eof
if %STANDALONE%==API goto :eof