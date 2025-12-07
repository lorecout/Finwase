# 🛒 Criar Produto IAP (In-App Purchase) - Play Console

**Data**: 04/12/2025  
**Versão**: v1.0.6+7 (Em Review)  
**Objetivo**: Criar produto "Premium Mensal" (R$ 9,90/mês)

---

## 📍 Passo-a-Passo Detalhado

### PASSO 1: Acessar Play Console
```
1. Abrir: https://play.google.com/console
2. Login: lorecout.dev@gmail.com
3. Selecionar app: Finans (com.lorecout.finwise)
4. Aguardar carregamento do dashboard
```

**Screenshot**: Você deve ver a tela que enviou (com Testar e lançar, Monitorar)

---

### PASSO 2: Ir para Monetização

```
NAVEGAÇÃO:
Menu Esquerdo → Monetização → Produtos

OU

Dashboard → Botão "Monetizar com o Google Play"
```

**Localização na tela**:
```
┌─────────────────────────────────────┐
│ Menu Esquerdo                       │
│ ├── Visão geral da publicação       │
│ ├── Testar e lançar                 │
│ ├── Monitorar e aprimorar           │
│ ├── Monetização ← CLIQUE AQUI        │
│ └── ...                             │
└─────────────────────────────────────┘
```

---

### PASSO 3: Selecionar "Assinaturas"

```
APÓS CLICAR EM MONETIZAÇÃO:

Menu Monetização:
├── Produtos no app
├── Assinaturas ← CLIQUE AQUI
└── Configuração de faturamento
```

**Você deve ver**:
- Lista vazia (primeira vez) ou produtos existentes
- Botão "+ Criar assinatura" (canto superior direito)

---

### PASSO 4: Criar Nova Assinatura

```
CLIQUE EM: "+ Criar assinatura" (botão azul)
```

**Abrirá um formulário com campos**:

#### Campo 1: ID do Produto
```
ID DO PRODUTO (obrigatório):
┌──────────────────────────────────────┐
│ premium_monthly                      │ ← Use este ID
└──────────────────────────────────────┘

⚠️ IMPORTANTE: Deve corresponder ao código do app
   (em lib/constants/ad_constants.dart)
   Não pode ser alterado depois!
```

#### Campo 2: Título (Nome)
```
TÍTULO DO PRODUTO (obrigatório):
┌──────────────────────────────────────┐
│ Premium Finans - Mensal              │ ← Ou "Finans Premium"
└──────────────────────────────────────┘

Dica: Simples e descritivo
```

#### Campo 3: Descrição
```
DESCRIÇÃO (obrigatória):
┌─────────────────────────────────────────────┐
│ Acesso a todos os recursos premium do       │
│ Finans por 1 mês:                           │
│                                             │
│ ✓ Relatórios avançados em PDF               │
│ ✓ Backup na nuvem automático                │
│ ✓ Sincronização entre dispositivos          │
│ ✓ Análises detalhadas e gráficos            │
│ ✓ Categorização inteligente                 │
│ ✓ Suporte prioritário 24/7                  │
│ ✓ Sem anúncios                              │
└─────────────────────────────────────────────┘
```

**Copiar desta fonte**: `JUSTIFICATIVA_PRECO_R990.md` (seção de funcionalidades)

---

### PASSO 5: Definir Período de Cobrança

```
PERÍODO DE COBRANÇA (obrigatório):
┌─────────────────────┐
│ ▼ Mensal (1 mês)   │ ← SELECIONE ESTA
└─────────────────────┘

Opções disponíveis:
- Semanal
- Mensal ✓
- Trimestral (3 meses)
- Semestral (6 meses)
- Anual (12 meses)
```

---

### PASSO 6: Definir Preço

```
PREÇO (obrigatório):
┌─────────────────────────────────────┐
│ País/Região: Brasil                 │
│ Preço: R$ 9,90                      │ ← Digite aqui
└─────────────────────────────────────┘

IMPORTANTE:
• Clique em "Brasil" se não estiver
• Digite apenas: 9,90 (sem R$ ou símbolos)
• Sistema converte automaticamente
```

**Verificar conversão**:
```
Se necessário, clique "Configurar preços para outros países"
para ofertar preço em USD/EUR também (opcional por agora)
```

---

### PASSO 7: Período de Teste Grátis (IMPORTANTE!)

```
PERÍODO DE TESTE GRÁTIS:
┌─────────────────────────────────────┐
│ ✓ Oferecer período de teste grátis  │ ← MARQUE
│ Duração: _____ dias                 │
│           └─→ Digite: 7             │
└─────────────────────────────────────┘

BENEFÍCIOS:
✓ Aumenta taxa de conversão (+30-50%)
✓ Usuários experimentam sem risco
✓ Menos cancelamentos
✓ Padrão de mercado (Spotify, Netflix também fazem)
```

---

### PASSO 8: Ativar Produto

```
ANTES DE SALVAR:

☐ ID do Produto: premium_monthly
☐ Título: Premium Finans - Mensal
☐ Descrição: [preenchida conforme acima]
☐ Período: Mensal (1 mês)
☐ Preço: R$ 9,90
☐ Teste grátis: 7 dias
```

**Clique em: "Salvar" (botão azul no final da página)**

---

## ✅ Confirmação - Produto Criado

Após salvar, você verá:

```
┌────────────────────────────────────┐
│ ✓ Produto criado com sucesso!      │
│                                    │
│ ID: premium_monthly                │
│ Nome: Premium Finans - Mensal      │
│ Preço: R$ 9,90/mês                │
│ Teste: 7 dias grátis              │
│ Status: ATIVO ✓                    │
└────────────────────────────────────┘
```

---

## 🔍 Verificar se foi Criado

```
Volte para: Monetização → Assinaturas

Você deve ver a lista:
┌─────────────────────────────────────────┐
│ Produto        │ Preço      │ Status    │
├─────────────────────────────────────────┤
│ Premium Finans │ R$ 9,90    │ ATIVO ✓   │
└─────────────────────────────────────────┘
```

---

## ⚠️ Erros Comuns

### ❌ Erro: "ID do Produto já existe"
```
SOLUÇÃO:
• Significa que outro app já usa "premium_monthly"
• Mude para: "com_lorecout_finwise_premium_monthly"
• OU: "finans_premium_mensal"

IMPORTANTE: Depois mude também em:
  lib/constants/ad_constants.dart
  Linha: finwise_premium_monthly
```

### ❌ Erro: "Descrição muito curta"
```
SOLUÇÃO:
• Descrição precisa ter mínimo 80 caracteres
• Use a descrição completa com as 4 funcionalidades
• (vai ter mais de 80 caracteres com certeza)
```

### ❌ Erro: "Preço inválido"
```
SOLUÇÃO:
• Não use símbolos (R$, vírgula)
• Digite apenas: 9.90 (ou 9,90)
• Sistema aceita ambos os separadores
```

---

## 📍 Próximo Passo Após Criar Produto

1. ✅ Produto criado no Play Console
2. ⏳ Aguardar aprovação de v1.0.6+7 (2-7 dias)
3. 🔄 Quando aprovar → Ativar produto IAP automaticamente
4. 🧪 Testar compra com conta de teste do Play Console

---

## 💡 Dicas de Sucesso

✅ **FAÇA**:
- Ofereça período de teste grátis (7 dias)
- Descrição clara e honesta (4 funcionalidades principais)
- Preço competitivo (R$ 9,90 vs R$ 15-25 concorrentes)
- Teste com sua conta antes de lançar

❌ **NÃO FAÇA**:
- Não mude o ID do produto depois (quebra as compras anteriores)
- Não coloque preço muito alto (mata conversão)
- Não exagere na descrição (seja honesto)

---

**Status**: 🔴 TODO - Criar agora  
**Tempo estimado**: 5-10 minutos  
**Dificuldade**: ⭐ Fácil

**Próximo documento**: `TESTAR_COMPRA_PRODUCAO.md` (após aprovação)
