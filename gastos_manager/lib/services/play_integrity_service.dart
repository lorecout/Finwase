import 'package:firebase_app_check/firebase_app_check.dart';

/// Serviço para verificação de integridade do app usando Firebase App Check
/// (que usa Play Integrity API no Android)
class PlayIntegrityService {
  /// Inicializa o Firebase App Check
  static Future<void> initialize() async {
    try {
      await FirebaseAppCheck.instance.activate(
        // Para Android: usa Play Integrity API
        androidProvider: AndroidAppCheckProviderType.playIntegrity,
        // Para iOS: usa App Attest
        appleProvider: AppleAppCheckProviderType.appAttest,
        webProvider: ReCaptchaV3Provider('token'),
      );
      print('✅ Firebase App Check inicializado com Play Integrity API');
    } catch (e) {
      print('⚠️ App Check já está inicializado ou erro: $e');
    }
  }

  /// Verifica a integridade do app usando Firebase App Check
  static Future<bool> verifyAppIntegrity() async {
    try {
      final token = await FirebaseAppCheck.instance.getToken();

      if (token != null && token.isNotEmpty) {
        print('✅ App Check Token obtido com sucesso');
        return true;
      }
      print('❌ Falha ao obter App Check Token');
      return false;
    } catch (e) {
      print('❌ Erro ao verificar integridade: $e');
      return false;
    }
  }

  /// Obtém o token de integridade do Firebase App Check
  static Future<String?> getIntegrityToken() async {
    try {
      final token = await FirebaseAppCheck.instance.getToken();
      return token;
    } catch (e) {
      print('❌ Erro ao obter token: $e');
      return null;
    }
  }

  /// Verifica se o device é legítimo
  static Future<bool> isDeviceLegitimate() async {
    try {
      final token = await getIntegrityToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      print('⚠️ Erro ao validar device: $e');
      return false;
    }
  }

  /// Habilita auto-refresh de tokens
  static Future<void> enableTokenAutoRefresh() async {
    try {
      await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);
      print('✅ Auto-refresh de tokens habilitado');
    } catch (e) {
      print('❌ Erro ao habilitar auto-refresh: $e');
    }
  }
}
