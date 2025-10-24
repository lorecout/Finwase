import 'package:flutter/foundation.dart';

/// Classe centralizada para logging que só mostra mensagens em modo debug
class Logger {
  static const bool _isDebug = kDebugMode;

  /// Log de informação geral
  static void log(String message) {
    if (_isDebug) debugPrint('ℹ️ $message');
  }

  /// Log de erro
  static void error(String message, [Object? error]) {
    if (_isDebug) debugPrint('❌ $message${error != null ? ': $error' : ''}');
  }

  /// Log de warning
  static void warning(String message) {
    if (_isDebug) debugPrint('⚠️ $message');
  }

  /// Log de sucesso
  static void success(String message) {
    if (_isDebug) debugPrint('✅ $message');
  }

  /// Log de inicialização de serviço
  static void service(String serviceName, String status) {
    if (_isDebug) debugPrint('🔧 $serviceName: $status');
  }
}
