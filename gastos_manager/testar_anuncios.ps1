# Script para testar configuração de anúncios
# Execute com: .\testar_anuncios.ps1

Write-Host "🎯 Teste de Configuração de Anúncios - Finans App" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host ""

# 1. Verificar se Flutter está instalado
Write-Host "1️⃣ Verificando Flutter..." -ForegroundColor Yellow
$flutterVersion = flutter --version 2>&1 | Select-String "Flutter"
if ($flutterVersion) {
    Write-Host "✅ Flutter instalado" -ForegroundColor Green
    Write-Host $flutterVersion -ForegroundColor Gray
} else {
    Write-Host "❌ Flutter não encontrado!" -ForegroundColor Red
    exit 1
}
Write-Host ""

# 2. Verificar dispositivos conectados
Write-Host "2️⃣ Verificando dispositivos..." -ForegroundColor Yellow
$devices = flutter devices
Write-Host $devices -ForegroundColor Gray
if ($devices -match "No devices detected") {
    Write-Host "⚠️ Nenhum dispositivo conectado!" -ForegroundColor Red
    Write-Host "Conecte um dispositivo Android ou inicie um emulador." -ForegroundColor Yellow
    exit 1
} else {
    Write-Host "✅ Dispositivo(s) encontrado(s)" -ForegroundColor Green
}
Write-Host ""

# 3. Verificar arquivo ad_service.dart
Write-Host "3️⃣ Verificando configuração de anúncios..." -ForegroundColor Yellow
$adServicePath = "lib\services\ad_service.dart"
if (Test-Path $adServicePath) {
    Write-Host "✅ Arquivo ad_service.dart encontrado" -ForegroundColor Green
    
    $adServiceContent = Get-Content $adServicePath -Raw
    
    # Verificar IDs de produção
    if ($adServiceContent -match "ca-app-pub-6846955506912398") {
        Write-Host "✅ IDs de produção configurados" -ForegroundColor Green
    } else {
        Write-Host "⚠️ IDs de produção não encontrados!" -ForegroundColor Yellow
    }
    
    # Verificar Banner ID
    if ($adServiceContent -match "2600398827") {
        Write-Host "✅ Banner ID configurado" -ForegroundColor Green
    }
    
    # Verificar Interstitial ID
    if ($adServiceContent -match "7605313496") {
        Write-Host "✅ Interstitial ID configurado" -ForegroundColor Green
    }
} else {
    Write-Host "❌ Arquivo ad_service.dart não encontrado!" -ForegroundColor Red
}
Write-Host ""

# 4. Verificar AndroidManifest.xml
Write-Host "4️⃣ Verificando AndroidManifest.xml..." -ForegroundColor Yellow
$manifestPath = "android\app\src\main\AndroidManifest.xml"
if (Test-Path $manifestPath) {
    Write-Host "✅ AndroidManifest.xml encontrado" -ForegroundColor Green
    
    $manifestContent = Get-Content $manifestPath -Raw
    
    # Verificar App ID do AdMob
    if ($manifestContent -match "com.google.android.gms.ads.APPLICATION_ID") {
        Write-Host "✅ AdMob Application ID configurado" -ForegroundColor Green
    } else {
        Write-Host "❌ AdMob Application ID NÃO configurado!" -ForegroundColor Red
    }
} else {
    Write-Host "❌ AndroidManifest.xml não encontrado!" -ForegroundColor Red
}
Write-Host ""

# 5. Verificar dependências
Write-Host "5️⃣ Verificando dependências..." -ForegroundColor Yellow
$pubspecPath = "pubspec.yaml"
if (Test-Path $pubspecPath) {
    $pubspecContent = Get-Content $pubspecPath -Raw
    
    if ($pubspecContent -match "google_mobile_ads") {
        Write-Host "✅ google_mobile_ads no pubspec.yaml" -ForegroundColor Green
    } else {
        Write-Host "❌ google_mobile_ads NÃO encontrado no pubspec.yaml!" -ForegroundColor Red
    }
    
    if ($pubspecContent -match "provider") {
        Write-Host "✅ provider no pubspec.yaml" -ForegroundColor Green
    }
} else {
    Write-Host "❌ pubspec.yaml não encontrado!" -ForegroundColor Red
}
Write-Host ""

# 6. Perguntar se quer fazer build
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""
Write-Host "📦 Deseja fazer build e instalar no dispositivo?" -ForegroundColor Cyan
Write-Host ""
Write-Host "Opções:" -ForegroundColor Yellow
Write-Host "  1 - Sim, fazer build debug e instalar" -ForegroundColor White
Write-Host "  2 - Sim, apenas rodar (flutter run)" -ForegroundColor White
Write-Host "  3 - Não, apenas verificação" -ForegroundColor White
Write-Host ""
$choice = Read-Host "Escolha uma opção (1/2/3)"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "🔨 Iniciando build debug..." -ForegroundColor Yellow
        Write-Host ""
        
        # Limpar build anterior
        Write-Host "Limpando build anterior..." -ForegroundColor Gray
        flutter clean
        
        # Obter dependências
        Write-Host "Obtendo dependências..." -ForegroundColor Gray
        flutter pub get
        
        # Build APK
        Write-Host "Construindo APK debug..." -ForegroundColor Gray
        flutter build apk --debug
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host ""
            Write-Host "✅ Build concluído com sucesso!" -ForegroundColor Green
            Write-Host ""
            
            # Instalar
            Write-Host "📱 Instalando no dispositivo..." -ForegroundColor Yellow
            flutter install
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host ""
                Write-Host "✅ App instalado com sucesso!" -ForegroundColor Green
                Write-Host ""
                Write-Host "🔍 Para ver logs em tempo real, execute:" -ForegroundColor Cyan
                Write-Host "   flutter logs" -ForegroundColor White
            } else {
                Write-Host ""
                Write-Host "❌ Erro ao instalar!" -ForegroundColor Red
            }
        } else {
            Write-Host ""
            Write-Host "❌ Erro no build!" -ForegroundColor Red
        }
    }
    "2" {
        Write-Host ""
        Write-Host "🚀 Executando app..." -ForegroundColor Yellow
        Write-Host ""
        flutter run --debug
    }
    "3" {
        Write-Host ""
        Write-Host "✅ Verificação concluída!" -ForegroundColor Green
    }
    default {
        Write-Host ""
        Write-Host "⚠️ Opção inválida!" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""
Write-Host "📋 Checklist de Verificação Manual:" -ForegroundColor Cyan
Write-Host ""
Write-Host "  [ ] Abrir app com conta NÃO premium" -ForegroundColor White
Write-Host "  [ ] Verificar banner no final do Dashboard" -ForegroundColor White
Write-Host "  [ ] Adicionar 3 transações" -ForegroundColor White
Write-Host "  [ ] Verificar interstitial após 3ª transação" -ForegroundColor White
Write-Host "  [ ] Verificar logs no console" -ForegroundColor White
Write-Host "  [ ] Procurar por: '✅ ADMOB: AdMob inicializado'" -ForegroundColor White
Write-Host ""
Write-Host "📊 Monitoramento AdMob:" -ForegroundColor Cyan
Write-Host "  🌐 https://admob.google.com/" -ForegroundColor Blue
Write-Host ""
Write-Host "📚 Documentação completa:" -ForegroundColor Cyan
Write-Host "  📄 GUIA_CONFIGURACAO_ANUNCIOS.md" -ForegroundColor White
Write-Host ""
Write-Host "🎉 Boa sorte com os testes!" -ForegroundColor Green
Write-Host ""
