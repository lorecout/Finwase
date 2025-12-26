#!/bin/bash
# Script para build limpo do Flutter Linux
# Remove diretórios de build e executa build completo

set -e

cd "$(dirname "$0")/.."

BUILD_DIR="build/linux/x64"

if [ -d "$BUILD_DIR" ]; then
  echo "Removendo diretório de build antigo..."
  rm -rf "$BUILD_DIR"
fi

echo "Executando flutter clean..."
flutter clean

echo "Executando flutter build linux..."
flutter build linux

echo "Build limpo concluído."
