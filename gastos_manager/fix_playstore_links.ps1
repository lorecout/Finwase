# Script para corrigir links do Play Store de com.example.finwise para com.lorecout.finwise

Write-Host "🔍 Procurando por links incorretos do Play Store..." -ForegroundColor Cyan
Write-Host ""

# Array para rastrear arquivos modificados
$filesModified = @()

# Procurar em todos os arquivos do projeto
Get-ChildItem -Path . -Recurse -File | Where-Object {
    $_.Extension -match '\.(md|html|dart|xml|json|txt|sh|ps1)$'
} | ForEach-Object {
    $file = $_
    $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
    
    if ($content -and $content.Contains('com.example.finwise')) {
        # Contar ocorrências
        $count = ($content | Select-String 'com.example.finwise' -All).Matches.Count
        
        # Substituir
        $newContent = $content -replace 'com\.example\.finwise', 'com.lorecout.finwise'
        
        # Salvar arquivo
        $newContent | Out-File -FilePath $file.FullName -Encoding UTF8
        
        $filesModified += @{
            File = $file.FullName
            Count = $count
        }
        
        Write-Host "✅ Corrigido: $($file.FullName)" -ForegroundColor Green
        Write-Host "   → $count ocorrência(s) substituída(s)" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "=" * 60

if ($filesModified.Count -eq 0) {
    Write-Host "✓ Nenhum link incorreto encontrado!" -ForegroundColor Green
} else {
    Write-Host "📊 RESUMO DE CORREÇÕES" -ForegroundColor Cyan
    Write-Host "=" * 60
    Write-Host "Arquivos corrigidos: $($filesModified.Count)" -ForegroundColor Yellow
    
    $totalOccurrences = ($filesModified | Measure-Object -Property Count -Sum).Sum
    Write-Host "Total de correções: $totalOccurrences" -ForegroundColor Yellow
    
    Write-Host ""
    Write-Host "Detalhes:" -ForegroundColor Cyan
    foreach ($file in $filesModified) {
        Write-Host "  • $($file.File): $($file.Count) mudança(s)" -ForegroundColor White
    }
}

Write-Host ""
Write-Host "=" * 60
Write-Host "✨ Script concluído!" -ForegroundColor Green
Write-Host ""
Write-Host "Próximas ações:" -ForegroundColor Cyan
Write-Host "  1. git add ." -ForegroundColor White
Write-Host "  2. git commit -m 'fix: corrigir package name'" -ForegroundColor White
Write-Host "  3. git push" -ForegroundColor White
