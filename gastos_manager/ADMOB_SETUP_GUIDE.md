# 🎯 GUIA COMPLETO - CONFIGURAR ADMOB PARA PRODUÇÃO

## ✅ Status Atual
- ✅ versionCode atualizado para 8
- ✅ Modo de teste desativado (`_isTestMode = false`)
- ❌ **IDs DE PRODUÇÃO AINDA SÃO PLACEHOLDERS** (URGENTE!)

---

## 🚨 PROBLEMA CRÍTICO

Seus IDs de anúncios estão como PLACEHOLDERS:
```dart
_prodBannerId = 'ca-app-pub-6846955506912398/9999999999'  ❌
_prodInterstitialId = 'ca-app-pub-6846955506912398/8888888888'  ❌
_prodRewardedId = 'ca-app-pub-6846955506912398/7777777777'  ❌
```

**Isso significa:** Seu app NÃO vai exibir anúncios reais em produção!

---

## 🔑 COMO OBTER OS IDs REAIS

### PASSO 1: Acessar Google AdMob
1. Vá para: https://admob.google.com
2. Faça login com sua conta Google (mesma do Firebase)
3. No painel, você verá seu App ID: **ca-app-pub-6846955506912398~2473407367** ✅

### PASSO 2: Criar Unidades de Anúncios
1. Clique em **Apps** → Seu app (FinWise)
2. Clique em **Ad Units** (Unidades de Anúncios)
3. Para cada tipo, crie uma unidade:

#### 3.1 BANNER
- Clique em **+**
- Selecione: **Banner**
- Nome: "App Banner"
- Tamanho: **320x50** ou **320x100**
- Clique em **Create**
- **COPIE O ID** que aparecer (ex: `ca-app-pub-6846955506912398/1234567890`)

#### 3.2 INTERSTITIAL
- Clique em **+**
- Selecione: **Interstitial**
- Nome: "App Interstitial"
- Clique em **Create**
- **COPIE O ID** que aparecer

#### 3.3 REWARDED
- Clique em **+**
- Selecione: **Rewarded**
- Nome: "App Rewarded"
- Clique em **Create**
- **COPIE O ID** que aparecer

---

## 📝 ATUALIZAR O CÓDIGO

Agora que você tem os IDs reais, atualize o arquivo:
**`lib/services/ad_service.dart`**

Procure por:
```dart
  static const String _prodBannerId = 'ca-app-pub-6846955506912398/9999999999';
  static const String _prodInterstitialId = 'ca-app-pub-6846955506912398/8888888888';
  static const String _prodRewardedId = 'ca-app-pub-6846955506912398/7777777777';
```

E substitua pelos IDs reais que você copiou:
```dart
  static const String _prodBannerId = 'ca-app-pub-6846955506912398/XXXXX';  // Seu ID real
  static const String _prodInterstitialId = 'ca-app-pub-6846955506912398/YYYYY';  // Seu ID real
  static const String _prodRewardedId = 'ca-app-pub-6846955506912398/ZZZZZ';  // Seu ID real
```

---

## ✅ CHECKLIST PRÉ-COMPILAÇÃO

- [ ] Acessei https://admob.google.com
- [ ] Criei 3 unidades de anúncios (Banner, Interstitial, Rewarded)
- [ ] Copiei os 3 IDs reais
- [ ] Atualizei `ad_service.dart` com os IDs reais
- [ ] Verifiquei que `_isTestMode = false`
- [ ] Verifiquei que `versionCode = 8` no pubspec.yaml

---

## 🔄 PRÓXIMOS PASSOS

Depois de atualizar os IDs:

```bash
# Terminal - Na pasta do projeto
cd C:\Users\Lorena\StudioProjects\Finwase\gastos_manager

# 1. Limpar e obter dependências
flutter clean
flutter pub get

# 2. Compilar para release
flutter build appbundle --release

# 3. O arquivo gerado será:
# build/app/outputs/bundle/release/app-release.aab
```

---

## 📊 VERIFICAR RECEITA

Depois de publicar:

1. Vá em: https://admob.google.com
2. No dashboard, você verá:
   - **Impressões** (vezes que anúncios foram mostrados)
   - **Cliques** (vezes que clicaram no anúncio)
   - **Receita Estimada** (ganhos)

---

## ⚠️ AVISOS IMPORTANTES

### ❌ Não Faça Isso (Violará Políticas do Google)
- Clicar seus próprios anúncios
- Pedir para amigos clicarem
- Usar bots para gerar cliques
- Modificar o app para gerar cliques automáticos

### ✅ Faça Isso (Boas Práticas)
- Deixe usuários reais clicarem naturalmente
- Coloque anúncios em locais estratégicos
- Ofereça algo de valor (conteúdo, funcionalidade)
- Monitore métricas regularmente

---

## 🆘 TROUBLESHOOTING

### "Anúncios não aparecem"
→ Verifique se os IDs estão corretos e `_isTestMode = false`

### "Receita zerada"
→ Pode levar 24-48 horas para começar a registrar receita

### "App rejeitado pelo Play Store"
→ Verifique se todos os IDs estão preenchidos corretamente

---

## 📞 LINKS ÚTEIS
- AdMob: https://admob.google.com
- Play Console: https://play.google.com/console
- Firebase: https://console.firebase.google.com
- Documentação Google Mobile Ads: https://pub.dev/packages/google_mobile_ads

