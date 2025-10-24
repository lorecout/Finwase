import '../models/orcamento.dart';
import '../models/transaction.dart';
import '../services/app_state.dart';

class SmartBudgetService {
  // Análise inteligente de orçamentos
  Map<String, dynamic> analyzeBudgets(AppState appState) {
    final budgets = appState.orcamentos;
    final transactions = appState.transacoes;

    if (budgets.isEmpty) {
      return {
        'status': 'no_budgets',
        'message': 'Você ainda não criou nenhum orçamento',
        'recommendations': [
          'Crie orçamentos para suas principais categorias de gastos',
        ],
      };
    }

    final budgetAnalysis = <Map<String, dynamic>>[];
    var totalBudgeted = 0.0;
    var totalSpent = 0.0;
    var alerts = <Map<String, dynamic>>[];

    for (final budget in budgets) {
      final spent = _calculateSpentInBudget(budget, transactions);
      final remaining = budget.valorLimite - spent;
      final percentage = budget.valorLimite > 0
          ? (spent / budget.valorLimite) * 100
          : 0;

      totalBudgeted += budget.valorLimite;
      totalSpent += spent;

      // Obter nome da categoria
      final categoryName = budget.categoriaId != null
          ? appState.getCategoriaById(budget.categoriaId!)?.nome ??
                'Categoria desconhecida'
          : budget.nome;

      // Determinar status do orçamento
      String status;
      String statusColor;
      if (percentage >= 100) {
        status = 'exceeded';
        statusColor = 'red';
        alerts.add({
          'type': 'budget_exceeded',
          'message':
              'Orçamento de $categoryName excedido em R\$ ${(spent - budget.valorLimite).toStringAsFixed(2)}',
          'severity': 'high',
        });
      } else if (percentage >= 80) {
        status = 'warning';
        statusColor = 'orange';
        alerts.add({
          'type': 'budget_warning',
          'message':
              'Orçamento de $categoryName está em ${percentage.toStringAsFixed(1)}%',
          'severity': 'medium',
        });
      } else {
        status = 'good';
        statusColor = 'green';
      }

      budgetAnalysis.add({
        'budget': budget,
        'spent': spent,
        'remaining': remaining,
        'percentage': percentage,
        'status': status,
        'statusColor': statusColor,
        'categoryName': categoryName,
      });
    }

    // Análise geral
    final overallPercentage = totalBudgeted > 0
        ? (totalSpent / totalBudgeted) * 100
        : 0;
    final overallStatus = _getOverallStatus(overallPercentage.toDouble());

    // Recomendações inteligentes
    final recommendations = _generateBudgetRecommendations(
      budgetAnalysis,
      transactions,
    );

    return {
      'status': overallStatus,
      'budgetAnalysis': budgetAnalysis,
      'alerts': alerts,
      'recommendations': recommendations,
      'summary': {
        'totalBudgeted': totalBudgeted,
        'totalSpent': totalSpent,
        'totalRemaining': totalBudgeted - totalSpent,
        'overallPercentage': overallPercentage,
      },
    };
  }

  // Calcular gastos em um orçamento específico
  double _calculateSpentInBudget(
    Orcamento budget,
    List<TransactionModel> transactions,
  ) {
    final now = DateTime.now();
    final budgetStart = DateTime(now.year, now.month, 1);
    final budgetEnd = DateTime(now.year, now.month + 1, 0);

    return transactions
        .where(
          (t) =>
              t.type == TransactionType.expense &&
              t.categoriaId == budget.categoriaId &&
              t.data.isAfter(budgetStart.subtract(const Duration(days: 1))) &&
              t.data.isBefore(budgetEnd.add(const Duration(days: 1))),
        )
        .fold(0.0, (sum, t) => sum + t.valor);
  }

  // Determinar status geral
  String _getOverallStatus(double percentage) {
    if (percentage >= 100) return 'critical';
    if (percentage >= 80) return 'warning';
    if (percentage >= 60) return 'caution';
    return 'good';
  }

  // Gerar recomendações inteligentes
  List<String> _generateBudgetRecommendations(
    List<Map<String, dynamic>> budgetAnalysis,
    List<TransactionModel> transactions,
  ) {
    final recommendations = <String>[];

    // Analisar orçamentos excedidos
    final exceededBudgets = budgetAnalysis
        .where((b) => b['status'] == 'exceeded')
        .toList();
    if (exceededBudgets.isNotEmpty) {
      recommendations.add(
        'Você excedeu ${exceededBudgets.length} orçamento(s). Considere transferir dinheiro de categorias com sobra.',
      );
    }

    // Analisar orçamentos próximos do limite
    final warningBudgets = budgetAnalysis
        .where((b) => b['status'] == 'warning')
        .toList();
    if (warningBudgets.isNotEmpty) {
      recommendations.add(
        '${warningBudgets.length} orçamento(s) estão próximos do limite. Monitore seus gastos.',
      );
    }

    // Analisar categorias sem orçamento
    final budgetedCategories = budgetAnalysis
        .map((b) => b['budget'].categoriaId)
        .toSet();
    final allCategories = transactions.map((t) => t.categoriaId).toSet();
    final unbudgetedCategories = allCategories.difference(budgetedCategories);

    if (unbudgetedCategories.isNotEmpty) {
      recommendations.add(
        'Você tem ${unbudgetedCategories.length} categoria(s) sem orçamento definido.',
      );
    }

    // Análise de padrão de gastos
    final currentMonth = DateTime.now().month;
    final currentMonthTransactions = transactions
        .where((t) => t.data.month == currentMonth && t.type == TransactionType.expense)
        .toList();

    if (currentMonthTransactions.length > 10) {
      final avgDailySpending =
          currentMonthTransactions.fold(0.0, (sum, t) => sum + t.valor) /
          DateTime.now().day;

      final daysLeft =
          DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day -
          DateTime.now().day;
      final projectedSpending = avgDailySpending * daysLeft;

      recommendations.add(
        'Projeção: você pode gastar até R\$ ${projectedSpending.toStringAsFixed(2)} nos próximos $daysLeft dias.',
      );
    }

    return recommendations;
  }

  // Sugerir novos orçamentos baseado no histórico
  List<Map<String, dynamic>> suggestNewBudgets(AppState appState) {
    final transactions = appState.transacoes;
    final existingBudgets = appState.orcamentos
        .map((b) => b.categoriaId)
        .toSet();

    // Agrupar gastos por categoria nos últimos 3 meses
    final threeMonthsAgo = DateTime.now().subtract(const Duration(days: 90));
    final recentTransactions = transactions
        .where((t) => t.data.isAfter(threeMonthsAgo) && t.type == TransactionType.expense)
        .toList();

    final categorySpending = <String, double>{};
    for (final transaction in recentTransactions) {
      categorySpending[transaction.categoriaId] =
          (categorySpending[transaction.categoriaId] ?? 0) + transaction.valor;
    }

    // Filtrar categorias sem orçamento e com gastos significativos
    final suggestions = <Map<String, dynamic>>[];
    final totalSpending = categorySpending.values.fold(
      0.0,
      (sum, amount) => sum + amount,
    );

    for (final entry in categorySpending.entries) {
      if (!existingBudgets.contains(entry.key)) {
        final percentage = (entry.value / totalSpending) * 100;
        if (percentage > 5) {
          // Só sugerir para categorias com >5% dos gastos
          final suggestedBudget = entry.value * 1.1; // 10% de margem
          final category = appState.getCategoriaById(entry.key);

          suggestions.add({
            'categoryId': entry.key,
            'categoryName': category?.nome ?? 'Desconhecida',
            'currentSpending': entry.value,
            'suggestedBudget': suggestedBudget,
            'reason':
                'Representa ${percentage.toStringAsFixed(1)}% dos seus gastos',
          });
        }
      }
    }

    return suggestions;
  }

  // Alertas em tempo real
  List<Map<String, dynamic>> getRealTimeAlerts(AppState appState) {
    final alerts = <Map<String, dynamic>>[];
    final budgets = appState.orcamentos;
    final transactions = appState.transacoes;

    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final daysPassed = now.day;
    final monthProgress = daysPassed / daysInMonth;

    for (final budget in budgets) {
      final spent = _calculateSpentInBudget(budget, transactions);
      final budgetProgress = budget.valorLimite > 0
          ? spent / budget.valorLimite
          : 0;

      // Alerta se estiver gastando mais rápido que o tempo
      if (budgetProgress > monthProgress * 1.2) {
        // 20% acima do ritmo
        final categoryName = budget.categoriaId != null
            ? appState.getCategoriaById(budget.categoriaId!)?.nome ??
                  'Categoria desconhecida'
            : budget.nome;

        alerts.add({
          'type': 'spending_pace',
          'severity': 'high',
          'message':
              'Você está gastando ${((budgetProgress / monthProgress - 1) * 100).toStringAsFixed(1)}% mais rápido que o planejado em $categoryName',
          'action': 'Considere reduzir gastos nesta categoria',
        });
      }

      // Alerta se orçamento será excedido baseado na tendência
      final dailyAverage = spent / daysPassed;
      final projectedSpending = dailyAverage * daysInMonth;

      if (projectedSpending > budget.valorLimite * 1.1) {
        // Projeção 10% acima
        final categoryName = budget.categoriaId != null
            ? appState.getCategoriaById(budget.categoriaId!)?.nome ??
                  'Categoria desconhecida'
            : budget.nome;

        alerts.add({
          'type': 'budget_projection',
          'severity': 'medium',
          'message':
              'Projeção indica que você excederá o orçamento de $categoryName em R\$ ${(projectedSpending - budget.valorLimite).toStringAsFixed(2)}',
          'action': 'Ajuste seus gastos ou aumente o orçamento',
        });
      }
    }

    return alerts;
  }

  // Otimização automática de orçamentos
  Map<String, dynamic> optimizeBudgets(AppState appState) {
    final budgets = appState.orcamentos;
    final transactions = appState.transacoes;

    if (budgets.isEmpty || transactions.isEmpty) {
      return {
        'optimizations': [],
        'message': 'Dados insuficientes para otimização',
      };
    }

    final optimizations = <Map<String, dynamic>>[];

    // Analisar orçamentos muito folgados
    for (final budget in budgets) {
      final spent = _calculateSpentInBudget(budget, transactions);
      final utilization = budget.valorLimite > 0
          ? spent / budget.valorLimite
          : 0;

      if (utilization < 0.5) {
        // Menos de 50% utilizado
        optimizations.add({
          'type': 'reduce_budget',
          'budget': budget,
          'currentUtilization': utilization,
          'suggestion':
              'Reduzir orçamento em ${(budget.valorLimite * 0.3).toStringAsFixed(2)} (30%)',
          'reason':
              'Orçamento subutilizado - você gastou apenas ${(utilization * 100).toStringAsFixed(1)}%',
        });
      }
    }

    // Analisar categorias com gastos crescentes
    final spendingTrends = _analyzeSpendingTrends(transactions);
    for (final trend in spendingTrends) {
      if (trend['growth'] > 0.2) {
        // Crescimento > 20%
        final relatedBudget = budgets.firstWhere(
          (b) => b.categoriaId == trend['categoryId'],
        );

        optimizations.add({
          'type': 'increase_budget',
          'budget': relatedBudget,
          'growth': trend['growth'],
          'suggestion':
              'Aumentar orçamento em ${(relatedBudget.valorLimite * trend['growth']).toStringAsFixed(2)}',
          'reason':
              'Gastos nesta categoria cresceram ${(trend['growth'] * 100).toStringAsFixed(1)}%',
        });
      }
    }

    return {
      'optimizations': optimizations,
      'message': optimizations.isEmpty
          ? 'Seus orçamentos estão bem balanceados'
          : 'Encontramos ${optimizations.length} oportunidades de otimização',
    };
  }

  // Análise de tendências de gastos
  List<Map<String, dynamic>> _analyzeSpendingTrends(
    List<TransactionModel> transactions,
  ) {
    final trends = <Map<String, dynamic>>[];

    // Agrupar por categoria e mês
    final categoryMonthlySpending = <String, Map<int, double>>{};

    for (final transaction in transactions.where((t) => t.type == TransactionType.expense)) {
      final categoryId = transaction.categoriaId;
      final month = transaction.data.month;

      categoryMonthlySpending[categoryId] ??= {};
      categoryMonthlySpending[categoryId]![month] =
          (categoryMonthlySpending[categoryId]![month] ?? 0) +
          transaction.valor;
    }

    // Calcular tendência para cada categoria
    for (final entry in categoryMonthlySpending.entries) {
      final monthlyData = entry.value;
      if (monthlyData.length >= 2) {
        final months = monthlyData.keys.toList()..sort();
        final recentMonths = months.sublist(months.length - 2);

        if (recentMonths.length == 2) {
          final previous = monthlyData[recentMonths[0]] ?? 0;
          final current = monthlyData[recentMonths[1]] ?? 0;

          if (previous > 0) {
            final growth = (current - previous) / previous;
            trends.add({
              'categoryId': entry.key,
              'growth': growth,
              'previousMonth': previous,
              'currentMonth': current,
            });
          }
        }
      }
    }

    return trends;
  }
}
