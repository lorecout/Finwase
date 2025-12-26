import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gastos_manager/services/firebase_service.dart';
import 'package:gastos_manager/services/settings_service.dart';
import 'package:gastos_manager/utils/dialog_utils.dart';
import 'package:gastos_manager/utils/snackbar_utils.dart';
import 'package:gastos_manager/constants.dart';

/// Widget para a seção de conta nas configurações
class AccountSettingsSection extends StatelessWidget {
  const AccountSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<FirebaseService, SettingsService>(
      builder: (context, firebaseService, settingsService, child) {
        final isSignedInWithGoogle = firebaseService.isSignedInWithGoogle;

        return Card(
          child: Column(
            children: [
              _buildSettingsTile(
                context,
                icon: Icons.person,
                title: AppConstants.profile,
                subtitle: AppConstants.editPersonalInfo,
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
              _buildDivider(),
              // Só mostrar botão de email se NÃO estiver logado com Google
              if (!isSignedInWithGoogle) ...[
                _buildSettingsTile(
                  context,
                  icon: Icons.email,
                  title: AppConstants.changeEmailSetting,
                  subtitle: 'Alterar endereço de email',
                  onTap: () => _showEmailDialog(context),
                ),
                _buildDivider(),
              ],
              // Só mostrar botão de senha se NÃO estiver logado com Google
              if (!isSignedInWithGoogle) ...[
                _buildSettingsTile(
                  context,
                  icon: Icons.lock,
                  title: AppConstants.changePasswordSetting,
                  subtitle: AppConstants.changePasswordDescription,
                  onTap: () => _showChangePasswordDialog(context),
                ),
                _buildDivider(),
              ],
              _buildGoogleAccountTile(context, firebaseService),
              _buildDivider(),
              _buildSettingsTile(
                context,
                icon: Icons.security,
                title: AppConstants.biometricAuth,
                subtitle: AppConstants.biometricDescription,
                trailing: Switch(
                  value: settingsService.biometricEnabled,
                  onChanged: (value) =>
                      _toggleBiometricAuth(context, value, settingsService),
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

  Widget _buildGoogleAccountTile(
    BuildContext context,
    FirebaseService firebaseService,
  ) {
    final isSignedInWithGoogle = firebaseService.isSignedInWithGoogle;
    final user = firebaseService.currentUser;

    return _buildSettingsTile(
      context,
      icon: Icons.account_circle,
      title: 'Conta Google',
      subtitle: isSignedInWithGoogle
          ? 'Logado com ${user?.email ?? 'conta Google'}'
          : 'Não logado com Google',
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSignedInWithGoogle
              ? Colors.green.withValues(alpha: 0.1)
              : Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSignedInWithGoogle ? Icons.check_circle : Icons.cancel,
              color: isSignedInWithGoogle ? Colors.green : Colors.grey,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              isSignedInWithGoogle ? 'Conectado' : 'Desconectado',
              style: TextStyle(
                color: isSignedInWithGoogle ? Colors.green : Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEmailDialog(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final newEmail = await DialogUtils.showTextInputDialog(
      context,
      title: AppConstants.changeEmail,
      labelText: AppConstants.newEmail,
    );

    if (newEmail != null && newEmail.isNotEmpty) {
      // TODO: Implementar lógica de mudança de email
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text(AppConstants.emailUpdated),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _showChangePasswordDialog(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => const _ChangePasswordDialog(),
    );

    if (result != null) {
      // TODO: Implementar lógica de mudança de senha
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text(AppConstants.passwordChanged),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _toggleBiometricAuth(
    BuildContext context,
    bool value,
    SettingsService settingsService,
  ) {
    settingsService.toggleBiometric(value);
    SnackBarUtils.showInfo(
      context,
      value ? AppConstants.biometricEnabled : AppConstants.biometricDisabled,
    );
  }
}

/// Diálogo para mudança de senha
class _ChangePasswordDialog extends StatefulWidget {
  const _ChangePasswordDialog();

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppConstants.changePassword),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _currentPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: AppConstants.currentPassword,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _newPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: AppConstants.newPassword,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: AppConstants.confirmPassword,
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(AppConstants.cancel),
        ),
        ElevatedButton(
          onPressed: _validateAndSubmit,
          child: const Text(AppConstants.changePasswordSetting),
        ),
      ],
    );
  }

  void _validateAndSubmit() {
    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      SnackBarUtils.showError(context, 'Preencha todos os campos');
      return;
    }

    if (newPassword != confirmPassword) {
      SnackBarUtils.showError(context, 'As senhas não coincidem');
      return;
    }

    if (newPassword.length < 6) {
      SnackBarUtils.showError(
        context,
        'A senha deve ter pelo menos 6 caracteres',
      );
      return;
    }

    Navigator.pop(context, {'current': currentPassword, 'new': newPassword});
  }
}
