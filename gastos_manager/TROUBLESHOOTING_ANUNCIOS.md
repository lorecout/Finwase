# 🔧 Troubleshooting e FAQ - Anúncios AdMob

## ❓ Perguntas Frequentes

### 1. "Por que meus anúncios não aparecem?"

**Respostas possíveis:**

#### A) Você está usando conta Premium
- **Solução:** Teste com conta gratuita
- **Como verificar:**
  ```dart
  // Adicione debug no dashboard_page_clean.dart
  print('É premium? ${premiumService.isPremium}');
  print('Deve mostrar ads? ${AdService.shouldShowAds(context)}');
  ```

#### B) IDs de teste vs produção
- **IDs de teste** (funcionam imediatamente):
  ```dart
  Banner: 'ca-app-pub-3940256099942544/6300978111'
  Interstitial: 'ca-app-pub-3940256099942544/1033173712'
  ```
- **IDs de produção** (podem demorar 24-48h para ativar):
  ```dart
  Banner: 'ca-app-pub-6846955506912398/2600398827'
  Interstitial: 'ca-app-pub-6846955506912398/7605313496'
  ```

#### C) App não está vinculado no AdMob
1. Acesse [admob.google.com](https://admob.google.com/)
2. Apps → Adicionar app existente
3. Busque por `com.lorecout.finans`
4. Se não encontrar, adicione manualmente

#### D) Unidades em análise
- Novas unidades de anúncio podem levar até 48h para serem aprovadas
- Durante esse período, use IDs de teste

---

### 2. "Como sei se os anúncios estão carregando?"

**Verificar logs:**
```powershell
# Ver logs em tempo real
flutter logs

# Procure por estas mensagens:
# ✅ ADMOB: AdMob inicializado com sucesso
# ✅ ADMOB: Banner carregado com sucesso
# 📺 ADMOB: Intersticial exibido
```

**Adicionar logs extras:**
```dart
// Em ad_banner_widget.dart, no método _loadAd():
debugPrint('🔍 Tentando carregar banner...');
debugPrint('🔍 Ad Unit ID: ${AdService.bannerAdUnitId}');
debugPrint('🔍 AdMob inicializado? ${AdService.isInitialized}');
```

---

### 3. "Por que não estou ganhando dinheiro?"

**Checklist:**

1. **Volume de usuários:**
   - Precisa de MUITOS usuários para gerar receita significativa
   - Mínimo recomendado: 1000 usuários ativos/dia

2. **Impressões de anúncios:**
   - Verifique no AdMob Dashboard
   - Poucos usuários = poucas impressões = pouca receita

3. **Taxa de preenchimento:**
   - Veja no AdMob Dashboard
   - Se < 50%, pode ter problema de configuração
   - Se > 80%, está normal

4. **eCPM baixo:**
   - eCPM varia MUITO por país/categoria
   - Brasil: R$ 0,20 - R$ 2,00 tipicamente
   - Nicho financeiro costuma ter eCPM mais alto

5. **Cliques:**
   - Banners geralmente têm CTR de 1-3%
   - Intersticiais: 5-10%
   - Se muito baixo, melhore posicionamento

**Fórmula de receita:**
```
Receita = (Impressões / 1000) × eCPM
Exemplo: (10.000 / 1000) × R$ 0,80 = R$ 8,00
```

---

### 4. "Quanto tempo demora para receber pagamento?"

**Timeline AdMob:**
1. **Fim do mês:** AdMob fecha estatísticas
2. **Dia 3 do mês seguinte:** Receitas finalizadas
3. **Dia 21-26:** Pagamento processado
4. **Mínimo:** R$ 100 acumulados (ou US$ 100 dependendo da moeda)

**Exemplo:**
- Janeiro: Ganhou R$ 45
- Fevereiro: Ganhou R$ 60 (Total: R$ 105)
- Março: Receberá os R$ 105 entre dias 21-26

---

### 5. "Posso clicar nos meus próprios anúncios para testar?"

**❌ NÃO! Isso pode suspender sua conta AdMob!**

**Como testar corretamente:**
1. Use **dispositivos de teste** registrados no AdMob
2. Configure dispositivo de teste:
   ```dart
   // Em main.dart, antes de MobileAds.instance.initialize()
   final testDeviceIds = ['SEU_DEVICE_ID_AQUI'];
   final configuration = RequestConfiguration(testDeviceIds: testDeviceIds);
   MobileAds.instance.updateRequestConfiguration(configuration);
   ```

3. **Como obter seu Device ID:**
   - Rode o app uma vez
   - Veja nos logs: "Use RequestConfiguration.Builder().setTestDeviceIds(Arrays.asList("33BE2250B43518CCDA7DE426D04EE231"))"
   - Copie o ID entre aspas

---

### 6. "Meus anúncios são muito invasivos?"

**Sinais de que sim:**
- Usuários reclamam
- Taxa de desinstalação alta
- Muitos usuários comprando Premium só para remover anúncios

**Soluções:**
1. **Reduzir frequência de intersticiais:**
   ```dart
   // Em ad_service.dart
   static const int _interstitialFrequency = 5; // Era 3
   ```

2. **Remover banners de telas críticas:**
   - Não coloque banner em telas de login/cadastro
   - Evite em formulários importantes

3. **Timing inteligente:**
   ```dart
   // Não mostrar intersticial se usuário estiver no app há < 1 minuto
   static DateTime? _appOpenTime;
   
   static bool _canShowInterstitial() {
     if (_appOpenTime == null) {
       _appOpenTime = DateTime.now();
       return false;
     }
     return DateTime.now().difference(_appOpenTime!).inMinutes >= 1;
   }
   ```

4. **Feedback dos usuários:**
   - Adicione opção "Reportar anúncio inapropriado"
   - Pergunte: "Os anúncios estão muito frequentes?"

---

### 7. "Como aumentar minhas receitas?"

**Estratégias comprovadas:**

#### A) Mais usuários
- **Marketing:** Redes sociais, SEO, influencers
- **ASO:** Otimize listagem na Play Store
- **Referral:** Sistema de indicação

#### B) Mais impressões por usuário
- Adicione banners em mais telas (sem exagerar)
- Use **native ads** (se mistura com conteúdo)
- Aumente tempo de sessão (melhor UX)

#### C) Maior eCPM
- **Mediação:** Use Firebase AdMob Mediation (múltiplas redes)
- **Localização:** Foque em países com eCPM alto (EUA, UK, Canadá)
- **Otimização:** Teste diferentes posições e formatos

#### D) Rewarded Ads
- Maior eCPM (~R$ 5-10)
- Usuário escolhe assistir = melhor UX
- Exemplo: "Assistir ad para desbloquear recurso X"

#### E) A/B Testing
```dart
// Teste diferentes posicionamentos
// Grupo A: Banner no topo
// Grupo B: Banner no rodapé
// Veja qual gera mais receita
```

---

## 🔍 Códigos de Erro Comuns

### Erro: "ERROR_CODE_NO_FILL"
**Significado:** Não há anúncio disponível para mostrar
**Causas:**
- Baixa demanda de anunciantes na sua região
- App novo sem histórico
- Categoria do app com pouca demanda

**Soluções:**
1. Normal em apps novos (melhora com tempo)
2. Configure mediação (múltiplas redes de anúncios)
3. Verifique categoria do app no AdMob

---

### Erro: "ERROR_CODE_NETWORK_ERROR"
**Significado:** Problema de conexão
**Soluções:**
1. Verifique internet do dispositivo
2. Adicione tratamento de retry:
   ```dart
   // Tentar novamente após 5 segundos
   Future.delayed(Duration(seconds: 5), () {
     _loadAd();
   });
   ```

---

### Erro: "ERROR_CODE_INVALID_REQUEST"
**Significado:** Requisição mal formada
**Causas:**
- ID de unidade incorreto
- App não vinculado no AdMob
- AndroidManifest sem App ID

**Soluções:**
1. Verifique IDs no ad_service.dart
2. Confirme App ID no AndroidManifest.xml
3. Reconstrua o app (flutter clean)

---

### Erro: "ERROR_CODE_APP_ID_MISSING"
**Significado:** App ID não configurado no AndroidManifest
**Solução:**
```xml
<!-- AndroidManifest.xml -->
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-6846955506912398~2473407367"/>
```

---

## 🛠️ Scripts de Debugging

### Script 1: Verificar configuração completa
```dart
// Em main.dart, após inicialização
void _debugAdConfig() {
  debugPrint('═══════════════════════════════════');
  debugPrint('📊 CONFIGURAÇÃO DE ANÚNCIOS');
  debugPrint('═══════════════════════════════════');
  debugPrint('Inicializado: ${AdService.isInitialized}');
  debugPrint('Banner ID: ${AdService.bannerAdUnitId}');
  debugPrint('Interstitial ID: ${AdService.interstitialAdUnitId}');
  debugPrint('Plataforma: ${Platform.operatingSystem}');
  debugPrint('═══════════════════════════════════');
}
```

### Script 2: Forçar logs detalhados
```dart
// Em ad_service.dart
static const bool _debugMode = true; // Mude para true

static void _log(String message) {
  if (_debugMode) {
    debugPrint('[AdService] $message');
  }
}

// Use _log() em todos os métodos
```

### Script 3: Simular anúncio
```dart
// Para testar layout sem esperar anúncio real
class MockAdBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.grey[300],
      child: Center(
        child: Text('MOCK ANÚNCIO (Teste Layout)'),
      ),
    );
  }
}
```

---

## 📊 Monitoramento Avançado

### Analytics Custom Events
```dart
// Rastrear quando anúncios são mostrados
import 'package:firebase_analytics/firebase_analytics.dart';

static void _logAdImpression(String adType) {
  FirebaseAnalytics.instance.logEvent(
    name: 'ad_impression',
    parameters: {
      'ad_type': adType,
      'timestamp': DateTime.now().toIso8601String(),
    },
  );
}

// Use ao carregar banner
_logAdImpression('banner');

// Use ao mostrar intersticial
_logAdImpression('interstitial');
```

### Dashboard Custom
```dart
// Criar tela admin para ver métricas
class AdminAdsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Métricas de Anúncios')),
      body: Column(
        children: [
          _metricCard('Banners carregados', '123'),
          _metricCard('Intersticiais mostrados', '45'),
          _metricCard('Falhas de carregamento', '7'),
          _metricCard('Taxa de sucesso', '94%'),
        ],
      ),
    );
  }
  
  Widget _metricCard(String title, String value) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: Text(
          value,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
```

---

## 🚨 Problemas Graves

### Conta AdMob Suspensa
**Causas comuns:**
- Cliques inválidos (auto-clicar)
- Tráfego inválido (bots)
- Conteúdo proibido
- Violação de políticas

**O que fazer:**
1. **Não entre em pânico**
2. Leia o email do AdMob cuidadosamente
3. Se foi erro, apele via formulário oficial
4. Revise políticas: [support.google.com/admob/answer/6128543](https://support.google.com/admob/answer/6128543)

**Prevenção:**
- NUNCA clique nos seus anúncios
- NUNCA peça para outros clicarem
- Use sempre IDs de teste durante desenvolvimento
- Respeite todas as políticas

---

### Violação de Políticas da Play Store
**Políticas relacionadas a anúncios:**
1. **Anúncios devem ser claramente identificáveis**
2. **Não bloquear conteúdo essencial**
3. **Não anúncios inesperados/invasivos**
4. **Declarar uso de AdMob na listagem**

**Checklist de conformidade:**
- [ ] Anúncios não impedem uso do app
- [ ] Usuário pode fechar intersticiais
- [ ] Banners não cobrem botões importantes
- [ ] Declarado na seção "Privacidade" da Play Store
- [ ] Política de privacidade menciona AdMob

---

## 💡 Dicas Profissionais

### 1. Use Firebase Performance Monitoring
```dart
// Ver impacto dos anúncios na performance
import 'package:firebase_performance/firebase_performance.dart';

final trace = FirebasePerformance.instance.newTrace('ad_load');
await trace.start();
// ... carregar anúncio ...
await trace.stop();
```

### 2. Cache de Intersticiais
```dart
// Pré-carregar interstitial para exibição rápida
static InterstitialAd? _cachedInterstitial;

static Future<void> preloadInterstitial() async {
  _cachedInterstitial = await createInterstitialAd();
}

static Future<void> showCachedInterstitial() async {
  if (_cachedInterstitial != null) {
    await _cachedInterstitial!.show();
    _cachedInterstitial = null;
    preloadInterstitial(); // Carregar próximo
  }
}
```

### 3. Anúncios Contextuais
```dart
// Mostrar anúncios relevantes ao conteúdo
AdRequest(
  keywords: ['finanças', 'investimentos', 'economia'],
  contentUrl: 'https://seuapp.com/financas',
);
```

### 4. Teste com Frequência
```powershell
# Automatize testes semanais
.\testar_anuncios.ps1
```

---

## 📚 Recursos Adicionais

### Documentação Oficial
- [AdMob Help Center](https://support.google.com/admob)
- [Flutter google_mobile_ads](https://pub.dev/packages/google_mobile_ads)
- [Políticas do AdMob](https://support.google.com/admob/answer/6128543)
- [Best Practices](https://developers.google.com/admob/android/banner/best-practices)

### Comunidade
- [Reddit r/admob](https://reddit.com/r/admob)
- [Stack Overflow [admob] tag](https://stackoverflow.com/questions/tagged/admob)
- [Flutter Discord](https://discord.com/invite/flutter)

### Ferramentas
- [AdMob Policy Center](https://support.google.com/admob/topic/7384018)
- [Firebase Console](https://console.firebase.google.com/)
- [Play Console](https://play.google.com/console/)

---

## 🎯 Próximos Passos

Após resolver qualquer problema:
1. ✅ Documente a solução encontrada
2. ✅ Atualize seus scripts de teste
3. ✅ Adicione verificações preventivas
4. ✅ Monitore métricas regularmente
5. ✅ Otimize baseado em dados reais

---

**Lembre-se:** Monetização é um processo iterativo. Teste, medir, otimize, repita! 🚀

**Sucesso!** 💰
