#!/usr/bin/env pwsh
# Script para corrigir erro de versão Java/Gradle

Write-Host "🔧 CORRIGINDO JAVA/GRADLE" -ForegroundColor Green
Write-Host "=========================" -ForegroundColor Green

# 1. Verificar versões atuais
Write-Host "📋 Verificando versões..." -ForegroundColor Yellow
java -version
Write-Host ""

# 2. Configurar JAVA_HOME para JDK 17 (compatível)
Write-Host "⚙️ Configurando JAVA_HOME..." -ForegroundColor Cyan
$env:JAVA_HOME = "c:\Users\Lorena\AppData\Local\Programs\Microsoft VS Code\jdk-17"
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"

Write-Host "✅ JAVA_HOME: $env:JAVA_HOME" -ForegroundColor Green

# 3. Verificar se JDK 17 existe
if (Test-Path "$env:JAVA_HOME\bin\java.exe") {
    Write-Host "✅ JDK 17 encontrado" -ForegroundColor Green
} else {
    Write-Host "❌ JDK 17 não encontrado. Usando JDK do Android Studio..." -ForegroundColor Yellow
    $env:JAVA_HOME = "C:\Program Files\Android\Android Studio1\jbr"
    $env:PATH = "$env:JAVA_HOME\bin;$env:PATH"
}

# 4. Limpar cache do Gradle
Write-Host "🧹 Limpando cache Gradle..." -ForegroundColor Yellow
cd android
if (Test-Path ".gradle") {
    Remove-Item -Recurse -Force ".gradle" -ErrorAction SilentlyContinue
}
.\gradlew clean --no-daemon
cd ..

# 5. Limpar Flutter
Write-Host "🧹 Limpando Flutter..." -ForegroundColor Yellow
flutter clean
flutter pub get

# 6. Testar compilação
Write-Host "🚀 Testando compilação..." -ForegroundColor Green
flutter build apk --debug

Write-Host "✅ JAVA/GRADLE CORRIGIDO!" -ForegroundColor Green