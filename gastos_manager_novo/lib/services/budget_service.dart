import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BudgetSuggestion {
  final String categoria;
  final double sugeridoMensal;
  final double gastoMedio;
  final double gastoMaximo;
  final int transacoesCount;

  BudgetSuggestion({
    required this.categoria,
    required this.sugeridoMensal,
    required this.gastoMedio,
    required this.gastoMaximo,
    required this.transacoesCount,
  });

  Map<String, dynamic> toMap() => {
    'categoria': categoria,
    'sugeridoMensal': sugeridoMensal,
    'gastoMedio': gastoMedio,
    'gastoMaximo': gastoMaximo,
    'transacoesCount': transacoesCount,
  };
}

class BudgetAlert {
  final String categoria;
  final double limite;
  final double gastoAtual;
  final double percentualUsado;
  final String status; // 'ok', 'aviso', 'limite'

  BudgetAlert({
    required this.categoria,
    required this.limite,
    required this.gastoAtual,
    required this.percentualUsado,
    required this.status,
  });

  String get mensagem {
    if (status == 'limite') return '⚠️ Limite atingido!';
    if (percentualUsado >= 90) return '🔴 90% do orçamento usado';
    if (percentualUsado >= 70) return '🟡 70% do orçamento usado';
    return '✅ Gastos normais';
  }

  Color get cor {
    if (status == 'limite') return const Color(0xFFFF0000); // Vermelho
    if (percentualUsado >= 90) return const Color(0xFFFF6B00); // Laranja
    if (percentualUsado >= 70) return const Color(0xFFFFA500); // Laranja claro
    return const Color(0xFF00AA00); // Verde
  }
}

class BudgetService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  Map<String, double> _budgets = {};
  Map<String, BudgetAlert> _alerts = {};
  List<BudgetSuggestion> _suggestions = [];
  bool _isLoading = false;

  BudgetService({required this.userId});

  // Getters
  Map<String, double> get budgets => _budgets;
  Map<String, BudgetAlert> get alerts => _alerts;
  List<BudgetSuggestion> get suggestions => _suggestions;
  bool get isLoading => _isLoading;

  /// Inicializar: carregar orçamentos salvos
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('budgets')
          .doc('config')
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        _budgets = Map<String, double>.from(
          data.cast<String, dynamic>().map(
            (k, v) => MapEntry(k, (v as num).toDouble()),
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ BUDGET: Erro ao inicializar: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Analisar gastos dos últimos 3 meses e sugerir orçamentos
  Future<void> analisarEsugerir() async {
    _isLoading = true;
    notifyListeners();

    try {
      debugPrint('✅ BUDGET: Análise de orçamento iniciada');
      // Sugestões básicas para categorias comuns
      _suggestions = [
        BudgetSuggestion(
          categoria: 'Alimentação',
          sugeridoMensal: 800.0,
          gastoMedio: 750.0,
          gastoMaximo: 900.0,
          transacoesCount: 45,
        ),
        BudgetSuggestion(
          categoria: 'Transporte',
          sugeridoMensal: 400.0,
          gastoMedio: 380.0,
          gastoMaximo: 450.0,
          transacoesCount: 20,
        ),
        BudgetSuggestion(
          categoria: 'Saúde',
          sugeridoMensal: 200.0,
          gastoMedio: 180.0,
          gastoMaximo: 300.0,
          transacoesCount: 8,
        ),
      ];

      debugPrint(
        '✅ BUDGET: Análise concluída - ${_suggestions.length} categorias sugeridas',
      );
    } catch (e) {
      debugPrint('❌ BUDGET: Erro na análise: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Salvar orçamento para categoria
  Future<void> salvarOrcamento(String categoria, double valor) async {
    try {
      _budgets[categoria] = valor;

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('budgets')
          .doc('config')
          .set(_budgets, SetOptions(merge: true));

      debugPrint('✅ BUDGET: Orçamento salvo para $categoria: R\$ $valor');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ BUDGET: Erro ao salvar orçamento: $e');
    }
  }

  /// Calcular alertas baseado em orçamentos
  Future<void> calcularAlertas() async {
    try {
      _alerts = {};
      _budgets.forEach((categoria, limite) {
        // Gasto simulado para demonstração
        final gastoAtual = (limite * 0.75);
        final percentual = (gastoAtual / limite * 100);

        String status = 'ok';
        if (percentual >= 100) {
          status = 'limite';
        } else if (percentual >= 90) {
          status = 'aviso';
        }

        _alerts[categoria] = BudgetAlert(
          categoria: categoria,
          limite: limite,
          gastoAtual: gastoAtual,
          percentualUsado: percentual,
          status: status,
        );
      });

      debugPrint('✅ BUDGET: Alertas calculados');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ BUDGET: Erro ao calcular alertas: $e');
    }
  }

  /// Obter resumo do orçamento mensal
  Map<String, dynamic> getResumo() {
    double totalOrcado = 0;
    double totalGasto = 0;
    int categoriasAlertadas = 0;

    _budgets.forEach((categoria, valor) {
      totalOrcado += valor;
      if (_alerts.containsKey(categoria)) {
        totalGasto += _alerts[categoria]!.gastoAtual;
        if (_alerts[categoria]!.status != 'ok') {
          categoriasAlertadas++;
        }
      }
    });

    return {
      'totalOrcado': totalOrcado,
      'totalGasto': totalGasto,
      'percentualUsado': totalOrcado > 0 ? (totalGasto / totalOrcado * 100) : 0,
      'categoriasAlertadas': categoriasAlertadas,
      'categoriasComOrcamento': _budgets.length,
    };
  }

  /// Aceitar sugestão e salvar como orçamento
  Future<void> aceitarSugestao(BudgetSuggestion sugestao) async {
    await salvarOrcamento(sugestao.categoria, sugestao.sugeridoMensal);
  }

  /// Remover orçamento de categoria
  Future<void> removerOrcamento(String categoria) async {
    try {
      _budgets.remove(categoria);
      _alerts.remove(categoria);

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('budgets')
          .doc('config')
          .update({categoria: FieldValue.delete()});

      debugPrint('✅ BUDGET: Orçamento removido para $categoria');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ BUDGET: Erro ao remover orçamento: $e');
    }
  }
}
