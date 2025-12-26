import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'services/app_state.dart';
import 'services/settings_service.dart';
import 'services/theme_service.dart';
import 'services/notification_service.dart';
import 'services/firebase_messaging_service.dart';
import 'services/backup_service.dart';
import 'services/premium_service.dart';
import 'services/firebase_service.dart';
import 'screens/auth_page.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Inicializar Firebase
    bool firebaseAvailable = true;
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      debugPrint('✅ FIREBASE: Inicializado com sucesso');
    } catch (e) {
      debugPrint('⚠️ FIREBASE: Falha na inicialização: $e');
      firebaseAvailable = false;
    }

    // Inicializar tema
    final themeService = ThemeService();
    await themeService.initTheme();
    debugPrint('✅ THEME: Inicializado com sucesso');

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppState()),
          ChangeNotifierProvider(create: (_) => SettingsService()),
          ChangeNotifierProvider(create: (_) => themeService),
          Provider<NotificationService>(create: (_) => NotificationService()),
          ChangeNotifierProvider<FirebaseMessagingService>(
            create: (_) => FirebaseMessagingService(),
          ),
          ChangeNotifierProvider(create: (_) => BackupService()),
          ChangeNotifierProvider(create: (_) => PremiumService()),
          Provider<FirebaseService>(create: (_) => FirebaseService()),
        ],
        child: MyApp(firebaseAvailable: firebaseAvailable),
      ),
    );
  }, (error, stack) {
    debugPrint('Erro não capturado: $error');
    debugPrint(stack.toString());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.firebaseAvailable});

  final bool firebaseAvailable;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: appNavigatorKey,
      title: 'FinWise',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const AuthPage(),
    );
  }
}