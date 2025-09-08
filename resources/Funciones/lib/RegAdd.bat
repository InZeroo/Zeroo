:: Parámetros:
::  %~1 = Ruta de la clave de registro
::  %~2 = Nombre del valor (si es "(Default)", se usa /ve)
::  %~3 = Tipo de dato (por ejemplo, REG_DWORD o REG_SZ)
::  %~4 = Datos a asignar (si es "(Default)", se omite)

:RegAddEntry

set "VARSERV=%~1"

if exist "%TEMP%\services.log" del /f /q "%TEMP%\services.log"
set "llamado=RegAddEntry"

%RegQuery% "%~1"
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
%REG% add "%~1" /v "%~2" /t %~3 /d %~4 /f > "%TEMP%\services.log" 2>&1
if errorlevel 1 (
    %LOG%    "     Falló al establecer el valor %~2 en %~1."
) else (
    %LOG%    "     Valor %~2 establecido a %~4 en %~1."
    goto :eof
)

type "%TEMP%\services.log" >> "%LOG2%"
if /i "%SYSTEM_LANGUAGE%"=="es" set "ACCESO=Acceso denegado."
if /i "%SYSTEM_LANGUAGE%"=="en" set "ACCESO=Access is denied."

findstr /c:"%ACCESO%" "%TEMP%\services.log" >nul
if not errorlevel 1 (
    %LOG%    "    Se detecto "%ACCESO%""
    %SCError2% "%~1"
)

goto :eof