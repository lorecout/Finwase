import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../services/app_state.dart';
import '../services/theme_service.dart';
import '../widgets/smart_ad_banner_widget.dart';

class RecurringTransactionsPage extends StatefulWidget {
  const RecurringTransactionsPage({super.key});

  @override
  State<RecurringTransactionsPage> createState() =>
      _RecurringTransactionsPageState();
}

class _RecurringTransactionsPageState extends State<RecurringTransactionsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<AppState, ThemeService>(
      builder: (context, appState, themeService, child) {
        final recurringTransactions = appState.transacoes
            .where((t) => t.isRecurring)
            .toList();

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
              'Transações Recorrentes',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: recurringTransactions.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: recurringTransactions.length,
                        itemBuilder: (context, index) {
                          final transaction = recurringTransactions[index];
                          return _buildRecurringTransactionCard(
                            transaction,
                            appState,
                          );
                        },
                      ),
              ),
              const SmartAdBannerWidget(debugLabel: 'recurring'),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/add-transaction');
            },
            backgroundColor: themeService.accentColor,
            heroTag: "recurring_add_fab",
            child: const Icon(Icons.repeat, color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.repeat_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 24),
          Text(
            'Nenhuma transação recorrente',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Adicione transações que se repetem automaticamente',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/add-transaction');
            },
            icon: const Icon(Icons.add),
            label: const Text('Adicionar Transação'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecurringTransactionCard(
    TransactionModel transaction,
    AppState appState,
  ) {
    final categoria = appState.categorias
        .where((c) => c.id == transaction.categoryId)
        .firstOrNull;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: transaction.type == TransactionType.income
              ? Colors.green.withValues(alpha: 0.1)
              : Colors.red.withValues(alpha: 0.1),
          child: Icon(
            transaction.type == TransactionType.income
                ? Icons.arrow_upward
                : Icons.arrow_downward,
            color: transaction.type == TransactionType.income
                ? Colors.green
                : Colors.red,
          ),
        ),
        title: Text(
          transaction.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(categoria?.name ?? 'Sem categoria'),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.repeat, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  _getRecurrenceDescription(transaction.recurringType),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'R\$ ${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: transaction.type == TransactionType.income
                    ? Colors.green
                    : Colors.red,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _getNextOccurrence(transaction),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        onTap: () {
          _showTransactionOptions(context, transaction, appState);
        },
      ),
    );
  }

  String _getRecurrenceDescription(RecurringType? type) {
    switch (type) {
      case RecurringType.daily:
        return 'Diário';
      case RecurringType.weekly:
        return 'Semanal';
      case RecurringType.monthly:
        return 'Mensal';
      case RecurringType.yearly:
        return 'Anual';
      default:
        return 'Indefinido';
    }
  }

  String _getNextOccurrence(TransactionModel transaction) {
    final now = DateTime.now();
    DateTime nextDate = transaction.date;

    switch (transaction.recurringType) {
      case RecurringType.daily:
        while (nextDate.isBefore(now)) {
          nextDate = nextDate.add(const Duration(days: 1));
        }
        break;
      case RecurringType.weekly:
        while (nextDate.isBefore(now)) {
          nextDate = nextDate.add(const Duration(days: 7));
        }
        break;
      case RecurringType.monthly:
        while (nextDate.isBefore(now)) {
          nextDate = DateTime(nextDate.year, nextDate.month + 1, nextDate.day);
        }
        break;
      case RecurringType.yearly:
        while (nextDate.isBefore(now)) {
          nextDate = DateTime(nextDate.year + 1, nextDate.month, nextDate.day);
        }
        break;
      default:
        return 'Próx: --/--';
    }

    return 'Próx: ${nextDate.day.toString().padLeft(2, '0')}/${nextDate.month.toString().padLeft(2, '0')}';
  }

  void _showTransactionOptions(
    BuildContext context,
    TransactionModel transaction,
    AppState appState,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Editar'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context,
                    '/add-transaction',
                    arguments: transaction,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.content_copy),
                title: const Text('Duplicar'),
                onTap: () {
                  Navigator.pop(context);
                  final duplicated = transaction.copyWith(
                    id: null, // Força criação de novo ID
                    isRecurring: false, // Duplica como transação única
                  );
                  Navigator.pushNamed(
                    context,
                    '/add-transaction',
                    arguments: duplicated,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.pause_circle_outline),
                title: const Text('Pausar Recorrência'),
                onTap: () {
                  Navigator.pop(context);
                  final updated = transaction.copyWith(isRecurring: false);
                  appState.atualizarTransacao(updated);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Recorrência pausada')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Excluir',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(context, transaction, appState);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    TransactionModel transaction,
    AppState appState,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir Transação Recorrente'),
          content: Text(
            'Tem certeza que deseja excluir "${transaction.title}"?\n\nEsta ação não pode ser desfeita.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                appState.removerTransacao(transaction.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Transação excluída')),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }
}
