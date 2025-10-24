import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gastos_manager/models/transaction.dart';
import 'package:gastos_manager/models/category.dart';
import 'package:gastos_manager/models/orcamento.dart';

class AppState extends ChangeNotifier {
  final List<TransactionModel> _transacoes = [];
  final List<Orcamento> _orcamentos = [];
  final List<CategoryModel> _categorias = [];
  bool _isGuestMode = false;

  // Getters
  List<TransactionModel> get transacoes => List.unmodifiable(_transacoes);
  List<Orcamento> get orcamentos => List.unmodifiable(_orcamentos);
  List<CategoryModel> get categorias => List.unmodifiable(_categorias);
  bool get isGuest => _isGuestMode;

  // Métodos para transações
  void adicionarTransacao(TransactionModel transacao) {
    debugPrint(
      '🔥 APP_STATE: Adicionando transação: ${transacao.title} - R\$ ${transacao.amount} - Tipo: ${transacao.type}',
    );
    _transacoes.add(transacao);
    debugPrint(
      '🔥 APP_STATE: Total de transações após adicionar: ${_transacoes.length}',
    );
    notifyListeners();
  }

  void removerTransacao(String id) {
    _transacoes.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void atualizarTransacao(TransactionModel transacao) {
    final index = _transacoes.indexWhere((t) => t.id == transacao.id);
    if (index != -1) {
      _transacoes[index] = transacao;
      notifyListeners();
    }
  }

  // Métodos para orçamentos
  void adicionarOrcamento(Orcamento orcamento) {
    _orcamentos.add(orcamento);
    notifyListeners();
  }

  void removerOrcamento(String id) {
    _orcamentos.removeWhere((o) => o.id == id);
    notifyListeners();
  }

  void atualizarOrcamento(Orcamento orcamento) {
    final index = _orcamentos.indexWhere((o) => o.id == orcamento.id);
    if (index != -1) {
      _orcamentos[index] = orcamento;
      notifyListeners();
    }
  }

  // Métodos para categorias
  void adicionarCategoria(CategoryModel categoria) {
    _categorias.add(categoria);
    notifyListeners();
  }

  void removerCategoria(String id) {
    _categorias.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  void atualizarCategoria(CategoryModel categoria) {
    final index = _categorias.indexWhere((c) => c.id == categoria.id);
    if (index != -1) {
      _categorias[index] = categoria;
      notifyListeners();
    }
  }

  // Método para limpar todos os dados
  void limparDados() {
    _transacoes.clear();
    _orcamentos.clear();
    _categorias.clear();
    notifyListeners();
  }

  // Método para definir modo visitante
  void setGuestMode(bool isGuest) {
    _isGuestMode = isGuest;
    if (isGuest) {
      // Limpar dados quando entrar no modo visitante
      limparDados();
    }
    notifyListeners();
  }

  // Método para obter categoria por ID
  CategoryModel? getCategoriaById(String id) {
    try {
      return _categorias.firstWhere((categoria) => categoria.id == id);
    } catch (e) {
      return null;
    }
  }

  // Método para obter as 10 categorias mais usadas + "Outros"
  List<CategoryModel> getCategoriasMaisUsadas() {
    // Para novos usuários, retornar lista vazia para experiência limpa
    if (_categorias.isEmpty) {
      return [];
    }

    // Contar uso de cada categoria
    Map<String, int> usoCategoria = {};
    for (final transacao in _transacoes) {
      usoCategoria[transacao.categoryId] =
          (usoCategoria[transacao.categoryId] ?? 0) + 1;
    }

    // Ordenar categorias por uso
    List<CategoryModel> categoriasOrdenadas = List.from(_categorias);
    categoriasOrdenadas.sort((a, b) {
      int usoA = usoCategoria[a.id] ?? 0;
      int usoB = usoCategoria[b.id] ?? 0;
      return usoB.compareTo(usoA);
    });

    // Pegar as 10 mais usadas
    List<CategoryModel> top10 = categoriasOrdenadas.take(10).toList();

    // Garantir que "Outros" está sempre disponível
    bool temOutros = top10.any((cat) => cat.name.toLowerCase() == 'outros');
    if (!temOutros) {
      // Procurar "Outros" nas categorias existentes
      CategoryModel? outros = _categorias.firstWhere(
        (cat) => cat.name.toLowerCase() == 'outros',
        orElse: () => CategoryModel.create(
          name: 'Outros',
          icon: '📁',
          color: const Color(0xFF607D8B),
          type: CategoryType.expense,
        ),
      );

      // Se a lista já tem 10 itens, remover o último e adicionar "Outros"
      if (top10.length >= 10) {
        top10.removeLast();
      }
      top10.add(outros);
    }

    return top10;
  } // Getters para cálculos financeiros

  double get receitasPeriodo {
    return _transacoes
        .where((transacao) => transacao.type == TransactionType.income)
        .fold(0.0, (sum, transacao) => sum + transacao.amount);
  }

  double get despesasPeriodo {
    return _transacoes
        .where((transacao) => transacao.type == TransactionType.expense)
        .fold(0.0, (sum, transacao) => sum + transacao.amount);
  }

  double get saldoTotal {
    return receitasPeriodo - despesasPeriodo;
  }

  // Alias para compatibilidade
  double get saldoPeriodo => saldoTotal;

  // Método para carregar dados do Firestore
  Future<void> carregarDados() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint('🔥 APP_STATE: Usuário não logado');
        return;
      }

      debugPrint('🔥 APP_STATE: Carregando dados para usuário ${user.uid}');

      // Carregar transações
      final transacoesSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .get();

      debugPrint(
        '🔥 APP_STATE: Encontradas ${transacoesSnapshot.docs.length} transações',
      );

      _transacoes.clear();
      for (final doc in transacoesSnapshot.docs) {
        final transacao = TransactionModel.fromMap(doc.data());
        _transacoes.add(transacao);
        debugPrint(
          '🔥 APP_STATE: Carregada transação: ${transacao.title} - R\$ ${transacao.amount}',
        );
      }

      // Carregar orçamentos
      final orcamentosSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('budgets')
          .get();

      _orcamentos.clear();
      for (final doc in orcamentosSnapshot.docs) {
        final orcamento = Orcamento.fromMap(doc.data());
        _orcamentos.add(orcamento);
      }

      // Carregar categorias
      final categoriasSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('categories')
          .get();

      _categorias.clear();
      for (final doc in categoriasSnapshot.docs) {
        final categoria = CategoryModel.fromMap(doc.data());
        _categorias.add(categoria);
      }

      notifyListeners();

      debugPrint('🔥 APP_STATE: Dados carregados com sucesso!');
      debugPrint('🔥 APP_STATE: Total transações: ${_transacoes.length}');
      debugPrint(
        '🔥 APP_STATE: Receitas: R\$ ${receitasPeriodo.toStringAsFixed(2)}',
      );
      debugPrint(
        '🔥 APP_STATE: Despesas: R\$ ${despesasPeriodo.toStringAsFixed(2)}',
      );
      debugPrint('🔥 APP_STATE: Saldo: R\$ ${saldoTotal.toStringAsFixed(2)}');
    } catch (e) {
      debugPrint('❌ APP_STATE: Erro ao carregar dados: $e');
    }
  }
}
