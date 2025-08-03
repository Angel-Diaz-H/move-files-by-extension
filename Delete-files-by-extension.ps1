# Carpeta donde buscar
$dir = "C:\Users\angel\OneDrive\Si-Tec"

# Verifica que exista
if (Test-Path -Path $dir) {
    # Busca y borra todos los archivos .psd de forma recursiva
    Get-ChildItem -Path $dir -Recurse -Force -Filter *.psd | ForEach-Object {
        try {
            Remove-Item -LiteralPath $_.FullName -Force
            Write-Host "✅ Eliminado: $($_.FullName)"
        } catch {
            Write-Warning "❌ Error al eliminar: $($_.FullName)"
        }
    }
    Write-Host "🗑️ Todos los archivos .psd han sido eliminados en $dir."
} else {
    Write-Host "⚠️ La carpeta $dir no existe."
}