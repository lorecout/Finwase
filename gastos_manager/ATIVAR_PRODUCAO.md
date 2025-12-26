# 🚀 ATIVAR MODO DE PRODUÇÃO - PASSO A PASSO

## ⚠️ ANTES DE COMEÇAR

### Requisitos
- ✅ Conta AdMob configurada
- ✅ App publicado no Google Play (ou em teste)
- ✅ Site do desenvolvedor (para app-ads.txt)

### ⚠️ ATENÇÃO
**NÃO ative o modo de produção antes de publicar o app!**
- Mantenha em modo de teste durante desenvolvimento
- Só mude para produção quando o app estiver na Play Store

---

## 📋 PASSO 1: CRIAR UNIDADES DE ANÚNCIO

### 1.1 Acessar AdMob Console
```
🔗 https://apps.admob.google.com/
```

### 1.2 Criar Unidade de Banner
1. Clique em **Apps** → **FinWise (Android)**
2. Clique em **Unidades de anúncio** → **Adicionar unidade de anúncio**
3. Selecione: **Banner**
4. Configure:
   - **Nome:** Banner Principal
   - **Formato:** Banner padrão (320x50)
5. Clique em **Criar unidade de anúncio**
6. **COPIE O ID:** `ca-app-pub-6846955506912398/XXXXXXXXXX`

### 1.3 Criar Unidade Intersticial
1. Adicionar nova unidade de anúncio
2. Selecione: **Intersticial**
3. Configure:
   - **Nome:** Intersticial Principal
4. Clique em **Criar unidade de anúncio**
5. **COPIE O ID:** `ca-app-pub-6846955506912398/YYYYYYYYYY`

### 1.4 Criar Unidade com Recompensa
1. Adicionar nova unidade de anúncio
2. Selecione: **Com recompensa**
3. Configure:
   - **Nome:** Recompensa Principal
   - **Recompensa:** Moedas (quantidade: 10)
4. Clique em **Criar unidade de anúncio**
5. **COPIE O ID:** `ca-app-pub-6846955506912398/ZZZZZZZZZZ`

---

## 📝 PASSO 2: ATUALIZAR CÓDIGO

### 2.1 Editar ad_service.dart

Abra o arquivo:
```
lib/services/ad_service.dart
```

Localize as linhas (aproximadamente linhas 16-18):
```dart
// IDs de produção (substitua pelos seus IDs reais do AdMob)
static const String _prodBannerId = 'ca-app-pub-6846955506912398/9999999999';
static const String _prodInterstitialId = 'ca-app-pub-6846955506912398/8888888888';
static const String _prodRewardedId = 'ca-app-pub-6846955506912398/7777777777';
```

Substitua pelos IDs copiados no Passo 1:
```dart
// IDs de produção (SEUS IDs REAIS do AdMob)
static const String _prodBannerId = 'ca-app-pub-6846955506912398/XXXXXXXXXX';
static const String _prodInterstitialId = 'ca-app-pub-6846955506912398/YYYYYYYYYY';
static const String _prodRewardedId = 'ca-app-pub-6846955506912398/ZZZZZZZZZZ';
```

### 2.2 Ativar Modo de Produção

Localize a linha (aproximadamente linha 21):
```dart
static bool _isTestMode = true;
```

Mude para:
```dart
static bool _isTestMode = false;
```

### 2.3 Salvar e Recompilar
```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

---

## 🌐 PASSO 3: CONFIGURAR APP-ADS.TXT

### 3.1 Criar Arquivo app-ads.txt

Crie um arquivo de texto com o seguinte conteúdo:
```
google.com, pub-6846955506912398, DIRECT, f08c47fec0942fa0
```

### 3.2 Publicar no Seu Site

**Opção A: Se você tem um site**
1. Faça upload do arquivo `app-ads.txt` para a raiz do site
2. Exemplo: `https://seusite.com/app-ads.txt`
3. Verifique acessando a URL no navegador

**Opção B: Se você NÃO tem um site**

Você pode usar serviços gratuitos como:

1. **GitHub Pages (RECOMENDADO):**
   ```
   1. Vá para: https://github.com/lorecout/lorecout.github.io
   2. Clique em "Settings" (Configurações)
   3. Vá em "Pages" no menu esquerdo
   4. Verifique se está marcado "Deploy from a branch"
   5. Branch: main (ou master)
   6. Folder: / (root)
   7. Clique em "Save"
   8. Aguarde a página verde: ✓ Your site is live at https://lorecout.github.io
   9. Adicione arquivo app-ads.txt na raiz do repositório
   10. URL final: https://lorecout.github.io/app-ads.txt
   ```

2. **Google Sites:**
   ```
   1. Crie site gratuito
   2. Adicione página com conteúdo do app-ads.txt
   3. Configure domínio personalizado (opcional)
   ```

3. **Netlify/Vercel:**
   ```
   1. Crie conta gratuita
   2. Faça deploy de pasta com app-ads.txt
   3. URL: https://seu-app.netlify.app/app-ads.txt
   ```

### 3.3 Configurar no Google Play Console

1. Acesse: https://play.google.com/console
2. Selecione seu app: **FinWise**
3. Vá em: **Configurações** → **Detalhes do app**
4. Localize: **Site**
5. Adicione: `https://seusite.com` (ou o domínio que você usou)
6. Salve as alterações

### 3.4 Verificar no AdMob

1. Acesse: https://apps.admob.google.com/
2. Vá em: **Apps** → **FinWise (Android)**
3. Procure seção: **app-ads.txt**
4. Clique em: **Verificar se há atualizações**
5. Aguarde: 24-48 horas para validação

---

## 🔍 PASSO 4: TESTAR ANTES DE PUBLICAR

### 4.1 Build de Teste
```bash
flutter build apk --debug
flutter install
```

### 4.2 Verificar Anúncios
1. Abra o app no dispositivo
2. Navegue para telas com anúncios
3. Verifique se carregam corretamente
4. **NÃO clique nos anúncios!** (para evitar cliques inválidos)

### 4.3 Monitorar Logs
```bash
flutter logs
```

Procure por mensagens como:
```
✅ AdMob: Anúncio carregado com sucesso
✅ AdService: Modo de produção ativo
```

---

## 📦 PASSO 5: GERAR E PUBLICAR

### 5.1 Gerar AAB de Release
```bash
cd C:\Users\Lorena\StudioProjects\Finwase\gastos_manager
flutter build appbundle --release
```

### 5.2 Localizar Arquivo
```
Arquivo: build\app\outputs\bundle\release\app-release.aab
Tamanho: ~30-50 MB
```

### 5.3 Fazer Upload no Play Console

1. Acesse: https://play.google.com/console
2. Selecione: **FinWise**
3. Vá em: **Produção** → **Criar nova versão**
4. Faça upload: `app-release.aab`
5. Preencha: **Notas da versão**
   ```
   Versão 1.0.5
   - Melhorias de desempenho
   - Correções de bugs
   - Otimizações de anúncios
   ```
6. Clique em: **Revisar versão**
7. Clique em: **Iniciar implementação**

### 5.4 Aguardar Aprovação
- Tempo médio: 1-7 dias
- Você receberá email quando for aprovado
- Acompanhe em: **Visão geral da publicação**

---

## ✅ PASSO 6: APÓS APROVAÇÃO

### 6.1 Publicar Manualmente
Como você tem **Publicação gerenciada** ativada:

1. Acesse: **Visão geral da publicação**
2. Quando ver: **"Pronto para publicar"**
3. Clique em: **Publicar versão**
4. Confirme a publicação

### 6.2 Aguardar Disponibilidade
- Tempo de propagação: 2-24 horas
- O app ficará disponível gradualmente

### 6.3 Verificar app-ads.txt
Após 24-48 horas da publicação do app:

1. Acesse AdMob Console
2. Vá em: **Apps** → **FinWise**
3. Verifique status do app-ads.txt:
   - ✅ **Verificado** - Tudo certo!
   - ⚠️ **Não verificado** - Revisar configuração
   - ❌ **Erro** - Verificar arquivo e domínio

---

## 📊 PASSO 7: MONITORAR RECEITA

### 7.1 Acessar Dashboard AdMob
```
🔗 https://apps.admob.google.com/
```

### 7.2 Métricas Importantes
- **Impressões:** Quantas vezes anúncios foram exibidos
- **Cliques:** Quantas vezes foram clicados
- **CTR:** Taxa de clique (ideal: 1-3%)
- **eCPM:** Ganho por mil impressões
- **Receita Estimada:** Ganho total estimado

### 7.3 Relatórios
1. Vá em: **Relatórios**
2. Selecione período: **Últimos 7 dias**
3. Visualize por:
   - Dia
   - Formato de anúncio
   - Plataforma

---

## ⚠️ PROBLEMAS COMUNS

### Anúncios não aparecem
**Possíveis causas:**
1. IDs incorretos → Verificar ad_service.dart
2. Modo de teste ainda ativo → Verificar _isTestMode
3. AdMob ainda processando → Aguardar 24h
4. App não publicado → Publicar na Play Store

**Solução:**
```bash
# Ver logs
flutter logs | grep -i "ad"

# Verificar status
print(AdService.getAdStatus());
```

### app-ads.txt não verifica
**Possíveis causas:**
1. Arquivo não na raiz do domínio
2. Conteúdo incorreto
3. Domínio diferente do Play Console
4. Ainda propagando (24-48h)

**Solução:**
1. Acessar diretamente: `https://seusite.com/app-ads.txt`
2. Verificar conteúdo exato
3. Aguardar propagação
4. Verificar domínio no Play Console

### Receita muito baixa
**Possível causa:**
- Poucos usuários
- CTR baixo
- eCPM baixo
- Localização geográfica

**Dicas para melhorar:**
1. Aumentar base de usuários
2. Posicionar anúncios estrategicamente
3. Não exagerar na frequência
4. Usar anúncios relevantes

---

## 📋 CHECKLIST COMPLETO

### Antes de Ativar Produção
- [ ] App publicado no Google Play
- [ ] Unidades de anúncio criadas no AdMob
- [ ] IDs de produção copiados
- [ ] ad_service.dart atualizado
- [ ] _isTestMode = false
- [ ] app-ads.txt criado
- [ ] app-ads.txt publicado no site
- [ ] Domínio configurado no Play Console

### Após Ativar Produção
- [ ] Build de release gerado
- [ ] AAB enviado para Play Console
- [ ] Aprovação do Google recebida
- [ ] App publicado manualmente
- [ ] app-ads.txt verificado no AdMob (24-48h)
- [ ] Primeiras impressões aparecendo
- [ ] Receita sendo gerada

---

## 📞 SUPORTE

### Precisa de Ajuda?

**AdMob:**
- Central de Ajuda: https://support.google.com/admob
- Fórum: https://groups.google.com/g/google-admob-ads-sdk

**Google Play:**
- Central de Ajuda: https://support.google.com/googleplay/android-developer

**Flutter:**
- Documentação: https://docs.flutter.dev/
- Stack Overflow: https://stackoverflow.com/questions/tagged/flutter

---

**📅 Última atualização:** 07/12/2025
**✅ Status:** Instruções completas e testadas
**🎯 Objetivo:** Ativar anúncios de produção e gerar receita real

