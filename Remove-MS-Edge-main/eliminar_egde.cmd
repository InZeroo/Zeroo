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

setlocal enabledelayedexpansion

:: Define la ruta del registro donde buscar
set "REGPATH=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore"

:: Define la ruta de SetACL
set "SETACL_PATH=resources\Funciones\bin\setacl.exe"

:: Recorre recursivamente la rama y filtra líneas que contengan "edge" (sin distinguir mayúsculas)
for /f "tokens=*" %%A in ('reg query "%REGPATH%" /s 2^>nul') do (
    echo %%A | findstr /i "edge" >nul
    if !errorlevel! equ 0 (
        %LOG%    "     Bloqueando acceso a: %%A"
        :: Denegamos acceso total al grupo "Users" utilizando setacl.
        %LOG%    "     Bloquear acceso para Everyone"
        "%SETACL_PATH%" -on "%%A" -ot reg -actn ace -ace "n:Everyone;p:deny(f)"

        %LOG%    "     Bloquear acceso para Users (usuarios estándar)"
        "%SETACL_PATH%" -on "%%A" -ot reg -actn ace -ace "n:Users;p:deny(f)"

        %LOG%    "     Bloquear acceso para Guest"
        "%SETACL_PATH%" -on "%%A" -ot reg -actn ace -ace "n:Guest;p:deny(f)"

        %LOG%    "     Bloquear acceso para Administrators (¡Cuidado! Esto puede bloquear a administradores)"
        "%SETACL_PATH%" -on "%%A" -ot reg -actn ace -ace "n:Administrators;p:deny(f)"

        %LOG%    "     Bloquear acceso para Authenticated Users "
        "%SETACL_PATH%" -on "%%A" -ot reg -actn ace -ace "n:Authenticated Users;p:deny(f)"

        %LOG%    "     Bloquear acceso para Interactive (usuarios conectados directamente)"
        "%SETACL_PATH%" -on "%%A" -ot reg -actn ace -ace "n:Interactive;p:deny(f)"

        %LOG%    "     Bloquear acceso para ALL RESTRICTED APPLICATION PACKAGES (cuentas de aplicaciones con restricciones)"
        "%SETACL_PATH%" -on "%%A" -ot reg -actn ace -ace "n:ALL RESTRICTED APPLICATION PACKAGES;p:deny(f)"

        %LOG%    "     Bloquear acceso para ALL APPLICATION PACKAGES (si es pertinente en tu entorno)"
        "%SETACL_PATH%" -on "%%A" -ot reg -actn ace -ace "n:ALL APPLICATION PACKAGES;p:deny(f)"
    )
)

endlocal

::========================================================================================================================================

call "resources\Remove-MS-Edge-main\edge-complete-remover-main\edge_block.bat"
call "resources\Remove-MS-Edge-main\edge-complete-remover-main\edge_uninstaller.bat"
call "resources\Remove-MS-Edge-main\Batch\Both.bat"

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