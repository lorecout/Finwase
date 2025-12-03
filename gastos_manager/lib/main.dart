import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
import 'firebase_options.dart';
import 'services/app_state.dart';
import 'services/theme_service.dart';
import 'services/premium_service.dart';
import 'services/backup_service.dart';
import 'services/payment_service.dart';
import 'services/firebase_service.dart';
import 'services/ad_service.dart';
import 'services/ad_integration_service.dart';
import 'services/settings_service.dart';
import 'services/referral_service.dart';
import 'services/streak_service.dart';
import 'services/budget_service.dart';
import 'services/firebase_messaging_service.dart';
import 'services/play_integrity_service.dart';
import 'screens/auth_page.dart';
import 'screens/loading_screen.dart';
import 'screens/main_navigation_page.dart';
import 'screens/add_transaction_page.dart';
import 'screens/bulk_text_input_page.dart';
import 'screens/bulk_transactions_page.dart';
import 'screens/theme_settings_page.dart';
import 'screens/debug_page.dart';
import 'screens/data_debug_page.dart';
import 'screens/profile_page.dart';
import 'screens/premium_upgrade_page.dart';
import 'screens/referral_page.dart';
import 'screens/budget_page.dart';
import 'screens/notifications_settings_page.dart';
import 'widgets/premium_feature_access_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Toggle to enable App Check in debug (can be overridden with --dart-define=APP_CHECK_DEBUG=true)
  const bool kEnableAppCheckInDebug = bool.fromEnvironment(
    'APP_CHECK_DEBUG',
    defaultValue: false,
  );

  // Verificar se estamos em um ambiente de desenvolvimento/emulador
  // onde o Firebase pode não estar disponível
  bool isEmulatorEnvironment = false;
  try {
    // Inicializar Firebase com um timeout mais generoso para evitar falsos positivos
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).timeout(const Duration(seconds: 8));
    debugPrint('✅ FIREBASE: Inicializado com sucesso');
    isEmulatorEnvironment = false;
  } catch (e) {
    debugPrint(
      '⚠️ FIREBASE: Ambiente offline detectado - ativando modo visitante: $e',
    );
    isEmulatorEnvironment = true;
  }

  // Inicializar Firebase App Check apenas se Firebase estiver disponível.
  // Em debug, por padrão não ativamos para evitar erros 403 quando a API
  // firebaseappcheck.googleapis.com ainda não está habilitada no projeto.
  // Para testar App Check em debug, rode com: --dart-define=APP_CHECK_DEBUG=true
  if (!isEmulatorEnvironment &&
      !Platform.isWindows &&
      (!kDebugMode || kEnableAppCheckInDebug)) {
    try {
      await FirebaseAppCheck.instance.activate(
        androidProvider: kDebugMode
            ? AndroidProvider.debug
            : AndroidProvider.playIntegrity,
        appleProvider: kDebugMode
            ? AppleProvider.debug
            : AppleProvider.deviceCheck,
      );
      // Habilitar auto-refresh do token e forçar geração imediata
      await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);
      try {
        final token = await FirebaseAppCheck.instance.getToken(true);
        if (token != null && token.isNotEmpty) {
          if (kDebugMode) {
            debugPrint('✅ FIREBASE: App Check token DEBUG = $token');
          } else {
            debugPrint('✅ FIREBASE: App Check token obtido');
          }
        } else {
          debugPrint('⚠️ FIREBASE: App Check retornou token vazio');
        }
      } catch (e) {
        debugPrint('⚠️ FIREBASE: Falha ao obter token do App Check: $e');
      }
      debugPrint('✅ FIREBASE: App Check ativado');
    } catch (e) {
      debugPrint('⚠️ FIREBASE: App Check falhou: $e');
    }
  }

  // Inicializar Play Integrity Service para verificação adicional de integridade
  if (!isEmulatorEnvironment && !Platform.isWindows) {
    try {
      await PlayIntegrityService.initialize();
      await PlayIntegrityService.enableTokenAutoRefresh();
      debugPrint('✅ SECURITY: Play Integrity API ativada');
    } catch (e) {
      debugPrint('⚠️ SECURITY: Play Integrity API falhou: $e');
    }
  }

  // Inicializar Firebase Messaging apenas se Firebase estiver disponível
  if (!isEmulatorEnvironment && !Platform.isWindows) {
    try {
      await FirebaseService().initializeMessaging();
      debugPrint('✅ FIREBASE: Messaging inicializado');
    } catch (e) {
      debugPrint('⚠️ FIREBASE: Messaging falhou: $e');
    }
  }

  // Inicializar Google Mobile Ads (AdMob) e sistema de otimização
  try {
    await AdService.initialize();
    // Inicializar sistema de otimização de anúncios
    await AdIntegrationService().initialize();
    debugPrint('✅ ADS: Inicializados com sucesso');
  } catch (e) {
    debugPrint('⚠️ ADS: Falha na inicialização: $e');
  }

  runApp(MyApp(firebaseAvailable: !isEmulatorEnvironment));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.firebaseAvailable});

  final bool firebaseAvailable;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isInitialized = false;
  final String _loadingMessage = 'Inicializando...';
  final double _loadingProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Pequeno delay mínimo para garantir que todos os serviços estejam prontos
    await Future.delayed(const Duration(milliseconds: 100));

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  Widget _buildBulkTransactionsRoute(BuildContext context) {
    final premiumService = Provider.of<PremiumService>(context, listen: false);

    if (premiumService.isPremium) {
      return const BulkTransactionsPage();
    } else {
      return PremiumFeatureAccessPage(
        featureName: 'Inserção em Massa de Transações',
        featureDescription:
            'Adicione múltiplas transações de uma vez com este recurso premium.',
        featureIcon: Icons.playlist_add,
        onAccessGranted: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const BulkTransactionsPage()),
          );
        },
      );
    }
  }

  Widget _buildBulkTextInputRoute(BuildContext context) {
    final premiumService = Provider.of<PremiumService>(context, listen: false);

    if (premiumService.isPremium) {
      return const BulkTextInputPage();
    } else {
      return PremiumFeatureAccessPage(
        featureName: 'Inserção por Texto',
        featureDescription:
            'Importe transações colando texto ou CSV com este recurso premium.',
        featureIcon: Icons.text_fields,
        onAccessGranted: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const BulkTextInputPage()),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoadingScreen(
          loadingMessage: _loadingMessage,
          progress: _loadingProgress,
        ),
      );
    }

    return MultiProvider(
      providers: [
        Provider(create: (_) => FirebaseService()),
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => ThemeService()..initTheme()),
        ChangeNotifierProvider(create: (_) => PremiumService()),
        ChangeNotifierProvider(create: (_) => BackupService()..loadSettings()),
        ChangeNotifierProvider(
          create: (_) => SettingsService()..loadSettings(),
        ),
        ChangeNotifierProvider(create: (_) => ReferralService()..initialize()),
        ChangeNotifierProvider(create: (_) => StreakService()..initialize()),
        ChangeNotifierProxyProvider<AppState, BudgetService>(
          create: (context) {
            final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
            return BudgetService(userId: userId)..initialize();
          },
          update: (context, appState, previous) =>
              previous ??
              BudgetService(
                userId: FirebaseAuth.instance.currentUser?.uid ?? 'guest',
              ),
        ),
        ChangeNotifierProvider(
          create: (context) => FirebaseMessagingService(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<PremiumService, PaymentService>(
          create: (context) => PaymentService(context.read<PremiumService>()),
          update: (context, premiumService, previous) =>
              previous ?? PaymentService(premiumService),
        ),
      ],
      child: Consumer2<ThemeService, PremiumService>(
        builder: (context, themeService, premiumService, child) {
          // Debug removido para melhorar performance

          // Inicializar anúncios e otimização apenas para usuários não premium
          if (!premiumService.isPremium && !AdService.isInitialized) {
            AdService.initialize().then((_) {
              AdIntegrationService().initialize();
            });
          }

          return MaterialApp(
            title: 'FinWise',
            debugShowCheckedModeBanner: false,
            locale: const Locale('pt', 'BR'),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('pt', 'BR')],
            theme: themeService.lightTheme,
            darkTheme: themeService.darkTheme,
            themeMode: themeService.themeMode,
            home: AuthWrapper(firebaseAvailable: widget.firebaseAvailable),
            routes: {
              '/auth': (context) => const AuthPage(),
              '/main': (context) {
                final args = ModalRoute.of(context)?.settings.arguments as int?;
                return MainNavigationPage(initialIndex: args);
              },
              '/add-transaction': (context) => const AddTransactionPage(),
              '/bulk-text-input': (context) =>
                  _buildBulkTextInputRoute(context),
              '/bulk-transactions': (context) =>
                  _buildBulkTransactionsRoute(context),
              '/theme-settings': (context) => const ThemeSettingsPage(),
              '/profile': (context) => const ProfilePage(),
              '/referral': (context) => const ReferralPage(),
              '/budget': (context) => const BudgetPage(),
              '/notifications-settings': (context) =>
                  const NotificationsSettingsPage(),
              '/premium': (context) => const PremiumUpgradePage(),
              '/premium-upgrade': (context) => const PremiumUpgradePage(),
              '/debug': (context) => const DebugPage(),
              '/data-debug': (context) => const DataDebugPage(),
            },
          );
        },
      ),
    );
  }
}

/// Widget que decide qual tela mostrar baseado no estado da autenticação
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
    // Timeout de 3 segundos para evitar travamento
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && !_hasTimedOut) {
        setState(() => _hasTimedOut = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Se Firebase não estiver disponível, forçar modo visitante
    if (!widget.firebaseAvailable) {
      debugPrint('🔥 AUTH: Firebase indisponível - forçando modo visitante');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final appState = Provider.of<AppState>(context, listen: false);
        appState.setGuestMode(true);
      });
      return const MainNavigationPage();
    }

    // Se já passou o timeout, ir direto para tela de login
    if (_hasTimedOut) {
      return const AuthPage();
    }

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Se está carregando e não passou o timeout
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen(
            loadingMessage: 'Verificando autenticação...',
            progress: 0.5,
          );
        }

        // Se tem usuário logado, ir direto para o app
        if (snapshot.hasData && snapshot.data != null) {
          _hasTimedOut = true; // Marcar como resolvido
          // Marcar que não está em modo visitante já que está logado
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final appState = Provider.of<AppState>(context, listen: false);
            appState.setGuestMode(false);
          });
          return const MainNavigationPage();
        }

        // Se não tem usuário ou erro, mostrar tela de login
        _hasTimedOut = true; // Marcar como resolvido
        return const AuthPage();
      },
    );
  }
}
