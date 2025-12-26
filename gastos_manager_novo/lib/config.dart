// ===================================================================
// FEATURE FLAGS - CONFIGURAÇÃO PARA GRATUITO TOTAL
// ===================================================================
// Esta configuração torna TODOS os recursos disponíveis gratuitamente
// para todos os usuários, sem restrições de premium.
// ===================================================================

// 🎁 TODOS OS USUÁRIOS SÃO PREMIUM
// Set to true to force the app to treat every user as premium.
// ✅ HABILITADO: Todos ganham acesso premium automáticamente
const bool FORCE_PREMIUM = true;

// ⏭️ PULAR TELA DE TRIAL/PREMIUM
// If true, the trial/premium intro page will be skipped and the app
// will continue directly to the auth/main flow.
// ✅ HABILITADO: Experiência mais rápida, sem popups de premium
const bool SKIP_TRIAL_PAGE = true;

// 💰 PUBLICIDADE HABILITADA PARA MONETIZAÇÃO
// New: If true, users who run the app in the ad-supported mode will
// receive the premium feature set while still seeing ads.
// ✅ HABILITADO: Usuários veem recursos premium COM ANÚNCIOS para monetização
const bool ADS_MODE_GIVES_PREMIUM = true;

// 📱 MOSTRAR ANÚNCIOS PARA MONETIZAÇÃO
// Se true, anúncios são mostrados mesmo com premium gratuito
const bool SHOW_ADS_WITH_FREE_PREMIUM = true;

// 🚫 REMOVE ADS NÃO É NECESSÁRIO
// If true, removing ads requires a purchase/subscription.
// ✅ DESABILITADO: Nenhuma compra necessária, acesso total gratuito
const bool REMOVE_ADS_PURCHASE_REQUIRED = false;

// ===================================================================
// RESULTADO FINAL:
// ✅ Todos os usuários têm acesso premium completo
// ✅ COM anúncios para monetização
// ✅ Sem necessidade de fazer login ou comprar
// ✅ Experiência 100% gratuita com anúncios
// ===================================================================
