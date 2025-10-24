import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../services/ad_revenue_optimizer.dart';
import '../services/premium_service.dart';

/// Widget inteligente de banner que otimiza receita automaticamente
class SmartAdBannerWidget extends StatefulWidget {
  final EdgeInsets? margin;
  final double? height;

  final String? debugLabel;
  final bool isActive;

  const SmartAdBannerWidget({
    Key? key,
    this.margin,
    this.height,
    this.debugLabel,
    this.isActive = true,
  }) : super(key: key);

  @override
  State<SmartAdBannerWidget> createState() => _SmartAdBannerWidgetState();
}

class _SmartAdBannerWidgetState extends State<SmartAdBannerWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  bool _isLoading = false;
  int _retryCount = 0;
  static const int _maxRetries = 5;
  // Rotação de tamanhos para tentar diferentes inventários
  final List<AdSize> _bannerSizes = [
    AdSize.banner,
    AdSize.largeBanner,
    AdSize.mediumRectangle,
  ];
  int _sizeIndex = 0;
  String? _currentBannerId;

  late AdRevenueOptimizer _optimizer;

  @override
  void initState() {
    super.initState();
    _optimizer = AdRevenueOptimizer();
    _initializeAndLoad();
  }

  Future<void> _initializeAndLoad() async {
    await _optimizer.initialize();
    if (!mounted || !widget.isActive) return;
    _loadOptimizedBanner();
  }

  void _loadOptimizedBanner() {
    if (_isLoading || !widget.isActive) return;

    setState(() {
      _isLoading = true;
    });

    // Dispose do banner anterior
    _bannerAd?.dispose();
    _bannerAd = null;

    final label = widget.debugLabel != null ? '[${widget.debugLabel}] ' : '';
    debugPrint(
      '🎯 SMART BANNER: ${label}Carregando banner otimizado (tentativa ${_retryCount + 1})',
    );

    // Definir ID atual para permitir rotação entre tentativas
    _currentBannerId ??= _optimizer.getBestBannerId();

    // Definir tamanho atual da rotação
    final sizeOverride = _bannerSizes[_sizeIndex % _bannerSizes.length];

    _bannerAd = _optimizer.createOptimizedBanner(
      onAdLoaded: (ad) {
        if (mounted) {
          setState(() {
            _isAdLoaded = true;
            _isLoading = false;
            _retryCount = 0;
          });
          debugPrint(
            '✅ SMART BANNER: ${label}Banner otimizado carregado com sucesso!',
          );
        }
      },
      onAdFailedToLoad: (ad, error) {
        debugPrint(
          '❌ SMART BANNER: ${label}Erro ao carregar banner otimizado: $error',
        );
        ad.dispose();

        if (mounted) {
          setState(() {
            _isAdLoaded = false;
            _isLoading = false;
          });

          // Retry com backoff exponencial
          if (_retryCount < _maxRetries) {
            _retryCount++;
            final delay = Duration(seconds: _retryCount * 5); // 5s, 10s, 15s
            debugPrint(
              '🔄 SMART BANNER: ${label}Tentando novamente em ${delay.inSeconds}s',
            );

            Future.delayed(delay, () {
              if (mounted && widget.isActive) {
                // Alternar ID para aumentar probabilidade de fill
                if (_currentBannerId != null) {
                  _currentBannerId = _optimizer.getNextBannerId(
                    _currentBannerId!,
                  );
                }
                // Alternar tamanho também
                _sizeIndex = (_sizeIndex + 1) % _bannerSizes.length;
                _loadOptimizedBanner();
              }
            });
          } else {
            debugPrint('⛔ SMART BANNER: ${label}Máximo de tentativas atingido');
          }
        }
      },
      adUnitIdOverride: _currentBannerId,
      sizeOverride: sizeOverride,
    );

    _bannerAd?.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SmartAdBannerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive) {
      if (!widget.isActive) {
        _bannerAd?.dispose();
        _bannerAd = null;
        _isAdLoaded = false;
        _isLoading = false;
      } else {
        _loadOptimizedBanner();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PremiumService>(
      builder: (context, premiumService, child) {
        // Premium: não mostra anúncio
        if (premiumService.isPremium) {
          return const SizedBox.shrink();
        }

        // Placeholder enquanto carrega
        if (_isLoading) {
          return Container(
            margin: widget.margin ?? const EdgeInsets.symmetric(vertical: 8),
            height: widget.height ?? 60,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        // Sem mensagens quando não carregar: reserva espaço
        if (!_isAdLoaded || _bannerAd == null) {
          return SizedBox(height: widget.height ?? 0);
        }

        // Mostrar banner carregado
        return Container(
          margin: widget.margin ?? const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
                _buildAdLabel(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAdLabel(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceVariant.withValues(alpha: 0.5),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 12,
            color: Theme.of(
              context,
            ).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              'Anúncio • Remova com Premium',
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(
                  context,
                ).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/premium'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Premium',
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
