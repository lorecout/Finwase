import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gastos_manager/utils/dialog_utils.dart';
import 'package:gastos_manager/utils/snackbar_utils.dart';
import 'package:gastos_manager/constants.dart';
import 'package:gastos_manager/services/settings_service.dart';

/// Widget para a seção de personalização nas configurações
class PersonalizationSettingsSection extends StatelessWidget {
  const PersonalizationSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsService>(
      builder: (context, settingsService, child) {
        return Card(
          child: Column(
            children: [
              _buildSettingsTile(
                context,
                icon: Icons.palette,
                title: AppConstants.themesAndColors,
                subtitle: AppConstants.customizeApp,
                onTap: () {
                  Navigator.pushNamed(context, '/theme-settings');
                },
              ),
              _buildDivider(),
              _buildSettingsTile(
                context,
                icon: Icons.language,
                title: AppConstants.language,
                subtitle: AppConstants.portugueseBrazil,
                onTap: () => _showLanguageDialog(context),
              ),
              _buildDivider(),
              _buildSettingsTile(
                context,
                icon: Icons.attach_money,
                title: AppConstants.currency,
                subtitle: AppConstants.brazilianReal,
                onTap: () => _showCurrencyDialog(context),
              ),
              _buildDivider(),
              _buildSettingsTile(
                context,
                icon: Icons.notifications,
                title: AppConstants.notifications,
                subtitle: settingsService.notificationsEnabled
                    ? AppConstants.notificationsEnabled
                    : AppConstants.notificationsDisabled,
                trailing: Switch(
                  value: settingsService.notificationsEnabled,
                  onChanged: (value) =>
                      _toggleNotifications(context, value, settingsService),
                ),
              ),
              _buildDivider(),
              _buildSettingsTile(
                context,
                icon: Icons.fingerprint,
                title: 'Autenticação Biométrica',
                subtitle: settingsService.biometricEnabled
                    ? 'Protegido por biometria'
                    : 'Use impressão digital para acessar',
                trailing: Switch(
                  value: settingsService.biometricEnabled,
                  onChanged: (value) =>
                      _toggleBiometric(context, value, settingsService),
                ),
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
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, indent: 56);
  }

  void _showLanguageDialog(BuildContext context) async {
    final selectedIndex = await DialogUtils.showSingleChoiceDialog(
      context,
      title: AppConstants.chooseLanguage,
      options: const [
        AppConstants.portugueseBrazil,
        AppConstants.english,
        AppConstants.spanish,
      ],
    );

    if (selectedIndex != null) {
      // TODO: Implementar mudança de idioma
      SnackBarUtils.showSuccess(context, 'Idioma alterado com sucesso!');
    }
  }

  void _showCurrencyDialog(BuildContext context) async {
    final selectedIndex = await DialogUtils.showSingleChoiceDialog(
      context,
      title: AppConstants.chooseCurrency,
      options: const [
        AppConstants.brazilianReal,
        AppConstants.usd,
        AppConstants.euro,
      ],
    );

    if (selectedIndex != null) {
      // TODO: Implementar mudança de moeda
      SnackBarUtils.showSuccess(context, 'Moeda alterada com sucesso!');
    }
  }

  void _toggleNotifications(
    BuildContext context,
    bool value,
    SettingsService settingsService,
  ) async {
    await settingsService.toggleNotifications(value);
    SnackBarUtils.showInfo(
      context,
      value
          ? AppConstants.notificationsEnabled
          : AppConstants.notificationsDisabled,
    );
  }

  void _toggleBiometric(
    BuildContext context,
    bool value,
    SettingsService settingsService,
  ) async {
    await settingsService.toggleBiometric(value);
    SnackBarUtils.showInfo(
      context,
      value
          ? 'Autenticação biométrica ativada'
          : 'Autenticação biométrica desativada',
    );
  }
}
