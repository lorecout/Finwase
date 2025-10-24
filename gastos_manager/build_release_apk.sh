#!/bin/bash

# Script para buildear o APK de produção do FinWise
# Uso: ./build_release_apk.sh

set -e

echo "🚀 FinWise Release Build Generator"
echo "=================================="
echo ""

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Função para validar se comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Verificar dependências
echo "📋 Verificando dependências..."
if ! command_exists flutter; then
    echo -e "${RED}❌ Flutter não instalado${NC}"
    exit 1
fi

if ! command_exists java; then
    echo -e "${RED}❌ Java não instalado${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Dependências OK${NC}"
echo ""

# Limpeza
echo "🧹 Limpando builds anteriores..."
flutter clean
rm -rf build/
echo -e "${GREEN}✅ Limpeza concluída${NC}"
echo ""

# Get dependencies
echo "📦 Baixando dependências..."
flutter pub get
echo -e "${GREEN}✅ Dependências baixadas${NC}"
echo ""

# Build release APK
echo "🔨 Buildando APK de release..."
flutter build apk \
    --release \
    --split-per-abi \
    --target-platform android-arm,android-arm64,android-x86,android-x86_64

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ APK buildado com sucesso!${NC}"
    echo ""
    echo "📍 Localização dos APKs:"
    ls -lah build/app/outputs/flutter-apk/
    echo ""
    
    # Build App Bundle (AAB) para Google Play
    echo "📦 Buildando App Bundle para Google Play..."
    flutter build appbundle --release
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ App Bundle buildado com sucesso!${NC}"
        echo ""
        echo "📍 Localização do App Bundle:"
        ls -lah build/app/outputs/bundle/release/
        echo ""
        
        echo -e "${YELLOW}✨ Build concluído!${NC}"
        echo ""
        echo "📋 Próximos passos:"
        echo "1. Fazer upload do AAB (app bundle) para Google Play Console"
        echo "2. Configurar store listing e screenshots"
        echo "3. Submeter para revisão"
        echo ""
    else
        echo -e "${RED}❌ Erro ao buildear App Bundle${NC}"
        exit 1
    fi
else
    echo -e "${RED}❌ Erro ao buildear APK${NC}"
    exit 1
fi
