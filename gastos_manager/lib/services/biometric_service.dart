import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Serviço para autenticação biométrica
class BiometricService {
  static final LocalAuthentication _auth = LocalAuthentication();
  static const String _biometricEnabledKey = 'biometric_enabled';

  /// Verifica se o dispositivo suporta biometria
  static Future<bool> isDeviceSupported() async {
    try {
      return await _auth.isDeviceSupported();
    } catch (e) {
      debugPrint('❌ BIOMETRIC: Erro ao verificar suporte: $e');
      return false;
    }
  }

  /// Verifica se há biometria configurada no dispositivo
  static Future<bool> canCheckBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } catch (e) {
      debugPrint('❌ BIOMETRIC: Erro ao verificar biometria: $e');
      return false;
    }
  }

  /// Obtém a lista de biometrias disponíveis
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      debugPrint('❌ BIOMETRIC: Erro ao obter biometrias: $e');
      return [];
    }
  }

  /// Verifica se a biometria está ativada nas configurações do app
  static Future<bool> isBiometricEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_biometricEnabledKey) ?? false;
    } catch (e) {
      debugPrint('❌ BIOMETRIC: Erro ao verificar configuração: $e');
      return false;
    }
  }

  /// Autentica o usuário usando biometria
  static Future<bool> authenticate({
    String localizedReason = 'Use sua biometria para acessar o app',
  }) async {
    try {
      // Verificar se o dispositivo suporta
      final isSupported = await isDeviceSupported();
      if (!isSupported) {
        debugPrint('⚠️ BIOMETRIC: Dispositivo não suporta biometria');
        return true; // Permitir acesso se não suporta
      }

      // Verificar se pode usar biometria
      final canCheck = await canCheckBiometrics();
      if (!canCheck) {
        debugPrint('⚠️ BIOMETRIC: Nenhuma biometria configurada');
        return true; // Permitir acesso se não tem biometria configurada
      }

      // Usar a forma compatível com local_auth 2.x
      bool authenticated = false;
      try {
        authenticated = await _auth.authenticate(
          localizedReason: localizedReason,
          biometricOnly: true,
        );
      } catch (e) {
        debugPrint('❌ BIOMETRIC: authenticate falhou: $e');
        return true; // permitir acesso em caso de incompatibilidade
      }

      debugPrint(
        authenticated
            ? '✅ BIOMETRIC: Autenticação bem-sucedida'
            : '❌ BIOMETRIC: Autenticação falhou',
      );

      return authenticated;
    } on PlatformException catch (e) {
      debugPrint('❌ BIOMETRIC: Erro de plataforma: ${e.message}');
      return true;
    } catch (e) {
      debugPrint('❌ BIOMETRIC: Erro inesperado: $e');
      return true;
    }
  }

  /// Verifica se deve solicitar biometria (está ativada e dispositivo suporta)
  static Future<bool> shouldRequestBiometric() async {
    final isEnabled = await isBiometricEnabled();
    if (!isEnabled) return false;

    final isSupported = await isDeviceSupported();
    if (!isSupported) return false;

    final canCheck = await canCheckBiometrics();
    return canCheck;
  }
}
