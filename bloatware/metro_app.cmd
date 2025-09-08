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

%LOG%    "     Configurando el registro para prevenir la reinstalación de bloatware..."
call :RegAddEntry "HKLM\Software\Policies\Microsoft\Windows\CloudContent" "(Default)" REG_SZ ""
call :RegAddEntry "HKLM\Software\Policies\Microsoft\Windows\CloudContent" "DisableWindowsConsumerFeatures" REG_DWORD 1

::========================================================================================================================================

:: 3.5
:: TAREA: Eliminar aplicaciones Metro predeterminadas (Windows 8 y superiores)
title[Eliminar aplicaciones metro predeterminadas]

:: Este comando reinstalara TODAS las aplicaciones predeterminadas de Windows 10:
:: Get-AppxPackage -AllUsers| Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
:: Comprobaciones de version

%LOG%    "     Metro ha iniciado."
if %WIN_VER_NUM% geq 6.2 set TARGET_METRO=yes

if /i %TARGET_METRO%==yes (

    %LOG%    "     Windows 8 o superior detectado, eliminando aplicaciones Metro OEM..."

    :: Forzar el permiso para iniciar el servicio AppXSVC en Modo Seguro. AppXSVC es el equivalente del Instalador de Windows para "aplicaciones" (vs. programas)
    :: Habilitar el inicio de AppXSVC en Modo Seguro

    net start AppXSVC >nul 2>&1

    :: Habilitar scripts en PowerShell
    powershell "Set-ExecutionPolicy Unrestricted -force 2>&1 | Out-Null"


    :: Version de Windows 8/8.1
    if /i "%RUN_8%"=="yes" (

        %LOG%    "     Ejecutando "%~nx0" para Windows 8 y 8.1"
        :: En Windows 8/8.1 podemos eliminar TODAS las aplicaciones AppX/Metro/"Modern App" porque a diferencia de Windows 10, las aplicaciones "core" (calculadora, paint, etc.) no estan en formato "moderno"
        start /wait powershell "Get-AppXProvisionedPackage -online | Remove-AppxProvisionedPackage -online 2>&1 | Out-Null"
        start /wait powershell "Get-AppxPackage -AllUsers | Remove-AppxPackage 2>&1 | Out-Null"

    )


    :: Version de Windows 10
    if /i "%RUN_10_OR_11%"=="yes" (

        %LOG%    "     Ejecutando "%~nx0" para Windows 10 y 11"
        %LOG%    "     Llamar a los scripts externos de PowerShell para realizar la eliminacion de aplicaciones Modernas OEM de Microsoft y de terceros"
        if /i "%RUN_10%"=="yes" powershell -ExecutionPolicy Bypass -Command "Get-AppxPackage -Name 'Microsoft.WindowsAppRuntime.CBS' | Remove-AppxPackage"
        powershell -ExecutionPolicy Bypass -Command "Unblock-File -Path '.\resources\bloatware\metro_3rd_party_modern_apps_to_target_by_name.ps1'"
        powershell -ExecutionPolicy Bypass -Command "Unblock-File -Path '.\resources\bloatware\metro_Microsoft_modern_apps_to_target_by_name.ps1'"
        start /wait powershell -executionpolicy bypass -file ".\resources\bloatware\metro_3rd_party_modern_apps_to_target_by_name.ps1"
        start /wait powershell -executionpolicy bypass -file ".\resources\bloatware\metro_Microsoft_modern_apps_to_target_by_name.ps1"

   )
) 
%LOG%    "     Metro ha finalizado."

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

::========================================================================================================================================
::========================================================================================================================================

:DeleteTask
:: %~1 contiene el nombre de la tarea
set "TaskName=%~1"
schtasks /query /TN "%TaskName%" >nul 2>&1
if %errorlevel%==0 (
    schtasks /delete /F /TN "%TaskName%" >> "%LOG2%" 2>&1
    %LOG%    "     Tarea %TaskName% eliminada."
) else (
    %LOG%    "     La tarea %TaskName% no existe."
)
goto :eof

::--------------------------------

:DesactivarTask
:: %~1 contiene el nombre de la tarea
set "TaskName=%~1"
schtasks /query /TN "%TaskName%" >nul 2>&1
if %errorlevel%==0 (
    schtasks /change /TN "%TaskName%" /DISABLE >> "%LOG2%" 2>&1
    %LOG%    "     Tarea %TaskName% deshabilitada."
) else (
    %LOG%    "     La tarea %TaskName% no existe."
)
goto :eof

::========================================================================================================================================


:: Parámetros:
::  %~1 = Ruta de la clave de registro
::  %~2 = Nombre del valor (si es "(Default)", se usa /ve)
::  %~3 = Tipo de dato (por ejemplo, REG_DWORD o REG_SZ)
::  %~4 = Datos a asignar (si es "(Default)", se omite)

::--------------------------------

:RegAddEntry

call :RegQuery "%~1"
if errorlevel 1 (
    %LOG% "La clave %~1 no existe. Se creará."
)

:: Si el nombre es "(Default)", usar /ve para el valor predeterminado
if /I "%~2"=="(Default)" (
    %REG% add "%~1" /ve /t %~3 /d "" /f >> "%LOG2%" 2>&1
    if errorlevel 1 (
        %LOG%    "     Falló al establecer el valor (Default) en %~1."
    ) else (
        %LOG%    "     Valor (Default) establecido a %~4 en %~1."
    )
    goto :eof
)

:: Para cualquier otro valor, usar el nombre tal cual
%REG% add "%~1" /v "%~2" /t %~3 /d %~4 /f >> "%LOG2%" 2>&1
if errorlevel 1 (
    %LOG%    "     Falló al establecer el valor %~2 en %~1."
) else (
    %LOG%    "     Valor %~2 establecido a %~4 en %~1."
)
goto :eof

::--------------------------------

:RegDelEntry

call :RegQuery "%~1"
if %errorlevel% NEQ 0 (
    %LOG%    "La clave %~1 no existe, se omite eliminar."
    goto :eof
)

:: Parámetro:
::  %~1 = Clave o ruta completa que se desea eliminar
%REG% delete "%~1" /f >> "%LOG2%" 2>&1
if %errorlevel%==0 (
    %LOG%    "     Clave %~1 eliminada."
) else (
    %LOG%    "     Falló al eliminar la clave %~1."
)
goto :eof


::--------------------------------

:RegQuery
:: Verificar la existencia de la clave de registro
%REG% query "%~1" >nul 2>&1
::>> "%LOG2%" 2>&1 ::verifica el estado de la clave del registro con mas detalle en el log 
goto :eof

::========================================================================================================================================

:SCServicesDown

set "VARSERV=%~1"
if exist "%TEMP%\services.log" del /f /q "%TEMP%\services.log"

:: Existe el servicio?
call :SCQuery "%VARSERV%"
if %errorlevel% NEQ 0 (
    %LOG%    "    El servicio %VARSERV% no existe, se omite Desactivar."
    goto :eof
)

:: Estado del servicio
call :SCQuery2 "%VARSERV%"

if /i "%DISABLED%"=="no" (

    :: detener servicio
    call :SCQuery3 "%VARSERV%"

    sc config "%VARSERV%" start= disabled > "%TEMP%\services.log" 2>&1
    type "%TEMP%\services.log" >> "%LOG2%"

    if /i "%SYSTEM_LANGUAGE%"=="es" set "ACCESO=Acceso denegado"
    if /i "%SYSTEM_LANGUAGE%"=="en" set "ACCESO=Access is denied"

)

findstr /i "%ACCESO%" "%TEMP%\services.log" >nul
if not errorlevel 1 (
    %LOG%    "    Se detecto "%ACCESO%""
    call :SCError1
)

goto :eof

::--------------------------------

:SCServicesDel

set "VARSERV=%~1"
:: Existe el servicio?
call :SCQuery "%~1"
if %errorlevel% NEQ 0 (
    %LOG%    "    El servicio "%VARSERV%" no existe, se omite eliminar."
    goto :eof
)

:: detener servicio
call :SCQuery3 "%VARSERV%"

sc delete "%VARSERV%" >> "%LOG2%" 2>&1

goto :eof

::--------------------------------

:SCQuery
:: Verificar la existencia de la clave de registro
sc query "%~1"
goto :eof

::--------------------------------

:SCQuery2

set "DISABLED=no"

if /i "%SYSTEM_LANGUAGE%"=="es" set "TIPO=TIPO_INICIO"
if /i "%SYSTEM_LANGUAGE%"=="en" set "TIPO=START_TYPE"

for /f "tokens=4 delims= " %%A in ('sc qc "%~1" ^| findstr /i "%TIPO%"') do (
    if "%%A"=="DISABLED" (
        %LOG%    "    El servicio \"%~1\" esta DESHABILITADO. saltando servicio"
        set "DISABLED=yes"
        goto :eof
    ) else (
        %LOG%    "    El servicio \"%~1\" NO está deshabilitado (TIPO_INICIO = %%A) continuando con el proceso."
        goto :eof
    )
)
goto :eof

::--------------------------------

:SCQuery3

if /i "%SYSTEM_LANGUAGE%"=="es" set "estado=ESTADO"
if /i "%SYSTEM_LANGUAGE%"=="en" set "estado=STATE"

for /f "tokens=4" %%a in ('sc query "%~1" ^| findstr "%estado%"') do (
    if /i "%%a"=="STOPPED" (
        %LOG%    "    Ya esta detenido"
        goto :eof
    )
    if /i "%%a"=="RUNNING" (
        %LOG%    "    Servicio \"%~1\" está en ejecución. Deteniendo..."
        sc stop "%~1" >> "%LOG2%" 2>&1

        if %errorlevel% NEQ 0 (
            %LOG%    "    [ERROR] No se pudo detener el servicio \"%~1\". Código de error: %errorlevel%"
            goto :eof
        ) else (
            %LOG%    "    Servicio \"%~1\" detenido correctamente."
            goto :eof
        )
    ) else (
        %LOG%    "    Servicio \"%~1\" esta en %%a."
        goto :eof
    )
)
goto :eof

::--------------------------------

:SCError1
%LOG%    "    Tratando de deshabilitar %VARSERV% desde regedit"

set "REGCLAVE=HKLM\SYSTEM\CurrentControlSet\Services\%VARSERV%"

call :RegQuery "%REGCLAVE%"
if %errorlevel%==0 (
    %LOG%    "    Eliminando la seguridad de regedit"
    resources\Telemetrias\disable_windows_telemetry\setacl.exe -on "%REGCLAVE%" -ot reg -actn setowner -ownr n:administrators >> "%LOG2%" 2>&1
    resources\Telemetrias\disable_windows_telemetry\setacl.exe -on "%REGCLAVE%" -ot reg -actn ace -ace "n:administrators;p:full" >> "%LOG2%" 2>&1
    call :RegAddEntry "%REGCLAVE%" LaunchProtected REG_DWORD 0
    call :RegAddEntry "%REGCLAVE%" Start REG_DWORD 4
    goto :eof
) else (
    %LOG%    "    La clave "%REGCLAVE%" Update no existe. [ERROR] no se puede deshabilitar el servicio %VARSERV%"
    goto :eof
)
goto :eof
