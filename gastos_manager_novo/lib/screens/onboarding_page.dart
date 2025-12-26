import 'package:flutter/material.dart';
import '../widgets/safe_asset_image.dart';

/// Wrapper para permitir callback ao finalizar onboarding
class OnboardingPageWrapper extends StatelessWidget {
  final Future<void> Function() onFinish;
  const OnboardingPageWrapper({super.key, required this.onFinish});

  @override
  Widget build(BuildContext context) {
    return OnboardingPage(
      onFinish: () async {
        await onFinish();
      },
    );
  }
}

class OnboardingPage extends StatefulWidget {
  final VoidCallback? onFinish;
  const OnboardingPage({super.key, this.onFinish});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardingStep> _steps = const [
    _OnboardingStep(
      title: 'Bem-vindo ao FinWise! 👋',
      description:
          'O app feito para quem quer dominar suas finanças sem complicação. Simples, seguro e inteligente para o seu dia a dia.',
      imageAsset: 'assets/onboarding/welcome.png',
    ),
    _OnboardingStep(
      title: 'Controle Total do Seu Dinheiro 💸',
      description:
          'Registre gastos e receitas em segundos, crie categorias personalizadas e visualize tudo em gráficos claros e bonitos.',
      imageAsset: 'assets/onboarding/welcome.png',
    ),
    _OnboardingStep(
      title: 'Acompanhe Seu Progresso 📈',
      description:
          'Receba dicas, alertas de orçamento e veja sua evolução mês a mês. O FinWise te ajuda a criar hábitos financeiros saudáveis!',
      imageAsset: 'assets/onboarding/welcome.png',
    ),
    _OnboardingStep(
      title: 'Desbloqueie o Premium ✨',
      description:
          'Tenha acesso a recursos exclusivos: backups automáticos, exportação de dados, temas premium, inserção em massa e muito mais!',
      imageAsset: 'assets/onboarding/welcome.png',
    ),
    _OnboardingStep(
      title: 'Pronto para começar?',
      description:
          'Toque em "Começar" e dê o primeiro passo para uma vida financeira mais leve e organizada!',
      imageAsset: 'assets/onboarding/welcome.png',
    ),
  ];

  void _nextPage() {
    if (_currentPage < _steps.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Chama o callback (se houver) e fecha a tela
      widget.onFinish?.call();
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _steps.length,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  itemBuilder: (context, index) {
                    final step = _steps[index];
                    return Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SafeAssetImage(
                            step.imageAsset,
                            height: 180,
                            fallbackAsset: 'assets/onboarding/welcome.png',
                          ),
                          const SizedBox(height: 32),
                          Text(
                            step.title,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            step.description,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _steps.length,
                  (index) => _buildDot(index),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    child: Text(
                      _currentPage == _steps.length - 1 ? 'Começar' : 'Próximo',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      );
    } catch (e, st) {
      debugPrint('OnboardingPage: build error: $e');
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
                  'Erro ao renderizar tela de onboarding',
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

  Widget _buildDot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: _currentPage == index ? 16 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.blue : Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _OnboardingStep {
  final String title;
  final String description;
  final String imageAsset;

  const _OnboardingStep({
    required this.title,
    required this.description,
    required this.imageAsset,
  });
}
