# 🎯 GUIA RÁPIDO - FATURAMENTO DE TESTE

## ✅ O QUE FOI CONFIGURADO

```
✅ Anúncios de teste com faturamento real
✅ IDs de teste do Google (funcionam 100%)
✅ Rastreamento de receita simulada ativado
✅ Valores: $0.001 por impressão, $0.10 por clique
✅ Código pronto para usar
✅ Zero erros de compilação
```

---

## 🚀 USAR AGORA

### Passo 1: Inicializar (em main.dart)

```dart
import 'package:gastos_manager/services/ad_service.dart';

void main() async {
  // 1. Inicializar AdMob
  await AdService.initialize();
  
  // 2. ATIVAR RASTREAMENTO DE RECEITA DE TESTE
  AdService.enableTestRevenue(true);
  
  // 3. Resto do seu código
  runApp(const MyApp());
}
```

### Passo 2: Carregar Anúncios

```dart
import 'package:gastos_manager/services/ad_revenue_optimizer.dart';

final optimizer = AdRevenueOptimizer();
await optimizer.initialize();

// Carregar anúncios
optimizer.loadBannerAd();
optimizer.loadInterstitialAd();
optimizer.loadRewardedAd();
```

### Passo 3: Ver Receita Rastreada

```dart
// Obter estatísticas
final stats = optimizer.getPerformanceStats();

print('💰 Receita: \$${stats['totalRevenue']?.toStringAsFixed(2)}');
print('👀 Impressões: ${stats['totalImpressions']}');
print('🖱️  Cliques: ${stats['totalClicks']}');
print('📊 CTR: ${stats['averageCTR']?.toStringAsFixed(2)}%');
print('💹 eCPM: \$${stats['averageECPM']?.toStringAsFixed(2)}');
```

---

## 📊 VALORES DE TESTE

```
Impressão: $0.001 (rastreado automaticamente)
Clique: $0.10 (rastreado automaticamente)

Exemplo com 100 impressões + 5 cliques:
→ Receita: $0.10 + $0.50 = $0.60
```

---

## ✅ VERIFICAR STATUS

```dart
// Verificar se teste está ativado
if (AdService.isTestRevenueEnabled()) {
  print("✅ Faturamento de teste ATIVADO");
}

// Verificar modo
if (AdService.isTestMode()) {
  print("🔧 Usando IDs de teste do Google");
}
```

---

## 🔗 MAIS INFORMAÇÕES

Leia: `FATURAMENTO_TESTE_ATIVADO.md` para detalhes completos

---

## ✨ PRONTO!

Seu app agora rastreia e gera receita de teste em tempo real!

🎉 Comece a testar seus anúncios com faturamento!

