#!/usr/bin/env pwsh
# Script robusto para testar FinWase no emulador
# Aguarda emulador inicializar completamente

Write-Host "🚀 FINWASE - TESTE NO EMULADOR ANDROID" -ForegroundColor Green
Write-Host "=======================================" -ForegroundColor Green

function Wait-ForEmulator {
    Write-Host "⏳ Aguardando emulador inicializar..." -ForegroundColor Yellow
    
    $maxAttempts = 20
    $attempt = 0
    
    do {
        $attempt++
        Write-Host "   Tentativa $attempt/$maxAttempts..." -ForegroundColor Gray
        
        $devices = flutter devices --machine 2>$null | ConvertFrom-Json -ErrorAction SilentlyContinue
        $androidDevice = $devices | Where-Object { $_.platform -eq "android" -and $_.emulator -eq $true }
        
        if ($androidDevice) {
            Write-Host "✅ Emulador pronto: $($androidDevice.name)" -ForegroundColor Green
            return $true
        }
        
        Start-Sleep -Seconds 3
    } while ($attempt -lt $maxAttempts)
    
    return $false
}

# Verificar se emulador já está rodando
Write-Host "📱 Verificando emuladores..." -ForegroundColor Cyan
$devices = flutter devices --machine 2>$null | ConvertFrom-Json -ErrorAction SilentlyContinue
$androidDevice = $devices | Where-Object { $_.platform -eq "android" -and $_.emulator -eq $true }

if (-not $androidDevice) {
    Write-Host "🔄 Iniciando emulador Medium_Phone..." -ForegroundColor Yellow
    flutter emulators --launch Medium_Phone
    
    if (-not (Wait-ForEmulator)) {
        Write-Host "❌ Emulador não inicializou. Tente manualmente:" -ForegroundColor Red
        Write-Host "   flutter emulators --launch Medium_Phone" -ForegroundColor White
        exit 1
    }
} else {
    Write-Host "✅ Emulador já está rodando!" -ForegroundColor Green
}

# Mostrar dispositivos disponíveis
Write-Host "`n📋 Dispositivos conectados:" -ForegroundColor Cyan
flutter devices

# Executar app
Write-Host "`n🎯 Executando FinWase..." -ForegroundColor Green
Write-Host "💡 Comandos úteis:" -ForegroundColor Yellow
Write-Host "   r  = Hot reload (recarregar)" -ForegroundColor White
Write-Host "   R  = Hot restart (reiniciar)" -ForegroundColor White
Write-Host "   q  = Sair" -ForegroundColor White
Write-Host "   h  = Ajuda" -ForegroundColor White

Write-Host "`n🚀 Iniciando app..." -ForegroundColor Green
flutter run --debug

Write-Host "`n✅ Teste finalizado!" -ForegroundColor Green