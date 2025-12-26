import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';
import '../services/premium_service.dart';

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações de Tema'), elevation: 0),
      body: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Seção Modo do Tema
              _buildSectionHeader('Modo do Tema'),
              const SizedBox(height: 8),
              _buildThemeModeCard(context, themeService),

              const SizedBox(height: 24),

              // Seção Cor de Destaque
              _buildSectionHeader('Cor de Destaque'),
              const SizedBox(height: 8),
              _buildAccentColorCard(context, themeService),

              const SizedBox(height: 24),

              // Seção Cores por Categoria
              _buildSectionHeader('Cores por Categoria'),
              const SizedBox(height: 8),
              _buildCategoryColorsCard(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildThemeModeCard(BuildContext context, ThemeService themeService) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildThemeModeOption(
              context,
              themeService,
              ThemeMode.light,
              'Claro',
              Icons.light_mode,
              'Sempre usar tema claro',
            ),
            const Divider(),
            _buildThemeModeOption(
              context,
              themeService,
              ThemeMode.dark,
              'Escuro',
              Icons.dark_mode,
              'Sempre usar tema escuro',
            ),
            const Divider(),
            _buildThemeModeOption(
              context,
              themeService,
              ThemeMode.system,
              'Sistema',
              Icons.auto_mode,
              'Seguir configuração do sistema',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeModeOption(
    BuildContext context,
    ThemeService themeService,
    ThemeMode mode,
    String title,
    IconData icon,
    String subtitle,
  ) {
    final isSelected = themeService.themeMode == mode;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.primary,
            )
          : null,
      onTap: () => themeService.setThemeMode(mode),
    );
  }

  Widget _buildAccentColorCard(
    BuildContext context,
    ThemeService themeService,
  ) {
    return Consumer<PremiumService>(
      builder: (context, premiumService, child) {
        final isPremium = premiumService.isPremium;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Escolha uma cor para personalizar o tema:',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    if (!isPremium)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'PREMIUM',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                if (!isPremium) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Personalização de cores disponível apenas para usuários premium',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: themeService.predefinedColors.map((color) {
                    final isSelected = themeService.accentColor == color;
                    final isBlueDefault = color == Colors.blue;

                    return GestureDetector(
                      onTap: () async {
                        if (!isPremium && !isBlueDefault) {
                          // Mostrar diálogo de upgrade para premium
                          _showPremiumRequiredDialog(context);
                          return;
                        }

                        final success = await themeService.setAccentColor(
                          color,
                          isPremium || isBlueDefault,
                        );
                        if (!success && !isBlueDefault) {
                          // ignore: use_build_context_synchronously
                          _showPremiumRequiredDialog(context);
                        }
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: isSelected
                                  ? Border.all(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.outline,
                                      width: 3,
                                    )
                                  : null,
                              boxShadow: [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 24,
                                  )
                                : null,
                          ),
                          if (!isPremium && !isBlueDefault)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.lock,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                if (!isPremium) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () =>
                          _showPremiumUpgradeDialog(context, premiumService),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star, size: 20),
                          SizedBox(width: 8),
                          Text('Upgrade para Premium'),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryColorsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cores automáticas por categoria:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ...ThemeService.categoryColors.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: entry.value,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(entry.key, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showPremiumRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.lock, color: Colors.orange),
            SizedBox(width: 8),
            Text('Recurso Premium'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personalização de cores é um recurso exclusivo para usuários premium.',
            ),
            SizedBox(height: 16),
            Text(
              'Com o Premium você pode:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('• Personalizar as cores do app'),
            Text('• Acesso a temas exclusivos'),
            Text('• Recursos avançados de análise'),
            Text('• Suporte prioritário'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showPremiumUpgradeDialog(
                context,
                Provider.of<PremiumService>(context, listen: false),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Upgrade'),
          ),
        ],
      ),
    );
  }

  void _showPremiumUpgradeDialog(
    BuildContext context,
    PremiumService premiumService,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.star, color: Colors.orange),
            SizedBox(width: 8),
            Text('Upgrade para Premium'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Desbloqueie todos os recursos premium!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: const Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 20),
                      SizedBox(width: 8),
                      Text('Personalização completa de cores'),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 20),
                      SizedBox(width: 8),
                      Text('Temas exclusivos premium'),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 20),
                      SizedBox(width: 8),
                      Text('Análises avançadas'),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 20),
                      SizedBox(width: 8),
                      Text('Sem anúncios'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Por apenas R\$ 9,90/mês',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Talvez depois'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navegar para página de upgrade premium
              Navigator.pushNamed(context, '/premium-upgrade');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Assinar Premium'),
          ),
        ],
      ),
    );
  }
}
