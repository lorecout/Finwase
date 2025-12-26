import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'config.dart';
import 'constants.dart';
import 'services/app_state.dart';
import 'services/settings_service.dart';
import 'services/theme_service.dart';
import 'services/notification_service.dart';
import 'services/firebase_messaging_service.dart';
import 'services/backup_service.dart';
import 'services/premium_service.dart';
import 'services/firebase_service.dart';
import 'services/ad_service.dart';
import 'services/ad_integration_service.dart';
import 'services/biometric_service.dart';
import 'screens/splash_screen.dart';
import 'screens/loading_screen.dart';
import 'screens/onboarding_page.dart';
import 'screens/trial_premium_page.dart';
import 'screens/auth_page.dart';
import 'screens/main_navigation_page.dart';
import 'route_generator.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Inicializar Firebase
    bool isEmulatorEnvironment = false;
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ).timeout(const Duration(seconds: 8));
      debugPrint('✅ FIREBASE: Inicializado com sucesso');
    } catch (e) {
      debugPrint('⚠️ FIREBASE: Ambiente offline detectado - ativando modo visitante: $e');
      isEmulatorEnvironment = true;
    }

    // Inicializar Firebase Messaging
    if (!isEmulatorEnvironment && !Platform.isWindows) {
      try {
        await FirebaseService().initializeMessaging();
        debugPrint('✅ FIREBASE: Messaging inicializado');
      } catch (e) {
        debugPrint('⚠️ FIREBASE: Messaging falhou: $e');
      }
    }

    // Inicializar AdMob
    try {
      await AdService.initialize();
      await AdIntegrationService().initialize();
      debugPrint('✅ ADS: Inicializados com sucesso');
    } catch (e) {
      debugPrint('⚠️ ADS: Falha na inicialização: $e');
    }

    // Inicializar tema
    final themeService = ThemeService();
    await themeService.initTheme();

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
        child: MyApp(firebaseAvailable: !isEmulatorEnvironment),
      ),
    );
  }, (error, stack) {
    debugPrint('Erro não capturado: $error');
    debugPrint(stack.toString());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.firebaseAvailable});

  final bool firebaseAvailable;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isInitialized = false;
  bool _showSplash = true;
  bool _showOnboarding = false;
  bool _showTrialPremium = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
    final hasSeenTrial = prefs.getBool('hasSeenTrialPremium') ?? false;

    final effectiveHasSeenTrial = SKIP_TRIAL_PAGE ? true : hasSeenTrial;

    if (mounted) {
      setState(() {
        _isInitialized = true;
        _showSplash = false;
        _showOnboarding = !hasSeenOnboarding;
        _showTrialPremium = !effectiveHasSeenTrial && hasSeenOnboarding;
      });
    }

    // Configurar premium se FORCE_PREMIUM estiver ativo
    if (FORCE_PREMIUM) {
      try {
        final premiumService = Provider.of<PremiumService>(context, listen: false);
        premiumService.upgradeToPremium('forced');
        debugPrint('🔥 CONFIG: FORCE_PREMIUM active - premium mode enabled');
      } catch (e) {
        debugPrint('🔥 CONFIG: FORCE_PREMIUM - could not set premium now: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: appNavigatorKey,
      onGenerateRoute: RouteGenerator.generateRoute,
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (_) => const AuthPage(),
        settings: settings,
      ),
      home: _showSplash
          ? const SplashScreen()
          : !_isInitialized
          ? const LoadingScreen(
              loadingMessage: 'Inicializando...',
              progress: 0.0,
            )
          : _showOnboarding
          ? OnboardingPageWrapper(
              onFinish: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('hasSeenOnboarding', true);
                if (mounted) {
                  setState(() {
                    _showOnboarding = false;
                    _showTrialPremium = true;
                  });
                }
              },
            )
          : _showTrialPremium
          ? TrialPremiumPage(
              onContinue: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('hasSeenTrialPremium', true);
                if (mounted) {
                  setState(() {
                    _showTrialPremium = false;
                  });
                }
              },
            )
          : AuthWrapper(firebaseAvailable: widget.firebaseAvailable),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key, required this.firebaseAvailable});

  final bool firebaseAvailable;

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _hasTimedOut = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && !_hasTimedOut) {
        setState(() => _hasTimedOut = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.firebaseAvailable) {
      debugPrint('🔥 AUTH: Firebase indisponível - forçando modo visitante');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final appState = Provider.of<AppState>(context, listen: false);
        appState.setGuestMode(true);
      });
      return const MainNavigationPage();
    }

    if (_hasTimedOut) {
      return const AuthPage();
    }

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen(
            loadingMessage: 'Verificando autenticação...',
            progress: 0.5,
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          _hasTimedOut = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final appState = Provider.of<AppState>(context, listen: false);
            appState.setGuestMode(false);
          });
          return const MainNavigationPage();
        }

        _hasTimedOut = true;
        return const AuthPage();
      },
    );
  }
}