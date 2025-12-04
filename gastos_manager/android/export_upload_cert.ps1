# Exporta certificado PEM da Upload Key para reset na Play Console
# Caminho padrão do keystore (ajuste se necessário)
$defaultKeystore = Join-Path $PSScriptRoot "app/release.keystore"

Write-Host "Exportar certificado PEM da Upload Key" -ForegroundColor Cyan
$keystorePath = Read-Host "Caminho do keystore [ENTER para padrao: $defaultKeystore]"
if ([string]::IsNullOrWhiteSpace($keystorePath)) { $keystorePath = $defaultKeystore }

$alias = Read-Host "Alias da chave (ex.: upload ou release)"

# Destino do PEM
$pemOut = Join-Path (Split-Path $keystorePath -Parent) "upload_certificate.pem"

Write-Host "Gerando PEM em: $pemOut"

# keytool pedira a senha interativamente
& keytool -export -rfc -keystore "$keystorePath" -alias "$alias" -file "$pemOut"

if ($LASTEXITCODE -eq 0) {
  Write-Host "Certificado exportado com sucesso: $pemOut" -ForegroundColor Green
} else {
  Write-Host "Falha ao exportar certificado. Verifique alias, caminho e senha." -ForegroundColor Red
}