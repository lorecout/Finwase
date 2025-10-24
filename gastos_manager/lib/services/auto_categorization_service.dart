import '../models/transaction.dart';
import '../models/category.dart';
import 'app_state.dart';

class AutoCategorizationService {
  final AppState _appState;

  AutoCategorizationService(this._appState);

  // Regras de categorização automática baseadas em padrões
  final Map<String, List<String>> _categorizationRules = {
    // Alimentação
    'alimentacao': [
      'restaurante',
      'lanchonete',
      'padaria',
      'mercado',
      'supermercado',
      'hortifruti',
      'açougue',
      'peixaria',
      'feira',
      'delivery',
      'ifood',
      'uber eats',
      'rappi',
      'james delivery',
      'pizza',
      'hamburguer',
      'sushi',
      'churrasco',
      'massas',
      'sorvete',
      'doces',
      'cafeteria',
      'bar',
      'pub',
      'boteco',
      'cerveja',
      'vinho',
      'bebidas',
    ],

    // Transporte
    'transporte': [
      'uber',
      '99',
      'cabify',
      'taxi',
      'ônibus',
      'metrô',
      'trem',
      'estacionamento',
      'pedágio',
      'combustível',
      'gasolina',
      'álcool',
      'diesel',
      'posto',
      'mecânico',
      'oficina',
      'pneu',
      'revisão',
      'seguro carro',
      'multa',
      'detran',
      'transito',
    ],

    // Moradia
    'moradia': [
      'aluguel',
      'condomínio',
      'iptu',
      'energia',
      'luz',
      'água',
      'saneamento',
      'gás',
      'internet',
      'telefone',
      'celular',
      'tv',
      'netflix',
      'spotify',
      'amazon prime',
      'deezer',
      'limpeza',
      'faxina',
      'manutenção',
      'reforma',
      'decoração',
      'móveis',
    ],

    // Saúde
    'saude': [
      'farmácia',
      'remédio',
      'consulta',
      'médico',
      'dentista',
      'oftalmologista',
      'psicólogo',
      'terapia',
      'exame',
      'laboratório',
      'hospital',
      'clínica',
      'plano saúde',
      'seguro saúde',
      'academia',
      'ginástica',
      'pilates',
      'crossfit',
      'musculação',
      'corrida',
      'ciclismo',
    ],

    // Educação
    'educacao': [
      'escola',
      'faculdade',
      'universidade',
      'curso',
      'aula',
      'professor',
      'material',
      'livro',
      'apostila',
      'caneta',
      'caderno',
      'mochila',
      'inglês',
      'espanhol',
      'francês',
      'alemão',
      'japonês',
      'chinês',
      'matemática',
      'português',
      'história',
      'geografia',
      'ciências',
    ],

    // Entretenimento
    'entretenimento': [
      'cinema',
      'teatro',
      'show',
      'concerto',
      'festival',
      'parque',
      'shopping',
      'loja',
      'roupa',
      'sapato',
      'bolsa',
      'acessório',
      'beleza',
      'cabeleireiro',
      'manicure',
      'pedicure',
      'salão',
      'perfume',
      'cosméticos',
      'jogo',
      'videogame',
      'console',
    ],

    // Compras
    'compras': [
      'shopping',
      'loja',
      'mercado',
      'supermercado',
      'farmácia',
      'posto',
      'padaria',
      'açougue',
      'hortifruti',
      'petshop',
      'papelaria',
      'livraria',
      'magazine',
      'americanas',
      'casas bahia',
      'ponto frio',
      'extra',
      'carrefour',
      'walmart',
      'amazon',
      'mercado livre',
    ],

    // Freelance/Profissional
    'freelance': [
      'freela',
      'projeto',
      'cliente',
      'pagamento',
      'honorário',
      'serviço',
      'consultoria',
      'desenvolvimento',
      'design',
      'marketing',
      'vendas',
      'comissão',
      'bônus',
      'adicional',
      'hora extra',
      'sobreaviso',
    ],
  };

  // Sugerir categoria para uma transação baseada na descrição
  CategoryModel? suggestCategoryForTransaction(TransactionModel transaction) {
    final description = transaction.title.toLowerCase();

    // Primeiro, tentar encontrar correspondência exata
    for (final entry in _categorizationRules.entries) {
      final categoryId = entry.key;
      final keywords = entry.value;

      for (final keyword in keywords) {
        if (description.contains(keyword)) {
          try {
            return _appState.categorias.firstWhere(
              (cat) => cat.id == categoryId,
            );
          } catch (e) {
            return null;
          }
        }
      }
    }

    // Se não encontrou correspondência exata, tentar correspondência parcial
    for (final entry in _categorizationRules.entries) {
      final categoryId = entry.key;
      final keywords = entry.value;

      for (final keyword in keywords) {
        // Verificar se alguma palavra da descrição contém parte da palavra-chave
        final descriptionWords = description.split(' ');
        for (final word in descriptionWords) {
          if (word.length > 3 && keyword.contains(word)) {
            try {
              return _appState.categorias.firstWhere(
                (cat) => cat.id == categoryId,
              );
            } catch (e) {
              return null;
            }
          }
        }
      }
    }

    // Se ainda não encontrou, usar análise baseada em valor e padrões históricos
    return _suggestCategoryByPattern(transaction);
  }

  // Sugerir categoria baseada em padrões históricos e valor
  CategoryModel? _suggestCategoryByPattern(TransactionModel transaction) {
    final amount = transaction.amount;
    final type = transaction.type;

    // Para receitas, tentar identificar padrões comuns
    if (type == TransactionType.income) {
      if (amount > 5000) {
        // Valores altos provavelmente são salários
        return _findCategoryByName('Salário');
      } else if (amount > 1000) {
        // Valores médios podem ser freelas ou vendas
        return _findCategoryByName('Freelance') ??
            _findCategoryByName('Vendas');
      }
    }

    // Para despesas, analisar valor e padrões
    if (type == TransactionType.expense) {
      if (amount > 500) {
        // Valores altos podem ser aluguel, compras grandes, etc.
        return _findCategoryByName('Moradia') ?? _findCategoryByName('Compras');
      } else if (amount > 100) {
        // Valores médios podem ser alimentação, transporte, etc.
        return _findCategoryByName('Alimentação') ??
            _findCategoryByName('Transporte');
      } else {
        // Valores baixos podem ser diversos
        return _findCategoryByName('Outros');
      }
    }

    return null;
  }

  // Encontrar categoria por nome aproximado
  CategoryModel? _findCategoryByName(String name) {
    final searchName = name.toLowerCase();
    try {
      return _appState.categorias.firstWhere(
        (cat) => cat.name.toLowerCase().contains(searchName),
      );
    } catch (e) {
      return null;
    }
  }

  // Aplicar categorização automática a transações sem categoria
  Future<int> autoCategorizeTransactions() async {
    int categorizedCount = 0;

    for (final transaction in _appState.transacoes) {
      if (transaction.categoryId.isEmpty) {
        final suggestedCategory = suggestCategoryForTransaction(transaction);
        if (suggestedCategory != null) {
          final updatedTransaction = transaction.copyWith(
            categoryId: suggestedCategory.id,
          );
          _appState.atualizarTransacao(updatedTransaction);
          categorizedCount++;
        }
      }
    }

    return categorizedCount;
  }

  // Aprender com categorizações manuais do usuário
  void learnFromManualCategorization(
    TransactionModel transaction,
    CategoryModel category,
  ) {
    final description = transaction.title.toLowerCase();
    final categoryId = category.id;

    // Adicionar palavras-chave baseadas na descrição à categoria
    if (_categorizationRules.containsKey(categoryId)) {
      final words = description
          .split(' ')
          .where((word) => word.length > 3)
          .toList();

      for (final word in words) {
        if (!_categorizationRules[categoryId]!.contains(word)) {
          _categorizationRules[categoryId]!.add(word);
        }
      }
    } else {
      // Criar nova regra para categoria
      final words = description
          .split(' ')
          .where((word) => word.length > 3)
          .toList();
      _categorizationRules[categoryId] = words;
    }
  }

  // Obter estatísticas de categorização automática
  Map<String, dynamic> getCategorizationStats() {
    final totalTransactions = _appState.transacoes.length;
    final categorizedTransactions = _appState.transacoes
        .where((t) => t.categoryId.isNotEmpty)
        .length;

    final categoryUsage = <String, int>{};
    for (final transaction in _appState.transacoes) {
      if (transaction.categoryId.isNotEmpty) {
        categoryUsage[transaction.categoryId] =
            (categoryUsage[transaction.categoryId] ?? 0) + 1;
      }
    }

    return {
      'totalTransactions': totalTransactions,
      'categorizedTransactions': categorizedTransactions,
      'uncategorizedTransactions': totalTransactions - categorizedTransactions,
      'categorizationRate': totalTransactions > 0
          ? categorizedTransactions / totalTransactions
          : 0.0,
      'categoryUsage': categoryUsage,
    };
  }

  // Obter sugestões de melhoria para regras de categorização
  List<String> getImprovementSuggestions() {
    final suggestions = <String>[];
    final stats = getCategorizationStats();

    final uncategorizedRate = 1.0 - (stats['categorizationRate'] as double);

    if (uncategorizedRate > 0.3) {
      suggestions.add(
        'Muitas transações não categorizadas. Considere revisar as regras de categorização automática.',
      );
    }

    if (uncategorizedRate > 0.5) {
      suggestions.add(
        'Taxa de categorização muito baixa. Adicione mais palavras-chave às regras existentes.',
      );
    }

    final categoryUsage = stats['categoryUsage'] as Map<String, int>;
    final mostUsedCategory = categoryUsage.entries.fold<MapEntry<String, int>?>(
      null,
      (prev, curr) => prev == null || curr.value > prev.value ? curr : prev,
    );

    if (mostUsedCategory != null &&
        mostUsedCategory.value > totalTransactions * 0.5) {
      suggestions.add(
        'Uma categoria (${_getCategoryName(mostUsedCategory.key)}) está sendo usada em mais de 50% das transações. Verifique se as regras estão corretas.',
      );
    }

    return suggestions;
  }

  // Obter nome da categoria por ID
  String _getCategoryName(String categoryId) {
    try {
      return _appState.categorias
          .firstWhere((cat) => cat.id == categoryId)
          .name;
    } catch (e) {
      return 'Categoria desconhecida';
    }
  }

  int get totalTransactions => _appState.transacoes.length;

  // Resetar regras de aprendizado (para debug/testes)
  void resetLearningRules() {
    // Recarregar regras padrão
    _categorizationRules.clear();
    _categorizationRules.addAll({
      'alimentacao': [
        'restaurante',
        'lanchonete',
        'padaria',
        'mercado',
        'supermercado',
        'hortifruti',
        'açougue',
        'peixaria',
        'feira',
        'delivery',
        'ifood',
        'uber eats',
        'rappi',
        'james delivery',
        'pizza',
        'hamburguer',
        'sushi',
        'churrasco',
        'massas',
        'sorvete',
        'doces',
        'cafeteria',
        'bar',
        'pub',
        'boteco',
        'cerveja',
        'vinho',
        'bebidas',
      ],
      'transporte': [
        'uber',
        '99',
        'cabify',
        'taxi',
        'ônibus',
        'metrô',
        'trem',
        'estacionamento',
        'pedágio',
        'combustível',
        'gasolina',
        'álcool',
        'diesel',
        'posto',
        'mecânico',
        'oficina',
        'pneu',
        'revisão',
        'seguro carro',
        'multa',
        'detran',
        'transito',
      ],
      'moradia': [
        'aluguel',
        'condomínio',
        'iptu',
        'energia',
        'luz',
        'água',
        'saneamento',
        'gás',
        'internet',
        'telefone',
        'celular',
        'tv',
        'netflix',
        'spotify',
        'amazon prime',
        'deezer',
        'limpeza',
        'faxina',
        'manutenção',
        'reforma',
        'decoração',
        'móveis',
      ],
      'saude': [
        'farmácia',
        'remédio',
        'consulta',
        'médico',
        'dentista',
        'oftalmologista',
        'psicólogo',
        'terapia',
        'exame',
        'laboratório',
        'hospital',
        'clínica',
        'plano saúde',
        'seguro saúde',
        'academia',
        'ginástica',
        'pilates',
        'crossfit',
        'musculação',
        'corrida',
        'ciclismo',
      ],
      'educacao': [
        'escola',
        'faculdade',
        'universidade',
        'curso',
        'aula',
        'professor',
        'material',
        'livro',
        'apostila',
        'caneta',
        'caderno',
        'mochila',
        'inglês',
        'espanhol',
        'francês',
        'alemão',
        'japonês',
        'chinês',
        'matemática',
        'português',
        'história',
        'geografia',
        'ciências',
      ],
      'entretenimento': [
        'cinema',
        'teatro',
        'show',
        'concerto',
        'festival',
        'parque',
        'shopping',
        'loja',
        'roupa',
        'sapato',
        'bolsa',
        'acessório',
        'beleza',
        'cabeleireiro',
        'manicure',
        'pedicure',
        'salão',
        'perfume',
        'cosméticos',
        'jogo',
        'videogame',
        'console',
      ],
      'compras': [
        'shopping',
        'loja',
        'mercado',
        'supermercado',
        'farmácia',
        'posto',
        'padaria',
        'açougue',
        'hortifruti',
        'petshop',
        'papelaria',
        'livraria',
        'magazine',
        'americanas',
        'casas bahia',
        'ponto frio',
        'extra',
        'carrefour',
        'walmart',
        'amazon',
        'mercado livre',
      ],
      'freelance': [
        'freela',
        'projeto',
        'cliente',
        'pagamento',
        'honorário',
        'serviço',
        'consultoria',
        'desenvolvimento',
        'design',
        'marketing',
        'vendas',
        'comissão',
        'bônus',
        'adicional',
        'hora extra',
        'sobreaviso',
      ],
    });
  }
}
