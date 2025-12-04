import 'package:flutter/material.dart';
import 'package:gastos_manager/utils/snackbar_utils.dart';
import 'package:gastos_manager/utils/dialog_utils.dart';
import 'package:gastos_manager/constants.dart';

/// Widget para a seção de suporte nas configurações
class SupportSettingsSection extends StatelessWidget {
  const SupportSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _buildSettingsTile(
            context,
            icon: Icons.help_center,
            title: AppConstants.helpCenterSetting,
            subtitle: AppConstants.faqAndTutorials,
            onTap: () => _showHelpCenter(context),
          ),
          _buildDivider(),
          _buildSettingsTile(
            context,
            icon: Icons.bug_report,
            title: AppConstants.bugReportSetting,
            subtitle: AppConstants.sendFeedback,
            onTap: () => _showBugReportDialog(context),
          ),
          _buildDivider(),
          _buildSettingsTile(
            context,
            icon: Icons.star_rate,
            title: AppConstants.rateApp,
            subtitle: AppConstants.leaveRating,
            onTap: () => _rateApp(context),
          ),
          _buildDivider(),
          _buildSettingsTile(
            context,
            icon: Icons.info,
            title: AppConstants.about,
            subtitle: AppConstants.versionAndInfo,
            onTap: () => _showAboutDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, indent: 56);
  }

  void _showHelpCenter(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text(AppConstants.helpCenter)),
          body: const Center(
            child: Text('Central de Ajuda em desenvolvimento'),
          ),
        ),
      ),
    );
  }

  void _showBugReportDialog(BuildContext context) {
    DialogUtils.showTextInputDialog(
      context,
      title: AppConstants.bugReport,
      labelText: AppConstants.bugDescription,
      maxLines: 5,
    ).then((description) {
      if (description != null && description.isNotEmpty) {
        SnackBarUtils.showSuccess(context, AppConstants.bugReportSent);
      }
    });
  }

  void _rateApp(BuildContext context) {
    SnackBarUtils.showInfo(context, AppConstants.redirectingToStore);
  }

  void _showAboutDialog(BuildContext context) {
    DialogUtils.showInfoDialog(
      context,
      title: AppConstants.aboutApp,
      content: '${AppConstants.appDescription}\n\n${AppConstants.appFeatures}',
      buttonText: AppConstants.close,
    );
  }
}
