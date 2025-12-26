import 'package:flutter/material.dart';
import '../widgets/safe_asset_image.dart';

import '../services/firebase_service.dart';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Escuta o estado de autenticação
    FirebaseService().authStateChanges.listen((user) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        if (user != null) {
          // Usuário logado
          appNavigatorKey.currentState?.pushReplacementNamed('/main');
        } else {
          // Usuário não logado
          appNavigatorKey.currentState?.pushReplacementNamed('/auth');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo animado ou estático
            const SafeAssetImage(
              'assets/onboarding/welcome.png',
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 32),
            // Nome do app com animação
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(seconds: 1),
              builder: (context, value, child) =>
                  Opacity(opacity: value, child: child),
              child: const Text(
                'FinWise',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Seu app de finanças pessoais',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
