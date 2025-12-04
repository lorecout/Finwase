import 'package:flutter/material.dart';
import '../services/ad_revenue_optimizer.dart';
import '../services/smart_interstitial_service.dart';

/// Serviço principal para integração de anúncios na aplicação
class AdIntegrationService {
  static final AdIntegrationService _instance =
      AdIntegrationService._internal();
  factory AdIntegrationService() => _instance;
  AdIntegrationService._internal();

  final AdRevenueOptimizer _optimizer = AdRevenueOptimizer();
  final SmartInterstitialService _interstitialService =
      SmartInterstitialService();

  bool _isInitialized = false;

  /// Inicializar todos os serviços de anúncios
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      debugPrint('🚀 AD INTEGRATION: Inicializando serviços de anúncios...');

      // Inicializar otimizador
      await _optimizer.initialize();

      // Inicializar serviço de intersticiais
      await _interstitialService.initialize();

      // Pré-carregar anúncios
      await _interstitialService.preloadAds();

      _isInitialized = true;
      debugPrint('✅ AD INTEGRATION: Todos os serviços inicializados!');
    } catch (e) {
      debugPrint('❌ AD INTEGRATION: Erro na inicialização: $e');
    }
  }

  /// Obter instância do otimizador
  AdRevenueOptimizer get optimizer => _optimizer;

  /// Obter instância do serviço de intersticiais
  SmartInterstitialService get interstitialService => _interstitialService;

  /// Verificar se está inicializado
  bool get isInitialized => _isInitialized;

  /// Registrar ação do usuário para controle de intersticiais
  Future<void> registerUserAction(
    BuildContext context,
    String actionType,
  ) async {
    if (!_isInitialized) await initialize();

    debugPrint('📊 AD INTEGRATION: Ação registrada: $actionType');
    await _interstitialService.incrementAndShowInterstitial(context);
  }

  /// Obter estatísticas de performance
  Future<Map<String, dynamic>> getPerformanceStats() async {
    if (!_isInitialized) return {};

    return _optimizer.getPerformanceStats();
  }

  /// Reset para testes
  Future<void> resetForTesting() async {
    debugPrint('🔄 AD INTEGRATION: Reset para testes...');
    // Reset será implementado no futuro se necessário
  }

  /// Dispose de todos os recursos
  void dispose() {
    _interstitialService.dispose();
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

  /// Registrar ação que pode disparar intersticial
  Future<void> registerAction(String actionType) async {
    await _adService.registerUserAction(context, actionType);
  }

  /// Mostrar anúncio recompensado
  Future<bool> showRewardedAd({
    required Function() onRewarded,
    String rewardMessage = 'Assista ao anúncio para ganhar a recompensa!',
  }) async {
    return await _adService.interstitialService.showRewarded(
      context,
      onRewarded: onRewarded,
      rewardMessage: rewardMessage,
    );
  }

  /// Verificar se tem anúncio recompensado disponível
  bool get hasRewardedAd => _adService.interstitialService.hasRewardedAd;

  @override
  void dispose() {
    // Note: Não fazemos dispose do serviço aqui pois é singleton
    super.dispose();
  }
}

/// Widget para exibir estatísticas de anúncios (para debug/admin)
class AdPerformanceWidget extends StatelessWidget {
  const AdPerformanceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: AdIntegrationService().getPerformanceStats(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final stats = snapshot.data!;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '📊 Performance dos Anúncios',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...stats.entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry.key),
                        Text(
                          entry.value.toString(),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Extensão para facilitar uso em qualquer widget
extension AdIntegrationExtension on BuildContext {
  /// Registrar ação do usuário
  Future<void> registerUserAction(String actionType) async {
    await AdIntegrationService().registerUserAction(this, actionType);
  }

  /// Mostrar anúncio recompensado
  Future<bool> showRewardedAd({
    required Function() onRewarded,
    String rewardMessage = 'Assista ao anúncio para ganhar a recompensa!',
  }) async {
    return await AdIntegrationService().interstitialService.showRewarded(
      this,
      onRewarded: onRewarded,
      rewardMessage: rewardMessage,
    );
  }
}
