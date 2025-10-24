import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Sistema de Design Unificado baseado na LoadingScreen
/// Contém todos os elementos visuais e componentes reutilizáveis
class DesignSystem {
  // ===== PALETA DE CORES =====
  static const Color primaryBlue = Color(0xFF1a237e);
  static const Color mediumBlue = Color(0xFF3949ab);
  static const Color primaryPurple = Color(0xFF5e35b1);

  // ===== GRADIENTES =====
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primaryBlue, // Azul escuro
      mediumBlue, // Azul médio
      primaryPurple, // Roxo
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // Gradiente dinâmico baseado na cor do usuário
  static LinearGradient getDynamicBackgroundGradient(Color baseColor) {
    // Criar variações da cor base para o gradiente
    final hsl = HSLColor.fromColor(baseColor);

    // Cor mais escura para o topo
    final darkColor = hsl
        .withLightness((hsl.lightness * 0.6).clamp(0.1, 0.4))
        .toColor();

    // Cor média
    final mediumColor = hsl
        .withLightness((hsl.lightness * 0.8).clamp(0.3, 0.7))
        .toColor();

    // Cor mais clara/accent para o fundo
    final lightColor = hsl
        .withLightness((hsl.lightness * 1.2).clamp(0.6, 0.9))
        .toColor();

    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [darkColor, mediumColor, lightColor],
      stops: [0.0, 0.5, 1.0],
    );
  }

  static const LinearGradient logoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.white, Color(0xFFE8EAF6)],
  );

  // ===== SOMBRAS =====
  static const List<Shadow> textShadow = [
    Shadow(color: Colors.white24, blurRadius: 15, offset: Offset(0, 0)),
  ];

  static const List<BoxShadow> logoShadow = [
    BoxShadow(color: Colors.white24, blurRadius: 20, spreadRadius: 5),
  ];

  // ===== ESTILOS DE TEXTO =====
  static const TextStyle titleStyle = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    shadows: textShadow,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: Colors.white70,
    fontWeight: FontWeight.w300,
  );

  static const TextStyle captionStyle = TextStyle(
    fontSize: 14,
    color: Colors.white60,
    fontWeight: FontWeight.w500,
  );

  // ===== COMPONENTES ANIMADOS =====

  /// Container base com gradiente de fundo e animações
  static Widget buildAnimatedBackground({
    required Widget child,
    bool showWaves = true,
    bool showParticles = true,
    Color? baseColor,
  }) {
    final gradient = baseColor != null
        ? getDynamicBackgroundGradient(baseColor)
        : backgroundGradient;

    return Container(
      decoration: BoxDecoration(gradient: gradient),
      child: Stack(
        children: [
          if (showWaves) const AnimatedWavePattern(),
          if (showParticles) const EnhancedParticles(),
          child,
        ],
      ),
    );
  }

  /// Logo pulsante reutilizável
  static Widget buildPulsingLogo({
    double size = 140,
    IconData icon = Icons.show_chart,
    double iconSize = 80,
  }) {
    return PulsingLogo(size: size, icon: icon, iconSize: iconSize);
  }

  /// Ícone do app pulsante com imagem personalizada
  static Widget buildPulsingAppIcon({double size = 140}) {
    return PulsingAppIcon(size: size);
  }

  /// Texto com efeito de digitação
  static Widget buildTypingText({
    required String text,
    TextStyle? style,
    Duration duration = const Duration(seconds: 2),
  }) {
    return TypingText(
      text: text,
      style: style ?? titleStyle,
      duration: duration,
    );
  }

  /// Barra de progresso estilizada
  static Widget buildProgressBar({
    required double progress,
    double width = 0.8,
    double height = 4,
  }) {
    return Builder(
      builder: (context) => SizedBox(
        width: MediaQuery.of(context).size.width * width,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Botão estilizado consistente com o design
  static Widget buildStyledButton({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Colors.white,
        foregroundColor: foregroundColor ?? primaryBlue,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(primaryBlue),
              ),
            )
          : Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
    );
  }

  /// Botão outline estilizado
  static Widget buildStyledOutlineButton({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    Widget? leading,
  }) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.white),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leading != null) ...[leading, const SizedBox(width: 12)],
          Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// ===== COMPONENTES ANIMADOS REUTILIZÁVEIS =====

class AnimatedWavePattern extends StatefulWidget {
  const AnimatedWavePattern({super.key});

  @override
  State<AnimatedWavePattern> createState() => _AnimatedWavePatternState();
}

class _AnimatedWavePatternState extends State<AnimatedWavePattern>
    with TickerProviderStateMixin {
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        return CustomPaint(
          painter: AnimatedWavePainter(_waveController.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class AnimatedWavePainter extends CustomPainter {
  final double animationValue;

  AnimatedWavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();

    for (double y = 0; y < size.height; y += 60) {
      path.moveTo(0, y);
      for (double x = 0; x < size.width; x += 25) {
        final waveOffset =
            math.sin((x * 0.008) + (animationValue * 2 * math.pi)) * 15;
        path.lineTo(x, y + waveOffset);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(AnimatedWavePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}

class EnhancedParticles extends StatefulWidget {
  const EnhancedParticles({super.key});

  @override
  State<EnhancedParticles> createState() => _EnhancedParticlesState();
}

class _EnhancedParticlesState extends State<EnhancedParticles>
    with TickerProviderStateMixin {
  static const int PARTICLE_COUNT = 25;
  late List<EnhancedParticle> particles;
  late List<AnimationController> controllers;

  @override
  void initState() {
    super.initState();
    _initializeParticles();
  }

  void _initializeParticles() {
    particles = [];
    controllers = [];

    for (int i = 0; i < PARTICLE_COUNT; i++) {
      final controller = AnimationController(
        duration: Duration(seconds: math.Random().nextInt(20) + 15),
        vsync: this,
      );

      final particle = EnhancedParticle(
        id: i,
        size: math.Random().nextDouble() * 6 + 2,
        startX: math.Random().nextDouble() * 100,
        startY: 120 + math.Random().nextDouble() * 80,
        endY: -20,
        tx: (math.Random().nextDouble() - 0.5) * 120,
        controller: controller,
        color: _getRandomParticleColor(),
      );

      particles.add(particle);
      controllers.add(controller);

      Future.delayed(Duration(seconds: math.Random().nextInt(15)), () {
        if (mounted) {
          controller.repeat();
        }
      });
    }
  }

  Color _getRandomParticleColor() {
    final colors = [
      Colors.white.withValues(alpha: 0.4),
      Colors.blue.withValues(alpha: 0.3),
      Colors.purple.withValues(alpha: 0.3),
      Colors.cyan.withValues(alpha: 0.3),
    ];
    return colors[math.Random().nextInt(colors.length)];
  }

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: particles.map((particle) {
        return AnimatedBuilder(
          animation: particle.controller,
          builder: (context, child) {
            final progress = particle.controller.value;
            final currentY =
                particle.startY + (particle.endY - particle.startY) * progress;
            final currentX = particle.startX + particle.tx * progress;
            final opacity = (1 - progress * 0.7).clamp(0.0, 1.0);

            return Positioned(
              left: currentX,
              top: currentY,
              child: Container(
                width: particle.size,
                height: particle.size,
                decoration: BoxDecoration(
                  color: particle.color.withValues(alpha: opacity),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: particle.color.withValues(alpha: opacity * 0.5),
                      blurRadius: 3,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

class EnhancedParticle {
  final int id;
  final double size;
  final double startX;
  final double startY;
  final double endY;
  final double tx;
  final AnimationController controller;
  final Color color;

  EnhancedParticle({
    required this.id,
    required this.size,
    required this.startX,
    required this.startY,
    required this.endY,
    required this.tx,
    required this.controller,
    required this.color,
  });
}

class PulsingLogo extends StatefulWidget {
  final double size;
  final IconData icon;
  final double iconSize;

  const PulsingLogo({
    super.key,
    this.size = 140,
    this.icon = Icons.show_chart,
    this.iconSize = 80,
  });

  @override
  State<PulsingLogo> createState() => _PulsingLogoState();
}

class _PulsingLogoState extends State<PulsingLogo>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: DesignSystem.logoGradient,
                boxShadow: DesignSystem.logoShadow,
              ),
              child: Icon(
                widget.icon,
                size: widget.iconSize,
                color: DesignSystem.primaryBlue,
              ),
            ),
          ),
        );
      },
    );
  }
}

class PulsingAppIcon extends StatefulWidget {
  final double size;

  const PulsingAppIcon({super.key, this.size = 140});

  @override
  State<PulsingAppIcon> createState() => _PulsingAppIconState();
}

class _PulsingAppIconState extends State<PulsingAppIcon>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: DesignSystem.logoGradient,
                boxShadow: DesignSystem.logoShadow,
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/icon/novo-icone.png',
                  fit: BoxFit.cover,
                  width: widget.size,
                  height: widget.size,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class TypingText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;

  const TypingText({
    super.key,
    required this.text,
    this.style,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<TypingText> createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> with TickerProviderStateMixin {
  late AnimationController _typingController;
  late Animation<int> _textAnimation;

  @override
  void initState() {
    super.initState();
    _typingController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _textAnimation = IntTween(begin: 0, end: widget.text.length).animate(
      CurvedAnimation(parent: _typingController, curve: Curves.easeInOut),
    );

    _typingController.forward();
  }

  @override
  void dispose() {
    _typingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _textAnimation,
      builder: (context, child) {
        final text = widget.text.substring(0, _textAnimation.value);
        return Text(text, style: widget.style);
      },
    );
  }
}
