# gastos_manager

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Monetização com Anúncios

Este app inclui suporte para anúncios do Google AdMob para monetização da versão gratuita.

### ✅ Status da Configuração
- Em debug, o app usa automaticamente IDs de TESTE oficiais do Google.
- Em release, IDs de produção são usados (definidos no código) e minify/shrink estão habilitados.
- App ID (Android): `ca-app-pub-6846955506912398~2473407367`
- Banner (prod): `ca-app-pub-6846955506912398/2600398827`
- Interstitial (prod): `ca-app-pub-6846955506912398/7605313496`

### 📱 Funcionalidades Ativas
- Banner: Exibido no app para usuários não premium
- Intersticial: Exibido conforme frequência configurada
- Recompensado: Desbloqueia recursos premium temporariamente
- Inicialização Condicional: Anúncios só carregam para usuários gratuitos

### Teste dos Anúncios

- Em debug, a SDK mostrará “This request is sent from a test device”.
- Use dispositivos reais quando possível para validar UX.
- Os IDs de teste nunca geram receita real.

⚠️ IMPORTANTE
- Evite publicar builds de debug com contas/lojas reais.
- Revise políticas de conteúdo de anúncios do Google.

## Checklist de Publicação (Android)

- [x] keystore configurado e key.properties presente (não versionar)
- [x] buildTypes.release com minifyEnabled e shrinkResources
- [x] proguard-rules.pro com regras para Firebase/Ads/Flutter
- [x] Manifest com POST_NOTIFICATIONS (Android 13+)
- [x] App Check: Play Integrity em release; debug opcional via flag
