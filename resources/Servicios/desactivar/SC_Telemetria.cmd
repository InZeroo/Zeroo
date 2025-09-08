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

%LOG%    "    Deshabilita el servicio de Compatibilidad con Aplicaciones de Windows"
%SCServicesDown% PcaSvc

::%LOG%    "    Deshabilita el servicio de Informes de Errores de Windows"
::%SCServicesDown% WerSvc

%LOG%    "    Deshabilita el servicio de Experiencia del Usuario con Aplicaciones"
%SCServicesDown% UevAgentService

%LOG%    "    Deshabilita el servicio de Servicio de Inventario de Software"
%SCServicesDown% DoSvc

%LOG%    "    Deshabilita la Experiencia del Cliente Conectado y Telemetría"
%SCServicesDown% dmwappushservice

%LOG%    "    Deshabilita el servicio de Experiencia del Usuario y Telemetría"
%SCServicesDown% DiagTrack

%LOG%    "    Deshabilita el servicio de almacenamiento de experiencias de usuario"
%SCServicesDown% wisvc

%LOG%    "    Deshabilita el servicio de Experiencia del Cliente Conectado"
%SCServicesDown% CDPUserSvc

%LOG%    "    Deshabilita el servicio de Configuración de Experiencia de Usuario"
%SCServicesDown% WbioSrvc




%LOG%    "    Deshabilita la recopilación de datos en el Registro"
%RegAdd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" AllowTelemetry REG_DWORD 0

%LOG%    "    Deshabilita el servicio de sugerencias en la pantalla de bloqueo"
%RegAdd% "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" DisableWindowsSpotlightFeatures REG_DWORD 1

%LOG%    "    Deshabilita las notificaciones de sugerencias y recomendaciones"
%RegAdd% "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" SubscribedContent-314559Enabled REG_DWORD 0
%RegAdd% "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" SubscribedContent-338389Enabled REG_DWORD 0

%LOG%    "    Deshabilita la publicidad en el menú inicio"
%RegAdd% "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" SubscribedContent-353694Enabled REG_DWORD 0

%LOG%    "    Deshabilita las experiencias compartidas entre dispositivos"
%RegAdd% "HKCU\Software\Microsoft\Windows\CurrentVersion\CDP" CdpSessionUserAuthzPolicy REG_DWORD 0

%LOG%    "    Deshabilita el contenido en la pantalla de bloqueo"
%RegAdd% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" NoLockScreenSlideshow REG_DWORD 1
%RegAdd% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" NoLockScreenCamera REG_DWORD 1

%LOG%    "    Deshabilita los anuncios en el Explorador de archivos"
%RegAdd% "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" ShowSyncProviderNotifications REG_DWORD 0

%LOG%    "    Deshabilita la publicidad en la barra de tareas"
%RegAdd% "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" SoftLandingEnabled REG_DWORD 0

%LOG%    "    Deshabilita los anuncios de sugerencias en la Configuración de Windows"
%RegAdd% "HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" ScoobeSystemSettingEnabled REG_DWORD 0

%LOG%    "    Deshabilita las notificaciones de sugerencias de aplicaciones en la Microsoft Store"
%RegAdd% "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" SilentInstalledAppsEnabled REG_DWORD 0


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