import 'package:flutter/material.dart';

/// Widget de banner de anúncio
/// DESABILITADO PARA: MODO GRATUITO TOTAL
/// - Nunca carrega ou exibe anúncios
/// - Retorna sempre SizedBox.shrink() para não ocupar espaço
class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({super.key});

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  @override
  void initState() {
    super.initState();
    debugPrint('🔕 AD BANNER: Desabilitado (modo gratuito total)');
  }

  @override
  Widget build(BuildContext context) {
    // Nunca mostrar anúncios em modo gratuito
    return const SizedBox.shrink();
  }
}
