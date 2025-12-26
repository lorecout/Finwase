import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PremiumService extends ChangeNotifier {
  // Lista de emails de administradores
  static const List<String> _adminEmails = [
    'lorenalessa90@gmail.com', // Sua conta
    'admin@finwise.com', // Email de backup admin
  ];

  bool _isPremium = true; // SEMPRE PREMIUM - GRATUITO TOTAL
  String _currentPlan = 'free';
  DateTime? _premiumExpiryDate;
  bool _isAdminModeActive = false; // Controle do modo admin
  bool _hasHadTrial = false; // Mantido para compatibilidade, mas não usado
  DateTime? _trialGrantedAt; // Mantido para compatibilidade, mas não usado

  // Valor fixo do plano premium
  static const double premiumPrice = 9.90;

  // Getters públicos
  // NOTA: isPremium sempre retorna true porque FORCE_PREMIUM está ativado em config.dart
  bool get isPremium => true; // Todos os usuários são premium
  String get currentPlan => _currentPlan;
  DateTime? get premiumExpiryDate => _premiumExpiryDate;
  bool get hasHadTrial => _hasHadTrial;
  DateTime? get trialGrantedAt => _trialGrantedAt;

  // Verificar se o usuário atual é administrador
  bool get isAdmin {
    final user = FirebaseAuth.instance.currentUser;
    if (user?.email == null) return false;
    return _adminEmails.contains(user!.email!.toLowerCase());
  }

  bool get isAdminModeActive => _isAdminModeActive;

  // Carregar dados do usuário do Firestore
  Future<void> loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _resetToDefault();
      notifyListeners();
      return;
    }

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data()!;

        // Carregar status premium - SEMPRE PREMIUM NO MODO GRATUITO TOTAL
        _isPremium = true; // FORCE_PREMIUM ativo
        _currentPlan = data['currentPlan'] ?? 'free';

        // Carregar data de expiração
        if (data['premiumExpiryDate'] != null) {
          _premiumExpiryDate = (data['premiumExpiryDate'] as Timestamp)
              .toDate();
        } else {
          _premiumExpiryDate = null;
        }

        // Carregar dados do trial (desabilitado)
        // _hasHadTrial = data['hasHadTrial'] ?? false;
        // if (data['trialGrantedAt'] != null) {
        //   _trialGrantedAt = (data['trialGrantedAt'] as Timestamp).toDate();
        // } else {
        //   _trialGrantedAt = null;
        // }

        // Verificar se o trial ainda é válido (desabilitado)
        // if (_hasHadTrial && _trialGrantedAt != null) {
        //   final trialExpiry = _trialGrantedAt!.add(const Duration(days: 7));
        //   if (DateTime.now().isBefore(trialExpiry) && !_isPremium) {
        //     _isPremium = true;
        //     _currentPlan = 'trial';
        //     _premiumExpiryDate = trialExpiry;
        //   }
        // }
      } else {
        _resetToDefault();
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao carregar dados do usuário: $e');
      _resetToDefault();
      notifyListeners();
    }
  }

  // Resetar para valores padrão
  void _resetToDefault() {
    _isPremium = false;
    _currentPlan = 'free';
    _premiumExpiryDate = null;
    _hasHadTrial = false;
    _trialGrantedAt = null;
  }

  // Métodos exclusivos para administradores
  void toggleAdminPremiumMode() {
    if (!isAdmin) return;
    _isAdminModeActive = !_isAdminModeActive;
    notifyListeners();
  }

  void setAdminPremiumStatus(bool premium) {
    if (!isAdmin) return;
    _isAdminModeActive = premium;
    notifyListeners();
  }

  // Simulação de upgrade para premium
  void upgradeToPremium(String plan) {
    try {
      _isPremium = true;
      _currentPlan = plan;
      _premiumExpiryDate = DateTime.now().add(
        const Duration(days: 30),
      ); // 30 dias de teste
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao fazer upgrade para premium: $e');
      // Manter estado anterior em caso de erro
    }
  }

  // Simulação de downgrade
  void downgradeToFree() {
    try {
      _isPremium = false;
      _currentPlan = 'free';
      _premiumExpiryDate = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao fazer downgrade: $e');
      // Manter estado anterior em caso de erro
    }
  }

  // Verificar se o premium ainda é válido
  bool get isPremiumValid {
    if (!_isPremium) return false;
    if (_premiumExpiryDate == null) return true;
    return DateTime.now().isBefore(_premiumExpiryDate!);
  }

  // Verificar se está próximo do vencimento (7 dias)
  bool get isNearExpiry {
    if (!isPremiumValid || _premiumExpiryDate == null) return false;
    final daysLeft = _premiumExpiryDate!.difference(DateTime.now()).inDays;
    return daysLeft <= 7 && daysLeft > 0;
  }

  // Dias restantes de premium
  int get daysLeft {
    if (_premiumExpiryDate == null) return 0;
    return _premiumExpiryDate!.difference(DateTime.now()).inDays;
  }

  // Obter mensagem de status premium
  String getStatusMessage() {
    final user = FirebaseAuth.instance.currentUser;

    // Se for visitante, incentivar login
    if (user == null) {
      return '🔑 Faça login para sincronizar seus dados e acessar recursos Premium!';
    }

    if (!isPremiumValid) {
      return 'Desbloqueie recursos avançados com o plano Premium!';
    }

    if (isNearExpiry) {
      return 'Seu premium expira em $daysLeft dias. Renove agora para não perder os benefícios!';
    }

    if (_isPremium) {
      return 'Premium ativo - Expira em $daysLeft dias';
    }

    return 'Atualize para premium e desbloqueie recursos avançados!';
  }

  // Verificar se deve mostrar alerta
  bool get shouldShowAlert {
    // Só mostrar alerta se o usuário já teve premium e agora expirou ou está próximo do vencimento
    if (hasEverBeenPremium) {
      return !isPremiumValid || isNearExpiry;
    }
    // Para usuários que nunca assinaram, não mostrar alerta
    return false;
  }

  // Verificar se o usuário já teve premium alguma vez
  bool get hasEverBeenPremium {
    return _premiumExpiryDate != null || _currentPlan != 'free';
  }

  // Obter cor baseada no status
  Color getStatusColor() {
    final user = FirebaseAuth.instance.currentUser;

    // Se for visitante, usar cor de destaque para login
    if (user == null) return Colors.amber;

    if (!isPremiumValid) return Colors.red;
    if (isNearExpiry) return Colors.orange;
    if (_isPremium) return Colors.green;
    return Colors.blue;
  }

  // Obter ícone baseado no status
  IconData getStatusIcon() {
    final user = FirebaseAuth.instance.currentUser;

    // Se for visitante, mostrar ícone de login
    if (user == null) return Icons.login;

    if (!isPremiumValid) return Icons.warning;
    if (isNearExpiry) return Icons.schedule;
    if (_isPremium) return Icons.verified;
    return Icons.star_border;
  }

  // Confirmar assinatura premium
  Future<void> confirmPremiumSubscription() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // Marcar que o upgrade foi feito
      upgradeToPremium('premium');

      debugPrint('Assinatura premium confirmada para ${user.uid}');
    } catch (e) {
      debugPrint('Erro ao confirmar assinatura premium: $e');
    }
  }

  // ========== MÉTODOS ADMINISTRATIVOS ==========

  /// Conceder premium manualmente para qualquer usuário (apenas admins)
  Future<bool> adminGrantPremium({
    required String userId,
    required int days,
    String plan = 'admin',
    String? reason,
  }) async {
    if (!isAdmin) {
      debugPrint('❌ ADMIN: Acesso negado - usuário não é administrador');
      return false;
    }

    try {
      final now = DateTime.now();
      final expiryDate = now.add(Duration(days: days));

      // Verificar se o usuário já tem premium ativo
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      DateTime finalExpiryDate = expiryDate;
      if (userDoc.exists) {
        final data = userDoc.data()!;
        final existingExpiry = data['premiumExpiryDate'] != null
            ? (data['premiumExpiryDate'] as Timestamp).toDate()
            : null;

        // Se já tem premium ativo, estender a partir da data atual de expiração
        if (existingExpiry != null && existingExpiry.isAfter(now)) {
          finalExpiryDate = existingExpiry.add(Duration(days: days));
        }
      }

      // Atualizar dados no Firestore
      final updateData = {
        'isPremium': true,
        'currentPlan': plan,
        'premiumExpiryDate': Timestamp.fromDate(finalExpiryDate),
        'adminGrantedAt': Timestamp.fromDate(now),
        'adminGrantedBy': FirebaseAuth.instance.currentUser?.uid,
        'adminReason': reason,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update(updateData);

      // Se for o próprio usuário admin, atualizar estado local
      if (userId == FirebaseAuth.instance.currentUser?.uid) {
        _isPremium = true;
        _currentPlan = plan;
        _premiumExpiryDate = finalExpiryDate;
        notifyListeners();
      }

      debugPrint(
        '✅ ADMIN: Premium concedido para $userId por $days dias (expira em: $finalExpiryDate)',
      );
      return true;
    } catch (e) {
      debugPrint('❌ ADMIN: Erro ao conceder premium: $e');
      return false;
    }
  }

  /// Remover premium de um usuário (apenas admins)
  Future<bool> adminRemovePremium(String userId, {String? reason}) async {
    if (!isAdmin) {
      debugPrint('❌ ADMIN: Acesso negado - usuário não é administrador');
      return false;
    }

    try {
      final updateData = {
        'isPremium': false,
        'currentPlan': 'free',
        'premiumExpiryDate': null,
        'adminRemovedAt': FieldValue.serverTimestamp(),
        'adminRemovedBy': FirebaseAuth.instance.currentUser?.uid,
        'adminRemoveReason': reason,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update(updateData);

      // Se for o próprio usuário admin, atualizar estado local
      if (userId == FirebaseAuth.instance.currentUser?.uid) {
        _isPremium = false;
        _currentPlan = 'free';
        _premiumExpiryDate = null;
        notifyListeners();
      }

      debugPrint('✅ ADMIN: Premium removido de $userId');
      return true;
    } catch (e) {
      debugPrint('❌ ADMIN: Erro ao remover premium: $e');
      return false;
    }
  }

  /// Estender premium existente (apenas admins)
  Future<bool> adminExtendPremium(
    String userId,
    int additionalDays, {
    String? reason,
  }) async {
    if (!isAdmin) {
      debugPrint('❌ ADMIN: Acesso negado - usuário não é administrador');
      return false;
    }

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (!userDoc.exists) {
        debugPrint('❌ ADMIN: Usuário não encontrado');
        return false;
      }

      final data = userDoc.data()!;
      final currentExpiry = data['premiumExpiryDate'] != null
          ? (data['premiumExpiryDate'] as Timestamp).toDate()
          : null;

      final now = DateTime.now();
      DateTime newExpiryDate;

      if (currentExpiry != null && currentExpiry.isAfter(now)) {
        // Estender a partir da data atual de expiração
        newExpiryDate = currentExpiry.add(Duration(days: additionalDays));
      } else {
        // Conceder novo período a partir de agora
        newExpiryDate = now.add(Duration(days: additionalDays));
      }

      final updateData = {
        'isPremium': true,
        'premiumExpiryDate': Timestamp.fromDate(newExpiryDate),
        'adminExtendedAt': FieldValue.serverTimestamp(),
        'adminExtendedBy': FirebaseAuth.instance.currentUser?.uid,
        'adminExtendReason': reason,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update(updateData);

      // Se for o próprio usuário admin, atualizar estado local
      if (userId == FirebaseAuth.instance.currentUser?.uid) {
        _isPremium = true;
        _premiumExpiryDate = newExpiryDate;
        notifyListeners();
      }

      debugPrint(
        '✅ ADMIN: Premium estendido para $userId (+$additionalDays dias, expira em: $newExpiryDate)',
      );
      return true;
    } catch (e) {
      debugPrint('❌ ADMIN: Erro ao estender premium: $e');
      return false;
    }
  }

  /// Obter informações de um usuário (apenas admins)
  Future<Map<String, dynamic>?> adminGetUserInfo(String userId) async {
    if (!isAdmin) return null;

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (!userDoc.exists) return null;

      final data = userDoc.data()!;
      return {
        'uid': userId,
        'email': data['email'],
        'displayName': data['displayName'],
        'isPremium': data['isPremium'] ?? false,
        'currentPlan': data['currentPlan'] ?? 'free',
        'premiumExpiryDate': data['premiumExpiryDate'] != null
            ? (data['premiumExpiryDate'] as Timestamp).toDate()
            : null,
        'hasHadTrial': data['hasHadTrial'] ?? false,
        'trialGrantedAt': data['trialGrantedAt'] != null
            ? (data['trialGrantedAt'] as Timestamp).toDate()
            : null,
        'createdAt': data['createdAt'] != null
            ? (data['createdAt'] as Timestamp).toDate()
            : null,
        'lastLogin': data['lastLogin'] != null
            ? (data['lastLogin'] as Timestamp).toDate()
            : null,
      };
    } catch (e) {
      debugPrint('❌ ADMIN: Erro ao obter informações do usuário: $e');
      return null;
    }
  }

  /// Listar usuários premium (apenas admins)
  Future<List<Map<String, dynamic>>> adminListPremiumUsers() async {
    if (!isAdmin) return [];

    try {
      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('isPremium', isEqualTo: true)
          .get();

      return query.docs.map((doc) {
        final data = doc.data();
        return {
          'uid': doc.id,
          'email': data['email'],
          'displayName': data['displayName'],
          'currentPlan': data['currentPlan'] ?? 'free',
          'premiumExpiryDate': data['premiumExpiryDate'] != null
              ? (data['premiumExpiryDate'] as Timestamp).toDate()
              : null,
          'createdAt': data['createdAt'] != null
              ? (data['createdAt'] as Timestamp).toDate()
              : null,
        };
      }).toList();
    } catch (e) {
      debugPrint('❌ ADMIN: Erro ao listar usuários premium: $e');
      return [];
    }
  }

  // ========== RECURSOS PREMIUM TEMPORÁRIOS ==========

  /// Conceder acesso premium temporário via anúncio recompensado
  void grantTemporaryPremium({int minutes = 60}) {
    final expiryDate = DateTime.now().add(Duration(minutes: minutes));

    _isPremium = true;
    _currentPlan = 'rewarded';
    _premiumExpiryDate = expiryDate;

    notifyListeners();

    debugPrint(
      '🎁 PREMIUM TEMPORÁRIO: Concedido por $minutes minutos (expira em: $expiryDate)',
    );

    // Agendar remoção automática do premium temporário
    Future.delayed(Duration(minutes: minutes), () {
      if (_currentPlan == 'rewarded') {
        downgradeToFree();
        debugPrint('⏰ PREMIUM TEMPORÁRIO: Expirado automaticamente');
      }
    });
  }

  /// Verificar se está em modo premium temporário
  bool get isTemporaryPremium => _currentPlan == 'rewarded';

  /// Método para simular a compra do plano premium por R$ 9,90
  Future<bool> comprarPremium() async {
    _isPremium = true;
    _currentPlan = 'premium';
    _premiumExpiryDate = DateTime.now().add(const Duration(days: 365));
    notifyListeners();
    return true;
  }
}
