import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../services/app_state.dart';
import '../services/theme_service.dart';
import '../services/premium_service.dart';
import '../services/ad_integration_service.dart';
import '../services/streak_service.dart';

// Mapa de ícones do Material Design por string
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

class AddTransactionPage extends StatefulWidget {
  final Transacao? transacao; // Para edição

  const AddTransactionPage({super.key, this.transacao});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();
  final _observacoesController = TextEditingController();

  DateTime _dataSelecionada = DateTime.now();
  TipoTransacao _tipo = TipoTransacao.despesa;
  Categoria? _categoriaSelecionada;
  bool _isLoading = false;
  bool _isRecorrente = false;
  RecurringType? _tipoRecorrencia;

  @override
  void initState() {
    super.initState();

    // Se estamos editando uma transação
    if (widget.transacao != null) {
      final transacao = widget.transacao!;
      _descricaoController.text = transacao.descricao;
      _valorController.text = transacao.valor.toStringAsFixed(2);
      _observacoesController.text = transacao.observacoes ?? '';
      _dataSelecionada = transacao.data;
      _tipo = transacao.tipo;
      _isRecorrente = transacao.recorrente;
      _tipoRecorrencia = transacao.recurringType;

      // Buscar categoria pela ID
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final appState = Provider.of<AppState>(context, listen: false);
        _categoriaSelecionada = appState.getCategoriaById(
          transacao.categoriaId,
        );
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _valorController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('pt', 'BR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(
            context,
          ).copyWith(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
          child: child!,
        );
      },
    );

    if (data != null) {
      setState(() {
        _dataSelecionada = data;
      });
    }
  }

  int? _getFrequencyDays(RecurringType type) {
    switch (type) {
      case RecurringType.daily:
        return 1;
      case RecurringType.weekly:
        return 7;
      case RecurringType.monthly:
        return 30;
      case RecurringType.yearly:
        return 365;
    }
  }

  Future<void> _salvarTransacao() async {
    if (!_formKey.currentState!.validate()) return;
    if (_categoriaSelecionada == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Selecione uma categoria')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final appState = Provider.of<AppState>(context, listen: false);
      final valor = double.parse(_valorController.text.replaceAll(',', '.'));

      final transacao = Transacao.fromPortuguese(
        id: widget.transacao?.id,
        descricao: _descricaoController.text.trim(),
        valor: valor,
        tipo: _tipo,
        categoriaId: _categoriaSelecionada!.id,
        data: _dataSelecionada,
        observacoes: _observacoesController.text.trim().isEmpty
            ? null
            : _observacoesController.text.trim(),
        recorrente: _isRecorrente,
        frequenciaDias: _tipoRecorrencia != null
            ? _getFrequencyDays(_tipoRecorrencia!)
            : null,
      ).copyWith(recurringType: _isRecorrente ? _tipoRecorrencia : null);

      if (widget.transacao == null) {
        appState.adicionarTransacao(transacao);

        // Registrar atividade no streak
        final streakService = Provider.of<StreakService>(
          context,
          listen: false,
        );
        streakService.recordActivity();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transação adicionada com sucesso!')),
        );
      } else {
        appState.atualizarTransacao(transacao);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transação atualizada com sucesso!')),
        );
      }

      Navigator.of(context).pop(true);

      // Registrar ação e mostrar anúncio intersticial otimizado para usuários não premium
      final premiumService = Provider.of<PremiumService>(
        context,
        listen: false,
      );
      if (!premiumService.isPremium && mounted) {
        // Registrar ação de salvar transação no sistema de otimização
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            AdIntegrationService().registerUserAction(
              context,
              'save_transaction',
            );
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro: ${e.toString()}')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildTipoSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _tipo = TipoTransacao.receita),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _tipo == TipoTransacao.receita
                      ? Colors.green
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      color: _tipo == TipoTransacao.receita
                          ? Colors.white
                          : Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Receita',
                      style: TextStyle(
                        color: _tipo == TipoTransacao.receita
                            ? Colors.white
                            : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _tipo = TipoTransacao.despesa),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _tipo == TipoTransacao.despesa
                      ? Colors.red
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_downward,
                      color: _tipo == TipoTransacao.despesa
                          ? Colors.white
                          : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Despesa',
                      style: TextStyle(
                        color: _tipo == TipoTransacao.despesa
                            ? Colors.white
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.transacao == null ? 'Nova Transação' : 'Editar Transação',
            ),
            backgroundColor: themeService.accentColor,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Seletor de Tipo
                  const Text(
                    'Tipo de Transação',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildTipoSelector(),
                  const SizedBox(height: 24),

                  // Descrição
                  TextFormField(
                    controller: _descricaoController,
                    decoration: InputDecoration(
                      labelText: 'Descrição',
                      hintText: 'Ex: Compras no supermercado',
                      prefixIcon: const Icon(Icons.description),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Digite uma descrição';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Valor
                  TextFormField(
                    controller: _valorController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Valor',
                      hintText: '0,00',
                      prefixIcon: const Icon(Icons.attach_money),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Digite um valor';
                      }
                      final valor = double.tryParse(value.replaceAll(',', '.'));
                      if (valor == null || valor <= 0) {
                        return 'Digite um valor válido maior que zero';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Data
                  InkWell(
                    onTap: _selecionarData,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.grey),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Data',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  '${_dataSelecionada.day.toString().padLeft(2, '0')}/'
                                  '${_dataSelecionada.month.toString().padLeft(2, '0')}/'
                                  '${_dataSelecionada.year}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Categoria
                  Consumer<AppState>(
                    builder: (context, appState, child) {
                      final categorias = appState.getCategoriasMaisUsadas();

                      // Se não há categorias, mostrar mensagem e botão para criar
                      if (categorias.isEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Categoria *',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.category_outlined,
                                    size: 32,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Nenhuma categoria criada',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Crie uma categoria para organizar suas transações',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 12),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/categories',
                                      );
                                    },
                                    icon: const Icon(Icons.add),
                                    label: const Text('Criar Categoria'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }

                      return DropdownButtonFormField<Categoria>(
                        initialValue: _categoriaSelecionada,
                        decoration: InputDecoration(
                          labelText: 'Categoria',
                          prefixIcon: const Icon(Icons.category),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: categorias.map((categoria) {
                          IconData iconData =
                              _iconMap[categoria.icon] ?? Icons.category;

                          return DropdownMenuItem(
                            value: categoria,
                            child: Row(
                              children: [
                                Icon(
                                  iconData,
                                  color: categoria.color,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(categoria.name),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (categoria) {
                          setState(() {
                            _categoriaSelecionada = categoria;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Selecione uma categoria';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Observações
                  TextFormField(
                    controller: _observacoesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Observações (opcional)',
                      hintText: 'Informações adicionais...',
                      prefixIcon: const Icon(Icons.note),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Transação Recorrente
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Transação Recorrente',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text(
                              'Esta é uma transação recorrente',
                            ),
                            subtitle: const Text(
                              'A transação se repetirá automaticamente',
                            ),
                            value: _isRecorrente,
                            onChanged: (value) {
                              setState(() {
                                _isRecorrente = value ?? false;
                                if (!_isRecorrente) {
                                  _tipoRecorrencia = null;
                                }
                              });
                            },
                          ),
                          if (_isRecorrente) ...[
                            const SizedBox(height: 8),
                            DropdownButtonFormField<RecurringType>(
                              initialValue: _tipoRecorrencia,
                              decoration: InputDecoration(
                                labelText: 'Frequência',
                                prefixIcon: const Icon(Icons.repeat),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: RecurringType.daily,
                                  child: Text('Diário'),
                                ),
                                DropdownMenuItem(
                                  value: RecurringType.weekly,
                                  child: Text('Semanal'),
                                ),
                                DropdownMenuItem(
                                  value: RecurringType.monthly,
                                  child: Text('Mensal'),
                                ),
                                DropdownMenuItem(
                                  value: RecurringType.yearly,
                                  child: Text('Anual'),
                                ),
                              ],
                              onChanged: (type) {
                                setState(() {
                                  _tipoRecorrencia = type;
                                });
                              },
                              validator: (value) {
                                if (_isRecorrente && value == null) {
                                  return 'Selecione a frequência';
                                }
                                return null;
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Botão Salvar
                  ElevatedButton(
                    onPressed: _isLoading ? null : _salvarTransacao,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeService.accentColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            widget.transacao == null
                                ? 'ADICIONAR'
                                : 'ATUALIZAR',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
