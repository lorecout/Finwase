import 'package:flutter/material.dart';
import '../premium_manager.dart';

/// Wraps content and exposes whether premium features should be enabled.
/// 
/// CONFIGURADO PARA: MODO GRATUITO TOTAL
/// - TODOS os usuários recebem recursos premium
/// - Nenhum anúncio é mostrado
/// - Nenhuma compra é necessária
///
/// Example usage:
///
/// PremiumWrapper(
///   adSupported: true,
///   builder: (context, isPremium, showAds) {
///     // isPremium será sempre true
///     // showAds será sempre false
///     return PremiumHome(); // Mostrar conteúdo premium
///   }
/// )
class PremiumWrapper extends StatefulWidget {
  final bool adSupported;
  final Widget Function(BuildContext, bool isPremium, bool showAds) builder;

  const PremiumWrapper({
    super.key,
    required this.adSupported,
    required this.builder,
  });

  @override
  State<PremiumWrapper> createState() => _PremiumWrapperState();
}

class _PremiumWrapperState extends State<PremiumWrapper> {
  // MODO GRATUITO TOTAL: sempre premium, nunca mostra anúncios
  bool _isPremium = true;
  bool _showAds = false;

  @override
  void initState() {
    super.initState();
    // Sem necessidade de carregar, valores já são finais
  }

  @override
  Widget build(BuildContext context) {
    // Sempre retorna premium habilitado e sem anúncios
    return widget.builder(context, _isPremium, _showAds);
  }
}
