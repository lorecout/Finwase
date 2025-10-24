import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/app_state.dart';
import '../services/firebase_service.dart';
import '../utils/design_system.dart';
import '../services/theme_service.dart';
import '../services/premium_service.dart';

/// Página de autenticação simplificada e robusta
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLoading = false;
  String? _errorMessage;
  late FirebaseService _firebaseService;

  @override
  void initState() {
    super.initState();
    _firebaseService = FirebaseService();
  }

  Future<void> _continueAsGuest() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // IMPORTANTE: Fazer logout primeiro para garantir modo visitante real
      await FirebaseAuth.instance.signOut();

      // Limpar cache do Google Sign-In também
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();

      final appState = Provider.of<AppState>(context, listen: false);
      appState.setGuestMode(true);

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/main');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Modo visitante ativado - Dados não serão salvos'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao entrar como visitante: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Criar instância do Google Sign-In
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Garanti que o seletor de contas apareça sempre em novo teste.
      // Em alguns casos o GoogleSignIn reutiliza a sessão anterior e não exibe a UI.
      // O signOut aqui força a escolha de conta e evita estados inconsistentes no emulador.
      try {
        await googleSignIn.signOut();
      } catch (_) {
        // Ignorar erros de signOut para não impactar o fluxo de login
      }

      // Fazer login com Google
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // Usuário cancelou o login
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Obter credenciais de autenticação
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Criar credencial do Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Fazer login no Firebase
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      debugPrint(
        '🔐 AUTH: Login realizado com sucesso para: ${userCredential.user!.email}',
      );
      debugPrint('🔐 AUTH: UID do usuário: ${userCredential.user!.uid}');

      // Criar perfil do usuário no Firestore
      debugPrint('👤 AUTH: Criando perfil no Firestore...');
      await _firebaseService.createUserProfile(userCredential.user!);

      // Atualizar displayName se necessário
      debugPrint('📝 AUTH: Atualizando displayName se necessário...');
      await _firebaseService.updateDisplayNameIfNeeded();

      // Carregar dados do usuário no PremiumService
      final premiumService = Provider.of<PremiumService>(
        context,
        listen: false,
      );
      await premiumService.loadUserData();

      // Atualizar último login
      debugPrint('🔄 AUTH: Atualizando último login...');
      await _firebaseService.updateLastLogin();

      if (mounted) {
        // Navegar primeiro
        Navigator.pushReplacementNamed(context, '/main');

        // Mostrar SnackBar em um callback separado para evitar conflito
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Bem-vindo, ${userCredential.user!.displayName ?? 'Usuário'}!',
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao fazer login com Google: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return DesignSystem.buildAnimatedBackground(
            baseColor: themeService.accentColor,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Título com efeito de digitação
                    Center(
                      child: DesignSystem.buildTypingText(
                        text: 'FinWise',
                        style: DesignSystem.subtitleStyle,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Controle suas finanças pessoais',
                      style: DesignSystem.bodyStyle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),

                    // Mensagem de erro
                    if (_errorMessage != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    if (_errorMessage != null) const SizedBox(height: 16),

                    // Botão Visitante
                    DesignSystem.buildStyledButton(
                      text: 'Continuar como Visitante',
                      onPressed: _continueAsGuest,
                      isLoading: _isLoading,
                    ),

                    const SizedBox(height: 16),

                    // Divisor
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OU',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Botão Login com Google
                    DesignSystem.buildStyledOutlineButton(
                      text: 'Continuar com Google',
                      onPressed: _signInWithGoogle,
                      isLoading: _isLoading,
                    ),

                    const SizedBox(height: 24),

                    // Versão
                    Text(
                      'Versão 1.0.0',
                      style: DesignSystem.captionStyle.copyWith(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
