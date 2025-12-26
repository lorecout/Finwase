import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gastos_manager/services/premium_service.dart';
import 'package:gastos_manager/utils/snackbar_utils.dart';
import 'package:gastos_manager/constants.dart';

/// Widget para a seção premium nas configurações
/// CONFIGURADO PARA: MODO GRATUITO TOTAL
/// - Sempre mostra status premium ativo
/// - Sem opção de upgrade ou compra
/// - Sem anúncios recompensados
class PremiumSettingsSection extends StatelessWidget {
  const PremiumSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PremiumService>(
      builder: (context, premiumService, child) => Card(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.green.withValues(alpha: 0.1),
                Colors.teal.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.green.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: [
              _buildSettingsTile(
                context,
                icon: Icons.verified,
                title: '✅ Premium Ativo - Totalmente Grátis',
                subtitle: 'Todos os recursos estão disponíveis sem custos',
                onTap: null,
                trailing: const Icon(Icons.verified, color: Colors.green),
              ),
              _buildDivider(),
              _buildSettingsTile(
                context,
                icon: Icons.card_giftcard,
                title: 'Plano Atual',
                subtitle: 'GRATUITO - ACESSO COMPLETO',
                onTap: null,
              ),
              _buildDivider(),
              _buildSettingsTile(
                context,
                icon: Icons.star,
                title: 'Funcionalidades',
                subtitle: 'Todos os recursos premium estão desbloqueados',
                onTap: null,
              ),
              _buildDivider(),
              _buildSettingsTile(
                context,
                icon: Icons.remove_circle_outline,
                title: 'Anúncios',
                subtitle: 'Sem anúncios - experiência limpa',
                onTap: null,
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
      trailing: trailing ?? const Icon(Icons.check_circle, color: Colors.green),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, indent: 56);
  }
}
