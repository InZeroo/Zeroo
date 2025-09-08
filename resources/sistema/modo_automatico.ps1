# Restablecer efectos visuales a la configuración automática de Windows

# Ruta de la clave que controla los efectos visuales para el usuario actual
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"

# Si la clave existe, eliminarla para quitar todas las configuraciones personalizadas
if (Test-Path $regPath) {
    Write-Host "Eliminando configuración personalizada..."
    Remove-Item -Path $regPath -Recurse -Force
}

# Recrear la clave y establecer VisualFXSetting en 0 para que el sistema determine lo mejor
New-Item -Path $regPath -Force | Out-Null
New-ItemProperty -Path $regPath -Name "VisualFXSetting" -Value 0 -PropertyType DWORD -Force | Out-Null

# Forzar la actualización de la interfaz de usuario
rundll32.exe user32.dll,UpdatePerUserSystemParameters

Write-Host "Configuración aplicada: Windows usará la configuración automática recomendada para efectos visuales."
exit
