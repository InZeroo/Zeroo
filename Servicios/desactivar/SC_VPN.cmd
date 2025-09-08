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

%LOG%    "     Deshabilita el servicio de acceso remoto a la red (VPN y túneles de red)"
%SCServicesDown% RemoteAccess 

%LOG%    "     Deshabilita el servicio de administración de autenticación de VPN"
%SCServicesDown% RasMan

%LOG%    "     Deshabilita el servicio de conexión de banda ancha móvil (WWAN, utilizado en algunas VPNs)"
%SCServicesDown% WwanSvc 

%LOG%    "     Deshabilita el servicio de política de conexión (Cubre VPNs y conexiones remotas)"
%SCServicesDown% IKEEXT

%LOG%    "     Deshabilita el servicio de autenticación de claves de IPsec (requerido por algunas VPNs)"
%SCServicesDown% PolicyAgent

%LOG%    "     Deshabilita el servicio de túnel seguro de Windows (utilizado en VPNs y conexiones seguras)"
%SCServicesDown% SSTPService

%LOG%    "     Deshabilita el servicio de NAT de Windows (utilizado en algunas configuraciones de VPN)"
%SCServicesDown% SharedAccess

%LOG%    "     Deshabilita el servicio de administración de enrutamiento y acceso remoto"
%SCServicesDown% RmSvc

%LOG%    "     Bloquea el tráfico VPN en el firewall de Windows"
netsh advfirewall firewall set rule group="Routing and Remote Access" new enable=No
netsh advfirewall firewall set rule group="Secure Socket Tunneling Protocol (SSTP-In)" new enable=No

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

