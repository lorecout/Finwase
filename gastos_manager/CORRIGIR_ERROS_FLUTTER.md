# 🔧 CORRIGIR ERROS DO FLUTTER - GASTOS MANAGER

## ❌ ERRO 1: Member not found: 'AdService.bannerUnitId'

### Localização
Arquivo: `lib/services/ad_revenue_optimizer.dart`
Linhas: 102, 114

### Problema
```dart
final prodId = AdService.bannerUnitId();  // ❌ ERRO
final prodId = AdService.interstitialUnitId();  // ❌ ERRO
```

### Solução
O `AdService` deve ter métodos de getter, não valores diretos. Verifique em `lib/services/ad_service.dart`:

#### Verificar se existem esses métodos:
```dart
// Em ad_service.dart deve ter:
static String get bannerUnitId => _isTestMode ? _testBannerId : _prodBannerId;
static String get interstitialUnitId => _isTestMode ? _testInterstitialId : _prodInterstitialId;
static String get rewardedUnitId => _isTestMode ? _testRewardedId : _prodRewardedId;
```

#### Se não existem, adicionar em `ad_service.dart`:
Encontre a seção de getters (cerca da linha 30-40) e adicione:

```dart
// Getters para IDs de anúncio
static String get bannerUnitId => _isTestMode ? _testBannerId : _prodBannerId;
static String get interstitialUnitId => _isTestMode ? _testInterstitialId : _prodInterstitialId;
static String get rewardedUnitId => _isTestMode ? _testRewardedId : _prodRewardedId;
```

#### Ou use assim em `ad_revenue_optimizer.dart`:
```dart
// Forma correta:
final prodId = AdService.bannerUnitId;  // Sem parenteses
final prodId = AdService.interstitialUnitId;  // Sem parenteses
```

---

## ❌ ERRO 2: The getter '_performanceData' isn't defined

### Localização
Arquivo: `lib/services/ad_revenue_optimizer.dart`
Linhas: 307, 350, 361, 372, 387, 400, 411

### Problema
A classe `AdRevenueOptimizer` usa `_performanceData` mas não declarou como campo privado.

### Solução
Em `ad_revenue_optimizer.dart`, adicione o campo privado na classe:

```dart
class AdRevenueOptimizer {
  // Adicione esta linha no topo da classe:
  late Map<String, AdPerformanceData> _performanceData = {};
  
  // ... resto do código
}
```

Ou se quiser usar como Map padrão:

```dart
class AdRevenueOptimizer {
  final Map<String, AdPerformanceData> _performanceData = {};
  
  // ... resto do código
}
```

---

## ❌ ERRO 3: .dart_tool/package_config.json does not exist

### Problema
Flutter não consegue encontrar dependências do projeto.

### Solução
```bash
# Navegue até a pasta do projeto
cd C:\Users\Lorena\StudioProjects\Finwase\gastos_manager

# Execute um dos seguintes comandos:

# Opção 1: Pub Get (mais rápido)
flutter pub get

# Opção 2: Clean + Pub Get (se Opção 1 não funcionar)
flutter clean
flutter pub get

# Opção 3: Get com download forçado (se ainda não funcionar)
flutter pub get --no-offline
```

Após isso, tente compilar novamente:
```bash
flutter build appbundle --release
```

---

## 🔍 VERIFICAR ARQUIVO AD_SERVICE.DART

### O arquivo deve ter esta estrutura:

```dart
class AdService {
  // === Teste ===
  static const String _testBannerId = 'ca-app-pub-3940256099942544/6300978111';
  static const String _testInterstitialId = 'ca-app-pub-3940256099942544/1033173712';
  static const String _testRewardedId = 'ca-app-pub-3940256099942544/5224354917';

  // === Produção ===
  static const String _prodBannerId = 'ca-app-pub-6846955506912398/XXXXXXXXXX';
  static const String _prodInterstitialId = 'ca-app-pub-6846955506912398/YYYYYYYYYY';
  static const String _prodRewardedId = 'ca-app-pub-6846955506912398/ZZZZZZZZZZ';

  // === Flag de Teste/Produção ===
  static bool _isTestMode = true;  // Mudar para false quando for publicar

  // === Getters ===
  static String get bannerUnitId => _isTestMode ? _testBannerId : _prodBannerId;
  static String get interstitialUnitId => _isTestMode ? _testInterstitialId : _prodInterstitialId;
  static String get rewardedUnitId => _isTestMode ? _testRewardedId : _prodRewardedId;

  // === Métodos ===
  static Future<void> initializeAds() async {
    // Inicializar Google Mobile Ads
  }

  static void loadBannerAd() {
    // Carregar anúncio de banner
  }

  // ... resto dos métodos
}
```

---

## 🔍 VERIFICAR ARQUIVO AD_REVENUE_OPTIMIZER.DART

### O arquivo deve ter esta estrutura:

```dart
class AdRevenueOptimizer {
  // === Declarações de Classe ===
  late final Map<String, AdPerformanceData> _performanceData = {};

  // === Métodos que usam _performanceData ===
  Future<void> _loadPerformanceData() async {
    // Carregar dados...
    final data = _performanceData[id];  // Agora funciona!
  }

  void _recordAdLoad(String adId) {
    final data = _performanceData[adId] ??= AdPerformanceData();
    // ... resto do código
  }

  // ... resto dos métodos
}

class AdPerformanceData {
  int impressions = 0;
  int clicks = 0;
  double revenue = 0.0;
  // ... resto dos campos
}
```

---

## ✅ PASSO A PASSO PARA CORRIGIR TUDO

### 1. Abrir Arquivo ad_service.dart
```
Localização: lib/services/ad_service.dart
```

### 2. Verificar Getters
Procure por linhas com:
```dart
static String get bannerUnitId
static String get interstitialUnitId
```

Se não existem, adicione-as.

### 3. Abrir Arquivo ad_revenue_optimizer.dart
```
Localização: lib/services/ad_revenue_optimizer.dart
```

### 4. Adicionar Campo _performanceData
No topo da classe, adicione:
```dart
class AdRevenueOptimizer {
  late final Map<String, AdPerformanceData> _performanceData = {};
  // ... resto
}
```

### 5. Remover Parênteses em Chamadas
Procure por:
```dart
AdService.bannerUnitId()  // Mudar para:
AdService.bannerUnitId    // Sem parênteses
```

### 6. Executar Limpeza
```bash
cd C:\Users\Lorena\StudioProjects\Finwase\gastos_manager
flutter clean
flutter pub get
```

### 7. Tentar Compilar
```bash
flutter build appbundle --release
```

---

## 📋 CHECKLIST DE CORREÇÃO

- [ ] Getters em `ad_service.dart` existem
- [ ] Campo `_performanceData` declarado em `ad_revenue_optimizer.dart`
- [ ] Não há parênteses em `AdService.bannerUnitId()` (deve ser sem)
- [ ] Arquivo `package_config.json` regenerado (flutter pub get)
- [ ] `flutter clean` executado
- [ ] Compilação sem erros

---

## 🚀 PRÓXIMO: ATIVAR MODO DE PRODUÇÃO

Após corrigir todos os erros:

1. Em `ad_service.dart`, mude:
```dart
static bool _isTestMode = false;  // Ativar modo de produção
```

2. Adicione IDs de produção reais do AdMob

3. Compile:
```bash
flutter build appbundle --release
```

4. Publique no Play Store

---

**📅 Última atualização:** 07/12/2025
**✅ Status:** Instruções de correção completas


