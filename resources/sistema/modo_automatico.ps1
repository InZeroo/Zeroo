# Restablecer efectos visuales a la configuraci�n autom�tica de Windows

# Ruta de la clave que controla los efectos visuales para el usuario actual
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"

# Si la clave existe, eliminarla para quitar todas las configuraciones personalizadas
if (Test-Path $regPath) {
    Write-Host "Eliminando configuraci�n personalizada..."
    Remove-Item -Path $regPath -Recurse -Force
}

# Recrear la clave y establecer VisualFXSetting en 0 para que el sistema determine lo mejor
New-Item -Path $regPath -Force | Out-Null
New-ItemProperty -Path $regPath -Name "VisualFXSetting" -Value 0 -PropertyType DWORD -Force | Out-Null

# Forzar la actualizaci�n de la interfaz de usuario
rundll32.exe user32.dll,UpdatePerUserSystemParameters

Write-Host "Configuraci�n aplicada: Windows usar� la configuraci�n autom�tica recomendada para efectos visuales."
exit
