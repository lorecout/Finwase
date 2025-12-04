import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../services/app_state.dart';

class AdvancedReportsService {
  // Gerar relatório PDF
  Future<String> generatePDFReport(
    BuildContext context,
    AppState appState,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final pdf = pw.Document();

    // Filtrar transações por período
    final filteredTransactions = appState.transacoes.where((t) {
      return t.data.isAfter(startDate.subtract(const Duration(days: 1))) &&
          t.data.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();

    // Calcular totais
    final receitas = filteredTransactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);

    final despesas = filteredTransactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);

    final saldo = receitas - despesas;

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text(
                  'Relatório Financeiro Avançado',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Período: ${startDate.toString().split(' ')[0]} - ${endDate.toString().split(' ')[0]}',
              ),
              pw.SizedBox(height: 20),
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                  borderRadius: pw.BorderRadius.circular(5),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Resumo Financeiro',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text('Receitas: R\$ ${receitas.toStringAsFixed(2)}'),
                    pw.Text('Despesas: R\$ ${despesas.toStringAsFixed(2)}'),
                    pw.Text('Saldo: R\$ ${saldo.toStringAsFixed(2)}'),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Transações Detalhadas',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              ...filteredTransactions.map(
                (t) => pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 5),
                  padding: const pw.EdgeInsets.all(5),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(t.title),
                      pw.Text('R\$ ${t.amount.toStringAsFixed(2)}'),
                      pw.Text(t.type.name),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    // Salvar PDF
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/relatorio_financeiro.pdf');
    await file.writeAsBytes(await pdf.save());

    return file.path;
  }

  // Compartilhar relatório
  Future<void> shareReport(String filePath, String fileName) async {
    await Share.shareXFiles([
      XFile(filePath),
    ], text: 'Relatório Financeiro - $fileName');
  }

  // Análise de tendências
  Map<String, dynamic> analyzeTrends(List<TransactionModel> transactions) {
    if (transactions.isEmpty) {
      return {
        'trend': 'neutral',
        'message': 'Dados insuficientes para análise',
        'suggestion': 'Continue registrando transações para ver tendências',
      };
    }

    // Agrupar por mês
    final monthlyData = <String, Map<String, double>>{};
    for (final transaction in transactions) {
      final monthKey =
          '${transaction.date.year}-${transaction.date.month.toString().padLeft(2, '0')}';
      monthlyData[monthKey] ??= {'receitas': 0, 'despesas': 0};

      if (transaction.type == TransactionType.income) {
        monthlyData[monthKey]!['receitas'] =
            (monthlyData[monthKey]!['receitas'] ?? 0) + transaction.amount;
      } else {
        monthlyData[monthKey]!['despesas'] =
            (monthlyData[monthKey]!['despesas'] ?? 0) + transaction.amount;
      }
    }

    // Calcular tendência
    final months = monthlyData.keys.toList()..sort();
    if (months.length < 2) {
      return {
        'trend': 'neutral',
        'message': 'Dados insuficientes para análise de tendência',
        'suggestion': 'Continue registrando transações por mais alguns meses',
      };
    }

    final lastMonth = months.last;
    final previousMonth = months[months.length - 2];

    final lastMonthSaldo =
        (monthlyData[lastMonth]!['receitas'] ?? 0) -
        (monthlyData[lastMonth]!['despesas'] ?? 0);
    final previousMonthSaldo =
        (monthlyData[previousMonth]!['receitas'] ?? 0) -
        (monthlyData[previousMonth]!['despesas'] ?? 0);

    final difference = lastMonthSaldo - previousMonthSaldo;

    if (difference > 0) {
      return {
        'trend': 'positive',
        'message': 'Sua situação financeira melhorou este mês!',
        'suggestion': 'Continue com as boas práticas financeiras',
        'improvement': difference,
      };
    } else if (difference < 0) {
      return {
        'trend': 'negative',
        'message': 'Sua situação financeira piorou este mês',
        'suggestion':
            'Revise seus gastos e considere cortar despesas desnecessárias',
        'decline': difference.abs(),
      };
    } else {
      return {
        'trend': 'stable',
        'message': 'Sua situação financeira se manteve estável',
        'suggestion': 'Continue monitorando seus gastos regularmente',
      };
    }
  }

  // Previsões simples
  Map<String, dynamic> generatePredictions(
    List<TransactionModel> transactions,
  ) {
    if (transactions.length < 10) {
      return {
        'available': false,
        'message': 'Dados insuficientes para previsões',
      };
    }

    // Calcular médias mensais
    final monthlyExpenses = <int, double>{};
    for (final transaction in transactions.where(
      (t) => t.type == TransactionType.expense,
    )) {
      final month = transaction.date.month;
      monthlyExpenses[month] =
          (monthlyExpenses[month] ?? 0) + transaction.amount;
    }

    final avgMonthlyExpense =
        monthlyExpenses.values.reduce((a, b) => a + b) / monthlyExpenses.length;

    final nextMonthPrediction =
        avgMonthlyExpense * 1.05; // 5% de aumento estimado

    return {
      'available': true,
      'currentMonthAvg': avgMonthlyExpense,
      'nextMonthPrediction': nextMonthPrediction,
      'message':
          'Baseado em seus gastos históricos, prevejo R\$ ${nextMonthPrediction.toStringAsFixed(2)} em despesas para o próximo mês',
    };
  }

  // Análise por categoria
  Map<String, dynamic> analyzeByCategory(
    List<TransactionModel> transactions,
    List<CategoryModel> categories,
  ) {
    final categoryTotals = <String, double>{};

    for (final transaction in transactions.where(
      (t) => t.type == TransactionType.expense,
    )) {
      final categoryName = categories
          .firstWhere(
            (c) => c.id == transaction.categoryId,
            orElse: () => const CategoryModel(
              id: 'unknown',
              name: 'Desconhecida',
              icon: 'help',
              color: Colors.grey,
              type: CategoryType.expense,
              isDefault: false,
            ),
          )
          .name;

      categoryTotals[categoryName] =
          (categoryTotals[categoryName] ?? 0) + transaction.amount;
    }

    // Encontrar categoria com maior gasto
    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    if (sortedCategories.isEmpty) {
      return {
        'topCategory': 'N/A',
        'topAmount': 0.0,
        'message': 'Nenhuma despesa registrada',
      };
    }

    final topCategory = sortedCategories.first;
    final totalExpenses = sortedCategories.fold(
      0.0,
      (sum, entry) => sum + entry.value,
    );
    final percentage = (topCategory.value / totalExpenses) * 100;

    return {
      'topCategory': topCategory.key,
      'topAmount': topCategory.value,
      'percentage': percentage,
      'message':
          '${topCategory.key} representa ${percentage.toStringAsFixed(1)}% dos seus gastos',
      'suggestion': percentage > 50
          ? 'Considere diversificar seus gastos para reduzir a dependência desta categoria'
          : 'Sua distribuição de gastos está bem equilibrada',
    };
  }
}
