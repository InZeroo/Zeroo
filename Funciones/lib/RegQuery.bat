:RegQuery
:: Verificar la existencia de la clave de registro

if "%~2"=="" (
    %REG% query "%~1" /f >nul 2>&1
) else (
    %REG% query "%~1" /v "%~2" /f >nul 2>&1
)

::>> "%LOG2%" 2>&1 ::verifica el estado de la clave del registro con mas detalle en el log 
goto :eof
