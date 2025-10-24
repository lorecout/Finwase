import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/budget_service.dart';
import '../services/app_state.dart';

class BudgetPage extends StatefulWidget {
  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final budgetService = Provider.of<BudgetService>(context, listen: false);

      // Analisar gastos e sugerir orçamentos
      await budgetService.analisarEsugerir();
      // Calcular alertas atuais
      await budgetService.calcularAlertas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('💰 Orçamentos'),
        backgroundColor: Color(0xFF6B63FF),
      ),
      body: Consumer2<BudgetService, AppState>(
        builder: (context, budgetService, appState, _) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Resumo do mês
                _buildResumo(budgetService),
                SizedBox(height: 24),

                // Gráfico de orçamento vs gasto
                if (budgetService.budgets.isNotEmpty)
                  _buildGraficoOrcamento(budgetService),
                SizedBox(height: 24),

                // Cards de alertas
                _buildAlertas(budgetService),
                SizedBox(height: 24),

                // Sugestões
                if (budgetService.suggestions.isNotEmpty)
                  _buildSugestes(budgetService),
                SizedBox(height: 24),

                // Lista de orçamentos salvos
                _buildOrcamentosSalvos(budgetService, context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildResumo(BudgetService budgetService) {
    final resumo = budgetService.getResumo();
    final percentualUsado = (resumo['percentualUsado'] as num).toDouble();
    final totalOrcado = resumo['totalOrcado'] as double;
    final totalGasto = resumo['totalGasto'] as double;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6B63FF), Color(0xFF8B7FFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumo do Mês',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Orçado', style: TextStyle(color: Colors.white70)),
                    Text(
                      'R\$ ${totalOrcado.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Gasto', style: TextStyle(color: Colors.white70)),
                    Text(
                      'R\$ ${totalGasto.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: (percentualUsado / 100).clamp(0, 1),
                minHeight: 8,
                backgroundColor: Colors.white30,
                valueColor: AlwaysStoppedAnimation<Color>(
                  percentualUsado >= 100 ? Colors.red : Colors.greenAccent,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${percentualUsado.toStringAsFixed(1)}% do orçamento utilizado',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGraficoOrcamento(BudgetService budgetService) {
    final dados = budgetService.budgets.entries
        .take(6)
        .toList()
        .asMap()
        .entries
        .map((e) {
          final categoria = e.value.key;
          final limite = e.value.value;
          final gasto = budgetService.alerts[categoria]?.gastoAtual ?? 0;
          return {
            'categoria': categoria,
            'limite': limite,
            'gasto': gasto,
            'index': e.key,
          };
        })
        .toList();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📊 Orçamento vs Gasto',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: List.generate(dados.length, (index) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: dados[index]['limite'] as double,
                          color: Colors.blue.shade300,
                          width: 8,
                        ),
                        BarChartRodData(
                          toY: dados[index]['gasto'] as double,
                          color: Colors.orange,
                          width: 8,
                        ),
                      ],
                    );
                  }),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < dados.length) {
                            return Text(
                              dados[value.toInt()]['categoria']
                                  .toString()
                                  .substring(0, 3),
                              style: TextStyle(fontSize: 10),
                            );
                          }
                          return Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade300,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8),
                Text('Orçado', style: TextStyle(fontSize: 12)),
                SizedBox(width: 24),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8),
                Text('Gasto', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertas(BudgetService budgetService) {
    final alertasComProblema = budgetService.alerts.entries
        .where((e) => e.value.status != 'ok')
        .toList();

    if (alertasComProblema.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '⚠️ Alertas de Orçamento',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        ...alertasComProblema.map((entry) {
          final alert = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Card(
              color: alert.cor.withOpacity(0.1),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          alert.categoria,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${alert.percentualUsado.toStringAsFixed(0)}%',
                          style: TextStyle(
                            color: alert.cor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (alert.percentualUsado / 100).clamp(0, 1),
                        minHeight: 6,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(alert.cor),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'R\$ ${alert.gastoAtual.toStringAsFixed(2)} de R\$ ${alert.limite.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    SizedBox(height: 4),
                    Text(
                      alert.mensagem,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildSugestes(BudgetService budgetService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '💡 Sugestões de Orçamento',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        ...budgetService.suggestions.take(5).map((sugestao) {
          final jaTemOrcamento = budgetService.budgets.containsKey(
            sugestao.categoria,
          );

          return Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sugestao.categoria,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Gasto médio: R\$ ${sugestao.gastoMedio.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'R\$ ${sugestao.sugeridoMensal.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6B63FF),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: jaTemOrcamento
                            ? null
                            : () async {
                                await Provider.of<BudgetService>(
                                  context,
                                  listen: false,
                                ).aceitarSugestao(sugestao);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('✅ Orçamento salvo!')),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: jaTemOrcamento
                              ? Colors.grey.shade300
                              : Color(0xFF6B63FF),
                        ),
                        child: Text(
                          jaTemOrcamento
                              ? '✓ Já tem orçamento'
                              : 'Aceitar sugestão',
                          style: TextStyle(
                            color: jaTemOrcamento ? Colors.grey : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildOrcamentosSalvos(
    BudgetService budgetService,
    BuildContext context,
  ) {
    if (budgetService.budgets.isEmpty) {
      return Center(
        child: Column(
          children: [
            Icon(Icons.wallet, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Nenhum orçamento definido',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '📋 Orçamentos Definidos',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        ...budgetService.budgets.entries.map((entry) {
          final categoria = entry.key;
          final limite = entry.value;
          final alert = budgetService.alerts[categoria];

          return Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(categoria),
              subtitle: Text('Limite: R\$ ${limite.toStringAsFixed(2)}'),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  await Provider.of<BudgetService>(
                    context,
                    listen: false,
                  ).removerOrcamento(categoria);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('✅ Orçamento removido')),
                  );
                },
              ),
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: alert?.cor.withOpacity(0.2) ?? Colors.blue.shade100,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  alert != null
                      ? '${alert.percentualUsado.toStringAsFixed(0)}%'
                      : '0%',
                  style: TextStyle(
                    color: alert?.cor ?? Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
