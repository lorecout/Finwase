import '../models/transaction.dart';

class AIService {
  // Análise de padrões de gastos
  Map<String, dynamic> analyzeSpendingPatterns(
    List<TransactionModel> transactions,
  ) {
    if (transactions.isEmpty) {
      return {
        'patterns': [],
        'insights': [
          'Adicione mais transações para receber insights personalizados',
        ],
        'recommendations': [
          'Continue registrando suas transações regularmente',
        ],
      };
    }

    final insights = <String>[];
    final recommendations = <String>[];
    final patterns = <Map<String, dynamic>>[];

    // Análise de gastos por dia da semana
    final weekdaySpending = _analyzeWeekdaySpending(transactions);
    patterns.add({
      'type': 'weekday_spending',
      'title': 'Gastos por Dia da Semana',
      'data': weekdaySpending,
    });

    // Identificar dia com maior gasto
    final maxWeekday = weekdaySpending.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );
    if (maxWeekday.value > 0) {
      insights.add(
        'Você gasta mais aos ${maxWeekday.key} (R\$ ${maxWeekday.value.toStringAsFixed(2)} em média)',
      );
      recommendations.add(
        'Considere reduzir gastos recreativos aos ${maxWeekday.key}',
      );
    }

    // Análise de gastos por horário
    final hourlySpending = _analyzeHourlySpending(transactions);
    patterns.add({
      'type': 'hourly_spending',
      'title': 'Gastos por Horário',
      'data': hourlySpending,
    });

    // Identificar horário de pico
    final maxHour = hourlySpending.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );
    if (maxHour.value > 0) {
      insights.add(
        'Seu horário de pico de gastos é às ${maxHour.key}:00 (R\$ ${maxHour.value.toStringAsFixed(2)} em média)',
      );
    }

    // Análise de recorrência
    final recurringAnalysis = _analyzeRecurringTransactions(transactions);
    patterns.add({
      'type': 'recurring_transactions',
      'title': 'Transações Recorrentes',
      'data': recurringAnalysis,
    });

    if (recurringAnalysis['percentage'] > 50) {
      insights.add(
        '${recurringAnalysis['percentage'].toStringAsFixed(1)}% dos seus gastos são recorrentes',
      );
      recommendations.add(
        'Revise suas assinaturas mensais para identificar economias',
      );
    }

    // Análise de categorias sazonais
    final seasonalAnalysis = _analyzeSeasonalSpending(transactions);
    patterns.add({
      'type': 'seasonal_spending',
      'title': 'Gastos Sazonais',
      'data': seasonalAnalysis,
    });

    // Detectar anomalias
    final anomalies = _detectAnomalies(transactions);
    if (anomalies.isNotEmpty) {
      patterns.add({
        'type': 'anomalies',
        'title': 'Gastos Atípicos',
        'data': anomalies,
      });

      insights.add('Detectamos ${anomalies.length} gastos atípicos este mês');
      recommendations.add(
        'Revise os gastos atípicos para identificar compras impulsivas',
      );
    }

    // Sugestões de economia
    final savingsSuggestions = _generateSavingsSuggestions(transactions);
    recommendations.addAll(savingsSuggestions);

    return {
      'patterns': patterns,
      'insights': insights,
      'recommendations': recommendations,
    };
  }

  // Análise de gastos por dia da semana
  Map<String, double> _analyzeWeekdaySpending(
    List<TransactionModel> transactions,
  ) {
    final weekdayTotals = <String, List<double>>{};
    final weekdays = [
      'Segunda',
      'Terça',
      'Quarta',
      'Quinta',
      'Sexta',
      'Sábado',
      'Domingo',
    ];

    for (final transaction in transactions.where((t) => t.type == TransactionType.expense)) {
      final weekday = weekdays[transaction.data.weekday - 1];
      weekdayTotals[weekday] ??= [];
      weekdayTotals[weekday]!.add(transaction.valor);
    }

    return weekdayTotals.map(
      (key, values) => MapEntry(
        key,
        values.isEmpty ? 0 : values.reduce((a, b) => a + b) / values.length,
      ),
    );
  }

  // Análise de gastos por horário
  Map<String, double> _analyzeHourlySpending(
    List<TransactionModel> transactions,
  ) {
    final hourlyTotals = <String, List<double>>{};

    for (final transaction in transactions.where((t) => t.type == TransactionType.expense)) {
      final hour = transaction.data.hour.toString().padLeft(2, '0');
      hourlyTotals[hour] ??= [];
      hourlyTotals[hour]!.add(transaction.valor);
    }

    return hourlyTotals.map(
      (key, values) => MapEntry(
        key,
        values.isEmpty ? 0 : values.reduce((a, b) => a + b) / values.length,
      ),
    );
  }

  // Análise de transações recorrentes
  Map<String, dynamic> _analyzeRecurringTransactions(
    List<TransactionModel> transactions,
  ) {
    final expenseTransactions = transactions
        .where((t) => t.type == TransactionType.expense)
        .toList();
    if (expenseTransactions.isEmpty) {
      return {'count': 0, 'percentage': 0.0, 'total': 0.0};
    }

    // Simples detecção de recorrência baseada em títulos similares
    final titleGroups = <String, List<TransactionModel>>{};
    for (final transaction in expenseTransactions) {
      final normalizedTitle = transaction.title.toLowerCase().trim();
      titleGroups[normalizedTitle] ??= [];
      titleGroups[normalizedTitle]!.add(transaction);
    }

    final recurringTitles = titleGroups.entries
        .where((entry) => entry.value.length > 1)
        .toList();
    final recurringTotal = recurringTitles.fold(
      0.0,
      (sum, entry) => sum + entry.value.fold(0.0, (s, t) => s + t.valor),
    );

    final totalExpenses = expenseTransactions.fold(
      0.0,
      (sum, t) => sum + t.valor,
    );
    final percentage = totalExpenses > 0
        ? (recurringTotal / totalExpenses) * 100
        : 0.0;

    return {
      'count': recurringTitles.length,
      'percentage': percentage,
      'total': recurringTotal,
    };
  }

  // Análise de gastos sazonais
  Map<String, dynamic> _analyzeSeasonalSpending(
    List<TransactionModel> transactions,
  ) {
    final monthlySpending = <int, double>{};

    for (final transaction in transactions.where((t) => t.type == TransactionType.expense)) {
      final month = transaction.data.month;
      monthlySpending[month] =
          (monthlySpending[month] ?? 0) + transaction.valor;
    }

    final months = [
      'Jan',
      'Fev',
      'Mar',
      'Abr',
      'Mai',
      'Jun',
      'Jul',
      'Ago',
      'Set',
      'Out',
      'Nov',
      'Dez',
    ];

    return {
      'data': List.generate(
        12,
        (index) => {
          'month': months[index],
          'amount': monthlySpending[index + 1] ?? 0.0,
        },
      ),
    };
  }

  // Detecção de anomalias (gastos muito acima da média)
  List<Map<String, dynamic>> _detectAnomalies(
    List<TransactionModel> transactions,
  ) {
    final expenses = transactions.where((t) => t.type == TransactionType.expense).toList();
    if (expenses.length < 5) return [];

    final amounts = expenses.map((t) => t.valor).toList();
    amounts.sort();
    final q1 = amounts[(amounts.length * 0.25).floor()];
    final q3 = amounts[(amounts.length * 0.75).floor()];
    final iqr = q3 - q1;
    final upperFence = q3 + (1.5 * iqr);

    return expenses
        .where((t) => t.valor > upperFence)
        .map(
          (t) => {
            'title': t.title,
            'amount': t.valor,
            'date': t.data,
            'category': t.categoriaId,
          },
        )
        .toList();
  }

  // Geração de sugestões de economia
  List<String> _generateSavingsSuggestions(
    List<TransactionModel> transactions,
  ) {
    final suggestions = <String>[];

    // Análise de gastos vs receitas
    final totalIncome = transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.valor);

    final totalExpenses = transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.valor);

    final savingsRate = totalIncome > 0
        ? ((totalIncome - totalExpenses) / totalIncome) * 100
        : 0;

    if (savingsRate < 20) {
      suggestions.add(
        'Sua taxa de poupança está em ${savingsRate.toStringAsFixed(1)}%. Tente alcançar pelo menos 20%',
      );
    }

    // Sugestão baseada em gastos recorrentes
    final recurringAnalysis = _analyzeRecurringTransactions(transactions);
    if (recurringAnalysis['percentage'] > 60) {
      suggestions.add(
        'Seus gastos recorrentes são altos. Considere cancelar serviços não essenciais',
      );
    }

    // Sugestão baseada em anomalias
    final anomalies = _detectAnomalies(transactions);
    if (anomalies.length > 3) {
      suggestions.add(
        'Você teve ${anomalies.length} gastos atípicos. Tente reduzir compras impulsivas',
      );
    }

    return suggestions;
  }

  // Previsão de orçamento para o próximo mês
  Map<String, dynamic> predictNextMonthBudget(
    List<TransactionModel> transactions,
  ) {
    if (transactions.length < 10) {
      return {
        'available': false,
        'message': 'Dados insuficientes para previsão',
      };
    }

    // Calcular médias dos últimos 3 meses
    final now = DateTime.now();
    final threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);

    final recentTransactions = transactions
        .where((t) => t.data.isAfter(threeMonthsAgo))
        .toList();

    final monthlyIncome = <int, double>{};
    final monthlyExpenses = <int, double>{};

    for (final transaction in recentTransactions) {
      final monthKey = transaction.data.month;
      if (transaction.type == TransactionType.income) {
        monthlyIncome[monthKey] =
            (monthlyIncome[monthKey] ?? 0) + transaction.valor;
      } else {
        monthlyExpenses[monthKey] =
            (monthlyExpenses[monthKey] ?? 0) + transaction.valor;
      }
    }

    final avgIncome = monthlyIncome.values.isEmpty
        ? 0
        : monthlyIncome.values.reduce((a, b) => a + b) / monthlyIncome.length;
    final avgExpenses = monthlyExpenses.values.isEmpty
        ? 0
        : monthlyExpenses.values.reduce((a, b) => a + b) /
              monthlyExpenses.length;

    final predictedIncome = avgIncome * 1.02; // 2% de aumento estimado
    final predictedExpenses = avgExpenses * 1.05; // 5% de aumento conservador
    final predictedSavings = predictedIncome - predictedExpenses;

    return {
      'available': true,
      'predictedIncome': predictedIncome,
      'predictedExpenses': predictedExpenses,
      'predictedSavings': predictedSavings,
      'confidence': monthlyIncome.length >= 3 ? 'high' : 'medium',
      'message':
          'Para o próximo mês, prevejo:\n• Receitas: R\$ ${predictedIncome.toStringAsFixed(2)}\n• Despesas: R\$ ${predictedExpenses.toStringAsFixed(2)}\n• Poupança: R\$ ${predictedSavings.toStringAsFixed(2)}',
    };
  }
}
