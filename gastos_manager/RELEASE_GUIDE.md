# 🚀 Guia Completo - Release FinWise para Google Play

## 1️⃣ PREPARAÇÃO INICIAL

### Pré-requisitos
- ✅ Flutter SDK instalado
- ✅ Java SDK 11+ instalado
- ✅ Android SDK instalado
- ✅ Conta Google Play Developer ($ 25)
- ✅ Certificado digital (recomendado, mas não obrigatório para primeira submissão)

### Verificar Versão
```bash
flutter --version
java -version
```

---

## 2️⃣ CONFIGURAR KEYSTORE PARA ASSINATURA

### Gerar Release Keystore

**No Windows (PowerShell):**
```powershell
$JAVA_HOME = "C:\Program Files\Java\jdk-11.0.x"  # Ajuste para sua versão
cd gastos_manager
keytool -genkey -v -keystore key.jks `
    -keyalg RSA -keysize 2048 -validity 10000 `
    -alias finwise-key
```

**No Linux/macOS:**
```bash
keytool -genkey -v -keystore key.jks \
    -keyalg RSA -keysize 2048 -validity 10000 \
    -alias finwise-key
```

### Informações a Fornecer:
```
Keystore password: ██████████
Key password: ██████████
First and Last Name: Developer Name
Organizational Unit: FinWise
Organization: Your Company
City: Your City
State: Your State
Country: BR
```

### ⚠️ SEGURANÇA
- 🔐 **NUNCA** commit `key.jks` para Git
- 🔐 Guardar senha em local seguro
- 🔐 Fazer backup de `key.jks`
- 🔐 Adicionar `key.jks` ao `.gitignore`

---

## 3️⃣ CONFIGURAR ASSINATURA NO ANDROID

Editar `android/app/build.gradle`:

```gradle
android {
    // ... configurações existentes

    signingConfigs {
        release {
            keyAlias = 'finwise-key'
            keyPassword = '█████████'  // Sua senha da chave
            storeFile = file('key.jks')
            storePassword = '█████████'  // Sua senha do keystore
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

---

## 4️⃣ CONFIGURAR APP VERSIONING

Editar `pubspec.yaml`:

```yaml
version: 1.0.0+1

# Notas:
# - Incrementar versão para cada release (ex: 1.0.1, 1.0.2, 1.1.0)
# - Incrementar build number para cada build (ex: +1, +2, +3)
# - Versão MAJOR.MINOR.PATCH é obrigatória
```

---

## 5️⃣ ATUALIZAR INFORMAÇÕES DO APP

### AndroidManifest.xml
Verificar em `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.finwise">
    
    <application
        android:label="FinWise"
        android:icon="@mipmap/ic_launcher"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:allowBackup="false">
        
        <!-- ... resto da configuração -->
    </application>
</manifest>
```

### Ícone do App
- 📱 Icone de alta qualidade em `android/app/src/main/res/mipmap-*/ic_launcher.png`
- 📐 Tamanhos recomendados: 
  - mdpi: 48x48px
  - hdpi: 72x72px
  - xhdpi: 96x96px
  - xxhdpi: 144x144px
  - xxxhdpi: 192x192px

---

## 6️⃣ PREPARAR ASSETS PARA PLAY STORE

### Screenshots (Obrigatórios)
Criar screenshots para todas as telas principais:
- 📸 Home/Dashboard
- 📊 Orçamentos
- 💳 Transações
- ⚙️ Configurações

**Especificações:**
- Dimensões: 1440x2560px (portrait) ou 2560x1440px (landscape)
- Máximo 8 screenshots por idioma
- Formato: JPG ou PNG
- Tamanho máximo: 5 MB por arquivo

### Descrição do App (Play Store)
```
Título curto: FinWise - Gestor de Finanças
Descrição longa:

FinWise é um aplicativo completo de gestão financeira que ajuda você a:

✅ Rastrear todas as suas despesas e receitas
✅ Estabelecer e monitorar orçamentos por categoria
✅ Receber alertas inteligentes quando atingir limites
✅ Analisar padrões de gastos com gráficos detalhados
✅ Fazer backup automático na nuvem
✅ Sincronizar entre dispositivos via Firebase

Recursos:
🎯 Orçamentos Inteligentes - Sugestões automáticas baseadas em gastos
📊 Análises Detalhadas - Gráficos e relatórios completos
🔔 Notificações Push - Lembretes e alertas personalizados
🎁 Programa de Referral - Convide amigos e ganhe prêmios
💎 Modo Premium - Recursos avançados desbloqueados
🔒 Segurança - Sincronização segura com Firebase

Suporte: suporte@finwise.app
Privacidade: https://finwise.app/privacy
```

### Palavras-chave
```
finanças, orçamento, gastos, dinheiro, economia, app, gestor financeiro
```

---

## 7️⃣ BUILD E GERAÇÃO DO APK

### Usar Script Automático (RECOMENDADO)

**Windows (PowerShell):**
```powershell
.\build_release_apk.ps1
```

**Linux/macOS (Bash):**
```bash
chmod +x build_release_apk.sh
./build_release_apk.sh
```

### Ou Comando Manual

```bash
# Limpar build anterior
flutter clean
rm -rf build/

# Gerar APK split por arquitetura (menor tamanho)
flutter build apk --release --split-per-abi

# Gerar App Bundle (recomendado para Play Store)
flutter build appbundle --release
```

### Arquivos de Saída
```
build/app/outputs/flutter-apk/
├── app-armeabi-v7a-release.apk
├── app-arm64-v8a-release.apk
├── app-x86-release.apk
└── app-x86_64-release.apk

build/app/outputs/bundle/release/
└── app-release.aab
```

---

## 8️⃣ TESTAR APK ANTES DE SUBMETER

### Instalar em Dispositivo Real
```bash
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

### Testar Funcionalidades Críticas
- [ ] Login com Google funciona
- [ ] Cadastro de transações salva
- [ ] Orçamentos funcionam
- [ ] Notificações push chegam
- [ ] Anúncios (AdMob) exibem corretamente
- [ ] Sync Firebase funciona
- [ ] Modo offline funciona
- [ ] Modo dark/light funciona

---

## 9️⃣ SUBMETER PARA GOOGLE PLAY CONSOLE

### 1. Criar Aplicação
- Acessar [Google Play Console](https://play.google.com/console)
- Clicar "Criar aplicativo"
- Preencher informações básicas

### 2. Configurar Play Store Listing
```
Seção "Visão geral":
├── Título do aplicativo: FinWise
├── Descrição curta: Gestor de finanças pessoais
├── Descrição completa: [vide acima]
├── Categoria: Finanças
├── Tipo de conteúdo: Aplicativo
├── Público-alvo: 13+
└── Conteúdo:
    ├── Sem conteúdo sensível
    ├── Sem anúncios personalizados
    └── Sem compras com cartão de crédito (a menos que premium)
```

### 3. Adicionar Ícone e Screenshots
- Upload de ícone 512x512px
- Upload de 2-8 screenshots (obrigatório)
- Upload de imagem de capa (opcional, mas recomendado)

### 4. Classificação de Conteúdo
```
Responder ao formulário:
├── Profanidade: Nenhuma
├── Violência: Nenhuma
├── Conteúdo sexual: Nenhum
├── Dados pessoais: Apenas necessários (email, nome)
└── Anúncios: Sim (Google Mobile Ads)
```

### 5. Informações Legais
- [ ] Aceitar termos Google Play
- [ ] Confirmar que é responsável pelo conteúdo
- [ ] Confirmar conformidade com políticas

### 6. Configurar Preço e Distribuição
```
Distribuição:
├── Países: Todos
├── Preço: Grátis
├── Conteúdo com anúncios: Sim
└── Compras no app: Sim (Premium)
```

### 7. Upload do App Bundle
```
"Testagem" → "Teste interno" → Upload do AAB
ou
"Produção" → Upload do AAB (após testes)
```

### 8. Submeter para Revisão
- Revisar todos os dados
- Clicar "Enviar para revisão"
- Aguardar revisão (geralmente 2-4 horas)

---

## 🔟 PÓS-LANÇAMENTO

### Monitorar Métricas
- 📊 Google Play Console → Estatísticas
- 📱 Firebase Analytics
- 💬 Google Play Feedback
- ⭐ Avaliações e comentários

### Primeira Semana Crítica
- Monitorar crash reports
- Responder comentários
- Corrigir bugs críticos urgentemente
- Incrementar versão para patch (1.0.1)

### Manutenção Contínua
```bash
# Checklist de updates:
- [ ] Atualizar Flutter/Dart monthly
- [ ] Revisar Firebase security rules
- [ ] Monitorar AdMob performance
- [ ] Fazer backups regulares
- [ ] Manter documentação atualizada
```

---

## 📋 CHECKLIST PRÉ-SUBMISSÃO

- [ ] Versão bumped em pubspec.yaml
- [ ] Build number incrementado
- [ ] Nenhum debug print ativo em produção
- [ ] Tratamento de erros apropriado
- [ ] Testado em múltiplos dispositivos
- [ ] Ícone e screenshots prontos
- [ ] Descrição da app review-ready
- [ ] Política de privacidade configurada
- [ ] Termos de serviço configurados
- [ ] Keystore gerado e backup feito
- [ ] Nenhuma chave secreta em código
- [ ] Assets de alta qualidade
- [ ] App funciona offline (parcialmente)
- [ ] Notificações funcionam
- [ ] Ads funcionam
- [ ] Sync Firebase funciona

---

## 🚨 TROUBLESHOOTING

### Build falha com erro de gradle
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk --release --split-per-abi
```

### Keystore password incorreta
```bash
keytool -list -v -keystore key.jks
# Pode confirmar alias e fingerprints
```

### App rejeitado no Play Store
Razões comuns:
- 🔴 Funcionalidades promessas não funcionam
- 🔴 Crashes ou erros críticos
- 🔴 Permissões não justificadas
- 🔴 Dados de usuário não protegidos
- 🔴 Violação de políticas de conteúdo

**Solução:**
1. Ler feedback do Google Play
2. Corrigir issues
3. Resubmeter (máximo 3x por dia)

---

## 📞 CONTATO E SUPORTE

- 📧 Email: suporte@finwise.app
- 🐛 Bug Reports: GitHub Issues
- 💬 Discord: [Servidor da comunidade]
- 🌐 Website: https://finwise.app

---

## 📚 REFERÊNCIAS

- [Google Play Console Docs](https://developer.android.com/guide/google-play)
- [Flutter Release Docs](https://flutter.dev/docs/deployment/android)
- [Firebase Security](https://firebase.google.com/docs/database/security)
- [AdMob Best Practices](https://admob.google.com/home)

---

**Última atualização:** 2024
**Versão:** 1.0.0+1
**Status:** ✅ Pronto para produção
