/// Exemplo de como usar o PlayIntegrityService
/// Adicione este código no seu main.dart ou em um provider de inicialização

import 'package:gastos_manager/services/play_integrity_service.dart';

class AppInitializer {
  /// Inicializa todos os serviços do app incluindo Play Integrity
  static Future<void> initialize() async {
    // 1. Inicializar Firebase (já feito normalmente)
    // await Firebase.initializeApp();

    // 2. Inicializar Play Integrity API
    await PlayIntegrityService.initialize();

    // 3. Habilitar auto-refresh de tokens
    await PlayIntegrityService.enableTokenAutoRefresh();

    // 4. Verificar integridade do app na inicialização
    final isLegitimate = await PlayIntegrityService.isDeviceLegitimate();
    if (isLegitimate) {
      print('✅ Aplicativo verificado como legítimo');
    } else {
      print('⚠️ Aviso: Não foi possível verificar a integridade do app');
    }

    // 5. Obter token para enviar ao servidor (se necessário)
    final token = await PlayIntegrityService.getIntegrityToken();
    if (token != null) {
      print('✅ Token de integridade obtido');
      // Envie este token ao seu backend para validação adicional
    }
  }

  /// Método para verificar integridade antes de operações sensíveis
  static Future<bool> checkIntegrityBeforeSensitiveOperation() async {
    final isLegitimate = await PlayIntegrityService.verifyAppIntegrity();
    if (!isLegitimate) {
      print('❌ Operação bloqueada: Device não passou na verificação de integridade');
      return false;
    }
    return true;
  }
}

/// Como usar no seu app:
/// 
/// 1. No main.dart, chame durante a inicialização:
///    await AppInitializer.initialize();
///
/// 2. Antes de operações financeiras sensíveis:
///    if (await AppInitializer.checkIntegrityBeforeSensitiveOperation()) {
///      // Prosseguir com a operação
///    }
///
/// 3. Enviar token ao backend para validação:
///    final token = await PlayIntegrityService.getIntegrityToken();
///    // Envie token ao seu servidor para decodificar e validar
///
/// Backend (exemplo com Node.js):
/// const {GoogleAuth} = require('google-auth-library');
/// const integrityTokenVerifier = require('@google-play/integrity');
///
/// async function verifyToken(token) {
///   const client = new GoogleAuth();
///   const verifier = new integrityTokenVerifier.IntegrityTokenVerifier();
///   const result = await verifier.verifyToken(token);
///   return result;
/// }
