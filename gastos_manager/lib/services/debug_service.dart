import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'app_state.dart';

/// Serviço de debug para logs e monitoramento do aplicativo
class DebugService {
  static final DebugService _instance = DebugService._internal();
  factory DebugService() => _instance;
  DebugService._internal();

  final List<String> _debugLogs = [];

  /// Adicionar log de debug
  void log(String message) {
    final timestamp = DateTime.now().toString().substring(11, 19);
    final logMessage = '[$timestamp] $message';
    _debugLogs.add(logMessage);

    // Manter apenas os últimos 100 logs
    if (_debugLogs.length > 100) {
      _debugLogs.removeAt(0);
    }

    if (kDebugMode) {
      debugPrint('DEBUG: $logMessage');
    }
  }

  /// Obter todos os logs
  List<String> get logs => List.unmodifiable(_debugLogs);

  /// Limpar logs
  void clearLogs() {
    _debugLogs.clear();
  }

  /// Analisar dados do usuário para informações gerais
  Future<Map<String, dynamic>> analyzeUserData() async {
    log('Analisando dados do usuário');

    final user = FirebaseAuth.instance.currentUser;
    final analysis = <String, dynamic>{
      'user_id': user?.uid,
      'user_email': user?.email,
      'is_logged_in': user != null,
      'analysis_time': DateTime.now().toIso8601String(),
      'suspicious_transactions': 0,
      'suspicious_categories': 0,
    };

    if (user == null) {
      analysis['message'] = 'Usuário não está logado';
      return analysis;
    }

    try {
      // Verificar coleções do usuário
      final firestore = FirebaseFirestore.instance;
      final userDoc = firestore.collection('users').doc(user.uid);

      // Analisar transações
      final transactionsSnapshot = await userDoc
          .collection('transactions')
          .get();
      analysis['firestore_transactions'] = transactionsSnapshot.docs.length;

      // Verificar transações fictícias
      int suspiciousTransactions = 0;
      for (final doc in transactionsSnapshot.docs) {
        final data = doc.data();
        final title = (data['title'] ?? data['descricao'] ?? '')
            .toString()
            .toLowerCase();
        final description = (data['description'] ?? data['descricao'] ?? '')
            .toString()
            .toLowerCase();

        if (_isSuspiciousContent(title) || _isSuspiciousContent(description)) {
          suspiciousTransactions++;
        }
      }
      analysis['suspicious_transactions'] = suspiciousTransactions;

      // Analisar categorias
      final categoriesSnapshot = await userDoc.collection('categories').get();
      analysis['firestore_categories'] = categoriesSnapshot.docs.length;

      // Verificar categorias fictícias
      int suspiciousCategories = 0;
      for (final doc in categoriesSnapshot.docs) {
        final data = doc.data();
        final name = (data['name'] ?? data['nome'] ?? '')
            .toString()
            .toLowerCase();

        if (_isSuspiciousContent(name)) {
          suspiciousCategories++;
        }
      }
      analysis['suspicious_categories'] = suspiciousCategories;

      // Analisar orçamentos
      final budgetsSnapshot = await userDoc.collection('budgets').get();
      analysis['firestore_budgets'] = budgetsSnapshot.docs.length;

      analysis['message'] = 'Análise concluída com sucesso';
    } catch (e) {
      log('Erro durante análise: $e');
      analysis['error'] = e.toString();
    }

    return analysis;
  }

  /// Verificar se o conteúdo é suspeito (dados fictícios)
  bool _isSuspiciousContent(String content) {
    final keywords = [
      'exemplo',
      'teste',
      'test',
      'demo',
      'sample',
      'mock',
      'placeholder',
      'dummy',
      'fake',
      'fictício',
      'ficticio',
      'provisório',
      'provisorio',
      'temporário',
      'temporario',
    ];

    return keywords.any((keyword) => content.contains(keyword));
  }

  /// Limpar dados fictícios do Firebase
  Future<Map<String, dynamic>> cleanFictitiousData() async {
    log('Iniciando limpeza de dados fictícios');

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return {'success': false, 'error': 'Usuário não está logado'};
    }

    final result = <String, dynamic>{
      'success': true,
      'transactions_removed': 0,
      'categories_removed': 0,
      'errors': <String>[],
    };

    try {
      final firestore = FirebaseFirestore.instance;
      final userDoc = firestore.collection('users').doc(user.uid);
      final batch = firestore.batch();

      // Limpar transações fictícias
      final transactionsSnapshot = await userDoc
          .collection('transactions')
          .get();
      for (final doc in transactionsSnapshot.docs) {
        final data = doc.data();
        final title = (data['title'] ?? data['descricao'] ?? '')
            .toString()
            .toLowerCase();
        final description = (data['description'] ?? data['descricao'] ?? '')
            .toString()
            .toLowerCase();

        if (_isSuspiciousContent(title) || _isSuspiciousContent(description)) {
          batch.delete(doc.reference);
          result['transactions_removed'] =
              (result['transactions_removed'] as int) + 1;
          log('Removendo transação: ${data['title'] ?? data['descricao']}');
        }
      }

      // Limpar categorias fictícias (exceto as padrão do sistema)
      final categoriesSnapshot = await userDoc.collection('categories').get();
      for (final doc in categoriesSnapshot.docs) {
        final data = doc.data();
        final name = (data['name'] ?? data['nome'] ?? '')
            .toString()
            .toLowerCase();
        final isDefault = data['isDefault'] ?? false;

        // Não remover categorias padrão do sistema
        if (!isDefault && _isSuspiciousContent(name)) {
          batch.delete(doc.reference);
          result['categories_removed'] =
              (result['categories_removed'] as int) + 1;
          log('Removendo categoria: ${data['name'] ?? data['nome']}');
        }
      }

      // Executar todas as remoções
      await batch.commit();
      log('Limpeza concluída com sucesso');
    } catch (e) {
      log('Erro durante limpeza: $e');
      result['success'] = false;
      result['errors'].add(e.toString());
    }

    return result;
  }

  /// Limpar TODOS os dados do usuário (função administrativa)
  Future<Map<String, dynamic>> clearAllUserData() async {
    log('Iniciando limpeza COMPLETA de dados');

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return {'success': false, 'error': 'Usuário não está logado'};
    }

    final result = <String, dynamic>{
      'success': true,
      'transactions_removed': 0,
      'categories_removed': 0,
      'budgets_removed': 0,
      'errors': <String>[],
    };

    try {
      final firestore = FirebaseFirestore.instance;
      final userDoc = firestore.collection('users').doc(user.uid);

      // Limpar todas as transações
      final transactionsSnapshot = await userDoc
          .collection('transactions')
          .get();
      for (final doc in transactionsSnapshot.docs) {
        await doc.reference.delete();
        result['transactions_removed'] =
            (result['transactions_removed'] as int) + 1;
      }

      // Limpar todas as categorias (exceto as padrão do sistema)
      final categoriesSnapshot = await userDoc.collection('categories').get();
      for (final doc in categoriesSnapshot.docs) {
        final data = doc.data();
        final isDefault = data['isDefault'] ?? false;

        if (!isDefault) {
          await doc.reference.delete();
          result['categories_removed'] =
              (result['categories_removed'] as int) + 1;
        }
      }

      // Limpar todos os orçamentos
      final budgetsSnapshot = await userDoc.collection('budgets').get();
      for (final doc in budgetsSnapshot.docs) {
        await doc.reference.delete();
        result['budgets_removed'] = (result['budgets_removed'] as int) + 1;
      }

      log('Limpeza completa concluída com sucesso');
    } catch (e) {
      log('Erro durante limpeza completa: $e');
      result['success'] = false;
      result['errors'].add(e.toString());
    }

    return result;
  }

  /// Obter estatísticas do app state
  Map<String, dynamic> getAppStateStats(AppState appState) {
    return {
      'transacoes_count': appState.transacoes.length,
      'categorias_count': appState.categorias.length,
      'orcamentos_count': appState.orcamentos.length,
      'is_guest_mode': appState.isGuest,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Exportar logs para string
  String exportLogs() {
    return _debugLogs.join('\n');
  }
}
