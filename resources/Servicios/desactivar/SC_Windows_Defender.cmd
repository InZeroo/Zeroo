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

%LOG%    "    Deshabilita el servicio principal de Windows Defender"
%SCServicesDown% WinDefend 

%LOG%    "    Deshabilita el servicio de protección en tiempo real"
%SCServicesDown% Sense

%LOG%    "    Deshabilita el servicio de inspección de red de Windows Defender"
%SCServicesDown% WdNisSvc

%LOG%    "    Deshabilita el servicio de plataforma de seguridad de Windows Defender"
%SCServicesDown% SecurityHealthService

%LOG%    "    Bloquea el reinicio de Windows Defender en el registro"
%RegDel% "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" DisableAntiSpyware REG_DWORD 1 
%RegDel% "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" DisableBehaviorMonitoring REG_DWORD 1
%RegDel% "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" DisableOnAccessProtection REG_DWORD 1
%RegDel% "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" DisableScanOnRealtimeEnable REG_DWORD 1

::========================================================================================================================================

%LOG%    "    1 - Disable Real-time protection"
%RegDel% "HKLM\Software\Policies\Microsoft\Windows Defender"
%RegAdd% "HKLM\Software\Policies\Microsoft\Windows Defender" "DisableAntiSpyware" REG_DWORD "1"
%RegAdd% "HKLM\Software\Policies\Microsoft\Windows Defender" "DisableAntiVirus" REG_DWORD "1"
%RegAdd% "HKLM\Software\Policies\Microsoft\Windows Defender" "DisableRoutinelyTakingAction" REG_DWORD "1"
%RegAdd% "HKLM\Software\Policies\Microsoft\Windows Defender\MpEngine" "MpEnablePus" REG_DWORD "0"
%RegAdd% "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableBehaviorMonitoring" REG_DWORD "1"
%RegAdd% "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableIOAVProtection" REG_DWORD "1"
%RegAdd% "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableOnAccessProtection" REG_DWORD "1"
%RegAdd% "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableRealtimeMonitoring" REG_DWORD "1"
%RegAdd% "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableScanOnRealtimeEnable" REG_DWORD "1"
%RegAdd% "HKLM\Software\Policies\Microsoft\Windows Defender\Reporting" "DisableEnhancedNotifications" REG_DWORD "1"
%RegAdd% "HKLM\Software\Policies\Microsoft\Windows Defender\SpyNet" "DisableBlockAtFirstSeen" REG_DWORD "1"
%RegAdd% "HKLM\Software\Policies\Microsoft\Windows Defender\SpyNet" "SpynetReporting" REG_DWORD "0"
%RegAdd% "HKLM\Software\Policies\Microsoft\Windows Defender\SpyNet" "SubmitSamplesConsent" REG_DWORD "2"

%LOG%    "    0 - Disable Logging"
%RegAdd% "HKLM\System\CurrentControlSet\Control\WMI\Autologger\DefenderApiLogger" "Start" REG_DWORD "0"
%RegAdd% "HKLM\System\CurrentControlSet\Control\WMI\Autologger\DefenderAuditLogger" "Start" REG_DWORD "0"

%LOG%    "    Disable WD Tasks"
%DesactivarTask% "Microsoft\Windows\ExploitGuard\ExploitGuard MDM policy Refresh"
%DesactivarTask% "Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance"
%DesactivarTask% "Microsoft\Windows\Windows Defender\Windows Defender Cleanup"
%DesactivarTask% "Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan"
%DesactivarTask% "Microsoft\Windows\Windows Defender\Windows Defender Verification"

%LOG%    "    Disable WD systray icon"
%RegDel% "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" "SecurityHealth"
%RegDel% "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" "SecurityHealth"

%LOG%    "    Remove WD context menu"
%RegDel% "HKCR\*\shellex\ContextMenuHandlers\EPP"
%RegDel% "HKCR\Directory\shellex\ContextMenuHandlers\EPP"
%RegDel% "HKCR\Drive\shellex\ContextMenuHandlers\EPP"

%LOG%    "    Disable WD services"
%RegAdd% "HKLM\System\CurrentControlSet\Services\WdBoot" "Start" REG_DWORD "4"
%RegAdd% "HKLM\System\CurrentControlSet\Services\WdFilter" "Start" REG_DWORD "4"
%RegAdd% "HKLM\System\CurrentControlSet\Services\WdNisDrv" "Start" REG_DWORD "4"

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

