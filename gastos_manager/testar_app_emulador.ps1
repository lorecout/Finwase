#!/usr/bin/env pwsh
# Script para testar FinWase no emulador Android
# Criado para facilitar testes antes da publicação

Write-Host "🚀 TESTANDO FINWASE NO EMULADOR" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Green

# 1. Verificar se emulador está rodando
Write-Host "📱 Verificando emuladores..." -ForegroundColor Yellow
$devices = flutter devices --machine | ConvertFrom-Json
$androidDevice = $devices | Where-Object { $_.platform -eq "android" -and $_.emulator -eq $true }

if (-not $androidDevice) {
    Write-Host "⚡ Iniciando emulador Medium_Phone..." -ForegroundColor Cyan
    Start-Process -FilePath "flutter" -ArgumentList "emulators", "--launch", "Medium_Phone" -NoNewWindow
    
    Write-Host "⏳ Aguardando emulador inicializar (30s)..." -ForegroundColor Yellow
    Start-Sleep -Seconds 30
}

# 2. Verificar novamente
Write-Host "🔍 Verificando dispositivos conectados..." -ForegroundColor Yellow
flutter devices

# 3. Executar app em modo debug
Write-Host "🎯 Executando FinWase no emulador..." -ForegroundColor Green
Write-Host "💡 Pressione 'r' para hot reload, 'R' para hot restart, 'q' para sair" -ForegroundColor Cyan

flutter run --debug

Write-Host "✅ Teste concluído!" -ForegroundColor Green