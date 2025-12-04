import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gastos_manager/services/referral_service.dart';
import 'package:gastos_manager/utils/snackbar_utils.dart';

/// Página para gerenciar e compartilhar código de referência
class ReferralPage extends StatefulWidget {
  const ReferralPage({super.key});

  @override
  State<ReferralPage> createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeReferralCode();
  }

  Future<void> _initializeReferralCode() async {
    final referralService = Provider.of<ReferralService>(
      context,
      listen: false,
    );
    setState(() => _isLoading = true);
    try {
      await referralService.generateReferralCode();
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showError(context, 'Erro ao gerar código de referência');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    SnackBarUtils.showSuccess(context, 'Código copiado para clipboard!');
  }

  void _shareCode() {
    final referralService = Provider.of<ReferralService>(
      context,
      listen: false,
    );
    final message = referralService.getShareMessage();
    Share.share(message, subject: '🎁 FinWise - Código de Referência');
  }

  void _redeemCode() {
    showDialog(context: context, builder: (context) => _RedeemCodeDialog());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('💰 Programa de Referência'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        elevation: 0,
      ),
      body: Consumer<ReferralService>(
        builder: (context, referralService, _) {
          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Hero section
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.primaryContainer,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.people, size: 48, color: Colors.white),
                      SizedBox(height: 12),
                      Text(
                        'Convide Amigos!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Ganhe 1 mês de Premium para cada amigo que se inscrever',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Código de referência
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          'SEU CÓDIGO DE REFERÊNCIA',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (referralService.referralCode != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 24,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              referralService.referralCode ?? '',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                                letterSpacing: 4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _copyToClipboard(
                                  referralService.referralCode ?? '',
                                ),
                                icon: const Icon(Icons.copy),
                                label: const Text('Copiar'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _shareCode,
                                icon: const Icon(Icons.share),
                                label: const Text('Compartilhar'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Estatísticas
                Row(
                  children: [
                    Expanded(
                      child: _StatisticCard(
                        icon: Icons.people,
                        title: 'Amigos Indicados',
                        value: referralService.referredUsers.toString(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatisticCard(
                        icon: Icons.card_giftcard,
                        title: 'Meses Ganhos',
                        value: '${referralService.premiumMonthsEarned}',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Resgatar código
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(Icons.card_giftcard, size: 32),
                        const SizedBox(height: 12),
                        const Text(
                          'Você tem um código de referência?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Digite o código de um amigo para ganhar 1 mês de Premium',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _redeemCode,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'RESGATAR CÓDIGO',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Benefícios
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Como funciona?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        _BenefitItem(
                          number: 1,
                          title: 'Compartilhe seu código',
                          description:
                              'Envie para amigos por WhatsApp, email ou redes sociais',
                        ),
                        SizedBox(height: 12),
                        _BenefitItem(
                          number: 2,
                          title: 'Amigo se cadastra',
                          description:
                              'Seu amigo baixa o app e usa o seu código ao registrar',
                        ),
                        SizedBox(height: 12),
                        _BenefitItem(
                          number: 3,
                          title: 'Ambos ganham Premium',
                          description:
                              'Você e seu amigo recebem 1 mês de acesso premium',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatisticCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _StatisticCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  final int number;
  final String title;
  final String description;

  const _BenefitItem({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Dialog para resgatar código de referência
class _RedeemCodeDialog extends StatefulWidget {
  @override
  State<_RedeemCodeDialog> createState() => _RedeemCodeDialogState();
}

class _RedeemCodeDialogState extends State<_RedeemCodeDialog> {
  final _codeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _redeemCode() async {
    if (_codeController.text.isEmpty) {
      SnackBarUtils.showError(context, 'Digite um código válido');
      return;
    }

    final referralService = Provider.of<ReferralService>(
      context,
      listen: false,
    );

    setState(() => _isLoading = true);
    try {
      final success = await referralService.redeemReferralCode(
        _codeController.text,
      );

      if (success) {
        if (mounted) {
          SnackBarUtils.showSuccess(
            context,
            '🎉 Código resgatado! Você ganhou 1 mês de Premium!',
          );
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          SnackBarUtils.showError(context, 'Código inválido ou já utilizado');
        }
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showError(context, 'Erro ao resgatar código');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Resgatar Código de Referência'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Digite o código de referência que você recebeu:',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _codeController,
            enabled: !_isLoading,
            decoration: InputDecoration(
              hintText: 'Ex: AB12345678',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            textCapitalization: TextCapitalization.characters,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _redeemCode,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Resgatar'),
        ),
      ],
    );
  }
}
