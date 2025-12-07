# ✅ CHECKLIST APP-ADS.TXT - FINWISE

## 🎯 OBJETIVO
Resolver o erro de verificação do AdMob configurando corretamente o arquivo app-ads.txt.

---

## 📋 PASSO-A-PASSO RÁPIDO

### ETAPA 1: PREPARAÇÃO (2 minutos)
```
[ ] Arquivo app-ads.txt criado ✅ (já está pronto neste projeto!)
[ ] Conteúdo verificado: google.com, pub-6846955506912398, DIRECT, f08c47fec0942fa0
```

**Localização do arquivo:**
```
C:\Users\Lorena\StudioProjects\Finwase\gastos_manager\app-ads.txt
```

---

### ETAPA 2: DESCOBRIR SEU DOMÍNIO (2 minutos)

**Onde encontrar:**
1. Acesse: https://play.google.com/console
2. Selecione: FinWise
3. Menu: Configurações → Detalhes do app
4. Procure: "Site do desenvolvedor"
5. Anote aqui: ___________________________________

**Exemplos comuns:**
- www.finwise.com.br
- www.lorecout.com
- lorecout.github.io
- seusite.com

---

### ETAPA 3: PUBLICAR NO SERVIDOR (5-10 minutos)

**Escolha seu método:**

#### [ ] Opção A: cPanel
```
1. Acesse cPanel do seu domínio
2. Gerenciador de Arquivos → public_html/
3. Upload → Selecione app-ads.txt
4. Permissões: 644
```

#### [ ] Opção B: FTP (FileZilla)
```
1. Conecte ao servidor FTP
2. Navegue até: public_html/ ou www/
3. Arraste app-ads.txt para essa pasta
4. Confirme permissões: 644
```

#### [ ] Opção C: GitHub Pages
```
1. Copie app-ads.txt para raiz do repositório
2. git add app-ads.txt
3. git commit -m "Add app-ads.txt"
4. git push
5. Aguarde 2-5 minutos
```

#### [ ] Opção D: WordPress Admin
```
1. Use plugin: File Manager ou WP File Manager
2. Vá para: public_html/
3. Upload app-ads.txt
```

---

### ETAPA 4: VERIFICAR SE FUNCIONOU (2 minutos)

**Teste 1: Navegador**
```
[ ] Abrir: https://SEUDOMINIO/app-ads.txt
[ ] Deve mostrar: google.com, pub-6846955506912398, DIRECT, f08c47fec0942fa0
```

**Teste 2: Validador Online**
```
[ ] Acesse: https://www.appadstest.com/
[ ] Digite seu domínio
[ ] Resultado: ✓ Valid
```

**Teste 3: curl (opcional)**
```bash
curl https://SEUDOMINIO/app-ads.txt
```

---

### ETAPA 5: RASTREAR NO ADMOB (1 minuto)

```
[ ] Acesse: https://apps.admob.com
[ ] Vá para: Apps → FinWise
[ ] Clique: Configurações do app
[ ] Procure: "app-ads.txt"
[ ] Clique: "Rastrear" ou "Verificar agora"
```

**Tempo de verificação:**
- Rápido: 5-10 minutos
- Normal: 1-2 horas
- Máximo: 24 horas

---

### ETAPA 6: AGUARDAR CONFIRMAÇÃO

```
[ ] Email recebido do AdMob (pode demorar)
[ ] Status no AdMob: "Verificado" ✓
```

---

## ⚠️ PROBLEMAS COMUNS

### ❌ Erro 404 - Arquivo não encontrado

**Causa:** Arquivo não está na raiz do site

**Solução:**
```
1. Verifique caminho: deve ser /app-ads.txt
2. NÃO pode estar em subpastas
3. Teste URL: https://seudominio.com/app-ads.txt
```

### ❌ Domínio não corresponde

**Causa:** Domínio no Play Console diferente do arquivo

**Solução:**
```
1. Confira domínio EXATO no Play Console
2. Teste com e sem www:
   - www.seusite.com/app-ads.txt
   - seusite.com/app-ads.txt
3. Publique em AMBOS se necessário
```

### ❌ Formato inválido

**Causa:** Espaços extras ou codificação errada

**Solução:**
```
1. Use o arquivo app-ads.txt que criei (já está correto)
2. NÃO edite, apenas copie
3. Salve como UTF-8
```

### ❌ Não verifica após 24h

**Causa:** Cache ou DNS

**Solução:**
```
1. Limpe cache do servidor
2. Aguarde propagação DNS (48h)
3. Tente rastrear novamente no AdMob
```

---

## 📊 STATUS ATUAL

### Seu Publisher ID
```
pub-6846955506912398
```

### Conteúdo do arquivo (NÃO ALTERE)
```
google.com, pub-6846955506912398, DIRECT, f08c47fec0942fa0
```

### Pacote do App
```
com.lorecout.finwise
```

---

## 🎯 RESUMO VISUAL

```
┌─────────────────────────────────────────────────┐
│  1. Descobrir domínio no Play Console          │
│     ↓                                           │
│  2. Publicar app-ads.txt na raiz do site       │
│     ↓                                           │
│  3. Testar: https://seudominio.com/app-ads.txt │
│     ↓                                           │
│  4. Rastrear no AdMob                          │
│     ↓                                           │
│  5. Aguardar verificação (5min - 24h)          │
│     ↓                                           │
│  6. ✅ VERIFICADO!                             │
└─────────────────────────────────────────────────┘
```

---

## 💡 DICA PRO

**Se NÃO tem site:**

1. Crie GitHub Pages GRÁTIS:
   ```
   - Crie conta: github.com
   - Novo repositório: seunome.github.io
   - Adicione: app-ads.txt
   - URL: https://seunome.github.io/app-ads.txt
   ```

2. Configure no Play Console:
   ```
   Site do desenvolvedor: https://seunome.github.io
   ```

---

## 📞 PRECISA DE AJUDA?

Consulte o arquivo completo:
```
CONFIGURAR_APP_ADS_TXT.md
```

Ou acesse:
- https://support.google.com/admob/answer/9363762
- https://www.appadstest.com/

---

**Criado:** 7 de Dezembro de 2024
**App:** FinWise
**Status:** Aguardando publicação do arquivo
**Próximo passo:** Publicar app-ads.txt no seu domínio!

