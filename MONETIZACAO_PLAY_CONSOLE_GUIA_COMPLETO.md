# 💰 Guia Completo: Monetização no Google Play Console

> **Status**: App em análise (v1.0.6+7) - Aguardando aprovação para publicação

## 📋 Índice
1. [Configuração de Produtos](#configuração-de-produtos)
2. [Configuração de Assinaturas](#configuração-de-assinaturas)
3. [Verificação de Conta Bancária](#verificação-de-conta-bancária)
4. [Configurações de Políticas](#configurações-de-políticas)
5. [Monitoramento de Receita](#monitoramento-de-receita)

---

## 🏪 Configuração de Produtos

### 1️⃣ Produtos In-App (Compras Únicas)

#### Acessar o Console
```
Google Play Console > Seu App (Finans) > Monetização > Produtos no app
```

#### Produtos Recomendados para Finans

**A) Premium Mensal Ilimitado**
- **ID do Produto**: `finwise_premium_monthly`
- **Título**: Premium Mensal
- **Descrição**: Acesso ilimitado a todos os recursos premium por 1 mês
- **Preço**: R$ 9,99 ou equivalente em USD (~$2.50)
- **Status**: Disponível

**B) Premium Anual Ilimitado** (MELHOR VALOR)
- **ID do Produto**: `finwise_premium_yearly`
- **Título**: Premium Anual
- **Descrição**: Acesso anual ao Premium com 40% de desconto em comparação com mensalidades
- **Preço**: R$ 59,99 ou equivalente em USD (~$15.00)
- **Status**: Disponível
- 💡 **Dica**: Este é o produto com melhor conversão

**C) Premium Vitalício** (ONE-TIME)
- **ID do Produto**: `finwise_premium_lifetime`
- **Título**: Premium Vitalício
- **Descrição**: Acesso permanente a todos os recursos premium
- **Preço**: R$ 199,99 ou equivalente em USD (~$50.00)
- **Status**: Disponível
- ⭐ **Maior margem de lucro**

**D) Remoção de Anúncios**
- **ID do Produto**: `remove_ads`
- **Título**: Remover Anúncios
- **Descrição**: Remova todos os anúncios permanentemente
- **Preço**: R$ 4,99 ou equivalente em USD (~$1.25)
- **Status**: Disponível

#### Como Criar Produto

1. Clique em **"Criar produto"**
2. Preencha:
   - **ID do produto** (não pode ser alterado depois!)
   - **Título** (visível ao usuário)
   - **Descrição** (detalhes do produto)
3. Selecione **"Produto gerenciado"** (não assinatura)
4. Configure **Preços e disponibilidade**:
   - Defina preço base (USD)
   - Google Play calcula automaticamente para outras moedas
5. Salve como **Rascunho** primeiro
6. Teste com conta de teste
7. **Publique** quando pronto

---

## 📱 Configuração de Assinaturas

### 2️⃣ Assinaturas (Pagamento Recorrente)

#### Acessar o Console
```
Google Play Console > Seu App (Finans) > Monetização > Assinaturas
```

#### Planos de Assinatura Recomendados

**Estrutura de 3 Camadas:**

```
┌─────────────────────────────────────────┐
│         PLANOS DE ASSINATURA            │
├─────────────────────────────────────────┤
│                                         │
│  1. MENSAL BÁSICO                       │
│     ID: premium_sub_monthly             │
│     Preço: R$ 9,99/mês                  │
│     ✓ Sem anúncios                      │
│     ✓ Análises básicas                  │
│     ✓ Backup na nuvem                   │
│     ✓ Suporte por email                 │
│                                         │
│  2. ANUAL PRO (40% DESCONTO) ⭐         │
│     ID: premium_sub_yearly              │
│     Preço: R$ 59,99/ano (~R$ 5/mês)    │
│     ✓ Tudo do Mensal +                  │
│     ✓ Análises avançadas                │
│     ✓ Exportação de dados               │
│     ✓ Múltiplas contas                  │
│                                         │
│  3. FAMÍLIA (5 Usuários)                │
│     ID: premium_sub_family              │
│     Preço: R$ 19,99/mês                 │
│     ✓ Tudo do Pro +                     │
│     ✓ 5 contas simultâneas              │
│     ✓ Controle parental                 │
│     ✓ Prioridade no suporte             │
│                                         │
└─────────────────────────────────────────┘

CONVERSÃO ESPERADA:
- Mensal: 1-2% de taxa de conversão
- Anual: 0.3-0.5% (melhor LTV - Lifetime Value)
- Família: 0.1-0.2% (segmento premium)
```

#### Como Criar Assinatura

1. **Tipo de Assinatura**:
   - Selecione **"Assinatura"**
   - **Período de faturamento**: Mensal, Anual, etc.

2. **IDs Obrigatórios**:
   ```
   premium_sub_monthly   → Mensal
   premium_sub_yearly    → Anual
   premium_sub_family    → Família
   ```

3. **Configurar Períodos de Teste**:
   - **Período de teste gratuito**: 7 dias (aumenta conversão)
   - Exemplo: "Teste grátis por 7 dias, depois R$ 9,99/mês"

4. **Políticas de Renovação**:
   - ✅ Ativar renovação automática
   - ✅ Permitir pausar (manter usuário engajado)
   - ✅ Permitir atrasar renovação

---

## 🏦 Verificação de Conta Bancária

### 3️⃣ Configurar Pagamentos

#### Acessar
```
Google Play Console > Configurações > Informações de conta > Conta bancária
```

#### Dados Necessários

**Para Brasil (Conta Corrente):**
- ✅ Titular da conta
- ✅ CPF do titular
- ✅ Número da agência (sem DV)
- ✅ Número da conta (sem DV)
- ✅ Tipo de conta (Corrente)
- ✅ Banco (código COMPE)
- ✅ Endereço completo
- ✅ Telefone
- ✅ CNPJ (se for PJ - recomendado)

**Bancos Principais:**
| Banco | Código |
|-------|--------|
| Banco do Brasil | 001 |
| Caixa | 104 |
| Bradesco | 237 |
| Itaú | 341 |
| Santander | 033 |

#### ⚠️ Imposto sobre Vendas

**IMPORTANTE**: Em 2021, Google começou a reter impostos:
- **Alíquota**: 15% sobre receita bruta (ajustável por estado/tipo)
- **Retenção automática**: Já descontado antes do depósito
- **Declaração**: Declare no IRPF como "Receita de PJ"

---

## 📋 Configurações de Políticas

### 4️⃣ Políticas de Monetização

#### Conformidade Obrigatória
```
Google Play Console > Seu App > Monetização > Configurações de monetização
```

**Checklist:**
- ✅ **Política de privacidade** - OBRIGATÓRIA
  - Link: https://finwase-privice.vercel.app/privacy_policy.html
  - Incluir: Dados coletados, uso, compartilhamento
  
- ✅ **Política de devolução** - Para IAP
  - Google Play oferece reembolso até 15 minutos após compra
  - Você pode estender até 30 minutos em Configurações

- ✅ **Termos de serviço** - OBRIGATÓRIO
  - Presente em: Legal/terms_of_service.html

- ✅ **Classificação Etária** - Marque corretamente
  - Finans é: **3+ anos** (sem conteúdo restrito)

#### Anúncios - Configuração Recomendada
```
Google Play Console > Seu App > Monetização > Anúncios
```

- **Tipo de conteúdo**: Aplicativo de negócios/finanças
- **Públicos-alvo**: Adultos (18+)
- **Marcar**: "Exibir anúncios de parceiros"
- **Desabilitar**: Anúncios para menores de idade

---

## 📊 Monitoramento de Receita

### 5️⃣ Análise Financeira

#### Dashboard de Receita
```
Google Play Console > Seu App > Monetização > Receita
```

**Métricas Importantes:**

| Métrica | O que é | Meta Realista |
|---------|---------|---------------|
| **Receita Total** | Todas as vendas brutas | Aumentar 20%/mês |
| **Receita Líquida** | Após impostos Google | 70% da bruta |
| **Taxa de Conversão** | % usuários que compram | 1-3% (Premium) |
| **LTV (Lifetime Value)** | Receita média por usuário | R$ 50-100 |
| **CAC (Customer Acquisition Cost)** | Custo para atrair usuário | < LTV |
| **Churn Rate** | % que cancela assinatura | < 5%/mês (ideal) |

#### Relatórios Disponíveis

1. **Por Produto**: Qual IAP vende mais
2. **Por País**: Mercados mais lucrativos
3. **Por Dispositivo**: iOS, Android (você tem Android)
4. **Por Período**: Diário, Semanal, Mensal

---

## 🚀 Estratégia de Monetização Recomendada para Finans

### Fase 1: Lançamento (Próximas 2 semanas)
```
- ✅ Anúncios (Banner + Interstitial)
- ✅ Remover Anúncios (R$ 4,99)
- ✅ Premium Mensal (R$ 9,99)
```

### Fase 2: Crescimento (Semanas 3-4)
```
- ✅ Tudo da Fase 1
- ✅ Premium Anual (R$ 59,99) - lançamento
- ✅ Teste grátis de 7 dias
```

### Fase 3: Otimização (Mês 2+)
```
- ✅ Analisar dados
- ✅ Adicionar Premium Vitalício se conversão alta
- ✅ Considerar modelo Família
- ✅ Ajustar preços por país
```

---

## 💡 Dicas Práticas

### ✨ Aumentar Conversão

1. **Mostrar valor premium CEDO**
   - Teaser no dia 3 de uso
   - Unlock feature limitada para incentivar compra

2. **Oferecer 7 dias grátis**
   - Aumenta conversão em ~50%
   - Depois cobra automaticamente

3. **Usar paywall (tela de compra)**
   - Mostrar antes do usuário tentar acessar premium
   - Listar benefícios específicos

4. **Preços em moeda local**
   - Google faz ajuste automático
   - Mas você pode customizar por país

5. **Teste A/B**
   - Experimente R$ 7,99 vs R$ 9,99 vs R$ 11,99
   - Veja qual tem melhor conversão

### 📈 Crescimento de Receita

| Ação | Impacto | Prazo |
|------|--------|-------|
| Adicionar Premium | +200% | Imediato |
| Teste grátis | +50% conversão | 1 semana |
| Otimizar copy | +20% | 2 semanas |
| Expandir geográfico | +100% | 1 mês |

---

## 🎯 Checklist Pré-Lançamento

- [ ] Conta bancária verificada no Play Console
- [ ] Pelo menos 1 produto IAP criado e testado
- [ ] Política de privacidade online e acessível
- [ ] Termos de serviço definidos
- [ ] Contas de teste configuradas no Google Play
- [ ] Publicidade configurada (AdMob)
- [ ] Receita configurada (Bank Info + Tax ID)
- [ ] Pricing definido para todos os produtos
- [ ] App aprovado pelo Google Play
- [ ] Monitor primeiro mês de vendas

---

## 📞 Contato & Suporte

**Problemas com monetização?**
- Google Play Support: https://support.google.com/googleplay
- Google AdMob Help: https://support.google.com/admob
- Play Console Help: https://support.google.com/playaccounts

**Sua conta:**
- Email: lorecout.dev@gmail.com
- App: Finans (com.lorecout.finwise)
- Status: Aguardando aprovação v1.0.6+7

---

**Última atualização**: 04/12/2025  
**Próximo passo**: Aguardar aprovação e ativar monetização no console
