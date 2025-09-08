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

%LOG% "    Iniciando script de Memoria Virtual..."

:: Determinar el sistema operativo
if /i "%RUN_7%"=="yes" (
    set "OS=Windows7"
) else if /i "%RUN_8%"=="yes" (
    set "OS=Windows8"
) else if /i "%RUN_10%"=="yes" (
    set "OS=Windows10"
) else if /i "%RUN_11%"=="yes" (
    set "OS=Windows11"
) else (
    set "OS=Desconocido"
)

:: Determinar si se detecto SSD (se asume que la variable %SKIP_DEFRAG% se ha establecido previamente)
if /i "%SKIP_DEFRAG%"=="yes_ssd" (
    set "SSD=Yes"
) else (
    set "SSD=No"
)

echo.
echo ================================================
%LOG%    "    Configurando Memoria Virtual para %OS%"
%LOG%    "    RAM instalada: %RAM% GB."
%LOG%    "    SSD detectado: %SSD%"
echo ================================================
echo.

:: Si se tienen 32GB o mas, se deja la administracion automatica.
if %RAM% GEQ 32 (
    %LOG%    "    [Info] Con %RAM% GB, la capacidad es alta. Se deja el manejo AUTOMÁTICO del pagefile."
    wmic computersystem where "name='%computername%'" set AutomaticManagedPagefile=True
    goto :fin
)

:: Seleccionar el multiplicador en funcion de la cantidad de RAM y del entorno
:: Caso: 4GB --> siempre x4
if %RAM%==4 (
    set multiplier=4
    %LOG%    "    [Info] 4 GB detectados. Usando multiplicador x4."
)

:: Caso: entre 6 y 13 GB
if %RAM% GEQ 6 if %RAM% LEQ 13 (
    :: Si el sistema es Windows7 u Windows8 y hay SSD, usar x1. En caso contrario, usar x2.
    if /i "%SSD%"=="Yes" if /i "%OS%"=="Windows7" (
        set multiplier=1
        %LOG%    "    [Info] %RAM% GB en Windows7 con SSD. Usando multiplicador x1."
    ) else if /i "%SSD%"=="Yes" if /i "%OS%"=="Windows8" (
        set multiplier=1
        %LOG%    "    [Info] %RAM% GB en Windows8 con SSD. Usando multiplicador x1."
    ) else (
        set multiplier=2
        %LOG%    "    [Info] %RAM% GB detectados (sin SSD en Win7/8 o en otro OS). Usando multiplicador x2."
    )
)

:: Caso: 14GB hasta 31GB
if %RAM% GEQ 14 if %RAM% LSS 32 (
    if /i "%SSD%"=="Yes" (
        set multiplier=1
        %LOG%    "    [Info] %RAM% GB detectados con SSD. Usando multiplicador x1."
    ) else (
        set multiplier=2
        %LOG%    "    [Info] %RAM% GB detectados sin SSD. Usando multiplicador x2."
    )
)

%LOG%    "    Calcular el tamaño inicial y maximo en MB"
set /a InitialSize=%RAM% * 1024 * multiplier
set /a MaximumSize=%RAM% * 1024 * multiplier

echo.
%LOG%    "    Valores calculados para el pagefile (C:\pagefile.sys):"
%LOG%    "    Tamaño Inicial : %InitialSize% MB"
%LOG%    "    Tamaño Maximo  : %MaximumSize% MB"
echo.

%LOG%    "    Desactivando la administracion automatica del pagefile..."
wmic computersystem where "name='%computername%'" set AutomaticManagedPagefile=False

%LOG%    "    Aplicando configuracion manual en C:\pagefile.sys..."
wmic pagefileset where "name='C:\\pagefile.sys'" set InitialSize=%InitialSize%,MaximumSize=%MaximumSize%

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