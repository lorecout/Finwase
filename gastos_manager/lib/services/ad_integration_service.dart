import 'package:flutter/material.dart';

/// Serviço principal para integração de anúncios na aplicação
/// DESABILITADO PARA: MODO GRATUITO TOTAL
/// - Nenhum anúncio é carregado ou exibido
/// - Serviço retorna sempre sem fazer nada
/// - Mantido para compatibilidade com código existente
class AdIntegrationService {
  static final AdIntegrationService _instance =
      AdIntegrationService._internal();
  factory AdIntegrationService() => _instance;
  AdIntegrationService._internal();

  bool _isInitialized = false;

  /// Inicializar - NO-OP em modo gratuito total
  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;
    debugPrint('🔕 AD INTEGRATION: Desabilitado (modo gratuito total)');
  }

  /// Verificar se está inicializado
  bool get isInitialized => _isInitialized;

  /// Registrar ação do usuário - NO-OP
  Future<void> registerUserAction(
    BuildContext context,
    String actionType,
  ) async {
    // No-op em modo gratuito
  }

  /// Obter estatísticas de performance - retorna vazio
  Future<Map<String, dynamic>> getPerformanceStats() async {
    return {'ads_disabled': 'No ads in free mode'};
  }

  /// Reset para testes
  Future<void> resetForTesting() async {
    debugPrint('🔄 AD INTEGRATION: Reset (desabilitado)');
  }

  /// Dispose de todos os recursos
  void dispose() {
    _isInitialized = false;
  }
}

/// Mixin para facilitar integração de anúncios em telas
mixin AdIntegrationMixin<T extends StatefulWidget> on State<T> {
  final AdIntegrationService _adService = AdIntegrationService();

  @override
  void initState() {
    super.initState();
    _initializeAds();
  }

  Future<void> _initializeAds() async {
    await _adService.initialize();
  }

  /// Registrar ação - NO-OP
  Future<void> registerAction(String actionType) async {
    // No-op em modo gratuito
  }

  /// Mostrar anúncio recompensado - sempre retorna false (sem anúncios)
  Future<bool> showRewardedAd({
    required Function() onRewarded,
    String rewardMessage = 'Assista ao anúncio para ganhar a recompensa!',
  }) async {
    return false;
  }

  /// Verificar se tem anúncio recompensado - sempre false
  bool get hasRewardedAd => false;

  @override
  void dispose() {
    super.dispose();
  }
}

/// Widget para exibir estatísticas de anúncios (para debug/admin)
class AdPerformanceWidget extends StatelessWidget {
  const AdPerformanceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📊 Anúncios Desabilitados',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Status'),
                  Text(
                    'Modo Gratuito Total',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Extensão para facilitar uso em qualquer widget
extension AdIntegrationExtension on BuildContext {
  /// Registrar ação do usuário - NO-OP
  Future<void> registerUserAction(String actionType) async {
    // No-op em modo gratuito
  }

  /// Mostrar anúncio recompensado - sempre retorna false
  Future<bool> showRewardedAd({
    required Function() onRewarded,
    String rewardMessage = 'Assista ao anúncio para ganhar a recompensa!',
  }) async {
    return false;
  }
}
