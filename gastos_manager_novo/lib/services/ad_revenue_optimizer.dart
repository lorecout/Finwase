import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_service.dart';

/// Classe para rastrear dados de desempenho de anÃºncios
class AdPerformanceData {
  int impressions = 0;
  int clicks = 0;
  double revenue = 0.0;
  DateTime lastUpdated = DateTime.now();

  AdPerformanceData();

  /// Taxa de clique (CTR) em percentual
  double get ctr => impressions > 0 ? (clicks / impressions) * 100 : 0.0;

  /// Ganho por mil impressÃµes (eCPM) em dÃ³lares
  double get ecpm => impressions > 0 ? (revenue / impressions) * 1000 : 0.0;
}

/// Otimizador de receita de anÃºncios com rastreamento de desempenho
class AdRevenueOptimizer {
  late final Map<String, AdPerformanceData> _performanceData = {};
  static final AdRevenueOptimizer _instance = AdRevenueOptimizer._internal();

  late Map<String, AdPerformanceData> _performanceData;
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  AdRevenueOptimizer._internal() {
    _performanceData = {};
    _bannerAd = null;
    _interstitialAd = null;
    _rewardedAd = null;
  }

  factory AdRevenueOptimizer() {
    return _instance;
  }

  /// Inicializar o Google Mobile Ads SDK
  Future<void> initialize() async {
    await AdService.initializeMobileAds();
    _loadPerformanceData();
  }

  /// Carregar anÃºncio de banner
  void loadBannerAd() {
    final prodId = AdService.bannerUnitId();
    _bannerAd = BannerAd(
      adUnitId: prodId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _recordAdPerformance(prodId, isImpression: true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
        onAdClicked: (ad) {
          _recordAdPerformance(prodId, isClick: true);
        },
      ),
    );
    _bannerAd?.load();
  }

  /// Carregar anÃºncio intersticial
  void loadInterstitialAd() {
    final prodId = AdService.interstitialUnitId();
    InterstitialAd.load(
      adUnitId: prodId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _recordAdPerformance(prodId, isImpression: true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          // Log do erro de carregamento
        },
      ),
    );
  }

  /// Carregar anÃºncio com recompensa
  void loadRewardedAd() {
    final prodId = AdService.rewardedUnitId();
    RewardedAd.load(
      adUnitId: prodId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _recordAdPerformance(prodId, isImpression: true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          // Log do erro de carregamento
        },
      ),
    );
  }

  /// Exibir anÃºncio de banner
  void showBannerAd(void Function(BannerAd) onAdLoaded) {
    if (_bannerAd != null) {
      onAdLoaded(_bannerAd!);
    }
  }

  /// Exibir anÃºncio intersticial
  void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd?.show();
      _recordAdPerformance(AdService.interstitialUnitId(), isClick: true);
    }
  }

  /// Exibir anÃºncio com recompensa
  void showRewardedAd(void Function(AdWithoutView) onUserEarnedReward) {
    if (_rewardedAd != null) {
      _rewardedAd?.show(
        onUserEarnedReward: (ad, reward) {
          onUserEarnedReward(ad);
          _recordAdPerformance(AdService.rewardedUnitId(), isClick: true);
        },
      );
    }
  }

  /// Registrar desempenho do anÃºncio (com rastreamento de receita de teste)
  void _recordAdPerformance(
    String adId, {
    bool isImpression = false,
    bool isClick = false,
  }) {
    final data = _performanceData[adId] ??= AdPerformanceData();

    if (isImpression) {
      data.impressions++;
    }

    if (isClick) {
      data.clicks++;
    }

    data.lastUpdated = DateTime.now();
    _savePerformanceData();
  }

  /// Salvar dados de desempenho (implementar com SharedPreferences/Hive)
  void _savePerformanceData() {
    // Mapeia os dados de desempenho para formato de persistÃªncia
    _performanceData.map(
      (key, value) => MapEntry(key, {
        'impressions': value.impressions,
        'clicks': value.clicks,
        'revenue': value.revenue,
        'lastUpdated': value.lastUpdated.toIso8601String(),
      }),
    );
    // TODO: Implementar persistÃªncia em SharedPreferences ou banco de dados
    // Exemplo: await prefs.setString('ad_performance', jsonEncode(dataMap));
  }

  /// Carregar dados de desempenho (implementar com SharedPreferences/Hive)
  void _loadPerformanceData() {
    // TODO: Implementar carregamento de SharedPreferences ou banco de dados
    // Exemplo:
    // final json = prefs.getString('ad_performance');
    // if (json != null) {
    //   final dataMap = jsonDecode(json);
    //   _performanceData = dataMap.map(
    //     (key, value) => MapEntry(
    //       key,
    //       AdPerformanceData()
    //         ..impressions = value['impressions']
    //         ..clicks = value['clicks']
    //         ..revenue = (value['revenue'] as num).toDouble()
    //         ..lastUpdated = DateTime.parse(value['lastUpdated']),
    //     ),
    //   );
    // }
  }

  /// Obter dados de desempenho de todos os anÃºncios
  Map<String, AdPerformanceData> getPerformanceData() {
    return Map.unmodifiable(_performanceData);
  }

  /// Obter estatÃ­sticas de desempenho dos anÃºncios
  Map<String, dynamic> getPerformanceStats() {
    double totalRevenue = 0;
    int totalImpressions = 0;
    int totalClicks = 0;

    for (var data in _performanceData.values) {
      totalRevenue += data.revenue;
      totalImpressions += data.impressions;
      totalClicks += data.clicks;
    }

    return {
      'totalRevenue': totalRevenue,
      'totalImpressions': totalImpressions,
      'totalClicks': totalClicks,
      'averageCTR': totalImpressions > 0
          ? (totalClicks / totalImpressions) * 100
          : 0.0,
      'averageECPM': totalImpressions > 0
          ? (totalRevenue / totalImpressions) * 1000
          : 0.0,
    };
  }

  /// Criar anÃºncio de banner otimizado
  BannerAd? createOptimizedBanner({
    required Function(BannerAd) onAdLoaded,
    required Function(BannerAd, LoadAdError) onAdFailedToLoad,
  }) {
    final prodId = AdService.bannerUnitId();
    final banner = BannerAd(
      adUnitId: prodId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _recordAdPerformance(prodId, isImpression: true);
          onAdLoaded(ad as BannerAd);
        },
        onAdFailedToLoad: (ad, error) {
          onAdFailedToLoad(ad as BannerAd, error);
          ad.dispose();
        },
        onAdClicked: (ad) {
          _recordAdPerformance(prodId, isClick: true);
        },
      ),
    );
    banner.load();
    return banner;
  }

  /// Criar anÃºncio intersticial otimizado
  Future<InterstitialAd?> createOptimizedInterstitial({
    required Function(InterstitialAd) onAdLoaded,
    required Function(LoadAdError) onAdFailedToLoad,
  }) async {
    final prodId = AdService.interstitialUnitId();

    InterstitialAd.load(
      adUnitId: prodId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _recordAdPerformance(prodId, isImpression: true);
          onAdLoaded(ad);
        },
        onAdFailedToLoad: (error) {
          onAdFailedToLoad(error);
        },
      ),
    );

    return null;
  }

  /// Criar anÃºncio com recompensa otimizado
  Future<RewardedAd?> createOptimizedRewarded({
    required Function(RewardedAd) onAdLoaded,
    required Function(LoadAdError) onAdFailedToLoad,
  }) async {
    final prodId = AdService.rewardedUnitId();
    final completer = Completer<RewardedAd?>();

    RewardedAd.load(
      adUnitId: prodId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _recordAdPerformance(prodId, isImpression: true);
          onAdLoaded(ad);
          completer.complete(ad);
        },
        onAdFailedToLoad: (error) {
          onAdFailedToLoad(error);
          completer.complete(null);
        },
      ),
    );

    return completer.future;
  }

  /// Obter melhor ID de banner baseado em desempenho
  String getBestBannerId() {
    return AdService.bannerUnitId();
  }

  /// Obter prÃ³ximo ID de banner (para rotaÃ§Ã£o)
  String getNextBannerId([String? currentId]) {
    return AdService.bannerUnitId();
  }

  /// Limpar recursos de anÃºncios
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
  }
}

