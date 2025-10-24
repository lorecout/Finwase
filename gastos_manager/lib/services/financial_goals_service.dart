import 'dart:math';
import '../models/transaction.dart';
import '../services/app_state.dart';

class FinancialGoalsService {
  final AppState _appState;

  FinancialGoalsService(this._appState);

  // Criar meta financeira
  FinancialGoal createGoal({
    required String title,
    required double targetAmount,
    required DateTime targetDate,
    String? description,
    String? category,
    double initialAmount = 0.0,
  }) {
    return FinancialGoal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      targetAmount: targetAmount,
      currentAmount: initialAmount,
      targetDate: targetDate,
      description: description,
      category: category,
      createdAt: DateTime.now(),
      isActive: true,
    );
  }

  // Calcular progresso da meta
  double calculateProgress(FinancialGoal goal) {
    if (goal.targetAmount <= 0) return 0.0;
    return min(goal.currentAmount / goal.targetAmount, 1.0);
  }

  // Calcular tempo restante para a meta
  Duration calculateTimeRemaining(FinancialGoal goal) {
    return goal.targetDate.difference(DateTime.now());
  }

  // Calcular valor mensal necessário para alcançar a meta
  double calculateMonthlyContribution(FinancialGoal goal) {
    final timeRemaining = calculateTimeRemaining(goal);
    if (timeRemaining.isNegative) return 0.0;

    final monthsRemaining = timeRemaining.inDays / 30.0;
    if (monthsRemaining <= 0) return goal.targetAmount - goal.currentAmount;

    final remainingAmount = goal.targetAmount - goal.currentAmount;
    return remainingAmount / monthsRemaining;
  }

  // Calcular valor semanal necessário
  double calculateWeeklyContribution(FinancialGoal goal) {
    final monthly = calculateMonthlyContribution(goal);
    return monthly / 4.3; // Aproximadamente 4.3 semanas por mês
  }

  // Calcular valor diário necessário
  double calculateDailyContribution(FinancialGoal goal) {
    final monthly = calculateMonthlyContribution(goal);
    return monthly / 30.0; // Aproximadamente 30 dias por mês
  }

  // Verificar se a meta foi alcançada
  bool isGoalAchieved(FinancialGoal goal) {
    return goal.currentAmount >= goal.targetAmount;
  }

  // Verificar se a meta está atrasada
  bool isGoalOverdue(FinancialGoal goal) {
    return DateTime.now().isAfter(goal.targetDate) && !isGoalAchieved(goal);
  }

  // Obter sugestões de metas baseadas no perfil financeiro
  List<FinancialGoal> suggestGoals() {
    final suggestions = <FinancialGoal>[];
    final transactions = _appState.transacoes;
    final budgets = _appState.orcamentos;

    // Analisar padrões de gastos
    final monthlyIncome = _calculateMonthlyIncome(transactions);
    final monthlyExpenses = _calculateMonthlyExpenses(transactions);

    if (monthlyIncome > 0) {
      // Meta de emergência (3-6 meses de despesas)
      final emergencyFundTarget = monthlyExpenses * 6;
      suggestions.add(
        createGoal(
          title: 'Fundo de Emergência',
          targetAmount: emergencyFundTarget,
          targetDate: DateTime.now().add(const Duration(days: 365)), // 1 ano
          description: 'Guardar 6 meses de despesas para imprevistos',
          category: 'Emergência',
        ),
      );

      // Meta de investimento (20% da renda)
      final investmentTarget = monthlyIncome * 0.2 * 12; // 1 ano
      suggestions.add(
        createGoal(
          title: 'Investimentos',
          targetAmount: investmentTarget,
          targetDate: DateTime.now().add(const Duration(days: 365)),
          description: 'Guardar 20% da renda mensal para investimentos',
          category: 'Investimentos',
        ),
      );

      // Meta de viagem (baseada no orçamento de lazer)
      final leisureBudget = budgets
          .where((b) => b.categoriaId != null)
          .fold(0.0, (sum, b) => sum + b.valorLimite);

      if (leisureBudget > 0) {
        suggestions.add(
          createGoal(
            title: 'Viagem dos Sonhos',
            targetAmount: leisureBudget * 12, // 1 ano de lazer
            targetDate: DateTime.now().add(const Duration(days: 730)), // 2 anos
            description: 'Guardar para uma viagem especial',
            category: 'Viagem',
          ),
        );
      }
    }

    return suggestions;
  }

  // Calcular renda mensal média
  double _calculateMonthlyIncome(List<TransactionModel> transactions) {
    final incomeTransactions = transactions
        .where((t) => t.type == TransactionType.income)
        .toList();

    if (incomeTransactions.isEmpty) return 0.0;

    final totalIncome = incomeTransactions.fold(
      0.0,
      (sum, t) => sum + t.amount,
    );
    final months = _calculateMonthsSpan(incomeTransactions);

    return months > 0 ? totalIncome / months : totalIncome;
  }

  // Calcular despesas mensais médias
  double _calculateMonthlyExpenses(List<TransactionModel> transactions) {
    final expenseTransactions = transactions
        .where((t) => t.type == TransactionType.expense)
        .toList();

    if (expenseTransactions.isEmpty) return 0.0;

    final totalExpenses = expenseTransactions.fold(
      0.0,
      (sum, t) => sum + t.amount,
    );
    final months = _calculateMonthsSpan(expenseTransactions);

    return months > 0 ? totalExpenses / months : totalExpenses;
  }

  // Calcular span em meses das transações
  int _calculateMonthsSpan(List<TransactionModel> transactions) {
    if (transactions.isEmpty) return 1;

    final dates = transactions.map((t) => t.date).toList();
    dates.sort();

    final firstDate = dates.first;
    final lastDate = dates.last;

    final months =
        (lastDate.year - firstDate.year) * 12 +
        lastDate.month -
        firstDate.month +
        1;

    return max(months, 1);
  }

  // Obter estatísticas das metas
  Map<String, dynamic> getGoalsStats(List<FinancialGoal> goals) {
    final activeGoals = goals.where((g) => g.isActive).toList();
    final completedGoals = goals.where((g) => isGoalAchieved(g)).toList();
    final overdueGoals = goals.where((g) => isGoalOverdue(g)).toList();

    final totalTargetAmount = activeGoals.fold(
      0.0,
      (sum, g) => sum + g.targetAmount,
    );
    final totalCurrentAmount = activeGoals.fold(
      0.0,
      (sum, g) => sum + g.currentAmount,
    );

    return {
      'totalGoals': goals.length,
      'activeGoals': activeGoals.length,
      'completedGoals': completedGoals.length,
      'overdueGoals': overdueGoals.length,
      'totalTargetAmount': totalTargetAmount,
      'totalCurrentAmount': totalCurrentAmount,
      'overallProgress': totalTargetAmount > 0
          ? totalCurrentAmount / totalTargetAmount
          : 0.0,
      'completionRate': goals.isNotEmpty
          ? completedGoals.length / goals.length
          : 0.0,
    };
  }

  // Obter dicas para alcançar metas
  List<String> getGoalTips(FinancialGoal goal) {
    final tips = <String>[];
    final progress = calculateProgress(goal);
    final timeRemaining = calculateTimeRemaining(goal);
    final monthlyNeeded = calculateMonthlyContribution(goal);

    if (progress < 0.3) {
      tips.add(
        'Você está no início da jornada! Mantenha o foco e estabeleça contribuições regulares.',
      );
    }

    if (timeRemaining.inDays < 30 && !isGoalAchieved(goal)) {
      tips.add(
        'O prazo está se aproximando! Considere aumentar suas contribuições mensais.',
      );
    }

    if (monthlyNeeded > _calculateMonthlyIncome(_appState.transacoes) * 0.3) {
      tips.add(
        'O valor mensal necessário pode ser alto. Considere estender o prazo da meta.',
      );
    }

    if (progress > 0.8) {
      tips.add('Você está quase lá! Falta pouco para alcançar sua meta.');
    }

    tips.add(
      'Configure lembretes automáticos para manter suas contribuições em dia.',
    );
    tips.add('Acompanhe seu progresso regularmente para manter a motivação.');

    return tips;
  }

  // Calcular projeção de alcance da meta
  Map<String, dynamic> calculateGoalProjection(
    FinancialGoal goal,
    double monthlyContribution,
  ) {
    final remainingAmount = goal.targetAmount - goal.currentAmount;
    final monthsToComplete = remainingAmount / monthlyContribution;

    final projectedCompletionDate = DateTime.now().add(
      Duration(days: (monthsToComplete * 30).round()),
    );

    final isAchievable = !projectedCompletionDate.isAfter(goal.targetDate);

    return {
      'monthsToComplete': monthsToComplete,
      'projectedCompletionDate': projectedCompletionDate,
      'isAchievable': isAchievable,
      'additionalMonthlyNeeded': max(
        0,
        calculateMonthlyContribution(goal) - monthlyContribution,
      ),
    };
  }

  // Categorizar metas por prioridade
  List<FinancialGoal> prioritizeGoals(List<FinancialGoal> goals) {
    final prioritized = List<FinancialGoal>.from(goals);

    prioritized.sort((a, b) {
      // Primeiro, metas atrasadas têm prioridade máxima
      final aOverdue = isGoalOverdue(a);
      final bOverdue = isGoalOverdue(b);

      if (aOverdue && !bOverdue) return -1;
      if (!aOverdue && bOverdue) return 1;

      // Depois, metas mais próximas do prazo
      final aUrgency = calculateTimeRemaining(a).inDays;
      final bUrgency = calculateTimeRemaining(b).inDays;

      if (aUrgency != bUrgency) return aUrgency.compareTo(bUrgency);

      // Por último, por progresso (menos progresso = mais prioridade)
      final aProgress = calculateProgress(a);
      final bProgress = calculateProgress(b);

      return aProgress.compareTo(bProgress);
    });

    return prioritized;
  }
}

// Modelo para representar uma meta financeira
class FinancialGoal {
  final String id;
  final String title;
  final String? description;
  final String? category;
  final double targetAmount;
  double currentAmount;
  final DateTime targetDate;
  final DateTime createdAt;
  bool isActive;
  final List<GoalContribution> contributions;

  FinancialGoal({
    required this.id,
    required this.title,
    this.description,
    this.category,
    required this.targetAmount,
    required this.currentAmount,
    required this.targetDate,
    required this.createdAt,
    this.isActive = true,
    List<GoalContribution>? contributions,
  }) : contributions = contributions ?? [];

  // Adicionar contribuição à meta
  void addContribution(double amount, {String? description, DateTime? date}) {
    final contribution = GoalContribution(
      amount: amount,
      description: description,
      date: date ?? DateTime.now(),
    );

    contributions.add(contribution);
    currentAmount += amount;
  }

  // Calcular progresso
  double get progress {
    if (targetAmount <= 0) return 0.0;
    return currentAmount / targetAmount;
  }

  // Verificar se foi alcançada
  bool get isAchieved => currentAmount >= targetAmount;

  // Verificar se está atrasada
  bool get isOverdue => DateTime.now().isAfter(targetDate) && !isAchieved;

  // Calcular dias restantes
  int get daysRemaining => targetDate.difference(DateTime.now()).inDays;

  // Criar cópia com modificações
  FinancialGoal copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    double? targetAmount,
    double? currentAmount,
    DateTime? targetDate,
    DateTime? createdAt,
    bool? isActive,
    List<GoalContribution>? contributions,
  }) {
    return FinancialGoal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      targetDate: targetDate ?? this.targetDate,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      contributions: contributions ?? this.contributions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'targetDate': targetDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
      'contributions': contributions.map((c) => c.toJson()).toList(),
    };
  }

  factory FinancialGoal.fromJson(Map<String, dynamic> json) {
    return FinancialGoal(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      targetAmount: json['targetAmount'],
      currentAmount: json['currentAmount'],
      targetDate: DateTime.parse(json['targetDate']),
      createdAt: DateTime.parse(json['createdAt']),
      isActive: json['isActive'] ?? true,
      contributions:
          (json['contributions'] as List<dynamic>?)
              ?.map((c) => GoalContribution.fromJson(c))
              .toList() ??
          [],
    );
  }
}

// Modelo para representar uma contribuição a uma meta
class GoalContribution {
  final double amount;
  final String? description;
  final DateTime date;

  const GoalContribution({
    required this.amount,
    this.description,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'description': description,
      'date': date.toIso8601String(),
    };
  }

  factory GoalContribution.fromJson(Map<String, dynamic> json) {
    return GoalContribution(
      amount: json['amount'],
      description: json['description'],
      date: DateTime.parse(json['date']),
    );
  }
}
