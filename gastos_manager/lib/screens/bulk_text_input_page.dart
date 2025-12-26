import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../services/app_state.dart';
import '../services/theme_service.dart';
import '../services/premium_service.dart';
import '../services/firebase_service.dart';
import '../utils/design_system.dart';

class BulkTextInputPage extends StatefulWidget {
  const BulkTextInputPage({super.key});

  @override
  State<BulkTextInputPage> createState() => _BulkTextInputPageState();
}

class _BulkTextInputPageState extends State<BulkTextInputPage> {
  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  List<ParsedTransaction> _parsedTransactions = [];
  bool _showPreview = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer4<ThemeService, PremiumService, AppState, FirebaseService>(
      builder: (context, themeService, premiumService, appState, firebaseService, child) {
        return Scaffold(
          backgroundColor: Colors.transparent,
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
            title: const Text('Adicionar em Massa por Texto'),
            actions: [
              if (_showPreview && _parsedTransactions.isNotEmpty)
                TextButton(
                  onPressed: _saveTransactions,
                  child: const Text(
                    'Salvar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          body: DesignSystem.buildAnimatedBackground(
            baseColor: themeService.accentColor,
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Instruções
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.lightbulb,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Como usar:',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Digite suas transações em texto natural, uma por linha:\n\n'
                              '• menos 500 de aluguel\n'
                              '• mais 1800 de salario\n'
                              '• menos 400 de alimentação\n'
                              '• menos 150 de transporte\n\n'
                              'Use "menos" para despesas e "mais" para receitas.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Campo de texto
                      const Text(
                        'Digite suas transações:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                        ),
                        child: TextFormField(
                          controller: _textController,
                          maxLines: 8,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText:
                                'Exemplo: menos 500 de aluguel, mais 1800 de salario, menos 400 de alimentação',
                            hintStyle: TextStyle(
                              color: Colors.black.withValues(alpha: 0.4),
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(16),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Digite pelo menos uma transação';
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Botão de análise
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _analyzeText,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.2,
                            ),
                            foregroundColor: Colors.white,
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
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.analytics),
                                    SizedBox(width: 8),
                                    Text(
                                      'Analisar Texto',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),

                      // Preview das transações
                      if (_showPreview && _parsedTransactions.isNotEmpty) ...[
                        const SizedBox(height: 32),
                        const Text(
                          'Transações encontradas:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),

                        ..._parsedTransactions.asMap().entries.map((entry) {
                          final index = entry.key;
                          final parsed = entry.value;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: parsed.isValid
                                  ? Colors.white.withValues(alpha: 0.1)
                                  : Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: parsed.isValid
                                    ? Colors.white.withValues(alpha: 0.2)
                                    : Colors.red.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  parsed.type == TipoTransacao.despesa
                                      ? Icons.remove_circle
                                      : Icons.add_circle,
                                  color: parsed.type == TipoTransacao.despesa
                                      ? Colors.red
                                      : Colors.green,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'R\$ ${parsed.amount.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        parsed.categoryName,
                                        style: TextStyle(
                                          color: Colors.white.withValues(
                                            alpha: 0.7,
                                          ),
                                          fontSize: 14,
                                        ),
                                      ),
                                      if (!parsed.isValid)
                                        Text(
                                          parsed.errorMessage ??
                                              'Erro desconhecido',
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                // Botão de remover
                                IconButton(
                                  onPressed: () => _removeTransaction(index),
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                                if (parsed.isValid)
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 20,
                                  )
                                else
                                  const Icon(
                                    Icons.error,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                              ],
                            ),
                          );
                        }),

                        const SizedBox(height: 16),

                        Text(
                          '${_parsedTransactions.where((t) => t.isValid).length} transações válidas encontradas',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _analyzeText() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _parsedTransactions = _parseText(text);
      _showPreview = true;
    });
  }

  void _removeTransaction(int index) {
    setState(() {
      _parsedTransactions.removeAt(index);
    });
  }

  List<ParsedTransaction> _parseText(String text) {
    // Primeiro divide por vírgulas, depois por quebras de linha
    final commaSeparated = text.split(',');
    final allLines = <String>[];

    for (final part in commaSeparated) {
      // Para cada parte separada por vírgula, divide por quebras de linha
      final lines = part.split('\n');
      allLines.addAll(lines);
    }

    final parsedTransactions = <ParsedTransaction>[];

    for (final line in allLines) {
      final trimmedLine = line.trim();
      if (trimmedLine.isNotEmpty) {
        final parsed = _parseLine(trimmedLine);
        if (parsed != null) {
          parsedTransactions.add(parsed);
        }
      }
    }

    return parsedTransactions;
  }

  ParsedTransaction? _parseLine(String line) {
    // Padrões suportados:
    // "menos 500 de aluguel"
    // "mais 1800 de salario"
    // "-500 aluguel"
    // "+1800 salario"

    final lowerLine = line.toLowerCase();

    // Detectar tipo (menos = despesa, mais = receita)
    TipoTransacao? type;
    String remainingText;

    if (lowerLine.startsWith('menos ') || lowerLine.startsWith('-')) {
      type = TipoTransacao.despesa;
      remainingText = lowerLine
          .replaceFirst(RegExp(r'^menos\s+'), '')
          .replaceFirst(RegExp(r'^-'), '');
    } else if (lowerLine.startsWith('mais ') || lowerLine.startsWith('+')) {
      type = TipoTransacao.receita;
      remainingText = lowerLine
          .replaceFirst(RegExp(r'^mais\s+'), '')
          .replaceFirst(RegExp(r'^\+'), '');
    } else {
      // Tentar detectar pelo contexto
      if (lowerLine.contains('salario') ||
          lowerLine.contains('salário') ||
          lowerLine.contains('renda') ||
          lowerLine.contains('receita')) {
        type = TipoTransacao.receita;
      } else {
        type = TipoTransacao.despesa;
      }
      remainingText = lowerLine;
    }

    // Extrair valor
    final valueRegex = RegExp(r'(\d+(?:[,.]\d+)?)');
    final valueMatch = valueRegex.firstMatch(remainingText);

    if (valueMatch == null) {
      return ParsedTransaction.invalid('Valor não encontrado na linha: $line');
    }

    final valueStr = valueMatch.group(1)!.replaceAll(',', '.');
    final amount = double.tryParse(valueStr);

    if (amount == null) {
      return ParsedTransaction.invalid(
        'Valor inválido: ${valueMatch.group(1)}',
      );
    }

    // Extrair categoria (texto após "de" ou resto da linha)
    String categoryText;
    final deIndex = remainingText.toLowerCase().indexOf(' de ');
    if (deIndex != -1) {
      categoryText = remainingText.substring(deIndex + 4).trim();
    } else {
      // Remover o valor e pegar o resto
      categoryText = remainingText.replaceFirst(valueRegex, '').trim();
    }

    if (categoryText.isEmpty) {
      return ParsedTransaction.invalid(
        'Categoria não encontrada na linha: $line',
      );
    }

    // Mapear categoria
    final categoryId = _mapCategory(categoryText);

    return ParsedTransaction(
      amount: amount,
      type: type,
      categoryId: categoryId,
      categoryName: categoryText,
      originalText: line,
    );
  }

  String _mapCategory(String categoryText) {
    final lowerText = categoryText.toLowerCase();

    // Mapeamento de categorias baseado em palavras-chave para nomes de categoria
    final categoryMap = {
      // Alimentação
      'alimentacao': 'Alimentação',
      'alimentação': 'Alimentação',
      'comida': 'Alimentação',
      'restaurante': 'Alimentação',
      'lanche': 'Alimentação',

      // Transporte
      'transporte': 'Transporte',
      'gasolina': 'Transporte',
      'combustivel': 'Transporte',
      'combustível': 'Transporte',
      'uber': 'Transporte',
      'taxi': 'Transporte',
      'onibus': 'Transporte',
      'ônibus': 'Transporte',
      'metro': 'Transporte',

      // Moradia
      'aluguel': 'Moradia',
      'casa': 'Moradia',
      'apartamento': 'Moradia',
      'condominio': 'Moradia',
      'condomínio': 'Moradia',
      'iptu': 'Moradia',
      'luz': 'Moradia',
      'agua': 'Moradia',
      'água': 'Moradia',
      'internet': 'Moradia',
      'telefone': 'Moradia',

      // Saúde
      'saude': 'Saúde',
      'saúde': 'Saúde',
      'medico': 'Saúde',
      'médico': 'Saúde',
      'remedio': 'Saúde',
      'remédio': 'Saúde',
      'plano': 'Saúde',
      'odontologico': 'Saúde',
      'odontológico': 'Saúde',

      // Educação
      'educacao': 'Educação',
      'educação': 'Educação',
      'escola': 'Educação',
      'faculdade': 'Educação',
      'universidade': 'Educação',
      'curso': 'Educação',
      'livro': 'Educação',

      // Entretenimento
      'entretenimento': 'Entretenimento',
      'cinema': 'Entretenimento',
      'teatro': 'Entretenimento',
      'show': 'Entretenimento',
      'jogo': 'Entretenimento',
      'diversao': 'Entretenimento',
      'diversão': 'Entretenimento',

      // Compras
      'compra': 'Compras',
      'shopping': 'Compras',
      'roupa': 'Compras',
      'vestuario': 'Compras',
      'vestuário': 'Compras',

      // Salário
      'salario': 'Salário',
      'salário': 'Salário',
      'renda': 'Salário',
      'vencimento': 'Salário',
      'pagamento': 'Salário',

      // Freelance
      'freelance': 'Freelance',
      'freela': 'Freelance',
      'trabalho': 'Freelance',
      'servico': 'Freelance',
      'serviço': 'Freelance',

      // Investimentos
      'investimento': 'Investimentos',
      'acao': 'Investimentos',
      'ação': 'Investimentos',
      'fundo': 'Investimentos',
      'poupanca': 'Investimentos',
      'poupança': 'Investimentos',

      // Vendas
      'venda': 'Vendas',
      'produto': 'Vendas',
      'mercadoria': 'Vendas',
    };

    // Procurar correspondência exata primeiro
    String categoryName;
    if (categoryMap.containsKey(lowerText)) {
      categoryName = categoryMap[lowerText]!;
    } else {
      // Procurar correspondência parcial
      categoryName = 'Outros';
      for (final entry in categoryMap.entries) {
        if (lowerText.contains(entry.key)) {
          categoryName = entry.value;
          break;
        }
      }
    }

    // Retornar o nome da categoria para ser processado no _saveTransactions
    // onde será convertido para ID adequado
    return categoryName;
  }

  void _saveTransactions() async {
    if (_parsedTransactions.isEmpty) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final validTransactions = _parsedTransactions
        .where((t) => t.isValid)
        .toList();

    if (validTransactions.isEmpty) {
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Nenhuma transação válida para salvar'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final appState = Provider.of<AppState>(context, listen: false);
      final firebaseService = Provider.of<FirebaseService>(
        context,
        listen: false,
      );

      // Primeiro, vamos processar as categorias e criar IDs corretos
      final transacoesProcessadas = <Map<String, dynamic>>[];

      for (final parsed in validTransactions) {
        // Tentar encontrar categoria existente pelo nome
        CategoryModel? categoria = appState.categorias
            .cast<CategoryModel?>()
            .firstWhere(
              (cat) =>
                  cat?.name.toLowerCase() == parsed.categoryName.toLowerCase(),
              orElse: () => null,
            );

        // Se não encontrar, criar nova categoria
        if (categoria == null) {
          categoria = CategoryModel.create(
            name: parsed.categoryName,
            icon: '📝',
            color: Colors.grey,
            type: parsed.type == TipoTransacao.receita
                ? CategoryType.income
                : CategoryType.expense,
          );

          // Adicionar ao estado local
          appState.adicionarCategoria(categoria);
          // Salvar no Firestore apenas se estiver logado
          if (firebaseService.userId != null) {
            await firebaseService.saveCategory(categoria);
          }
        }

        transacoesProcessadas.add({
          'parsed': parsed,
          'categoryId': categoria.id,
        });
      }

      // Agora salvar as transações com IDs de categoria corretos
      for (final item in transacoesProcessadas) {
        final parsed = item['parsed'] as ParsedTransaction;
        final categoryId = item['categoryId'] as String;

        final transaction = TransactionModel.create(
          title: parsed.categoryName,
          amount: parsed.amount,
          type: parsed.type == TipoTransacao.receita
              ? TransactionType.income
              : TransactionType.expense,
          categoryId: categoryId,
          date: DateTime.now(),
          description: 'Adicionado via texto: ${parsed.originalText}',
        );

        // Adicionar ao estado local
        appState.adicionarTransacao(transaction);

        // Salvar no Firestore apenas se estiver logado
        if (firebaseService.userId != null) {
          await firebaseService.saveTransaction(transaction);
        }
      }

      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(
            '${validTransactions.length} transações salvas com sucesso!',
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Recarregar dados para garantir que o dashboard seja atualizado
      await appState.carregarDados();
      if (!mounted) return;

      // Limpar e voltar
      setState(() {
        _textController.clear();
        _parsedTransactions.clear();
        _showPreview = false;
      });

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar transações: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

class ParsedTransaction {
  final double amount;
  final TipoTransacao type;
  final String categoryId;
  final String categoryName;
  final String originalText;
  final bool isValid;
  final String? errorMessage;

  ParsedTransaction({
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.categoryName,
    required this.originalText,
  }) : isValid = true,
       errorMessage = null;

  ParsedTransaction.invalid(this.errorMessage)
    : amount = 0,
      type = TipoTransacao.despesa,
      categoryId = '',
      categoryName = '',
      originalText = '',
      isValid = false;
}
