# 🎬 INSTRUÇÕES VISUAIS - PASSO A PASSO

## 📍 VOCÊ ESTÁ AQUI

```
✅ GitHub Pages configurado
✅ app-ads.txt online
❌ Erros Flutter não corrigidos
❌ AAB não gerado
```

---

## 🎯 PASSO 1: EXECUTAR SCRIPT

### Método 1️⃣: Mais Fácil (Clique Direito)

```
📂 C:\Users\Lorena\StudioProjects\Finwase\gastos_manager
  └── CORRIGIR_AUTOMATICO.ps1  ⬅️ PROCURE ESTE ARQUIVO
```

**O que fazer:**
1. Abra a pasta acima
2. Encontre o arquivo `CORRIGIR_AUTOMATICO.ps1`
3. Clique com **botão direito** nele
4. Selecione: **Run with PowerShell**
5. Confirme qualquer aviso de segurança

**Você verá:**
```
================================
CORRIGINDO ERROS FLUTTER
================================

[1/4] Atualizando versão em pubspec.yaml...
✅ Versão atualizada: 1.0.4+5 → 1.0.5+6

[2/4] Adicionando getters em ad_service.dart...
✅ Getters adicionados a ad_service.dart

[3/4] Adicionando campo em ad_revenue_optimizer.dart...
✅ Campo _performanceData adicionado

[4/4] Ativando modo produção em ad_service.dart...
✅ Modo produção ativado (_isTestMode = false)

[FINAL] Limpando cache e restaurando dependências...
Executando: flutter clean
Executando: flutter pub get

================================
✅ CORREÇÕES CONCLUÍDAS!
================================
```

---

## 🎯 PASSO 2: COMPILAR PARA RELEASE

### Espere o script terminar, depois abra Terminal

**Via Explorador:**
1. Na mesma pasta, clique em `📍 Este PC` ou pasta vazia
2. Pressione: `Shift + Clique Direito`
3. Selecione: **Abrir PowerShell aqui**

**Ou via VS Code:**
1. Abra VS Code
2. Pressione: `Ctrl + '` (apóstrofo)
3. Terminal se abre automaticamente

### Cole este comando:

```bash
flutter build appbundle --release
```

**Você verá:**
```
Running Gradle task 'bundleRelease'...
⣯ Running Gradle...

Building for Android (release)...
✓ Built build/app/outputs/bundle/release/app-release.aab (87.3 MB)

Compiling for Android... (1234ms)
```

⏱️ **Isso demora 10-15 minutos na primeira vez**

### Quando terminar, você terá:

```
📦 build/app/outputs/bundle/release/app-release.aab
```

**Tamanho esperado:** 30-100 MB

---

## 🎯 PASSO 3: VERIFICAR SE AAB FOI GERADO

### Via Explorador

```
📂 C:\Users\Lorena\StudioProjects\Finwase\gastos_manager
  └── 📂 build
      └── 📂 app
          └── 📂 outputs
              └── 📂 bundle
                  └── 📂 release
                      └── 📦 app-release.aab  ⬅️ PROCURE ISTO
```

### Via Terminal

```bash
# Listar arquivo
dir build\app\outputs\bundle\release\app-release.aab

# Deve retornar algo assim:
# 04/12/2025 10:30:45 87,342,156 app-release.aab
```

✅ **Se aparecer, significa que funcionou!**

---

## 🎯 PASSO 4: PUBLICAR NO PLAY STORE

### Abra Play Console

```
Link: https://play.google.com/console
```

### Passo a Passo com Screenshots (Descrição)

**4.1 - Selecionar App:**
```
1. Clique em: FinWise
2. Menu esquerdo → Produção
```

**4.2 - Criar Nova Versão:**
```
1. Clique em: "Criar nova versão"
2. Ou: "+ Nova versão"
3. Selecione: Android App Bundle (AAB)
```

**4.3 - Fazer Upload do AAB:**
```
1. Clique em: "Fazer upload do AAB"
2. Procure: app-release.aab
   Localização: C:\Users\Lorena\StudioProjects\Finwase\gastos_manager\build\app\outputs\bundle\release\
3. Selecione o arquivo
4. Clique: Abrir
```

**4.4 - Preencher Informações:**
```
Campo: Notas da versão
Valor: 
Versão 1.0.5
- Correção de bugs
- Suporte a anúncios
- Otimizações de desempenho
```

**4.5 - Revisar e Confirmar:**
```
1. Clique: "Revisar versão"
2. Verifique tudo
3. Clique: "Confirmar mudanças"
4. Clique: "Iniciar implementação"
```

**4.6 - Selecionar Público:**
```
1. Selecione: "Produção"
2. Clique: "Confirmar"
```

**4.7 - Enviado!**
```
Status: "Enviado para revisão"
Você receberá email quando aprovado
```

---

## ⏱️ O QUE ACONTECE DEPOIS

### Fase 1: Revisão (1-7 dias)
```
📧 Google Play Console enviará emails com:
- ✅ Aprovado (geralmente em 1-3 dias)
- ⚠️ Precisa de ajustes
- ❌ Rejeitado (muito raro)
```

### Fase 2: Publicar Manualmente (Quando Aprovado)
```
1. Acesse Play Console
2. Procure: "Pronto para publicar"
3. Clique: "Publicar versão"
4. Confirme
```

### Fase 3: Propagação (2-24 horas)
```
App fica disponível gradualmente
Todos os usuários terão em até 24 horas
```

### Fase 4: Ganhar com Anúncios 💰
```
App começa a exibir anúncios
Você ganha por: Impressões e cliques
Dashboard AdMob mostra: Receita em tempo real
```

---

## ✅ CHECKLIST RÁPIDO

```
ANTES DE EXECUTAR SCRIPT:
☐ Projeto Flutter está em: C:\Users\Lorena\StudioProjects\Finwase\gastos_manager
☐ Você tem permissão de administrador
☐ Flutter instalado (flutter --version funciona)

DEPOIS DE EXECUTAR SCRIPT:
☐ Mensagem "✅ CORREÇÕES CONCLUÍDAS!" apareceu
☐ Sem erros críticos

DEPOIS DE COMPILAR:
☐ Arquivo app-release.aab existe
☐ Tamanho > 20 MB (significa que tem o app)

DEPOIS DE UPLOAD PLAY STORE:
☐ Status mudou para "Enviado para revisão"
☐ Email de confirmação recebido

DEPOIS DE APROVAÇÃO:
☐ Status mudou para "Pronto para publicar"
☐ Clicou em "Publicar versão"

DEPOIS DE PUBLICAR:
☐ Status mudou para "Ativo em Produção"
☐ App aparecendo no Play Store para alguns usuários

RECEITA:
☐ app-ads.txt verificado no AdMob ✅
☐ Primeiros anúncios aparecendo
☐ Primeira receita sendo gerada
```

---

## 🆘 ERROS POSSÍVEIS E SOLUÇÕES

### Erro: "Arquivo CORRIGIR_AUTOMATICO.ps1 não encontrado"
**Solução:**
- Verifique se criou corretamente
- Tente navegar manualmente até: `C:\Users\Lorena\StudioProjects\Finwase\gastos_manager`
- Se não existir, crie manualmente as correções (veja: CORRIGIR_ERROS_PASSO_A_PASSO.md)

### Erro: "PowerShell não reconhece comando"
**Solução:**
```powershell
# Executar como Administrador:
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser
```

### Erro: "Flutter não encontrado durante compilação"
**Solução:**
```bash
# Testar se Flutter funciona:
flutter --version

# Se não funcionar, adicionar ao PATH em Variáveis de Ambiente
# C:\Users\Lorena\Documents\SDK\flutter\bin
```

### Erro: "AAB não foi gerado"
**Solução:**
```bash
# Tentar novamente com:
flutter clean
flutter pub get
flutter build appbundle --release
```

---

## 📱 TESTAR ANTES DE PUBLICAR (Opcional)

Se quiser testar o app antes de publicar:

```bash
# Compilar versão debug
flutter build apk --debug

# Instalar em dispositivo conectado
adb install build/app/outputs/apk/debug/app-debug.apk

# Ou usar:
flutter run --release
```

---

## 🎉 SUCESSO!

Quando ver seu app no Play Store:
```
✅ App publicado
✅ Recebendo anúncios
✅ Gerando receita
✅ Parabéns! 🎊
```

---

**📅 Próximo passo: Execute o script!**


