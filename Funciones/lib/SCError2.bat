
set "REGCLAVE=%~1"

%RegQuery% "%REGCLAVE%"
if %errorlevel%==0 (
    %LOG%    "    Eliminando la seguridad de regedit"
    resources\Funciones\bin\setacl.exe -on "%REGCLAVE%" -ot reg -actn setowner -ownr n:administrators >> "%LOG2%" 2>&1
    resources\Funciones\bin\setacl.exe -on "%REGCLAVE%" -ot reg -actn ace -ace "n:administrators;p:full" >> "%LOG2%" 2>&1
    if /i "%llamado%"=="RegDelEntry" %RegDelEntry% %VARSERV%
    if /i "%llamado%"=="RegAddEntry" %RegAddEntry% %VARSERV%
    goto :eof
) else (
    %LOG%    "    La clave "%REGCLAVE%" Update no existe. [ERROR] no se puede deshabilitar el servicio %VARSERV%"
    goto :eof
)
goto :eof