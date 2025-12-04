import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/premium_service.dart';
import '../services/theme_service.dart';
import '../services/payment_service.dart';

class PremiumUpgradePage extends StatefulWidget {
  const PremiumUpgradePage({super.key});

  @override
  State<PremiumUpgradePage> createState() => _PremiumUpgradePageState();
}

class _PremiumUpgradePageState extends State<PremiumUpgradePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer3<PremiumService, ThemeService, PaymentService>(
      builder: (context, premiumService, themeService, paymentService, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final cor = themeService.accentColor;

        // Configurar callbacks para dialogs
        paymentService.setDialogCallbacks(
          onSuccess: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message), backgroundColor: Colors.green),
            );
          },
          onError: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message), backgroundColor: Colors.red),
            );
          },
        );

        return Scaffold(
          backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
          appBar: AppBar(
            title: const Text('Upgrade Premium'),
            backgroundColor: isDark ? Colors.grey[800] : Colors.white,
            foregroundColor: isDark ? Colors.white : Colors.black,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header com ícone e texto principal
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        cor.withValues(alpha: 0.1),
                        cor.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: cor.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.stars, size: 48, color: cor),
                      const SizedBox(height: 16),
                      const Text(
                        'Desbloqueie Todo o Potencial',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tenha acesso a relatórios avançados, backup na nuvem e muito mais!',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Planos
                const Text(
                  'Plano Premium',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                // Plano Premium Único
                _buildPlanCard(
                  context: context,
                  title: 'Premium',
                  price: 'R\$ 9,90/mês',
                  features: [
                    'Relatórios avançados em PDF',
                    'Backup na nuvem automático',
                    'Sincronização entre dispositivos',
                    'Análises detalhadas e gráficos',
                    'Categorização inteligente',
                    'Suporte prioritário 24/7',
                    'Acesso a todos os recursos',
                  ],
                  isPopular: true,
                  onTap: () => _showPurchaseDialog(
                    context,
                    'Premium',
                    '9,90',
                    paymentService,
                  ),
                  cor: cor,
                  isDark: isDark,
                ),

                const SizedBox(height: 32),

                // Informações adicionais
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? Colors.grey[700]! : Colors.blue[200]!,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue[700]),
                          const SizedBox(width: 8),
                          Text(
                            'Informações importantes',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '• Pagamento seguro através do Google Play\n'
                        '• Cancele a qualquer momento\n'
                        '• Renovação automática\n'
                        '• Suporte 24/7 para assinantes',
                        style: TextStyle(
                          color: isDark ? Colors.grey[300] : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlanCard({
    required BuildContext context,
    required String title,
    required String price,
    String? originalPrice,
    required List<String> features,
    required bool isPopular,
    required VoidCallback onTap,
    required Color cor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPopular
              ? cor
              : (isDark ? Colors.grey[700]! : Colors.grey[200]!),
          width: isPopular ? 2 : 1,
        ),
        boxShadow: isPopular
            ? [
                BoxShadow(
                  color: cor.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isPopular) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: cor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'POPULAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: cor,
                ),
              ),
              if (originalPrice != null) ...[
                const SizedBox(width: 8),
                Text(
                  originalPrice,
                  style: TextStyle(
                    fontSize: 16,
                    decoration: TextDecoration.lineThrough,
                    color: isDark ? Colors.grey[500] : Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(feature, style: const TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: isPopular ? cor : Colors.grey[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Assinar $title',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPurchaseDialog(
    BuildContext context,
    String planName,
    String price,
    PaymentService paymentService,
  ) {
    String productId = '';
    if (planName == 'Básico') {
      productId = 'premium_monthly_basic';
    } else if (planName == 'Premium') {
      productId = 'premium_monthly';
    } else if (planName == 'Anual') {
      productId = 'premium_yearly';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Assinar $planName'),
        content: Text(
          'Você será redirecionado para o Google Play para concluir a compra de R\$ $price.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final currentContext = context;
              Navigator.pop(context);

              // Mostrar loading
              ScaffoldMessenger.of(currentContext).showSnackBar(
                const SnackBar(
                  content: Text('Redirecionando para o Google Play...'),
                  duration: Duration(seconds: 2),
                ),
              );

              // Buscar o produto correspondente
              final product = paymentService.products.firstWhere(
                (p) => p.id == productId,
                orElse: () => throw Exception('Produto não encontrado'),
              );

              try {
                // Iniciar compra
                final success = await paymentService.buyProduct(product);

                if (!success && currentContext.mounted) {
                  ScaffoldMessenger.of(currentContext).showSnackBar(
                    const SnackBar(
                      content: Text('Erro ao iniciar compra. Tente novamente.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } catch (e) {
                if (currentContext.mounted) {
                  ScaffoldMessenger.of(currentContext).showSnackBar(
                    SnackBar(
                      content: Text('Erro: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }
}
