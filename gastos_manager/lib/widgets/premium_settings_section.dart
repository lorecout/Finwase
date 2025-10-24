import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gastos_manager/services/premium_service.dart';
import 'package:gastos_manager/services/smart_interstitial_service.dart';
import 'package:gastos_manager/utils/snackbar_utils.dart';
import 'package:gastos_manager/constants.dart';

/// Widget para a seção premium nas configurações
class PremiumSettingsSection extends StatelessWidget {
  const PremiumSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PremiumService>(
      builder: (context, premiumService, child) => Card(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: premiumService.isPremium
                  ? [
                      Colors.green.withValues(alpha: 0.1),
                      Colors.teal.withValues(alpha: 0.1),
                    ]
                  : [
                      Colors.amber.withValues(alpha: 0.1),
                      Colors.orange.withValues(alpha: 0.1),
                    ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: premiumService.isPremium
                  ? Colors.green.withValues(alpha: 0.3)
                  : Colors.amber.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: [
              _buildSettingsTile(
                context,
                icon: premiumService.getStatusIcon(),
                title: premiumService.isPremium
                    ? 'Premium Ativo'
                    : 'FinWise Premium',
                subtitle: premiumService.getStatusMessage(),
                onTap: () {
                  if (!premiumService.isPremium) {
                    Navigator.pushNamed(context, '/premium-upgrade');
                  }
                },
                trailing: !premiumService.isPremium
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'UPGRADE',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      )
                    : Icon(Icons.verified, color: Colors.green),
              ),
              if (premiumService.isPremium) ...[
                _buildDivider(),
                _buildSettingsTile(
                  context,
                  icon: Icons.calendar_today,
                  title: 'Plano Atual',
                  subtitle: premiumService.currentPlan.toUpperCase(),
                  onTap: null,
                ),
                if (premiumService.premiumExpiryDate != null) ...[
                  _buildDivider(),
                  _buildSettingsTile(
                    context,
                    icon: Icons.schedule,
                    title: 'Expira em',
                    subtitle:
                        '${premiumService.daysLeft} dias (${_formatDateTime(premiumService.premiumExpiryDate!)})',
                    onTap: null,
                  ),
                ],
              ],
              if (!premiumService.isPremium) ...[
                _buildDivider(),
                _buildRewardedAdTile(context, premiumService),
              ],
              _buildDivider(),
              _buildSettingsTile(
                context,
                icon: Icons.history,
                title: AppConstants.restorePurchases,
                subtitle: AppConstants.recoverPreviousSubscription,
                onTap: () => _restorePurchases(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, indent: 56);
  }

  void _restorePurchases(BuildContext context) {
    SnackBarUtils.showInfo(context, AppConstants.checkingPurchases);
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
  }

  Widget _buildRewardedAdTile(
    BuildContext context,
    PremiumService premiumService,
  ) {
    return RewardedAdButton(
      text: 'Ver Anúncio (1h Premium Grátis)',
      icon: Icons.play_circle_fill,
      onRewarded: () {
        premiumService.grantTemporaryPremium(minutes: 60);
        SnackBarUtils.showSuccess(
          context,
          '🎁 Premium temporário ativado por 1 hora!',
        );
      },
      rewardMessage:
          'Assista ao anúncio para ganhar 1 hora de acesso Premium grátis!',
      color: Colors.green,
    );
  }
}
