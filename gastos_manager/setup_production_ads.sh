#!/bin/bash

# Script para configurar IDs de produção do AdMob
# Execute: chmod +x setup_production_ads.sh && ./setup_production_ads.sh

echo "🚀 Configuração de IDs de Produção do AdMob"
echo "=========================================="
echo ""

# Solicitar IDs do usuário
echo "📝 Cole os IDs do seu AdMob (disponíveis em: https://admob.google.com/)"
echo ""

read -p "🔗 Banner Ad Unit ID: " BANNER_ID
read -p "🔗 Interstitial Ad Unit ID: " INTERSTITIAL_ID

# Validar formato dos IDs
if [[ ! $BANNER_ID =~ ^ca-app-pub-[0-9]+/[0-9]+$ ]]; then
    echo "❌ Formato inválido para Banner ID. Deve ser: ca-app-pub-XXXXX/YYYYY"
    exit 1
fi

if [[ ! $INTERSTITIAL_ID =~ ^ca-app-pub-[0-9]+/[0-9]+$ ]]; then
    echo "❌ Formato inválido para Interstitial ID. Deve ser: ca-app-pub-XXXXX/YYYYY"
    exit 1
fi

# Arquivo AdService
ADSERVICE_FILE="lib/services/ad_service.dart"

# Backup do arquivo original
cp "$ADSERVICE_FILE" "${ADSERVICE_FILE}.backup"
echo "✅ Backup criado: ${ADSERVICE_FILE}.backup"

# Substituir IDs de teste pelos de produção
sed -i "s|static const String _testBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';|static const String _productionBannerAdUnitId = '$BANNER_ID';|" "$ADSERVICE_FILE"
sed -i "s|static const String _testInterstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';|static const String _productionInterstitialAdUnitId = '$INTERSTITIAL_ID';|" "$ADSERVICE_FILE"

# Atualizar métodos getter
sed -i "s|return _testBannerAdUnitId;|return _productionBannerAdUnitId;|" "$ADSERVICE_FILE"
sed -i "s|return _testInterstitialAdUnitId;|return _productionInterstitialAdUnitId;|" "$ADSERVICE_FILE"

# Remover comentários TODO
sed -i "/TODO: Substitua pelo seu ID real quando publicar/d" "$ADSERVICE_FILE"
sed -i "/(use o ID de teste por enquanto)/d" "$ADSERVICE_FILE"

echo ""
echo "✅ Configuração concluída!"
echo ""
echo "📋 Resumo das mudanças:"
echo "   • Banner ID: $BANNER_ID"
echo "   • Interstitial ID: $INTERSTITIAL_ID"
echo "   • Arquivo: $ADSERVICE_FILE"
echo ""
echo "⚠️  IMPORTANTE:"
echo "   • NUNCA commite este arquivo no Git!"
echo "   • Adicione ao .gitignore se necessário"
echo "   • Teste em dispositivo real antes de publicar"
echo ""
echo "🧪 Para testar:"
echo "   flutter build apk --release"
echo "   flutter install"
echo ""
echo "🚀 Pronto para publicar!"</content>
<parameter name="filePath">c:\Users\lore-\OneDrive\Ambiente de Trabalho\NEWappdefinans\gastos_manager\setup_production_ads.sh