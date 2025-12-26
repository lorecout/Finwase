import 'package:flutter/material.dart';
import '../widgets/safe_asset_image.dart';

class TrialPremiumPage extends StatelessWidget {
  final VoidCallback? onContinue;
  const TrialPremiumPage({super.key, this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SafeAssetImage(
                'assets/onboarding/premium.png',
                height: 120,
                fallbackAsset: 'assets/onboarding/welcome.png',
              ),
              const SizedBox(height: 32),
              const Text(
                'Teste o Premium por 7 dias!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Desbloqueie todos os recursos avançados do FinWise sem compromisso. Experimente backups automáticos, exportação, temas exclusivos, inserção em massa e muito mais!',
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vantagens do Premium:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('• Backup automático na nuvem'),
                    Text('• Exportação de dados'),
                    Text('• Temas premium e personalização'),
                    Text('• Inserção em massa de transações'),
                    Text('• Suporte prioritário'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onContinue ?? () => Navigator.of(context).pop(),
                icon: const Icon(Icons.star),
                label: const Text('Começar teste grátis'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[800],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 32,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
