import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import 'ad_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

/// Serviço avançado para otimização de receita de anúncios
/// Implementa estratégias para maximizar fill rate e eCPM
class AdRevenueOptimizer {
  static final AdRevenueOptimizer _instance = AdRevenueOptimizer._internal();
  factory AdRevenueOptimizer() => _instance;
  AdRevenueOptimizer._internal();

  // Configurações de otimização
  static const String _prefsKey = 'ad_optimization_data';

  // Múltiplos formatos de anúncio para maximizar fill rate
  final Map<String, AdFormat> _adFormats = {
    'banner_large': AdFormat.largeBanner,
    'banner_medium': AdFormat.mediumRectangle,
    'banner_adaptive': AdFormat.banner,
  };

  // IDs de teste alternativos para melhor fill rate
  final List<String> _testBannerIds = [
    'ca-app-pub-3940256099942544/6300978111', // Banner test ID 1
    'ca-app-pub-3940256099942544/2934735716', // Banner test ID 2 (medium rectangle)
    'ca-app-pub-3940256099942544/9214589741', // Adaptive banner
  ];

  final List<String> _testInterstitialIds = [
    'ca-app-pub-3940256099942544/1033173712', // Interstitial test ID 1
    'ca-app-pub-3940256099942544/4411468910', // Interstitial test ID 2
  ];

  final List<String> _testRewardedIds = [
    'ca-app-pub-3940256099942544/5224354917', // Rewarded test ID 1
    'ca-app-pub-3940256099942544/1712485313', // Rewarded test ID 2
  ];

  // Estatísticas para otimização
  Map<String, AdPerformanceData> _performanceData = {};

  /// Inicializar otimizador carregando dados salvos
  Future<void> initialize() async {
    await _loadPerformanceData();
    debugPrint('🎯 AD OPTIMIZER: Otimizador inicializado');
  }

  /// Obter melhor ID de banner baseado em performance
  String getBestBannerId() {
    if (kDebugMode) {
      final bestId = _getBestPerformingId(_testBannerIds, 'banner');
      debugPrint('🎯 AD OPTIMIZER: [DEBUG] Usando banner ID de teste: $bestId');
      return bestId;
    }
    final prodId = AdService.bannerAdUnitId;
    debugPrint(
      '🎯 AD OPTIMIZER: [RELEASE] Usando banner ID de produção: $prodId',
    );
    return prodId;
  }

  /// Obter melhor ID de intersticial baseado em performance
  String getBestInterstitialId() {
    if (kDebugMode) {
      final bestId = _getBestPerformingId(_testInterstitialIds, 'interstitial');
      debugPrint(
        '🎯 AD OPTIMIZER: [DEBUG] Usando interstitial ID de teste: $bestId',
      );
      return bestId;
    }
    final prodId = AdService.interstitialAdUnitId;
    debugPrint(
      '🎯 AD OPTIMIZER: [RELEASE] Usando interstitial ID de produção: $prodId',
    );
    return prodId;
  }

  /// Obter melhor ID de recompensa baseado em performance
  String getBestRewardedId() {
    if (kDebugMode) {
      final bestId = _getBestPerformingId(_testRewardedIds, 'rewarded');
      debugPrint(
        '🎯 AD OPTIMIZER: [DEBUG] Usando rewarded ID de teste: $bestId',
      );
      return bestId;
    }
    final prodId = AdService.rewardedAdUnitId;
    debugPrint(
      '🎯 AD OPTIMIZER: [RELEASE] Usando rewarded ID de produção: $prodId',
    );
    return prodId;
  }

  /// Criar banner otimizado com possibilidade de sobrescrever tamanho/ID
  BannerAd? createOptimizedBanner({
    required Function(Ad) onAdLoaded,
    required Function(Ad, LoadAdError) onAdFailedToLoad,
    AdSize? sizeOverride,
    String? adUnitIdOverride,
  }) {
    final adId = adUnitIdOverride ?? getBestBannerId();
    final format = _getOptimalBannerFormat();

    debugPrint(
      '🎯 AD OPTIMIZER: Criando banner otimizado - Format: ${format.name}',
    );

    return BannerAd(
      adUnitId: adId,
      size: sizeOverride ?? _getAdSizeForFormat(format),
      request: _buildOptimizedAdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _recordSuccess(adId, 'banner');
          onAdLoaded(ad);
        },
        onAdFailedToLoad: (ad, error) {
          _recordFailure(adId, 'banner', error);
          onAdFailedToLoad(ad, error);
        },
        onAdOpened: (ad) {
          _recordEngagement(adId, 'banner');
        },
      ),
    );
  }

  /// Expor construção de AdRequest otimizado
  AdRequest buildAdRequest() => _buildOptimizedAdRequest();

  /// Próximo ID de banner, para rotacionar quando houver falhas consecutivas
  String getNextBannerId(String currentId) {
    if (_testBannerIds.isEmpty) return currentId;
    final idx = _testBannerIds.indexOf(currentId);
    if (idx == -1) return _testBannerIds.first;
    final nextIdx = (idx + 1) % _testBannerIds.length;
    return _testBannerIds[nextIdx];
  }

  /// Criar intersticial otimizado
  Future<InterstitialAd?> createOptimizedInterstitial({
    required Function(InterstitialAd) onAdLoaded,
    required Function(LoadAdError) onAdFailedToLoad,
  }) async {
    final adId = getBestInterstitialId();

    try {
      final completer = Completer<InterstitialAd?>();

      await InterstitialAd.load(
        adUnitId: adId,
        request: _buildOptimizedAdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _recordSuccess(adId, 'interstitial');
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (ad) {
                _recordEngagement(adId, 'interstitial');
              },
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                ad.dispose();
                _recordFailure(adId, 'interstitial', error);
              },
            );
            onAdLoaded(ad);
            completer.complete(ad);
          },
          onAdFailedToLoad: (error) {
            _recordFailure(adId, 'interstitial', error);
            onAdFailedToLoad(error);
            completer.complete(null);
          },
        ),
      );

      return await completer.future;
    } catch (e) {
      debugPrint('❌ AD OPTIMIZER: Erro ao criar intersticial: $e');
      return null;
    }
  }

  /// Criar anúncio recompensado otimizado
  Future<RewardedAd?> createOptimizedRewarded({
    required Function(RewardedAd) onAdLoaded,
    required Function(LoadAdError) onAdFailedToLoad,
  }) async {
    final adId = getBestRewardedId();

    try {
      final completer = Completer<RewardedAd?>();

      await RewardedAd.load(
        adUnitId: adId,
        request: _buildOptimizedAdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _recordSuccess(adId, 'rewarded');
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (ad) {
                _recordEngagement(adId, 'rewarded');
              },
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                ad.dispose();
                _recordFailure(adId, 'rewarded', error);
              },
            );
            onAdLoaded(ad);
            completer.complete(ad);
          },
          onAdFailedToLoad: (error) {
            _recordFailure(adId, 'rewarded', error);
            onAdFailedToLoad(error);
            completer.complete(null);
          },
        ),
      );

      return await completer.future;
    } catch (e) {
      debugPrint('❌ AD OPTIMIZER: Erro ao criar rewarded: $e');
      return null;
    }
  }

  /// Construir requisição otimizada de anúncio
  AdRequest _buildOptimizedAdRequest() {
    return const AdRequest(
      keywords: [
        'finance',
        'money',
        'budget',
        'financial',
        'banking',
        'investment',
      ],
      contentUrl: 'https://finansapp.com',
      nonPersonalizedAds: false,
    );
  }

  /// Obter melhor ID baseado em performance histórica
  String _getBestPerformingId(List<String> ids, String type) {
    if (ids.isEmpty) return ids.first;

    // Calcular score para cada ID
    String bestId = ids.first;
    double bestScore = 0.0;

    for (final id in ids) {
      final data = _performanceData[id];
      if (data != null) {
        final fillRate = data.requests > 0
            ? data.successes / data.requests
            : 0.0;
        final engagementRate = data.successes > 0
            ? data.engagements / data.successes
            : 0.0;
        final score =
            fillRate * 0.7 + engagementRate * 0.3; // Peso maior para fill rate

        if (score > bestScore) {
          bestScore = score;
          bestId = id;
        }
      }
    }

    return bestId;
  }

  /// Obter formato ótimo de banner baseado em performance
  AdFormat _getOptimalBannerFormat() {
    // Rotacionar entre formatos para teste A/B
    final formats = _adFormats.values.toList();
    final index = DateTime.now().minute % formats.length;
    return formats[index];
  }

  /// Converter formato para AdSize
  AdSize _getAdSizeForFormat(AdFormat format) {
    switch (format) {
      case AdFormat.largeBanner:
        return AdSize.largeBanner;
      case AdFormat.mediumRectangle:
        return AdSize.mediumRectangle;
      case AdFormat.banner:
        return AdSize.banner;
    }
  }

  /// Registrar sucesso de anúncio
  void _recordSuccess(String adId, String type) {
    final data = _performanceData[adId] ??= AdPerformanceData();
    data.requests++;
    data.successes++;
    data.lastSuccess = DateTime.now();
    _savePerformanceData();

    debugPrint('✅ AD OPTIMIZER: Sucesso registrado para $adId ($type)');
  }

  /// Registrar falha de anúncio
  void _recordFailure(String adId, String type, dynamic error) {
    final data = _performanceData[adId] ??= AdPerformanceData();
    data.requests++;
    data.failures++;
    data.lastFailure = DateTime.now();
    _savePerformanceData();

    debugPrint('❌ AD OPTIMIZER: Falha registrada para $adId ($type): $error');
  }

  /// Registrar engajamento (clique/abertura)
  void _recordEngagement(String adId, String type) {
    final data = _performanceData[adId] ??= AdPerformanceData();
    data.engagements++;
    _savePerformanceData();

    debugPrint('👆 AD OPTIMIZER: Engajamento registrado para $adId ($type)');
  }

  /// Carregar dados de performance salvos
  Future<void> _loadPerformanceData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dataString = prefs.getString(_prefsKey);

      if (dataString != null) {
        final Map<String, dynamic> dataMap = jsonDecode(dataString);
        _performanceData = dataMap.map(
          (key, value) => MapEntry(key, AdPerformanceData.fromJson(value)),
        );
      }
    } catch (e) {
      debugPrint('❌ AD OPTIMIZER: Erro ao carregar dados: $e');
    }
  }

  /// Salvar dados de performance
  Future<void> _savePerformanceData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dataMap = _performanceData.map(
        (key, value) => MapEntry(key, value.toJson()),
      );
      await prefs.setString(_prefsKey, jsonEncode(dataMap));
    } catch (e) {
      debugPrint('❌ AD OPTIMIZER: Erro ao salvar dados: $e');
    }
  }

  /// Obter estatísticas de performance
  Map<String, Map<String, dynamic>> getPerformanceStats() {
    return _performanceData.map(
      (key, value) => MapEntry(key, {
        'fillRate': value.requests > 0
            ? (value.successes / value.requests * 100).toStringAsFixed(1) + '%'
            : '0%',
        'engagementRate': value.successes > 0
            ? (value.engagements / value.successes * 100).toStringAsFixed(1) +
                  '%'
            : '0%',
        'totalRequests': value.requests,
        'totalSuccesses': value.successes,
        'totalFailures': value.failures,
        'totalEngagements': value.engagements,
      }),
    );
  }
}

/// Classe para armazenar dados de performance de anúncios
class AdPerformanceData {
  int requests = 0;
  int successes = 0;
  int failures = 0;
  int engagements = 0;
  DateTime? lastSuccess;
  DateTime? lastFailure;

  AdPerformanceData();

  factory AdPerformanceData.fromJson(Map<String, dynamic> json) {
    final data = AdPerformanceData();
    data.requests = json['requests'] ?? 0;
    data.successes = json['successes'] ?? 0;
    data.failures = json['failures'] ?? 0;
    data.engagements = json['engagements'] ?? 0;

    if (json['lastSuccess'] != null) {
      data.lastSuccess = DateTime.parse(json['lastSuccess']);
    }
    if (json['lastFailure'] != null) {
      data.lastFailure = DateTime.parse(json['lastFailure']);
    }

    return data;
  }

  Map<String, dynamic> toJson() {
    return {
      'requests': requests,
      'successes': successes,
      'failures': failures,
      'engagements': engagements,
      'lastSuccess': lastSuccess?.toIso8601String(),
      'lastFailure': lastFailure?.toIso8601String(),
    };
  }
}

/// Enum para formatos de anúncio
enum AdFormat { banner, largeBanner, mediumRectangle }
