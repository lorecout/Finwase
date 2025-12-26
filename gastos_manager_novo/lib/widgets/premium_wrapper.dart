import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/premium_service.dart';

/// Wraps content and exposes whether premium features should be enabled.
///
/// CONFIGURADO PARA: MODO GRATUITO TOTAL COM ANÚNCIOS
/// - TODOS os usuários recebem recursos premium
/// - Anúncios são mostrados para monetização
/// - Nenhuma compra é necessária
///
/// Example usage:
///
/// PremiumWrapper(
///   builder: (context, isPro, showAds) {
///     // isPro será true para plano Pro
///     // showAds true para plano Free
///     return PremiumHome(); // Mostrar conteúdo premium
///   }
/// )
class PremiumWrapper extends StatelessWidget {
  final Widget Function(BuildContext, bool isPro, bool showAds) builder;

  const PremiumWrapper({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<PremiumService>(
      builder: (context, premiumService, _) {
        return builder(
          context,
          premiumService.isPro,
          premiumService.showAds,
        );
      },
    );
  }
}
