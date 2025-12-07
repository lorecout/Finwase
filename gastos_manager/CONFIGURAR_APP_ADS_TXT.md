# 🔧 GUIA COMPLETO - CONFIGURAR APP-ADS.TXT

## ❌ PROBLEMA IDENTIFICADO

O AdMob não consegue verificar seu app porque:
- O arquivo app-ads.txt não existe no seu site de desenvolvedor
- OU o arquivo existe mas está com informações incorretas
- OU o domínio configurado está errado

---

## ✅ SOLUÇÃO PASSO-A-PASSO

### PASSO 1: Identificar Seu Domínio de Desenvolvedor

O domínio do desenvolvedor é o site que você configurou no Google Play Console.

**Onde encontrar:**
1. Acesse: https://play.google.com/console
2. Vá para: Configurações → Detalhes do app
3. Procure por: "Site do desenvolvedor" ou "Developer website"
4. Anote o domínio (exemplo: www.seusite.com)

**Formatos comuns:**
- www.seusite.com
- seusite.com
- seusite.com.br
- www.seusite.com.br

**⚠️ IMPORTANTE:** O domínio deve ser EXATAMENTE como está no Google Play!

---

### PASSO 2: Criar o Arquivo app-ads.txt

**Conteúdo do arquivo:**

```
google.com, pub-6846955506912398, DIRECT, f08c47fec0942fa0
```

**Como criar:**

1. Abra o Bloco de Notas (Notepad)
2. Cole a linha acima
3. Salve como: `app-ads.txt` (não app-ads.txt.txt!)
4. Tipo: "Todos os arquivos (*.*)"
5. Codificação: UTF-8

---

### PASSO 3: Publicar o Arquivo no Servidor

O arquivo precisa estar na RAIZ do seu domínio.

**Localização correta:**
```
https://seudominio.com/app-ads.txt
```

**❌ Localizações ERRADAS:**
```
https://seudominio.com/ads/app-ads.txt  ← NÃO
https://seudominio.com/public/app-ads.txt  ← NÃO
https://seudominio.com/wp-content/app-ads.txt  ← NÃO
```

**Como publicar (depende do seu servidor):**

#### Se usa cPanel:
1. Acesse cPanel do seu site
2. Vá para: Gerenciador de Arquivos
3. Navegue até: public_html/
4. Clique: Upload
5. Selecione: app-ads.txt
6. Clique: OK

#### Se usa WordPress:
1. Acesse via FTP (FileZilla)
2. Conecte ao servidor
3. Navegue até: public_html/ ou www/
4. Arraste app-ads.txt para essa pasta
5. Verifique as permissões (644)

#### Se usa GitHub Pages:
1. Coloque app-ads.txt na raiz do repositório
2. Commit e push
3. Aguarde deploy (1-5 minutos)

#### Se usa hospedagem própria:
1. Use FTP/SFTP
2. Conecte ao servidor
3. Vá para a pasta raiz do site
4. Faça upload do arquivo

---

### PASSO 4: Verificar se o Arquivo Está Acessível

**Teste 1: Navegador**
1. Abra navegador
2. Digite: `https://seudominio.com/app-ads.txt`
3. Você deve ver: `google.com, pub-6846955506912398, DIRECT, f08c47fec0942fa0`

**Teste 2: Ferramenta Online**
1. Acesse: https://www.appadstest.com/
2. Digite seu domínio
3. Clique: "Test"
4. Deve aparecer: ✓ Valid

**Teste 3: curl (opcional)**
```bash
curl https://seudominio.com/app-ads.txt
```

---

### PASSO 5: Rastrear no AdMob

**Depois de publicar o arquivo:**

1. Acesse: https://apps.admob.com
2. Vá para: Apps → Seu App (FinWise)
3. Clique: "Configurações do app"
4. Procure: "Verificação do app-ads.txt"
5. Clique: "Verificar agora" ou "Rastrear"

**Tempo de verificação:**
- Normalmente: 5-10 minutos
- Pode demorar: até 24 horas
- Se não funcionar: aguarde e tente novamente

---

## 🔍 PROBLEMAS COMUNS E SOLUÇÕES

### Problema 1: "Arquivo não encontrado (404)"

**Causa:**
- Arquivo não está na raiz
- Nome do arquivo errado
- Servidor não configurado corretamente

**Solução:**
1. Verifique o caminho: deve ser /app-ads.txt
2. Verifique o nome: app-ads.txt (minúsculas, com hífen)
3. Verifique permissões: 644 ou 755

### Problema 2: "Domínio não corresponde"

**Causa:**
- Domínio no Play Console diferente do arquivo

**Solução:**
1. Acesse Play Console
2. Verifique domínio EXATO
3. Teste com www e sem www:
   - www.seusite.com/app-ads.txt
   - seusite.com/app-ads.txt

### Problema 3: "Formato inválido"

**Causa:**
- Espaços extras
- Codificação errada
- Caracteres especiais

**Solução:**
1. Reescreva o arquivo do zero
2. Use só esta linha:
   `google.com, pub-6846955506912398, DIRECT, f08c47fec0942fa0`
3. Salve como UTF-8 sem BOM

### Problema 4: "Ainda não verificado após 24h"

**Causa:**
- Cache do servidor
- DNS não propagado
- Domínio não configurado no Play Console

**Solução:**
1. Limpe cache do servidor
2. Aguarde propagação DNS (48h)
3. Verifique domínio no Play Console

---

## 📊 CHECKLIST DE VERIFICAÇÃO

```
[ ] Domínio do Play Console anotado
[ ] Arquivo app-ads.txt criado com conteúdo correto
[ ] Arquivo salvo como UTF-8
[ ] Arquivo publicado na RAIZ do servidor
[ ] Arquivo acessível no navegador (https://dominio.com/app-ads.txt)
[ ] Teste online validou o arquivo
[ ] Rastreamento solicitado no AdMob
[ ] Aguardando verificação (5min - 24h)
```

---

## 🎯 EXEMPLO COMPLETO

### Se seu site for: www.finwise.app

**1. Conteúdo do arquivo:**
```
google.com, pub-6846955506912398, DIRECT, f08c47fec0942fa0
```

**2. Localização:**
```
Servidor: public_html/app-ads.txt
URL: https://www.finwise.app/app-ads.txt
```

**3. Teste:**
- Navegador: https://www.finwise.app/app-ads.txt
- Deve mostrar: google.com, pub-6846955506912398, DIRECT, f08c47fec0942fa0

**4. No AdMob:**
- Apps → FinWise → Configurações
- Clique: "Rastrear" ou "Verificar"
- Aguarde: 5-60 minutos

---

## ⚠️ CASOS ESPECIAIS

### Se NÃO tem site próprio:

**Opção 1: Criar site simples no GitHub Pages (GRÁTIS)**
1. Crie repositório: seunome.github.io
2. Crie arquivo: app-ads.txt
3. Configure no Play Console: seunome.github.io

**Opção 2: Usar domínio do Play Store**
- Alguns desenvolvedores usam: play.google.com
- Mas NÃO é recomendado pelo Google

**Opção 3: Criar site mínimo**
- Compre domínio (.com.br ~R$40/ano)
- Configure hospedagem gratuita
- Publique app-ads.txt

### Se o site redireciona:

**Problema:**
- seusite.com redireciona para www.seusite.com

**Solução:**
1. Publique app-ads.txt em AMBOS:
   - seusite.com/app-ads.txt
   - www.seusite.com/app-ads.txt
2. OU configure para NÃO redirecionar /app-ads.txt

---

## 📞 PRECISA DE AJUDA?

### Ferramentas úteis:

1. **Validador app-ads.txt:**
   - https://www.appadstest.com/

2. **Verificador de domínio:**
   - https://mxtoolbox.com/

3. **Teste HTTP:**
   - https://httpstatus.io/

### Documentação oficial:

- AdMob: https://support.google.com/admob/answer/9363762
- IAB Tech Lab: https://iabtechlab.com/ads-txt/

---

## 🚀 RESUMO RÁPIDO

1. ✅ Anote seu domínio do Play Console
2. ✅ Crie arquivo: `google.com, pub-6846955506912398, DIRECT, f08c47fec0942fa0`
3. ✅ Publique na raiz: `https://seudominio.com/app-ads.txt`
4. ✅ Teste no navegador
5. ✅ Rastreie no AdMob
6. ✅ Aguarde 5min - 24h

---

**Data:** 7 de Dezembro de 2024
**Publisher ID:** pub-6846955506912398
**Package:** com.lorecout.finwise
**Status:** Aguardando configuração do app-ads.txt

