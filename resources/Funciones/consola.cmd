:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::IntecZeroo::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::1.1 cambio de la variable win 7 y 8
::========================================================================================================================================
::========================================================================================================================================

:: Comprobar ejecución independiente
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

if /i "%LOGFILE%"=="" (

    set "STANDALONE=yes"
    @echo off
    chcp 65001

    :: Asingnando ruta
    if exist "%~dp0resources" (
        pushd "%~dp0\"
        set "RUTA=%~dp0\"   
    ) else (
        if exist "%~dp0..\..\resources" (
            pushd "%~dp0..\.."
            for %%I in ("%~dp0..\..") do set "RUTA=%%~fI"
        ) else (
            if exist "%~dp0..\..\..\resources" (
                pushd "%~dp0..\..\.."
                for %%I in ("%~dp0..\..\..") do set "RUTA=%%~fI"
            )
        )
    )

    :: Cargar archivos de configuración y entorno
    call "%RUTA%resources\Funciones\Version.bat"
    call "%RUTA%resources\Funciones\Logo.bat"
)

title "%~nx0"
%LOG% "    Iniciando script "%~nx0"."

::========================================================================================================================================
::========================================================================================================================================

start cmd.exe 