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

%LOG%    "    Deshabilita el servicio principal de Windows Update"
%SCServicesDown% wuauserv

%LOG%    "    Deshabilita el servicio de Orchestrator de actualizaciones"
call :SCServices DownUsoSvc 

%LOG%    "    Deshabilita el servicio de reparación de Windows Update (WaaS Medic Service)"
%SCServicesDown% WaaSMedicSvc

%LOG%    "    Deshabilita el servicio de transferencia inteligente en segundo plano (BITS), utilizado por Windows Update"
%SCServicesDown% BITS

%LOG%    "    Deshabilita el servicio de Telemetría y Diagnóstico (recolecta datos sobre las actualizaciones)"
%SCServicesDown% DiagTrack

%LOG%    "    Deshabilita el servicio de instalación de módulos de Windows Update"
%SCServicesDown% TrustedInstaller

%LOG%    "    Bloquea las conexiones de Windows Update a nivel de firewall"
netsh advfirewall firewall add rule name="Bloquear Windows Update" dir=out action=block remoteip=13.107.4.50,13.107.5.93,52.109.76.0/22 protocol=any

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

