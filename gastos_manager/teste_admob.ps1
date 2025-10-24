# 🧪 Script de Teste AdMob
# Execute após aguardar 30 minutos do bloqueio

Write-Host "🚀 Iniciando teste otimizado do AdMob..." -ForegroundColor Cyan
Write-Host ""

# Limpar cache
Write-Host "🧹 Limpando cache do Flutter..." -ForegroundColor Yellow
flutter clean
Write-Host ""

# Verificar dispositivos disponíveis
Write-Host "📱 Dispositivos disponíveis:" -ForegroundColor Yellow
flutter devices
Write-Host ""

# Perguntar qual dispositivo usar
Write-Host "🎯 Iniciando app no dispositivo padrão..." -ForegroundColor Green
Write-Host "💡 Dica: Use 'r' para hot reload, 'R' para hot restart" -ForegroundColor Yellow
Write-Host ""

# Rodar app
Write-Host "▶️  Executando flutter run..." -ForegroundColor Cyan
flutter run

Write-Host ""
Write-Host "✅ Teste concluído!" -ForegroundColor Green
