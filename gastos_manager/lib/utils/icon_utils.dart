import 'package:flutter/material.dart';
import '../widgets/safe_asset_image.dart';

/// Utilitários para ícones adaptativos do app
class IconUtils {
  /// Retorna um ícone adaptativo que se redimensiona automaticamente
  /// baseado no contexto e tamanho disponível
  static Widget buildAdaptiveIcon({
    required BuildContext context,
    required String assetPath,
    double? size,
    Color? color,
    BoxFit fit = BoxFit.contain,
    double? maxSize,
    double? minSize,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    // Calcula tamanho adaptativo baseado na tela
    double adaptiveSize = size ?? (isSmallScreen ? 24 : 32);

    if (maxSize != null && adaptiveSize > maxSize) {
      adaptiveSize = maxSize;
    }

    if (minSize != null && adaptiveSize < minSize) {
      adaptiveSize = minSize;
    }

    return SizedBox(
      width: adaptiveSize,
      height: adaptiveSize,
      child: SafeAssetImage(
        assetPath,
        width: adaptiveSize,
        height: adaptiveSize,
        fit: fit,
        color: color,
      ),
    );
  }

  /// Ícone específico para a tela de login
  static Widget buildLoginIcon(BuildContext context) {
    return buildAdaptiveIcon(
      context: context,
      assetPath: 'assets/onboarding/welcome.png',
      size: 60,
      maxSize: 80,
      minSize: 50,
    );
  }

  /// Ícone específico para navegação inferior
  static Widget buildNavigationIcon(BuildContext context) {
    return buildAdaptiveIcon(
      context: context,
      assetPath: 'assets/onboarding/welcome.png',
      size: 24,
      maxSize: 28,
      minSize: 20,
    );
  }

  /// Ícone específico para AppBar
  static Widget buildAppBarIcon(BuildContext context, {Color? color}) {
    return buildAdaptiveIcon(
      context: context,
      assetPath: 'assets/onboarding/welcome.png',
      size: 24,
      maxSize: 28,
      minSize: 20,
      color: color,
    );
  }
}
