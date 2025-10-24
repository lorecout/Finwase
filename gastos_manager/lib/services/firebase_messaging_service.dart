import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'notification_service.dart';

class FirebaseMessagingService extends ChangeNotifier {
  static final FirebaseMessagingService _instance =
      FirebaseMessagingService._internal();

  factory FirebaseMessagingService() {
    return _instance;
  }

  FirebaseMessagingService._internal();

  late final FirebaseMessaging _firebaseMessaging;
  bool _isInitialized = false;
  String? _deviceToken;

  bool get isInitialized => _isInitialized;
  String? get deviceToken => _deviceToken;

  /// Inicializar Firebase Messaging
  Future<void> initialize(NotificationService notificationService) async {
    if (_isInitialized) return;

    try {
      _firebaseMessaging = FirebaseMessaging.instance;

      // Solicitar permissão de notificação
      NotificationSettings settings = await _firebaseMessaging
          .requestPermission(
            alert: true,
            announcement: true,
            badge: true,
            criticalAlert: false,
            provisional: true,
            sound: true,
          );

      debugPrint(
        '✅ FCM: Permissão de notificação: ${settings.authorizationStatus}',
      );

      // Obter token do dispositivo
      _deviceToken = await _firebaseMessaging.getToken();
      debugPrint('✅ FCM: Token obtido: $_deviceToken');

      // Handler para mensagens em primeiro plano
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handler para mensagens quando app é aberto a partir de notificação
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

      // Listener para token refresh
      FirebaseMessaging.instance.onTokenRefresh.listen(_handleTokenRefresh);

      // Handler para mensagens em segundo plano (background)
      FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

      _isInitialized = true;
      debugPrint('✅ FCM: Inicializado com sucesso');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ FCM: Erro na inicialização: $e');
    }
  }

  /// Handler para mensagens recebidas em primeiro plano
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('📬 FCM: Mensagem em primeiro plano');
    debugPrint('Title: ${message.notification?.title}');
    debugPrint('Body: ${message.notification?.body}');
    debugPrint('Data: ${message.data}');

    // Mensagens em primeiro plano não mostram notificação por padrão
    // Processar dados da mensagem aqui se necessário
  }

  /// Handler para mensagens que abrem o app
  void _handleMessageOpenedApp(RemoteMessage message) {
    debugPrint('📬 FCM: App aberto a partir de notificação');
    debugPrint('Title: ${message.notification?.title}');
    debugPrint('Body: ${message.notification?.body}');
    debugPrint('Data: ${message.data}');

    // Navegar para tela apropriada baseado na data da mensagem
    _routeBasedOnMessage(message);
  }

  /// Handler para mensagens em segundo plano (executado em isolate separado)
  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    debugPrint('📬 FCM: Mensagem em segundo plano');
    debugPrint('Title: ${message.notification?.title}');
    debugPrint('Body: ${message.notification?.body}');
    debugPrint('Data: ${message.data}');

    // Processamento da mensagem em segundo plano (ex: salvar no banco)
  }

  /// Handler para refresh do token
  void _handleTokenRefresh(String token) {
    debugPrint('🔄 FCM: Token renovado: $token');
    _deviceToken = token;

    // TODO: Salvar novo token no Firestore para sincronização com servidor
    // await saveTokenToFirestore(token);
    notifyListeners();
  }

  /// Rotear para tela apropriada baseado na mensagem
  void _routeBasedOnMessage(RemoteMessage message) {
    final type = message.data['type'];

    switch (type) {
      case 'budget_alert':
        // Navegar para Budget Page
        debugPrint('📍 Rotear para: Budget');
        break;
      case 'badge_unlocked':
        // Navegar para Achievements
        debugPrint('📍 Rotear para: Achievements');
        break;
      case 'referral_invite':
        // Navegar para Referral
        debugPrint('📍 Rotear para: Referral');
        break;
      case 'promotional':
        // Navegar para Home
        debugPrint('📍 Rotear para: Home');
        break;
      default:
        debugPrint('📍 Tipo de mensagem desconhecido: $type');
    }
  }

  /// Testar notificação FCM local
  Future<void> testarNotificacaoFCM({
    String titulo = 'Teste FCM',
    String corpo = 'Esta é uma notificação de teste',
    Map<String, dynamic>? dados,
  }) async {
    try {
      debugPrint('🧪 Enviando notificação de teste...');
      // Simular uma mensagem FCM remota para teste
      final message = RemoteMessage(
        notification: RemoteNotification(title: titulo, body: corpo),
        data: dados ?? {},
      );
      _handleForegroundMessage(message);
      debugPrint('✅ Notificação de teste enviada');
    } catch (e) {
      debugPrint('❌ Erro ao enviar notificação de teste: $e');
    }
  }

  /// Desabilitar notificações
  Future<void> desabilitarNotificacoes() async {
    try {
      await _firebaseMessaging.deleteToken();
      debugPrint('✅ Notificações desabilitadas');
    } catch (e) {
      debugPrint('❌ Erro ao desabilitar notificações: $e');
    }
  }

  /// Reabilitar notificações
  Future<void> reabilitarNotificacoes() async {
    try {
      _deviceToken = await _firebaseMessaging.getToken();
      debugPrint('✅ Notificações reabilitadas: $_deviceToken');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Erro ao reabilitar notificações: $e');
    }
  }

  /// Subscrever a tópico FCM
  Future<void> inscreverTopicoFCM(String topico) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topico);
      debugPrint('✅ Inscrito ao tópico: $topico');
    } catch (e) {
      debugPrint('❌ Erro ao inscrever-se ao tópico: $e');
    }
  }

  /// Desinscrever de tópico FCM
  Future<void> desinscreverTopicoFCM(String topico) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topico);
      debugPrint('✅ Desinscrito do tópico: $topico');
    } catch (e) {
      debugPrint('❌ Erro ao desinscrever-se do tópico: $e');
    }
  }

  /// Inscrever em tópicos automáticos para o usuário
  Future<void> inscreverEmTopicosAuto() async {
    try {
      // Tópicos principais
      await inscreverTopicoFCM('all_users');
      await inscreverTopicoFCM('budget_alerts');
      await inscreverTopicoFCM('promotional');

      debugPrint('✅ Inscrito em tópicos automáticos');
    } catch (e) {
      debugPrint('❌ Erro ao inscrever em tópicos: $e');
    }
  }
}
