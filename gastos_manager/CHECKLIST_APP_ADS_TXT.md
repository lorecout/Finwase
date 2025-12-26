# ✅ CHECKLIST - CONFIGURAR APP-ADS.TXT

## 🎯 SEU SITE
```
https://lorecout.github.io/
```

---

## 📋 CHECKLIST PASSO A PASSO

### FASE 1: PREPARAR REPOSITÓRIO ✅

- [ ] Abrir terminal/PowerShell
- [ ] Navegar até pasta do repositório
  ```
  cd lorecout.github.io
  ```
- [ ] Verificar se é um repositório Git
  ```
  git status
  ```

### FASE 2: CRIAR ARQUIVO ✅

**Opção A: Usar Script (RECOMENDADO)**
- [ ] Windows: Execute `.\configurar-app-ads.ps1`
- [ ] Mac/Linux: Execute `bash configurar-app-ads.sh`

**Opção B: Criar Manualmente**
- [ ] Criar arquivo chamado `app-ads.txt` na raiz
- [ ] Adicionar este conteúdo:
  ```
  google.com, pub-6846955506912398, DIRECT, f08c47fec0942fa0
  ```

### FASE 3: FAZER UPLOAD ✅

- [ ] Git add:
  ```
  git add app-ads.txt
  ```
- [ ] Verificar status:
  ```
  git status
  ```
  (deve mostrar "app-ads.txt" em verde/modificado)

- [ ] Fazer commit:
  ```
  git commit -m "feat: Adicionar app-ads.txt para validação AdMob"
  ```

- [ ] Fazer push:
  ```
  git push origin main
  ```
  (ou `git push origin master` se sua branch for master)

### FASE 4: VERIFICAR ARQUIVO ✅

- [ ] Aguardar 1-2 minutos
- [ ] Abrir no navegador:
  ```
  https://lorecout.github.io/app-ads.txt
  ```
- [ ] Verificar se vê o conteúdo:
  ```
  google.com, pub-6846955506912398, DIRECT, f08c47fec0942fa0
  ```

### FASE 5: CONFIGURAR NO PLAY CONSOLE ✅

- [ ] Acessar: https://play.google.com/console
- [ ] Selecionar app: FinWise
- [ ] Menu: Configurações → Detalhes do app
- [ ] Campo: Website (ou Site do desenvolvedor)
- [ ] Digitar:
  ```
  lorecout.github.io
  ```
  ou
  ```
  https://lorecout.github.io
  ```
- [ ] Clique em: Salvar alterações

### FASE 6: VERIFICAR NO ADMOB ⏳

- [ ] Acessar: https://apps.admob.google.com/
- [ ] Selecionar: Apps → FinWise (Android)
- [ ] Procurar: seção app-ads.txt
- [ ] Clique em: Verificar se há atualizações
- [ ] ⏳ Aguardar: 24-48 horas

---

## 🔄 FLUXO RÁPIDO

```
1. Clone repositório (se necessário)
   └─ git clone https://github.com/lorecout/lorecout.github.io.git

2. Crie app-ads.txt com conteúdo correto
   └─ File: app-ads.txt
   └─ Content: google.com, pub-6846955506912398, DIRECT, f08c47fec0942fa0

3. Faça upload para GitHub
   └─ git add app-ads.txt
   └─ git commit -m "feat: Adicionar app-ads.txt para validação AdMob"
   └─ git push origin main

4. Aguarde propagação (1-2 minutos)

5. Verifique acesso
   └─ https://lorecout.github.io/app-ads.txt

6. Configure no Play Console
   └─ Website: lorecout.github.io

7. Verifique no AdMob
   └─ Clique em "Verificar se há atualizações"

8. Aguarde validação (24-48h) ⏳
```

---

## ✅ VERIFICAÇÃO COMPLETA

### Arquivo Criado Corretamente?
```
📁 lorecout.github.io/
   ├── index.html
   ├── app-ads.txt ✅ (NOVO)
   └── ... (outros arquivos)
```

### Arquivo Acessível?
```
✅ https://lorecout.github.io/app-ads.txt
   └─ Mostra: google.com, pub-6846955506912398, DIRECT, f08c47fec0942fa0
```

### Play Console Configurado?
```
✅ Website: lorecout.github.io
   └─ Status: Salvo
```

### AdMob Verificando?
```
⏳ Status: Em verificação
   └─ Próximo status em: 24-48h
```

---

## ⚠️ PROBLEMAS COMUNS

### ❌ "Arquivo não encontrado" (404)

**Verificar:**
- [ ] Arquivo está na raiz: `lorecout.github.io/app-ads.txt`
- [ ] Nome exato: `app-ads.txt` (minúsculas)
- [ ] Sem extensão extra: `app-ads.txt` (não `app-ads.txt.txt`)
- [ ] Git push funcionou: verificar no GitHub

**Solução:**
1. Delete arquivo: `git rm app-ads.txt`
2. Commit: `git commit -m "Remove file"`
3. Push: `git push origin main`
4. Recrie arquivo com nome correto
5. Repita upload

### ❌ "Domínio não encontrado"

**Verificar:**
- [ ] Domínio correto no Play Console: `lorecout.github.io`
- [ ] Sem `https://` ou `/` extra
- [ ] Play Console salvo as alterações

**Solução:**
1. Acesse Play Console
2. Vá em Configurações → Detalhes do app
3. Campo Website: limpe e digite novamente
4. Salve as mudanças

### ❌ "app-ads.txt ainda não verificado"

**Possível:**
- [ ] Ainda está em processo (24-48h)
- [ ] GitHub Pages propagando (aguarde 5-10 min)
- [ ] Cache do navegador (limpe ou use modo privado)

**Solução:**
1. Aguarde mais 24 horas
2. Tente em navegador diferente
3. Limpe cache: Ctrl+Shift+Delete
4. Se persistir: contate suporte AdMob

---

## 📱 APÓS VERIFICAÇÃO

### Quando app-ads.txt for Verificado ✅

1. ✅ AdMob mostrará "Verificado"
2. ✅ Receita melhorará
3. ✅ Sem avisos no Play Console
4. ✅ Pronto para publicar app

### Próximos Passos

```
1. Gerar build de release
   └─ flutter build appbundle --release

2. Publicar no Play Console
   └─ Upload: build/app/outputs/bundle/release/app-release.aab

3. Enviar para revisão
   └─ Preencher notas da versão

4. Aguardar aprovação (1-7 dias)

5. Publicar manualmente (publicação gerenciada)

6. Monitorar receita no AdMob
```

---

## 📞 LINKS ÚTEIS

```
GitHub:           https://github.com/lorecout/lorecout.github.io
Seu site:         https://lorecout.github.io/
app-ads.txt:      https://lorecout.github.io/app-ads.txt

Play Console:     https://play.google.com/console
AdMob Console:    https://apps.admob.google.com/
app-ads.txt Docs: https://support.google.com/admob/answer/9787782
```

---

## 🎯 RESULTADO ESPERADO

### Status Esperado Após 24-48h

```
PLAY CONSOLE:
├─ Website: lorecout.github.io ✅
└─ Nenhum aviso sobre app-ads.txt ✅

ADMOB:
├─ app-ads.txt: Verificado ✅
├─ Status: Ativo ✅
└─ Receita: Otimizada ✅

APP-ADS.TXT:
├─ Acessível: https://lorecout.github.io/app-ads.txt ✅
└─ Conteúdo: google.com, pub-6846955506912398, DIRECT, f08c47fec0942fa0 ✅
```

---

## 🚀 PRÓXIMAS AÇÕES

- [ ] Executar script ou seguir passos manuais
- [ ] Aguardar 1-2 min propagação
- [ ] Testar acesso ao arquivo
- [ ] Configurar domínio no Play Console
- [ ] Aguardar 24-48h para verificação
- [ ] Monitorar status no AdMob
- [ ] Publicar app quando estiver verificado

---

**🎉 Você está quase lá! Mais alguns passos e seu app gerará receita real!**

Dúvidas? Consulte:
- `CONFIGURAR_APP_ADS_TXT.md` - Guia detalhado
- `ATIVAR_PRODUCAO.md` - Como ativar modo de produção
- `RESUMO_EXECUTIVO.md` - Visão geral do projeto

