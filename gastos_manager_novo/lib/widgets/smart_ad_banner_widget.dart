import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../services/premium_service.dart';

/// Widget inteligente de banner
/// DESABILITADO PARA: MODO GRATUITO TOTAL
/// - Nunca carrega ou exibe anúncios
/// - Retorna sempre espaço vazio
class SmartAdBannerWidget extends StatelessWidget {
  final EdgeInsets? margin;
  final double? height;
  final String? debugLabel;

  const SmartAdBannerWidget({
    super.key,
    this.margin,
    this.height,
    this.debugLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<PremiumService>(
      builder: (context, premiumService, _) {
        if (!premiumService.showAds) {
          return const SizedBox.shrink();
        }
        return _SmartAdBannerInner(
          margin: margin,
          height: height,
          debugLabel: debugLabel,
        );
      },
    );
  }
}

class _SmartAdBannerInner extends StatefulWidget {
  final EdgeInsets? margin;
  final double? height;
  final String? debugLabel;

  const _SmartAdBannerInner({
    this.margin,
    this.height,
    this.debugLabel,
  });

  @override
  State<_SmartAdBannerInner> createState() => _SmartAdBannerInnerState();
}

class _SmartAdBannerInnerState extends State<_SmartAdBannerInner> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    debugPrint('🔔 SMART AD BANNER: Ativo (modo gratuito com anúncios)');
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isLoaded = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Obrigado por apoiar o app visualizando anúncios!'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          setState(() {
            _isLoaded = false;
          });
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null) return const SizedBox.shrink();
    return Container(
      margin: widget.margin,
      width: _bannerAd!.size.width.toDouble(),
      height: widget.height ?? _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}

class _SmartAdBannerWidgetState extends State<_SmartAdBannerInner> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    debugPrint('🔔 SMART AD BANNER: Ativo (modo gratuito com anúncios)');
    _bannerAd = BannerAd(
      adUnitId:
          'ca-app-pub-3940256099942544/6300978111', // Teste oficial Google
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isLoaded = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Obrigado por apoiar o app visualizando anúncios!'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          setState(() {
            _isLoaded = false;
          });
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Removido: checagem de isActive. A lógica de exibição já está no widget principal.
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Aviso de monetização
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(
            'Este app é gratuito graças aos anúncios',
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
        ),
        if (_isLoaded && _bannerAd != null)
          SizedBox(
            width: _bannerAd!.size.width.toDouble(),
            height: _bannerAd!.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          )
        else
          Container(
            height: 50,
            color: Colors.blueGrey.shade50,
            child: Center(
              child: Text(
                widget.debugLabel ?? 'Carregando anúncio...',
                style: const TextStyle(color: Colors.black38),
              ),
            ),
          ),
      ],
    );
  }
}
