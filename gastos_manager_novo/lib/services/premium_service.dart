import 'package:flutter/material.dart';

/// Enum global para os planos do app
enum AppPlan { free, pro }

class PremiumService extends ChangeNotifier {
  // Valor da mensalidade do plano Pro (pode ser usado para exibir na UI)
  static const double proMonthlyPrice = 14.99; // Exemplo em reais

  // Simula compra/assinatura do Pro (pode ser integrado ao Google Play Billing futuramente)
  Future<void> comprarPro() async {
    // Aqui você pode integrar com o sistema de pagamentos real
    upgradeToPro();
    // Salvar status no backend, se necessário
    // Exemplo: await salvarPlanoNoFirestore();
  }

  AppPlan _currentPlan = AppPlan.free;
  DateTime? _premiumExpiryDate;
  bool _hasHadTrial = false;
  DateTime? _trialGrantedAt;

  // Getters públicos
  bool get isPro => _currentPlan == AppPlan.pro;
  bool get isFree => _currentPlan == AppPlan.free;
  bool get showAds => _currentPlan == AppPlan.free;
  AppPlan get currentPlan => _currentPlan;
  DateTime? get premiumExpiryDate => _premiumExpiryDate;
  bool get hasHadTrial => _hasHadTrial;
  DateTime? get trialGrantedAt => _trialGrantedAt;

  // Carregar dados do usuário (mock/simples)
  Future<void> loadUserData() async {
    // Aqui você pode carregar dados do backend, se necessário
    // Exemplo: manter sempre plano free por padrão
    _currentPlan = AppPlan.free;
    _premiumExpiryDate = null;
    _hasHadTrial = false;
    _trialGrantedAt = null;
    notifyListeners();
  }

  // Upgrade para Pro
  void upgradeToPro() {
    _currentPlan = AppPlan.pro;
    _premiumExpiryDate = DateTime.now().add(const Duration(days: 30));
    notifyListeners();
  }

  // Downgrade para Free
  void downgradeToFree() {
    _currentPlan = AppPlan.free;
    _premiumExpiryDate = null;
    notifyListeners();
  }
}

// --- Fim da lógica principal do serviço premium ---
