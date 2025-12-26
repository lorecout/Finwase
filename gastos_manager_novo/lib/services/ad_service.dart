import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:gastos_manager/constants/ad_constants.dart';

/// ServiÃ§o centralizado para gerenciar IDs de anÃºncios do Google AdMob
class AdService {
  // Google AdMob App ID (conta: lorenaslcout@gmail.com)
  static const String adMobAppId = AdConstants.admobAppId;

  // IDs de produÃ§Ã£o - Usando IDs reais do AdMob Console
  // Configurados em lib/constants/ad_constants.dart
  static const String _prodBannerId = AdConstants.bannerAdUnitId;
  static const String _prodInterstitialId = AdConstants.interstitialAdUnitId;
  static const String _prodRewardedId = AdConstants.rewardedAdUnitId;
  static bool _initialized = false;

  /// Obter ID da unidade de anÃºncio de banner
  // === GETTERS PARA IDs ===
  static String get bannerUnitId => _isTestMode ? _testBannerId : _prodBannerId;
  static String get interstitialUnitId => _isTestMode ? _testInterstitialId : _prodInterstitialId;
  static String get rewardedUnitId => _isTestMode ? _testRewardedId : _prodRewardedId;
  static String bannerUnitId() {
    return AdConstants.useTestAds
        ? AdConstants.getBannerAdUnitId()
        : _prodBannerId;
  }

  static String interstitialUnitId() {
    return AdConstants.useTestAds
        ? AdConstants.getInterstitialAdUnitId()
        : _prodInterstitialId;
  }

  static String rewardedUnitId() {
    return AdConstants.useTestAds
        ? AdConstants.getRewardedAdUnitId()
        : _prodRewardedId;
  }

  /// Inicializar Google Mobile Ads SDK
  static Future<void> initialize() async {
    if (!_initialized) {
      // Se estivermos em modo de teste, configurar testDeviceIds para evitar erros
      try {
        if (AdConstants.useTestAds) {
          final config = RequestConfiguration(
            testDeviceIds: [AdConstants.testDeviceId],
          );
          await MobileAds.instance.updateRequestConfiguration(config);
        }
      } catch (e) {
        // NÃ£o bloquear inicializaÃ§Ã£o por falha na configuraÃ§Ã£o de request
        debugPrint('AdService: falha ao configurar RequestConfiguration: $e');
      }

      await MobileAds.instance.initialize();
      _initialized = true;
    }
  }

  /// Inicializar Google Mobile Ads SDK (compatibilidade)
  static Future<void> initializeMobileAds() async {
    await initialize();
  }

  /// Verificar se o SDK foi inicializado
  static bool get isInitialized => _initialized;

  /// Obter status dos anÃºncios
  static Map<String, dynamic> getAdStatus() {
    return {
      'initialized': _initialized,
      'bannerUnitId': bannerUnitId(),
      'interstitialUnitId': interstitialUnitId(),
      'rewardedUnitId': rewardedUnitId(),
    };
  }

  /// Criar anÃºncio de banner
  static BannerAd createBannerAd({
    required Function(Ad) onAdLoaded,
    required Function(Ad, LoadAdError) onAdFailedToLoad,
    Function(Ad)? onAdOpened,
    Function(Ad)? onAdClosed,
    Function(Ad)? onAdClicked,
  }) {
    return BannerAd(
      adUnitId: bannerUnitId(),
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
        onAdOpened: onAdOpened,
        onAdClosed: onAdClosed,
        onAdClicked: onAdClicked,
      ),
    );
  }

  /// Criar anÃºncio intersticial
  static Future<InterstitialAd?> createInterstitialAd({
    required Function(InterstitialAd) onAdLoaded,
    required Function(LoadAdError) onAdFailedToLoad,
  }) async {
    InterstitialAd? interstitialAd;

    await InterstitialAd.load(
      adUnitId: interstitialUnitId(),
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          onAdLoaded(ad);
        },
        onAdFailedToLoad: onAdFailedToLoad,
      ),
    );

    return interstitialAd;
  }

  /// Criar anÃºncio com recompensa
  static Future<RewardedAd?> createRewardedAd({
    required Function(RewardedAd) onAdLoaded,
    required Function(LoadAdError) onAdFailedToLoad,
  }) async {
    RewardedAd? rewardedAd;

    await RewardedAd.load(
      adUnitId: rewardedUnitId(),
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          rewardedAd = ad;
          onAdLoaded(ad);
        },
        onAdFailedToLoad: onAdFailedToLoad,
      ),
    );

    return rewardedAd;
  }
}

