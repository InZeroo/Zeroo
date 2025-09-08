# Configurar Windows para obtener el mejor rendimiento (desactivando efectos visuales)
# ==============================================================================

# Lista de efectos visuales a desactivar (poner en 0)
$visualEffects = @(
    "AnimateMinimizeMaximize",       # Animar al minimizar y maximizar
    "ComboBoxAnimation",             # Animar cuadros combinados
    "CursorShadow",                  # Sombra en el cursor
    "DesktopIconLabelShadow",        # Sombra en las etiquetas de iconos del Escritorio
    "DragFullWindows",               # Dibujar ventanas completas al arrastrar
    "DropShadow",                    # Sombra bajo las ventanas
    "ListBoxSmoothScrolling",        # Desplazamiento suave en cuadros de lista
    "MenuAnimation",                 # Animaci�n de men�s
    "SelectionFade",                 # Atenuar elementos tras clic
    "TaskbarAnimations",             # Animaciones en la barra de tareas
    "ToolTipAnimation",              # Animaciones en tooltips
    "WindowFade"                     # Efecto de desvanecimiento en ventanas
)

# Ruta del registro que controla los efectos visuales para el usuario actual
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"

# Desactivar cada efecto visual poni�ndolo en 0
foreach ($effect in $visualEffects) {
    Write-Host "Desactivando: $effect"
    Set-ItemProperty -Path $regPath -Name $effect -Value 0 -ErrorAction SilentlyContinue
}

# Forzar la actualizaci�n de la configuraci�n de interfaz del usuario
rundll32.exe user32.dll,UpdatePerUserSystemParameters

Write-Host "Configuraci�n aplicada: Windows est� optimizado para el mejor rendimiento."
exit
