# 🚀 GUIA COMPLETO - CORRIGIR E PUBLICAR NO PLAY STORE

## ❌ PROBLEMAS IDENTIFICADOS

1. **Certificado SHA1 Incorreto**
   - Esperado: `19:2E:C6:69:11:E8:BD:47:D9:AB:47:7B:5F:81:76:7C:40:C9:78:4F`
   - Recebido: `AA:A2:2A:1A:83:EE:8A:73:46:72:F0:EF:12:9F:32:BB:C4:FD:A1:81`

2. **VersionCode Duplicado**
   - versionCode 6 e 7 já foram usados
   - Próximo: versionCode 8

3. **Faltam IDs de Anúncios de Produção**
   - Banner ID: `ca-app-pub-6846955506912398/9999999999` (INVÁLIDO)
   - Interstitial ID: `ca-app-pub-6846955506912398/8888888888` (INVÁLIDO)
   - Rewarded ID: `ca-app-pub-6846955506912398/7777777777` (INVÁLIDO)

4. **Modo de Teste Ativado**
   - `_isTestMode = true` - deve ser `false` para produção

5. **app-ads.txt não Verificado**
   - Arquivo faltando no site do desenvolvedor

---

## ✅ SOLUÇÃO PASSO A PASSO

### PASSO 1: CORRIGIR A CHAVE DE ASSINATURA

1. **Gerar novo keystore com a chave correta:**

```bash
keytool -genkey -v -keystore C:\Users\Lorena\.android\finwise.keystore `
  -keyalg RSA -keysize 2048 -validity 10000 `
  -alias finwise `
  -storepass SENHA_AQUI `
  -keypass SENHA_AQUI `
  -dname "CN=Finwise,O=Lorecout,L=Brazil,S=SP,C=BR"
```

2. **Depois, obtenha o SHA1:**

```bash
keytool -list -v -keystore C:\Users\Lorena\.android\finwise.keystore `
  -alias finwise -storepass SENHA_AQUI
```

3. **Copie o SHA1 resultante e coloque no Google Play Console**

---

### PASSO 2: ATUALIZAR VERSION CODE

**Arquivo: `pubspec.yaml`**

```yaml
# ANTES
version: 1.0.8+10

# DEPOIS
version: 1.0.8+8
```

---

### PASSO 3: DESATIVAR MODO DE TESTE

**Arquivo: `lib/services/ad_service.dart`**

Altere:
```dart
// ANTES
static bool _isTestMode = true;

// DEPOIS  
static bool _isTestMode = false;
```

---

### PASSO 4: ATUALIZAR IDs DE ANÚNCIOS DE PRODUÇÃO

**Arquivo: `lib/services/ad_service.dart`**

```dart
// OBTENHA ESSES IDs DO GOOGLE ADMOB CONSOLE
static const String _prodBannerId = 'ca-app-pub-6846955506912398/XXXXXXXXX';
static const String _prodInterstitialId = 'ca-app-pub-6846955506912398/YYYYYYYYY';
static const String _prodRewardedId = 'ca-app-pub-6846955506912398/ZZZZZZZZZ';
```

---

### PASSO 5: REMOVER ABA DE TESTE (OPCIONAL)

Se há uma aba "Billing Test" nas configurações, remova a referência.

---

### PASSO 6: COMPILAR PARA RELEASE

```bash
cd C:\Users\Lorena\StudioProjects\Finwase\gastos_manager

# Limpar
flutter clean
flutter pub get

# Compilar AAB
flutter build appbundle --release
```

**Arquivo gerado:**
```
build/app/outputs/bundle/release/app-release.aab
```

---

### PASSO 7: ENVIAR AO PLAY CONSOLE

1. Abra: https://play.google.com/console
2. Selecione seu app: "FinWise"
3. Vá em: **Versão de Teste > Testes Internos** (ou Produção)
4. Clique em: **Criar Release**
5. Carregue: `app-release.aab`
6. Revise e publique

---

### PASSO 8: CONFIGURAR app-ads.txt

**Seu domínio:** https://lorecout.github.io/

**Criar arquivo:** `https://lorecout.github.io/app-ads.txt`

**Conteúdo:**
```
google.com, pub-6846955506912398, DIRECT, f08c47fec0942fa0
```

**Verificar no Play Console:**
1. Vá em: **Publicação > App Integrity**
2. Clique em: **Verificar app-ads.txt**
3. Aguarde 24 horas para verificação completa

---

## 🔍 CHECKLIST FINAL

- [ ] SHA1 da chave de assinatura atualizado no Google Play Console
- [ ] versionCode aumentado para 8
- [ ] Modo de teste desativado (`_isTestMode = false`)
- [ ] IDs de anúncios de produção preenchidos (obtenha do AdMob Console)
- [ ] AppBundle compilado com `flutter build appbundle --release`
- [ ] AppBundle enviado ao Play Console
- [ ] app-ads.txt criado e publicado no site
- [ ] Google Play Console aguardando aprovação

---

## ⚠️ PROBLEMAS COMUNS

### "O certificado usado para assinar o App Bundle não corresponde"
→ Use o mesmo keystore no `build.gradle` que foi registrado no Play Console

### "VersionCode já foi usado"
→ Aumente para um número maior que qualquer versão anterior enviada

### "app-ads.txt não pode ser encontrado"
→ Certifique-se de publicar em `https://seusite.com/app-ads.txt` (root)

### "Anúncios não geram receita"
→ Certifique-se de estar com `_isTestMode = false` em produção

---

## 📞 SUPORTE

Se encontrar problemas, verifique:
1. Google Play Console: https://play.google.com/console
2. Google AdMob: https://admob.google.com
3. Firebase Console: https://console.firebase.google.com

