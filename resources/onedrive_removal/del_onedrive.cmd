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

:: Onedriver
:: 3.6
:: TAREA: Eliminar la integracion forzada de OneDrive

:: Esta variable se usa mas adelante para asegurarse de que no deshabilitamos la sincronizacion de archivos si OneDrive no fue eliminado
set ONEDRIVE_REMOVED=no

:: 1. ¿Estamos en Windows 10? Si no, omitir la eliminacion
if /i not "%WIN_VER:~0,9%"=="Windows 1" goto :skip_onedrive_removal

::========================================================================================================================================

:: 2. ¿Existe la carpeta en la ubicacion predeterminada? Si no, omitir la eliminacion
if not exist "%USERPROFILE%\OneDrive" (
    %LOG%    "!  La carpeta de OneDrive no esta en la ubicacion predeterminada. Omitiendo la eliminacion."
    goto :skip_onedrive_removal
)

::========================================================================================================================================

:: 3. ¿Tiene la carpeta predeterminada algun archivo? Si es asi, omitir la eliminacion
%LOG%    "   Comprobando si OneDrive esta en uso, por favor espere..."
::    Primero, eliminar desktop.ini para que no active incorrectamente la comprobacion de 'onedrive esta en uso'
if exist "%USERPROFILE%\OneDrive\desktop.ini" %SystemRoot%\System32\attrib.exe -s -h "%USERPROFILE%\OneDrive\desktop.ini" >nul 2>&1
if exist "%USERPROFILE%\OneDrive\desktop.ini" del /f /q "%USERPROFILE%\OneDrive\desktop.ini" >nul 2>&1
resources\Computador\onedrive_removal\diruse.exe /q:0.5 "%USERPROFILE%\OneDrive" >> "%LOG2%" 2>&1
if /i not %ERRORLEVEL%==0 (
    %LOG%     "!  Parece que OneDrive esta en uso (existen archivos en la carpeta de OneDrive). Omitiendo la eliminacion."
    goto :skip_onedrive_removal
)

::========================================================================================================================================

:: Si nada de lo anterior se activo, es seguro eliminar OneDrive
::1.1 se modifico el script para hacerlo mas optimo
title Eliminación de OneDrive

::-------------------------------------------------------
:: Desinstalación de OneDrive: Intento con winget primero
::-------------------------------------------------------
%LOG%    "   [*] Iniciando desinstalación de OneDrive usando winget..."
winget uninstall Microsoft.OneDrive >nul 2>&1
%LOG%    "   [*] Winget desinstalación completada."

::-------------------------------------------------------
:: Detención del proceso OneDrive
::-------------------------------------------------------
%LOG%    "   [*] Cerrando proceso de OneDrive..."
taskkill /f /im OneDrive.exe >nul 2>&1
timeout /t 5 >nul

:: Verificar si OneDrive sigue activo y forzar shutdown
tasklist | findstr /i OneDrive.exe >nul
if %ERRORLEVEL%==0 (
    %LOG%    "   [*] OneDrive sigue activo. Enviando shutdown..."
    "%LocalAppData%\Microsoft\OneDrive\OneDrive.exe" /shutdown >nul 2>&1
    timeout /t 3 >nul
)

::-------------------------------------------------------
:: Desinstalación de OneDrive usando OneDriveSetup.exe
::-------------------------------------------------------
set "Setup32=%SYSTEMROOT%\System32\OneDriveSetup.exe"
set "Setup64=%SYSTEMROOT%\SysWOW64\OneDriveSetup.exe"

%LOG%    "   [*] Ejecutando desinstalación con OneDriveSetup..."
if exist %Setup64% (
    %Setup64% /uninstall >nul 2>&1
) else if exist %Setup32% (
    %Setup32% /uninstall >nul 2>&1
)

timeout /t 5 >nul

::-------------------------------------------------------
:: Eliminación de Carpetas y Archivos Residuales
::-------------------------------------------------------
%LOG%    "   [*] Tomando propiedad y eliminando carpetas de OneDrive..."

takeown /f "%LocalAppData%\Microsoft\OneDrive" /r /d y >nul 2>&1
icacls "%LocalAppData%\Microsoft\OneDrive" /grant administrators:F /t >nul 2>&1

rd /s /q "%LocalAppData%\Microsoft\OneDrive" >nul 2>&1
rd /s /q "%ProgramData%\Microsoft OneDrive" >nul 2>&1
rd /s /q "%SystemDrive%\OneDriveTemp" >nul 2>&1
if exist "%USERPROFILE%\OneDrive" (
    dir /b /s "%USERPROFILE%\OneDrive" >nul 2>&1
    if errorlevel 1 rd /s /q "%USERPROFILE%\OneDrive"
)

:: Si la eliminación falla, usar movefile de Sysinternals (opcional)
if %ERRORLEVEL% neq 0 (
    %LOG%    "   [*] Hubo problemas al eliminar algunas carpetas. Intentando con movefile..."
    resources\movefile\movefile.exe "%LocalAppData%\Microsoft\OneDrive" "" /accepteula >nul 2>&1
    resources\movefile\movefile.exe "%ProgramData%\Microsoft OneDrive" "" /accepteula >nul 2>&1
    resources\movefile\movefile.exe "%SystemDrive%\OneDriveTemp" "" /accepteula >nul 2>&1
)

::-------------------------------------------------------
:: Configuración del Registro para Deshabilitar OneDrive
::-------------------------------------------------------
%LOG%    "   [*] Configurando claves de registro para deshabilitar OneDrive..."
%REG% add "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSyncNGSC" /t REG_DWORD /d 1 /f
%REG% add "HKLM\Software\Policies\Microsoft\Windows\Skydrive" /v "DisableFileSync" /t REG_DWORD /d 1 /f >nul 2>&1
%REG% add "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 0 /f >nul 2>&1
%REG% add "HKCR\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 0 /f >nul 2>&1

%LOG%    "   Eliminar ejecución automática para nuevos usuarios"
%REG% load "HKU\Default" "C:\Users\Default\NTUSER.DAT"
%REG% delete "HKU\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDriveSetup" /f
%REG% unload "HKU\Default"

%LOG%    "   Eliminar acceso directo del menú inicio"
del /f /q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"

%LOG%    "   Eliminar tareas programadas relacionadas con OneDrive"
schtasks /Change /TN "\Microsoft\Windows\OneDrive\OneDrive Standalone Update Task-S-1-5-21" /Disable >nul 2>&1
schtasks /Delete /TN "\Microsoft\Windows\OneDrive\OneDrive Standalone Update Task-S-1-5-21" /F >nul 2>&1

%LOG%    "   [*] OneDrive ha sido eliminado y deshabilitado del sistema."

%REG% delete "HKEY_CURRENT_USER\Software\Microsoft\OneDrive" /f
%REG% delete "HKEY_USERS\.DEFAULT\Software\Microsoft\OneDrive" /f


set ONEDRIVE_REMOVED=yes

:skip_onedrive_removal

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