import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../models/category.dart';

/// Serviço principal do Firebase para gerenciar autenticação, Firestore e Messaging
class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Getters
  FirebaseAuth get auth => _auth;
  FirebaseFirestore get firestore => _firestore;
  FirebaseMessaging get messaging => _messaging;

  // Usuário atual
  User? get currentUser => _auth.currentUser;
  String? get userId => currentUser?.uid;

  // Stream do usuário atual
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Inicializar Firebase Messaging
  Future<void> initializeMessaging() async {
    // Só inicializar messaging em plataformas móveis
    if (kIsWeb) {
      debugPrint(
        '📱 FIREBASE: Pulando inicialização do Firebase Messaging na web',
      );
      return;
    }

    try {
      // Solicitar permissão para notificações
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      debugPrint('User granted permission: ${settings.authorizationStatus}');

      // Obter token FCM
      String? token = await _messaging.getToken();
      debugPrint('FCM Token: $token');

      // Salvar token no Firestore se usuário estiver logado
      if (currentUser != null && token != null) {
        await _saveFCMToken(token);
      }

      // Listener para mudanças no token
      _messaging.onTokenRefresh.listen((newToken) {
        debugPrint('FCM Token refreshed: $newToken');
        if (currentUser != null) {
          _saveFCMToken(newToken);
        }
      });

      // Listener para mensagens em foreground
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('Got a message whilst in the foreground!');
        debugPrint('Message data: ${message.data}');

        if (message.notification != null) {
          debugPrint(
            'Message also contained a notification: ${message.notification}',
          );
        }
      });

      debugPrint('✅ FIREBASE: Firebase Messaging inicializado com sucesso');
    } catch (e) {
      debugPrint('❌ FIREBASE: Erro ao inicializar Firebase Messaging: $e');
      // Não lançar erro para não quebrar o app
    }
  }

  /// Salvar token FCM no Firestore
  Future<void> _saveFCMToken(String token) async {
    if (userId == null) return;

    try {
      await _firestore.collection('users').doc(userId).update({
        'fcmToken': token,
        'lastTokenUpdate': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Se o documento não existir, criar
      await _firestore.collection('users').doc(userId).set({
        'fcmToken': token,
        'lastTokenUpdate': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  /// Criar perfil do usuário no Firestore
  Future<void> createUserProfile(User user, {String? displayName}) async {
    final userDoc = _firestore.collection('users').doc(user.uid);

    debugPrint(
      '👤 FIRESTORE: Criando perfil para usuário: ${user.email} (UID: ${user.uid})',
    );

    final userData = {
      'uid': user.uid,
      'email': user.email,
      'displayName':
          user.displayName ??
          displayName ??
          user.email?.split('@')[0] ??
          'Usuário',
      'createdAt': FieldValue.serverTimestamp(),
      'lastLogin': FieldValue.serverTimestamp(),
      'isPremium': false,
      'premiumExpiryDate': null,
      'currentPlan': 'free',
      'hasHadTrial': false, // Campo mantido para compatibilidade, mas não usado
      'settings': {
        'theme': 'system',
        'currency': 'BRL',
        'language': 'pt_BR',
        'notifications': true,
      },
    };

    debugPrint('👤 FIRESTORE: Dados do perfil: $userData');

    await userDoc.set(userData, SetOptions(merge: true));

    debugPrint('✅ FIRESTORE: Perfil criado com sucesso para: ${user.email}');
  }

  /// Obter dados do usuário
  Future<Map<String, dynamic>?> getUserData() async {
    if (userId == null) return null;

    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.data();
    } catch (e) {
      debugPrint('❌ FIRESTORE: Erro ao obter dados do usuário: $e');
      return null;
    }
  }

  /// Atualizar configurações do usuário
  Future<void> updateUserSettings(Map<String, dynamic> settings) async {
    if (userId == null) return;

    try {
      await _firestore.collection('users').doc(userId).update({
        'settings': settings,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('❌ FIRESTORE: Erro ao atualizar configurações: $e');
      // Não lançar erro para não quebrar o app
    }
  }

  /// Salvar dados de premium do usuário
  Future<void> updatePremiumData({
    required bool isPremium,
    String? currentPlan,
    DateTime? premiumExpiryDate,
  }) async {
    if (userId == null) return;

    final updateData = <String, dynamic>{
      'isPremium': isPremium,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (currentPlan != null) updateData['currentPlan'] = currentPlan;
    if (premiumExpiryDate != null) {
      updateData['premiumExpiryDate'] = Timestamp.fromDate(premiumExpiryDate);
    }

    await _firestore.collection('users').doc(userId).update(updateData);
  }

  /// Salvar transação no Firestore
  Future<void> saveTransaction(TransactionModel transaction) async {
    if (userId == null) {
      debugPrint('❌ FIRESTORE: UserId é null, não é possível salvar transação');
      return;
    }

    try {
      debugPrint(
        '🔥 FIRESTORE: Salvando transação: ${transaction.title} - R\$ ${transaction.amount}',
      );

      final transactionData = {
        'id': transaction.id,
        'title': transaction.title,
        'amount': transaction.amount,
        'type': transaction.type.name,
        'categoryId': transaction.categoryId,
        'date': Timestamp.fromDate(transaction.date),
        'description': transaction.description,
        'isRecurring': transaction.isRecurring,
        'recurringType': transaction.recurringType?.name,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .doc(transaction.id)
          .set(transactionData);

      debugPrint('✅ FIRESTORE: Transação salva com sucesso!');
    } catch (e) {
      debugPrint('❌ FIRESTORE: Erro ao salvar transação: $e');
      // Não lançar erro para não quebrar o app
    }
  }

  /// Obter transações do usuário
  Future<List<TransactionModel>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
    TransactionType? type,
  }) async {
    if (userId == null) return [];

    try {
      Query query = _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .orderBy('date', descending: true);

      if (startDate != null) {
        query = query.where(
          'date',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
        );
      }

      if (endDate != null) {
        query = query.where(
          'date',
          isLessThanOrEqualTo: Timestamp.fromDate(endDate),
        );
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => _transactionFromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint('❌ FIRESTORE: Erro ao obter transações: $e');
      return [];
    }
  }

  /// Converter documento do Firestore para TransactionModel
  TransactionModel _transactionFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return TransactionModel(
      id: data['id'],
      title: data['title'],
      amount: data['amount'],
      type: TransactionType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => TransactionType.expense,
      ),
      categoryId: data['categoryId'],
      date: (data['date'] as Timestamp).toDate(),
      description: data['description'],
      isRecurring: data['isRecurring'] ?? false,
      recurringType: data['recurringType'] != null
          ? RecurringType.values.firstWhere(
              (e) => e.name == data['recurringType'],
              orElse: () => RecurringType.monthly,
            )
          : null,
    );
  }

  /// Deletar transação
  Future<void> deleteTransaction(String transactionId) async {
    if (userId == null) return;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .doc(transactionId)
        .delete();
  }

  /// Salvar categoria no Firestore
  Future<void> saveCategory(CategoryModel category) async {
    if (userId == null) return;

    final categoryData = {
      'id': category.id,
      'name': category.name,
      'icon': category.icon,
      'color': category.color.toARGB32(),
      'type': category.type.name,
      'isDefault': category.isDefault,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('categories')
        .doc(category.id)
        .set(categoryData);
  }

  /// Obter categorias do usuário
  Future<List<CategoryModel>> getCategories({TransactionType? type}) async {
    if (userId == null) return [];

    Query query = _firestore
        .collection('users')
        .doc(userId)
        .collection('categories')
        .orderBy('createdAt');

    if (type != null) {
      query = query.where('type', isEqualTo: type.name);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => _categoryFromFirestore(doc)).toList();
  }

  /// Converter documento do Firestore para Category
  CategoryModel _categoryFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return CategoryModel(
      id: data['id'],
      name: data['name'],
      icon: data['icon'],
      color: Color(data['color']),
      type: CategoryType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => CategoryType.expense,
      ),
      isDefault: data['isDefault'] ?? false,
    );
  }

  /// Deletar categoria
  Future<void> deleteCategory(String categoryId) async {
    if (userId == null) return;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('categories')
        .doc(categoryId)
        .delete();
  }

  /// Sincronizar dados locais com Firestore
  Future<void> syncData({
    required List<TransactionModel> transactions,
    required List<CategoryModel> categories,
  }) async {
    if (userId == null) return;

    final batch = _firestore.batch();

    // Sincronizar transações
    for (final transaction in transactions) {
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .doc(transaction.id);

      final transactionData = {
        'id': transaction.id,
        'title': transaction.title,
        'amount': transaction.amount,
        'type': transaction.type.name,
        'categoryId': transaction.categoryId,
        'date': Timestamp.fromDate(transaction.date),
        'description': transaction.description,
        'isRecurring': transaction.isRecurring,
        'recurringType': transaction.recurringType?.name,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      batch.set(docRef, transactionData, SetOptions(merge: true));
    }

    // Sincronizar categorias
    for (final category in categories) {
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('categories')
          .doc(category.id);

      final categoryData = {
        'id': category.id,
        'name': category.name,
        'icon': category.icon,
        'color': category.color.toARGB32(),
        'type': category.type.name,
        'isDefault': category.isDefault,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      batch.set(docRef, categoryData, SetOptions(merge: true));
    }

    await batch.commit();
  }

  /// Atualizar último login do usuário
  Future<void> updateLastLogin() async {
    if (userId == null) return;

    try {
      debugPrint('🔥 FIRESTORE: Tentando atualizar último login...');
      await _firestore.collection('users').doc(userId).update({
        'lastLogin': FieldValue.serverTimestamp(),
      });
      debugPrint('✅ FIRESTORE: Último login atualizado com sucesso');
    } catch (e) {
      debugPrint('❌ FIRESTORE: Erro ao atualizar último login: $e');
      // Se o documento não existir, criar com dados básicos
      try {
        await _firestore.collection('users').doc(userId).set({
          'lastLogin': FieldValue.serverTimestamp(),
          'uid': userId,
          'email': currentUser?.email,
        }, SetOptions(merge: true));
        debugPrint('✅ FIRESTORE: Documento criado com sucesso');
      } catch (firestoreError) {
        debugPrint('❌ FIRESTORE: Erro ao criar documento: $firestoreError');
        // Se Firestore não estiver disponível, continuar sem erro
        debugPrint(
          '⚠️ FIRESTORE: Continuando sem atualizar Firestore (API pode não estar habilitada)',
        );
      }
    }
  }

  /// Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Deletar conta do usuário
  Future<void> deleteAccount() async {
    if (userId == null) return;

    // Deletar dados do usuário
    final userDoc = _firestore.collection('users').doc(userId);
    await userDoc.collection('transactions').get().then((snapshot) {
      for (final doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
    await userDoc.collection('categories').get().then((snapshot) {
      for (final doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
    await userDoc.delete();

    // Deletar conta do Firebase Auth
    await currentUser?.delete();
  }

  /// Verificar se o usuário atual está logado com Google
  bool get isSignedInWithGoogle {
    final user = currentUser;
    if (user == null) return false;

    // Verificar se algum dos provedores de autenticação é Google
    return user.providerData.any(
      (userInfo) => userInfo.providerId == 'google.com',
    );
  }

  /// Atualizar displayName do usuário
  Future<bool> updateDisplayName(String newDisplayName) async {
    final user = currentUser;
    if (user == null) return false;

    try {
      debugPrint('🔥 FIREBASE: Atualizando displayName para: $newDisplayName');

      // Atualizar no Firebase Auth
      await user.updateDisplayName(newDisplayName);
      await user.reload(); // Recarregar dados do usuário

      // Atualizar no Firestore também
      await _firestore.collection('users').doc(user.uid).update({
        'displayName': newDisplayName,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      debugPrint(
        '✅ FIREBASE: DisplayName atualizado com sucesso para: $newDisplayName',
      );
      return true;
    } catch (e) {
      debugPrint('❌ FIREBASE: Erro ao atualizar displayName: $e');
      return false;
    }
  }

  /// Atualizar displayName do usuário se necessário
  Future<void> updateDisplayNameIfNeeded() async {
    final user = currentUser;

    if (user == null) return;

    try {
      // Tentar obter nome do provedor Google
      if (isSignedInWithGoogle) {
        final googleUserInfo = user.providerData.firstWhere(
          (userInfo) => userInfo.providerId == 'google.com',
        );

        if (googleUserInfo.displayName != null &&
            googleUserInfo.displayName!.isNotEmpty) {
          // Atualizar o perfil do usuário no Firebase Auth
          await user.updateDisplayName(googleUserInfo.displayName);

          // Atualizar no Firestore também
          await _firestore.collection('users').doc(user.uid).update({
            'displayName': googleUserInfo.displayName,
            'updatedAt': FieldValue.serverTimestamp(),
          });

          debugPrint(
            '✅ FIREBASE: DisplayName atualizado para: ${googleUserInfo.displayName}',
          );
        }
      }
    } catch (e) {
      debugPrint('❌ FIREBASE: Erro ao atualizar displayName: $e');
    }
  }
}
