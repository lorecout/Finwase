#!/bin/bash

# Script para configurar app-ads.txt no GitHub Pages
# Uso: bash configurar-app-ads.sh

echo "🚀 Iniciando configuração do app-ads.txt..."
echo ""

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Verificar se estamos em um repositório Git
if [ ! -d ".git" ]; then
    echo -e "${RED}❌ ERRO: Não é um repositório Git!${NC}"
    echo "Execute este script na raiz do seu repositório GitHub Pages"
    echo "Exemplo: cd lorecout.github.io && bash configurar-app-ads.sh"
    exit 1
fi

echo -e "${GREEN}✅ Repositório Git detectado${NC}"
echo ""

# Criar arquivo app-ads.txt
echo "📝 Criando arquivo app-ads.txt..."
cat > app-ads.txt << 'EOF'
google.com, pub-6846955506912398, DIRECT, f08c47fec0942fa0
EOF

echo -e "${GREEN}✅ Arquivo criado: app-ads.txt${NC}"
echo ""

# Verificar conteúdo
echo "🔍 Verificando conteúdo..."
if grep -q "google.com, pub-6846955506912398" app-ads.txt; then
    echo -e "${GREEN}✅ Conteúdo correto${NC}"
else
    echo -e "${RED}❌ Conteúdo inválido!${NC}"
    exit 1
fi
echo ""

# Git add
echo "📤 Adicionando arquivo ao Git..."
git add app-ads.txt
echo -e "${GREEN}✅ Arquivo adicionado${NC}"
echo ""

# Verificar status
echo "📊 Status Git:"
git status
echo ""

# Commit
echo "💬 Fazendo commit..."
git commit -m "feat: Adicionar app-ads.txt para validação AdMob"
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Commit realizado${NC}"
else
    echo -e "${YELLOW}⚠️  Commit falhou (arquivo pode estar sem mudanças)${NC}"
fi
echo ""

# Push
echo "🚀 Fazendo push para GitHub..."
git push origin main
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Push realizado com sucesso!${NC}"
else
    echo -e "${YELLOW}⚠️  Push pode ter falhado. Tente: git push origin main${NC}"
fi
echo ""

# Verificar arquivo
echo "🔗 Verificando arquivo online..."
echo "Aguarde 1-2 minutos e acesse:"
echo -e "${YELLOW}https://lorecout.github.io/app-ads.txt${NC}"
echo ""

# Próximos passos
echo -e "${GREEN}✅ PRÓXIMOS PASSOS:${NC}"
echo "1. Acesse: https://play.google.com/console"
echo "2. Configure o domínio: lorecout.github.io"
echo "3. Acesse: https://apps.admob.google.com/"
echo "4. Clique em 'Verificar se há atualizações'"
echo "5. Aguarde 24-48h para validação"
echo ""
echo -e "${GREEN}🎉 Configuração concluída!${NC}"

