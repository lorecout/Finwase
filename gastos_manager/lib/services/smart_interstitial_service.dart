import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/ad_revenue_optimizer.dart';

/// Serviço para anúncios intersticiais e recompensados otimizados
class SmartInterstitialService {
  static final SmartInterstitialService _instance =
      SmartInterstitialService._internal();
  factory SmartInterstitialService() => _instance;
  SmartInterstitialService._internal();

  final AdRevenueOptimizer _optimizer = AdRevenueOptimizer();

  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  bool _isInterstitialLoading = false;
  bool _isRewardedLoading = false;

  int _interstitialCounter = 0;
  static const int _interstitialFrequency = 4; // Mostrar a cada 4 ações

  /// Inicializar o serviço
  Future<void> initialize() async {
    await _optimizer.initialize();
    debugPrint('🎯 SMART INTERSTITIAL: Serviço inicializado');
  }

  /// Incrementar contador e mostrar intersticial se necessário
  Future<void> incrementAndShowInterstitial(BuildContext context) async {
    _interstitialCounter++;

    if (_interstitialCounter >= _interstitialFrequency) {
      _interstitialCounter = 0;
      await showInterstitial(context);
    }
  }

  /// Carregar intersticial otimizado
  Future<void> loadInterstitial() async {
    if (_isInterstitialLoading || _interstitialAd != null) return;

    _isInterstitialLoading = true;
    debugPrint('🎯 SMART INTERSTITIAL: Carregando intersticial otimizado...');

    try {
      _interstitialAd = await _optimizer.createOptimizedInterstitial(
        onAdLoaded: (ad) {
          _isInterstitialLoading = false;
          debugPrint('✅ SMART INTERSTITIAL: Intersticial carregado!');
        },
        onAdFailedToLoad: (error) {
          _isInterstitialLoading = false;
          _interstitialAd = null;
          debugPrint('❌ SMART INTERSTITIAL: Falha ao carregar: $error');
        },
      );
    } catch (e) {
      _isInterstitialLoading = false;
      debugPrint('❌ SMART INTERSTITIAL: Erro: $e');
    }
  }

  /// Mostrar intersticial se disponível
  Future<void> showInterstitial(BuildContext context) async {
    if (_interstitialAd == null) {
      await loadInterstitial();
      return;
    }

    try {
      debugPrint('🎯 SMART INTERSTITIAL: Mostrando intersticial...');
      await _interstitialAd!.show();
      _interstitialAd = null;

      // Pré-carregar próximo
      Future.delayed(const Duration(seconds: 2), loadInterstitial);
    } catch (e) {
      debugPrint('❌ SMART INTERSTITIAL: Erro ao mostrar: $e');
    }
  }

  /// Carregar anúncio recompensado otimizado
  Future<void> loadRewarded() async {
    if (_isRewardedLoading || _rewardedAd != null) return;

    _isRewardedLoading = true;
    debugPrint('🎯 SMART REWARDED: Carregando rewarded otimizado...');

    try {
      _rewardedAd = await _optimizer.createOptimizedRewarded(
        onAdLoaded: (ad) {
          _isRewardedLoading = false;
          debugPrint('✅ SMART REWARDED: Rewarded carregado!');
        },
        onAdFailedToLoad: (error) {
          _isRewardedLoading = false;
          _rewardedAd = null;
          debugPrint('❌ SMART REWARDED: Falha ao carregar: $error');
        },
      );
    } catch (e) {
      _isRewardedLoading = false;
      debugPrint('❌ SMART REWARDED: Erro: $e');
    }
  }

  /// Mostrar anúncio recompensado
  Future<bool> showRewarded(
    BuildContext context, {
    required Function() onRewarded,
    String rewardMessage = 'Assista ao anúncio para ganhar a recompensa!',
  }) async {
    if (_rewardedAd == null) {
      await loadRewarded();
      if (_rewardedAd == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Anúncio não disponível no momento. Tente novamente.',
            ),
            backgroundColor: Colors.orange,
          ),
        );
        return false;
      }
    }

    bool rewardReceived = false;

    try {
      debugPrint('🎯 SMART REWARDED: Mostrando rewarded...');

      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          debugPrint('🎯 SMART REWARDED: Anúncio exibido');
        },
        onAdDismissedFullScreenContent: (ad) {
          debugPrint('🎯 SMART REWARDED: Anúncio fechado');
          ad.dispose();
          _rewardedAd = null;

          // Pré-carregar próximo
          Future.delayed(const Duration(seconds: 2), loadRewarded);
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          debugPrint('❌ SMART REWARDED: Erro ao mostrar: $error');
          ad.dispose();
          _rewardedAd = null;
        },
      );

      await _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          debugPrint(
            '🎁 SMART REWARDED: Recompensa ganha! ${reward.amount} ${reward.type}',
          );
          rewardReceived = true;
          onRewarded();
        },
      );

      return rewardReceived;
    } catch (e) {
      debugPrint('❌ SMART REWARDED: Erro ao mostrar: $e');
      return false;
    }
  }

  /// Verificar se tem anúncio recompensado disponível
  bool get hasRewardedAd => _rewardedAd != null;

  /// Pré-carregar anúncios
  Future<void> preloadAds() async {
    await loadInterstitial();
    await loadRewarded();
  }

  /// Dispose de todos os anúncios
  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _interstitialAd = null;
    _rewardedAd = null;
  }
}

/// Widget para botão de anúncio recompensado
class RewardedAdButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final Function() onRewarded;
  final String rewardMessage;
  final Color? color;

  const RewardedAdButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onRewarded,
    this.rewardMessage = 'Assista ao anúncio para ganhar a recompensa!',
    this.color,
  });

  @override
  State<RewardedAdButton> createState() => _RewardedAdButtonState();
}

class _RewardedAdButtonState extends State<RewardedAdButton> {
  final SmartInterstitialService _service = SmartInterstitialService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _service.loadRewarded();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : _showRewardedAd,
      icon: _isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(widget.icon),
      label: Text(widget.text),
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.color ?? Colors.amber,
        foregroundColor: Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Future<void> _showRewardedAd() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _service.showRewarded(
        context,
        onRewarded: widget.onRewarded,
        rewardMessage: widget.rewardMessage,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎁 Recompensa recebida!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
