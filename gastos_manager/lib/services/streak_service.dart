import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Serviço para gerenciar sequência de dias consecutivos de uso (streak)
class StreakService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late SharedPreferences _prefs;

  int _currentStreak = 0;
  int _bestStreak = 0;
  DateTime? _lastActivityDate;
  DateTime? _streakStartDate;
  bool _achievedToday = false;
  List<int> _unlockedBadges = [];

  // Getters
  int get currentStreak => _currentStreak;
  int get bestStreak => _bestStreak;
  DateTime? get lastActivityDate => _lastActivityDate;
  DateTime? get streakStartDate => _streakStartDate;
  bool get achievedToday => _achievedToday;
  List<int> get unlockedBadges => _unlockedBadges;

  /// Badges de milestone: 7, 30, 100, 365 dias
  static const Map<int, String> streakBadges = {
    7: '🔥 Semana de Fogo',
    30: '🌟 Mês Invicto',
    100: '💯 Centesimal',
    365: '👑 Mestre dos Hábitos',
  };

  /// Inicializar serviço
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadStreakData();
  }

  /// Registrar atividade do dia
  Future<void> recordActivity() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    // Se já registrou hoje, não fazer nada
    if (_lastActivityDate != null) {
      final lastDate = DateTime(
        _lastActivityDate!.year,
        _lastActivityDate!.month,
        _lastActivityDate!.day,
      );
      if (lastDate == todayDate) {
        return;
      }
    }

    // Verificar se quebrou a sequência
    bool streakContinues = false;
    if (_lastActivityDate != null) {
      final yesterday = DateTime(today.year, today.month, today.day - 1);
      final lastDate = DateTime(
        _lastActivityDate!.year,
        _lastActivityDate!.month,
        _lastActivityDate!.day,
      );
      streakContinues = lastDate == yesterday;
    } else {
      streakContinues = true; // Primeiro dia
    }

    if (streakContinues) {
      _currentStreak += 1;
      _streakStartDate ??= todayDate;
    } else {
      // Sequência quebrou
      if (_currentStreak > _bestStreak) {
        _bestStreak = _currentStreak;
      }
      _currentStreak = 1;
      _streakStartDate = todayDate;
    }

    _lastActivityDate = todayDate;
    _achievedToday = true;

    // Verificar milestones
    await _checkMilestones();

    // Salvar localmente
    await _saveStreakLocally();

    // Salvar no Firestore
    await _saveStreakToFirestore();

    notifyListeners();
  }

  /// Verificar se desbloqueou badges
  Future<void> _checkMilestones() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final milestones = [7, 30, 100, 365];

    for (final milestone in milestones) {
      if (_currentStreak == milestone && !_unlockedBadges.contains(milestone)) {
        _unlockedBadges.add(milestone);

        // Salvar milestone no Firestore
        await _firestore.collection('users').doc(user.uid).update({
          'streak_badges': FieldValue.arrayUnion([milestone]),
          'last_badge_unlocked_at': FieldValue.serverTimestamp(),
        });

        debugPrint('🏅 Badge desbloqueado: ${streakBadges[milestone]}');
      }
    }
  }

  /// Obter mensagem motivacional baseada no streak
  String getMotivationalMessage() {
    if (_currentStreak == 0) {
      return '🚀 Comece sua jornada hoje! Primeira atividade = primeiro passo.';
    } else if (_currentStreak < 7) {
      return '💪 Você está crescendo! $_currentStreak dias - falta pouco para a primeira semana!';
    } else if (_currentStreak < 30) {
      return '🔥 Sequência incrível! $_currentStreak dias - continue assim!';
    } else if (_currentStreak < 100) {
      return '⚡ Você é uma máquina! $_currentStreak dias já - rumo ao centesimal!';
    } else if (_currentStreak < 365) {
      return '👑 Lendário! $_currentStreak dias - quase um ano invicto!';
    } else {
      return '🌟 MESTRE DOS HÁBITOS! $_currentStreak dias consecutivos!';
    }
  }

  /// Obter porcentagem de progresso até próximo milestone
  double getProgressToNextMilestone() {
    final milestones = [7, 30, 100, 365];
    int nextMilestone = 365;

    for (final milestone in milestones) {
      if (_currentStreak < milestone) {
        nextMilestone = milestone;
        break;
      }
    }

    if (_currentStreak >= 365) return 1.0;
    return _currentStreak / nextMilestone;
  }

  /// Obter próximo milestone
  int getNextMilestone() {
    final milestones = [7, 30, 100, 365];
    for (final milestone in milestones) {
      if (_currentStreak < milestone) {
        return milestone;
      }
    }
    return 365;
  }

  /// Carregar dados de streak
  Future<void> _loadStreakData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // Carregar do SharedPreferences primeiro
      _currentStreak = _prefs.getInt('current_streak') ?? 0;
      _bestStreak = _prefs.getInt('best_streak') ?? 0;
      final lastActivityString = _prefs.getString('last_activity_date');
      if (lastActivityString != null) {
        _lastActivityDate = DateTime.parse(lastActivityString);
      }
      final streakStartString = _prefs.getString('streak_start_date');
      if (streakStartString != null) {
        _streakStartDate = DateTime.parse(streakStartString);
      }
      _unlockedBadges =
          _prefs.getStringList('streak_badges')?.map(int.parse).toList() ?? [];

      // Verificar se já registrou atividade hoje
      if (_lastActivityDate != null) {
        final today = DateTime.now();
        final todayDate = DateTime(today.year, today.month, today.day);
        final lastDate = DateTime(
          _lastActivityDate!.year,
          _lastActivityDate!.month,
          _lastActivityDate!.day,
        );
        _achievedToday = lastDate == todayDate;
      }

      // Buscar dados mais recentes do Firestore
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        final data = userDoc.data();
        _currentStreak = (data?['current_streak'] as int?) ?? _currentStreak;
        _bestStreak = (data?['best_streak'] as int?) ?? _bestStreak;

        final badges = (data?['streak_badges'] as List<dynamic>?) ?? [];
        _unlockedBadges = badges.cast<int>();

        final lastActivityTs = data?['last_activity_date'] as Timestamp?;
        if (lastActivityTs != null) {
          _lastActivityDate = lastActivityTs.toDate();
        }

        final streakStartTs = data?['streak_start_date'] as Timestamp?;
        if (streakStartTs != null) {
          _streakStartDate = streakStartTs.toDate();
        }
      }

      // Verificar se sequência não quebrou (caso do app aberto em dias diferentes)
      await _validateStreak();

      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao carregar streak: $e');
    }
  }

  /// Validar se a sequência deveria ter quebrado
  Future<void> _validateStreak() async {
    if (_lastActivityDate == null) return;

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final lastDate = DateTime(
      _lastActivityDate!.year,
      _lastActivityDate!.month,
      _lastActivityDate!.day,
    );

    // Se a última atividade foi há mais de 1 dia, quebrou a sequência
    if (todayDate.difference(lastDate).inDays > 1) {
      if (_currentStreak > _bestStreak) {
        _bestStreak = _currentStreak;
      }
      _currentStreak = 0;
      _streakStartDate = null;
      await _saveStreakLocally();
    }
  }

  /// Salvar dados localmente
  Future<void> _saveStreakLocally() async {
    await _prefs.setInt('current_streak', _currentStreak);
    await _prefs.setInt('best_streak', _bestStreak);
    if (_lastActivityDate != null) {
      await _prefs.setString(
        'last_activity_date',
        _lastActivityDate!.toIso8601String(),
      );
    }
    if (_streakStartDate != null) {
      await _prefs.setString(
        'streak_start_date',
        _streakStartDate!.toIso8601String(),
      );
    }
    await _prefs.setStringList(
      'streak_badges',
      _unlockedBadges.map((e) => e.toString()).toList(),
    );
  }

  /// Salvar no Firestore
  Future<void> _saveStreakToFirestore() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection('users').doc(user.uid).set({
        'current_streak': _currentStreak,
        'best_streak': _bestStreak,
        'last_activity_date': _lastActivityDate,
        'streak_start_date': _streakStartDate,
        'streak_badges': _unlockedBadges,
        'last_streak_update': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Erro ao salvar streak no Firestore: $e');
    }
  }

  /// Reset do streak (para testes)
  Future<void> resetStreak() async {
    _currentStreak = 0;
    _bestStreak = 0;
    _lastActivityDate = null;
    _streakStartDate = null;
    _achievedToday = false;
    _unlockedBadges.clear();
    await _saveStreakLocally();
    await _saveStreakToFirestore();
    notifyListeners();
  }
}
