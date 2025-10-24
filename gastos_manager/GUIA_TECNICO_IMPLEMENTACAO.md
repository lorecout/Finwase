# 🔧 GUIA TÉCNICO DE IMPLEMENTAÇÃO - FinWise

## 1. QUICK WINS - Implementação Imediata

### 1.1 Referral Program
```dart
// lib/services/referral_service.dart

class ReferralService extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  
  String _referralCode = '';
  int _referralCount = 0;
  
  String get referralCode => _referralCode;
  int get referralCount => _referralCount;
  
  Future<void> generateReferralCode() async {
    final user = _auth.currentUser;
    if (user == null) return;
    
    // Gerar código único
    final code = user.uid.substring(0, 8).toUpperCase();
    _referralCode = code;
    
    await _firestore.collection('users').doc(user.uid).update({
      'referralCode': code,
      'createdAt': FieldValue.serverTimestamp(),
    });
    
    notifyListeners();
  }
  
  Future<bool> applyReferralCode(String code) async {
    final user = _auth.currentUser;
    if (user == null) return false;
    
    try {
      // Verificar se código existe
      final query = await _firestore
          .collection('users')
          .where('referralCode', isEqualTo: code)
          .get();
      
      if (query.docs.isEmpty) return false;
      
      final referrerUid = query.docs.first.id;
      
      // Salvar referência
      await _firestore.collection('users').doc(user.uid).update({
        'referredBy': referrerUid,
        'referralAppliedAt': FieldValue.serverTimestamp(),
      });
      
      // Contar referral para referrer
      await _firestore.collection('users').doc(referrerUid).update({
        'referralCount': FieldValue.increment(1),
      });
      
      // Ambos ganham 1 mês de premium
      final premiumService = PremiumService();
      await premiumService.grantTemporaryPremium(days: 30);
      
      return true;
    } catch (e) {
      print('Erro ao aplicar código referral: $e');
      return false;
    }
  }
}
```

### 1.2 Streak Counter
```dart
// lib/services/streak_service.dart

class StreakService extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _prefs = SharedPreferences.getInstance();
  
  int _currentStreak = 0;
  DateTime? _lastActivityDate;
  
  int get currentStreak => _currentStreak;
  
  Future<void> checkAndUpdateStreak() async {
    final prefs = await _prefs;
    final today = DateTime.now();
    
    final lastDate = prefs.getString('lastActivityDate');
    final lastDateTime = lastDate != null ? DateTime.parse(lastDate) : null;
    
    if (lastDateTime == null) {
      // Primeiro acesso
      _currentStreak = 1;
    } else if (_isSameDay(today, lastDateTime)) {
      // Mesmo dia, não incrementar
      _currentStreak = prefs.getInt('currentStreak') ?? 1;
    } else if (_isDayAfter(today, lastDateTime)) {
      // Dia seguinte, incrementar
      _currentStreak = (prefs.getInt('currentStreak') ?? 0) + 1;
    } else {
      // Dias pulados, resetar
      _currentStreak = 1;
    }
    
    // Salvar localmente
    await prefs.setString('lastActivityDate', today.toIso8601String());
    await prefs.setInt('currentStreak', _currentStreak);
    
    // Sincronizar com Firebase
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'currentStreak': _currentStreak,
        'lastActivityDate': today,
        'longestStreak': _getLongestStreak(),
      });
    }
    
    // Unlock badges
    _checkBadges();
    notifyListeners();
  }
  
  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }
  
  bool _isDayAfter(DateTime d1, DateTime d2) {
    return d1.difference(d2).inDays == 1;
  }
  
  void _checkBadges() {
    // Badge: 7 dias
    if (_currentStreak == 7) {
      _unlockBadge('streak_7');
    }
    // Badge: 30 dias
    if (_currentStreak == 30) {
      _unlockBadge('streak_30');
    }
    // Badge: 365 dias
    if (_currentStreak == 365) {
      _unlockBadge('streak_365');
    }
  }
  
  Future<void> _unlockBadge(String badgeId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('badges')
          .doc(badgeId)
          .set({
        'unlockedAt': FieldValue.serverTimestamp(),
        'badgeId': badgeId,
      });
    }
  }
  
  int _getLongestStreak() {
    // Implementar lógica para pegar longest streak do Firestore
    return _currentStreak;
  }
}
```

### 1.3 Smart Budgets
```dart
// lib/services/smart_budget_service.dart

class SmartBudgetService extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _appState = AppState();
  
  Future<void> suggestBudgets() async {
    // Analisar últimos 3 meses de gastos
    final now = DateTime.now();
    final threeMonthsAgo = now.subtract(Duration(days: 90));
    
    final transactions = _appState.transacoes
        .where((t) => t.data.isAfter(threeMonthsAgo))
        .toList();
    
    // Agrupar por categoria
    final Map<String, List<Transacao>> byCategory = {};
    for (var t in transactions) {
      if (!byCategory.containsKey(t.categoriaId)) {
        byCategory[t.categoriaId] = [];
      }
      byCategory[t.categoriaId]!.add(t);
    }
    
    // Calcular média por categoria
    final suggestions = <String, double>{};
    byCategory.forEach((categoryId, trans) {
      final total = trans.fold(0.0, (sum, t) => sum + t.valor);
      final average = total / 3; // 3 meses
      suggestions[categoryId] = average * 1.1; // 10% de margem
    });
    
    // Salvar sugestões
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('budgets')
          .doc('suggested')
          .set({
        'suggestions': suggestions,
        'generatedAt': FieldValue.serverTimestamp(),
      });
    }
    
    notifyListeners();
  }
  
  Future<void> setAlert(String categoryId, double limit) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('budgetAlerts')
          .doc(categoryId)
          .set({
        'categoryId': categoryId,
        'limit': limit,
        'thresholds': {
          'warning': limit * 0.7,
          'critical': limit * 0.9,
        },
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }
}
```

---

## 2. INTEGRAÇÃO COM IA (Google Gemini)

### 2.1 Categorização Automática
```dart
// lib/services/ai_categorization_service.dart

class AICategorization extends ChangeNotifier {
  final _gemini = GoogleGenerativeAI(apiKey: 'YOUR_GEMINI_API_KEY');
  
  Future<String?> categorizeTransaction(
    String description,
    double amount,
    List<String> availableCategories,
  ) async {
    try {
      final prompt = '''
      Você é um assistente financeiro. Categorize esta transação:
      
      Descrição: $description
      Valor: R\$ $amount
      Categorias disponíveis: ${availableCategories.join(', ')}
      
      Retorne APENAS o nome da categoria mais apropriada.
      ''';
      
      final response = await _gemini.generateContent([
        Content(parts: [TextPart(prompt)])
      ]);
      
      final category = response.text?.trim();
      return availableCategories.contains(category) ? category : null;
    } catch (e) {
      print('Erro na categorização com IA: $e');
      return null;
    }
  }
  
  Future<String> getAIInsight(List<Transacao> recentTransactions) async {
    try {
      final summary = recentTransactions
          .fold('', (acc, t) => '$acc\n- ${t.descricao}: R\$ ${t.valor}');
      
      final prompt = '''
      Analisando esses gastos recentes:
      $summary
      
      Dê uma recomendação de economia personalizada e breve (máx 100 caracteres).
      ''';
      
      final response = await _gemini.generateContent([
        Content(parts: [TextPart(prompt)])
      ]);
      
      return response.text ?? '';
    } catch (e) {
      return 'Assista mais seus gastos!';
    }
  }
}
```

### 2.2 Voice Input
```dart
// lib/services/voice_input_service.dart

class VoiceInputService extends ChangeNotifier {
  final _speech = SpeechToText();
  final _gemini = GoogleGenerativeAI(apiKey: 'YOUR_GEMINI_API_KEY');
  
  String _voiceText = '';
  bool _isListening = false;
  
  String get voiceText => _voiceText;
  bool get isListening => _isListening;
  
  Future<void> startListening() async {
    if (!await _speech.initialize()) {
      print('Erro ao iniciar reconhecimento de voz');
      return;
    }
    
    _isListening = true;
    notifyListeners();
    
    _speech.listen(
      onResult: (result) {
        _voiceText = result.recognizedWords;
        notifyListeners();
      },
      localeId: 'pt_BR',
    );
  }
  
  Future<void> stopListening() async {
    await _speech.stop();
    _isListening = false;
    
    // Parse com IA
    final parsed = await _parseVoiceInput(_voiceText);
    // ... salvar transação
    
    notifyListeners();
  }
  
  Future<Map<String, dynamic>> _parseVoiceInput(String text) async {
    final prompt = '''
    Extraia os dados desta transação falada:
    "$text"
    
    Retorne em JSON:
    {
      "description": "descrição",
      "amount": número,
      "type": "receita" ou "despesa",
      "category": "categoria"
    }
    ''';
    
    final response = await _gemini.generateContent([
      Content(parts: [TextPart(prompt)])
    ]);
    
    // Parse JSON da resposta
    try {
      return jsonDecode(response.text ?? '{}');
    } catch (e) {
      return {};
    }
  }
}
```

---

## 3. OCR PARA RECIBOS

### 3.1 Receipt Scanner
```dart
// lib/services/receipt_scanner_service.dart

class ReceiptScannerService extends ChangeNotifier {
  final _vision = GoogleVision(apiKey: 'YOUR_VISION_API_KEY');
  final _gemini = GoogleGenerativeAI(apiKey: 'YOUR_GEMINI_API_KEY');
  
  Future<Map<String, dynamic>?> scanReceipt(File imageFile) async {
    try {
      // 1. Extrair texto com Google Vision
      final textResponse = await _vision.detectText(imageFile);
      final extractedText = textResponse.text;
      
      if (extractedText == null) return null;
      
      // 2. Processar com Gemini
      final prompt = '''
      Extraia dados fiscais deste recibo:
      
      Texto do recibo:
      $extractedText
      
      Retorne em JSON:
      {
        "store": "nome da loja",
        "amount": valor total,
        "date": "data (DD/MM/YYYY)",
        "items": ["item1", "item2"],
        "category": "categoria estimada"
      }
      ''';
      
      final response = await _gemini.generateContent([
        Content(parts: [TextPart(prompt)])
      ]);
      
      return jsonDecode(response.text ?? '{}');
    } catch (e) {
      print('Erro ao escanear recibo: $e');
      return null;
    }
  }
}
```

---

## 4. INTEGRAÇÃO COM OPEN BANKING

### 4.1 Setup Plaid (Recomendado)
```dart
// lib/services/open_banking_service.dart

class OpenBankingService extends ChangeNotifier {
  final String plaidClientId = 'YOUR_CLIENT_ID';
  final String plaidSecret = 'YOUR_SECRET';
  final String plaidEnv = 'production'; // ou 'sandbox'
  
  Future<bool> linkBankAccount() async {
    // 1. Criar token de link
    final linkToken = await _createLinkToken();
    
    // 2. Abrir fluxo Plaid no app
    final result = await PlaidLink.open(
      configuration: LinkTokenConfiguration(
        token: linkToken,
      ),
    );
    
    // 3. Salvar public token
    if (result.publicToken != null) {
      await _exchangePublicToken(result.publicToken!);
      return true;
    }
    
    return false;
  }
  
  Future<String> _createLinkToken() async {
    final response = await http.post(
      Uri.parse('https://sandbox.plaid.com/link/token/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'client_id': plaidClientId,
        'secret': plaidSecret,
        'client_name': 'FinWise',
        'user': {'client_user_id': 'user_id'},
        'client_ip': '0.0.0.0',
        'language': 'pt-BR',
        'country_codes': ['BR'],
        'products': ['auth', 'transactions'],
      }),
    );
    
    final data = jsonDecode(response.body);
    return data['link_token'];
  }
  
  Future<void> _exchangePublicToken(String publicToken) async {
    // Fazer isso no backend por segurança!
    final response = await http.post(
      Uri.parse('https://your-backend.com/api/plaid/exchange'),
      body: jsonEncode({
        'public_token': publicToken,
      }),
    );
    
    // Salvar access token retornado
  }
  
  Future<void> syncTransactions() async {
    // Chamar backend para sincronizar
    final response = await http.get(
      Uri.parse('https://your-backend.com/api/plaid/transactions'),
    );
    
    final transactions = jsonDecode(response.body)['transactions'];
    
    // Adicionar ao app
    for (var t in transactions) {
      // ... criar Transacao
    }
    
    notifyListeners();
  }
}
```

---

## 5. BADGES & GAMIFICATION

### 5.1 Sistema de Badges
```dart
// lib/models/badge.dart

enum BadgeType {
  // Economia
  economizer,
  superEconomizer,
  economyLegend,
  
  // Consistência
  weekStreak,
  monthStreak,
  yearStreak,
  
  // Metas
  zeroSpend,
  foodReduction,
  transportReduction,
  
  // Milestone
  firstTransaction,
  hundredTransactions,
  thousandTransactions,
}

class Badge {
  final BadgeType type;
  final String title;
  final String description;
  final IconData icon;
  final DateTime unlockedAt;
  final bool isSecret; // Badge surpresa
  
  Badge({
    required this.type,
    required this.title,
    required this.description,
    required this.icon,
    required this.unlockedAt,
    this.isSecret = false,
  });
}

// lib/services/badge_service.dart

class BadgeService extends ChangeNotifier {
  final List<Badge> _badges = [];
  
  List<Badge> get badges => _badges;
  
  Future<void> checkBadgeEligibility(
    int totalTransactions,
    int streakDays,
    double monthlyEconomy,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    
    // 1ª Transação
    if (totalTransactions == 1) {
      await _unlockBadge(
        BadgeType.firstTransaction,
        'Primeiro Passo',
        'Registrou sua primeira transação',
        Icons.emoji_events,
      );
    }
    
    // 100ª Transação
    if (totalTransactions == 100) {
      await _unlockBadge(
        BadgeType.hundredTransactions,
        'Centésimo',
        'Registrou 100 transações',
        Icons.celebration,
      );
    }
    
    // Economizer (10% economia em 1 mês)
    if (monthlyEconomy > 10) {
      await _unlockBadge(
        BadgeType.economizer,
        'Economizador',
        'Economizou 10% em um mês',
        Icons.trending_down,
      );
    }
    
    // Week Streak
    if (streakDays == 7) {
      await _unlockBadge(
        BadgeType.weekStreak,
        'Semana de Fogo',
        'Usou o app 7 dias seguidos',
        Icons.fire_hydrant,
      );
    }
    
    notifyListeners();
  }
  
  Future<void> _unlockBadge(
    BadgeType type,
    String title,
    String description,
    IconData icon,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    
    final badge = Badge(
      type: type,
      title: title,
      description: description,
      icon: icon,
      unlockedAt: DateTime.now(),
    );
    
    _badges.add(badge);
    
    // Salvar no Firebase
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('badges')
        .doc(type.toString())
        .set(badge.toJson());
    
    // Mostrar notificação
    await _showBadgeNotification(badge);
  }
  
  Future<void> _showBadgeNotification(Badge badge) async {
    final flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    
    await flutterLocalNotificationsPlugin.show(
      badge.type.hashCode,
      '🏆 ${badge.title}',
      badge.description,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'badges_channel',
          'Badges',
          channelDescription: 'Notificações de conquistas',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }
}
```

---

## 6. NOTIFICAÇÕES INTELIGENTES

### 6.1 Smart Notifications
```dart
// lib/services/smart_notification_service.dart

class SmartNotificationService {
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  
  Future<void> setupNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    
    const iosSettings = DarwinInitializationSettings();
    
    await _flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );
  }
  
  Future<void> scheduleReminders() async {
    // Lembrete diário às 20h
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      '💰 Não esqueça de registrar seus gastos',
      'Mantenha seu orçamento em dia',
      _nextInstance(20, 0),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_channel',
          'Lembretes Diários',
        ),
      ),
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
  
  Future<void> notifyBudgetAlert(
    String categoryName,
    double spent,
    double limit,
  ) async {
    final percentage = (spent / limit * 100).toStringAsFixed(0);
    
    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecond,
      '⚠️ Cuidado com $categoryName',
      'Você já gastou $percentage% do orçamento (R\$ $spent de R\$ $limit)',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'budget_alerts',
          'Alertas de Orçamento',
          importance: Importance.high,
          priority: Priority.high,
          color: Colors.red,
        ),
      ),
    );
  }
  
  tz.TZDateTime _nextInstance(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(Duration(days: 1));
    }
    
    return scheduledDate;
  }
}
```

---

## 7. WIDGET NA HOME SCREEN

### 7.1 App Widget (Android)
```xml
<!-- android/app/src/main/res/xml/home_widget_info.xml -->
<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:minWidth="110dp"
    android:minHeight="110dp"
    android:updatePeriodMillis="1800000"
    android:previewImage="@drawable/widget_preview"
    android:initialLayout="@layout/home_widget"
    android:resizeMode="horizontal|vertical"
    android:widgetCategory="home_screen" />
```

---

## 8. CHECKLIST DE IMPLEMENTAÇÃO

### Phase 1: QA & Stability (2 semanas)
- [ ] Corrigir bug de abertura
- [ ] Testes completos de fluxo
- [ ] Performance otimizada
- [ ] Build APK/IPA pronto

### Phase 2: Monetização Básica (3-4 semanas)
- [ ] Melhorar página premium ✓
- [ ] Anúncios otimizados
- [ ] Referral program
- [ ] Streak counter
- [ ] Push notifications

### Phase 3: IA & Features (4-6 semanas)
- [ ] Integração Gemini
- [ ] Auto-categorização
- [ ] Voice input
- [ ] Receipt OCR

### Phase 4: Integrações (6-8 semanas)
- [ ] Open Banking (Plaid)
- [ ] Badges system
- [ ] Leaderboards
- [ ] Dashboard compartilhado

---

**Tempo total estimado: 4-6 meses para MVP completo com todas as features.**
