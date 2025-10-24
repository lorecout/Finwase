# Script PowerShell para buildear APK de produção do FinWise
# Uso: .\build_release_apk.ps1

Write-Host "🚀 FinWise Release Build Generator" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# Verificar dependências
Write-Host "📋 Verificando dependências..." -ForegroundColor Yellow

# Verificar Flutter
$flutter = Get-Command flutter -ErrorAction SilentlyContinue
if (-not $flutter) {
    Write-Host "❌ Flutter não instalado" -ForegroundColor Red
    exit 1
}

# Verificar Java
$java = Get-Command java -ErrorAction SilentlyContinue
if (-not $java) {
    Write-Host "❌ Java não instalado" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Dependências OK" -ForegroundColor Green
Write-Host ""

# Limpeza
Write-Host "🧹 Limpando builds anteriores..." -ForegroundColor Yellow
flutter clean
if (Test-Path "build") { Remove-Item -Recurse -Force "build" }
Write-Host "✅ Limpeza concluída" -ForegroundColor Green
Write-Host ""

# Get dependencies
Write-Host "📦 Baixando dependências..." -ForegroundColor Yellow
flutter pub get
Write-Host "✅ Dependências baixadas" -ForegroundColor Green
Write-Host ""

# Build release APK
Write-Host "🔨 Buildando APK de release..." -ForegroundColor Yellow
Write-Host "(Isso pode levar alguns minutos...)" -ForegroundColor Gray

$apkResult = & flutter build apk --release --split-per-abi --target-platform android-arm,android-arm64,android-x86,android-x86_64 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ APK buildado com sucesso!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📍 Localização dos APKs:" -ForegroundColor Cyan
    Get-Item "build/app/outputs/flutter-apk/" -ErrorAction SilentlyContinue | ForEach-Object { Get-ChildItem -Path $_ -File }
    Write-Host ""
    
    # Build App Bundle (AAB) para Google Play
    Write-Host "📦 Buildando App Bundle para Google Play..." -ForegroundColor Yellow
    Write-Host "(Isso pode levar alguns minutos...)" -ForegroundColor Gray
    
    & flutter build appbundle --release 2>&1 | Out-Null
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ App Bundle buildado com sucesso!" -ForegroundColor Green
        Write-Host ""
        Write-Host "📍 Localização do App Bundle:" -ForegroundColor Cyan
        Get-Item "build/app/outputs/bundle/release/" -ErrorAction SilentlyContinue | ForEach-Object { Get-ChildItem -Path $_ -File }
        Write-Host ""
        
        Write-Host "✨ Build concluído!" -ForegroundColor Green
        Write-Host ""
        Write-Host "📋 Próximos passos:" -ForegroundColor Cyan
        Write-Host "1. Fazer upload do AAB (app bundle) para Google Play Console" -ForegroundColor White
        Write-Host "2. Configurar store listing e screenshots" -ForegroundColor White
        Write-Host "3. Submeter para revisão" -ForegroundColor White
        Write-Host ""
        
        # Abrir Google Play Console
        $response = Read-Host "Deseja abrir Google Play Console? (s/n)"
        if ($response -eq "s") {
            Start-Process "https://play.google.com/console"
        }
    } else {
        Write-Host "❌ Erro ao buildear App Bundle" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "❌ Erro ao buildear APK" -ForegroundColor Red
    Write-Host $apkResult
    exit 1
}
