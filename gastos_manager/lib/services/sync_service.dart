import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../models/orcamento.dart';
import 'app_state.dart';

class SyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Timestamp da última sincronização
  DateTime? _lastSyncTimestamp;

  // Sincronizar dados do usuário
  Future<Map<String, dynamic>> syncUserData(AppState appState) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Usuário não autenticado');
      }

      final userDoc = _firestore.collection('users').doc(user.uid);
      final syncDoc = userDoc.collection('sync').doc('metadata');

      // Obter timestamp da última sincronização
      final syncSnapshot = await syncDoc.get();
      if (syncSnapshot.exists) {
        final data = syncSnapshot.data();
        _lastSyncTimestamp = (data?['lastSync'] as Timestamp?)?.toDate();
      }

      final results = {
        'transactionsSynced': 0,
        'categoriesSynced': 0,
        'budgetsSynced': 0,
        'conflictsResolved': 0,
      };

      // Sincronizar transações
      results['transactionsSynced'] = await _syncTransactions(
        user.uid,
        appState,
      );

      // Sincronizar categorias
      results['categoriesSynced'] = await _syncCategories(user.uid, appState);

      // Sincronizar orçamentos
      results['budgetsSynced'] = await _syncBudgets(user.uid, appState);

      // Atualizar timestamp da última sincronização
      await syncDoc.set({
        'lastSync': FieldValue.serverTimestamp(),
        'deviceId': await _getDeviceId(),
        'appVersion': '1.0.0',
      }, SetOptions(merge: true));

      return {
        'success': true,
        'message': 'Sincronização concluída com sucesso',
        'results': results,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro na sincronização: $e',
        'results': null,
      };
    }
  }

  // Sincronizar transações
  Future<int> _syncTransactions(String userId, AppState appState) async {
    final localTransactions = appState.transacoes;
    final remoteTransactions = await _getRemoteTransactions(userId);

    int syncedCount = 0;

    // Upload transações locais que não existem remotamente
    for (final localTx in localTransactions) {
      TransactionModel? remoteTx;
      try {
        remoteTx = remoteTransactions.firstWhere((rt) => rt.id == localTx.id);
      } catch (e) {
        remoteTx = null;
      }

      if (remoteTx == null) {
        // Nova transação local - upload
        await _uploadTransaction(userId, localTx);
        syncedCount++;
      } else if (_isTransactionNewer(localTx, remoteTx)) {
        // Transação local mais recente - sobrescrever remota
        await _uploadTransaction(userId, localTx);
        syncedCount++;
      } else if (_isTransactionNewer(remoteTx, localTx)) {
        // Transação remota mais recente - sobrescrever local
        appState.atualizarTransacao(remoteTx);
        syncedCount++;
      }
    }

    // Download transações remotas que não existem localmente
    for (final remoteTx in remoteTransactions) {
      TransactionModel? localTx;
      try {
        localTx = localTransactions.firstWhere((lt) => lt.id == remoteTx.id);
      } catch (e) {
        localTx = null;
      }

      if (localTx == null) {
        // Nova transação remota - adicionar localmente
        appState.adicionarTransacao(remoteTx);
        syncedCount++;
      }
    }

    return syncedCount;
  }

  // Sincronizar categorias
  Future<int> _syncCategories(String userId, AppState appState) async {
    final localCategories = appState.categorias;
    final remoteCategories = await _getRemoteCategories(userId);

    int syncedCount = 0;

    // Upload categorias locais que não existem remotamente
    for (final localCat in localCategories) {
      CategoryModel? remoteCat;
      try {
        remoteCat = remoteCategories.firstWhere((rc) => rc.id == localCat.id);
      } catch (e) {
        remoteCat = null;
      }

      if (remoteCat == null) {
        await _uploadCategory(userId, localCat);
        syncedCount++;
      } else if (_isCategoryNewer(localCat, remoteCat)) {
        await _uploadCategory(userId, localCat);
        syncedCount++;
      } else if (_isCategoryNewer(remoteCat, localCat)) {
        appState.atualizarCategoria(remoteCat);
        syncedCount++;
      }
    }

    // Download categorias remotas que não existem localmente
    for (final remoteCat in remoteCategories) {
      CategoryModel? localCat;
      try {
        localCat = localCategories.firstWhere((lc) => lc.id == remoteCat.id);
      } catch (e) {
        localCat = null;
      }

      if (localCat == null) {
        appState.adicionarCategoria(remoteCat);
        syncedCount++;
      }
    }

    return syncedCount;
  }

  // Sincronizar orçamentos
  Future<int> _syncBudgets(String userId, AppState appState) async {
    final localBudgets = appState.orcamentos;
    final remoteBudgets = await _getRemoteBudgets(userId);

    int syncedCount = 0;

    // Upload orçamentos locais que não existem remotamente
    for (final localBudget in localBudgets) {
      Orcamento? remoteBudget;
      try {
        remoteBudget = remoteBudgets.firstWhere(
          (rb) => rb.id == localBudget.id,
        );
      } catch (e) {
        remoteBudget = null;
      }

      if (remoteBudget == null) {
        await _uploadBudget(userId, localBudget);
        syncedCount++;
      } else if (_isBudgetNewer(localBudget, remoteBudget)) {
        await _uploadBudget(userId, localBudget);
        syncedCount++;
      } else if (_isBudgetNewer(remoteBudget, localBudget)) {
        appState.atualizarOrcamento(remoteBudget);
        syncedCount++;
      }
    }

    // Download orçamentos remotos que não existem localmente
    for (final remoteBudget in remoteBudgets) {
      Orcamento? localBudget;
      try {
        localBudget = localBudgets.firstWhere((lb) => lb.id == remoteBudget.id);
      } catch (e) {
        localBudget = null;
      }

      if (localBudget == null) {
        appState.adicionarOrcamento(remoteBudget);
        syncedCount++;
      }
    }

    return syncedCount;
  }

  // Métodos auxiliares para upload
  Future<void> _uploadTransaction(
    String userId,
    TransactionModel transaction,
  ) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .doc(transaction.id)
        .set({
          'id': transaction.id,
          'title': transaction.title,
          'amount': transaction.amount,
          'type': transaction.type.name,
          'categoryId': transaction.categoryId,
          'date': Timestamp.fromDate(transaction.date),
          'description': transaction.description,
          'isRecurring': transaction.isRecurring,
          'recurringType': transaction.recurringType?.name,
          'frequencyDays': transaction.frequencyDays,
          'lastModified': FieldValue.serverTimestamp(),
        });
  }

  Future<void> _uploadCategory(String userId, CategoryModel categoria) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('categories')
        .doc(categoria.id)
        .set({
          'id': categoria.id,
          'name': categoria.name,
          'icon': categoria.icon,
          'color': categoria.color.toARGB32(),
          'type': categoria.type.name,
          'isDefault': categoria.isDefault,
          'isActive': categoria.isActive,
          'lastModified': FieldValue.serverTimestamp(),
        });
  }

  Future<void> _uploadBudget(String userId, Orcamento orcamento) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('budgets')
        .doc(orcamento.id)
        .set({
          'id': orcamento.id,
          'nome': orcamento.nome,
          'categoriaId': orcamento.categoriaId,
          'valorLimite': orcamento.valorLimite,
          'dataInicio': Timestamp.fromDate(orcamento.dataInicio),
          'dataFim': Timestamp.fromDate(orcamento.dataFim),
          'ativo': orcamento.ativo,
          'notificarExcesso': orcamento.notificarExcesso,
          'porcentagemAlerta': orcamento.porcentagemAlerta,
          'lastModified': FieldValue.serverTimestamp(),
        });
  }

  // Métodos auxiliares para download
  Future<List<TransactionModel>> _getRemoteTransactions(String userId) async {
    final query = _firestore
        .collection('users')
        .doc(userId)
        .collection('transactions');

    final snapshot = await query.get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return TransactionModel.fromMap(data);
    }).toList();
  }

  Future<List<CategoryModel>> _getRemoteCategories(String userId) async {
    final query = _firestore
        .collection('users')
        .doc(userId)
        .collection('categories');

    final snapshot = await query.get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return CategoryModel.fromMap(data);
    }).toList();
  }

  Future<List<Orcamento>> _getRemoteBudgets(String userId) async {
    final query = _firestore
        .collection('users')
        .doc(userId)
        .collection('budgets');

    final snapshot = await query.get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Orcamento.fromMap(data);
    }).toList();
  }

  // Métodos auxiliares para comparação de versões
  bool _isTransactionNewer(TransactionModel tx1, TransactionModel tx2) {
    // Por enquanto, comparar por data (pode ser melhorado com timestamps)
    return tx1.data.isAfter(tx2.data);
  }

  bool _isCategoryNewer(Categoria cat1, Categoria cat2) {
    // Categorias não têm timestamp, então comparar por nome
    return cat1.nome != cat2.nome;
  }

  bool _isBudgetNewer(Orcamento budget1, Orcamento budget2) {
    // Comparar por data de fim
    return budget1.dataFim.isAfter(budget2.dataFim);
  }

  // Obter ID único do dispositivo
  Future<String> _getDeviceId() async {
    // Implementar lógica para obter ID único do dispositivo
    // Por enquanto, usar UID do usuário
    return _auth.currentUser?.uid ?? 'unknown_device';
  }

  // Verificar se sincronização é necessária
  bool shouldSync() {
    if (_lastSyncTimestamp == null) return true;

    final now = DateTime.now();
    final timeSinceLastSync = now.difference(_lastSyncTimestamp!);

    // Sincronizar se passou mais de 5 minutos
    return timeSinceLastSync.inMinutes > 5;
  }

  // Forçar sincronização completa
  Future<Map<String, dynamic>> forceFullSync(AppState appState) async {
    _lastSyncTimestamp = null;
    return await syncUserData(appState);
  }
}
