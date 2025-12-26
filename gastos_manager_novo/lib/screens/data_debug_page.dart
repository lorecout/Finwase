import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../services/firebase_service.dart';
import '../models/transaction.dart';

/// Página para debug de dados
/// Investiga por que os valores aparecem no dashboard mas não no resumo financeiro
class DataDebugPage extends StatefulWidget {
  const DataDebugPage({super.key});

  @override
  State<DataDebugPage> createState() => _DataDebugPageState();
}

class _DataDebugPageState extends State<DataDebugPage> {
  DateTime _mesAtual = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug de Dados'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Consumer2<AppState, FirebaseService>(
        builder: (context, appState, firebaseService, child) {
          // Filtrar transações do mês atual (como na página de relatórios)
          final transacoesMes = appState.transacoes.where((transacao) {
            return transacao.date.year == _mesAtual.year &&
                transacao.date.month == _mesAtual.month;
          }).toList();

          // Calcular valores do mês atual
          final receitasMes = transacoesMes
              .where((t) => t.tipo == TipoTransacao.receita)
              .fold(0.0, (sum, t) => sum + t.valor);

          final despesasMes = transacoesMes
              .where((t) => t.tipo == TipoTransacao.despesa)
              .fold(0.0, (sum, t) => sum + t.valor);

          final saldoMes = receitasMes - despesasMes;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Informações de usuário
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Usuário',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'UID: ${firebaseService.currentUser?.uid ?? "Não logado"}',
                        ),
                        Text(
                          'Email: ${firebaseService.currentUser?.email ?? "N/A"}',
                        ),
                        Text(
                          'Logado: ${firebaseService.currentUser != null ? "Sim" : "Não"}',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Totais gerais (como no dashboard)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Totais Gerais (Dashboard)',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Total de transações: ${appState.transacoes.length}',
                        ),
                        Text(
                          'Receitas totais: R\$ ${appState.receitasPeriodo.toStringAsFixed(2)}',
                        ),
                        Text(
                          'Despesas totais: R\$ ${appState.despesasPeriodo.toStringAsFixed(2)}',
                        ),
                        Text(
                          'Saldo total: R\$ ${appState.saldoTotal.toStringAsFixed(2)}',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Mês atual (como nos relatórios)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mês Atual (${_mesAtual.month}/${_mesAtual.year}) - Relatórios',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text('Transações do mês: ${transacoesMes.length}'),
                        Text(
                          'Receitas do mês: R\$ ${receitasMes.toStringAsFixed(2)}',
                        ),
                        Text(
                          'Despesas do mês: R\$ ${despesasMes.toStringAsFixed(2)}',
                        ),
                        Text(
                          'Saldo do mês: R\$ ${saldoMes.toStringAsFixed(2)}',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Listagem das transações
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Transações Carregadas',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        if (appState.transacoes.isEmpty)
                          const Text('Nenhuma transação encontrada')
                        else
                          ...appState.transacoes
                              .take(10)
                              .map(
                                (transacao) => Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    dense: true,
                                    title: Text(transacao.title),
                                    subtitle: Text(
                                      '${transacao.date.day}/${transacao.date.month}/${transacao.date.year} - ${transacao.tipo.name}',
                                    ),
                                    trailing: Text(
                                      'R\$ ${transacao.amount.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color:
                                            transacao.tipo ==
                                                TipoTransacao.receita
                                            ? Colors.green
                                            : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        if (appState.transacoes.length > 10)
                          Text(
                            '... e mais ${appState.transacoes.length - 10} transações',
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Ações de debug
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ações de Debug',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            appState.carregarDados();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Dados recarregados!'),
                              ),
                            );
                          },
                          child: const Text('Recarregar Dados do Firebase'),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _mesAtual = DateTime.now();
                            });
                          },
                          child: const Text('Resetar para Mês Atual'),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/debug');
                          },
                          child: const Text('Abrir Debug Service'),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () async {
                            // Navegar para página de transações
                            Navigator.pushNamed(context, '/transactions');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text('Ver Transações'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
