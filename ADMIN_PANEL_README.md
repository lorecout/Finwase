# 🛠️ Painel Administrativo FinWise

Sistema web para gerenciamento completo de usuários premium e administradores do aplicativo FinWise.

## 📋 Funcionalidades

### 👥 Gerenciamento de Usuários
- ✅ **Dashboard com estatísticas** - Visão geral de usuários totais, premium, trial e free
- ✅ **Lista de usuários** - Visualização completa de todos os usuários cadastrados
- ✅ **Busca e filtros** - Encontre usuários rapidamente por nome ou email
- ✅ **Concessão de premium** - Conceda acesso premium com duração customizada
- ✅ **Extensão de premium** - Estenda o período premium de usuários existentes
- ✅ **Remoção de premium** - Remova acesso premium quando necessário
- ✅ **Histórico de ações** - Todas as ações são registradas no Firestore
- ✅ **Interface responsiva** - Funciona em desktop e dispositivos móveis

### 👑 Gerenciamento de Administradores
- ✅ **Lista de admins** - Visualizar todos os administradores cadastrados
- ✅ **Adicionar admins** - Incluir novos administradores via interface web
- ✅ **Remover admins** - Remover administradores existentes com confirmação
- ✅ **Sincronização automática** - Mantém lista atualizada em tempo real

### 📊 Analytics e Estatísticas
- ✅ **Métricas em tempo real** - Usuários totais, premium, trial e free
- ✅ **Receita mensal** - Cálculo automático baseado em usuários premium (R$ 9,99/mês)
- ✅ **Novos cadastros** - Contagem de cadastros nos últimos 30 dias
- ✅ **Gráficos visuais** - Distribuição de usuários e receita estimada
- ✅ **Dashboard interativo** - Interface moderna com abas organizadas

## 🚀 Como Usar

### 1. Configuração Inicial

1. **Configure o Firebase:**
   - Abra `admin_login.html` e `admin_panel.html`
   - Substitua a configuração do Firebase (linhas ~70-80) pelas suas credenciais reais:

```javascript
const firebaseConfig = {
    apiKey: "your-actual-api-key",
    authDomain: "your-project.firebaseapp.com",
    projectId: "your-actual-project-id",
    storageBucket: "your-project.appspot.com",
    messagingSenderId: "123456789",
    appId: "your-actual-app-id"
};
```

### 2. Lista de Administradores

A lista de emails autorizados está definida nas duas páginas (linha ~85):

```javascript
const adminEmails = [
    'lorenalessa90@gmail.com',
    'admin@finwise.com'
];
```

**Para adicionar novos admins:**
1. Edite a lista `adminEmails` em ambos os arquivos
2. Mantenha sincronizada com a lista no `premium_service.dart` do app Flutter

### 3. Acesso ao Sistema

1. Abra `admin_login.html` no navegador
2. Faça login com um email autorizado
3. Use a senha da conta Firebase Auth

### 4. Gerenciamento de Usuários

#### Conceder Premium:
- Selecione um usuário na lista
- Clique em "Conceder Premium"
- Defina o número de dias
- Adicione um motivo (opcional)

#### Estender Premium:
- Selecione um usuário premium
- Clique em "Estender Premium"
- Defina dias adicionais
- Adicione motivo da extensão

#### Remover Premium:
- Selecione um usuário premium
- Clique em "Remover Premium"
- Justifique o motivo da remoção

### 5. Gerenciamento de Administradores

#### ⚠️ IMPORTANTE: Apenas Super Admin
Esta funcionalidade está disponível **APENAS** para o Super Admin (`lorenalessa90@gmail.com`).

#### Adicionar Administrador:
- Clique na aba "Administradores" (visível apenas para Super Admin)
- Clique em "Adicionar Admin"
- Digite o email do novo administrador
- Confirme a adição

#### Remover Administrador:
- Na aba "Administradores", localize o admin desejado
- Clique em "Remover" no card do administrador
- Confirme a remoção na caixa de diálogo

#### Para Admins Regulares:
- A aba "Administradores" não será visível
- Tentativas de acesso serão bloqueadas
- Mensagem de aviso sobre permissões limitadas

### 6. Visualizar Analytics

#### Aba Analytics:
- **Distribuição de Usuários**: Gráfico visual da proporção Premium/Trial/Free
- **Receita Mensal**: Cálculo automático baseado em usuários premium
- **Métricas Gerais**: Contadores atualizados em tempo real
- **Novos Cadastros**: Usuários registrados nos últimos 30 dias

## 📊 Dados Armazenados

Cada ação administrativa é registrada no Firestore com:

```javascript
{
    // Dados originais do usuário
    email: "user@example.com",
    displayName: "Nome do Usuário",
    isPremium: true,
    currentPlan: "admin",
    premiumExpiryDate: Timestamp,

    // Dados administrativos
    adminGrantedAt: Timestamp,      // Quando foi concedido
    adminGrantedBy: "admin-uid",    // Quem concedeu
    adminReason: "Cliente VIP",     // Motivo

    adminExtendedAt: Timestamp,     // Quando foi estendido
    adminExtendedBy: "admin-uid",   // Quem estendeu
    adminExtendReason: "Renovação", // Motivo da extensão

    adminRemovedAt: Timestamp,      // Quando foi removido
    adminRemovedBy: "admin-uid",    // Quem removeu
    adminRemoveReason: "Solicitação do usuário", // Motivo da remoção

    updatedAt: Timestamp            // Última atualização
}
```

### Coleção `config` - Configurações do Sistema (APENAS SUPER ADMIN):
```javascript
// Documento: adminEmails
{
  emails: [
    "lorenalessa90@gmail.com",  // Super Admin
    "admin@finwise.com"        // Admin regular
  ]
}
// ✅ Leitura: Todos os usuários autenticados
// ✏️ Escrita: APENAS Super Admin
```

## 🔒 Segurança

### Níveis de Acesso

- **👑 SUPER ADMIN** (`lorenalessa90@gmail.com`):
  - Acesso total ao sistema
  - Pode gerenciar administradores (adicionar/remover)
  - Pode gerenciar usuários premium
  - Acesso a todas as abas e funcionalidades

- **🛡️ ADMIN REGULAR** (outros emails na lista):
  - Pode gerenciar usuários premium (conceder/estender/remover)
  - Acesso aos analytics e estatísticas
  - **NÃO** pode ver ou acessar a aba "Administradores"
  - **NÃO** pode modificar configurações de admin

- **👤 USUÁRIO NORMAL**:
  - Sem acesso ao painel administrativo
  - Apenas usuários regulares do app

### Autenticação obrigatória
- Apenas usuários logados podem acessar
- Verificação de email em lista autorizada
- Logs completos de todas as ações
- Validação de entrada antes do envio

### Proteções Implementadas
- ✅ Aba "Administradores" invisível para admins regulares
- ✅ Funções de gerenciamento de admin bloqueadas
- ✅ Firestore rules atualizadas para super admin apenas
- ✅ Verificações de permissão em tempo real
- ✅ Avisos claros sobre limitações de acesso

## 🌐 Hospedagem

Para usar em produção, hospede os arquivos em:

- **Firebase Hosting** (recomendado)
- **Vercel**
- **Netlify**
- **GitHub Pages** (com limitações de CORS)

### Exemplo com Firebase Hosting:

```bash
# Instalar Firebase CLI
npm install -g firebase-tools

# Inicializar projeto
firebase init hosting

# Fazer deploy
firebase deploy
```

## 🛠️ Desenvolvimento Local

Para testar localmente:

1. Abra os arquivos HTML diretamente no navegador
2. Configure as credenciais do Firebase
3. Certifique-se de que o Firestore permite leituras/escritas

## 📱 Responsividade

O painel é totalmente responsivo e funciona em:
- 💻 Desktop
- 📱 Tablets
- 📱 Celulares

## 🎨 Personalização

Para personalizar o visual:

1. **Cores:** Edite as variáveis CSS no `<style>` dos arquivos
2. **Logo:** Substitua o emoji 🛠️ por uma imagem
3. **Textos:** Modifique os textos em português
4. **Layout:** Ajuste o CSS Grid/Flexbox conforme necessário

## 🔧 Manutenção

### Atualização da Lista de Admins:
- **Via interface web**: Use a aba "Administradores" no painel
- **Sincronização automática**: Mudanças são refletidas imediatamente
- **Backup**: Lista armazenada no Firestore para persistência

### Backup de Dados:
- Os dados ficam no Firestore
- Configure backups automáticos no Firebase Console
- Exportações manuais disponíveis via Firebase Admin SDK

### Monitoramento:
- Use Firebase Analytics para acompanhar uso do painel
- Monitore erros no Firebase Crashlytics
- Dashboard de analytics integrado para métricas de negócio

## 📞 Suporte

Para dúvidas ou problemas:
1. Verifique o console do navegador (F12)
2. Confirme as configurações do Firebase
3. Valide as regras do Firestore

---

## 🆕 Novas Funcionalidades v2.0

### Interface com Abas
- **Organização intuitiva**: Abas separadas para Usuários, Administradores e Analytics
- **Navegação fluida**: Alternância rápida entre diferentes seções
- **Design moderno**: Interface limpa e profissional

### Gerenciamento de Administradores Web
- **Adição via web**: Não precisa mais editar código para adicionar admins
- **Remoção segura**: Confirmação obrigatória para remoção de admins
- **Sincronização em tempo real**: Mudanças refletidas imediatamente

### Dashboard de Analytics Avançado
- **Métricas visuais**: Gráficos de distribuição de usuários
- **Receita estimada**: Cálculo automático baseado em R$ 9,99/mês por usuário premium
- **KPIs importantes**: Novos cadastros, conversão trial-premium
- **Dados em tempo real**: Atualização automática das estatísticas

### Melhorias de UX
- **Responsividade total**: Perfeito em desktop, tablet e mobile
- **Feedback visual**: Notificações claras para todas as ações
- **Loading states**: Indicadores visuais durante operações
- **Validação robusta**: Verificação de dados antes do envio

---

## 🆕 Novas Funcionalidades v2.1 - Controle de Acesso Seguro

### Sistema de Níveis de Acesso
- **👑 Super Admin**: Controle total sobre administradores e usuários
- **🛡️ Admin Regular**: Gerenciamento de usuários premium apenas
- **🔒 Interface Adaptativa**: Abas e funcionalidades visíveis apenas para quem tem permissão

### Segurança Aprimorada
- **Controle Granular**: Diferentes níveis de acesso para diferentes funções
- **Interface Oculta**: Abas confidenciais não aparecem para usuários sem permissão
- **Bloqueio de Funções**: Tentativas de acesso não autorizado são rejeitadas
- **Firestore Rules**: Regras atualizadas para proteger configurações críticas

### Feedback de Segurança
- **Avisos Claros**: Usuários sabem quando não têm permissão
- **Logs de Tentativas**: Todas as tentativas são registradas
- **Mensagens Contextuais**: Explicações sobre por que o acesso foi negado

### Proteções Técnicas
- **Verificação em Tempo Real**: Permissões verificadas antes de cada ação
- **Validação no Frontend**: Bloqueio preventivo de ações não autorizadas
- **Regras no Backend**: Proteção adicional no Firestore
- **Auditoria Completa**: Histórico de todas as ações administrativas

---

**Desenvolvido para FinWise - Sistema de Gerenciamento Financeiro** 💰
**Versão 2.1 - Controle de Acesso Seguro**