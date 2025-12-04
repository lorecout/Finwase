# 💰 Guia de Monetização - FinWise

Data: 04 de dezembro de 2025

---

## 📊 Visão Geral

O FinWise já tem infraestrutura de monetização implementada:
- ✅ Google AdMob (banners, intersticiais, recompensados)
- ✅ In-App Purchases (Premium R$ 9,90/mês)
- ✅ Sistema de otimização de anúncios
- ✅ Configuração de frequência de anúncios

---

## 🚀 PASSO 1: Configurar Google AdMob (5 min)

### 1.1 Criar/Acessar conta Google AdMob
```
URL: https://admob.google.com
1. Faça login com sua conta Google
2. Se for primeira vez, clique em "Começar"
```

### 1.2 Registrar seu app
```
1. Clique em: "+ App"
2. Preencha:
   - Nome do app: FinWise
   - Plataforma: Android
   - Categoria: Finanças/Produtividade
3. Clique em: "Criar"
```

### 1.3 Copiar App ID do AdMob
```
1. Vá em: Configurações > Apps
2. Procure por: FinWise
3. Copie o: "App ID" (formato: ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy)
4. Cole em: lib/constants/ad_constants.dart > admobAppId
```

### 1.4 Criar Ad Units (Anúncios)

#### Banner Ads
```
1. Clique em: "+ Ad unit"
2. Nome: "Banner - Home"
3. Tipo: "Banner"
4. Formato: "320x50" ou "320x100"
5. Copie o ID gerado (formato: ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx)
6. Cole em: ad_constants.dart > bannerAdUnitId
```

#### Interstitial Ads
```
1. Clique em: "+ Ad unit"
2. Nome: "Interstitial - Transações"
3. Tipo: "Interstitial"
4. Copie o ID gerado
5. Cole em: ad_constants.dart > interstitialAdUnitId
```

#### Rewarded Ads
```
1. Clique em: "+ Ad unit"
2. Nome: "Rewarded - Bônus"
3. Tipo: "Rewarded"
4. Copie o ID gerado
5. Cole em: ad_constants.dart > rewardedAdUnitId
```

---

## 🛒 PASSO 2: Configurar In-App Purchases (10 min)

### 2.1 Acessar Play Console
```
URL: https://play.google.com/console
1. Selecione seu app: FinWise
2. Vá em: "Monetização" > "Produtos no app"
```

### 2.2 Criar Produto Premium Mensal
```
1. Clique em: "+ Criar produto"
2. Preencha:
   - ID do produto: finwise_premium_monthly
   - Nome: Premium Mensal
   - Descrição: Acesso ao plano premium por 1 mês
   - Preço: R$ 9,90
   - País: Brasil
3. Clique em: "Salvar"
4. Copie o ID para: ad_constants.dart > premiumMonthlyProductId
```

### 2.3 Criar Produto Premium Anual (RECOMENDADO)
```
1. Clique em: "+ Criar produto"
2. Preencha:
   - ID do produto: finwise_premium_yearly
   - Nome: Premium Anual
   - Descrição: Acesso ao plano premium por 12 meses (25% desconto)
   - Preço: R$ 79,90
   - País: Brasil
   - Período de cobrança: Renovação automática anual
3. Clique em: "Salvar"
4. Copie o ID para: ad_constants.dart > premiumYearlyProductId
```

### 2.4 Criar Produto Lifetime (Opcional)
```
1. Clique em: "+ Criar produto"
2. Preencha:
   - ID do produto: finwise_premium_lifetime
   - Nome: Premium Vitalício
   - Descrição: Acesso permanente ao premium
   - Preço: R$ 199,90
   - Tipo: Único (não renovável)
3. Clique em: "Salvar"
```

---

## 🔧 PASSO 3: Configurar no Projeto Flutter

### 3.1 Adicionar IDs ao AndroidManifest.xml
```xml
<!-- android/app/src/main/AndroidManifest.xml -->

<!-- Adicionar dentro de <manifest> -->
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>
```

### 3.2 Atualizar ad_constants.dart
```dart
// lib/constants/ad_constants.dart

class AdConstants {
  // Substitua pelos seus IDs reais do AdMob
  static const String admobAppId = 'ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy';
  static const String bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String interstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';
  static const String rewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';

  // In-App Products
  static const String premiumMonthlyProductId = 'finwise_premium_monthly';
  static const String premiumYearlyProductId = 'finwise_premium_yearly';
  static const String premiumLifetimeProductId = 'finwise_premium_lifetime';
}
```

### 3.3 Testar com IDs de Teste do Google
```dart
// Durante desenvolvimento, use IDs de teste (não geram receita)
// Após testes bem-sucedidos, troque pelos IDs reais

// IDs de teste do Google AdMob:
const String GOOGLE_BANNER_AD_ID = 'ca-app-pub-3940256099942544/6300978111';
const String GOOGLE_INTERSTITIAL_AD_ID = 'ca-app-pub-3940256099942544/1033173712';
const String GOOGLE_REWARDED_AD_ID = 'ca-app-pub-3940256099942544/5224354917';
```

---

## 📱 PASSO 4: Testar Monetização

### 4.1 Testar Anúncios
```bash
cd gastos_manager
flutter run --debug
```

Espere ver:
- Anúncios banners na home
- Intersticiais ao criar transações
- Opção de assistir anúncio recompensado

### 4.2 Testar In-App Purchases
```
1. Acesse: Configurações > Upgrade Premium
2. Clique em: "Premium Mensal"
3. Deve abrir a tela de compra do Play
4. Use tester account do Play Console (não cobra)
```

---

## ✅ CHECKLIST DE MONETIZAÇÃO

| Item | Status | Data |
|------|--------|------|
| Google AdMob Account criada | ⏳ | - |
| App registrado no AdMob | ⏳ | - |
| App ID copiado | ⏳ | - |
| Banner Ad Unit criada | ⏳ | - |
| Interstitial Ad Unit criada | ⏳ | - |
| Rewarded Ad Unit criada | ⏳ | - |
| Play Console monetização ativada | ✅ | - |
| Produto Premium criado | ✅ | - |
| IDs copiados para ad_constants.dart | ⏳ | - |
| AndroidManifest.xml atualizado | ⏳ | - |
| Anúncios testados | ⏳ | - |
| In-App Purchases testadas | ⏳ | - |
| AAB enviado com config de ads | ✅ | 03/12 |

---

## 💡 DICAS DE MONETIZAÇÃO

### 1. Frequência de Anúncios
```dart
// Não mostre muitos anúncios = Usuários deletam o app
// Mostre poucos = Pouca receita

// Recomendação do Google:
// - 1 interstitial a cada 5 ações
// - 1 rewarded a cada 10 ações
// - Banners contínuos (não incomodam)
```

### 2. Estratégia de Preços
```
Mensal: R$ 9,90 (entrada de usuários)
Anual: R$ 79,90 (melhor conversão, 25% desconto)
Lifetime: R$ 199,90 (power users)
```

### 3. Ordem de Prioridade
```
1º - Mostrar anúncios grátis
2º - Oferecer Premium após 7 dias
3º - Bloqueadores de anúncios para Premium
```

---

## 📊 Métricas para Acompanhar

Após lançar monetização, monitore:

1. **AdMob Dashboard**
   - Impressões por dia
   - Click-through rate (CTR)
   - Earnings (CPM)

2. **Play Console**
   - Número de assinantes
   - Taxa de cancelamento
   - Revenue

3. **Analytics (Firebase)**
   - Usuários que viram anúncios
   - Conversão para premium
   - Retenção

---

## 🔐 Segurança na Monetização

### Proteja contra fraude:
1. ✅ Valide compras no backend
2. ✅ Nunca confie apenas no cliente
3. ✅ Use Server-Side Verification
4. ✅ Monitore padrões suspeitos

### Conformidade:
1. ✅ Política de Reembolso clara
2. ✅ Política de Cancelamento de Assinatura
3. ✅ Termos e Condições atualizados
4. ✅ Conformidade com Lei do Consumidor

---

## 📞 Suporte

**Se tiver dúvidas:**
- Google AdMob Help: https://support.google.com/admob/
- Play Console Help: https://support.google.com/googleplay/android-developer/
- Flutter In-App Purchase: https://pub.dev/packages/in_app_purchase

---

## 🎯 Próximos Passos

1. ✅ Criar conta AdMob
2. ✅ Registrar app no AdMob
3. ✅ Criar Ad Units
4. ✅ Criar Produtos In-App
5. ✅ Atualizar constants do projeto
6. ✅ Testar anúncios e compras
7. ✅ Enviar novo AAB ao Play Console
8. ✅ Monitorar receita

**Status Atual: Passo 1**
