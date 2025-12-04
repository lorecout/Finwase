# 🛍️ Passo a Passo: Monetização no Google Play Console

## 📍 PARTE 1: Configurar Produtos In-App

### Passos Detalhados

#### 1. Abrir Google Play Console
```
Acesse: https://play.google.com/console
Login com: lorecout.dev@gmail.com
Selecione: "Finans" (com.lorecout.finwise)
```

#### 2. Ir para Monetização > Produtos no app
```
Sidebar Esquerda:
├─ Monetização
│  ├─ Configuração de monetização
│  ├─ Produtos no app    ← AQUI
│  └─ Assinaturas
```

#### 3. Criar Primeiro Produto: "Remover Anúncios"

**Clique em: "+ Criar produto"**

```
┌────────────────────────────────────────┐
│  FORMULÁRIO DE PRODUTO                 │
├────────────────────────────────────────┤
│                                        │
│  ID do Produto: *                      │
│  [remove_ads                         ] │
│                                        │
│  Tipo:                                 │
│  ◉ Produto gerenciado                  │
│                                        │
│  Título: *                             │
│  [Remover Anúncios                   ] │
│                                        │
│  Descrição: *                          │
│  [Remova todos os anúncios do app    ] │
│  [obtendo uma experiência sem       ] │
│  [interrupções. Suporte ao dev!      ] │
│                                        │
│  [SALVAR COMO RASCUNHO]  [PUBLICAR]   │
│                                        │
└────────────────────────────────────────┘
```

**Clique: "SALVAR COMO RASCUNHO"**

---

#### 4. Configurar Preço
```
Depois de salvar, você verá:

┌─────────────────────────────────────────┐
│ Configuração de Preço e Disponibilidade │
├─────────────────────────────────────────┤
│                                         │
│ País/Região: Brasil                     │
│ Moeda de Base: USD $                    │
│ Preço Base: [2.49] (≈ R$ 4,99)        │
│                                         │
│ Disponibilidade:                        │
│ [✓] Disponível em todos os países      │
│                                         │
│ [SALVAR]                                │
│                                         │
└─────────────────────────────────────────┘
```

**Valores Recomendados:**
- USD $1.49 ≈ R$ 4,99
- USD $2.49 ≈ R$ 9,99
- USD $5.99 ≈ R$ 19,99

**Clique: "SALVAR"**

---

#### 5. Ativar Produto
```
Volte para a lista de produtos.

Você verá:
┌────────────────────────────────────────┐
│ Remover Anúncios      [Status: Rascunho]
│ remove_ads                              │
│                                         │
│ [Editar]  [Publish...]                 │
└────────────────────────────────────────┘

Clique em: [Publish...]

Confirmação:
"Deseja publicar este produto?"
[Cancelar]  [Publicar]
```

**Clique: "Publicar"**

✅ **Produto 1 concluído!**

---

### Criar Produtos Restantes

Repita os passos 3-5 para:

#### Produto 2: Premium Mensal
```
ID: finwise_premium_monthly
Título: Premium Mensal
Descrição: Acesso ilimitado a recursos premium
Preço: USD $2.49 (R$ 9,99)
```

#### Produto 3: Premium Anual
```
ID: finwise_premium_yearly
Título: Premium Anual
Descrição: Acesso anual com 40% de desconto
Preço: USD $14.99 (R$ 59,99)
```

#### Produto 4: Premium Vitalício
```
ID: finwise_premium_lifetime
Título: Premium Vitalício
Descrição: Acesso permanente, compra única
Preço: USD $49.99 (R$ 199,99)
```

---

## 📍 PARTE 2: Configurar Assinaturas

### Passo a Passo Assinatura Mensal

#### 1. Ir para Monetização > Assinaturas
```
Sidebar:
├─ Monetização
│  ├─ Configuração de monetização
│  ├─ Produtos no app
│  └─ Assinaturas      ← AQUI
```

#### 2. Clique em "+ Criar assinatura"
```
┌──────────────────────────────────────────┐
│  CRIAR NOVA ASSINATURA                   │
├──────────────────────────────────────────┤
│                                          │
│  ID da assinatura: *                     │
│  [premium_sub_monthly                  ] │
│                                          │
│  Período de faturamento: *               │
│  [Mensal ▼]                              │
│                                          │
│  Tipo de assinatura:                     │
│  ◉ Preparada (renovação automática)      │
│                                          │
│  Título: *                               │
│  [Premium Mensal                       ] │
│                                          │
│  Descrição: *                            │
│  [Acesso completo a recursos            │
│   premium. Renova automaticamente       │
│   a cada mês. Cancele a qualquer       │
│   momento.                              │
│                                          │
│  [SALVAR COMO RASCUNHO]  [PUBLICAR]     │
│                                          │
└──────────────────────────────────────────┘
```

**Clique: "SALVAR COMO RASCUNHO"**

---

#### 3. Configurar Período de Teste Gratuito
```
Após salvar, você verá opção:

┌──────────────────────────────────────────┐
│  PERÍODO DE TESTE GRATUITO               │
├──────────────────────────────────────────┤
│                                          │
│ Ativar período de teste: [Toggle ON]    │
│                                          │
│ Duração:                                 │
│ [7] dias      ← RECOMENDADO             │
│                                          │
│ Essa duração aparecerá como:            │
│ "7 dias grátis, depois R$ 9,99/mês"     │
│                                          │
│ [SALVAR]                                 │
│                                          │
└──────────────────────────────────────────┘
```

**Clique: "SALVAR"**

---

#### 4. Configurar Preço
```
┌──────────────────────────────────────────┐
│  PREÇO E DISPONIBILIDADE                 │
├──────────────────────────────────────────┤
│                                          │
│  Moeda de Base: USD $                    │
│  Preço Recorrente: [2.49]               │
│                                          │
│  Disponível em:                          │
│  [✓] Todos os países                     │
│                                          │
│  [SALVAR]                                │
│                                          │
└──────────────────────────────────────────┘
```

---

#### 5. Publicar Assinatura
```
Botão: [Publicar...]

Confirmação:
"Deseja publicar esta assinatura?"
[Cancelar]  [Publicar]
```

✅ **Assinatura Mensal Criada!**

---

### Criar Assinatura Anual

Repita processo com:
```
ID: premium_sub_yearly
Título: Premium Anual
Período: Anual
Duração Teste: 7 dias (opcional)
Preço: USD $14.99 (R$ 59,99)
```

---

## 📍 PARTE 3: Configurar Conta Bancária

### 1. Abrir Configurações de Conta
```
URL: https://play.google.com/console
Canto superior direito: [⚙️ Ícone]
Selecione: "Configurações"
```

### 2. Ir para Informações de Conta
```
Menu Esquerdo:
├─ Seu Perfil
├─ Informações da Conta    ← AQUI
├─ Segurança
└─ ...
```

### 3. Dados Bancários
```
Seção: "Conta Bancária"

┌──────────────────────────────────────────┐
│ INFORMAÇÕES BANCÁRIAS PARA DEPÓSITOS     │
├──────────────────────────────────────────┤
│                                          │
│ Nome Completo: *                         │
│ [Lorena Coutinho                       ] │
│                                          │
│ Tipo de Conta: *                         │
│ ◉ Pessoa Física  ◯ PJ/Empresa           │
│                                          │
│ CPF/CNPJ: *                              │
│ [12345678901                           ] │
│                                          │
│ Data de Nascimento: *  (PF)              │
│ [DD/MM/YYYY]                            │
│                                          │
│ Banco: *                                 │
│ [Banco do Brasil ▼]                     │
│                                          │
│ Agência: *                               │
│ [1234] (sem DV)                         │
│                                          │
│ Conta: *                                 │
│ [123456] (sem DV)                       │
│                                          │
│ Tipo Conta:                              │
│ ◉ Corrente  ◯ Poupança                  │
│                                          │
│ [SALVAR DADOS BANCÁRIOS]                │
│                                          │
└──────────────────────────────────────────┘
```

**⚠️ IMPORTANTE**: Dados devem coincidir com conta Google Play

---

## 📍 PARTE 4: Testar Compras (Antes de Publicar)

### 1. Configurar Conta de Teste
```
Play Console > Configurações > Contas de teste

Clique: [+ Contas de teste]

Adicione:
- Gmail de teste
- Email alternativo para testes
```

### 2. Instalar App com Conta de Teste
```
1. Saia da conta atual no dispositivo
2. Faça login com a conta de TESTE
3. Instale o app
4. Teste cada compra (não será cobrado)
```

### 3. Simular Compra (no App)
```
Seu código Android deve chamar:

BillingClient.launchBillingFlow(
  activity,
  billingFlowParams
)

A Google Play mostra:
"Essa é uma compra de teste.
 Nenhuma cobrança será efetuada."
```

---

## 📍 PARTE 5: Monitorar Receita

### 1. Dashboard de Vendas
```
Play Console > Monetização > Receita

Dashboard mostra:
├─ Receita Total (últimos 30 dias)
├─ Por Produto
├─ Por País
├─ Por Período
└─ Tendências
```

### 2. Relatórios Detalhados
```
Abas Disponíveis:
├─ Visão Geral
├─ Por Produto
├─ Por País/Região
├─ Por Dispositivo
└─ Configuração de Data
```

---

## ✅ Checklist Final

- [ ] 4 produtos criados e publicados
- [ ] 2 assinaturas criadas e publicadas
- [ ] Conta bancária verificada
- [ ] Taxa de impostos configurada
- [ ] Contas de teste criadas
- [ ] Compras testadas com sucesso
- [ ] Política de Privacidade atualizada
- [ ] Termos de Serviço online
- [ ] App aprovado pelo Google Play
- [ ] Monetização ativada no código

---

## 🚨 Problemas Comuns

| Problema | Solução |
|----------|---------|
| ID do Produto duplicado | IDs devem ser únicos. Use padrão: `finwise_*` |
| Produto não aparece | Verifique status: deve ser "Publicado" não "Rascunho" |
| Teste não funciona | Confirme que está com conta de TESTE logada |
| Sem depósitos bancários | Conta bancária deve estar verificada |

---

**Próximo Passo**: Aguardar aprovação da v1.0.6+7 e então ativar monetização!
