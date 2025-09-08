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

%LOG%    "    Deshabilita el servicio de escritorio remoto"
%SCServicesDown% TermService

%LOG%    "    Deshabilita el servicio de entorno de sesiones (necesario para conexiones remotas)"
%SCServicesDown% SessionEnv

%LOG%    "    Deshabilita el servicio de administración remota de Windows (WinRM)"
%SCServicesDown% WinRM

%LOG%    "    Deshabilita el servicio de acceso remoto a la red (VPN y túneles de red)"
%SCServicesDown% RemoteAccess

%LOG%    "    Deshabilita la asistencia remota de Windows"
%SCServicesDown% RpcLocator

%LOG%    "    Deshabilita el servicio de puerta de enlace de escritorio remoto"
%SCServicesDown% UmRdpService

%LOG%    "    Deshabilita el redireccionamiento de dispositivos de escritorio remoto"
%SCServicesDown% SessionEnv

%LOG%    "    Deshabilita el servicio de ayuda remota de Windows"
%SCServicesDown% RemoteRegistry

%LOG%    "    Deshabilita la política de permisos de autenticación remota"
%RegAdd% "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" fDenyTSConnections REG_DWORD 1

%LOG%    "    Bloquea el firewall para conexiones de escritorio remoto"
netsh advfirewall firewall set rule group="Remote Desktop" new enable=No

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

