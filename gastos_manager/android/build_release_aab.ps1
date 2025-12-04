# Gera o App Bundle de release usando o keystore configurado em android/key.properties
param(
  [switch]$Clean
)

$projectRoot = Split-Path $PSScriptRoot -Parent
Set-Location $projectRoot

if ($Clean) {
  Write-Host "flutter clean" -ForegroundColor Yellow
  flutter clean
}

Write-Host "flutter pub get" -ForegroundColor Yellow
flutter pub get

Write-Host "flutter build appbundle --release" -ForegroundColor Yellow
flutter build appbundle --release

if ($LASTEXITCODE -eq 0) {
  Write-Host "AAB gerado com sucesso:" -ForegroundColor Green
  Write-Host (Join-Path $projectRoot "build/app/outputs/bundle/release/app-release.aab")
} else {
  Write-Host "Falha ao gerar o AAB. Verifique o key.properties e as senhas." -ForegroundColor Red
}