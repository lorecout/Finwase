import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gastos_manager/models/transaction.dart';
import 'package:gastos_manager/models/category.dart';
import '../services/app_state.dart';
import '../services/premium_service.dart';
import '../services/theme_service.dart';
import '../widgets/smart_ad_banner_widget.dart';
import '../widgets/premium_feature_access_page.dart';
import 'add_transaction_page.dart';
import '../main.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _filtroCategoria = '';
  DateTime? _filtroDataInicio;
  DateTime? _filtroDataFim;
  String _ordenacao = 'data_desc'; // data_desc, data_asc, valor_desc, valor_asc

  // Mapa de ícones para as categorias
  final Map<String, IconData> _iconMap = {
    '🍔': Icons.restaurant,
    '🚗': Icons.directions_car,
    '⚕️': Icons.medical_services,
    '🎮': Icons.sports_esports,
    '🏫': Icons.school,
    '🛍️': Icons.shopping_bag,
    '🏠': Icons.home,
    '💡': Icons.lightbulb,
    '👔': Icons.work,
    '📱': Icons.phone_android,
    '💰': Icons.monetization_on,
    '🎁': Icons.card_giftcard,
  };

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

  List<Transacao> _filtrarTransacoes(
    List<Transacao> transacoes,
    TipoTransacao? tipo,
  ) {
    var filtradas = transacoes.where((t) {
      if (tipo != null && t.tipo != tipo) {
        return false;
      }
      if (_filtroCategoria.isNotEmpty && t.categoriaId != _filtroCategoria) {
        return false;
      }
      if (_filtroDataInicio != null && t.data.isBefore(_filtroDataInicio!)) {
        return false;
      }
      if (_filtroDataFim != null && t.data.isAfter(_filtroDataFim!)) {
        return false;
      }
      return true;
    }).toList();

    // Ordenação
    switch (_ordenacao) {
      case 'data_asc':
        filtradas.sort((a, b) => a.data.compareTo(b.data));
        break;
      case 'data_desc':
        filtradas.sort((a, b) => b.data.compareTo(a.data));
        break;
      case 'valor_asc':
        filtradas.sort((a, b) => a.valor.compareTo(b.valor));
        break;
      case 'valor_desc':
        filtradas.sort((a, b) => b.valor.compareTo(a.valor));
        break;
    }

    return filtradas;
  }

  Widget _buildTransactionCard(Transacao transacao, Categoria? categoria) {
    final isReceita = transacao.tipo == TipoTransacao.receita;
    final cor = isReceita ? Colors.green : Colors.red;
    final icone = isReceita ? Icons.arrow_upward : Icons.arrow_downward;

    IconData categoriaIcon = _iconMap[categoria?.icone ?? ''] ?? Icons.category;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: () => _mostrarOpcoesTransacao(transacao),
        borderRadius: BorderRadius.circular(20),
        splashColor: cor.withValues(alpha: 0.1),
        highlightColor: cor.withValues(alpha: 0.05),
        child: Card(
          elevation: 6,
          shadowColor: cor.withValues(alpha: 0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).cardColor,
                  Theme.of(context).cardColor.withValues(alpha: 0.95),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      categoria != null
                          ? Color(categoria.cor).withValues(alpha: 0.3)
                          : Colors.grey[300]!,
                      categoria != null
                          ? Color(categoria.cor).withValues(alpha: 0.1)
                          : Colors.grey[200]!,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (categoria != null
                              ? Color(categoria.cor)
                              : Colors.grey)
                          .withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  categoriaIcon,
                  color: categoria != null ? Color(categoria.cor) : Colors.grey,
                ),
              ),
              title: Text(
                transacao.descricao,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(categoria?.nome ?? 'Categoria não encontrada'),
                  Text(
                    '${transacao.data.day.toString().padLeft(2, '0')}/'
                    '${transacao.data.month.toString().padLeft(2, '0')}/'
                    '${transacao.data.year}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icone, color: cor, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'R\$ ${transacao.valor.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: cor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _mostrarOpcoesTransacao(Transacao transacao) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text('Editar'),
              onTap: () {
                Navigator.pop(context);
                _editarTransacao(transacao);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Excluir'),
              onTap: () {
                Navigator.pop(context);
                _confirmarExclusao(transacao);
              },
            ),
            if (transacao.observacoes != null &&
                transacao.observacoes!.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.note, color: Colors.grey),
                title: const Text('Observações'),
                subtitle: Text(transacao.observacoes!),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _editarTransacao(Transacao transacao) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTransactionPage(transacao: transacao),
      ),
    );

    if (resultado == true) {
      setState(() {});
    }
  }

  void _confirmarExclusao(Transacao transacao) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja excluir a transação "${transacao.descricao}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<AppState>(
                context,
                listen: false,
              ).removerTransacao(transacao.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Transação excluída')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  void _mostrarFiltros() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Filtros e Ordenação',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    children: [
                      // Filtro por categoria
                      Consumer<AppState>(
                        builder: (context, appState, child) {
                          return DropdownButtonFormField<String>(
                            initialValue: _filtroCategoria.isEmpty
                                ? null
                                : _filtroCategoria,
                            decoration: const InputDecoration(
                              labelText: 'Filtrar por Categoria',
                              border: OutlineInputBorder(),
                            ),
                            items: [
                              const DropdownMenuItem<String>(
                                value: null,
                                child: Text('Todas as categorias'),
                              ),
                              ...appState.categorias.map((categoria) {
                                return DropdownMenuItem<String>(
                                  value: categoria.id,
                                  child: Text(categoria.nome),
                                );
                              }),
                            ],
                            onChanged: (valor) {
                              setState(() {
                                _filtroCategoria = valor ?? '';
                              });
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Ordenação
                      DropdownButtonFormField<String>(
                        initialValue: _ordenacao,
                        decoration: const InputDecoration(
                          labelText: 'Ordenar por',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'data_desc',
                            child: Text('Data (mais recente)'),
                          ),
                          DropdownMenuItem(
                            value: 'data_asc',
                            child: Text('Data (mais antiga)'),
                          ),
                          DropdownMenuItem(
                            value: 'valor_desc',
                            child: Text('Valor (maior)'),
                          ),
                          DropdownMenuItem(
                            value: 'valor_asc',
                            child: Text('Valor (menor)'),
                          ),
                        ],
                        onChanged: (valor) {
                          setState(() {
                            _ordenacao = valor!;
                          });
                        },
                      ),
                      const SizedBox(height: 24),

                      // Botões de ação
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _filtroCategoria = '';
                                  _filtroDataInicio = null;
                                  _filtroDataFim = null;
                                  _ordenacao = 'data_desc';
                                });
                                Navigator.pop(context);
                              },
                              child: const Text('Limpar Filtros'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Aplicar'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTransactionsList(
    List<Transacao> transacoes,
    List<Categoria> categorias,
  ) {
    if (transacoes.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Nenhuma transação encontrada',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: transacoes.length,
      itemBuilder: (context, index) {
        final transacao = transacoes[index];
        final categoria =
            categorias.where((c) => c.id == transacao.categoriaId).firstOrNull;

        return _buildTransactionCard(transacao, categoria);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Transações'),
            backgroundColor: Colors.transparent,
            foregroundColor: colorScheme.onPrimary,
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary,
                    colorScheme.primary.withValues(alpha: 0.8),
                    colorScheme.secondary.withValues(alpha: 0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: colorScheme.onPrimary,
              indicatorWeight: 3,
              labelColor: colorScheme.onPrimary,
              unselectedLabelColor: colorScheme.onPrimary.withValues(
                alpha: 0.7,
              ),
              labelStyle: const TextStyle(fontWeight: FontWeight.w600),
              tabs: const [
                Tab(text: 'Todas'),
                Tab(text: 'Receitas'),
                Tab(text: 'Despesas'),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: _mostrarFiltros,
              ),
              // Botão Premium para registros em massa
              Consumer<PremiumService>(
                builder: (context, premiumService, child) {
                  return IconButton(
                    icon: Icon(
                      Icons.workspace_premium,
                      color:
                          premiumService.isPro ? Colors.amber : Colors.white70,
                    ),
                    onPressed: () {
                      if (premiumService.isPro) {
                        // usar navigator global
                        appNavigatorKey.currentState?.pushNamed(
                          '/bulk-transactions',
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PremiumFeatureAccessPage(
                              featureName: 'Registros em Massa',
                              featureDescription:
                                  'Adicione múltiplas transações de forma visual e organizada',
                              featureIcon: Icons.grid_view,
                              onAccessGranted: () {
                                // usar navigator global aqui também
                                appNavigatorKey.currentState?.pushNamed(
                                  '/bulk-transactions',
                                );
                              },
                            ),
                          ),
                        );
                      }
                    },
                    tooltip: premiumService.isPro
                        ? 'Registros em Massa (Premium)'
                        : 'Upgrade para Premium',
                  );
                },
              ),
            ],
          ),
          body: Consumer<AppState>(
            builder: (context, appState, child) {
              return TabBarView(
                controller: _tabController,
                children: [
                  // Todas as transações
                  Column(
                    children: [
                      Expanded(
                        child: _buildTransactionsList(
                          _filtrarTransacoes(appState.transacoes, null),
                          appState.categorias,
                        ),
                      ),
                      const SmartAdBannerWidget(debugLabel: 'todas'),
                    ],
                  ),
                  // Receitas
                  Column(
                    children: [
                      Expanded(
                        child: _buildTransactionsList(
                          _filtrarTransacoes(
                            appState.transacoes,
                            TipoTransacao.receita,
                          ),
                          appState.categorias,
                        ),
                      ),
                      const SmartAdBannerWidget(debugLabel: 'receitas'),
                    ],
                  ),
                  // Despesas
                  Column(
                    children: [
                      Expanded(
                        child: _buildTransactionsList(
                          _filtrarTransacoes(
                            appState.transacoes,
                            TipoTransacao.despesa,
                          ),
                          appState.categorias,
                        ),
                      ),
                      const SmartAdBannerWidget(debugLabel: 'despesas'),
                    ],
                  ),
                ],
              );
            },
          ),
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Botão Premium para registros em massa
              Consumer<PremiumService>(
                builder: (context, premiumService, child) {
                  if (premiumService.isPro) {
                    return FloatingActionButton.small(
                      onPressed: () {
                        appNavigatorKey.currentState?.pushNamed(
                          '/bulk-transactions',
                        );
                      },
                      backgroundColor: Colors.amber,
                      heroTag: "bulk",
                      tooltip: 'Registros em Massa',
                      child: Icon(
                        Icons.workspace_premium,
                        color: colorScheme.onPrimary,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 8),
              // Botão principal com gradiente
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.primary.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: FloatingActionButton(
                  onPressed: () async {
                    final resultado = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddTransactionPage(),
                      ),
                    );

                    if (resultado == true) {
                      setState(() {});
                    }
                  },
                  backgroundColor:
                      Colors.transparent, // Transparente para mostrar gradiente
                  elevation: 0, // Remove sombra padrão
                  heroTag: "add",
                  child: Icon(Icons.add, color: colorScheme.onPrimary),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
