# Parámetros configurables.
param (
    [string]$origen = "C:\Users\myuser\Local\Proyects",
    [string]$destino = "C:\Users\myuser\Local\DirMove",
    [string]$extension = ".psd"
)

# Crear carpeta destino si no existe.
if (!(Test-Path -Path $destino)) {
    New-Item -ItemType Directory -Path $destino | Out-Null
}

# Excluir carpeta de destino de la búsqueda.
$archivos = Get-ChildItem -Path $origen -Recurse -File -ErrorAction SilentlyContinue |
    Where-Object {
        $_.Extension -ieq $extension -and
        ($_.FullName -notlike "$destino*")
    }

foreach ($archivo in $archivos) {
    $nombreArchivo = $archivo.Name
    $nombreSinExtension = [System.IO.Path]::GetFileNameWithoutExtension($nombreArchivo)
    $extensionArchivo = $archivo.Extension

    # Ruta tentativa en destino.
    $rutaDestino = Join-Path $destino $nombreArchivo
    $contador = 1

    # Evitar duplicados añadiendo (1), (2), etc.
    while (Test-Path -Path $rutaDestino) {
        $nuevoNombre = "$nombreSinExtension ($contador)$extensionArchivo"
        $rutaDestino = Join-Path $destino $nuevoNombre
        $contador++
    }

    try {
        Move-Item -LiteralPath $archivo.FullName -Destination $rutaDestino -Force
        Write-Host "✅ Movido: $($archivo.FullName) → $rutaDestino"
    } catch {
        Write-Warning "❌ Error al mover: $($archivo.FullName)"
    }
}