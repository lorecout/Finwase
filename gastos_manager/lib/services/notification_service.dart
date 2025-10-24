import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/transaction.dart';
import '../models/orcamento.dart';
import 'app_state.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Configurações de inicialização
  Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(settings);
  }

  // Notificações de orçamento
  Future<void> checkBudgetAlerts(AppState appState) async {
    final budgets = appState.orcamentos;
    final transactions = appState.transacoes;

    for (final budget in budgets) {
      if (!budget.ativo || !budget.notificarExcesso) continue;

      final spent = _calculateSpentInBudget(budget, transactions);
      final utilization = spent / budget.valorLimite;

      // Alerta de 80% do orçamento
      if (budget.porcentagemAlerta != null &&
          utilization >= budget.porcentagemAlerta!) {
        await _showBudgetAlertNotification(
          budget,
          spent,
          utilization,
          'warning',
        );
      }

      // Alerta de orçamento excedido
      if (utilization >= 1.0) {
        await _showBudgetAlertNotification(
          budget,
          spent,
          utilization,
          'exceeded',
        );
      }

      // Alerta de orçamento próximo do fim (últimos 3 dias)
      final daysLeft = budget.dataFim.difference(DateTime.now()).inDays;
      if (daysLeft <= 3 && daysLeft > 0 && utilization < 1.0) {
        await _showBudgetDeadlineNotification(budget, spent, daysLeft);
      }
    }
  }

  // Notificações de metas financeiras
  Future<void> checkGoalReminders(AppState appState) async {
    // Implementar lembretes de metas quando o serviço de metas for criado
    // Por enquanto, apenas lembretes semanais de economia
    await _showWeeklySavingsReminder();
  }

  // Notificações de padrões de gastos
  Future<void> checkSpendingPatterns(AppState appState) async {
    final transactions = appState.transacoes;
    final anomalies = _detectSpendingAnomalies(transactions);

    for (final anomaly in anomalies) {
      await _showSpendingAnomalyNotification(anomaly);
    }
  }

  // Lembretes de transações recorrentes
  Future<void> scheduleRecurringTransactionReminders(AppState appState) async {
    final recurringTransactions = appState.transacoes
        .where((t) => t.isRecurring)
        .toList();

    for (final transaction in recurringTransactions) {
      await _scheduleRecurringReminder(transaction);
    }
  }

  // Notificação semanal de resumo financeiro
  Future<void> scheduleWeeklySummary() async {
    await _notificationsPlugin.zonedSchedule(
      999,
      'Resumo Financeiro Semanal',
      'Veja como estão seus gastos e orçamentos esta semana',
      _nextInstanceOfWeekday(7, 9, 0), // Próximo domingo às 9:00
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'weekly_summary',
          'Resumo Semanal',
          channelDescription: 'Resumos semanais dos gastos',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  // Métodos auxiliares
  double _calculateSpentInBudget(
    Orcamento budget,
    List<Transacao> transactions,
  ) {
    return transactions
        .where(
          (t) =>
              t.type == TransactionType.expense &&
              t.date.isAfter(budget.dataInicio) &&
              t.date.isBefore(budget.dataFim.add(const Duration(days: 1))) &&
              (budget.categoriaId == null ||
                  t.categoryId == budget.categoriaId),
        )
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  Future<void> _showBudgetAlertNotification(
    Orcamento budget,
    double spent,
    double utilization,
    String type,
  ) async {
    final percent = (utilization * 100).toStringAsFixed(1);
    final budgetName = budget.categoriaId != null
        ? 'Orçamento: ${budget.nome}'
        : 'Orçamento Geral';

    String title;
    String body;

    if (type == 'warning') {
      title = '⚠️ Orçamento quase esgotado';
      body =
          '$budgetName: $percent% utilizado (R\$ ${spent.toStringAsFixed(2)} de R\$ ${budget.valorLimite.toStringAsFixed(2)})';
    } else {
      title = '🚨 Orçamento excedido!';
      body =
          '$budgetName: $percent% utilizado (R\$ ${spent.toStringAsFixed(2)} > R\$ ${budget.valorLimite.toStringAsFixed(2)})';
    }

    await _notificationsPlugin.show(
      budget.id.hashCode,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'budget_alerts',
          'Alertas de Orçamento',
          channelDescription: 'Notificações sobre limites de orçamento',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> _showBudgetDeadlineNotification(
    Orcamento budget,
    double spent,
    int daysLeft,
  ) async {
    final budgetName = budget.categoriaId != null
        ? 'Orçamento: ${budget.nome}'
        : 'Orçamento Geral';

    await _notificationsPlugin.show(
      budget.id.hashCode + 1000,
      '⏰ Orçamento terminando',
      '$budgetName termina em $daysLeft dia(s). Gasto atual: R\$ ${spent.toStringAsFixed(2)}',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'budget_deadlines',
          'Prazos de Orçamento',
          channelDescription: 'Lembretes sobre prazos de orçamento',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> _showWeeklySavingsReminder() async {
    await _notificationsPlugin.show(
      2000,
      '💰 Dica de Economia',
      'Que tal revisar seus gastos desta semana? Pequenas economias fazem diferença!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'savings_tips',
          'Dicas de Economia',
          channelDescription: 'Dicas e lembretes para economizar',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  List<Map<String, dynamic>> _detectSpendingAnomalies(
    List<Transacao> transactions,
  ) {
    final anomalies = <Map<String, dynamic>>[];

    // Agrupar por categoria e calcular médias
    final categorySpending = <String, List<double>>{};
    for (final transaction in transactions.where(
      (t) => t.type == TransactionType.expense,
    )) {
      categorySpending.putIfAbsent(transaction.categoryId, () => []);
      categorySpending[transaction.categoryId]!.add(transaction.amount);
    }

    // Detectar anomalias (gastos muito acima da média)
    for (final entry in categorySpending.entries) {
      if (entry.value.length >= 3) {
        final avg = entry.value.reduce((a, b) => a + b) / entry.value.length;
        final max = entry.value.reduce((a, b) => a > b ? a : b);

        if (max > avg * 2) {
          // Gasto mais que o dobro da média
          anomalies.add({
            'categoryId': entry.key,
            'average': avg,
            'anomaly': max,
            'ratio': max / avg,
          });
        }
      }
    }

    return anomalies;
  }

  Future<void> _showSpendingAnomalyNotification(
    Map<String, dynamic> anomaly,
  ) async {
    await _notificationsPlugin.show(
      anomaly['categoryId'].hashCode + 3000,
      '📈 Gasto Incomum Detectado',
      'Você gastou R\$ ${anomaly['anomaly'].toStringAsFixed(2)}, ${anomaly['ratio'].toStringAsFixed(1)}x acima da média',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'spending_anomalies',
          'Anomalias de Gastos',
          channelDescription: 'Alertas sobre padrões incomuns de gastos',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> _scheduleRecurringReminder(Transacao transaction) async {
    // Calcular próxima data baseada na frequência
    DateTime nextDate;
    if (transaction.recurringType == RecurringType.monthly) {
      nextDate = DateTime(
        transaction.data.year,
        transaction.data.month + 1,
        transaction.data.day,
      );
    } else if (transaction.recurringType == RecurringType.weekly) {
      nextDate = transaction.data.add(const Duration(days: 7));
    } else {
      return; // Não agendar para outros tipos
    }

    if (nextDate.isBefore(DateTime.now())) return;

    await _notificationsPlugin.zonedSchedule(
      transaction.id.hashCode + 4000,
      '💳 Transação Recorrente',
      '${transaction.title}: R\$ ${transaction.amount.toStringAsFixed(2)} vence em breve',
      tz.TZDateTime.from(nextDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'recurring_transactions',
          'Transações Recorrentes',
          channelDescription: 'Lembretes de transações recorrentes',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  tz.TZDateTime _nextInstanceOfWeekday(int weekday, int hour, int minute) {
    tz.TZDateTime scheduledDate = _nextInstance(
      DateTime.now(),
      weekday,
      hour,
      minute,
    );
    return scheduledDate;
  }

  tz.TZDateTime _nextInstance(DateTime now, int weekday, int hour, int minute) {
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    while (scheduledDate.weekday != weekday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }

    return scheduledDate;
  }

  // Cancelar todas as notificações
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  // Cancelar notificações específicas
  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }
}
