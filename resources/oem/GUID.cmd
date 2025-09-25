:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::IntecZeroo:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::https://www.youtube.com/channel/UCkIm0Fu5DdJ-va5Gp9n3Taw
::2.0 correccion del codigo para detectar apps
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

::Volcado de programas sin GUID
title [Volcado de programas sin GUID]

%LOG%    "     Volcando lista de programas sin GUID a \"%RAW_LOGS%\"..."

if not exist "%RAW_LOGS%" mkdir "%RAW_LOGS%"
powershell.exe -NoProfile -Command "$threshold = ('{C9615618-5AE1-27D3-B74C-15D0AC4138D7}'.Length) - 1; Get-ChildItem 'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall' | Where-Object { $_.PSChildName.Length -le $threshold } | ForEach-Object { Get-ItemProperty $_.PSPath } | Format-Table -Property PSChildName, DisplayName, DisplayVersion -AutoSize | Out-String | Out-File -FilePath '%RAW_LOGS%\sin_guid.txt'"

%LOG%    "     Volcado de programas sin GUID ha terminado."

::========================================================================================================================================

:: 3.1
:: Hacer el volcado de GUID en el que se basan algunas partes a continuacion. Tenemos que ejecutar el archivo a traves del comando 'type' para convertir la salida de UCS-2 Little Endian a UTF-8/ANSI para que los bucles for a continuacion puedan leerlo
if %STANDALONE%==yes (
    <NUL %WMIC% product get identifyingnumber,name,version /all > "%TEMP%\wmic_dump_temp.txt" 2>NUL
    type "%TEMP%\wmic_dump_temp.txt" > "%RAW_LOGS%\GUID_dump_%COMPUTERNAME%_%CUR_DATE%.txt" 2>NUL
    del /f /q "%TEMP%\wmic_dump_temp.txt" 2>nul
)

::========================================================================================================================================

setlocal EnableDelayedExpansion

:: Define las rutas de los archivos (ajusta estas rutas según tu entorno)
set "FILE_INSTALADOS=%RAW_LOGS%\sin_guid.txt"
set "FILE_ELIMINAR=resources\oem\sin_guid_del.txt"

:: Define la ubicación del archivo temporal en la carpeta %temp%
set "TEMP_FILE=%temp%\temp.txt"

:: Filtra sin_guid.txt eliminando las líneas que aparecen en sin_guid_del.txt y guarda el resultado en TEMP_FILE
findstr /I /X /V /G:"%FILE_ELIMINAR%" "%FILE_INSTALADOS%" > "%TEMP_FILE%"

%LOG% "Programas a desinstalar listados en %TEMP_FILE%"
type "%TEMP_FILE%"
%LOG% ""

:: Itera por cada línea en TEMP_FILE y desinstala el programa usando WMIC
for /f "usebackq delims=" %%A in ("%TEMP_FILE%") do (
    %LOG% "Desinstalando: %%A"
    wmic product where "Name like '%%%A%%'" call uninstall /nointeractive
    :: Espera 2 segundos para dar tiempo a que finalice la desinstalación antes de pasar al siguiente.
    timeout /t 2 >nul
)

:: Elimina el archivo temporal al finalizar
del "%TEMP_FILE%" /F /Q

%LOG% ""
%LOG% "Proceso de desinstalación completado. Archivo temporal eliminado."

endlocal

if %STANDALONE%==yes pause
::========================================================================================================================================

:: 1.7
:: TAREA: Hacer un volcado de GUID antes de iniciar todo
title [Volcado de GUID]

%LOG%    "     Volcando la lista de GUID a "%RAW_LOGS%"..."

if not exist "%RAW_LOGS%" mkdir "%RAW_LOGS%"
echo iniciando GUID >> "%RAW_LOGS%\GUID_dump_%COMPUTERNAME%_%CUR_DATE2%.txt"

<NUL %WMIC% product get identifyingnumber,name,version /all > "%TEMP%\wmic_dump_temp.txt" 2>NUL
type "%TEMP%\wmic_dump_temp.txt" > "%RAW_LOGS%\GUID_dump_%COMPUTERNAME%_%CUR_DATE2%.txt" 2>NUL
del /f /q "%TEMP%\wmic_dump_temp.txt" 2>nul

%LOG%    "     Volcando la lista de GUID ha terminado."

::========================================================================================================================================

:: 1.8
:: TAREA: Hacer un volcado de aplicaciones Metro antes de iniciar todo (solo en Win8+; solo fuera del Modo Seguro [no funciona en Modo Seguro])

title [Volcado de aplicaciones Metro]

if /i %WIN_VER_NUM% geq 6.2 (
    %LOG%    "     Volcando la lista de aplicaciones Metro a "%RAW_LOGS%"..."
    powershell "Get-AppxPackage -AllUsers | Select Name" > "%RAW_LOGS%\Metro_app_dump_%COMPUTERNAME%_%CUR_DATE2%.txt" 2>NUL
)

%LOG%    "     Volcando la lista de aplicaciones Metro ha terminado."

::========================================================================================================================================

:: 3.4
:: Calcular cuantos GUID estamos buscando
set GUID_TOTAL=0
for /f %%i in ('%FINDSTR% /R /N "^{" resources\oem\programs_to_target_by_GUID.txt ^| %FIND% /C ":"') do set GUID_TOTAL=%%i
%LOG%    "     Comparando la lista de GUID del sistema con %GUID_TOTAL% entradas en la lista negra, por favor espere..."
:: Esto es necesario para que podamos verificar el errorlevel dentro del bucle FOR
SETLOCAL ENABLEDELAYEDEXPANSION
:: Recorrer el volcado de GUID local y ver si algun GUID coincide con la lista objetivo
for /f "tokens=1" %%a in (%RAW_LOGS%\GUID_dump_%COMPUTERNAME%_%CUR_DATE2%.txt) do (
    for /f "tokens=1" %%j in (resources\oem\programs_to_target_by_GUID.txt) do (
        if /i %%j==%%a (

            :: Registrar el hallazgo y realizar la eliminacion
            %LOG%    "    %%a COINCIDENCIA de la lista objetivo, desinstalando..."
            start /wait msiexec /qn /norestart /x %%a>> "%LOG2%" 2>nul

            :: Restablecer UpdateExeVolatile. Supongo que podriamos verificar si esta activado, pero realmente no tiene sentido ya que de todos modos lo vamos a restablecer
            %REG% add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Updates" /v UpdateExeVolatile /d 0 /f >nul 2>&1

            :: Comprobar si el desinstalador agrego entradas a PendingFileRenameOperations. Si lo hizo, exportar el contenido, eliminar el valor de la clave y luego continuar
            %REG% query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v PendingFileRenameOperations >nul 2>&1
            if !errorlevel!==0 (
                echo GUID ofensivo: %%i >> "%RAW_LOGS%\PendingFileRenameOperations_%COMPUTERNAME%_%CUR_DATE2%.txt"
                %REG% query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v PendingFileRenameOperations>> "%RAW_LOGS%\PendingFileRenameOperations_%COMPUTERNAME%_%CUR_DATE2%.txt"
                %REG% delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v PendingFileRenameOperations /f >nul 2>&1

                %LOG% "    %CUR_DATE2% !TIME! ^^!  Entradas de PendingFileRenameOperations exportadas a "%RAW_LOGS%\PendingFileRenameOperations_%COMPUTERNAME%_%CUR_DATE2%.txt" y eliminadas."
                echo %CUR_DATE2% !TIME! ^^!  Entradas de PendingFileRenameOperations exportadas a "%RAW_LOGS%\PendingFileRenameOperations_%COMPUTERNAME%_%CUR_DATE2%.txt" y eliminadas. >> "%LOG2%"
                echo ------------------------------------------------------------------->> "%RAW_LOGS%\PendingFileRenameOperations_%COMPUTERNAME%_%CUR_DATE2%.txt"
            )
        )
    )
)
ENDLOCAL DISABLEDELAYEDEXPANSION
%LOG%    "     Fase 1 terminado."

::========================================================================================================================================

:: TAREA: Eliminar programas basura, fase 2: barras de herramientas y BHOs no deseados por GUID
title [Eliminar barras de herramientas por GUID]
%LOG%    "     Intentando eliminar junkware: Fase 2 (barras de herramientas por GUID especifico)..."
:: Calcular cuantos GUID estamos buscando
    set GUID_TOTAL=0
    for /f %%i in ('%FINDSTR% /R /N "^{" resources\oem\toolbars_BHOs_to_target_by_GUID.txt ^| FIND /C ":"') do set GUID_TOTAL=%%i
    %LOG%    "     Comparando la lista de GUID del sistema con %GUID_TOTAL% entradas en la lista negra, por favor espere..."
:: Esto es necesario para que podamos verificar el errorlevel dentro del bucle FOR
SETLOCAL ENABLEDELAYEDEXPANSION
:: Recorrer el volcado de GUID local y ver si algun GUID coincide con la lista objetivo
for /f "tokens=1" %%a in (%RAW_LOGS%\GUID_dump_%COMPUTERNAME%_%CUR_DATE2%.txt) do (
    for /f "tokens=1" %%j in (resources\oem\toolbars_BHOs_to_target_by_GUID.txt) do (
        if /i %%j==%%a (

            :: Registrar el hallazgo y realizar la eliminacion
            %LOG%    "    %%a COINCIDENCIA de la lista objetivo, desinstalando..."
            start /wait msiexec /qn /norestart /x %%a>> "%LOGPATH%\%LOGFILE%" 2>nul

            :: Restablecer UpdateExeVolatile. Supongo que podriamos verificar si esta activado, pero realmente no tiene sentido ya que de todos modos lo vamos a restablecer
            %REG% add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Updates" /v UpdateExeVolatile /d 0 /f >nul 2>&1

            :: Comprobar si el desinstalador agrego entradas a PendingFileRenameOperations. Si lo hizo, exportar el contenido, eliminar el valor de la clave y luego continuar
            %REG% query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v PendingFileRenameOperations >nul 2>&1
            if !errorlevel!==0 (
                echo GUID ofensivo: %%i >> "%RAW_LOGS%\PendingFileRenameOperations_%COMPUTERNAME%_%CUR_DATE2%.txt"
                %REG% query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v PendingFileRenameOperations>> "%RAW_LOGS%\PendingFileRenameOperations_%COMPUTERNAME%_%CUR_DATE2%.txt"
                %REG% delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v PendingFileRenameOperations /f >nul 2>&1

            %LOG%    "    %CUR_DATE2% !TIME! ^^!  Entradas de PendingFileRenameOperations exportadas a "%RAW_LOGS%\PendingFileRenameOperations_%COMPUTERNAME%_%CUR_DATE2%.txt" y eliminadas."
            echo %CUR_DATE2% !TIME! ^^!  Entradas de PendingFileRenameOperations exportadas a "%RAW_LOGS%\PendingFileRenameOperations_%COMPUTERNAME%_%CUR_DATE2%.txt" y eliminadas.>> "%LOG2%"
            echo ------------------------------------------------------------------->> "%RAW_LOGS%\PendingFileRenameOperations_%COMPUTERNAME%_%CUR_DATE2%.txt"
            )
        )
    )
)
ENDLOCAL DISABLEDELAYEDEXPANSION
%LOG%    "     Fase 2 terminada."

::========================================================================================================================================

:: TAREA: Eliminar programas basura, fase 3: comodin por nombre
title [Eliminar bloatware por nombre]
%LOG%    "     Intentando eliminar junkware: Fase 3 (comodin por nombre)..."
%LOG%    "     Zeroo NO esta bloqueado aqui, esta parte simplemente lleva mucho tiempo"
%LOG%    "     Los errores sobre 'SHUTTING DOWN' son seguros de ignorar"
setlocal EnableExtensions EnableDelayedExpansion

:: Sellar el archivo de registro raw que usamos para rastrear el progreso a traves de la lista:: este todavia esta habilitado ya que no estamos mostrando el nombre en la barra de titulo
echo %CUR_DATE2% %TIME%     Intentando eliminar junkware: Fase 3 ^(comodin por nombre^)...>> "%RAW_LOGS%\stage_2_de-bloat_progress_%COMPUTERNAME%_%CUR_DATE2%.log" 2>&1
:: Esto es necesario para que podamos verificar errorlevel dentro del bucle FOR
SETLOCAL ENABLEDELAYEDEXPANSION
:: Comprobacion de salida detallada
%LOG% "    Buscando:"
:: Recorrer el archivo...
for /f "delims=" %%i in (resources\oem\programs_to_target_by_name.txt) do (
    ::  ...y para cada linea comprobar si es un comentario o un comando SET y realizar la eliminacion si no lo es
    if not %%i==:: (
    if not %%i==set (

       :: Realizar la eliminacion
       %LOG%    "    %%i"
       <NUL "%WMIC%" product where "name like '%%i'" uninstall /nointeractive>> "%LOG2%" 2>&1

       :: Comprobar si el desinstalador agrego entradas a PendingFileRenameOperations. Si lo hizo, exportar el contenido, eliminar el valor de la clave y luego continuar
       %REG% query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v PendingFileRenameOperations >nul 2>&1
       if !errorlevel!==0 (
            echo GUID ofensivo: %%i >> "%RAW_LOGS%\PendingFileRenameOperations_%COMPUTERNAME%_%CUR_DATE2%.txt"
            %REG% query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v PendingFileRenameOperations>> "%RAW_LOGS%\PendingFileRenameOperations_%COMPUTERNAME%_%CUR_DATE2%.txt"
            %REG% delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v PendingFileRenameOperations /f >nul 2>&1

        %LOG%    "    %CUR_DATE2% !TIME! ^^!  Entradas de PendingFileRenameOperations exportadas a "%RAW_LOGS%\PendingFileRenameOperations_%COMPUTERNAME%_%CUR_DATE2%.txt" y eliminadas."
            echo %CUR_DATE2% !TIME! ^^!  Entradas de PendingFileRenameOperations exportadas a "%RAW_LOGS%\PendingFileRenameOperations_%COMPUTERNAME%_%CUR_DATE2%.txt" y eliminadas.>> "%LOG2%"
            echo ------------------------------------------------------------------->> "%RAW_LOGS%\PendingFileRenameOperations_%COMPUTERNAME%_%CUR_DATE2%.txt"
        )

        :: Volcar a un registro raw separado para que podamos ver si el script se bloquea en una entrada en particular
        :: No se muestra en la consola ni se vuelca al registro principal para evitar saturarlos
        echo %CUR_DATE2% !TIME!     %%i>> "%RAW_LOGS%\stage_2_de-bloat_progress_%COMPUTERNAME%_%CUR_DATE2%.log" 2>&1

        )
    )
)
ENDLOCAL DISABLEDELAYEDEXPANSION

endlocal DisableDelayedExpansion
%LOG%    "     Fase 3 terminada."

::========================================================================================================================================

:: TAREA: Eliminar programas basura, fase 4: escaneos auxiliares de WildTangent y HP Games
title [escaneos auxiliares]
%LOG%    "     Intentando eliminar junkware: Fase 4 (escaneos auxiliares de HP y Wild Tangent Games)...":: Gateway Games (juegos WildTangent con la marca Gateway):: Estos dos bucles FOR deberian detectar TODOS los juegos de Gateway, en teoria al menos:: Basicamente, recorre el subdirectorio de juegos y, si existe un "Uninstall.exe" EN CUALQUIER LUGAR, lo ejecuta con el modificador /silent
if exist "%ProgramFiles%\Gateway Games" ( for /r "%ProgramFiles%\Gateway Games" %%i in (Uninstall.exe) do ( if exist "%%i" "%%i" /silent ) )
if exist "%ProgramFiles(x86)%\Gateway Games" ( for /r "%ProgramFiles(x86)%\Gateway Games" %%i in (Uninstall.exe) do ( if exist "%%i" "%%i" /silent ) )

:: HP Games:: Estos dos bucles FOR deberian detectar TODOS los juegos de HP, en teoria al menos:: Basicamente, recorre el subdirectorio de HP Games y, si existe un "Uninstall.exe" EN CUALQUIER LUGAR, lo ejecuta con el modificador /silent
if exist "%ProgramFiles%\HP Games" ( for /r "%ProgramFiles%\HP Games" %%i in (Uninstall.exe) do ( if exist "%%i" "%%i" /silent ) )
if exist "%ProgramFiles(x86)%\HP Games" ( for /r "%ProgramFiles(x86)%\HP Games" %%i in (Uninstall.exe) do ( if exist "%%i" "%%i" /silent ) )

:: Dell Games (juegos WildTangent con la marca Dell):: Estos dos bucles deberian detectar todos los juegos de Dell, en teoria al menos:: Basicamente, recorre el subdirectorio de juegos y, si existe un "Uninstall.exe" EN CUALQUIER LUGAR, lo ejecuta con el modificador /silent
for /r "%ProgramFiles%\WildTangent\Dell Games" %%i in (Uninstall.exe) do ( if exist "%%i" "%%i" /silent )
for /r "%ProgramFiles(x86)%\WildTangent\Dell Games" %%i in (Uninstall.exe) do ( if exist "%%i" "%%i" /silent )

%LOG%    "     Fase 4 terminada."

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
