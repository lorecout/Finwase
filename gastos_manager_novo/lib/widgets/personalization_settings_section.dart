import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gastos_manager/utils/dialog_utils.dart';
import 'package:gastos_manager/constants.dart';
import 'package:gastos_manager/services/settings_service.dart';
import 'package:gastos_manager/services/biometric_service.dart';

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
    final scaffoldMessenger = ScaffoldMessenger.of(context);
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
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Idioma alterado com sucesso!')),
      );
    }
  }

  void _showCurrencyDialog(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
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
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Moeda alterada com sucesso!')),
      );
    }
  }

  void _toggleNotifications(
    BuildContext context,
    bool value,
    SettingsService settingsService,
  ) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    await settingsService.toggleNotifications(value);
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          value
              ? AppConstants.notificationsEnabled
              : AppConstants.notificationsDisabled,
        ),
      ),
    );
  }

  void _toggleBiometric(
    BuildContext context,
    bool value,
    SettingsService settingsService,
  ) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    // Se está tentando ativar, verificar suporte primeiro
    if (value) {
      final isSupported = await BiometricService.isDeviceSupported();
      if (!isSupported) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text(
              'Seu dispositivo não suporta autenticação biométrica',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final canCheck = await BiometricService.canCheckBiometrics();
      if (!canCheck) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text(
              'Configure uma biometria no seu dispositivo primeiro',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Verificar biometria antes de ativar
      final authenticated = await BiometricService.authenticate(
        localizedReason: 'Confirme sua biometria para ativar esta proteção',
      );
      if (!authenticated) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Autenticação biométrica falhou'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    await settingsService.toggleBiometric(value);
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          value
              ? 'Autenticação biométrica ativada'
              : 'Autenticação biométrica desativada',
        ),
      ),
    );
  }
}
