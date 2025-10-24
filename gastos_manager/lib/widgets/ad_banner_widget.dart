import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../services/ad_service.dart';
import '../services/premium_service.dart';

/// Widget de banner de anúncio que só aparece para usuários free
class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({Key? key}) : super(key: key);

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  bool _isLoading = false;
  int _retryCount = 0;
  static const int _maxRetries = 1; // Reduzido de 3 para 1 para evitar bloqueio

  // Contador global para delay escalonado entre widgets
  static int _instanceCounter = 0;
  final int _instanceDelay;

  _AdBannerWidgetState() : _instanceDelay = _instanceCounter++ * 2000 {
    // Cada instância espera 2s a mais que a anterior
    debugPrint(
      '🆕 ADMOB BANNER: Nova instância criada com delay de ${_instanceDelay}ms',
    );
  }

  @override
  void initState() {
    super.initState();
    debugPrint(
      '🔵 ADMOB BANNER: Widget iniciado (Retry: $_retryCount/$_maxRetries, Delay: ${_instanceDelay}ms)',
    );

    // Aguardar delay antes de carregar para evitar sobrecarga
    Future.delayed(Duration(milliseconds: _instanceDelay), () {
      if (mounted) {
        _loadBannerAd();
      }
    });
  }

  void _loadBannerAd() {
    if (_isLoading) {
      debugPrint('⏳ ADMOB BANNER: Já está carregando, aguardando...');
      return;
    }

    debugPrint('🔵 ADMOB BANNER: Tentando carregar banner...');
    debugPrint(
      '🔵 ADMOB BANNER: AdMob inicializado? ${AdService.isInitialized}',
    );

    // Só carregar anúncio se AdMob estiver inicializado
    if (!AdService.isInitialized) {
      debugPrint('📱 ADMOB: AdMob não inicializado, não carregando banner');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Dispose do banner anterior se existir
    _bannerAd?.dispose();
    _bannerAd = null;

    // Tentar criar banner (pode retornar null se bloqueado)
    _bannerAd = AdService.createBannerAd(
      onAdLoaded: (ad) {
        if (mounted) {
          setState(() {
            _isAdLoaded = true;
            _isLoading = false;
            _retryCount = 0; // Reset retry count on success
          });
          debugPrint('✅ ADMOB: Banner carregado com sucesso!');
        }
      },
      onAdFailedToLoad: (ad, error) {
        debugPrint('❌ ADMOB: Erro ao carregar banner: $error');
        ad.dispose();

        if (mounted) {
          setState(() {
            _isAdLoaded = false;
            _isLoading = false;
          });

          // Retry logic - apenas 1 tentativa com delay maior
          if (_retryCount < _maxRetries) {
            _retryCount++;
            debugPrint(
              '🔄 ADMOB: Tentando novamente em 10 segundos (Tentativa $_retryCount/$_maxRetries)',
            );
            Future.delayed(const Duration(seconds: 10), () {
              if (mounted) {
                _loadBannerAd();
              }
            });
          } else {
            debugPrint(
              '⛔ ADMOB: Máximo de tentativas atingido. Mostrando aviso premium.',
            );
          }
        }
      },
    );

    // Verificar se o banner foi criado (não bloqueado)
    if (_bannerAd != null) {
      _bannerAd!.load();
    } else {
      debugPrint('⛔ ADMOB: Banner bloqueado pelo sistema de prevenção');
      setState(() {
        _isLoading = false;
        _isAdLoaded = false;
      });
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PremiumService>(
      builder: (context, premiumService, child) {
        debugPrint(
          '🔵 ADMOB BANNER: Build chamado - isPremium: ${premiumService.isPremium}',
        );
        debugPrint(
          '🔵 ADMOB BANNER: Ad carregado? $_isAdLoaded, Ad existe? ${_bannerAd != null}',
        );

        // Se for premium, não mostrar anúncios
        if (premiumService.isPremium) {
          debugPrint(
            '🔵 ADMOB BANNER: Usuário premium - não mostrando anúncio',
          );
          return const SizedBox.shrink();
        }

        // Se está carregando, mostrar indicador
        if (_isLoading) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 12),
                  Text('Carregando anúncio...'),
                ],
              ),
            ),
          );
        }
        if (!_isAdLoaded) {
          // Mostra diagnóstico apenas se houve tentativa de carregamento e falhou
          if (_retryCount > 0) {
            return _buildDiagnosticWidget(context);
          }
          // Caso contrário, não mostra nada (modo discreto)
          return const SizedBox.shrink();
        }

        // Mostrar banner de anúncio
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: AdWidget(ad: _bannerAd!),
            ),
            _buildRemoveAdsNotice(context),
          ],
        );
      },
    );
  }

  /// Widget de loading enquanto carrega o anúncio

  /// Widget de diagnóstico discreto apenas quando há erro
  Widget _buildDiagnosticWidget(BuildContext context) {
    final isPremium = Provider.of<PremiumService>(
      context,
      listen: false,
    ).isPremium;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.red.shade200, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.info_outline, color: Colors.red.shade600, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Anúncio indisponível${isPremium ? ' (Premium ativo)' : ''}',
              style: TextStyle(fontSize: 11, color: Colors.red.shade700),
            ),
          ),
          if (!isPremium)
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'AdMob: ${AdService.isInitialized ? 'OK' : 'Erro'} | '
                      'Status: ${_retryCount >= _maxRetries ? 'Falhou' : 'Tentando'} | '
                      'ID: ${AdService.bannerAdUnitId}',
                    ),
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
              child: Icon(
                Icons.help_outline,
                color: Colors.red.shade600,
                size: 14,
              ),
            ),
        ],
      ),
    );
  }

  /// Widget com aviso sobre remoção de anúncios
  Widget _buildRemoveAdsNotice(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: 14,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              'Para remover anúncios, assine o Premium',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/premium');
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Saiba mais',
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
