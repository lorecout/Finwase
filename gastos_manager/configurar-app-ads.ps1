# Script para configurar app-ads.txt no GitHub Pages (Windows PowerShell)
# Uso: .\configurar-app-ads.ps1

Write-Host "🚀 Iniciando configuração do app-ads.txt..." -ForegroundColor Green
Write-Host ""

# Verificar se estamos em um repositório Git
if (-not (Test-Path ".git")) {
    Write-Host "❌ ERRO: Não é um repositório Git!" -ForegroundColor Red
    Write-Host "Execute este script na raiz do seu repositório GitHub Pages"
    Write-Host "Exemplo: cd lorecout.github.io; .\configurar-app-ads.ps1"
    exit 1
}

Write-Host "✅ Repositório Git detectado" -ForegroundColor Green
Write-Host ""

# Criar arquivo app-ads.txt
Write-Host "📝 Criando arquivo app-ads.txt..." -ForegroundColor Yellow
$content = "google.com, pub-6846955506912398, DIRECT, f08c47fec0942fa0"
$content | Out-File -FilePath "app-ads.txt" -Encoding UTF8 -NoNewline

Write-Host "✅ Arquivo criado: app-ads.txt" -ForegroundColor Green
Write-Host ""

# Verificar conteúdo
Write-Host "🔍 Verificando conteúdo..." -ForegroundColor Yellow
$fileContent = Get-Content "app-ads.txt"
if ($fileContent -match "google.com, pub-6846955506912398") {
    Write-Host "✅ Conteúdo correto" -ForegroundColor Green
} else {
    Write-Host "❌ Conteúdo inválido!" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Git add
Write-Host "📤 Adicionando arquivo ao Git..." -ForegroundColor Yellow
git add app-ads.txt
Write-Host "✅ Arquivo adicionado" -ForegroundColor Green
Write-Host ""

# Verificar status
Write-Host "📊 Status Git:" -ForegroundColor Yellow
git status
Write-Host ""

# Commit
Write-Host "💬 Fazendo commit..." -ForegroundColor Yellow
git commit -m "feat: Adicionar app-ads.txt para validação AdMob"
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Commit realizado" -ForegroundColor Green
} else {
    Write-Host "⚠️  Commit falhou (arquivo pode estar sem mudanças)" -ForegroundColor Yellow
}
Write-Host ""

# Push
Write-Host "🚀 Fazendo push para GitHub..." -ForegroundColor Yellow
git push origin main
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Push realizado com sucesso!" -ForegroundColor Green
} else {
    Write-Host "⚠️  Push pode ter falhado. Tente: git push origin main" -ForegroundColor Yellow
}
Write-Host ""

# Próximos passos
Write-Host "✅ PRÓXIMOS PASSOS:" -ForegroundColor Green
Write-Host "1. Aguarde 1-2 minutos para propagação"
Write-Host "2. Acesse: https://lorecout.github.io/app-ads.txt"
Write-Host "3. Vá em: https://play.google.com/console"
Write-Host "4. Configure domínio: lorecout.github.io"
Write-Host "5. Vá em: https://apps.admob.google.com/"
Write-Host "6. Clique em 'Verificar se há atualizações'"
Write-Host "7. Aguarde 24-48h para validação"
Write-Host ""
Write-Host "🎉 Configuração concluída!" -ForegroundColor Green

