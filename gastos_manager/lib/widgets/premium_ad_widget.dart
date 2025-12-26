import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/premium_service.dart';

import 'package:firebase_auth/firebase_auth.dart';

/// Widget que mostra call-to-action para premium quando usuário é free
class PremiumAdWidget extends StatelessWidget {
  final String message;
  final String buttonText;
  final IconData icon;

  const PremiumAdWidget({
    super.key,
    this.message = '🚀 Remova anúncios e desbloqueie recursos avançados!',
    this.buttonText = 'UPGRADE PREMIUM',
    this.icon = Icons.workspace_premium,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<PremiumService>(
      builder: (context, premiumService, child) {
        // Se for premium, não mostrar
        if (premiumService.isPremium) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.amber.withValues(alpha: 0.1),
                Colors.orange.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.amber.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.amber[700], size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.amber[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Sem limites, sem anúncios, mais recursos',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  final user = Provider.of<PremiumService>(
                    context,
                    listen: false,
                  );
                  // Checa autenticação via FirebaseAuth diretamente
                  final currentUser = FirebaseAuth.instance.currentUser;
                  if (currentUser == null) {
                    Navigator.pushNamed(context, '/auth');
                  } else {
                    Navigator.pushNamed(context, '/premium-upgrade');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
