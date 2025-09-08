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

:: 3.7
:: TAREA: Deshabilitar los consejos "como hacer" que aparecen en Win8+
if /i "%WIN_VER:~0,9%"=="Windows 1" (
    title [Deshabilitar consejos how-to]
    %LOG%     "     Deshabilitando los consejos 'howto' que aparecen..."
    %REG% add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableSoftLanding /t reg_dword /d 1 /f>> "%LOG2%" 2>&1
)

::========================================================================================================================================
::========================================================================================================================================

:: TAREA: Deshabilitar "Mostrar sugerencias ocasionalmente en Inicio"...suspiro
title [Deshabilitar sugerencias]
%LOG%     "     Deshabilitando 'Mostrar sugerencias ocasionalmente en Inicio'..."
%REG% ADD HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CloudContent /v DisableWindowsConsumerFeatures /t REG_DWORD /d 1 /f>> "%LOG2%" 2>&1
%LOG%     "     Hecho."

::========================================================================================================================================
::========================================================================================================================================

:: 7.2
:: TAREA: Precompilar la cache de .NET
title [ngen .NET compilation]
%LOG%     "    Lanzar tarea 'ngen .NET compilation'..."
if %PROCESSOR_ARCHITECTURE%==x86 (
    pushd %WINDIR%\Microsoft.NET\Framework\v4*
    (ngen executeQueuedItems >> "%LOG2%" 2>&1)
    popd
    ) else (
    pushd %WINDIR%\Microsoft.NET\Framework64\v4*
    (ngen executeQueuedItems >> "%LOG2%" 2>&1)
    popd
)
%LOG%     "     Hecho."

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