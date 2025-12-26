import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gastos_manager/services/premium_service.dart';
import 'package:gastos_manager/services/smart_interstitial_service.dart';
import 'package:gastos_manager/utils/snackbar_utils.dart';

/// Tela intermediária para acesso a recursos premium via anúncios recompensados
class PremiumFeatureAccessPage extends StatefulWidget {
  final String featureName;
  final String featureDescription;
  final IconData featureIcon;
  final VoidCallback onAccessGranted;

  const PremiumFeatureAccessPage({
    super.key,
    required this.featureName,
    required this.featureDescription,
    required this.featureIcon,
    required this.onAccessGranted,
  });

  @override
  State<PremiumFeatureAccessPage> createState() =>
      _PremiumFeatureAccessPageState();
}

class _PremiumFeatureAccessPageState extends State<PremiumFeatureAccessPage> {
  bool _isLoading = false;

  Future<void> _watchAdForAccess() async {
    setState(() => _isLoading = true);

    try {
      final premiumService = Provider.of<PremiumService>(
        context,
        listen: false,
      );
      final interstitialService = SmartInterstitialService();

      final success = await interstitialService.showRewarded(
        context,
        onRewarded: () {
          // Conceder acesso premium temporário
          premiumService.grantTemporaryPremium(
            minutes: 30,
          ); // 30 minutos de acesso
        },
        rewardMessage:
            'Assista ao anúncio para liberar ${widget.featureName} por 30 minutos!',
      );

      if (success && mounted) {
        SnackBarUtils.showSuccess(
          context,
          '🎁 Acesso liberado! Você tem 30 minutos para usar ${widget.featureName}',
        );

        // Navegar para o recurso após um pequeno delay
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            widget.onAccessGranted();
          }
        });
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showError(
          context,
          'Erro ao carregar anúncio. Tente novamente.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _goToPremiumUpgrade() {
    Navigator.of(context).pushNamed('/premium-upgrade');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.featureName),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícone do recurso
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.featureIcon,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            const SizedBox(height: 24),

            // Título
            Text(
              widget.featureName,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Descrição
            Text(
              widget.featureDescription,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // Badge Premium
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'RECURSO PREMIUM',
                    style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),

            // Botão de anúncio recompensado
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _watchAdForAccess,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.play_circle_fill),
                label: Text(
                  _isLoading
                      ? 'Carregando anúncio...'
                      : 'Ver Anúncio (30min Grátis)',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Texto explicativo
            Text(
              'Assista um anúncio curto e tenha acesso imediato por 30 minutos',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Divider
            Row(
              children: [
                Expanded(child: Divider(color: Theme.of(context).dividerColor)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'OU',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: Theme.of(context).dividerColor)),
              ],
            ),

            const SizedBox(height: 32),

            // Botão de upgrade premium
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _goToPremiumUpgrade,
                icon: const Icon(Icons.star_border),
                label: const Text('Fazer Upgrade Premium'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Benefícios do premium
            Text(
              'Acesso ilimitado a todos os recursos premium',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
