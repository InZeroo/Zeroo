:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::IntecZeroo:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::https://www.youtube.com/channel/UCkIm0Fu5DdJ-va5Gp9n3Taw
:: 1.1 reparacion modo maximo rendimiento ya no genera varias opciones 
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

set "maximo_rendimiento=no"

::-------------------------------------------------------------------------------------

echo %CPU% | findstr /c:"Celeron" >nul && set CPU_CELERON=yes || set CPU_CELERON=no

if /i "%CPU_CELERON%"=="yes" (
    %LOG%    "    [Info] Se detecto procesador Celeron. Se ejecuta modo maximo rendimiento"
    %LOG%    "    SE RECOMIENDA CAMBIAR DE PROCESADOR"
    set "maximo_rendimiento=yes"
)

::-------------------------------------------------------------------------------------

if %RAM%==4 (
    %LOG%    "    [Info] 4 GB detectados. Se ejecuta modo maximo rendimiento."
    %LOG%    "    SE RECOMIENDA INSTALAR MAS MEMORIA DE RAM"
    set "maximo_rendimiento=yes"
)

::-------------------------------------------------------------------------------------

if %VRAM% LSS 500 (
    %LOG%    "    [Info] Se ha detectado VRAM inferior a 500MB. ejecutando modo maximo rendimiento"
    %LOG%    "    SE RECOMIENDA INSTALAR DRIVERS DE VIDEO O COMPRAR GRAFICA"
    set "maximo_rendimiento=yes"
)

::========================================================================================================================================

if "%maximo_rendimiento%"=="yes" (

    REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v UseOLEDTaskbarTransparency /t REG_DWORD /d 0 /f
    REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAcrylicTranslucency /t REG_DWORD /d 0 /f
    REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v UseAcrylicTileTransparency /t REG_DWORD /d 0 /f
    REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v EnableXamlStartMenuTransparency /t REG_DWORD /d 0 /f
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Accessibility" /v AnimationFilter /t REG_DWORD /d 3 /f
    reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f
    REG ADD "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v ForceEffectMode /t REG_DWORD /d 0 /f
    reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012038010000000 /f

    REM 1. Opciones de rendimiento – Ajustar para obtener el mejor rendimiento
    REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f

    REM 2. Explorador y barra de tareas (modo personalizado)
    REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v Animations /t REG_DWORD /d 0 /f
    REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v TaskbarAnimations /t REG_DWORD /d 0 /f
    REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v TooltipAnimation /t REG_DWORD /d 0 /f
    REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v MenuAnimation /t REG_DWORD /d 0 /f
    REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v ComboBoxAnimation /t REG_DWORD /d 0 /f
    REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v ListViewSmoothScrolling /t REG_DWORD /d 0 /f

    REM 3. Ajustes avanzados del Explorador
    REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewAlphaSelect /t REG_DWORD /d 0 /f
    REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v AnimationsShiftKey /t REG_DWORD /d 1 /f

    REM 4. Transparencias de interfaz
    REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 0 /f

    REM 5. Ventanas, menús y arrastre
    REG ADD "HKCU\Control Panel\Desktop" /v MinAnimate /t REG_SZ /d 0 /f
    REG ADD "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f
    REG ADD "HKCU\Control Panel\Desktop" /v DragFullWindows /t REG_SZ /d 0 /f

    REM 6. Composición y desenfoques (DWM / Acrylic)
    REG ADD "HKCU\Software\Microsoft\Windows\DWM" /v Composition /t REG_DWORD /d 0 /f
    REG ADD "HKCU\Software\Microsoft\Windows\DWM" /v Blur /t REG_DWORD /d 0 /f
    REG ADD "HKCU\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 0 /f

    %LOG%    "    Activando miniatura de los iconos"
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v IconsOnly /t REG_DWORD /d 0 /f
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ThumbnailLivePreviewHover /t REG_DWORD /d 1 /f

    %LOG%    "    Para computadores de bajos recursos se desactivan todos los servicios innecesarios para el correcto funcionamiento de windows"
    %start% "resources\Servicios\OP_Servicios.cmd ind"

    %LOG%    "    Para computadores de bajos recursos se desactiva la indexación para evitar mas usos del cpu y ram"
    %SCServicesDown% WSearch

    %LOG%    "    Configurar el Explorador para máxima eficiencia"
    %RegAdd% "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" NoRecentDocsHistory REG_DWORD 1
    %RegAdd% "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" NoThumbnailCache REG_DWORD 1

    %LOG%    "    Desactivar la Compresión NTFS en Discos HDD"
    fsutil behavior set disablecompression 1

    :: usa la memoria de ram para abrir rapidamente las aplicaciones que mas sueles usar 
    %LOG%    "    Desactivar SysMain para evitar la sobre carga en la memoria ram"
    %SCServicesDown% SysMain
)

::========================================================================================================================================

if /i "%DISK%"=="SSD" (
    %LOG%    "    Se ha detectado disco SSD. Desactivando indexación"
    %SCServicesDown% WSearch
)

::========================================================================================================================================

%LOG%    "    estableciendo maximo uso de CPU para defender en 20%"
powershell Set-MpPreference -ScanAvgCPULoad 20
gpupdate /force

::========================================================================================================================================

%LOG%    "    Comprobando si existe el modo Máximo Rendimiento oculto."

powercfg /list | findstr /i "Máximo rendimiento" >nul
if %errorlevel% == 1 (
    %LOG%    "    El plan de Máximo Rendimiento no existe. Activándolo..."
    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
) else (
    %LOG%    "    El plan de Máximo Rendimiento ya está disponible."
)

:: Obtener GUIDs correctamente
echo "     Activando variables GUIDs."
for /f "tokens=2 delims=:" %%a in ('powercfg /list ^| findstr /i "Equilibrado"') do (
    for /f "tokens=1" %%b in ("%%a") do set GUID_BALANCED=%%b
)

for /f "tokens=2 delims=:" %%a in ('powercfg /list ^| findstr /i "Máximo rendimiento"') do (
    for /f "tokens=1" %%b in ("%%a") do set GUID_MAX=%%b
)

:: Mostrar qué GUIDs capturó
%LOG%    "    GUID Equilibrado: %GUID_BALANCED%"
%LOG%    "    GUID Máximo Rendimiento: %GUID_MAX%"

::-------------------------------------------------------------

:: Activar el plan de energía adecuado
%LOG%    "     Activando plan correcto"
if /i "%bateria%"=="no" (
    %LOG%    "    No se detectaron baterías. Activando modo Máximo Rendimiento..."
    powercfg /setactive %GUID_MAX%
) else (
    %LOG%    "    Batería detectada. Activando modo Rendimiento Equilibrado..."
    powercfg /setactive %GUID_BALANCED%
)

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