import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/debug_service.dart';
import '../services/app_state.dart';

class DebugPage extends StatefulWidget {
  const DebugPage({super.key});

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  final DebugService _debugService = DebugService();
  bool _isLoading = false;
  Map<String, dynamic>? _analysisResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug & Análise'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAnalysisSection(),
            const SizedBox(height: 24),
            _buildLogsSection(),
            const SizedBox(height: 24),
            _buildActionsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Análise de Dados',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _runAnalysis,
                icon: _isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh),
                label: Text(_isLoading ? 'Analisando...' : 'Executar Análise'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            if (_analysisResult != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resultado da Análise',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._analysisResult!.entries.map((entry) {
                      String displayValue = entry.value.toString();
                      Color textColor = Colors.black87;

                      // Destacar dados suspeitos
                      if (entry.key == 'suspicious_transactions' ||
                          entry.key == 'suspicious_categories') {
                        final count = entry.value as int;
                        textColor = count > 0
                            ? Colors.red[700]!
                            : Colors.green[700]!;
                        displayValue = count > 0
                            ? '$count (encontrados dados fictícios)'
                            : '$count (nenhum dado fictício)';
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 13,
                            ),
                            children: [
                              TextSpan(
                                text: '${entry.key}: ',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: displayValue,
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLogsSection() {
    final logs = _debugService.logs;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.list_alt, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      'Logs de Debug (${logs.length})',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (logs.isNotEmpty)
                  TextButton.icon(
                    onPressed: () {
                      _debugService.clearLogs();
                      setState(() {});
                    },
                    icon: const Icon(Icons.clear),
                    label: const Text('Limpar'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 200,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
              ),
              child: logs.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum log disponível',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: logs.length,
                      itemBuilder: (context, index) {
                        return Text(
                          logs[index],
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.settings, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  'Ações Rápidas',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/data-debug'),
                icon: const Icon(Icons.data_exploration),
                label: const Text('Análise Detalhada de Dados'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _cleanFictitiousData,
                icon: _isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.delete_sweep),
                label: Text(
                  _isLoading ? 'Limpando...' : 'Limpar Dados Fictícios',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _clearAllData,
                icon: _isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.delete_forever),
                label: Text(
                  _isLoading ? 'Limpando...' : 'LIMPAR TODOS OS DADOS',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[800],
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _runAnalysis() async {
    setState(() => _isLoading = true);

    try {
      final result = await _debugService.analyzeUserData();
      setState(() => _analysisResult = result);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Análise concluída com sucesso'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro na análise: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _cleanFictitiousData() async {
    // Mostrar confirmação antes de limpar
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Limpeza'),
        content: const Text(
          'Esta ação irá remover permanentemente todos os dados fictícios '
          '(transações e categorias com palavras como "teste", "exemplo", etc.). '
          'Esta ação não pode ser desfeita.\n\n'
          'Deseja continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              'Sim, Limpar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    try {
      final result = await _debugService.cleanFictitiousData();

      // Limpar dados locais do AppState
      final appState = Provider.of<AppState>(context, listen: false);
      appState.limparDados();

      if (context.mounted) {
        if (result['success'] == true) {
          final transactionsRemoved = result['transactions_removed'] ?? 0;
          final categoriesRemoved = result['categories_removed'] ?? 0;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '🧹 Limpeza de dados fictícios concluída!\n'
                'Transações removidas: $transactionsRemoved\n'
                'Categorias removidas: $categoriesRemoved\n'
                'Dashboard foi atualizado para mostrar apenas dados reais.',
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 5),
            ),
          );

          // Atualizar análise após limpeza
          _runAnalysis();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Erro na limpeza: ${result['errors']?.join(', ') ?? 'Erro desconhecido'}',
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro na limpeza: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _clearAllData() async {
    // Mostrar confirmação antes de limpar TUDO
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red[800]),
            const SizedBox(width: 8),
            const Text('PERIGO - LIMPAR TUDO'),
          ],
        ),
        content: const Text(
          'ATENÇÃO: Esta ação irá remover PERMANENTEMENTE:\n\n'
          '• TODAS as transações\n'
          '• TODAS as categorias personalizadas\n'
          '• TODOS os orçamentos\n'
          '• TODO o histórico de dados\n\n'
          '🚨 ESTA AÇÃO NÃO PODE SER DESFEITA!\n\n'
          'Só use se quiser começar completamente do zero.\n\n'
          'Tem certeza absoluta?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[800]),
            child: const Text(
              'SIM, DELETAR TUDO',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    try {
      final result = await _debugService.clearAllUserData();

      // Limpar dados locais do AppState
      final appState = Provider.of<AppState>(context, listen: false);
      appState.limparDados();

      if (context.mounted) {
        if (result['success'] == true) {
          final transactionsRemoved = result['transactions_removed'] ?? 0;
          final categoriesRemoved = result['categories_removed'] ?? 0;
          final budgetsRemoved = result['budgets_removed'] ?? 0;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '✅ LIMPEZA COMPLETA!\n'
                'Transações removidas: $transactionsRemoved\n'
                'Categorias removidas: $categoriesRemoved\n'
                'Orçamentos removidos: $budgetsRemoved\n'
                'Dashboard também foi limpo. Agora você tem uma conta completamente limpa.',
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 6),
            ),
          );

          // Atualizar análise após limpeza
          _runAnalysis();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Erro na limpeza: ${result['errors']?.join(', ') ?? 'Erro desconhecido'}',
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro na limpeza: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
