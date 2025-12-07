# 🌐 GUIA DE PUBLICAÇÃO APP-ADS.TXT POR PLATAFORMA

## 📋 Conteúdo do Arquivo (SEMPRE O MESMO)

```
google.com, pub-6846955506912398, DIRECT, f08c47fec0942fa0
```

**⚠️ Localização do arquivo criado:**
```
C:\Users\Lorena\StudioProjects\Finwase\gastos_manager\app-ads.txt
```

---

## 🔧 ESCOLHA SUA PLATAFORMA

### 1️⃣ GITHUB PAGES (GRÁTIS) ⭐ RECOMENDADO

**Quando usar:** Você não tem site ou quer solução gratuita

**Passo-a-passo:**

```bash
# 1. Criar repositório
1. Acesse: github.com
2. Clique: New repository
3. Nome: seunome.github.io (ex: lorena.github.io)
4. Tipo: Public
5. Clique: Create repository

# 2. Adicionar app-ads.txt
1. Clique: Add file → Upload files
2. Arraste: app-ads.txt
3. Commit changes

# 3. Aguardar deploy (2-5 minutos)

# 4. Testar
https://seunome.github.io/app-ads.txt
```

**Configurar no Play Console:**
```
Site do desenvolvedor: https://seunome.github.io
```

**Vantagens:**
- ✅ 100% gratuito
- ✅ Fácil de usar
- ✅ Deploy automático
- ✅ HTTPS incluído

---

### 2️⃣ CPANEL (HOSPEDAGEM COMPARTILHADA)

**Quando usar:** Você tem hospedagem cPanel (HostGator, GoDaddy, etc)

**Passo-a-passo:**

```
1. Login no cPanel
   └─ Acesse: seudominio.com/cpanel ou cpanel.seudominio.com

2. Gerenciador de Arquivos
   └─ Procure: "File Manager" ou "Gerenciador de Arquivos"
   └─ Clique para abrir

3. Navegar até public_html
   └─ Clique: public_html/
   └─ Esta é a raiz do seu site

4. Upload
   └─ Clique: "Upload" no menu superior
   └─ Selecione: app-ads.txt
   └─ Aguarde upload (1-2 segundos)

5. Verificar permissões
   └─ Clique direito em app-ads.txt
   └─ Permissions: 644
   └─ Salvar
```

**Testar:**
```
https://seudominio.com/app-ads.txt
```

---

### 3️⃣ FTP (FileZilla, WinSCP)

**Quando usar:** Você tem acesso FTP ao servidor

**Passo-a-passo com FileZilla:**

```
1. Abrir FileZilla
   └─ Download: https://filezilla-project.org/

2. Conectar ao servidor
   └─ Host: ftp.seudominio.com (ou IP do servidor)
   └─ Usuário: seu_usuario_ftp
   └─ Senha: sua_senha_ftp
   └─ Porta: 21 (padrão FTP)
   └─ Clique: Quickconnect

3. Navegar até a raiz
   └─ Lado direito (servidor): public_html/ ou www/ ou htdocs/
   └─ Esta pasta varia por servidor

4. Upload
   └─ Lado esquerdo: Navegue até a pasta do projeto
   └─ Encontre: app-ads.txt
   └─ Arraste para o lado direito (servidor)

5. Verificar
   └─ Confirme que app-ads.txt está na pasta raiz
   └─ Permissões: 644 (geralmente automático)
```

**Testar:**
```
https://seudominio.com/app-ads.txt
```

---

### 4️⃣ WORDPRESS

**Quando usar:** Seu site é WordPress

**Método 1: Plugin File Manager (RECOMENDADO)**

```
1. Instalar plugin
   └─ Painel WP → Plugins → Adicionar novo
   └─ Buscar: "File Manager"
   └─ Instalar: "File Manager" by wp-media
   └─ Ativar

2. Acessar File Manager
   └─ Menu lateral: File Manager
   └─ Abrir

3. Upload
   └─ Navegar até: wp-content/../ (voltar até a raiz)
   └─ Deve ver: wp-content, wp-admin, wp-includes
   └─ Upload → Selecionar app-ads.txt
   └─ OK

4. Verificar
   └─ app-ads.txt deve estar na mesma pasta que wp-config.php
```

**Método 2: FTP (se tem acesso)**
```
1. Use FileZilla (ver seção FTP acima)
2. Navegue até: public_html/
3. Upload app-ads.txt
```

**Testar:**
```
https://seusite.com/app-ads.txt
```

---

### 5️⃣ VERCEL / NETLIFY (JAMstack)

**Quando usar:** Deploy via Git (Next.js, Gatsby, etc)

**Vercel:**
```
1. Adicionar ao projeto
   └─ Copie app-ads.txt para pasta public/
   └─ OU raiz do projeto

2. Configurar vercel.json
   {
     "routes": [
       { "src": "/app-ads.txt", "dest": "/app-ads.txt" }
     ]
   }

3. Commit e push
   git add app-ads.txt
   git commit -m "Add app-ads.txt"
   git push

4. Deploy automático (1-2 min)
```

**Netlify:**
```
1. Adicionar ao projeto
   └─ Copie app-ads.txt para pasta public/

2. Configurar _redirects (se necessário)
   /app-ads.txt  /app-ads.txt  200

3. Commit e push
   git add app-ads.txt public/_redirects
   git commit -m "Add app-ads.txt"
   git push

4. Deploy automático (1-2 min)
```

**Testar:**
```
https://seusite.vercel.app/app-ads.txt
https://seusite.netlify.app/app-ads.txt
```

---

### 6️⃣ FIREBASE HOSTING

**Quando usar:** App hospedado no Firebase

```
1. Adicionar ao projeto
   └─ Copie app-ads.txt para pasta public/

2. Configurar firebase.json
   {
     "hosting": {
       "public": "public",
       "ignore": [
         "firebase.json",
         "**/.*",
         "**/node_modules/**"
       ],
       "headers": [
         {
           "source": "/app-ads.txt",
           "headers": [
             {
               "key": "Content-Type",
               "value": "text/plain"
             }
           ]
         }
       ]
     }
   }

3. Deploy
   firebase deploy --only hosting

4. Aguardar (1-2 min)
```

**Testar:**
```
https://seuapp.web.app/app-ads.txt
```

---

### 7️⃣ AMAZON S3 / AWS

**Quando usar:** Site estático no S3

```
1. Abrir S3 Console
   └─ console.aws.amazon.com/s3

2. Selecionar bucket
   └─ Clique no bucket do seu site

3. Upload
   └─ Upload → Add files
   └─ Selecione: app-ads.txt
   └─ Permissions: Public read
   └─ Upload

4. Configurar CORS (se necessário)
   [
     {
       "AllowedHeaders": ["*"],
       "AllowedMethods": ["GET"],
       "AllowedOrigins": ["*"],
       "ExposeHeaders": []
     }
   ]
```

**Testar:**
```
https://seudominio.com/app-ads.txt
https://seu-bucket.s3.amazonaws.com/app-ads.txt
```

---

## 🔍 VALIDAÇÃO UNIVERSAL

**Independente da plataforma, sempre teste:**

### Teste 1: Navegador
```
https://seudominio.com/app-ads.txt
```
**Deve mostrar:**
```
google.com, pub-6846955506912398, DIRECT, f08c47fec0942fa0
```

### Teste 2: curl (Terminal)
```bash
curl https://seudominio.com/app-ads.txt
```

### Teste 3: Validador Online
```
1. Acesse: https://www.appadstest.com/
2. Digite: seudominio.com
3. Clique: Test
4. Resultado: ✓ Valid
```

---

## ⚠️ PROBLEMAS COMUNS

### 404 - Arquivo não encontrado

**Soluções por plataforma:**

- **GitHub Pages:** Aguarde 2-5 min após commit
- **cPanel:** Verifique pasta public_html/
- **WordPress:** Arquivo deve estar na raiz, não em wp-content/
- **Vercel/Netlify:** Verifique pasta public/
- **Firebase:** Deploy novamente: `firebase deploy --only hosting`

### Domínio com WWW vs sem WWW

**Solução:** Publique em AMBOS se necessário
```
www.seusite.com/app-ads.txt  ← Com WWW
seusite.com/app-ads.txt      ← Sem WWW
```

---

## 📞 PLATAFORMA NÃO LISTADA?

**Regra geral:**

1. Arquivo deve estar na RAIZ do domínio
2. Caminho: https://dominio.com/app-ads.txt
3. Acessível via HTTP/HTTPS
4. Content-Type: text/plain
5. Permissões: Público (leitura)

**Exemplos de raiz:**
- cPanel: public_html/
- Plesk: httpdocs/
- Apache: /var/www/html/
- Nginx: /usr/share/nginx/html/

---

## ✅ CHECKLIST FINAL

```
[ ] Arquivo app-ads.txt criado
[ ] Plataforma escolhida
[ ] Upload realizado na raiz
[ ] Testado no navegador (200 OK)
[ ] Conteúdo correto visível
[ ] Validador online confirmou
[ ] Rastreado no AdMob
[ ] Aguardando verificação
```

---

**Data:** 7 de Dezembro de 2024
**Publisher ID:** pub-6846955506912398
**Arquivo:** app-ads.txt (já criado!)
**Próximo passo:** Escolha sua plataforma e publique!

