import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gastos_manager/services/premium_service.dart';
import 'package:gastos_manager/config.dart';

class PremiumFeatureAccessPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    // Se FORCE_PREMIUM está ativo, liberar acesso imediatamente
    if (FORCE_PREMIUM) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onAccessGranted();
      });
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Código original para quando premium não está forçado
    return Scaffold(
      appBar: AppBar(
        title: Text(featureName),
      ),
      body: const Center(
        child: Text('Recurso Premium'),
      ),
    );
  }
}
