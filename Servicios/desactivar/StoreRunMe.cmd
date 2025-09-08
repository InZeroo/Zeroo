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

::=======================================================================================================================================
::=======================================================================================================================================

::Definir la ruta de la carpeta Packages en el AppData local
set "packagesDir=%LOCALAPPDATA%\Packages"

:: Establecer la variable para la carpeta WindowsApps
set "DirWinApp=%ProgramFiles%\WindowsApps"

:: Actualizar apps si = yes
set "UPDATE_APP=yes"

::=======================================================================================================================================

:: Si el sistema no es Windows 10 ni 11, finalizar ejecución
%LOG%    "    Detectar si el sistema es diferente a Windows 10 o 11"

if /i not "%RUN_10_OR_11%"=="yes" (
    %LOGO3%
    %LOG%    "    Este script solo funciona en Windows 10 y 11.
    detectado: %WIN_VER%"
    goto fin
)

%LOG%    "     Sistema compatible detectado: %WIN_VER%"

::=======================================================================================================================================

%LOG%    "    Estableciendo permisos para %DirWinApp% 4.1 ."
::Permisos desde regedit
regedit.exe /S Files\regedit1.reg >> "%LOG2%" 2>&1
regedit.exe /S Files\regedit2.reg >> "%LOG2%" 2>&1

:: permisos de windows apps
if /i "%SYSTEM_LANGUAGE%"=="en" takeown /F "%DirWinApp%" /R /D Y >> "%LOG2%" 2>&1
if /i "%SYSTEM_LANGUAGE%"=="es" takeown /F "%DirWinApp%" /R /D S >> "%LOG2%" 2>&1
icacls "%DirWinApp%" /reset /T /C >> "%LOG2%" 2>&1
icacls "%DirWinApp%" /grant "SYSTEM":(OI)(CI)F
icacls "%DirWinApp%" /grant "Users":(OI)(CI)RX  
icacls "%DirWinApp%" /grant "Authenticated Users":(OI)(CI)RX  
icacls "%DirWinApp%" /grant "%USERNAME%":(OI)(CI)RX 
icacls "%DirWinApp%" /grant "Administrador":(OI)(CI)RX  
icacls "%DirWinApp%" /grant "Administradores":(OI)(CI)F
icacls "%DirWinApp%" /grant "ALL APPLICATION PACKAGES":(OI)(CI)RX
%LOG%    "     Hecho."

::----------------------------------------------

%LOG%    "    Eliminar todas las apps de %DirWinApp% 4.2 "
:: Obtener tamaño inicial de la carpeta
for /f %%A in ('powershell -Command "(Get-Item '%DirWinApp%').length"') do set "InitialSize=%%A"

:: Ejecutar el primer comando de eliminación
powershell -NoProfile -ExecutionPolicy Bypass -Command "$WinApps='%DirWinApp%'; $Exclude=@('Microsoft.WindowsStore','Microsoft.DesktopAppInstaller','Microsoft.WindowsShellExperienceHost'); Get-AppxPackage -AllUsers | Where-Object { $Exclude -notcontains $_.Name -and $_.InstallLocation -like \"$WinApps*\" } | ForEach-Object { try { Remove-AppxPackage -Package $_.PackageFullName -ErrorAction Stop; Write-Host '✅ Desinstalada:' $_.Name } catch { Write-Host '❌ Error al desinstalar:' $_.Name ' - ' $_.Exception.Message } }" >> "%LOG2%" 2>&1

:: Obtener tamaño después del proceso
for /f %%B in ('powershell -Command "(Get-Item '%DirWinApp%').length"') do set "FinalSize=%%B"

:: Si el tamaño sigue igual, ejecutar el otro comando
if "%InitialSize%"=="%FinalSize%" (
    powershell -Command "Get-AppxPackage -AllUsers | ForEach-Object {try {Remove-AppxPackage -Package $_.PackageFullName -ErrorAction Stop; Write-Host \"✅ Desinstalada: $_.Name\"} catch {Write-Host \"❌ Error al desinstalar: $_.Name - $_.Exception.Message\"}}" >> "%LOG2%" 2>&1
)
%LOG%    "    Hecho"

::----------------------------------------------

%LOG%    "    Buscando carpetas en %DirWinApp% para eliminar..."
for /d %%F in ("%DirWinApp%\*") do (
    rd /s /q "%%F"
    if exist "%%F" (
        echo  No se pudo eliminar: %%F >> "%LOG2%"
    ) else (
        echo  Eliminada: %%F >> "%LOG2%"
    )
)

:: Restaurar permisos predeterminados
icacls "%DirWinApp%" /reset /T /C /Q >> "%LOG2%" 2>&1

:: Conceder permisos esenciales para el sistema
icacls "%DirWinApp%" /grant "TrustedInstaller":F

::icacls "%DirWinApp%" /grant "%USER_SID%":RX
::icacls "%DirWinApp%" /grant SYSTEM:F
::icacls "%DirWinApp%" /grant "Administradores":(OI)(CI)RX
::icacls "%DirWinApp%" /grant "SERVICIO LOCAL":RX
::icacls "%DirWinApp%" /grant "Servicio de red":RX
::icacls "%DirWinApp%" /grant RESTRINGIDO:RX
::icacls "%DirWinApp%" /grant Usuarios:RX

%LOG% "    Permisos restaurados correctamente."


:: Recorre cada carpeta dentro de Packages
for /d %%A in ("%packagesDir%\*") do (
    if exist "%%A\LocalCache" (
        %LOG%    "    Limpiando cache en: %%A\LocalCache..."
        %LOG%    "    Elimina la carpeta LocalCache con todo su contenido"
        rd "%%A\LocalCache" /s /q
        %LOG%    "    Vuelve a crear la carpeta vacía"
        mkdir "%%A\LocalCache"
    )
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
