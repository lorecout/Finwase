import 'package:flutter/foundation.dart';

class LoggingService {
  static final LoggingService _instance = LoggingService._internal();

  factory LoggingService() => _instance;

  LoggingService._internal();

  void info(String message, {String? tag}) {
    final tagPrefix = tag != null ? '[$tag] ' : '';
    debugPrint('ℹ️ $tagPrefix$message');
  }

  void error(dynamic error, StackTrace stackTrace, {String? tag}) {
    final tagPrefix = tag != null ? '[$tag] ' : '';
    debugPrint('❌ $tagPrefix$error\n$stackTrace');

    // Aqui você pode adicionar o envio do erro para o Crashlytics
    // FirebaseCrashlytics.instance.recordError(error, stackTrace);
  }

  void warning(String message, {String? tag}) {
    final tagPrefix = tag != null ? '[$tag] ' : '';
    debugPrint('⚠️ $tagPrefix$message');
  }

  void debug(String message, {String? tag}) {
    if (kDebugMode) {
      final tagPrefix = tag != null ? '[$tag] ' : '';
      debugPrint('🐛 $tagPrefix$message');
    }
  }
}
