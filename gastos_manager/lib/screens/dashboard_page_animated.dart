import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/premium_service.dart';
import '../services/theme_service.dart';
import '../services/app_state.dart';
import '../utils/design_system.dart';
import '../widgets/premium_feature_access_page.dart';

class DashboardPageAnimated extends StatefulWidget {
  const DashboardPageAnimated({super.key});

  @override
  State<DashboardPageAnimated> createState() => _DashboardPageAnimatedState();
}

class _DashboardPageAnimatedState extends State<DashboardPageAnimated> {
  @override
  Widget build(BuildContext context) {
    return Consumer3<ThemeService, PremiumService, AppState>(
      builder: (context, themeService, premiumService, appState, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primary,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            elevation: 0,
            title: Row(
              children: [
                DesignSystem.buildPulsingAppIcon(size: 32),
                const SizedBox(width: 8),
                DesignSystem.buildTypingText(
                  text: 'FinWise',
                  style: DesignSystem.subtitleStyle.copyWith(fontSize: 20),
                  duration: const Duration(milliseconds: 500),
                ),
              ],
            ),
          ),
          body: DesignSystem.buildAnimatedBackground(
            baseColor: themeService.accentColor,
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Saudação animada
                    DesignSystem.buildTypingText(
                      text: 'Olá, Usuário!',
                      style: DesignSystem.titleStyle.copyWith(fontSize: 28),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Aqui está um resumo das suas finanças',
                      style: DesignSystem.bodyStyle,
                    ),

                    // Status Premium
                    if (premiumService.shouldShowAlert ||
                        !premiumService.isPremium) ...[
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, '/premium-upgrade'),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: themeService.accentColor.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: themeService.accentColor.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                premiumService.getStatusIcon(),
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  premiumService.getStatusMessage(),
                                  style: DesignSystem.bodyStyle.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ] else if (premiumService.isPremium) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.green.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.verified,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                premiumService.getStatusMessage(),
                                style: DesignSystem.bodyStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 32),

                    // Card Principal do Saldo
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.account_balance_wallet,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Saldo Total',
                                    style: DesignSystem.bodyStyle.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Este mês',
                                  style: DesignSystem.captionStyle.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'R\$ ${appState.saldoTotal.toStringAsFixed(2)}',
                            style: DesignSystem.titleStyle.copyWith(
                              fontSize: 36,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Receitas e Despesas
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.green.withValues(
                                        alpha: 0.3,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.arrow_upward,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Receitas',
                                            style: DesignSystem.bodyStyle
                                                .copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'R\$ ${appState.receitasPeriodo.toStringAsFixed(2)}',
                                        style: DesignSystem.titleStyle.copyWith(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.red.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.arrow_downward,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Despesas',
                                            style: DesignSystem.bodyStyle
                                                .copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'R\$ ${appState.despesasPeriodo.toStringAsFixed(2)}',
                                        style: DesignSystem.titleStyle.copyWith(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Ações Rápidas
                    Text(
                      'Ações Rápidas',
                      style: DesignSystem.subtitleStyle.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DesignSystem.buildStyledButton(
                            text: 'Adicionar',
                            onPressed: () {
                              Navigator.pushNamed(context, '/add-transaction');
                            },
                            backgroundColor: themeService.accentColor,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DesignSystem.buildStyledButton(
                            text: premiumService.isPremium
                                ? 'Massa'
                                : 'Premium',
                            onPressed: () {
                              if (premiumService.isPremium) {
                                Navigator.pushNamed(
                                  context,
                                  '/bulk-transactions',
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PremiumFeatureAccessPage(
                                      featureName: 'Registros em Massa',
                                      featureDescription:
                                          'Adicione múltiplas transações de forma rápida e eficiente',
                                      featureIcon: Icons.grid_view,
                                      onAccessGranted: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/bulk-transactions',
                                        );
                                      },
                                    ),
                                  ),
                                );
                              }
                            },
                            backgroundColor: premiumService.isPremium
                                ? Colors.amber
                                : Colors.grey[400],
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Terceira linha de ações
                    Row(
                      children: [
                        Expanded(
                          child: DesignSystem.buildStyledOutlineButton(
                            text: 'Histórico',
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/main',
                                arguments: 1,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DesignSystem.buildStyledOutlineButton(
                            text: 'Relatórios',
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/main',
                                arguments: 2,
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
