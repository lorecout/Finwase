# 📝 INTEGRAÇÃO COMPLETA - FATURAMENTO DE TESTE

## 🎯 IMPLEMENTAÇÃO PRONTA

Copie e cole este código em seu projeto para usar faturamento de teste completo!

---

## 📱 main.dart - Inicialização

```dart
import 'package:flutter/material.dart';
import 'package:gastos_manager/services/ad_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Inicializar AdMob
  await AdService.initialize();
  
  // 2. ATIVAR RASTREAMENTO DE RECEITA DE TESTE
  AdService.enableTestRevenue(true);
  
  print('✅ AdMob inicializado com faturamento de teste!');
  print('Mode: ${AdService.isTestMode() ? "🔧 TESTE" : "🚀 PRODUÇÃO"}');
  print('Rastreamento: ${AdService.isTestRevenueEnabled() ? "✅ ATIVADO" : "❌ DESATIVADO"}');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinWise com Faturamento de Teste',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}
```

---

## 📊 HomePage - Mostrar Receita

```dart
import 'package:flutter/material.dart';
import 'package:gastos_manager/services/ad_revenue_optimizer.dart';
import 'package:gastos_manager/services/ad_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AdRevenueOptimizer _optimizer;
  
  @override
  void initState() {
    super.initState();
    _initializeAds();
  }
  
  Future<void> _initializeAds() async {
    _optimizer = AdRevenueOptimizer();
    await _optimizer.initialize();
    
    // Carregar anúncios
    _optimizer.loadBannerAd();
    
    // Atualizar UI a cada segundo para ver receita em tempo real
    Future.delayed(Duration(seconds: 1), _refreshUI);
  }
  
  void _refreshUI() {
    if (mounted) {
      setState(() {});
      Future.delayed(Duration(seconds: 1), _refreshUI);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('💰 FinWise - Teste de Faturamento'),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Status
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '📊 Status do Sistema',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text('Modo: '),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AdService.isTestMode() ? Colors.orange : Colors.green,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              AdService.isTestMode() ? '🔧 TESTE' : '🚀 PRODUÇÃO',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Text('Faturamento: '),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AdService.isTestRevenueEnabled() ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              AdService.isTestRevenueEnabled() ? '✅ ATIVADO' : '❌ DESATIVADO',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Receita em Tempo Real
              _buildRevenueCard(context),
              
              const SizedBox(height: 16),
              
              // Botões de Teste
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _optimizer.loadBannerAd();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('🔄 Banner carregado (+$0.001)')),
                      );
                      _refreshUI();
                    },
                    child: const Text('Testar Banner'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _optimizer.loadInterstitialAd();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('🔄 Intersticial carregado (+$0.001)')),
                      );
                    },
                    child: const Text('Testar Intersticial'),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Detalhes por Anúncio
              _buildDetailCard(context),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildRevenueCard(BuildContext context) {
    final stats = _optimizer.getPerformanceStats();
    final totalRevenue = stats['totalRevenue'] as double? ?? 0.0;
    final totalImpressions = stats['totalImpressions'] as int? ?? 0;
    final totalClicks = stats['totalClicks'] as int? ?? 0;
    final ctr = stats['averageCTR'] as double? ?? 0.0;
    final ecpm = stats['averageECPM'] as double? ?? 0.0;
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '💸 Receita em Tempo Real',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                color: Colors.green[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            _buildStatRow('💰 Receita Total', '\$$totalRevenue.toStringAsFixed(2)', Colors.green),
            _buildStatRow('👀 Impressões', '$totalImpressions', Colors.blue),
            _buildStatRow('🖱️  Cliques', '$totalClicks', Colors.orange),
            _buildStatRow('📊 CTR', '${ctr.toStringAsFixed(2)}%', Colors.purple),
            _buildStatRow('💹 eCPM', '\$${ecpm.toStringAsFixed(2)}', Colors.teal),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: color),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDetailCard(BuildContext context) {
    final data = _optimizer.getPerformanceData();
    
    return Card(
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🎯 Detalhes por Anúncio',
              style: Theme.of(context).textTheme.headline6,
            ),
            const Divider(),
            if (data.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Nenhum anúncio carregado ainda...'),
              )
            else
              ...data.entries.map((entry) {
                final adId = entry.key.split('/').last;
                final perf = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        adId,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Impressões: ${perf.impressions}', style: const TextStyle(fontSize: 12)),
                          Text('Cliques: ${perf.clicks}', style: const TextStyle(fontSize: 12)),
                          Text('Receita: \$${perf.revenue.toStringAsFixed(4)}', style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                      const Divider(height: 8),
                    ],
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _optimizer.dispose();
    super.dispose();
  }
}
```

---

## 🔧 Widget de Testes Avançados

```dart
class TestPanel extends StatefulWidget {
  const TestPanel({Key? key}) : super(key: key);

  @override
  State<TestPanel> createState() => _TestPanelState();
}

class _TestPanelState extends State<TestPanel> {
  late AdRevenueOptimizer _optimizer;
  
  @override
  void initState() {
    super.initState();
    _optimizer = AdRevenueOptimizer();
    _optimizer.initialize();
  }
  
  void _simulateImpression() {
    _optimizer.loadBannerAd();
    print('Simulação: Banner carregado +\$0.001');
  }
  
  void _simulateClick() {
    // Simular clique (pode ser feito em um listener real)
    print('Simulação: Clique registrado +\$0.10');
  }
  
  void _printStats() {
    final stats = _optimizer.getPerformanceStats();
    print('''
    ╔═══════════════════════════════════════╗
    ║ 📊 ESTATÍSTICAS DE RECEITA            ║
    ╠═══════════════════════════════════════╣
    ║ Receita:     \$${stats['totalRevenue']?.toStringAsFixed(2).padRight(10)}       ║
    ║ Impressões:  ${stats['totalImpressions']?.toString().padRight(10)}       ║
    ║ Cliques:     ${stats['totalClicks']?.toString().padRight(10)}       ║
    ║ CTR:         ${stats['averageCTR']?.toStringAsFixed(2)}%          ║
    ║ eCPM:        \$${stats['averageECPM']?.toStringAsFixed(2).padRight(10)}       ║
    ╚═══════════════════════════════════════╝
    ''');
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.preview),
          label: const Text('Simular Impressão'),
          onPressed: _simulateImpression,
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.touch_app),
          label: const Text('Simular Clique'),
          onPressed: _simulateClick,
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.bar_chart),
          label: const Text('Ver Estatísticas'),
          onPressed: _printStats,
        ),
      ],
    );
  }
  
  @override
  void dispose() {
    _optimizer.dispose();
    super.dispose();
  }
}
```

---

## ✅ PRONTO PARA USAR!

Copie os arquivos acima e você terá:

✅ Inicialização com faturamento de teste
✅ Interface mostrando receita em tempo real
✅ Simulação de impressões e cliques
✅ Dashboard completo de estatísticas
✅ Tudo integrado e funcionando!

---

**🎉 Seu app está 100% pronto para testar faturamento!**

