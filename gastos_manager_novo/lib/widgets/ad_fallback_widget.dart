import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/premium_service.dart';

/// Widget de fallback quando anúncios não estão disponíveis
class AdFallbackWidget extends StatelessWidget {
  final String reason;
  final VoidCallback? onRetry;

  const AdFallbackWidget({super.key, required this.reason, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.withValues(alpha: 0.1),
            Colors.purple.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.star, color: Colors.blue.shade700, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upgrade para Premium',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    Text(
                      'Experiência completa sem anúncios',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Benefícios Premium
          _buildBenefit('✨ Interface limpa e elegante'),
          _buildBenefit('🚀 Performance otimizada'),
          _buildBenefit('📊 Relatórios avançados'),
          _buildBenefit('🔒 Backup automático'),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/premium');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Ir Premium',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              if (onRetry != null) ...[
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: onRetry,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    side: BorderSide(color: Colors.blue.withValues(alpha: 0.5)),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Tentar Novamente'),
                ),
              ],
            ],
          ),

          // Motivo do fallback (para debug)
          if (reason.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Motivo: $reason',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade500,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBenefit(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}

/// Widget que combina anúncio real com fallback inteligente
class SmartAdWidget extends StatefulWidget {
  final Widget child; // O widget de anúncio real
  final String fallbackReason;

  const SmartAdWidget({
    super.key,
    required this.child,
    this.fallbackReason = 'Anúncio indisponível',
  });

  @override
  State<SmartAdWidget> createState() => _SmartAdWidgetState();
}

class _SmartAdWidgetState extends State<SmartAdWidget> {
  bool _showFallback = false;
  int _retryCount = 0;
  static const int _maxRetries = 2;

  @override
  Widget build(BuildContext context) {
    final premiumService = Provider.of<PremiumService>(context);

    // Usuários Pro não veem nada
    if (premiumService.isPro) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        if (!_showFallback) ...[
          widget.child,
        ] else ...[
          AdFallbackWidget(
            reason: widget.fallbackReason,
            onRetry: _retryCount < _maxRetries ? _retryAd : null,
          ),
        ],
      ],
    );
  }

  void _retryAd() {
    setState(() {
      _showFallback = false;
      _retryCount++;
    });

    // Simular delay antes de tentar novamente
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        // Se ainda não carregou após 10 segundos, mostrar fallback
        Future.delayed(const Duration(seconds: 10), () {
          if (mounted && !_showFallback) {
            setState(() {
              _showFallback = true;
            });
          }
        });
      }
    });
  }

  void showFallback() {
    if (mounted) {
      setState(() {
        _showFallback = true;
      });
    }
  }
}
