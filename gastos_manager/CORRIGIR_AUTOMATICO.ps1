# Script PowerShell para corrigir erros Flutter automaticamente
# Salve este arquivo como: CORRIGIR_AUTOMATICO.ps1

param(
    [string]$ProjectPath = "C:\Users\Lorena\StudioProjects\Finwase\gastos_manager"
)

Write-Host "================================" -ForegroundColor Cyan
Write-Host "CORRIGINDO ERROS FLUTTER" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se a pasta do projeto existe
if (-not (Test-Path $ProjectPath)) {
    Write-Host "❌ Pasta do projeto não encontrada: $ProjectPath" -ForegroundColor Red
    exit 1
}

Set-Location $ProjectPath

# ============================================================================
# ETAPA 1: ATUALIZAR pubspec.yaml
# ============================================================================
Write-Host "[1/4] Atualizando versão em pubspec.yaml..." -ForegroundColor Yellow

$pubspecPath = Join-Path $ProjectPath "pubspec.yaml"
if (Test-Path $pubspecPath) {
    $content = Get-Content $pubspecPath -Raw
    $newContent = $content -replace 'version: 1\.0\.4\+5', 'version: 1.0.5+6'

    if ($content -ne $newContent) {
        $newContent | Set-Content $pubspecPath -Encoding UTF8
        Write-Host "✅ Versão atualizada: 1.0.4+5 → 1.0.5+6" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Versão não encontrada ou já atualizada" -ForegroundColor Yellow
    }
} else {
    Write-Host "❌ Arquivo pubspec.yaml não encontrado" -ForegroundColor Red
}

Write-Host ""

# ============================================================================
# ETAPA 2: ADICIONAR GETTERS EM ad_service.dart
# ============================================================================
Write-Host "[2/4] Adicionando getters em ad_service.dart..." -ForegroundColor Yellow

$adServicePath = Join-Path $ProjectPath "lib/services/ad_service.dart"
if (Test-Path $adServicePath) {
    $content = Get-Content $adServicePath -Raw

    # Verificar se getters já existem
    if ($content -like "*static String get bannerUnitId*") {
        Write-Host "⚠️  Getters já existem em ad_service.dart" -ForegroundColor Yellow
    } else {
        # Procurar por linha com _isTestMode para inserir getters antes
        $gettersCode = @"

  // === GETTERS PARA IDs ===
  static String get bannerUnitId => _isTestMode ? _testBannerId : _prodBannerId;
  static String get interstitialUnitId => _isTestMode ? _testInterstitialId : _prodInterstitialId;
  static String get rewardedUnitId => _isTestMode ? _testRewardedId : _prodRewardedId;
"@

        # Inserir getters antes da primeira função estática
        if ($content -match '(\s+static\s+\w+\s+\w+\s*\(|static\s+Future)') {
            $position = $content.IndexOf($matches[0])
            if ($position -gt 0) {
                $newContent = $content.Insert($position, $gettersCode)
                $newContent | Set-Content $adServicePath -Encoding UTF8
                Write-Host "✅ Getters adicionados a ad_service.dart" -ForegroundColor Green
            }
        } else {
            Write-Host "⚠️  Não foi possível adicionar getters (estrutura do arquivo diferente)" -ForegroundColor Yellow
            Write-Host "   Você precisará adicionar manualmente os getters em ad_service.dart" -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "❌ Arquivo ad_service.dart não encontrado em: $adServicePath" -ForegroundColor Red
}

Write-Host ""

# ============================================================================
# ETAPA 3: ADICIONAR CAMPO _performanceData em ad_revenue_optimizer.dart
# ============================================================================
Write-Host "[3/4] Adicionando campo em ad_revenue_optimizer.dart..." -ForegroundColor Yellow

$adRevenueOptimizerPath = Join-Path $ProjectPath "lib/services/ad_revenue_optimizer.dart"
if (Test-Path $adRevenueOptimizerPath) {
    $content = Get-Content $adRevenueOptimizerPath -Raw

    # Verificar se campo já existe
    if ($content -like "*late final Map*_performanceData*") {
        Write-Host "⚠️  Campo _performanceData já existe" -ForegroundColor Yellow
    } else {
        # Procurar por "class AdRevenueOptimizer {" e adicionar campo após
        $fieldCode = "`n  late final Map<String, AdPerformanceData> _performanceData = {};"

        if ($content -match 'class AdRevenueOptimizer\s*\{') {
            $position = $matches[0].Length + $content.IndexOf($matches[0])
            $newContent = $content.Insert($position, $fieldCode)
            $newContent | Set-Content $adRevenueOptimizerPath -Encoding UTF8
            Write-Host "✅ Campo _performanceData adicionado" -ForegroundColor Green
        } else {
            Write-Host "⚠️  Não foi possível adicionar campo (classe não encontrada)" -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "❌ Arquivo ad_revenue_optimizer.dart não encontrado" -ForegroundColor Red
}

Write-Host ""

# ============================================================================
# ETAPA 4: ATIVAR MODO PRODUÇÃO EM ad_service.dart
# ============================================================================
Write-Host "[4/4] Ativando modo produção em ad_service.dart..." -ForegroundColor Yellow

if (Test-Path $adServicePath) {
    $content = Get-Content $adServicePath -Raw

    # Procurar por _isTestMode = true e mudar para false
    if ($content -like "*static bool _isTestMode = true*") {
        $newContent = $content -replace 'static bool _isTestMode = true;', 'static bool _isTestMode = false;'
        $newContent | Set-Content $adServicePath -Encoding UTF8
        Write-Host "✅ Modo produção ativado (_isTestMode = false)" -ForegroundColor Green
    } elseif ($content -like "*static bool _isTestMode = false*") {
        Write-Host "⚠️  Modo produção já está ativado" -ForegroundColor Yellow
    } else {
        Write-Host "⚠️  Não foi possível encontrar _isTestMode" -ForegroundColor Yellow
    }
} else {
    Write-Host "❌ Arquivo ad_service.dart não encontrado" -ForegroundColor Red
}

Write-Host ""

# ============================================================================
# LIMPEZA E COMPILAÇÃO
# ============================================================================
Write-Host "[FINAL] Limpando cache e restaurando dependências..." -ForegroundColor Yellow
Write-Host ""

Write-Host "Executando: flutter clean" -ForegroundColor Cyan
flutter clean

Write-Host ""
Write-Host "Executando: flutter pub get" -ForegroundColor Cyan
flutter pub get

Write-Host ""
Write-Host "================================" -ForegroundColor Cyan
Write-Host "✅ CORREÇÕES CONCLUÍDAS!" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Próximo passo: Compilar o projeto" -ForegroundColor Yellow
Write-Host ""
Write-Host "Execute um dos comandos abaixo:" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Para DEBUG:" -ForegroundColor White
Write-Host "  flutter build appbundle --debug" -ForegroundColor Gray
Write-Host ""
Write-Host "  Para RELEASE (recomendado para Play Store):" -ForegroundColor White
Write-Host "  flutter build appbundle --release" -ForegroundColor Gray
Write-Host ""

pause

