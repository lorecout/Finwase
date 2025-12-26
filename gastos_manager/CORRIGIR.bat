@echo off
REM Script para corrigir erros de compilação Flutter - Windows PowerShell
REM Este arquivo faz todas as 3 correções necessárias

echo.
echo ================================
echo CORRIGINDO ERROS FLUTTER
echo ================================
echo.

REM Mudar para a pasta do projeto
cd /d C:\Users\Lorena\StudioProjects\Finwase\gastos_manager

echo [1/3] Limpando cache Flutter...
call flutter clean
call flutter pub get

echo.
echo [2/3] Atualizando versão em pubspec.yaml...
REM Você precisa fazer isso manualmente ou com script PowerShell

echo.
echo [3/3] Corrigindo arquivos Dart...
echo.
echo ✏️ Você precisa fazer as seguintes edições:
echo.
echo ARQUIVO 1: lib/services/ad_service.dart
echo ─────────────────────────────────────────
echo Procure pela seção de constantes e adicione os getters:
echo.
echo    static String get bannerUnitId ^=> _isTestMode ? _testBannerId : _prodBannerId;
echo    static String get interstitialUnitId ^=> _isTestMode ? _testInterstitialId : _prodInterstitialId;
echo    static String get rewardedUnitId ^=> _isTestMode ? _testRewardedId : _prodRewardedId;
echo.
echo ARQUIVO 2: lib/services/ad_revenue_optimizer.dart
echo ──────────────────────────────────────────────────
echo Localize "class AdRevenueOptimizer {" e adicione:
echo.
echo    late final Map^<String, AdPerformanceData^> _performanceData = {};
echo.
echo ARQUIVO 3: pubspec.yaml
echo ──────────────────────────────────────────────────
echo Procure por "version: 1.0.4+5" e mude para "version: 1.0.5+6"
echo.
echo ARQUIVO 4: lib/services/ad_service.dart (novamente)
echo ──────────────────────────────────────────────────
echo Procure por "static bool _isTestMode = true;" e mude para "false"
echo.

pause

