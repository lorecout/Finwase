/// Constantes de Monetização - AdMob e In-App Purchases
///
/// ⚠️ IMPORTANTE: Substitua os valores de exemplo pelos IDs reais do seu console
library;

class AdConstants {
  // ============================================
  // GOOGLE ADMOB - IDs de Anúncios
  // ============================================

  /// ID do App no Google AdMob
  /// Obtenha em: https://admob.google.com > Configurações do App
  static const String admobAppId = 'ca-app-pub-6846955506912398~2473407367';

  // --- ANÚNCIOS BANNER ---
  /// Banner Ad Unit ID para Android
  /// Tamanho: 320x50 (Banner) ou 320x100 (Large Banner)
  static const String bannerAdUnitId = 'ca-app-pub-6846955506912398/2600398827';

  /// Banner grande para home
  static const String largeBannerAdUnitId = 'ca-app-pub-6846955506912398/2600398827';

  // --- ANÚNCIOS INTERSTICIAIS ---
  /// Interstitial Ad Unit ID para Android
  /// Mostrado entre transições de tela
  static const String interstitialAdUnitId = 'ca-app-pub-6846955506912398/7605313496';

  // --- ANÚNCIOS RECOMPENSADOS ---
  /// Rewarded Ad Unit ID para Android
  /// Usuário assiste anúncio e ganha recompensa (ex: remove 1 transação)
  /// ⚠️ IMPORTANTE: Crie esta unidade no AdMob e substitua o ID abaixo
  /// 1. Acesse: https://admob.google.com
  /// 2. Apps > Finans > Adicionar unidade de anúncio > Recompensado
  /// 3. Copie o ID e cole aqui
  static const String rewardedAdUnitId = 'ca-app-pub-6846955506912398/REWARDED_ID_AQUI';

  /// Rewarded Interstitial Ad Unit ID
  /// Combine recompensa com interstitial
  static const String rewardedInterstitialAdUnitId = 'ca-app-pub-6846955506912398/REWARDED_INTERSTITIAL_ID_AQUI';

  // ============================================
  // IN-APP PURCHASES - Produtos Premium
  // ============================================

  /// ID do produto premium (mensal)
  /// Registre em: Play Console > Seu App > Monetização > In-app products
  static const String premiumMonthlyProductId = 'finwise_premium_monthly';

  /// ID do produto premium (anual)
  static const String premiumYearlyProductId = 'finwise_premium_yearly';

  /// ID do produto lifetime
  static const String premiumLifetimeProductId = 'finwise_premium_lifetime';

  // ============================================
  // CONFIGURAÇÕES DE FREQUÊNCIA
  // ============================================

  /// Mostrar interstitial a cada N transações criadas
  static const int interstitialFrequency = 5;

  /// Mostrar banner a cada N páginas visitadas
  static const int bannerFrequency = 1;

  /// Intervalo mínimo entre interstitials (em segundos)
  static const int interstitialMinInterval = 60;

  /// Máximo de anúncios por sessão
  static const int maxAdsPerSession = 10;

  // ============================================
  // FLAGS DE TESTE
  // ============================================

  /// Use IDs de teste para desenvolvimento
  /// IDs de teste são fornecidos pelo Google e não geram receita
  static const bool useTestAds = false; // ✅ Use IDs reais agora

  /// IDs de teste do Google AdMob (não geram receita)
  static const String testDeviceId = 'TEST_DEVICE_ID_HERE';

  // ============================================
  // MÉTODOS AUXILIARES
  // ============================================

  /// Retorna o App ID correto (teste ou produção)
  static String getAdMobAppId() {
    if (useTestAds) {
      return 'ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy'; // Seu ID real
    }
    return admobAppId;
  }

  /// Retorna o Banner Ad Unit ID correto
  static String getBannerAdUnitId() {
    if (useTestAds) {
      return 'ca-app-pub-3940256099942544/6300978111'; // ID de teste do Google
    }
    return bannerAdUnitId;
  }

  /// Retorna o Interstitial Ad Unit ID correto
  static String getInterstitialAdUnitId() {
    if (useTestAds) {
      return 'ca-app-pub-3940256099942544/1033173712'; // ID de teste do Google
    }
    return interstitialAdUnitId;
  }

  /// Retorna o Rewarded Ad Unit ID correto
  static String getRewardedAdUnitId() {
    if (useTestAds) {
      return 'ca-app-pub-3940256099942544/5224354917'; // ID de teste do Google
    }
    return rewardedAdUnitId; // ⚠️ Criar unidade no AdMob e atualizar ID acima
  }
}

// Atualize com seus IDs reais de produção do AdMob obtidos no console do AdMob.
class AdConstantsProd {
  // App-level: definido via AndroidManifest com com.google.android.gms.ads.APPLICATION_ID
  // Unidades de anúncio:
  static const String bannerAdUnitIdAndroid = 'ca-app-pub-6846955506912398/PROD_BANNER_ID';
  static const String interstitialAdUnitIdAndroid = 'ca-app-pub-6846955506912398/PROD_INTERSTITIAL_ID';
  static const String rewardedAdUnitIdAndroid = 'ca-app-pub-6846955506912398/PROD_REWARDED_ID';

  // iOS (se necessário)
  static const String bannerAdUnitIdiOS = 'ca-app-pub-6846955506912398/PROD_BANNER_ID_IOS';
  static const String interstitialAdUnitIdiOS = 'ca-app-pub-6846955506912398/PROD_INTERSTITIAL_ID_IOS';
  static const String rewardedAdUnitIdiOS = 'ca-app-pub-6846955506912398/PROD_REWARDED_ID_IOS';
}

/// Classe para gerenciar preços dos planos premium
class PremiumPricing {
  static const double monthlyPrice = 9.90;
  static const double yearlyPrice = 79.90; // ~R$6.66/mês
  static const double lifetimePrice = 199.90;

  static const String monthlyDescription = 'Acesso premium por 1 mês';
  static const String yearlyDescription = 'Acesso premium por 12 meses (25% desconto)';
  static const String lifetimeDescription = 'Acesso premium vitalício';

  /// Calcula economia ao escolher anual
  static double getSavingsPercentage() {
    double monthlyTotal = monthlyPrice * 12;
    double savings = monthlyTotal - yearlyPrice;
    return (savings / monthlyTotal) * 100;
  }
}

/// Benefícios do plano premium
class PremiumBenefits {
  static const List<String> benefits = [
    'Zero anúncios',
    'IA avançada para análise',
    'Relatórios completos e exportação',
    'Backup ilimitado na nuvem',
    'Suporte prioritário',
    'Novas funcionalidades em primeiro',
    'Temas premium exclusivos',
    'Categorias ilimitadas',
  ];
}
