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

%LOG%    "     Deshabilita el servicio de Geolocalización"
%SCServicesDown% lfsvc

%LOG%    "     Deshabilita el servicio de Sensor de Ubicación"
%SCServicesDown%  SensorService

%LOG%    "     Deshabilita el servicio de Datos de Sensores"
%SCServicesDown% SensorDataService

%LOG%    "     Deshabilita el servicio de Supervisión de Sensores"
%SCServicesDown% SensrSvc

%LOG%    "     Deshabilita el acceso a la ubicación en el Registro"
%RegAdd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" Value REG_SZ Deny

%LOG%    "     Deshabilita la API de geolocalización en Microsoft Edge"
%RegAdd% "HKLM\SOFTWARE\Policies\Microsoft\Edge" GeolocationEnabled REG_DWORD 0

%LOG%    "     Bloquear el seguimiento de ubicación"
%RegAdd% "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" "Value" REG_SZ "Deny"

%LOG%    "     Desactivar el acceso a la ubicación en Windows"
%RegAdd% "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" "LetAppsAccessLocation" REG_DWORD 2
%RegAdd% "HKLM\Software\Policies\Microsoft\Windows\LocationAndSensors" "DisableLocation" REG_DWORD 1

::========================================================================================================================================
::========================================================================================================================================

:fin
::popd
%LOG%    "     Ha finalizado el script "%~nx0""
%LOG%    "     ."
%LOG%    "     ."
%LOG%    "     ."
%LOG%    "     pausar si estamos realizando una ejecucion independiente
if %STANDALONE%==yes pause
if %STANDALONE%==yes %Suscribete%
if %STANDALONE%==ind exit
if %STANDALONE%==no goto :eof
if %STANDALONE%==API goto :eof
