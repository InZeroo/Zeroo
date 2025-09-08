
set "TaskName=%~1"

schtasks /query /TN "%TaskName%" >nul 2>&1
if %errorlevel%==0 (
    schtasks /change /TN "%TaskName%" /DISABLE >> "%LOG2%" 2>&1
    %LOG%    "     Tarea %TaskName% deshabilitada."
) else (
    %LOG%    "     La tarea %TaskName% no existe."
)
goto :eof