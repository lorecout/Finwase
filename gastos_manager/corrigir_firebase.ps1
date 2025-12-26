#!/usr/bin/env pwsh
# Script para corrigir erros do Firebase no FinWase
# Permite execução offline e resolve problemas de configuração

Write-Host "🔥 CORRIGINDO FIREBASE - FINWASE" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Green

# 1. Backup do main.dart atual
Write-Host "📋 Fazendo backup do main.dart..." -ForegroundColor Yellow
Copy-Item "lib\main.dart" "lib\main_backup_$(Get-Date -Format 'yyyyMMdd_HHmmss').dart"

# 2. Criar versão offline-friendly do main.dart
Write-Host "🔧 Criando versão offline-friendly..." -ForegroundColor Cyan

$mainContent = @'
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

    // Inicializar Firebase com fallback robusto
    bool isFirebaseAvailable = false;
    try {
      // Timeout mais curto para emulador
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ).timeout(const Duration(seconds: 3));
      
      // Testar conectividade básica
      await FirebaseAuth.instance.authStateChanges().first.timeout(
        const Duration(seconds: 2),
        onTimeout: () => null,
      );
      
      isFirebaseAvailable = true;
      debugPrint('✅ FIREBASE: Conectado e funcionando');
    } catch (e) {
      debugPrint('⚠️ FIREBASE: Modo offline ativado - $e');
      isFirebaseAvailable = false;
    }

    // Inicializar Firebase Messaging apenas se Firebase disponível
    if (isFirebaseAvailable && !Platform.isWindows) {
      try {
        await FirebaseService().initializeMessaging();
        debugPrint('✅ FIREBASE: Messaging inicializado');
      } catch (e) {
        debugPrint('⚠️ FIREBASE: Messaging falhou - $e');
      }
    }

    // Inicializar AdMob sempre (funciona offline)
    try {
      await AdService.initialize();
      await AdIntegrationService().initialize();
      debugPrint('✅ ADS: Inicializados com sucesso');
    } catch (e) {
      debugPrint('⚠️ ADS: Falha na inicialização - $e');
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
        child: MyApp(firebaseAvailable: isFirebaseAvailable),
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
    await Future.delayed(const Duration(milliseconds: 800));
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
        debugPrint('🔥 CONFIG: FORCE_PREMIUM ativo - modo premium habilitado');
      } catch (e) {
        debugPrint('🔥 CONFIG: FORCE_PREMIUM - erro ao definir premium: $e');
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
                    _showTrialPremium = !SKIP_TRIAL_PAGE;
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
    // Timeout mais rápido para emulador
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && !_hasTimedOut) {
        setState(() => _hasTimedOut = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Se Firebase não disponível, ir direto para modo visitante
    if (!widget.firebaseAvailable) {
      debugPrint('🔥 AUTH: Firebase offline - ativando modo visitante');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final appState = Provider.of<AppState>(context, listen: false);
        appState.setGuestMode(true);
      });
      return const MainNavigationPage();
    }

    // Se timeout, ir para tela de auth
    if (_hasTimedOut) {
      return const AuthPage();
    }

    // Tentar verificar auth do Firebase
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
'@

Set-Content -Path "lib\main.dart" -Value $mainContent -Encoding UTF8

Write-Host "✅ main.dart atualizado para modo offline-friendly" -ForegroundColor Green

# 3. Limpar cache e dependências
Write-Host "🧹 Limpando cache..." -ForegroundColor Yellow
flutter clean
flutter pub get

Write-Host "🚀 FIREBASE CORRIGIDO!" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Green
Write-Host "✅ App agora funciona offline" -ForegroundColor White
Write-Host "✅ Firebase com fallback robusto" -ForegroundColor White
Write-Host "✅ Timeout reduzido para emulador" -ForegroundColor White
Write-Host "✅ Modo visitante automático" -ForegroundColor White
Write-Host "" -ForegroundColor White
Write-Host "💡 Execute agora: flutter run" -ForegroundColor Cyan