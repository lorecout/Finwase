import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/premium_service.dart';
import '../services/app_state.dart';

class AdminSettingsSection extends StatelessWidget {
  const AdminSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PremiumService>(
      builder: (context, premiumService, child) {
        // Só mostrar se for administrador
        if (!premiumService.isAdmin) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              // Cabeçalho da seção admin
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.2),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.admin_panel_settings,
                      color: Colors.red[700],
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Configurações de Administrador',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[700],
                      ),
                    ),
                  ],
                ),
              ),

              // Controles admin
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Status atual
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Status Atual',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  premiumService.isPremium
                                      ? 'Premium (Admin Override Ativo)'
                                      : 'Gratuito',
                                  style: TextStyle(
                                    color: premiumService.isPremium
                                        ? Colors.green
                                        : Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: premiumService.isPremium
                                  ? Colors.green.withValues(alpha: 0.1)
                                  : Colors.grey.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              premiumService.isPremium ? 'PREMIUM' : 'FREE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: premiumService.isPremium
                                    ? Colors.green
                                    : Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Toggle Premium/Free
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SwitchListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        title: const Text(
                          'Modo Premium (Override)',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          premiumService.isAdminModeActive
                              ? 'Todas as funcionalidades premium ativas'
                              : 'Testando como usuário gratuito',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        value: premiumService.isAdminModeActive,
                        onChanged: (value) {
                          premiumService.setAdminPremiumStatus(value);

                          // Mostrar feedback
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                value
                                    ? 'Modo Premium Admin ativado'
                                    : 'Modo Premium Admin desativado',
                              ),
                              backgroundColor: value
                                  ? Colors.green
                                  : Colors.orange,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        secondary: Icon(
                          premiumService.isAdminModeActive
                              ? Icons.admin_panel_settings
                              : Icons.person,
                          color: premiumService.isAdminModeActive
                              ? Colors.green
                              : Colors.grey[600],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Botão para debug
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: const Icon(
                          Icons.bug_report,
                          color: Colors.purple,
                        ),
                        title: const Text(
                          'Debug - Investigar Dados',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: const Text(
                          'Analisar dados do usuário e logs do sistema',
                          style: TextStyle(fontSize: 12),
                        ),
                        onTap: () => Navigator.pushNamed(context, '/debug'),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Botão para limpar dados
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: const Icon(
                          Icons.delete_sweep,
                          color: Colors.orange,
                        ),
                        title: const Text(
                          'Limpar Todos os Dados',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: const Text(
                          'Remove todas as transações, categorias e orçamentos salvos',
                          style: TextStyle(fontSize: 12),
                        ),
                        onTap: () => _showClearDataDialog(context),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Aviso
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.amber.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_amber,
                            color: Colors.amber[700],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Use este controle para testar as funcionalidades premium e gratuitas.',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.amber[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text('Limpar Todos os Dados'),
          ],
        ),
        content: const Text(
          'Esta ação irá remover PERMANENTEMENTE:\n\n'
          '• Todas as transações\n'
          '• Todas as categorias\n'
          '• Todos os orçamentos\n'
          '• Histórico completo\n\n'
          'Esta ação NÃO PODE ser desfeita!\n\n'
          'Deseja continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
              await _clearAllUserData(context);
            },
            child: const Text('LIMPAR TUDO'),
          ),
        ],
      ),
    );
  }

  Future<void> _clearAllUserData(BuildContext context) async {
    try {
      // Mostrar indicador de loading
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Limpando dados...'),
            duration: Duration(seconds: 2),
          ),
        );
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final firestore = FirebaseFirestore.instance;
      final userDoc = firestore.collection('users').doc(user.uid);

      // Limpar transações
      final transactionsQuery = await userDoc.collection('transactions').get();
      for (final doc in transactionsQuery.docs) {
        await doc.reference.delete();
      }

      // Limpar categorias (exceto as padrão)
      final categoriesQuery = await userDoc.collection('categories').get();
      for (final doc in categoriesQuery.docs) {
        final data = doc.data();
        if (data['isDefault'] != true) {
          await doc.reference.delete();
        }
      }

      // Limpar orçamentos
      final budgetsQuery = await userDoc.collection('budgets').get();
      for (final doc in budgetsQuery.docs) {
        await doc.reference.delete();
      }

      // Limpar dados locais
      if (context.mounted) {
        final appState = Provider.of<AppState>(context, listen: false);
        appState.limparDados();
      }

      // Mostrar confirmação
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Todos os dados foram removidos com sucesso!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Erro ao limpar dados: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
