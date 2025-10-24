import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firebase_messaging_service.dart';

class NotificationsSettingsPage extends StatefulWidget {
  const NotificationsSettingsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsSettingsPage> createState() =>
      _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {
  late FirebaseMessagingService _firebaseMessagingService;

  @override
  void initState() {
    super.initState();
    _firebaseMessagingService = context.read<FirebaseMessagingService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('⚙️ Configurações de Notificações'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header com status
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue.shade400, Colors.blue.shade600],
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(
                    Icons.notifications_active,
                    size: 40,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  Consumer<FirebaseMessagingService>(
                    builder: (context, fcmService, _) {
                      return Column(
                        children: [
                          Text(
                            fcmService.isInitialized
                                ? '✅ Conectado'
                                : '❌ Desconectado',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (fcmService.deviceToken != null)
                            Text(
                              'Token: ${fcmService.deviceToken!.substring(0, 20)}...',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            // Notificações Push
            _buildNotificationSection(
              title: '📱 Notificações Push',
              items: [
                _buildSwitchTile(
                  title: 'Habilitar Notificações',
                  subtitle: 'Receba notificações do aplicativo',
                  icon: Icons.notifications,
                  settingKey: 'notifications_enabled',
                  onChanged: (value) async {
                    if (value) {
                      await _firebaseMessagingService.reabilitarNotificacoes();
                    } else {
                      await _firebaseMessagingService.desabilitarNotificacoes();
                    }
                  },
                ),
              ],
            ),

            // Alertas de Orçamento
            _buildNotificationSection(
              title: '💰 Alertas de Orçamento',
              items: [
                _buildSwitchTile(
                  title: 'Alerta de Limite Atingido (100%)',
                  subtitle:
                      'Notificação quando você atinge o limite do orçamento',
                  icon: Icons.warning_rounded,
                  settingKey: 'alert_budget_100',
                ),
                _buildSwitchTile(
                  title: 'Alerta em 90% do Orçamento',
                  subtitle: 'Notificação quando você gasta 90% do orçamento',
                  icon: Icons.info_rounded,
                  settingKey: 'alert_budget_90',
                ),
                _buildSwitchTile(
                  title: 'Alerta em 70% do Orçamento',
                  subtitle: 'Notificação quando você gasta 70% do orçamento',
                  icon: Icons.info_outline,
                  settingKey: 'alert_budget_70',
                ),
              ],
            ),

            // Lembretes
            _buildNotificationSection(
              title: '⏰ Lembretes',
              items: [
                _buildSwitchTile(
                  title: 'Lembrete de Registro',
                  subtitle: 'Lembrete diário para registrar despesas',
                  icon: Icons.schedule,
                  settingKey: 'reminder_transactions',
                ),
                _buildSwitchTile(
                  title: 'Lembrete de Resumo Semanal',
                  subtitle: 'Resumo das suas finanças toda semana',
                  icon: Icons.calendar_today,
                  settingKey: 'reminder_weekly_summary',
                ),
              ],
            ),

            // Recomendações
            _buildNotificationSection(
              title: '💡 Recomendações',
              items: [
                _buildSwitchTile(
                  title: 'Dicas de Economia',
                  subtitle: 'Receba dicas personalizadas para economizar',
                  icon: Icons.lightbulb,
                  settingKey: 'tips_economy',
                ),
                _buildSwitchTile(
                  title: 'Padrões de Gastos',
                  subtitle: 'Notificação de padrões incomuns de gastos',
                  icon: Icons.trending_up,
                  settingKey: 'spending_patterns',
                ),
              ],
            ),

            // Promoções
            _buildNotificationSection(
              title: '🎁 Promoções',
              items: [
                _buildSwitchTile(
                  title: 'Promoções e Ofertas',
                  subtitle: 'Receba ofertas especiais e novidades',
                  icon: Icons.local_offer,
                  settingKey: 'promotional_offers',
                ),
                _buildSwitchTile(
                  title: 'Novos Badges',
                  subtitle: 'Notificação ao desbloquear novos badges',
                  icon: Icons.card_giftcard,
                  settingKey: 'new_badges',
                ),
              ],
            ),

            // Botões de Ação
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await _firebaseMessagingService.testarNotificacaoFCM(
                          titulo: '🧪 Notificação de Teste',
                          corpo: 'Esta é uma notificação de teste do FinWise',
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('✅ Notificação de teste enviada'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.send),
                      label: const Text('Enviar Notificação de Teste'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Token FCM'),
                            content: SingleChildScrollView(
                              child: SelectableText(
                                _firebaseMessagingService.deviceToken ??
                                    'Não disponível',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Fechar'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.vpn_key),
                      label: const Text('Ver Token FCM'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSection({
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        ...items,
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required String settingKey,
    Function(bool)? onChanged,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool value = true; // valor padrão

        return ListTile(
          leading: Icon(icon, color: Theme.of(context).primaryColor),
          title: Text(title),
          subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600])),
          trailing: Switch(
            value: value,
            onChanged: (newValue) {
              setState(() {
                value = newValue;
              });
              onChanged?.call(newValue);
            },
          ),
        );
      },
    );
  }
}
