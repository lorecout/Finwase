/// Constantes da aplicação
/// Centraliza todas as strings, mensagens e valores constantes
library;

class AppConstants {
  // === MENSAGENS DE SUCESSO ===
  static const String transactionAdded = 'Transação adicionada com sucesso!';
  static const String transactionUpdated = 'Transação atualizada com sucesso!';
  static const String transactionDeleted = 'Transação excluída';
  static const String categoryDeleted = 'Categoria excluída';
  static const String budgetDeleted = 'Orçamento excluído';
  static const String emailUpdated = 'Email atualizado com sucesso!';
  static const String passwordChanged = 'Senha alterada com sucesso!';
  static const String dataCleared = 'Todos os dados foram apagados';
  static const String bugReportSent = 'Relatório enviado! Obrigado.';
  static const String profileUpdated = 'Perfil salvo com sucesso!';
  static const String profilePhotoUpdated = 'Foto de perfil atualizada!';
  static const String backupSuccessful = 'Backup realizado com sucesso!';
  static const String backupRestored = 'Backup restaurado com sucesso!';

  // === MENSAGENS DE ERRO ===
  static const String unexpectedError = 'Erro inesperado';
  static const String googleLoginError = 'Erro ao fazer login com Google';
  static const String guestLoginError = 'Erro ao entrar como visitante';
  static const String selectCategory = 'Selecione uma categoria';
  static const String noBackupAvailable =
      'Nenhum backup disponível para restaurar';

  // === MENSAGENS INFORMATIVAS ===
  static const String selectingFile = 'Selecionando arquivo...';
  static const String redirectingToStore = 'Redirecionando para a loja...';
  static const String checkingPurchases = 'Verificando compras anteriores...';
  static const String exportingCsv = 'Exportando para CSV...';
  static const String exportingPdf = 'Exportando para PDF...';
  static const String exportingData = 'Exportando dados...';
  static const String exportingAllData = 'Exportando todos os dados...';
  static const String performingBackup = 'Fazendo backup...';
  static const String backupEnabled = 'Backup automático ativado!';
  static const String backupDisabled = 'Backup automático desativado';
  static const String biometricEnabled = 'Autenticação biométrica ativada';
  static const String biometricDisabled = 'Autenticação biométrica desativada';
  static const String notificationsEnabled = 'Notificações ativadas';
  static const String notificationsDisabled = 'Notificações desativadas';

  // === TÍTULOS DE DIÁLOGOS ===
  static const String changeEmail = 'Alterar Email';
  static const String changePassword = 'Alterar Senha';
  static const String chooseLanguage = 'Escolher Idioma';
  static const String chooseCurrency = 'Escolher Moeda';
  static const String importData = 'Importar Dados';
  static const String clearAllData = 'Limpar Todos os Dados';
  static const String helpCenter = 'Central de Ajuda';
  static const String bugReport = 'Reportar Bug';
  static const String aboutApp = 'Sobre o FinWise';
  static const String logout = 'Sair da Conta';
  static const String backupHistory = 'Histórico de Backup';
  static const String restoreBackup = 'Restaurar Backup';
  static const String exportData = 'Exportar Dados';
  static const String premiumFeature = 'Recurso Premium';

  // === DESCRIÇÕES E TEXTOS ===
  static const String premiumRequired =
      'Esta funcionalidade está disponível apenas para usuários Premium.';
  static const String bulkTransactionsPremium =
      'A funcionalidade de Registros em Massa está disponível apenas para usuários Premium.';
  static const String bulkTransactionsFeatures =
      'Com o Premium você pode:\n• Importar transações via CSV\n• Adicionar múltiplas transações rapidamente\n• Usar templates personalizados\n• E muito mais!';
  static const String guestMode = 'Modo Visitante';
  static const String guestModeDescription =
      'Faça login para sincronizar seus dados na nuvem e acessar recursos avançados.';
  static const String logoutConfirmation =
      'Tem certeza que deseja sair da sua conta? Você precisará fazer login novamente.';
  static const String clearDataWarning =
      'Esta ação irá apagar TODAS as suas transações, categorias e orçamentos. Esta ação não pode ser desfeita.';
  static const String importDataDescription =
      'Selecione um arquivo CSV para importar suas transações. Os dados existentes serão mantidos.';
  static const String restoreBackupWarning =
      'Isso irá substituir todos os dados atuais pelos dados do backup de';
  static const String backupRestoreWarning = 'Esta ação não pode ser desfeita.';
  static const String exportFormatQuestion =
      'Escolha o formato para exportar seus dados:';

  // === RÓTULOS DE CAMPOS ===
  static const String email = 'Email';
  static const String password = 'Senha';
  static const String currentPassword = 'Senha atual';
  static const String newPassword = 'Nova senha';
  static const String confirmPassword = 'Confirmar nova senha';
  static const String newEmail = 'Novo email';
  static const String description = 'Descrição';
  static const String bugDescription = 'Descreva o problema encontrado';
  static const String amount = 'Valor (R\$)';
  static const String category = 'Categoria';
  static const String date = 'Data';
  static const String observations = 'Observações';

  // === BOTÕES ===
  static const String cancel = 'Cancelar';
  static const String save = 'Salvar';
  static const String apply = 'Aplicar';
  static const String selectFile = 'Selecionar Arquivo';
  static const String csv = 'CSV';
  static const String pdf = 'PDF';
  static const String send = 'Enviar';
  static const String close = 'Fechar';
  static const String upgrade = 'FAZER UPGRADE';
  static const String deleteAll = 'APAGAR TUDO';
  static const String restore = 'RESTAURAR';
  static const String logoutButton = 'SAIR';

  // === SEÇÕES ===
  static const String account = 'Conta';
  static const String personalization = 'Personalização';
  static const String data = 'Dados';
  static const String support = 'Suporte';
  static const String premium = 'Premium';

  // === CONFIGURAÇÕES ===
  static const String profile = 'Perfil';
  static const String editPersonalInfo = 'Editar informações pessoais';
  static const String changeEmailSetting = 'Email';
  static const String changePasswordSetting = 'Alterar Senha';
  static const String changePasswordDescription =
      'Atualizar sua senha de acesso';
  static const String biometricAuth = 'Autenticação Biométrica';
  static const String biometricDescription =
      'Use digital ou Face ID para entrar';
  static const String themesAndColors = 'Temas e Cores';
  static const String customizeApp = 'Personalizar aparência do app';
  static const String language = 'Idioma';
  static const String portugueseBrazil = 'Português (Brasil)';
  static const String english = 'English';
  static const String spanish = 'Español';
  static const String currency = 'Moeda';
  static const String brazilianReal = 'Real (R\$)';
  static const String usd = 'Dólar (US\$)';
  static const String euro = 'Euro (€)';
  static const String notifications = 'Notificações';
  static const String configureAlerts = 'Configurar alertas e lembretes';
  static const String cloudBackup = 'Backup na Nuvem';
  static const String keepDataSafe = 'Mantenha seus dados seguros';
  static const String automaticBackup = 'Backup automático ativado';
  static const String lastBackup = 'Último Backup';
  static const String manualBackup = 'Fazer Backup Agora';
  static const String saveCurrentData = 'Salvar dados atuais';
  static const String restoreBackupSetting = 'Restaurar Backup';
  static const String recoverSavedData = 'Recuperar dados salvos';
  static const String exportDataSetting = 'Exportar Dados';
  static const String importDataSetting = 'Importar Dados';
  static const String loadData = 'Carregar dados de outros apps';
  static const String clearData = 'Limpar Dados';
  static const String deleteAllTransactions = 'Apagar todas as transações';
  static const String helpCenterSetting = 'Central de Ajuda';
  static const String faqAndTutorials = 'Perguntas frequentes e tutoriais';
  static const String bugReportSetting = 'Reportar Bug';
  static const String sendFeedback = 'Envie feedback sobre problemas';
  static const String rateApp = 'Avaliar App';
  static const String leaveRating = 'Deixe sua avaliação na loja';
  static const String about = 'Sobre';
  static const String versionAndInfo = 'Versão 1.0.0 - Informações do app';
  static const String premiumActive = 'Premium Ativo';
  static const String currentPlan = 'Plano Atual';
  static const String expiresIn = 'Expira em';
  static const String restorePurchases = 'Restaurar Compras';
  static const String recoverPreviousSubscription =
      'Recuperar assinatura anterior';
  static const String logoutSetting = 'Sair da Conta';
  static const String logoutDescription = 'Fazer logout do aplicativo';

  // === VALORES NUMÉRICOS ===
  static const int snackBarShortDuration = 500; // milliseconds
  static const int snackBarLongDuration = 3000; // milliseconds

  // === FORMATOS ===
  static const String csvFormatExample =
      'Descrição,Valor,Tipo,Categoria,Data,Observações\nSupermercado,150.50,despesa,Alimentação,01/10/2024,Compras da semana\nSalário,3000.00,receita,Trabalho,01/10/2024,';
  static const String csvTips =
      '• Use vírgula como separador\n• Tipo pode ser "receita" ou "despesa"\n• Data no formato DD/MM/AAAA\n• Campos observações e data são opcionais';

  // === SOBRE O APP ===
  static const String appName = 'FinWise - Controle Financeiro Pessoal';
  static const String appVersion = 'Versão: 1.0.0';
  static const String appDescription =
      'Desenvolvido para ajudar você a ter controle total sobre suas finanças pessoais.';
  static const String appFeatures =
      'Funcionalidades:\n• Controle de receitas e despesas\n• Categorização de transações\n• Relatórios e gráficos detalhados\n• Metas de orçamento\n• Temas personalizáveis\n• Backup na nuvem';
}
