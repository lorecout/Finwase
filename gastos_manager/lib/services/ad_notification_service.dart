import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/ad_service.dart';
import '../services/premium_service.dart';

/// Serviço para gerenciar notificações sobre anúncios
class AdNotificationService extends ChangeNotifier {
  static final AdNotificationService _instance =
      AdNotificationService._internal();
  factory AdNotificationService() => _instance;
  AdNotificationService._internal();

  String? _currentMessage;
  Color? _messageColor;
  IconData? _messageIcon;
  DateTime? _lastNotification;

  String? get currentMessage => _currentMessage;
  Color? get messageColor => _messageColor;
  IconData? get messageIcon => _messageIcon;

  /// Verificar status dos anúncios e atualizar notificação
  void checkAdStatus() {
    final status = AdService.getAdStatus();
    final now = DateTime.now();

    // Evitar spam de notificações
    if (_lastNotification != null &&
        now.difference(_lastNotification!).inSeconds < 30) {
      return;
    }

    String? newMessage;
    Color? newColor;
    IconData? newIcon;

    if (!status['initialized']) {
      newMessage = 'AdMob não inicializado. Reinicie o app se necessário.';
      newColor = Colors.orange;
      newIcon = Icons.warning;
    } else if (status['blocked']) {
      newMessage =
          'Anúncios temporariamente bloqueados devido a muitas falhas. Aguarde alguns minutos.';
      newColor = Colors.red;
      newIcon = Icons.block;
    } else if (!status['canRequestAd']) {
      newMessage = 'Aguardando intervalo mínimo entre anúncios...';
      newColor = Colors.blue;
      newIcon = Icons.schedule;
    } else if (status['consecutiveFailures'] > 2) {
      newMessage = 'Múltiplas falhas detectadas. Sistema pode estar instável.';
      newColor = Colors.orange;
      newIcon = Icons.error_outline;
    }

    // Só atualizar se a mensagem mudou
    if (newMessage != _currentMessage) {
      _currentMessage = newMessage;
      _messageColor = newColor;
      _messageIcon = newIcon;
      _lastNotification = now;
      notifyListeners();

      // Auto-limpar mensagem após 30 segundos
      Future.delayed(const Duration(seconds: 30), () {
        if (_currentMessage == newMessage) {
          clearMessage();
        }
      });
    }
  }

  /// Limpar mensagem atual
  void clearMessage() {
    _currentMessage = null;
    _messageColor = null;
    _messageIcon = null;
    notifyListeners();
  }
}

/// Widget para mostrar notificações sobre anúncios
class AdNotificationWidget extends StatefulWidget {
  const AdNotificationWidget({super.key});

  @override
  State<AdNotificationWidget> createState() => _AdNotificationWidgetState();
}

class _AdNotificationWidgetState extends State<AdNotificationWidget> {
  late AdNotificationService _notificationService;

  @override
  void initState() {
    super.initState();
    _notificationService = AdNotificationService();

    // Verificar status periodicamente
    Future.doWhile(() async {
      if (mounted) {
        final premiumService = Provider.of<PremiumService>(
          context,
          listen: false,
        );
        // Só verificar para usuários free
        if (!premiumService.isPremium) {
          _notificationService.checkAdStatus();
        }
        await Future.delayed(const Duration(seconds: 15));
        return mounted;
      }
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final premiumService = Provider.of<PremiumService>(context);

    // Não mostrar para usuários premium
    if (premiumService.isPremium) {
      return const SizedBox.shrink();
    }

    return ChangeNotifierProvider.value(
      value: _notificationService,
      child: Consumer<AdNotificationService>(
        builder: (context, service, child) {
          if (service.currentMessage == null) {
            return const SizedBox.shrink();
          }

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: service.messageColor?.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color:
                    service.messageColor?.withValues(alpha: 0.3) ?? Colors.grey,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  service.messageIcon ?? Icons.info,
                  color: service.messageColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    service.currentMessage!,
                    style: TextStyle(
                      fontSize: 12,
                      color: service.messageColor?.withValues(alpha: 0.8),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: service.clearMessage,
                  icon: Icon(
                    Icons.close,
                    size: 16,
                    color: service.messageColor?.withValues(alpha: 0.6),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
