import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Serviço para gerenciar configurações do aplicativo
class SettingsService extends ChangeNotifier {
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
    } catch (e) {
      debugPrint('Erro ao carregar configurações: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
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
