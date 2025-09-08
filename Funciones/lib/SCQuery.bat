:: Verificar la existencia de la clave de registro
sc query "%~1" >nul 2>&1
goto :eof
