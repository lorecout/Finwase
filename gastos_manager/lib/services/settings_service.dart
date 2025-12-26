import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Serviço para gerenciar configurações do aplicativo
class SettingsService extends ChangeNotifier {
  // Referências para serviços externos (injeção simples)
  void Function(String, bool)? onPreferenceChanged;
  // Chaves para preferências detalhadas de notificações
  static const String _alertBudget100Key = 'alert_budget_100';
  static const String _alertBudget90Key = 'alert_budget_90';
  static const String _alertBudget70Key = 'alert_budget_70';
  static const String _reminderTransactionsKey = 'reminder_transactions';
  static const String _reminderWeeklySummaryKey = 'reminder_weekly_summary';
  static const String _tipsEconomyKey = 'tips_economy';
  static const String _spendingPatternsKey = 'spending_patterns';
  static const String _promotionalOffersKey = 'promotional_offers';
  static const String _newBadgesKey = 'new_badges';

  // Estado das preferências detalhadas
  bool alertBudget100 = true;
  bool alertBudget90 = true;
  bool alertBudget70 = true;
  bool reminderTransactions = true;
  bool reminderWeeklySummary = true;
  bool tipsEconomy = true;
  bool spendingPatterns = true;
  bool promotionalOffers = true;
  bool newBadges = true;
  static const String _notificationsKey = 'notifications_enabled';
  static const String _darkModeKey = 'dark_mode_enabled';
  static const String _biometricKey = 'biometric_enabled';
  static const String _autoBackupKey = 'auto_backup_enabled';

  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _biometricEnabled = false;
  bool _autoBackupEnabled = true;
  bool _isLoading = false;

  // Getters
  bool get notificationsEnabled => _notificationsEnabled;
  bool get darkModeEnabled => _darkModeEnabled;
  bool get biometricEnabled => _biometricEnabled;
  bool get autoBackupEnabled => _autoBackupEnabled;
  bool get isLoading => _isLoading;

  /// Carrega as configurações salvas
  Future<void> loadSettings() async {
    _isLoading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      _notificationsEnabled = prefs.getBool(_notificationsKey) ?? true;
      _darkModeEnabled = prefs.getBool(_darkModeKey) ?? false;
      _biometricEnabled = prefs.getBool(_biometricKey) ?? false;
      _autoBackupEnabled = prefs.getBool(_autoBackupKey) ?? true;
      // Preferências detalhadas de notificações
      alertBudget100 = prefs.getBool(_alertBudget100Key) ?? true;
      alertBudget90 = prefs.getBool(_alertBudget90Key) ?? true;
      alertBudget70 = prefs.getBool(_alertBudget70Key) ?? true;
      reminderTransactions = prefs.getBool(_reminderTransactionsKey) ?? true;
      reminderWeeklySummary = prefs.getBool(_reminderWeeklySummaryKey) ?? true;
      tipsEconomy = prefs.getBool(_tipsEconomyKey) ?? true;
      spendingPatterns = prefs.getBool(_spendingPatternsKey) ?? true;
      promotionalOffers = prefs.getBool(_promotionalOffersKey) ?? true;
      newBadges = prefs.getBool(_newBadgesKey) ?? true;
    } catch (e) {
      debugPrint('Erro ao carregar configurações: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Métodos para atualizar preferências detalhadas
  Future<void> setNotificationPreference(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
    switch (key) {
      case _alertBudget100Key:
        alertBudget100 = value;
        onPreferenceChanged?.call('budget_alerts', value);
        break;
      case _alertBudget90Key:
        alertBudget90 = value;
        onPreferenceChanged?.call('budget_alerts', value);
        break;
      case _alertBudget70Key:
        alertBudget70 = value;
        onPreferenceChanged?.call('budget_alerts', value);
        break;
      case _reminderTransactionsKey:
        reminderTransactions = value;
        onPreferenceChanged?.call('reminder_transactions', value);
        break;
      case _reminderWeeklySummaryKey:
        reminderWeeklySummary = value;
        onPreferenceChanged?.call('reminder_weekly_summary', value);
        break;
      case _tipsEconomyKey:
        tipsEconomy = value;
        onPreferenceChanged?.call('tips_economy', value);
        break;
      case _spendingPatternsKey:
        spendingPatterns = value;
        onPreferenceChanged?.call('spending_patterns', value);
        break;
      case _promotionalOffersKey:
        promotionalOffers = value;
        onPreferenceChanged?.call('promotional', value);
        break;
      case _newBadgesKey:
        newBadges = value;
        onPreferenceChanged?.call('new_badges', value);
        break;
    }
    notifyListeners();
  }

  bool getNotificationPreference(String key) {
    switch (key) {
      case _alertBudget100Key:
        return alertBudget100;
      case _alertBudget90Key:
        return alertBudget90;
      case _alertBudget70Key:
        return alertBudget70;
      case _reminderTransactionsKey:
        return reminderTransactions;
      case _reminderWeeklySummaryKey:
        return reminderWeeklySummary;
      case _tipsEconomyKey:
        return tipsEconomy;
      case _spendingPatternsKey:
        return spendingPatterns;
      case _promotionalOffersKey:
        return promotionalOffers;
      case _newBadgesKey:
        return newBadges;
      default:
        return true;
    }
  }

  /// Ativa/desativa notificações
  Future<void> toggleNotifications(bool enabled) async {
    if (_notificationsEnabled == enabled) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_notificationsKey, enabled);

      _notificationsEnabled = enabled;
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao salvar configuração de notificações: $e');
    }
  }

  /// Ativa/desativa modo escuro
  Future<void> toggleDarkMode(bool enabled) async {
    if (_darkModeEnabled == enabled) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_darkModeKey, enabled);

      _darkModeEnabled = enabled;
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao salvar configuração de modo escuro: $e');
    }
  }

  /// Ativa/desativa autenticação biométrica
  Future<void> toggleBiometric(bool enabled) async {
    if (_biometricEnabled == enabled) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_biometricKey, enabled);

      _biometricEnabled = enabled;
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao salvar configuração biométrica: $e');
    }
  }

  /// Ativa/desativa backup automático
  Future<void> toggleAutoBackup(bool enabled) async {
    if (_autoBackupEnabled == enabled) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_autoBackupKey, enabled);

      _autoBackupEnabled = enabled;
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao salvar configuração de backup automático: $e');
    }
  }

  /// Reseta todas as configurações para os valores padrão
  Future<void> resetToDefaults() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_notificationsKey);
      await prefs.remove(_darkModeKey);
      await prefs.remove(_biometricKey);
      await prefs.remove(_autoBackupKey);

      _notificationsEnabled = true;
      _darkModeEnabled = false;
      _biometricEnabled = false;
      _autoBackupEnabled = true;

      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao resetar configurações: $e');
    }
  }
}
