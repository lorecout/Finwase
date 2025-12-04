# Mostra o SHA1 do keystore/alias informado
$defaultKeystore = Join-Path $PSScriptRoot "app/release.keystore"

Write-Host "Verificar SHA1 do Keystore" -ForegroundColor Cyan
$keystorePath = Read-Host "Caminho do keystore [ENTER para padrao: $defaultKeystore]"
if ([string]::IsNullOrWhiteSpace($keystorePath)) { $keystorePath = $defaultKeystore }

$alias = Read-Host "Alias da chave (ex.: upload ou release)"

Write-Host "Exibindo SHA1 para: $keystorePath (alias: $alias)" -ForegroundColor Yellow

# keytool pedira a senha interativamente
& keytool -list -v -keystore "$keystorePath" -alias "$alias" | Select-String "SHA1"

if ($LASTEXITCODE -ne 0) {
  Write-Host "Falha ao ler o keystore. Verifique alias, caminho e senha." -ForegroundColor Red
}