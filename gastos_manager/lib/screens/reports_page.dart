import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gastos_manager/models/transaction.dart';
import 'package:gastos_manager/models/category.dart';
import '../services/app_state.dart';
import '../services/theme_service.dart';
import '../widgets/smart_ad_banner_widget.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  DateTime _mesAtual = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _alterarMes(int direcao) {
    setState(() {
      _mesAtual = DateTime(_mesAtual.year, _mesAtual.month + direcao, 1);
    });
  }

  List<Transacao> _getTransacoesMes(List<Transacao> todasTransacoes) {
    return todasTransacoes.where((transacao) {
      return transacao.date.year == _mesAtual.year &&
          transacao.date.month == _mesAtual.month;
    }).toList();
  }

  String _getNomeMes() {
    const meses = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro',
    ];
    return meses[_mesAtual.month - 1];
  }

  Widget _buildResumoFinanceiro(List<Transacao> transacoes) {
    final receitas = transacoes
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);

    final despesas = transacoes
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);

    final saldo = receitas - despesas;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Resumo Financeiro',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildResumoItem('Receitas', receitas, Colors.green),
                      _buildResumoItem('Despesas', despesas, Colors.red),
                      _buildResumoItem(
                        'Saldo',
                        saldo,
                        saldo >= 0 ? Colors.green : Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumoItem(String titulo, double valor, Color cor) {
    return Column(
      children: [
        Text(titulo, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(
          'R\$ ${valor.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: cor,
          ),
        ),
      ],
    );
  }

  Widget _buildGraficoPizza(Map<String, double> gastosPorCategoria) {
    if (gastosPorCategoria.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pie_chart_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Nenhuma despesa encontrada',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    final sections = gastosPorCategoria.entries.map((entry) {
      final total = gastosPorCategoria.values.fold(0.0, (a, b) => a + b);
      final percentage = (entry.value / total * 100);

      return PieChartSectionData(
        color:
            Colors.primaries[gastosPorCategoria.keys.toList().indexOf(
                  entry.key,
                ) %
                Colors.primaries.length],
        value: entry.value,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 60,
      );
    }).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Gastos por Categoria',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 250,
              child: PieChart(PieChartData(sections: sections)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGraficoBarras(List<Transacao> transacoes) {
    if (transacoes.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Nenhuma transação encontrada',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Movimentação Diária',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  barGroups: [],
                  titlesData: const FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, double> _calcularGastosPorCategoria(
    List<Transacao> transacoes,
    List<Categoria> categorias,
  ) {
    final Map<String, double> gastos = {};

    for (final transacao in transacoes) {
      if (transacao.type == TransactionType.expense) {
        final categoria = categorias
            .where((c) => c.id == transacao.categoryId)
            .firstOrNull;
        if (categoria != null) {
          gastos[categoria.name] =
              (gastos[categoria.name] ?? 0) + transacao.amount;
        }
      }
    }

    return gastos;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppState, ThemeService>(
      builder: (context, appState, themeService, child) {
        final transacoesMes = _getTransacoesMes(appState.transacoes);
        final gastosPorCategoria = _calcularGastosPorCategoria(
          transacoesMes,
          appState.categorias,
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('Relatórios'),
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Resumo'),
                Tab(text: 'Por Categoria'),
                Tab(text: 'Diário'),
              ],
            ),
          ),
          body: Column(
            children: [
              // Seletor de mês
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => _alterarMes(-1),
                      icon: const Icon(Icons.chevron_left),
                    ),
                    Text(
                      '${_getNomeMes()} ${_mesAtual.year}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _alterarMes(1),
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ),

              // Conteúdo das abas
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Aba Resumo
                    SingleChildScrollView(
                      child: _buildResumoFinanceiro(transacoesMes),
                    ),

                    // Aba Por Categoria
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: _buildGraficoPizza(gastosPorCategoria),
                      ),
                    ),

                    // Aba Diário
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: _buildGraficoBarras(transacoesMes),
                      ),
                    ),
                  ],
                ),
              ),

              // Banner de anúncios
              const SmartAdBannerWidget(debugLabel: 'reports'),
            ],
          ),
        );
      },
    );
  }
}
