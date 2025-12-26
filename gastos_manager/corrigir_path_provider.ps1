#!/usr/bin/env pwsh
# Script para corrigir erro do path_provider_android

Write-Host "🔧 CORRIGINDO PATH_PROVIDER_ANDROID" -ForegroundColor Green
Write-Host "===================================" -ForegroundColor Green

# 1. Atualizar Flutter para versão mais recente
Write-Host "📋 Atualizando Flutter..." -ForegroundColor Yellow
flutter upgrade --force

# 2. Limpar cache do pub
Write-Host "🧹 Limpando cache pub..." -ForegroundColor Yellow
flutter pub cache clean
flutter pub cache repair

# 3. Atualizar pubspec.yaml com versões compatíveis
Write-Host "📝 Atualizando dependências..." -ForegroundColor Cyan

$pubspecContent = Get-Content "pubspec.yaml" -Raw
$pubspecContent = $pubspecContent -replace 'path_provider: \^[0-9\.]+', 'path_provider: ^2.1.4'
$pubspecContent = $pubspecContent -replace 'path_provider_android: \^[0-9\.]+', 'path_provider_android: ^2.2.10'
Set-Content "pubspec.yaml" $pubspecContent

# 4. Remover pubspec.lock para forçar resolução
Write-Host "🗑️ Removendo pubspec.lock..." -ForegroundColor Yellow
if (Test-Path "pubspec.lock") {
    Remove-Item "pubspec.lock" -Force
}

# 5. Limpar tudo
Write-Host "🧹 Limpeza completa..." -ForegroundColor Yellow
flutter clean
Remove-Item -Recurse -Force "android\.gradle" -ErrorAction SilentlyContinue

# 6. Restaurar dependências
Write-Host "📦 Restaurando dependências..." -ForegroundColor Green
flutter pub get

# 7. Testar compilação
Write-Host "🚀 Testando compilação..." -ForegroundColor Green
flutter build apk --debug

Write-Host "✅ PATH_PROVIDER_ANDROID CORRIGIDO!" -ForegroundColor Green