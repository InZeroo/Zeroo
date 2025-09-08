%LOG%    "    Tratando de deshabilitar %VARSERV% desde regedit"

set "REGCLAVE=HKLM\SYSTEM\CurrentControlSet\Services\%VARSERV%"

%RegQuery% "%REGCLAVE%"
if %errorlevel%==0 (
    %LOG%    "    Eliminando la seguridad de regedit"
    resources\Funciones\bin\setacl.exe -on "%REGCLAVE%" -ot reg -actn setowner -ownr n:administrators >> "%LOG2%" 2>&1
    resources\Funciones\bin\setacl.exe -on "%REGCLAVE%" -ot reg -actn ace -ace "n:administrators;p:full" >> "%LOG2%" 2>&1
    %REG% add "%REGCLAVE%" /v LaunchProtected /t REG_DWORD /d 0 /f >> "%LOG2%" 2>&1
    %REG% add "%REGCLAVE%" /v Start /t REG_DWORD /d 4 /f >> "%LOG2%" 2>&1
    goto :eof
) else (
    %LOG%    "    La clave "%REGCLAVE%" Update no existe. [ERROR] no se puede deshabilitar el servicio %VARSERV%"
    goto :eof
)
goto :eof