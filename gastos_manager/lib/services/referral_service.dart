import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

/// Serviço para gerenciar o programa de referência (indicação)
class ReferralService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late SharedPreferences _prefs;

  String? _referralCode;
  int _referredUsers = 0;
  int _premiumMonthsEarned = 0;
  bool _isPremiumFromReferral = false;
  DateTime? _premiumExpiryFromReferral;

  // Getters
  String? get referralCode => _referralCode;
  int get referredUsers => _referredUsers;
  int get premiumMonthsEarned => _premiumMonthsEarned;
  bool get isPremiumFromReferral => _isPremiumFromReferral;
  DateTime? get premiumExpiryFromReferral => _premiumExpiryFromReferral;

  /// Inicializar o serviço de referência
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadReferralData();
  }

  /// Gerar código de referência único para o usuário (se não tiver)
  Future<String> generateReferralCode() async {
    final user = _auth.currentUser;
    if (user == null) return '';

    // Verificar se já tem código
    if (_referralCode != null && _referralCode!.isNotEmpty) {
      return _referralCode!;
    }

    // Gerar novo código (8 caracteres alfanuméricos)
    final random = Random();
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    String code = '';
    for (int i = 0; i < 8; i++) {
      code += characters[random.nextInt(characters.length)];
    }

    // Adicionar prefixo com primeiras letras do nome
    final namePart =
        user.email?.split('@')[0].substring(0, 2).toUpperCase() ?? 'XX';
    code = '$namePart$code';

    // Salvar no Firestore e SharedPreferences
    _referralCode = code;
    await _prefs.setString('referral_code', code);

    try {
      await _firestore.collection('users').doc(user.uid).set({
        'referral_code': code,
        'created_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Erro ao salvar código de referência: $e');
    }

    notifyListeners();
    return code;
  }

  /// Usar um código de referência para ganhar premium
  Future<bool> redeemReferralCode(String code) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    try {
      // Verificar se o código existe
      final query = await _firestore
          .collection('users')
          .where('referral_code', isEqualTo: code)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        debugPrint('Código de referência inválido: $code');
        return false;
      }

      final referrerId = query.docs.first.id;

      // Não permitir resgatar o próprio código
      if (referrerId == user.uid) {
        debugPrint('Não pode usar o próprio código de referência');
        return false;
      }

      // Verificar se já resgatou um código
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists && userDoc.data()?['referrer_id'] != null) {
        debugPrint('Usuário já resgatou um código de referência');
        return false;
      }

      // Salvar a referência
      await _firestore.collection('users').doc(user.uid).set({
        'referrer_id': referrerId,
        'referral_used_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Conceder 1 mês de premium ao novo usuário
      final expiryDate = DateTime.now().add(Duration(days: 30));
      await _firestore.collection('users').doc(user.uid).set({
        'premium_until_referral': expiryDate,
        'premium_from_referral': true,
      }, SetOptions(merge: true));

      // Atualizar dados do indicador (referrer)
      await _firestore.collection('users').doc(referrerId).update({
        'referred_users': FieldValue.increment(1),
        'premium_months_earned': FieldValue.increment(1),
      });

      // Se o indicador atingiu 5 referências, conceder 1 mês de premium adicional
      final referrerDoc = await _firestore
          .collection('users')
          .doc(referrerId)
          .get();
      final referredCount =
          (referrerDoc.data()?['referred_users'] as int?) ?? 0;

      if (referredCount % 5 == 0) {
        final referrerPremiumExpiry =
            referrerDoc.data()?['premium_until'] as Timestamp?;
        final newExpiry = (referrerPremiumExpiry?.toDate() ?? DateTime.now())
            .add(Duration(days: 30));
        await _firestore.collection('users').doc(referrerId).set({
          'premium_until': newExpiry,
          'last_referral_bonus_at': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      // Salvar localmente
      _premiumExpiryFromReferral = expiryDate;
      _isPremiumFromReferral = true;
      await _prefs.setString(
        'premium_expiry_from_referral',
        expiryDate.toIso8601String(),
      );
      await _prefs.setBool('is_premium_from_referral', true);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Erro ao resgatar código de referência: $e');
      return false;
    }
  }

  /// Compartilhar código de referência (gera link/texto para compartilhar)
  String getShareMessage() {
    return '''
🎁 **FinWise - Ganhe Premium!**

Ei! Estou usando o FinWise para gerenciar minhas finanças e adorei! 💰

Use meu código de referência: **$_referralCode**

Você ganha 1 mês de Premium grátis, e eu também ganho recompensas! 🚀

Baixe agora: [link da app store]
''';
  }

  /// Carregar dados de referência do storage local e Firestore
  Future<void> _loadReferralData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // Carregar do SharedPreferences primeiro (rápido)
      _referralCode = _prefs.getString('referral_code');
      _isPremiumFromReferral =
          _prefs.getBool('is_premium_from_referral') ?? false;
      final expiryString = _prefs.getString('premium_expiry_from_referral');
      if (expiryString != null) {
        _premiumExpiryFromReferral = DateTime.parse(expiryString);
      }

      // Buscar dados mais recentes do Firestore
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        final data = userDoc.data();
        _referralCode = data?['referral_code'] ?? _referralCode;
        _referredUsers = (data?['referred_users'] as int?) ?? 0;
        _premiumMonthsEarned = (data?['premium_months_earned'] as int?) ?? 0;

        // Verificar se ainda está com premium da referência
        final premiumUntil = data?['premium_until_referral'] as Timestamp?;
        if (premiumUntil != null) {
          _premiumExpiryFromReferral = premiumUntil.toDate();
          _isPremiumFromReferral = _premiumExpiryFromReferral!.isAfter(
            DateTime.now(),
          );
        }
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao carregar dados de referência: $e');
    }
  }

  /// Verificar se premium da referência expirou
  bool checkPremiumExpiry() {
    if (_premiumExpiryFromReferral == null) return false;

    final hasExpired = _premiumExpiryFromReferral!.isBefore(DateTime.now());
    if (hasExpired) {
      _isPremiumFromReferral = false;
      notifyListeners();
    }
    return !hasExpired;
  }

  /// Obter dias restantes de premium por referência
  int getDaysRemainingFromReferral() {
    if (_premiumExpiryFromReferral == null) return 0;
    final remaining = _premiumExpiryFromReferral!
        .difference(DateTime.now())
        .inDays;
    return remaining > 0 ? remaining : 0;
  }
}
