import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gastos_manager/models/orcamento.dart';
import 'package:gastos_manager/models/category.dart';
import '../services/app_state.dart';
import '../services/theme_service.dart';
import '../widgets/smart_ad_banner_widget.dart';

class BudgetsPage extends StatefulWidget {
  const BudgetsPage({super.key});

  @override
  State<BudgetsPage> createState() => _BudgetsPageState();
}

class _BudgetsPageState extends State<BudgetsPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _valorController = TextEditingController();

  DateTime _dataInicio = DateTime.now();
  DateTime _dataFim = DateTime.now().add(const Duration(days: 30));
  Categoria? _categoriaSelecionada;
  double _porcentagemAlerta = 0.8;

  @override
  void dispose() {
    _nomeController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  void _mostrarDialogOrcamento({Orcamento? orcamento}) {
    // Reset ou preencher valores
    if (orcamento != null) {
      _nomeController.text = orcamento.nome;
      _valorController.text = orcamento.valorLimite.toStringAsFixed(2);
      _dataInicio = orcamento.dataInicio;
      _dataFim = orcamento.dataFim;
      _porcentagemAlerta = orcamento.porcentagemAlerta ?? 0.8;

      // Buscar categoria
      final appState = Provider.of<AppState>(context, listen: false);
      _categoriaSelecionada = orcamento.categoriaId != null
          ? appState.categorias
                .where((c) => c.id == orcamento.categoriaId)
                .firstOrNull
          : null;
    } else {
      _nomeController.clear();
      _valorController.clear();
      _dataInicio = DateTime.now();
      _dataFim = DateTime.now().add(const Duration(days: 30));
      _categoriaSelecionada = null;
      _porcentagemAlerta = 0.8;
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            orcamento == null ? 'Novo Orçamento' : 'Editar Orçamento',
          ),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Nome do orçamento
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome do Orçamento',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Digite um nome para o orçamento';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Valor limite
                  TextFormField(
                    controller: _valorController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Valor Limite (R\$)',
                      border: OutlineInputBorder(),
                      prefixText: 'R\$ ',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Digite um valor limite';
                      }
                      final valor = double.tryParse(value.replaceAll(',', '.'));
                      if (valor == null || valor <= 0) {
                        return 'Digite um valor válido maior que zero';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Categoria (opcional)
                  Consumer<AppState>(
                    builder: (context, appState, child) {
                      return DropdownButtonFormField<Categoria>(
                        initialValue: _categoriaSelecionada,
                        decoration: const InputDecoration(
                          labelText: 'Categoria (Opcional)',
                          border: OutlineInputBorder(),
                          helperText: 'Deixe vazio para orçamento geral',
                        ),
                        items: [
                          const DropdownMenuItem<Categoria>(
                            value: null,
                            child: Text('Orçamento Geral'),
                          ),
                          ...appState.categorias.map((categoria) {
                            return DropdownMenuItem(
                              value: categoria,
                              child: Row(
                                children: [
                                  Text(
                                    categoria.icone,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(categoria.nome),
                                ],
                              ),
                            );
                          }),
                        ],
                        onChanged: (categoria) {
                          setDialogState(() {
                            _categoriaSelecionada = categoria;
                          });
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Data de início
                  InkWell(
                    onTap: () async {
                      final data = await showDatePicker(
                        context: context,
                        initialDate: _dataInicio,
                        firstDate: DateTime.now().subtract(
                          const Duration(days: 365),
                        ),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (data != null) {
                        setDialogState(() {
                          _dataInicio = data;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Data de Início',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  '${_dataInicio.day.toString().padLeft(2, '0')}/'
                                  '${_dataInicio.month.toString().padLeft(2, '0')}/'
                                  '${_dataInicio.year}',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Data de fim
                  InkWell(
                    onTap: () async {
                      final data = await showDatePicker(
                        context: context,
                        initialDate: _dataFim,
                        firstDate: _dataInicio,
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (data != null) {
                        setDialogState(() {
                          _dataFim = data;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Data de Fim',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  '${_dataFim.day.toString().padLeft(2, '0')}/'
                                  '${_dataFim.month.toString().padLeft(2, '0')}/'
                                  '${_dataFim.year}',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Porcentagem de alerta
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Alerta em ${(_porcentagemAlerta * 100).toInt()}% do limite',
                      ),
                      Slider(
                        value: _porcentagemAlerta,
                        min: 0.5,
                        max: 0.95,
                        divisions: 9,
                        label: '${(_porcentagemAlerta * 100).toInt()}%',
                        onChanged: (value) {
                          setDialogState(() {
                            _porcentagemAlerta = value;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final appState = Provider.of<AppState>(
                    context,
                    listen: false,
                  );
                  final valor = double.parse(
                    _valorController.text.replaceAll(',', '.'),
                  );

                  if (orcamento == null) {
                    // Criar novo orçamento
                    final novoOrcamento = Orcamento(
                      nome: _nomeController.text.trim(),
                      valorLimite: valor,
                      dataInicio: _dataInicio,
                      dataFim: _dataFim,
                      categoriaId: _categoriaSelecionada?.id,
                      porcentagemAlerta: _porcentagemAlerta,
                    );
                    appState.adicionarOrcamento(novoOrcamento);
                  } else {
                    // Atualizar orçamento existente
                    final orcamentoAtualizado = orcamento.copyWith(
                      nome: _nomeController.text.trim(),
                      valorLimite: valor,
                      dataInicio: _dataInicio,
                      dataFim: _dataFim,
                      categoriaId: _categoriaSelecionada?.id,
                      porcentagemAlerta: _porcentagemAlerta,
                    );
                    appState.atualizarOrcamento(orcamentoAtualizado);
                  }

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        orcamento == null
                            ? 'Orçamento criado com sucesso!'
                            : 'Orçamento atualizado com sucesso!',
                      ),
                    ),
                  );
                }
              },
              child: Text(orcamento == null ? 'Criar' : 'Atualizar'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmarExclusao(Orcamento orcamento) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja excluir o orçamento "${orcamento.nome}"?'),
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
              ).removerOrcamento(orcamento.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Orçamento excluído')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrcamentoCard(
    Orcamento orcamento,
    AppState appState,
    bool isDark,
  ) {
    // Calcular gastos do orçamento
    double gastoTotal = 0.0;

    final transacoesPeriodo = appState.transacoes.where((t) {
      return t.data.isAfter(orcamento.dataInicio) &&
          t.data.isBefore(orcamento.dataFim.add(const Duration(days: 1))) &&
          t.tipo.name == 'despesa';
    });

    if (orcamento.categoriaId != null) {
      gastoTotal = transacoesPeriodo
          .where((t) => t.categoriaId == orcamento.categoriaId)
          .fold(0.0, (sum, t) => sum + t.valor);
    } else {
      gastoTotal = transacoesPeriodo.fold(0.0, (sum, t) => sum + t.valor);
    }

    final porcentagemUsada = orcamento.calcularPorcentagemUsada(gastoTotal);
    final valorRestante = orcamento.valorLimite - gastoTotal;
    final categoria = orcamento.categoriaId != null
        ? appState.getCategoriaById(orcamento.categoriaId!)
        : null;

    // Determinar cor baseada no uso
    Color corStatus = Colors.green;
    if (porcentagemUsada >= 0.8) {
      corStatus = Colors.red;
    } else if (porcentagemUsada >= 0.6) {
      corStatus = Colors.orange;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _mostrarDialogOrcamento(orcamento: orcamento),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (categoria != null) ...[
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(
                                        categoria.cor,
                                      ).withValues(alpha: 0.2),
                                      Color(
                                        categoria.cor,
                                      ).withValues(alpha: 0.1),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  categoria.icone,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            Expanded(
                              child: Text(
                                orcamento.nome,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (categoria != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Text(
                              categoria.nome,
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white70
                                    : Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'editar':
                          _mostrarDialogOrcamento(orcamento: orcamento);
                          break;
                        case 'excluir':
                          _confirmarExclusao(orcamento);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'editar',
                        child: ListTile(
                          leading: Icon(Icons.edit, size: 20),
                          title: Text('Editar'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'excluir',
                        child: ListTile(
                          leading: Icon(
                            Icons.delete,
                            size: 20,
                            color: Colors.red,
                          ),
                          title: Text(
                            'Excluir',
                            style: TextStyle(color: Colors.red),
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Barra de progresso animada
              Container(
                height: 12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: porcentagemUsada.clamp(0.0, 1.0),
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(corStatus),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Informações do orçamento
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gasto',
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'R\$ ${gastoTotal.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: corStatus,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Limite',
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'R\$ ${orcamento.valorLimite.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: corStatus.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: corStatus.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '${(porcentagemUsada * 100).toStringAsFixed(1)}% usado',
                      style: TextStyle(
                        color: corStatus,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    valorRestante >= 0
                        ? 'Restam: R\$ ${valorRestante.toStringAsFixed(2)}'
                        : 'Excedeu em: R\$ ${(-valorRestante).toStringAsFixed(2)}',
                    style: TextStyle(
                      color: valorRestante >= 0 ? Colors.green : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Período
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${orcamento.dataInicio.day}/${orcamento.dataInicio.month}/${orcamento.dataInicio.year} - ${orcamento.dataFim.day}/${orcamento.dataFim.month}/${orcamento.dataFim.year}',
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppState, ThemeService>(
      builder: (context, appState, themeService, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.8),
                    Theme.of(
                      context,
                    ).colorScheme.secondary.withValues(alpha: 0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            title: Text(
              'Orçamentos',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: appState.orcamentos.isEmpty
                    ? _buildEmptyState(isDark)
                    : ListView.builder(
                        itemCount: appState.orcamentos.length,
                        itemBuilder: (context, index) {
                          final orcamento = appState.orcamentos[index];
                          return _buildOrcamentoCard(
                            orcamento,
                            appState,
                            isDark,
                          );
                        },
                      ),
              ),
              const SmartAdBannerWidget(debugLabel: 'budgets'),
            ],
          ),
          floatingActionButton: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(
                    context,
                  ).colorScheme.secondary.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: FloatingActionButton(
              onPressed: () => _mostrarDialogOrcamento(),
              backgroundColor: Colors.transparent,
              elevation: 0,
              heroTag: "budgets_add_fab",
              child: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 28,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 80,
            color: isDark ? Colors.white54 : Colors.grey,
          ),
          const SizedBox(height: 24),
          Text(
            'Nenhum orçamento criado',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Crie orçamentos para controlar\nseus gastos e atingir suas metas',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white54 : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _mostrarDialogOrcamento(),
            icon: const Icon(Icons.add),
            label: const Text('Criar Orçamento'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
