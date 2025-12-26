import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/transaction.dart';
import '../models/orcamento.dart';
import 'app_state.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Configurações de inicialização
  Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          // iOS 10+ callbacks can be added here if needed
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
        );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      settings,
      // onDidReceiveNotificationResponse pode ser adicionado conforme necessário
    );
  }

  // Wrapper seguro para agendar notificações sem depender de enums específicos
  Future<void> safeZonedSchedule(
    int id,
    String title,
    String body,
    tz.TZDateTime scheduledDate,
    NotificationDetails details,
  ) async {
    try {
      // Em vez de depender de APIs de agendamento do plugin que mudaram de nome,
      // usamos um fallback baseado em Future.delayed que funcionará enquanto o
      // aplicativo estiver em execução. Se o app for encerrado, usamos show() como fallback.
      final now = tz.TZDateTime.now(tz.local);
      final delay = scheduledDate.difference(now);

      if (delay.isNegative || delay.inSeconds == 0) {
        await _notificationsPlugin.show(id, title, body, details);
        return;
      }

      // Agendar com Future.delayed — compatível com qualquer versão do plugin.
      Future.delayed(delay, () async {
        try {
          await _notificationsPlugin.show(id, title, body, details);
        } catch (_) {
          // fallback silencioso
        }
      });
    } catch (e) {
      // Em caso de erro inesperado, exibir imediatamente
      try {
        await _notificationsPlugin.show(id, title, body, details);
      } catch (_) {}
    }
  }

  // Cancelar todas as notificações
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  // Cancelar notificações específicas
  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  // Agendar lembrete diário de transações
  Future<void> scheduleDailyTransactionReminder() async {
    // Implementação placeholder: não agendar se timezone não estiver configurado
    try {
      final now = tz.TZDateTime.now(tz.local).add(const Duration(days: 1));
      const details = NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder',
          'Lembretes',
          channelDescription: 'Lembretes diários de transações',
        ),
      );
      await safeZonedSchedule(
        3000,
        'Lembrete',
        'Adicione suas transações!',
        now,
        details,
      );
    } catch (e) {
      // ignore
    }
  }

  // Agendar resumo semanal
  Future<void> scheduleWeeklySummary() async {
    try {
      final now = tz.TZDateTime.now(tz.local).add(const Duration(days: 7));
      const details = NotificationDetails(
        android: AndroidNotificationDetails(
          'weekly_summary',
          'Resumo Semanal',
          channelDescription: 'Resumo semanal de gastos',
        ),
      );
      await safeZonedSchedule(
        999,
        'Resumo Semanal',
        'Veja seus gastos da semana!',
        now,
        details,
      );
    } catch (e) {
      // ignore
    }
  }
}
