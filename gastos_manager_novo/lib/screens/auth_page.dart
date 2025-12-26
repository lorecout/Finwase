import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../services/app_state.dart';
import '../services/firebase_service.dart';
import '../utils/design_system.dart';
import '../widgets/safe_asset_image.dart';
import '../main.dart'; // importar appNavigatorKey

/// Página de autenticação simplificada e robusta
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  Future<void> _registerWithEmail() async {
    String email = '';
    String password = '';
    String? errorMessage;
    bool isLoading = false;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Criar conta'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    onChanged: (value) => email = value,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Senha'),
                    obscureText: true,
                    autofillHints: const [AutofillHints.password],
                    onChanged: (value) => password = value,
                  ),
                  if (errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(errorMessage!,
                        style: const TextStyle(color: Colors.red)),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed:
                      isLoading ? null : () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          setStateDialog(() {
                            isLoading = true;
                            errorMessage = null;
                          });
                          try {
                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: email.trim(),
                              password: password,
                            );
                            if (mounted) Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Conta criada com sucesso!')),
                            );
                          } on FirebaseAuthException catch (e) {
                            String msg = 'Erro ao criar conta';
                            if (e.code == 'email-already-in-use') {
                              msg = 'Este email já está em uso.';
                            } else if (e.code == 'invalid-email') {
                              msg = 'Email inválido.';
                            } else if (e.code == 'weak-password') {
                              msg = 'Senha muito fraca (mínimo 6 caracteres).';
                            }
                            setStateDialog(() {
                              errorMessage = msg;
                              isLoading = false;
                            });
                          } catch (e) {
                            setStateDialog(() {
                              errorMessage = 'Erro inesperado.';
                              isLoading = false;
                            });
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Criar conta'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  bool _isLoading = false;
  String? _errorMessage;
  late FirebaseService _firebaseService;
  String _email = '';
  String _password = '';

  Future<void> _signInWithEmail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.trim(),
        password: _password,
      );
      if (!mounted) return;
      final appState = Provider.of<AppState>(context, listen: false);
      appState.setGuestMode(false);
      appNavigatorKey.currentState?.pushReplacementNamed('/main');
    } on FirebaseAuthException catch (e) {
      String errorMsg = 'Erro ao fazer login';
      if (e.code == 'user-not-found') {
        errorMsg = 'Usuário não encontrado';
      } else if (e.code == 'wrong-password') {
        errorMsg = 'Senha incorreta';
      } else if (e.code == 'invalid-email') {
        errorMsg = 'Email inválido';
      } else if (e.code == 'user-disabled') {
        errorMsg = 'Conta desabilitada';
      } else if (e.code == 'too-many-requests') {
        errorMsg = 'Muitas tentativas. Tente novamente mais tarde';
      }
      setState(() {
        _errorMessage = errorMsg;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro inesperado ao fazer login.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    try {
      debugPrint('AuthPage: initState start');
      _firebaseService = FirebaseService();
      debugPrint('AuthPage: initState completed');
    } catch (e, st) {
      debugPrint('AuthPage: initState error: $e');
      debugPrint(st.toString());
    }
  }

  Future<void> _continueAsGuest() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // IMPORTANTE: Fazer logout primeiro para garantir modo visitante real
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      final appState = Provider.of<AppState>(context, listen: false);
      appState.setGuestMode(true);

      if (mounted) {
        // Navegar usando a chave global para evitar erros de rota
        appNavigatorKey.currentState?.pushReplacementNamed('/main');
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

  /// Login com Google
  ///
  /// Processa:
  /// 1. Inicia sign-in com Google
  /// 2. Cria/atualiza perfil do usuário
  /// 3. Navega para home
  ///
  /// Tratamento de erros:
  /// - CANCELLED: Usuário fechou o dialog
  /// - Network: Sem conexão
  /// - Outros: Exibe mensagem de erro
  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      debugPrint('🔐 AUTH PAGE: Iniciando Google Sign-In...');
      final firebaseService = FirebaseService();
      final userCredential = await firebaseService.signInWithGoogle();

      if (userCredential == null) {
        // Usuário cancelou o login
        debugPrint('⚠️ AUTH PAGE: Google Sign-In cancelado pelo usuário');
        setState(() {
          _errorMessage =
              'Login cancelado. Tente novamente ou entre como visitante.';
        });
        return;
      }

      if (!mounted) return;

      debugPrint(
          '✅ AUTH PAGE: Login sucesso - UID: ${userCredential.user?.uid}');
      final appState = Provider.of<AppState>(context, listen: false);
      appState.setGuestMode(false);

      // Navegar com a chave global
      appNavigatorKey.currentState?.pushReplacementNamed('/main');
    } on FirebaseException catch (e) {
      debugPrint('❌ AUTH PAGE: Erro Firebase - ${e.code}: ${e.message}');
      String errorMsg = 'Erro ao fazer login com Google';

      if (e.code == 'network-request-failed') {
        errorMsg = 'Sem conexão com internet. Verifique sua conexão.';
      } else if (e.code == 'sign_in_failed') {
        errorMsg = 'Falha no login. Tente novamente.';
      } else if (e.code == 'account-exists-with-different-credential') {
        errorMsg = 'Uma conta com este email já existe.';
      }

      setState(() {
        _errorMessage = errorMsg;
      });
    } catch (e) {
      debugPrint('❌ AUTH PAGE: Erro inesperado - ${e.toString()}');
      setState(() {
        _errorMessage =
            'Erro inesperado ao fazer login com Google. Tente novamente.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('AuthPage: build start');
    try {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4F8CFF), Color(0xFFB6E0FE)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Ícone do app
                        // Fallback seguro para asset do ícone do app
                        Builder(
                          builder: (context) {
                            try {
                              return SafeAssetImage(
                                'assets/icon/app_icon.png',
                                height: 64,
                                fallbackAsset: null,
                              );
                            } catch (e) {
                              debugPrint('Erro ao carregar app_icon.png: $e');
                              return const Icon(
                                Icons.account_circle,
                                size: 64,
                                color: Colors.grey,
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        // Título estilizado
                        Center(
                          child: Text(
                            'FinWise',
                            style: DesignSystem.titleStyle.copyWith(
                              color: const Color(0xFF1A237E),
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Controle suas finanças pessoais',
                          style: TextStyle(
                            color: Color(0xFF374151),
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // Mensagem de erro
                        if (_errorMessage != null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: const TextStyle(color: Colors.red),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _errorMessage = null;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        if (_errorMessage != null) const SizedBox(height: 16),

                        // Campos de login com email e senha
                        TextField(
                          enabled: !_isLoading,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          onChanged: (value) {
                            setState(() {
                              _email = value;
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          enabled: !_isLoading,
                          decoration: const InputDecoration(
                            labelText: 'Senha',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          autofillHints: const [AutofillHints.password],
                          onChanged: (value) {
                            setState(() {
                              _password = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _signInWithEmail,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            backgroundColor: const Color(0xFF1A237E),
                            foregroundColor: Colors.white,
                            elevation: 4,
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text('Entrar'),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton(
                          onPressed: _isLoading ? null : _registerWithEmail,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: Color(0xFF1A237E)),
                            foregroundColor: Color(0xFF1A237E),
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text('Criar conta'),
                        ),

                        // Botão Google
                        ElevatedButton.icon(
                          onPressed: _isLoading ? null : _signInWithGoogle,
                          icon:
                              const Icon(Icons.login, color: Color(0xFF1A237E)),
                          label: const Text('Entrar com Google'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Color(0xFF1A237E),
                            elevation: 2,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Botão de modo visitante
                        OutlinedButton.icon(
                          onPressed: _isLoading ? null : _continueAsGuest,
                          icon: const Icon(
                            Icons.person_outline,
                            color: Color(0xFF1A237E),
                          ),
                          label: const Text('Continuar como Visitante'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            side: const BorderSide(
                              color: Color(0xFF1A237E),
                              width: 2,
                            ),
                            foregroundColor: const Color(0xFF1A237E),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Indicador de carregamento
                        if (_isLoading)
                          const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF1A237E),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } catch (e, st) {
      debugPrint('AuthPage: build error: $e');
      debugPrint(st.toString());
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 12),
                const Text(
                  'Erro ao renderizar tela de login',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(e.toString(), textAlign: TextAlign.center),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    if (mounted) setState(() {});
                  },
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
