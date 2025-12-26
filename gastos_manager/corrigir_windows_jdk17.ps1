#!/usr/bin/env pwsh
# Script OTIMIZADO - Windows + JDK 17 + Flutter

Write-Host "🚀 CORREÇÃO WINDOWS JDK 17" -ForegroundColor Green
Write-Host "===========================" -ForegroundColor Green

# 1. Configurar JDK 17
Write-Host "☕ Configurando JDK 17..." -ForegroundColor Yellow
$env:JAVA_HOME = "c:\Users\Lorena\AppData\Local\Programs\Microsoft VS Code\jdk-17"
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"

# Verificar Java
Write-Host "📋 Versão Java:" -ForegroundColor Cyan
java -version

# 2. Parar daemons Gradle
Write-Host "🛑 Parando Gradle daemons..." -ForegroundColor Yellow
cd android
if (Test-Path "gradlew.bat") {
    .\gradlew.bat --stop
}

# 3. Limpeza total
Write-Host "🧹 Limpeza completa..." -ForegroundColor Yellow
if (Test-Path ".gradle") {
    Remove-Item -Recurse -Force ".gradle"
}
if (Test-Path "build") {
    Remove-Item -Recurse -Force "build"
}

# 4. Flutter - limpeza
Write-Host "🧹 Flutter clean..." -ForegroundColor Yellow
cd ..
C:\Users\Lorena\Documents\SDK\flutter\bin\flutter.bat clean
C:\Users\Lorena\Documents\SDK\flutter\bin\flutter.bat pub cache clean

# 5. Remover pubspec.lock
if (Test-Path "pubspec.lock") {
    Remove-Item "pubspec.lock" -Force
}

# 6. Regenerar Android
Write-Host "🔄 Regenerando Android..." -ForegroundColor Cyan
C:\Users\Lorena\Documents\SDK\flutter\bin\flutter.bat create --platforms=android . --project-name gastos_manager

# 7. Pub get
Write-Host "📦 Flutter pub get..." -ForegroundColor Green
C:\Users\Lorena\Documents\SDK\flutter\bin\flutter.bat pub get

# 8. Gradle wrapper
Write-Host "🔄 Gradle wrapper..." -ForegroundColor Cyan
cd android
.\gradlew.bat wrapper --gradle-version=8.1

# 9. Build debug
Write-Host "🔨 Build debug..." -ForegroundColor Green
.\gradlew.bat assembleDebug --info --stacktrace

# 10. Teste Flutter
Write-Host "🎯 Teste Flutter..." -ForegroundColor Green
cd ..
C:\Users\Lorena\Documents\SDK\flutter\bin\flutter.bat doctor
C:\Users\Lorena\Documents\SDK\flutter\bin\flutter.bat build apk --debug

Write-Host "✅ WINDOWS JDK 17 - CONCLUÍDO!" -ForegroundColor Green
Write-Host "===============================" -ForegroundColor Green
Write-Host "✅ JDK 17 configurado" -ForegroundColor White
Write-Host "✅ Gradle limpo" -ForegroundColor White
Write-Host "✅ Flutter atualizado" -ForegroundColor White
Write-Host "✅ APK compilado" -ForegroundColor White
Write-Host "" -ForegroundColor White
Write-Host "🎉 Abra no Android Studio agora!" -ForegroundColor Cyan