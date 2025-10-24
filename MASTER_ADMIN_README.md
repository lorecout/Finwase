# 🛠️ Gerenciador Master - FinWise

Página web completa para gerenciamento total de contas do aplicativo FinWise, executada no seu servidor interno.

## 📋 Visão Geral

Esta página oferece **controle absoluto** sobre todas as contas registradas no seu aplicativo, com interface intuitiva e poderosa para:

- ✅ **Visualizar todas as contas** com detalhes completos
- ✅ **Buscar e filtrar** usuários rapidamente
- ✅ **Bloquear/desbloquear** contas instantaneamente
- ✅ **Gerenciar privilégios** (usuário comum, premium, admin)
- ✅ **Excluir contas** permanentemente (com confirmação)
- ✅ **Ações em massa** para múltiplas contas
- ✅ **Auditoria completa** de todas as ações

## 🚀 Como Usar

### 1. Configuração Inicial

1. **Configure o Firebase:**
   - Abra `master_admin.html`
   - Substitua a configuração do Firebase (linha ~470):

```javascript
const firebaseConfig = {
    apiKey: "your-actual-api-key",
    authDomain: "your-project.firebaseapp.com",
    projectId: "your-actual-project-id",
    storageBucket: "your-project.appspot.com",
    messagingSenderId: "123456789012",
    appId: "your-actual-app-id"
};
```

### 2. Executar no Servidor Interno

Como esta página é para **servidor interno**, você pode:

- **Executar localmente:** Abra o arquivo HTML diretamente no navegador
- **Servidor local:** Use `python -m http.server` ou similar
- **Servidor interno:** Hospede em seu servidor corporativo

### 3. Autenticação

A página está configurada para **servidor interno**, então:
- ✅ **Autenticação simplificada** (você controla o acesso)
- ✅ **Acesso direto** sem login complexo
- ✅ **Segurança por isolamento** (apenas rede interna)

Se quiser manter autenticação Firebase, descomente o código na linha ~580.

## 🎯 Funcionalidades Principais

### 📊 Dashboard de Estatísticas
- **Usuários Totais:** Contagem geral
- **Contas Ativas:** Usuários não bloqueados
- **Contas Bloqueadas:** Usuários suspensos
- **Usuários Premium:** Contas pagas

### 🔍 Busca e Filtros Avançados

#### Busca por Texto
- **Nome do usuário**
- **Email**
- **UID do Firebase**

#### Filtros por Status
- **Todos:** Lista completa
- **Ativos:** Apenas contas ativas
- **Bloqueados:** Apenas contas suspensas
- **Premium:** Apenas usuários premium
- **Admins:** Apenas administradores

#### Ordenação
- **Data de cadastro**
- **Nome (A-Z)**
- **Email**
- **Último acesso**

### 👤 Gerenciamento Individual

#### Visualizar Detalhes
Clique em qualquer usuário para ver:
- **Informações básicas:** Nome, email, UID
- **Status da conta:** Ativa/bloqueada
- **Privilégios:** Usuário comum, premium, admin
- **Datas importantes:** Cadastro, último acesso
- **Plano atual**

#### Ações Rápidas (Botões na Lista)
- **🔒 Bloquear/🔓 Desbloquear:** Suspender/restaurar conta
- **💎 Conceder/💰 Remover Premium:** Gerenciar assinatura
- **🗑️ Excluir:** Remover conta permanentemente

#### Edição Completa (Modal de Detalhes)
- **Alterar status:** Ativa/bloqueada
- **Modificar privilégios:** Usuário comum → Premium → Admin
- **Definir período premium:** Dias de validade
- **Justificativa obrigatória:** Motivo de cada alteração

### ⚡ Ações em Massa

Para gerenciar múltiplas contas simultaneamente:

1. Clique **"Ações em Massa"**
2. **Selecione filtro:** Todos, ativos, bloqueados, premium, etc.
3. **Escolha ação:**
   - Bloquear contas
   - Desbloquear contas
   - Conceder premium (30 dias)
   - Remover premium
   - **EXCLUIR CONTAS** (extremamente perigoso!)
4. **Justificativa obrigatória**
5. **Confirmação dupla:** Digite "CONFIRMAR" para executar

## 🔐 Segurança e Controles

### Níveis de Privilégio
- **SUPER ADMIN:** Você (lorenalessa90@gmail.com) - Controle total
- **ADMIN:** Outros admins - Acesso limitado
- **USUÁRIO:** Usuários normais - Sem acesso

### Proteções Implementadas
- ✅ **Confirmações duplas** para ações perigosas
- ✅ **Logs completos** de todas as modificações
- ✅ **Motivos obrigatórios** para todas as alterações
- ✅ **Validação de entrada** em todos os campos
- ✅ **Isolamento por servidor interno**

### Auditoria
Cada ação é registrada com:
```javascript
{
  adminModifiedAt: Timestamp,
  adminModifiedBy: "admin-uid",
  adminModificationReason: "Motivo da alteração",
  updatedAt: Timestamp
}
```

## 📊 Dados Gerenciados

### Campos Principais
- `isBlocked`: Conta suspensa (true/false)
- `isPremium`: Status premium (true/false)
- `isAdmin`: Privilégios de admin (true/false)
- `currentPlan`: Plano atual (free/premium/admin)
- `premiumExpiryDate`: Validade do premium
- `adminModifiedAt`: Última modificação
- `adminModificationReason`: Motivo da alteração

### Subcoleções (se existirem)
- `transactions`: Histórico financeiro
- `files`: Arquivos do usuário

## 🎨 Interface e UX

### Design Responsivo
- ✅ **Desktop:** Layout completo com grid
- ✅ **Tablet:** Adaptação automática
- ✅ **Mobile:** Interface otimizada

### Feedback Visual
- 🟢 **Verde:** Ações positivas (ativar, conceder)
- 🔴 **Vermelho:** Ações perigosas (bloquear, excluir)
- 🟡 **Amarelo:** Ações neutras (alterar)
- 🔵 **Azul:** Informações e navegação

### Estados de Loading
- **Spinner animado** durante operações
- **Mensagens de status** para feedback
- **Atualização automática** após ações

## 🚨 Avisos Importantes

### ⚠️ Ações Irreversíveis
- **Exclusão de contas** não pode ser desfeita
- **Sempre faça backup** antes de ações em massa
- **Verifique filtros** antes de executar ações

### 🔒 Segurança
- **Mantenha o acesso restrito** à rede interna
- **Monitore logs** regularmente
- **Faça backups** frequentes do Firestore

### 💡 Recomendações
- **Teste primeiro** com contas de teste
- **Documente procedimentos** internos
- **Treine equipe** no uso correto
- **Audite ações** periodicamente

## 🛠️ Desenvolvimento e Manutenção

### Personalização
```javascript
// Modificar cores no CSS
.stat-card.active {
    background: linear-gradient(135deg, #48bb78, #38a169);
}

// Adicionar novos filtros
case 'newFilter':
    filtered = filtered.filter(u => u.customField === value);
    break;
```

### Extensões Possíveis
- 📊 **Gráficos avançados** (Chart.js)
- 📧 **Notificações por email**
- 📱 **API REST** para integrações
- 🔄 **Sincronização automática**
- 📋 **Relatórios em PDF**

## 📞 Suporte

Para questões técnicas:
1. Verifique o **console do navegador** (F12)
2. Confirme **configuração do Firebase**
3. Valide **regras do Firestore**
4. Teste com **dados de exemplo**

---

**🛠️ Gerenciador Master - Controle Total sobre suas Contas**
**Versão 1.0 - Servidor Interno**