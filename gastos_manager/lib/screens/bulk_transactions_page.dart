import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../models/transaction.dart';
import '../services/app_state.dart';
import '../services/smart_interstitial_service.dart';

class BulkTransactionsPage extends StatefulWidget {
  const BulkTransactionsPage({super.key});

  @override
  State<BulkTransactionsPage> createState() => _BulkTransactionsPageState();
}

class _BulkTransactionsPageState extends State<BulkTransactionsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // Lista de transações em edição
  List<Map<String, dynamic>> _transacoesPendentes = [];

  // Controladores para adicionar múltiplas transações
  final List<TransactionFormData> _formsData = [];

  // Templates salvos pelo usuário
  final List<Map<String, dynamic>> _templatesSalvos = [];

  bool _adicionarDesbloqueado = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _adicionarNovoFormulario();
    _adicionarDesbloqueado = false;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _limparFormularios();
    super.dispose();
  }

  void _limparFormularios() {
    for (var form in _formsData) {
      form.dispose();
    }
    _formsData.clear();
  }

  void _adicionarNovoFormulario() {
    setState(() {
      _formsData.add(TransactionFormData());
    });
  }

  void _removerFormulario(int index) {
    if (_formsData.length > 1) {
      setState(() {
        _formsData[index].dispose();
        _formsData.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transações em Massa'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Adicionar', icon: Icon(Icons.add)),
            Tab(text: 'Importar CSV', icon: Icon(Icons.file_upload)),
            Tab(text: 'Revisar', icon: Icon(Icons.checklist)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAdicionarTab(),
          _buildImportarTab(),
          _buildRevisarTab(),
        ],
      ),
    );
  }

  Widget _buildAdicionarTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Adicionar Múltiplas Transações',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (!_adicionarDesbloqueado)
            RewardedAdButton(
              text: 'Desbloquear Adição em Massa',
              icon: Icons.lock_open,
              onRewarded: () {
                setState(() {
                  _adicionarDesbloqueado = true;
                });
              },
              rewardMessage:
                  'Assista ao anúncio para liberar a função de adicionar em massa!',
            ),
          if (_adicionarDesbloqueado) ...[
            ..._formsData.asMap().entries.map((entry) {
              final index = entry.key;
              final formData = entry.value;
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Transação ${index + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          if (_formsData.length > 1)
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removerFormulario(index),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: formData.descricaoController,
                        decoration: const InputDecoration(
                          labelText: 'Descrição',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: formData.valorController,
                        decoration: const InputDecoration(
                          labelText: 'Valor',
                          border: OutlineInputBorder(),
                          prefixText: 'R\$ ',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: formData.tipo,
                        decoration: const InputDecoration(
                          labelText: 'Tipo',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'receita',
                            child: Text('Receita'),
                          ),
                          DropdownMenuItem(
                            value: 'despesa',
                            child: Text('Despesa'),
                          ),
                        ],
                        onChanged: (value) =>
                            setState(() => formData.tipo = value),
                      ),
                      const SizedBox(height: 16),
                      Consumer<AppState>(
                        builder: (context, appState, child) {
                          return DropdownButtonFormField<String>(
                            initialValue: formData.categoriaId,
                            decoration: const InputDecoration(
                              labelText: 'Categoria',
                              border: OutlineInputBorder(),
                            ),
                            items: appState.categorias.map((categoria) {
                              return DropdownMenuItem(
                                value: categoria.id,
                                child: Text(categoria.nome),
                              );
                            }).toList(),
                            onChanged: (value) =>
                                setState(() => formData.categoriaId = value),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _adicionarNovoFormulario,
                    icon: const Icon(Icons.add),
                    label: const Text('Adicionar Transação'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _formsData.any((form) => form.isValid)
                        ? _salvarTransacoes
                        : null,
                    icon: const Icon(Icons.save),
                    label: const Text('Salvar Todas'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImportarTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Importar Transações do CSV',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Formato esperado do CSV:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'descricao,valor,tipo,categoria\n'
                    'Exemplo: "Compra mercado",150.50,despesa,"Alimentação"',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _importarCSV,
                    icon: const Icon(Icons.file_upload),
                    label: const Text('Selecionar Arquivo CSV'),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: _mostrarAjudaCSV,
                    icon: const Icon(Icons.help),
                    label: const Text('Ajuda com Formato CSV'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevisarTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Revisar Transações',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (_templatesSalvos.isNotEmpty) ...[
            const Text(
              'Templates Salvos:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ..._templatesSalvos.map(
              (template) => Card(
                child: ListTile(
                  leading: Icon(
                    template['icone'] ?? Icons.description,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(template['nome'] ?? 'Template'),
                  subtitle: Text(
                    '${template['transacoes']?.length ?? 0} transações',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removerTemplate(template),
                  ),
                  onTap: () => _carregarTemplate(template),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _importarCSV() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        String contents = await file.readAsString();

        List<Map<String, dynamic>> transacoes = _parseCSV(contents);

        setState(() {
          _transacoesPendentes = transacoes;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${transacoes.length} transações importadas')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro ao importar arquivo')));
    }
  }

  void _mostrarAjudaCSV() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Formato CSV'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('O arquivo CSV deve ter as seguintes colunas:'),
              SizedBox(height: 8),
              Text('• descricao (obrigatório)'),
              Text('• valor (obrigatório, formato: 123.45)'),
              Text('• tipo (obrigatório: "receita" ou "despesa")'),
              Text('• categoria (opcional, nome da categoria)'),
              SizedBox(height: 16),
              Text('Exemplo:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('"Compra mercado",150.50,"despesa","Alimentação"'),
              Text('"Salário",3000.00,"receita","Salário"'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _parseCSV(String csvContent) {
    List<String> lines = csvContent.split('\n');
    List<Map<String, dynamic>> transacoes = [];

    for (int i = 1; i < lines.length; i++) {
      String line = lines[i].trim();
      if (line.isEmpty) continue;

      List<String> fields = _parseCSVLine(line);
      if (fields.length >= 3) {
        transacoes.add({
          'descricao': fields[0].replaceAll('"', ''),
          'valor': double.tryParse(fields[1].replaceAll(',', '.')) ?? 0.0,
          'tipo': fields[2].replaceAll('"', ''),
          'categoriaId': fields.length > 3
              ? fields[3].replaceAll('"', '')
              : null,
        });
      }
    }

    return transacoes;
  }

  List<String> _parseCSVLine(String line) {
    List<String> fields = [];
    bool inQuotes = false;
    String currentField = '';

    for (int i = 0; i < line.length; i++) {
      String char = line[i];

      if (char == '"') {
        inQuotes = !inQuotes;
      } else if (char == ',' && !inQuotes) {
        fields.add(currentField);
        currentField = '';
      } else {
        currentField += char;
      }
    }

    fields.add(currentField);
    return fields;
  }

  void _salvarTransacoes() {
    final transacoes = _formsData.map((form) {
      return {
        'descricao': form.descricaoController.text,
        'valor':
            double.tryParse(form.valorController.text.replaceAll(',', '.')) ??
            0.0,
        'tipo': form.tipo,
        'categoriaId': form.categoriaId,
      };
    }).toList();

    _salvarTransacoesLista(transacoes);
  }

  void _salvarTransacoesLista(List<Map<String, dynamic>> transacoes) {
    final appState = Provider.of<AppState>(context, listen: false);

    for (var transacaoData in transacoes) {
      final categoria = appState.getCategoriaById(transacaoData['categoriaId']);
      if (categoria != null) {
        final tipoTransacao = transacaoData['tipo'] == 'receita'
            ? TipoTransacao.receita
            : TipoTransacao.despesa;

        final transacao = Transacao.fromPortuguese(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          descricao: transacaoData['descricao'],
          valor: transacaoData['valor'],
          tipo: tipoTransacao,
          categoriaId: categoria.id,
          data: DateTime.now(),
        );

        appState.adicionarTransacao(transacao);
      }
    }

    setState(() {
      _transacoesPendentes.clear();
      _limparFormularios();
      _adicionarNovoFormulario();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${transacoes.length} transações salvas com sucesso!'),
      ),
    );
  }

  void _removerTemplate(Map<String, dynamic> template) {
    setState(() {
      _templatesSalvos.remove(template);
    });
  }

  void _carregarTemplate(Map<String, dynamic> template) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Carregar Template'),
        content: Text(
          'Carregar template "${template['nome']}" com ${template['transacoes']?.length ?? 0} transações?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implementar carregamento do template
              Navigator.of(context).pop();
            },
            child: const Text('Carregar'),
          ),
        ],
      ),
    );
  }
}

class TransactionFormData {
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController valorController = TextEditingController();
  String? tipo;
  String? categoriaId;

  bool get isValid {
    return descricaoController.text.trim().isNotEmpty &&
        valorController.text.trim().isNotEmpty &&
        tipo != null &&
        categoriaId != null;
  }

  void dispose() {
    descricaoController.dispose();
    valorController.dispose();
  }
}
