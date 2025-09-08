:: 1.2 se añade la variable checkactivation 
:: 1.2 se elimina el archivo temporal
:: 1.3 Se añaden funciones para la creacion de archivo log
:: 1.4 Se añaden funciones para optimizar el internet
:: 1.5 se ha reparado la funcion log que no estaba copiando correctamente el log al archivo 
:: 1.6 se ha añadido mas configuraciones para la hora
:: 1.6 se agregaron mas funciones para el sistema
:: 1.6 se ordenaron correctamente las funciones 
:: 1.7 Se modifica las funciones de PTR para tener mayor coherencia
:: 1.8 se añade la variable de la carpeta %appdata%OPTzeroo
:: 1.9 Optener tarjeta de red y se añade el bat VAREX para añadir las variables de expansion
:: 1.9 se agregaron funciones para intenernet 2.8
:: 2.0 Se añade la funcion para detectar la memoria de ram
:: 2.1 Funcion para opterner los usuarios
:: 2.1 Se crea la carpeta backups
:: 2.1 detectar estado de la red
:: 2.1 detectar lenguaje del sistema
:: 2.2 Se añade el logo3
:: 2.2 Se actualizaron los identificadores de idiomas
:: 2.2 Acutalizacion del logo
:: 2.2 Reparacion del la deteccion del internet
:: 2.3 ahora se ejecuta en version.bat el estado de administrador
:: 2.3 Se añade la version
:: 2.3 Variable para ejecutar
:: 2.4 deteccion correcta para el windows 11
:: 2.4 mejora de la estructura del codigo
:: 2.4 Se añade la variable para ejecutar en silencion
:: 2.5 se añade User id 
:: 2.5 Se repara la deteccion del internet
:: 2.5 se añade la deteccion de windows 7 y 8 de forma individual
:: 2.6 Se agrega la identificacion de labateria
:: 2.6 Se ha modificado el logo para agregar la deteccion de laptop
:: 2.7 Se añade dxdiag para el analisis del equipo
:: 2.7 Mejorando diseño de la espera al ejecutar version.bat
:: 2.8 Se agrega lib para guardar formulas para ejecutar ciertos procesos repetitivos
:: 2.8 Se agrega la carpeta bin para agregar programas importantes para identificar ssd y modificar permisos de las carpetas 
:: 2.8 el archivo log se cambia de carpeta
:: 2.8 Se agrega la funcion para detectar ssd
:: 2.9 Ahora no mostrara que se esta actualizando la red
:: 2.9 Ahora no mostrara error si no encuentra dxdiag
:: 2.9 Se correije un error de logica en %RegDel%
:: 2.9 Se corrije errores de logica en %RegQuery%
:: 2.9 se ha añadido la libreria %SCServicesUp%
:: 2.9 Se añade la expancion de todas las tarjetas de red encontradas
:: 2.9 Se elimina wmic buscando USER_SID
:: 2.9 Ahora buscara la bateria sin generar reportes
:: 2.9 mejoras en la logica de las variables
:: 3.0 Se añade la variable ADPRED para opterner todos los adaptadores de red
:: 3.0 Se agrega la variable wifi
:: 3.1 Se mejora la deteccion de laptop o pc de mesa
:: 3.2 Configuracion modo tecnico | si la variable MODO esta configurada en tec este volvera a escribir el dxdiag de pero si esta en user solo lo hara una vez
:: 3.3 Se añade reparacion de WMIC  en caso de que este no funcione ya que es indispensable para las optimizaciones
::========================================================================================================================================
::========================================================================================================================================
::set "MODO=tec"
set "MODO=user"
::========================================================================================================================================

call resources\Funciones\Logo3.bat
@echo off
color 30
title Version o variables
echo.
echo =================================================================================
echo.
echo CARGANDO VARIABLES....
echo.
echo PORFAVOR ESPERE
echo.
echo =================================================================================
echo.

::========================================================================================================================================
::========================================================================================================================================

::version
set "var=resources\Funciones\Version.bat"
set "version=IntecZeroo v2.3"
set "start=start "%version%" /wait /high "cmd.exe" /c"
set "start2=start "%version%" /wait /high /MIN "cmd.exe" /c"
set "VAREX=resources\Funciones\VAREX.bat"

::========================================================================================================================================

::Variables de administrador
set WMIC=%SystemRoot%\System32\wbem\wmic.exe
set REG=%SystemRoot%\System32\reg.exe
set FINDSTR=%SystemRoot%\System32\findstr.exe
set FIND=%SystemRoot%\System32\find.exe
set "DirZeroo=%APPDATA%\OPTzeroo\"

::========================================================================================================================================

::REPARACION DE WMIC

if not exist "%WMIC%" (
    xcopy "resources\Funciones\bin\wmic.exe" "%SystemRoot%\System32\wbem\" /y /s /h
)

::========================================================================================================================================

::calcular la hora
set "current_date=%DATE%"
set "current_time=%TIME%"
set "formatted_date=%current_date%"
set "formatted_time=%current_time:~0,8%"

::Optener hora
for /f %%a in ('^<NUL %WMIC% OS GET LocalDateTime ^| %FIND% "."') do set DTS=%%a
set CUR_DATE3=%DTS:~0,4%-%DTS:~4,2%-%DTS:~6,2% %DTS:~8,2%-%DTS:~10,2%-%DTS:~12,2%
set CUR_DATE2=%DTS:~0,4%-%DTS:~4,2%-%DTS:~6,2%
set CUR_DATE=%formatted_date% %formatted_time%

::========================================================================================================================================

:: Variables para scripts zeroo
set "LOGO=call resources\Funciones\Logo.bat"
set "LOGO2=call resources\Funciones\Logo2.bat"
set "LOGO3=call resources\Funciones\Logo3.bat"
set "Suscribete=call resources\Funciones\Suscribete.bat"
set "DeleteTask=call resources\Funciones\lib\DeleteTask.bat"
set "DesactivarTask=call resources\Funciones\lib\DesactivarTask.bat"
set "RegAdd=call resources\Funciones\lib\RegAdd.bat"
set "RegDel=call resources\Funciones\lib\RegDel.bat"
set "RegQuery=call resources\Funciones\lib\RegQuery.bat"
set "SCError1=call resources\Funciones\lib\SCError1.bat"
set "SCError2=call resources\Funciones\lib\SCError2.bat"
set "SCQuery=call resources\Funciones\lib\SCQuery.bat"
set "SCQuery2=call resources\Funciones\lib\SCQuery2.bat"
set "SCQuery3=call resources\Funciones\lib\SCQuery3.bat"
set "SCServicesDel=call resources\Funciones\lib\SCServicesDel.bat"
set "SCServicesDown=call resources\Funciones\lib\SCServicesDown.bat"
set "SCServicesUp=call resources\Funciones\lib\SCServicesUp.bat"

::========================================================================================================================================

::DETECTAR VERSION DE WINDOWS
set WIN_VER=undetected
set WIN_VER_NUM=undetected

:: Detectar versión del sistema usando el registro
for /f "tokens=3*" %%i in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName ^| findstr /i "ProductName"') do set "WIN_VER=%%i %%j"
for /f "tokens=3*" %%i in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentVersion ^| findstr /i "CurrentVersion"') do set "WIN_VER_NUM=%%i"

:: Estado de inicial de reconocimiento de windows 
set RUN_7=no
set RUN_8=no
set RUN_7_OR_8=no
set RUN_10_OR_11=no
set RUN_10=no
set RUN_11=no

:: Reconocimiento de windows 7 y 8
if /i "%WIN_VER:~0,9%"=="Windows 7" set RUN_7_OR_8=yes
if /i "%WIN_VER:~0,9%"=="Windows 8" set RUN_7_OR_8=yes
if /i "%WIN_VER:~0,9%"=="Windows 7" set RUN_7=yes
if /i "%WIN_VER:~0,9%"=="Windows 8" set RUN_8=yes
if /i "%WIN_VER:~0,19%"=="Windows Server 2012" set RUN_7_OR_8=yes

:: Reconocimiento de windows 11
if /i "%WIN_VER:~0,10%"=="Windows 10" (for /f "skip=1 tokens=2* delims= " %%A in ('wmic os get Caption') do (set "WIN_VER=%%A %%B"))

:: Reconocimiento de windows 10 y 11
if /i "%WIN_VER:~0,9%"=="Windows 1" set RUN_10_OR_11=yes
if /i "%WIN_VER:~0,10%"=="Windows 10" set RUN_10=yes
if /i "%WIN_VER:~0,10%"=="Windows 11" set RUN_11=yes

::========================================================================================================================================

::Detectar usuarios

pushd "%USERPROFILE%\.."
set USERPROFILES=%CD%
popd

::========================================================================================================================================

:: RAM Ejecuta PowerShell y obtiene la RAM total en GB
for /f "tokens=*" %%a in ('powershell -command "([math]::Round((Get-WmiObject Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB))"') do set RAM=%%a

::========================================================================================================================================

:: Lenguaje del sistema
set NETWORK_AVAILABLE=undetected

:: English

%REG% query "hklm\system\controlset001\control\nls\language" /v Installlanguage | %FIND% /i "0409" >nul 2>&1
if /i %ERRORLEVEL%==0 (
	set SYSTEM_LANGUAGE=en
	goto detect_network_connection
)

%REG% query "hklm\system\controlset001\control\nls\language" /v Installlanguage | %FIND% /i "0809" >nul 2>&1
if /i %ERRORLEVEL%==0 (
	set SYSTEM_LANGUAGE=en
	goto detect_network_connection
)

%REG% query "hklm\system\controlset001\control\nls\language" /v Installlanguage | %FIND% /i "0C09" >nul 2>&1
if /i %ERRORLEVEL%==0 (
	set SYSTEM_LANGUAGE=en
	goto detect_network_connection
)

%REG% query "hklm\system\controlset001\control\nls\language" /v Installlanguage | %FIND% /i "1009" >nul 2>&1
if /i %ERRORLEVEL%==0 (
	set SYSTEM_LANGUAGE=en
	goto detect_network_connection
)

%REG% query "hklm\system\controlset001\control\nls\language" /v Installlanguage | %FIND% /i "4009" >nul 2>&1
if /i %ERRORLEVEL%==0 (
	set SYSTEM_LANGUAGE=en
	goto detect_network_connection
)

%REG% query "hklm\system\controlset001\control\nls\language" /v Installlanguage | %FIND% /i "1809" >nul 2>&1
if /i %ERRORLEVEL%==0 (
	set SYSTEM_LANGUAGE=en
	goto detect_network_connection
)


:: Spanish

%REG% query "hklm\system\controlset001\control\nls\language" /v Installlanguage | %FIND% /i "0C0A" >nul 2>&1
if /i %ERRORLEVEL%==0 (
	set SYSTEM_LANGUAGE=es
	goto detect_network_connection
)

%REG% query "hklm\system\controlset001\control\nls\language" /v Installlanguage | %FIND% /i "080A" >nul 2>&1
if /i %ERRORLEVEL%==0 (
	set SYSTEM_LANGUAGE=es
	goto detect_network_connection
)

%REG% query "hklm\system\controlset001\control\nls\language" /v Installlanguage | %FIND% /i "2C0A" >nul 2>&1
if /i %ERRORLEVEL%==0 (
	set SYSTEM_LANGUAGE=es
	goto detect_network_connection
)

%REG% query "hklm\system\controlset001\control\nls\language" /v Installlanguage | %FIND% /i "240A" >nul 2>&1
if /i %ERRORLEVEL%==0 (
	set SYSTEM_LANGUAGE=es
	goto detect_network_connection
)

%REG% query "hklm\system\controlset001\control\nls\language" /v Installlanguage | %FIND% /i "140A" >nul 2>&1
if /i %ERRORLEVEL%==0 (
	set SYSTEM_LANGUAGE=es
	goto detect_network_connection
)

::========================================================================================================================================

goto :continue1

::estado de red 
:detect_network_connection

set NETWORK_AVAILABLE=yes

:: English
if %SYSTEM_LANGUAGE%==en %WinDir%\system32\ipconfig /all | %FIND% /i "Subnet Mask" >NUL 2>&1
if /i not %ERRORLEVEL%==0 set NETWORK_AVAILABLE=no

:: Spanish
if %SYSTEM_LANGUAGE%==es %WinDir%\system32\ipconfig /all | %FIND% /i "de subred" >NUL 2>&1
if /i not %ERRORLEVEL%==0 set NETWORK_AVAILABLE=no

:continue1

:: filtro 2
ping -n 1 8.8.8.8 >NUL 2>&1
if %ERRORLEVEL%==0 (
    set NETWORK_AVAILABLE=yes
) else (
    set NETWORK_AVAILABLE=no
)


::========================================================================================================================================

:identificar_laptop

:: Ejecutar WMIC y capturar el resultado en variable
for /f "tokens=*" %%A in ('wmic path Win32_Battery get /format:list 2^>nul') do set "output=%%A"

if /i "%output%"=="" (
    set "bateria=no"
) else (
    set "bateria=yes"
)

::------------------------------------------

for /f "skip=1 tokens=* delims= " %%A in ('wmic SystemEnclosure get ChassisTypes') do (
    set "type=%%A"
    goto :done
    set "type=%type:{=%"
    set "type=%type:}=%"
)

:done
::3	Desktop (PC de escritorio)
::4	Low Profile Desktop
::5	Pizza Box
::6	Mini Tower
::7	Tower
::8	Portable
::9	Laptop
::10	Notebook
::11	Hand Held
::12	Docking Station
::13	All-in-One
::14	SubNotebook

if "%type%"=="3"  set "bateria=no"
if "%type%"=="4"  set "bateria=no"
if "%type%"=="5"  set "bateria=no"
if "%type%"=="6"  set "bateria=no"
if "%type%"=="7"  set "bateria=no"
if "%type%"=="8"  set "bateria=yes"
if "%type%"=="9"  set "bateria=yes"
if "%type%"=="10" set "bateria=yes"
if "%type%"=="11" set "bateria=yes"
if "%type%"=="12" set "bateria=no"
if "%type%"=="13" set "bateria=no"
if "%type%"=="14" set "bateria=yes"

::========================================================================================================================================

pushd resources\Funciones\bin

for /f %%i in ('smartctl.exe --scan') do smartctl.exe %%i -a | %FINDSTR% /i "Solid SSD RAID SandForce" >NUL && set SKIP_DEFRAG=yes_ssd
for /f %%i in ('smartctl.exe --scan') do smartctl.exe %%i -a | %FINDSTR% /i "VMware VBOX XENSRC PVDISK" >NUL && set SKIP_DEFRAG=yes_vm
for /f %%i in ('smartctl.exe --scan') do smartctl.exe %%i -a | %FIND% /i "Read Device Identity Failed" >NUL && set SKIP_DEFRAG=yes_disk_smart_read_error&&set WARNINGS_DETECTED=yes_disk_smart_read_error

:: Buscar codigos de problema conocidos y establecer skip_defrag si se encuentra alguno
set WARNING_LIST=(Error Degraded Unknown PredFail Service Stressed NonRecover)
for /f %%i in ('^<NUL %WMIC% diskdrive get status') do echo %%i|%FINDSTR% /i "%WARNING_LIST:~1,-1%" && (
    set SMART_PROBLEM_CODE=%%i
    set SKIP_DEFRAG=yes_disk_smart_problem_code
    set WARNINGS_DETECTED=yes_disk_smart_problem_code
)
popd

if /i "%SKIP_DEFRAG%"=="yes_ssd" set DISK=SSD
if /i not "%SKIP_DEFRAG%"=="yes_ssd" set DISK=HDD

::========================================================================================================================================

:log
set "LOGPATH=resources\log"
set "LOGFILE=Registro.log"
:: llamada de texto
set "LOG2=%LOGPATH%\%LOGFILE%"
set LOG=call "resources\Funciones\lib\log.bat"
:: Ruta para guid
set "RAW_LOGS=%LOGPATH%\raw_logs"
:: crear carpeta para usuarios
if not exist "%LOGPATH%" mkdir "%LOGPATH%"
:: Crear usuarios
dir "%USERPROFILES%\" /B > "%LOGPATH%\userlist.txt"
:: Carpeta Backups
set BACKUPS=%LOGPATH%\backups

::========================================================================================================================================

::Optener informacion de dxdiag
if "%MODO%"=="tec" dxdiag /t "%LOGPATH%\dxdiag_info.txt" >NUL 2>&1
if "%MODO%"=="user" if not exist "%LOGPATH%\dxdiag_info.txt" dxdiag /t "%LOGPATH%\dxdiag_info.txt" >NUL 2>&1

::========================================================================================================================================

:: Detectar vram
set VRAM=Desconocido

for /f "tokens=2* delims=:" %%A in ('findstr /c:"Display Memory: " "%LOGPATH%\dxdiag_info.txt"') do set VRAM=%%A
:: quitar espacios
set VRAM=%VRAM: =%
:: quitar MB
set VRAM=%VRAM:MB=%

::========================================================================================================================================

:: Detectar procesador
set CPU=Desconocido

for /f "tokens=2* delims=:" %%A in ('findstr /c:"Processor: " "%LOGPATH%\dxdiag_info.txt"') do set CPU=%%A

::========================================================================================================================================

:: Detectar Grafica
set GPU=Desconocido

for /f "tokens=2* delims=:" %%A in ('findstr /c:"Card name: " "%LOGPATH%\dxdiag_info.txt"') do set GPU=%%A

::---------------------------------------------------

:: Detectar Driver de la grafica
set GPU_DRIVER=Desconocido

for /f "tokens=2* delims=:" %%A in ('findstr /c:"Device Key: " "%LOGPATH%\dxdiag_info.txt"') do set GPU_DRIVER=%%A

::========================================================================================================================================

::Tarjeta de red

set NAMERED1=Desconocido
set PCIRED1=Desconocido
set NAMERED2=Desconocido
set PCIRED2=Desconocido
set /a REDN=0
set /a ADPN=0

:: Limpia el archivo de salida (opcional)
if exist "%VAREX%" del "%VAREX%"

setlocal enabledelayedexpansion

set 

:: Recorre la salida en formato CSV de WMIC para tarjetas de red habilitadas.
for /f "skip=1 tokens=2,3 delims=," %%A in ('wmic nic where "NetEnabled=true" get Name^,PNPDeviceID /format:csv ^| findstr /r /v "^$"') do (
    set /a REDN+=1
    :: Asigna el nombre y el PNPDeviceID a variables indexadas
    set "NAMERED!REDN!=%%A"
    set "PCIRED=%%B"
    set "PCIRED!REDN!=!PCIRED:&amp;=&!"
)

echo set REDN=%REDN% >> "%VAREX%"

:: Escribe todas las variables en el archivo de salida
(
    for /L %%i in (1,1,!REDN!) do (
        echo set "NAMERED%%i=!NAMERED%%i!"
        echo set "PCIRED%%i=!PCIRED%%i!"
    )
) >> "%VAREX%"

::----------------------------------------------------------------------------------------------------------------------------------------

:: optener adaptadores de red
for /f "skip=2 tokens=4" %%A in ('netsh interface show interface') do (
    set /a ADPN+=1
    echo set "ADPRED!ADPN!=%%A" >> "%VAREX%"
)

echo set ADPN=%ADPN% >> "%VAREX%"

endlocal

::========================================================================================================================================

set "WIFI=no"
findstr /i "wi-fi" "%VAREX%" >nul
if not errorlevel 1 (
    set "WIFI=yes"
)

::========================================================================================================================================

::Iniciar variables de expancion 
call %VAREX%

::========================================================================================================================================

:: Comprobamos si el script se está ejecutando como administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    %LOGO2%
    pause
    exit
) 


