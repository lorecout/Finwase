# 📄 CONFIGURAR APP-ADS.TXT NO GITHUB PAGES

## 📍 Seu Site
```
🔗 https://lorecout.github.io/
```

---

## ✅ PASSO 1: CRIAR O ARQUIVO APP-ADS.TXT

### 1.1 Clone do Repositório

Se você ainda não tem o repositório clonado localmente:

```bash
# Clone o repositório
git clone https://github.com/lorecout/lorecout.github.io.git

# Acesse a pasta
cd lorecout.github.io
```

### 1.2 Criar o Arquivo

Na raiz do repositório, crie o arquivo `app-ads.txt` com o seguinte conteúdo:

**Arquivo:** `app-ads.txt`
```
google.com, pub-6846955506912398, DIRECT, f08c47fec0942fa0
```

### 1.3 Verificar Estrutura

Sua pasta deve ficar assim:
```
lorecout.github.io/
├── index.html
├── app-ads.txt          ← NOVO ARQUIVO
├── _config.yml
└── ... (outros arquivos)
```

---

## 📤 PASSO 2: FAZER UPLOAD PARA GITHUB

### 2.1 Adicionar o Arquivo

```bash
# Adicionar arquivo ao Git
git add app-ads.txt

# Verificar status
git status
```

Você deve ver:
```
Changes to be committed:
  new file:   app-ads.txt
```

### 2.2 Fazer Commit

```bash
git commit -m "feat: Adicionar app-ads.txt para validação AdMob"
```

### 2.3 Fazer Push

```bash
git push origin main
```

(Ou `git push origin master` se sua branch for master)

---

## 🔍 PASSO 3: VERIFICAR SE FOI PUBLICADO

### 3.1 Acessar o Arquivo

Abra no navegador:
```
https://lorecout.github.io/app-ads.txt
```

Você deve ver o conteúdo:
```
google.com, pub-6846955506912398, DIRECT, f08c47fec0942fa0
```

### 3.2 Verificar Status HTTP

Se vir o conteúdo do arquivo = ✅ **SUCESSO!**

Se vir "404 Not Found" = ❌ Verificar estrutura

---

## 📱 PASSO 4: CONFIGURAR NO GOOGLE PLAY CONSOLE

### 4.1 Acessar Play Console

1. Vá em: https://play.google.com/console
2. Selecione seu app: **FinWise**
3. Menu lateral → **Configurações** → **Detalhes do app**

### 4.2 Configurar Domínio

Localize o campo **Website** ou **Site do desenvolvedor**

Digite exatamente:
```
https://lorecout.github.io
```

ou

```
lorecout.github.io
```

(Ambas funcionam)

### 4.3 Salvar Alterações

Clique em **Salvar alterações**

---

## ⏳ PASSO 5: VERIFICAR NO ADMOB (AGUARDAR 24-48H)

### 5.1 Acessar AdMob Console

1. Vá em: https://apps.admob.google.com/
2. Selecione: **Apps** → **FinWise (Android)**

### 5.2 Procurar app-ads.txt

Procure a seção "app-ads.txt" ou "Verificação de propriedade"

### 5.3 Clicar em "Verificar"

Clique em **Verificar se há atualizações** ou **Verificar agora**

### 5.4 Aguardar Resultado

Status possível:
- ✅ **Verificado** - app-ads.txt está correto!
- ⏳ **Aguardando** - Está verificando (24-48h)
- ⚠️ **Não encontrado** - Verificar arquivo
- ❌ **Erro** - Revisar conteúdo

---

## 🛠️ TROUBLESHOOTING

### Problema: "404 Not Found" ao acessar app-ads.txt

**Causa:** Arquivo não está na raiz do GitHub Pages

**Solução:**
1. Verifique se o arquivo está em: `lorecout.github.io/app-ads.txt`
2. Não coloque em pastas como `docs/` ou `_config/`
3. Verifique se o nome é exatamente `app-ads.txt` (minúsculas)

### Problema: AdMob não encontra o arquivo

**Causa:** GitHub Pages ainda está propagando

**Solução:**
1. Aguarde 10-15 minutos após fazer push
2. Limpe o cache do navegador
3. Tente em navegador privado
4. Verifique se a URL está correta no Play Console

### Problema: Ainda aparece "Não verificado"

**Causa:** Pode ser propagação de DNS

**Solução:**
1. Aguarde mais 24 horas
2. Verifique novamente no AdMob
3. Se persistir após 48h, contate suporte AdMob

---

## ✅ CHECKLIST GITHUB PAGES

### Antes de Fazer Push
- [ ] Arquivo criado: `app-ads.txt`
- [ ] Conteúdo correto: `google.com, pub-6846955506912398, DIRECT, f08c47fec0942fa0`
- [ ] Arquivo na raiz do repositório
- [ ] Nome sem espaços ou extensões extras

### Após Fazer Push
- [ ] Acessível em: `https://lorecout.github.io/app-ads.txt`
- [ ] Mostra o conteúdo correto
- [ ] Play Console tem o domínio correto
- [ ] AdMob está verificando

### Verificação (24-48h depois)
- [ ] AdMob mostram status "Verificado"
- [ ] Sem avisos de app-ads.txt
- [ ] Receita de anúncios normal

---

## 📋 PASSOS RÁPIDOS (RESUMO)

```bash
# 1. Clone (se necessário)
git clone https://github.com/lorecout/lorecout.github.io.git
cd lorecout.github.io

# 2. Criar arquivo
echo "google.com, pub-6846955506912398, DIRECT, f08c47fec0942fa0" > app-ads.txt

# 3. Fazer upload
git add app-ads.txt
git commit -m "feat: Adicionar app-ads.txt para validação AdMob"
git push origin main

# 4. Verificar
# Abra: https://lorecout.github.io/app-ads.txt
```

---

## 🔗 LINKS ÚTEIS

### GitHub
```
Repositório: https://github.com/lorecout/lorecout.github.io
Site: https://lorecout.github.io/
app-ads.txt: https://lorecout.github.io/app-ads.txt
```

### Google
```
Play Console: https://play.google.com/console
AdMob Console: https://apps.admob.google.com/
app-ads.txt Docs: https://support.google.com/admob/answer/9787782
```

---

## 🎯 PRÓXIMO PASSO

Após confirmar que o arquivo está acessível em `https://lorecout.github.io/app-ads.txt`:

1. ✅ Configure o domínio no Play Console
2. ⏳ Aguarde 24-48h para verificação no AdMob
3. 🚀 Após verificado, publique seu app!

---

**🎉 Pronto! Seu app-ads.txt será validado em 24-48h**

Se precisar de mais ajuda, consulte os documentos:
- `CONFIGURACAO_ADMOB.md`
- `ATIVAR_PRODUCAO.md`
- `RESUMO_EXECUTIVO.md`

