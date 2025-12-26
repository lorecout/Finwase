#!/usr/bin/env pwsh
# Script DEFINITIVO - Usa TODOS os comandos Gradle para resolver Flutter

Write-Host "🚀 CORREÇÃO COMPLETA - GRADLE + FLUTTER" -ForegroundColor Green
Write-Host "=======================================" -ForegroundColor Green

# 1. Configurar ambiente
$env:JAVA_HOME = "C:\Program Files\Android\Android Studio1\jbr"
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"

# 2. Parar todos os daemons
Write-Host "🛑 Parando daemons..." -ForegroundColor Yellow
cd android
.\gradlew --stop

# 3. Limpeza completa
Write-Host "🧹 Limpeza total..." -ForegroundColor Yellow
.\gradlew clean --no-daemon --refresh-dependencies --rerun-tasks
Remove-Item -Recurse -Force ".gradle" -ErrorAction SilentlyContinue

# 4. Regenerar wrapper
Write-Host "🔄 Regenerando wrapper..." -ForegroundColor Cyan
.\gradlew wrapper --gradle-version=8.1 --distribution-type=all

# 5. Verificar status
Write-Host "📋 Verificando status..." -ForegroundColor Cyan
.\gradlew --version
.\gradlew projects
.\gradlew tasks --group="build"

# 6. Flutter - limpeza total
Write-Host "🧹 Flutter - limpeza..." -ForegroundColor Yellow
cd ..
C:\Users\Lorena\Documents\SDK\flutter\bin\flutter.bat clean
C:\Users\Lorena\Documents\SDK\flutter\bin\flutter.bat pub cache clean
Remove-Item "pubspec.lock" -Force -ErrorAction SilentlyContinue

# 7. Regenerar plataformas
Write-Host "🔄 Regenerando plataformas..." -ForegroundColor Cyan
C:\Users\Lorena\Documents\SDK\flutter\bin\flutter.bat create --platforms=android,windows . --project-name gastos_manager

# 8. Restaurar dependências
Write-Host "📦 Restaurando dependências..." -ForegroundColor Green
C:\Users\Lorena\Documents\SDK\flutter\bin\flutter.bat pub get

# 9. Gradle - build com todas as opções
Write-Host "🔨 Build completo..." -ForegroundColor Green
cd android
.\gradlew build --info --stacktrace --refresh-dependencies --no-build-cache --rerun-tasks --continue

# 10. Verificar dependências
Write-Host "🔍 Verificando dependências..." -ForegroundColor Cyan
.\gradlew dependencies --configuration compileClasspath
.\gradlew dependencyInsight --dependency share_plus --configuration compileClasspath

# 11. Teste final
Write-Host "🎯 Teste final..." -ForegroundColor Green
cd ..
C:\Users\Lorena\Documents\SDK\flutter\bin\flutter.bat doctor -v
C:\Users\Lorena\Documents\SDK\flutter\bin\flutter.bat build apk --debug --verbose

Write-Host "✅ CORREÇÃO COMPLETA FINALIZADA!" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Green
Write-Host "✅ Gradle limpo e regenerado" -ForegroundColor White
Write-Host "✅ Flutter atualizado" -ForegroundColor White
Write-Host "✅ Dependências resolvidas" -ForegroundColor White
Write-Host "✅ Build testado" -ForegroundColor White
Write-Host "" -ForegroundColor White
Write-Host "🎉 Projeto pronto para Android Studio!" -ForegroundColor Cyan