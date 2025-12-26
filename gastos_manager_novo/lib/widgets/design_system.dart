import 'package:flutter/material.dart';

/// Sistema de Design do App - Componentes e utilitários consistentes
/// para manter uma experiência visual harmoniosa em todo o aplicativo

/// ==========================================
/// ESPAÇAMENTOS CONSISTENTES
/// ==========================================

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  // Padding patterns
  static const EdgeInsets screenPadding = EdgeInsets.all(md);
  static const EdgeInsets cardPadding = EdgeInsets.all(md);
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );

  // Widget extensions para facilitar uso
  static SizedBox get xsBox => const SizedBox(height: xs, width: xs);
  static SizedBox get smBox => const SizedBox(height: sm, width: sm);
  static SizedBox get mdBox => const SizedBox(height: md, width: md);
  static SizedBox get lgBox => const SizedBox(height: lg, width: lg);
  static SizedBox get xlBox => const SizedBox(height: xl, width: xl);
  static SizedBox get xxlBox => const SizedBox(height: xxl, width: xxl);

  // Padding helpers
  static EdgeInsets get xsPadding => const EdgeInsets.all(xs);
  static EdgeInsets get smPadding => const EdgeInsets.all(sm);
  static EdgeInsets get mdPadding => const EdgeInsets.all(md);
  static EdgeInsets get lgPadding => const EdgeInsets.all(lg);
  static EdgeInsets get xlPadding => const EdgeInsets.all(xl);
  static EdgeInsets get xxlPadding => const EdgeInsets.all(xxl);
}

/// ==========================================
/// TIPOGRAFIA CONSISTENTE
/// ==========================================

class AppTypography {
  static TextStyle displayLarge(BuildContext context) =>
      Theme.of(context).textTheme.displayLarge!.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle displayMedium(BuildContext context) =>
      Theme.of(context).textTheme.displayMedium!.copyWith(
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle headlineLarge(BuildContext context) =>
      Theme.of(context).textTheme.headlineLarge!.copyWith(
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle headlineMedium(BuildContext context) =>
      Theme.of(context).textTheme.headlineMedium!.copyWith(
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle bodyLarge(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.9),
      );

  static TextStyle bodyMedium(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
      );

  static TextStyle labelMedium(BuildContext context) =>
      Theme.of(context).textTheme.labelMedium!.copyWith(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
      );

  static TextStyle labelSmall(BuildContext context) =>
      Theme.of(context).textTheme.labelSmall!.copyWith(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
      );
}

/// ==========================================
/// SISTEMA DE CORES SEMÂNTICAS
/// ==========================================

class AppColors {
  // Cores semânticas
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Variações
  static Color successLight = success.withValues(alpha: 0.1);
  static Color errorLight = error.withValues(alpha: 0.1);
  static Color warningLight = warning.withValues(alpha: 0.1);
  static Color infoLight = info.withValues(alpha: 0.1);

  // Método para obter cor baseada no contexto
  static Color getSuccessColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? success : success;

  static Color getErrorColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? error : error;

  static Color getWarningColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? warning : warning;

  static Color getInfoColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? info : info;
}

/// ==========================================
/// COMPONENTE CARD PADRONIZADO
/// ==========================================

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double borderRadius;
  final List<BoxShadow>? shadows;
  final Border? border;

  const AppCard({
    super.key,
    required this.child,
    this.padding = AppSpacing.cardPadding,
    this.onTap,
    this.backgroundColor,
    this.borderRadius = 16,
    this.shadows,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final defaultShadows =
        shadows ??
        [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ];

    final defaultBorder =
        border ??
        Border.all(
          color: isDark
              ? Colors.grey[700]!.withValues(alpha: 0.5)
              : Colors.grey[200]!,
          width: 1,
        );

    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: defaultBorder,
        boxShadow: defaultShadows,
      ),
      child: child,
    );

    return onTap != null
        ? InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(borderRadius),
            child: card,
          )
        : card;
  }
}

/// ==========================================
/// BOTÃO PADRONIZADO
/// ==========================================

enum AppButtonType { primary, secondary, outline, ghost }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isLoading;
  final Widget? leading;
  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.leading,
    this.width,
    this.height = 48,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    ButtonStyle style;
    switch (type) {
      case AppButtonType.primary:
        style = ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(12),
          ),
        );
        break;
      case AppButtonType.secondary:
        style = ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.secondary,
          foregroundColor: theme.colorScheme.onSecondary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(12),
          ),
        );
        break;
      case AppButtonType.outline:
        style = OutlinedButton.styleFrom(
          side: BorderSide(color: theme.colorScheme.primary),
          foregroundColor: theme.colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(12),
          ),
        );
        break;
      case AppButtonType.ghost:
        style = TextButton.styleFrom(
          foregroundColor: theme.colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(12),
          ),
        );
        break;
    }

    final buttonChild = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                type == AppButtonType.primary || type == AppButtonType.secondary
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.primary,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...leading != null ? [leading!, AppSpacing.smBox] : [],
              Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          );

    final button = SizedBox(
      width: width,
      height: height,
      child: type == AppButtonType.outline || type == AppButtonType.ghost
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: style,
              child: buttonChild,
            )
          : type == AppButtonType.ghost
          ? TextButton(
              onPressed: isLoading ? null : onPressed,
              style: style,
              child: buttonChild,
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: style,
              child: buttonChild,
            ),
    );

    return button;
  }
}

/// ==========================================
/// UTILITÁRIOS RESPONSIVOS
/// ==========================================

class ResponsiveUtils {
  static double getScreenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;
  static double getScreenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static bool isMobile(BuildContext context) => getScreenWidth(context) < 600;
  static bool isTablet(BuildContext context) =>
      getScreenWidth(context) >= 600 && getScreenWidth(context) < 1200;
  static bool isDesktop(BuildContext context) =>
      getScreenWidth(context) >= 1200;

  static double responsiveFontSize(BuildContext context, double baseSize) {
    final screenWidth = getScreenWidth(context);
    if (screenWidth < 360) return baseSize * 0.8; // Small phones
    if (screenWidth > 1200) return baseSize * 1.2; // Large screens
    return baseSize;
  }

  static EdgeInsets responsivePadding(
    BuildContext context, {
    double base = AppSpacing.md,
  }) {
    final screenWidth = getScreenWidth(context);
    final multiplier = screenWidth < 360
        ? 0.75
        : screenWidth > 1200
        ? 1.5
        : 1.0;
    return EdgeInsets.all(base * multiplier);
  }

  static double responsiveBorderRadius(
    BuildContext context, {
    double base = 16,
  }) {
    final screenWidth = getScreenWidth(context);
    if (screenWidth < 360) return base * 0.8;
    if (screenWidth > 1200) return base * 1.2;
    return base;
  }
}

/// ==========================================
/// ANIMAÇÕES CONSISTENTES
/// ==========================================

class AppAnimations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);

  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve bounceOut = Curves.bounceOut;

  static Widget fadeIn({
    required Widget child,
    Duration duration = normal,
    Curve curve = easeOut,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: duration,
      curve: curve,
      builder: (context, opacity, child) {
        return Opacity(opacity: opacity, child: child);
      },
      child: child,
    );
  }

  static Widget slideIn({
    required Widget child,
    Duration duration = normal,
    Offset beginOffset = const Offset(0, 0.1),
  }) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween<Offset>(begin: beginOffset, end: Offset.zero),
      duration: duration,
      curve: easeOut,
      builder: (context, offset, child) {
        return Transform.translate(offset: offset, child: child);
      },
      child: child,
    );
  }

  static Widget scaleIn({
    required Widget child,
    Duration duration = normal,
    double beginScale = 0.8,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: beginScale, end: 1),
      duration: duration,
      curve: easeOut,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: child,
    );
  }
}

/// ==========================================
/// EXTENSÕES PARA FACILITAR USO
/// ==========================================

extension SpacingExtension on num {
  SizedBox get height => SizedBox(height: toDouble());
  SizedBox get width => SizedBox(width: toDouble());
}

extension ColorExtension on Color {
  Color withOpacityFactor(double factor) => withValues(alpha: a * factor);
}
