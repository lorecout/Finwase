import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gastos_manager/services/backup_service.dart';
import 'package:gastos_manager/services/premium_service.dart';
import 'package:gastos_manager/utils/snackbar_utils.dart';
import 'package:gastos_manager/utils/dialog_utils.dart';
import 'package:gastos_manager/constants.dart';
import 'premium_feature_access_page.dart';

/// Widget para a seção de dados nas configurações
class DataSettingsSection extends StatelessWidget {
  const DataSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<BackupService, PremiumService>(
      builder: (context, backupService, premiumService, child) {
        return Card(
          child: Column(
            children: [
              _buildSettingsTile(
                context,
                icon: Icons.cloud_upload,
                title: AppConstants.cloudBackup,
                subtitle: backupService.isBackupEnabled
                    ? AppConstants.automaticBackup
                    : AppConstants.keepDataSafe,
                trailing: Switch(
                  value: backupService.isBackupEnabled,
                  onChanged: (value) => _toggleCloudBackup(
                    context,
                    value,
                    backupService,
                    premiumService,
                  ),
                ),
              ),
              _buildDivider(),
              if (backupService.lastBackupDate != null)
                _buildSettingsTile(
                  context,
                  icon: Icons.history,
                  title: AppConstants.lastBackup,
                  subtitle: _formatDateTime(backupService.lastBackupDate!),
                  onTap: () => _showBackupHistory(context, backupService),
                ),
              if (backupService.lastBackupDate != null) _buildDivider(),
              _buildSettingsTile(
                context,
                icon: Icons.backup,
                title: AppConstants.manualBackup,
                subtitle: backupService.isBackingUp
                    ? 'Fazendo backup...'
                    : AppConstants.saveCurrentData,
                onTap: backupService.isBackingUp
                    ? null
                    : () => _performManualBackup(context, backupService),
                trailing: backupService.isBackingUp
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : null,
              ),
              _buildDivider(),
              _buildSettingsTile(
                context,
                icon: Icons.restore,
                title: AppConstants.restoreBackupSetting,
                subtitle: AppConstants.recoverSavedData,
                onTap: () => _showRestoreDialog(context, backupService),
              ),
              _buildDivider(),
              _buildSettingsTile(
                context,
                icon: Icons.file_download,
                title: AppConstants.exportDataSetting,
                subtitle: premiumService.isPro
                    ? 'PDF e CSV disponíveis'
                    : 'Formato CSV',
                onTap: () => _showExportDialog(context, premiumService),
              ),
              _buildDivider(),
              _buildSettingsTile(
                context,
                icon: Icons.file_upload,
                title: AppConstants.importDataSetting,
                subtitle: AppConstants.loadData,
                onTap: () => _showImportDialog(context),
              ),
              _buildDivider(),
              _buildSettingsTile(
                context,
                icon: Icons.delete_forever,
                title: AppConstants.clearAllData,
                subtitle: AppConstants.deleteAllTransactions,
                onTap: () => _showClearDataDialog(context),
              ),
              _buildDivider(),
              _buildSettingsTile(
                context,
                icon: Icons.bug_report,
                title: 'Debug & Análise',
                subtitle: 'Analisar e limpar dados fictícios',
                onTap: () => Navigator.pushNamed(context, '/debug'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Widget? trailing,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w500, color: textColor),
      ),
      subtitle: Text(subtitle),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, indent: 56);
  }

  void _toggleCloudBackup(
    BuildContext context,
    bool value,
    BackupService backupService,
    PremiumService premiumService,
  ) {
    if (!premiumService.isPro && value) {
      // Se não é premium, mostrar página de acesso premium
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PremiumFeatureAccessPage(
            featureName: 'Backup Automático na Nuvem',
            featureDescription:
                'Salve seus dados automaticamente na nuvem e tenha backup seguro',
            featureIcon: Icons.cloud_upload,
            onAccessGranted: () {
              backupService.toggleBackup(value);
              SnackBarUtils.showInfo(
                context,
                value
                    ? 'Backup automático ativado!'
                    : AppConstants.backupDisabled,
              );
            },
          ),
        ),
      );
      return;
    }

    backupService.toggleBackup(value);
    SnackBarUtils.showInfo(
      context,
      value ? 'Backup automático ativado!' : AppConstants.backupDisabled,
    );
  }

  void _showBackupHistory(BuildContext context, BackupService backupService) {
    DialogUtils.showInfoDialog(
      context,
      title: AppConstants.backupHistory,
      content: backupService.lastBackupDate != null
          ? 'Último backup: ${_formatDateTime(backupService.lastBackupDate!)}\n\nStatus: ${backupService.isBackupEnabled ? 'Ativo' : 'Inativo'}'
          : 'Nenhum backup realizado ainda.',
      buttonText: AppConstants.close,
    );
  }

  Future<void> _performManualBackup(
    BuildContext context,
    BackupService backupService,
  ) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    await backupService.performBackup();
    scaffoldMessenger.showSnackBar(
      const SnackBar(
        content: Text(AppConstants.backupSuccessful),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _showRestoreDialog(
    BuildContext context,
    BackupService backupService,
  ) async {
    if (backupService.lastBackupDate == null) {
      SnackBarUtils.showWarning(context, AppConstants.noBackupAvailable);
      return;
    }

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final confirmed = await DialogUtils.showConfirmationDialog(
      context,
      title: AppConstants.restoreBackup,
      content:
          'Isso irá substituir todos os dados atuais pelos dados do backup de ${_formatDateTime(backupService.lastBackupDate!)}. Esta ação não pode ser desfeita.',
      confirmText: AppConstants.restore,
      confirmColor: Colors.blue,
    );

    if (confirmed == true) {
      await backupService.restoreBackup();
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text(AppConstants.backupRestored),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _showExportDialog(BuildContext context, PremiumService premiumService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppConstants.exportData),
        content: const Text(AppConstants.exportFormatQuestion),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppConstants.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              SnackBarUtils.showInfo(context, AppConstants.exportingCsv);
            },
            child: const Text(AppConstants.csv),
          ),
          if (premiumService.isPro)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                SnackBarUtils.showInfo(context, AppConstants.exportingPdf);
              },
              child: const Text(AppConstants.pdf),
            ),
        ],
      ),
    );
  }

  void _showImportDialog(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    DialogUtils.showConfirmationDialog(
      context,
      title: AppConstants.importData,
      content: AppConstants.importDataDescription,
      confirmText: AppConstants.selectFile,
      confirmColor: Colors.blue,
    ).then((confirmed) {
      if (confirmed == true) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text(AppConstants.selectingFile)),
        );
      }
    });
  }

  void _showClearDataDialog(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    DialogUtils.showConfirmationDialog(
      context,
      title: AppConstants.clearAllData,
      content: AppConstants.clearDataWarning,
      confirmText: AppConstants.deleteAll,
      confirmColor: Colors.red,
    ).then((confirmed) {
      if (confirmed == true) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text(AppConstants.dataCleared),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return 'Hoje às ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Ontem às ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} dias atrás';
    } else {
      return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
    }
  }
}
