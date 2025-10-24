# Script para migrar imports de transacao.dart e categoria.dart para transaction.dart e category.dart

$files = @(
    "lib\screens\add_transaction_page.dart",
    "lib\screens\bulk_transactions_page.dart",
    "lib\screens\budgets_page.dart",
    "lib\screens\categories_page.dart",
    "lib\screens\reports_page.dart",
    "lib\screens\transactions_page.dart"
)

foreach ($file in $files) {
    $fullPath = Join-Path $PSScriptRoot $file
    
    if (Test-Path $fullPath) {
        Write-Host "Atualizando $file..." -ForegroundColor Cyan
        
        # Ler conteúdo do arquivo
        $content = Get-Content $fullPath -Raw
        
        # Substituir imports
        $content = $content -replace "import '../models/transacao\.dart';", "import '../models/transaction.dart';"
        $content = $content -replace "import '../models/categoria\.dart';", "import '../models/category.dart';"
        
        # Adicionar aliases para compatibilidade temporária
        $content = $content -replace "(import '../models/transaction\.dart';)", "`$1`nimport '../models/transaction.dart' as models; // Transacao = TransactionModel, TipoTransacao"
        $content = $content -replace "(import '../models/category\.dart';)", "`$1`nimport '../models/category.dart' as models; // Categoria = CategoryModel"
        
        # Remover duplicatas de import (se houver)
        $content = $content -replace "(import '../models/transaction\.dart';\s*)+", "import '../models/transaction.dart';`n"
        $content = $content -replace "(import '../models/category\.dart';\s*)+", "import '../models/category.dart';`n"
        
        # Salvar arquivo atualizado
        Set-Content -Path $fullPath -Value $content -NoNewline
        
        Write-Host "✓ $file atualizado" -ForegroundColor Green
    } else {
        Write-Host "⚠ $file não encontrado" -ForegroundColor Yellow
    }
}

Write-Host "`n✓ Migração de imports concluída!" -ForegroundColor Green
Write-Host "Próximos passos:" -ForegroundColor Cyan
Write-Host "1. Execute 'flutter analyze' para verificar erros"
Write-Host "2. Atualize referências de Transacao -> TransactionModel e Categoria -> CategoryModel"
Write-Host "3. Teste o aplicativo"
