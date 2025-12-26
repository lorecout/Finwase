import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IA Local Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LocalIAExample(),
    );
  }
}

class LocalIAExample extends StatefulWidget {
  const LocalIAExample({super.key});

  @override
  State<LocalIAExample> createState() => _LocalIAExampleState();
}

class _LocalIAExampleState extends State<LocalIAExample> {
  String _result = 'Pressione para rodar inferência local';

  Future<void> _runModel() async {
    try {
      // Carrega um modelo tflite de exemplo (modelo de adição simples)
      final interpreter = await Interpreter.fromAsset('add.tflite');
      var input = [ [1.0, 2.0] ]; // Exemplo: soma 1 + 2
      var output = List.filled(1, 0.0).reshape([1, 1]);
      interpreter.run(input, output);
      setState(() {
        _result = 'Resultado da IA local: ${output[0][0]} (esperado: 3.0)';
      });
    } catch (e) {
      setState(() {
        _result = 'Erro ao rodar IA local: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IA Local (TensorFlow Lite)')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_result, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _runModel,
              child: const Text('Rodar Inferência Local'),
            ),
            const SizedBox(height: 12),
            const Text('Este exemplo usa um modelo tflite de soma (1+2=3).'),
          ],
        ),
      ),
    );
  }
}
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Ocorreu um erro ao renderizar a interface',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      details.exceptionAsString(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      };

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
        await AdService.initialize(); // Removido o parâmetro appId, pois não é aceito
        await AdIntegrationService().initialize();
        debugPrint('✅ ADS: Inicializados com sucesso');
        try {
          final status = AdService.getAdStatus();
          debugPrint('ADS STATUS: $status');
        } catch (e) {
          debugPrint('ADS STATUS: falha ao obter status: $e');
        }
      } catch (e) {
        debugPrint('⚠️ ADS: Falha na inicialização: $e');
      }

      // Wrap MyApp with the top-level providers so every widget pode acessar them.
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
          // Ensure ProviderInitializer is created with a BuildContext that is
          // below the MultiProvider so it can read providers safely.
          child: ProviderInitializer(
            child: MyApp(firebaseAvailable: !isEmulatorEnvironment),
          ),
        ),
      );
    },
    (error, stack) {
      // Zona guardada - trate erros assíncronos aqui
      debugPrint('Zona capturou erro não capturado: $error');
      debugPrint(stack.toString());
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.firebaseAvailable});

  final bool firebaseAvailable;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Moved provider-dependent initialization into ProviderInitializer
    // because providers are created above MyApp in main().
    // Leaving this method empty prevents reading providers before they're available.
  }

  bool _isInitialized = false;
  bool _showSplash = true;
  bool _showOnboarding = false;
  bool _showTrialPremium = false;
  final String _loadingMessage = 'Inicializando...';
  final double _loadingProgress = 0.0;

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

    // If SKIP_TRIAL_PAGE is enabled, treat as already seen
    final effectiveHasSeenTrial = SKIP_TRIAL_PAGE ? true : hasSeenTrial;

    if (mounted) {
      setState(() {
        _isInitialized = true;
        _showSplash = false;
        _showOnboarding = !hasSeenOnboarding;
        _showTrialPremium = !effectiveHasSeenTrial && hasSeenOnboarding;
      });
    }

    // If FORCE_PREMIUM is enabled, set PremiumService state when available
    if (FORCE_PREMIUM) {
      try {
        final premiumService = Provider.of<PremiumService>(
          appNavigatorKey.currentContext!,
          listen: false,
        );
        premiumService.upgradeToPremium('forced');
        debugPrint('🔥 CONFIG: FORCE_PREMIUM active - premium mode enabled');
      } catch (e) {
        debugPrint('🔥 CONFIG: FORCE_PREMIUM - could not set premium now: $e');
      }
    }

    // DEBUG: Auto-test Google Sign-In when running in debug on emulator/device
    if (kDebugMode) {
      debugPrint('🔎 DEBUG: Running auto Google Sign-In test');
      // Run asynchronously but don't block initialization
      Future(() async {
        try {
          final result = await FirebaseService().signInWithGoogle();
          if (result == null) {
            debugPrint('🔎 DEBUG: Google Sign-In was cancelled by the user.');
          } else {
            debugPrint('🔎 DEBUG: Google Sign-In succeeded: ${result.user?.uid}');
          }
        } catch (e, st) {
          debugPrint('🔎 DEBUG: Google Sign-In failed: $e');
          debugPrint(st.toString());
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Providers are created above MyApp (in main). MaterialApp is returned
    // directly here because ProviderInitializer is now applied at the top
    // level (in runApp), guaranteeing its context is below the providers.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: appNavigatorKey,
      // Use a centralized route generator so every navigation call can be resolved
      onGenerateRoute: RouteGenerator.generateRoute,
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (_) => const AuthPage(),
        settings: settings,
      ),
      home: _showSplash
          ? const SplashScreen()
          : !_isInitialized
          ? LoadingScreen(
              loadingMessage: _loadingMessage,
              progress: _loadingProgress,
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

/// Widget que decide qual tela mostrar baseado no estado da autenticação
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key, required this.firebaseAvailable});

  final bool firebaseAvailable;

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _hasTimedOut = false;
  bool _biometricChecked = false;
  bool _biometricPassed = false;

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

  Future<void> _checkBiometric() async {
    if (_biometricChecked) return;

    final shouldRequest = await BiometricService.shouldRequestBiometric();
    if (!shouldRequest) {
      setState(() {
        _biometricChecked = true;
        _biometricPassed = true;
      });
      return;
    }

    final authenticated = await BiometricService.authenticate(
      localizedReason: 'Use sua biometria para acessar o FinWise',
    );

    setState(() {
      _biometricChecked = true;
      _biometricPassed = authenticated;
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
      return Builder(builder: (context) => const AuthPage());
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

        // Se tem usuário logado, verificar biometria antes de liberar acesso
        if (snapshot.hasData && snapshot.data != null) {
          _hasTimedOut = true; // Marcar como resolvido

          // Se biometria ainda não foi verificada, verificar agora
          if (!_biometricChecked) {
            _checkBiometric();
            return const LoadingScreen(
              loadingMessage: 'Verificando biometria...',
              progress: 0.7,
            );
          }

          // Se biometria falhou, mostrar tela de bloqueio
          if (!_biometricPassed) {
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.fingerprint,
                        size: 80,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Autenticação necessária',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Use sua biometria para acessar o app',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _biometricChecked = false;
                          });
                        },
                        icon: const Icon(Icons.fingerprint),
                        label: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // Biometria passou, liberar acesso
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final appState = Provider.of<AppState>(context, listen: false);
            appState.setGuestMode(false);
          });
          return const MainNavigationPage();
        }

        // Se não tem usuário ou erro, mostrar tela de login
        _hasTimedOut = true; // Marcar como resolvido
        return Builder(builder: (context) => const AuthPage());
      },
    );
  }
}

// Widget que inicializa listeners que dependem de Providers criados no MultiProvider
class ProviderInitializer extends StatefulWidget {
  final Widget child;
  const ProviderInitializer({super.key, required this.child});

  @override
  State<ProviderInitializer> createState() => _ProviderInitializerState();
}

class _ProviderInitializerState extends State<ProviderInitializer> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    // Adiar a leitura dos providers até o próximo frame. Isso evita erros
    // do tipo "Could not find the correct Provider<...> above this MyApp Widget"
    // que ocorrem quando a leitura acontece muito cedo no ciclo de vida.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      try {
        final settings = Provider.of<SettingsService>(context, listen: false);
        final fcm = Provider.of<FirebaseMessagingService>(
          context,
          listen: false,
        );
        final notificationService = Provider.of<NotificationService>(
          context,
          listen: false,
        );

        debugPrint('ProviderInitializer: providers carregados com sucesso');

        settings.onPreferenceChanged = (topic, enabled) async {
          try {
            if (topic == 'budget_alerts' ||
                topic == 'promotional' ||
                topic == 'new_badges') {
              if (enabled) {
                await fcm.inscreverTopicoFCM(topic);
              } else {
                await fcm.desinscreverTopicoFCM(topic);
              }
            }
            if (topic == 'reminder_transactions') {
              if (enabled) {
                await notificationService.scheduleDailyTransactionReminder();
              } else {
                await notificationService.cancelNotification(3000);
              }
            }
            if (topic == 'reminder_weekly_summary' && !enabled) {
              await notificationService.cancelNotification(999);
            }
            if (topic == 'reminder_weekly_summary' && enabled) {
              await notificationService.scheduleWeeklySummary();
            }
          } catch (e) {
            debugPrint('Erro em settings.onPreferenceChanged: $e');
          }
        };
      } catch (e) {
        debugPrint(
          'ProviderInitializer: não foi possível acessar providers: $e',
        );
      }

      // Marcar inicializado depois de tentar configurar os listeners
      if (mounted) {
        setState(() {
          _initialized = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
