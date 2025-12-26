import 'package:flutter/material.dart';

/// Widget inteligente de banner
/// DESABILITADO PARA: MODO GRATUITO TOTAL
/// - Nunca carrega ou exibe anúncios
/// - Retorna sempre espaço vazio
class SmartAdBannerWidget extends StatefulWidget {
  final EdgeInsets? margin;
  final double? height;
  final String? debugLabel;
  final bool isActive;

  const SmartAdBannerWidget({
    super.key,
    this.margin,
    this.height,
    this.debugLabel,
    this.isActive = true,
  });

  @override
  State<SmartAdBannerWidget> createState() => _SmartAdBannerWidgetState();
}

class _SmartAdBannerWidgetState extends State<SmartAdBannerWidget> {
  @override
  void initState() {
    super.initState();
    debugPrint(
      '🔕 SMART AD BANNER: Desabilitado (modo gratuito total)',
    );
  }

  @override
  Widget build(BuildContext context) {
    // Nunca mostrar anúncios em modo gratuito
    return const SizedBox.shrink();
  }
}
