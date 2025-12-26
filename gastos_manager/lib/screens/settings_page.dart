import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/theme_service.dart';
import '../services/app_state.dart';
import '../constants.dart';
import '../widgets/account_settings_section.dart';
import '../widgets/personalization_settings_section.dart';
import '../widgets/data_settings_section.dart';
import '../widgets/support_settings_section.dart';
import '../widgets/premium_settings_section.dart';
import '../widgets/admin_settings_section.dart';
import '../main.dart'; // importar appNavigatorKey

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        final listViewContent = ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Seção Admin (só aparece para administradores)
            const AdminSettingsSection(),

            const SizedBox(height: 24),

            // Seção Conta
            _buildSectionHeader(AppConstants.account, Icons.account_circle),
            const SizedBox(height: 8),
            const AccountSettingsSection(),

            const SizedBox(height: 24),

            // Seção Personalização
            _buildSectionHeader(AppConstants.personalization, Icons.palette),
            const SizedBox(height: 8),
            const PersonalizationSettingsSection(),

            const SizedBox(height: 24),

            // Seção Dados
            _buildSectionHeader(AppConstants.data, Icons.storage),
            const SizedBox(height: 8),
            const DataSettingsSection(),

            const SizedBox(height: 24),

            // Seção Suporte
            _buildSectionHeader(AppConstants.support, Icons.help),
            const SizedBox(height: 8),
            const SupportSettingsSection(),

            const SizedBox(height: 24),

            // Seção Premium
            _buildSectionHeader(AppConstants.premium, Icons.workspace_premium),
            const SizedBox(height: 8),
            const PremiumSettingsSection(),

            const SizedBox(height: 32),

            // Botão de Logout
            _buildLogoutButton(context),
          ],
        );

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.8),
                    Theme.of(
                      context,
                    ).colorScheme.secondary.withValues(alpha: 0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            title: Text(
              'Configurações',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ),
          body: listViewContent,
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.red.withValues(alpha: 0.1),
            Colors.red.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3), width: 1),
      ),
      child: InkWell(
        onTap: () => _showLogoutDialog(context),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.logout, color: Colors.red),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      AppConstants.logoutSetting,
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppConstants.logoutDescription,
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sair da Conta'),
        content: const Text(
          'Tem certeza que deseja sair da sua conta? Você precisará fazer login novamente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(dialogContext);
              // Capture provider, navigator e scaffoldMessenger antes de calls assíncronos
              final appState = Provider.of<AppState>(context, listen: false);
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              try {
                // Fazer logout completo do Firebase
                await FirebaseAuth.instance.signOut();

                // Se precisar adicionar logout do Google no futuro, faça aqui com
                // uma chamada opcional e tratada por try/catch; por enquanto evitamos
                // referenciar diretamente GoogleSignIn para manter compatibilidade.

                // Limpar estado do app
                appState.setGuestMode(false);

                // Navegar para tela de auth usando navegação global (key)
                if (!mounted) return;
                appNavigatorKey.currentState?.pushNamedAndRemoveUntil(
                  '/auth',
                  (route) => false,
                );
              } catch (e) {
                if (!mounted) return;
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text('Erro ao fazer logout: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('SAIR'),
          ),
        ],
      ),
    );
  }
}
