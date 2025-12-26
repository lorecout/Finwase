import 'package:flutter/material.dart';
import '../widgets/safe_asset_image.dart';

class LoadingScreen extends StatefulWidget {
  final String? loadingMessage;
  final double? progress;
  final Color? baseColor;

  const LoadingScreen({
    super.key,
    this.loadingMessage,
    this.progress,
    this.baseColor,
  });

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.baseColor ?? const Color(0xFF1a237e),
              (widget.baseColor ?? const Color(0xFF1a237e)).withValues(
                alpha: 0.8,
              ),
              const Color(0xFF0d47a1),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícone do app
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: const SafeAssetImage(
                    'assets/onboarding/welcome.png',
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Nome do app
              const Text(
                'FinWise',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),

              const SizedBox(height: 8),

              // Subtítulo
              Text(
                widget.loadingMessage ??
                    'Gerenciando suas finanças com inteligência',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              // Indicador de carregamento
              SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  value: widget.progress,
                  strokeWidth: 4,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                ),
              ),

              const SizedBox(height: 16),

              // Texto de status
              Text(
                widget.progress != null
                    ? '${(widget.progress! * 100).round()}%'
                    : 'Carregando...',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white60,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
