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
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.08),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.verified_user,
                      color: Colors.blue[700],
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Status do Plano',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          premiumService.isPro
                              ? Icons.workspace_premium
                              : Icons.verified_user,
                          color:
                              premiumService.isPro ? Colors.amber : Colors.blue,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          premiumService.isPro
                              ? 'Pro (sem anúncios)'
                              : 'Free (com anúncios)',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: premiumService.isPro
                                ? Colors.amber[800]
                                : Colors.blue[800],
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: premiumService.isPro
                                ? Colors.amber.withOpacity(0.1)
                                : Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            premiumService.isPro ? 'PRO' : 'FREE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: premiumService.isPro
                                  ? Colors.amber[800]
                                  : Colors.blue[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          premiumService.showAds ? Icons.ad_units : Icons.block,
                          color: premiumService.showAds
                              ? Colors.orange
                              : Colors.green,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          premiumService.showAds
                              ? 'Anúncios Ativados'
                              : 'Sem Anúncios',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: premiumService.showAds
                                ? Colors.orange[800]
                                : Colors.green[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Botão de debug
                    ListTile(
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
                    const SizedBox(height: 12),
                    // Botão para limpar dados
                    ListTile(
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
                    const SizedBox(height: 12),
                    // Aviso
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.amber.withOpacity(0.3),
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
                    const SizedBox(height: 16),
                    if (!premiumService.isPro)
                      ElevatedButton.icon(
                        icon: const Icon(Icons.workspace_premium,
                            color: Colors.amber),
                        label: Text(
                            'Ativar Pro por R\$ ${PremiumService.proMonthlyPrice.toStringAsFixed(2)} / mês'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 24),
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: () async {
                          await premiumService.comprarPro();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Plano Pro ativado!')),
                          );
                        },
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
    // Capturar referências antes de operações assíncronas
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final appState = Provider.of<AppState>(context, listen: false);

    try {
      // Mostrar indicador de loading
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Limpando dados...'),
          duration: Duration(seconds: 2),
        ),
      );

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
      appState.limparDados();

      // Mostrar confirmação
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('✅ Todos os dados foram removidos com sucesso!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('❌ Erro ao limpar dados: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
