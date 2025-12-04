# 📱 Guia Completo: Upload do AAB no Play Console

## Versão: 1.0.4 (Build 5)
## Data: 04/12/2025
## Status: Pronto para upload

---

## 🎯 O que você vai fazer:

Fazer upload do novo AAB (com Google AdMob IDs reais) para o Play Console, para que a Google revise e aprove a nova versão do FinWase.

---

## ✅ Antes de começar - Verifique:

- [ ] Você tem acesso ao Play Console (https://play.google.com/console)
- [ ] Você está logado com a conta Google do desenvolvedor
- [ ] Seu computador tem o arquivo: `app-release.aab` (54.72 MB)
- [ ] Você tem o documento aberto: `BUILD_FINAL_STATUS.md`

---

## 📋 PASSO A PASSO

### PASSO 1: Acessar o Play Console

1. Abra o navegador
2. Acesse: **https://play.google.com/console**
3. Faça login com sua conta Google (lorecout.dev@gmail.com)
4. Você verá a lista de apps - procure por **FinWase**

```
Você deve ver:
┌─────────────────────────────────┐
│ FinWase - Controle Financeiro   │
│ com.lorecout.finwise            │
│ 10+ downloads                   │
└─────────────────────────────────┘
```

---

### PASSO 2: Entrar na App

1. Clique em **FinWase** (ou qualquer app que você vê)
2. Você entrará no painel da app
3. No menu esquerdo, procure por **"Releases"** ou **"Versões"**

```
Menu lateral (esquerda):
├─ Dashboard
├─ Store listing (Listagem da loja)
├─ Releases ← CLIQUE AQUI
├─ Testers
└─ Settings
```

---

### PASSO 3: Ir para Releases (Versões)

1. Clique em **"Releases"** ou **"Lançamentos"**
2. Você verá as versões anteriores

```
Você verá algo assim:
┌──────────────────────────────────┐
│ Production (Produção)            │
│ Version 1.0.3 (Build 4)         │
│ Data: 01/12/2025                │
│ Status: ✅ Approved             │
└──────────────────────────────────┘

┌──────────────────────────────────┐
│ Internal Testing                 │
│ Version 1.0.2 (Build 3)         │
└──────────────────────────────────┘
```

---

### PASSO 4: Criar um Novo Release

**Opção A - Se você ver um botão "Create Release":**
1. Procure pelo botão azul **"Create Release"**
2. Clique nele

**Opção B - Se não ver (versão diferente do Play Console):**
1. Clique na aba **"Production"** (Produção)
2. Procure por **"Create new release"**
3. Clique nele

```
Você verá um botão assim:
┌─────────────────────────────────┐
│ + Create Release                │
└─────────────────────────────────┘
```

---

### PASSO 5: Fazer Upload do AAB

Depois de clicar em "Create Release", você verá uma tela assim:

```
┌─────────────────────────────────────────────┐
│ Create Release - Production                 │
│                                             │
│ App bundles and APKs                        │
│ ┌─────────────────────────────────────────┐ │
│ │ + Add files                             │ │
│ │ or drag and drop files here             │ │
│ └─────────────────────────────────────────┘ │
└─────────────────────────────────────────────┘
```

**Agora você tem 2 opções:**

#### OPÇÃO 1: Clicar no botão "Add files"
1. Clique em **"Add files"** ou **"Adicionar arquivos"**
2. Uma janela vai abrir (explorador de arquivos)
3. Navegue até: `C:\Users\Lorena\StudioProjects\Finwase\gastos_manager\build\app\outputs\bundle\release\`
4. Selecione: **`app-release.aab`** (54.72 MB)
5. Clique em **"Abrir"**

#### OPÇÃO 2: Arrastar e soltar (Drag and drop)
1. Abra o explorador de arquivos em outra janela
2. Navegue até a pasta acima
3. Encontre o arquivo **`app-release.aab`**
4. Arraste o arquivo e solte na caixa do Play Console

---

### PASSO 6: Aguardar o Upload

Depois que você adicionar o arquivo:

```
O Play Console vai mostrar:
┌─────────────────────────────────┐
│ ⏳ Uploading... 45%              │
└─────────────────────────────────┘

(Pode levar 1-3 minutos dependendo de sua internet)

Depois mostrará:
┌─────────────────────────────────┐
│ ✅ app-release.aab              │
│    Version 1.0.4 (Build 5)     │
│    54.72 MB                     │
│    Status: ✅ Pronto             │
└─────────────────────────────────┘
```

---

### PASSO 7: Revisar Informações

Depois do upload bem-sucedido, você verá:

```
┌──────────────────────────────────────┐
│ Release name (opcional):             │
│ ┌──────────────────────────────────┐ │
│ │ v1.0.4 - Segurança & Monetização │ │
│ └──────────────────────────────────┘ │
│                                      │
│ Release notes (Notas de versão):    │
│ ┌──────────────────────────────────┐ │
│ │ • Play Integrity API integrada   │ │
│ │ • Google AdMob configurado       │ │
│ │ • Otimizações de performance    │ │
│ └──────────────────────────────────┘ │
└──────────────────────────────────────┘
```

**O que fazer:**

1. **Release name** (opcional) - Digite um nome:
   ```
   v1.0.4 - Segurança & Monetização
   ```

2. **Release notes** (Notas de versão) - Digite o que mudou:
   ```
   • Play Integrity API integrada para proteger contra fraudes
   • Google Mobile Ads com IDs reais configurados
   • In-App Purchase implementado (Premium R$ 9,90/mês)
   • Otimizações de performance e segurança
   ```

---

### PASSO 8: Revisar Permissões (Importante!)

Na mesma tela, você verá uma seção:

```
┌─────────────────────────────────────────┐
│ Permissions and APIs                    │
│ (Permissões e APIs)                     │
│                                         │
│ ✓ INTERNET                              │
│ ✓ ACCESS_NETWORK_STATE                 │
│ ✓ INTERNET_BILLING                     │
│ ...                                     │
└─────────────────────────────────────────┘
```

**O que fazer:**
- Verifique se as permissões fazem sentido
- Não deve ter permissões estranhas
- Se tudo estiver OK, continue

---

### PASSO 9: Revisar Conteúdo da App

Antes de submeter, o Play Console pode pedir:

```
┌──────────────────────────────────────┐
│ Content Rating Questionnaire          │
│ (Questionário de Classificação)       │
│                                      │
│ ✓ Preenchido em: 02/12/2025         │
│ ✓ Categoria: Finanças/Produtividade  │
│ ✓ Classificação: PEGI 3              │
└──────────────────────────────────────┘
```

**Se não estiver preenchido:**
1. Clique em **"Content Rating"**
2. Responda ao questionário:
   - Categoria: **Finanças**
   - Conteúdo violento? **Não**
   - Conteúdo sexual? **Não**
   - Álcool/drogas? **Não**
   - Etc... (tudo "Não" para um app de finanças)
3. Clique em **"Save"**

---

### PASSO 10: Verificar Política de Privacidade

O Play Console vai verificar:

```
┌──────────────────────────────────────┐
│ Privacy Policy (Política de Privacidade)
│                                      │
│ URL: https://finwase-privice.       │
│      vercel.app/privacy_policy.html │
│                                      │
│ Status: ✅ Online e acessível       │
└──────────────────────────────────────┘
```

**Se não estiver vinculada:**
1. Procure por **"Privacy Policy"**
2. Cole a URL:
   ```
   https://finwase-privice.vercel.app/privacy_policy.html
   ```
3. Clique em **"Save"**

---

### PASSO 11: Submeter para Review (O Botão Importante!)

Agora você verá um botão azul grande:

```
┌─────────────────────────────────────┐
│ ▶ NEXT (PRÓXIMO)                   │
│ ou                                  │
│ ▶ Review Release                    │
│ ou                                  │
│ ▶ Send for Review                   │
└─────────────────────────────────────┘
```

1. Clique nesse botão
2. Você verá um resumo da release:

```
┌──────────────────────────────────────────┐
│ Review Release Summary                   │
│ (Resumo da Versão para Review)           │
│                                          │
│ Version: 1.0.4 (Build 5)                │
│ AAB Size: 54.72 MB                      │
│ Release Name: v1.0.4 - Segurança...    │
│ Status: Ready to submit ✅              │
└──────────────────────────────────────────┘
```

---

### PASSO 12: Confirmar o Envio (Muito Importante!)

Você verá um dialogo perguntando:

```
┌──────────────────────────────────────┐
│ Start rollout to Production?          │
│ (Começar lançamento na Produção?)     │
│                                      │
│ ⚠️ Isso vai submeter a app para      │
│    review da Google Play.            │
│                                      │
│ [ Cancel ]  [ Confirm ]              │
└──────────────────────────────────────┘
```

**Clique em "Confirm"** (Confirmar)

---

### PASSO 13: Pronto! Upload Enviado ✅

Depois de confirmar, você verá:

```
┌──────────────────────────────────────┐
│ ✅ Release submitted for review      │
│ (Versão enviada para revisão)        │
│                                      │
│ Your app is now being reviewed       │
│ by Google Play.                      │
│                                      │
│ Expected time: 2-4 hours             │
│ (Tempo esperado: 2-4 horas)         │
│                                      │
│ Status: Under review 🔄              │
└──────────────────────────────────────┘
```

---

## ⏱️ O QUE ACONTECE AGORA

### Imediatamente (5-10 min)
```
✅ Google valida o AAB automaticamente
✅ Gera APKs para diferentes arquiteturas
✅ Verifica tamanho e compatibilidade
✅ Você recebe notificação por email
```

### Próximas 2-4 horas
```
🤖 Revisão automática:
   ✓ Verifica policies (políticas)
   ✓ Analisa permissões
   ✓ Valida segurança
```

### 24-48 horas (ou até 7 dias)
```
👤 Revisão humana:
   ✓ Um revisor Google valida:
     - Política de privacidade
     - Monetização
     - Conteúdo apropriado
     - Conformidade
```

### Resultado Final
```
APROVADO ✅
  ↓
App vai ao ar em 24-48h
(com rollout gradual configurável)

OU

REJEITADO ❌
  ↓
Google envia email explicando
Você corrige e resubmete
```

---

## 📊 Como Monitorar o Status

### Opção 1: No Play Console
1. Acesse: https://play.google.com/console
2. Clique em **FinWase**
3. Vá para **Releases → Production**
4. Veja o status:

```
Status: ⏳ Under review (Em revisão)
ou
Status: ✅ Approved (Aprovado)
ou
Status: ❌ Rejected (Rejeitado)
```

### Opção 2: Por Email
- Google envia notificações para: **lorecout.dev@gmail.com**
- Verifique o email regularmente (inclua Spam)

### Opção 3: Push no Play Console
- Você recebe notificações push no Play Console

---

## ⚠️ SE HOUVER PROBLEMA

### Erro: "Invalid AAB"
```
Solução:
1. Verifique se o arquivo é realmente .aab
2. Tente fazer upload novamente
3. Se persistir, contate Google Play Support
```

### Erro: "Unsupported characters in Release name"
```
Solução:
1. Use apenas letras, números e traços
2. Exemplo: "v1.0.4-Seguranca-Monetizacao"
3. Tente novamente
```

### Erro: "Privacy Policy unreachable"
```
Solução:
1. Verifique URL: https://finwase-privice.vercel.app/privacy_policy.html
2. Tente acessar a URL no navegador
3. Se Vercel estiver down, use Google Docs como alternativa
4. Atualize a URL no Play Console
```

### Erro: "Content Rating not completed"
```
Solução:
1. Clique em "Content Rating"
2. Preencha o questionário
3. Salve
4. Tente submeter novamente
```

---

## 🎉 RESUMO DO PROCESSO

```
1. ✅ Acessar Play Console
2. ✅ Ir para FinWase → Releases
3. ✅ Criar novo Release
4. ✅ Fazer upload do AAB (54.72 MB)
5. ✅ Revisar informações
6. ✅ Submeter para Review
7. ✅ Aguardar aprovação (3-7 dias)
8. ✅ App ao ar na Play Store!
```

---

## 📞 DÚVIDAS FREQUENTES

### P: Quanto tempo leva para aprovação?
**R:** Normalmente 2-7 dias. Pode ser mais rápido se não houver problemas.

### P: E se rejeitarem?
**R:** Google envia email com motivo. Você corrige e resubmete.

### P: Posso cancelar o upload?
**R:** Sim, antes de clicar "Confirm". Depois, é tarde.

### P: Como acompanho os downloads?
**R:** No Play Console → Dashboard → Install statistics

### P: Quando gero receita com AdMob?
**R:** Após a app ser aprovada e depois que usuários virem anúncios.

---

## 🚀 PRONTO?

Se você conseguiu fazer todos os passos, **parabéns!** 🎉

Sua app vai ficar **"Under review"** por 3-7 dias.

Depois você receberá um email informando se foi **APROVADA** ou se precisa de **AJUSTES**.

**Boa sorte!** 💪

---

**Criado em:** 04/12/2025  
**Para:** Lorena Coutinho (lorecout)  
**App:** FinWase - Controle Financeiro  
**Versão:** 1.0.4 (Build 5)
