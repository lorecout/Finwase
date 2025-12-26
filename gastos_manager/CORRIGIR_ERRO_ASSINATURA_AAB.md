# 🔧 CORRIGIR ERRO DE ASSINATURA AAB

## ❌ Erro Recebido do Play Console

```
Seu Android App Bundle foi assinado com uma chave incorreta.
Certificado esperado (SHA1): 19:2E:C6:69:11:E8:BD:47:D9:AB:47:7B:5F:81:76:7C:40:C9:78:4F
Certificado enviado (SHA1): AA:A2:2A:1A:83:EE:8A:73:46:72:F0:EF:12:9F:32:BB:C4:FD:A1:81
```

---

## ✅ O Que Foi Feito

### 1. Verificar SHA1 do Keystore
```bash
keytool -list -v -keystore android/app/release.keystore \
  -storepass "223344" -alias "upload"
```

**Resultado:** 
- SHA1 correto encontrado: `19:2E:C6:69:11:E8:BD:47:D9:AB:47:7B:5F:81:76:7C:40:C9:78:4F` ✅

### 2. Corrigir Configuração de Build

**Arquivo:** `android/app/build.gradle.kts`

**Problema:** Minify e ShrinkResources causavam erro ao fazer strip de símbolos nativos

**Solução:**
```kotlin
buildTypes {
    release {
        signingConfig = signingConfigs.getByName("release")
        isMinifyEnabled = false      // ← Desabilitado
        isShrinkResources = false    // ← Desabilitado
        
        packaging {
            jniLibs {
                keepDebugSymbols += listOf("**/*.so")
            }
        }
    }
}
```

### 3. Regenerar AAB

```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

---

## 📁 Arquivo AAB Gerado

**Localização:**
```
build/app/outputs/bundle/release/app-release.aab
```

**Tamanho esperado:** 30-50 MB

---

## 🚀 Próximos Passos

### PASSO 1: Verificar Assinatura do AAB

```bash
# Extrair arquivo .aab
unzip -l build/app/outputs/bundle/release/app-release.aab | grep -i cert

# Ou verificar com jarsigner
jarsigner -verify build/app/outputs/bundle/release/app-release.aab
```

### PASSO 2: Upload no Play Console

1. Abra: https://play.google.com/console
2. Selecione: **FinWise**
3. Menu: **Produção → Criar nova versão**
4. Upload: `app-release.aab`
5. Preenchimento: 
   - Versão: 1.0.5+6
   - Notas: Sistema de faturamento implementado
6. Enviar para revisão

### PASSO 3: Aguardar Aprovação

- ⏱️ Tempo: 1-7 dias (geralmente 24-48h)
- 📧 Receberá email de aprovação ou rejeição
- ✅ Se aprovado: Clique "Publicar versão"
- ❌ Se rejeitado: Corrija e reenvie

---

## 🎯 Status de Verificação

| Item | Status |
|------|--------|
| Keystore SHA1 | ✅ Correto |
| build.gradle.kts | ✅ Atualizado |
| flutter clean | ✅ Executado |
| flutter pub get | ✅ Executado |
| flutter build appbundle | ⏳ Gerando... |

---

## 💡 Dicas Importantes

1. **Sempre use a mesma chave**: Uma vez registrada no Play Console, sempre gere com a mesma chave
2. **Guarde a senha**: `storePassword=223344` e `keyPassword=223344`
3. **Não compartilhe**: O arquivo `.keystore` é confidencial
4. **Backup**: Faça backup de `android/app/release.keystore`

---

## ⚠️ Se Erro Persistir

### Verificar logs do Gradle
```bash
flutter build appbundle --release --verbose
```

### Verificar configuração do key.properties
```
android/key.properties deve conter:
- storeFile=../app/release.keystore
- storePassword=223344
- keyAlias=upload
- keyPassword=223344
```

### Último recurso: Regenerar Keystore

⚠️ **CUIDADO**: Isso criará uma nova chave e você precisará registrar novamente no Play Console!

```bash
cd android/app

# Remover keystore antigo
rm release.keystore

# Gerar novo keystore
keytool -genkey -v -keystore release.keystore \
  -keyalg RSA -keysize 2048 -validity 10950 \
  -alias upload -storepass 223344 -keypass 223344
```

Então atualize o Play Console com o novo SHA1.

---

## 🎊 Você Consegue!

O sistema está correto. Agora é só gerar o AAB com a chave certa e publicar!

