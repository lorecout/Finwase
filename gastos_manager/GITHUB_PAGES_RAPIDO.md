# 🚀 GUIA RÁPIDO: PUBLICAR APP-ADS.TXT NO GITHUB PAGES

## ⚡ 5 MINUTOS DE CONFIGURAÇÃO

### PASSO 1: Clonar Repositório
```bash
git clone https://github.com/lorecout/lorecout.github.io.git
cd lorecout.github.io
```

### PASSO 2: Adicionar Arquivo
Copie o arquivo `app-ads.txt` para a raiz do repositório:

```bash
# Windows
copy C:\Users\Lorena\StudioProjects\Finwase\gastos_manager\app-ads.txt .

# Mac/Linux
cp ~/gastos_manager/app-ads.txt .
```

**Conteúdo do arquivo:**
```
google.com, pub-6846955506912398, DIRECT, f08c47fec0942fa0
```

### PASSO 3: Enviar para GitHub
```bash
git add app-ads.txt
git commit -m "Adicionar app-ads.txt para AdMob"
git push origin main
```

### PASSO 4: Verificar
Acesse em seu navegador:
```
https://lorecout.github.io/app-ads.txt
```

Você deve ver o conteúdo do arquivo.

### PASSO 5: Configurar no Play Console
1. Acesse: https://play.google.com/console
2. App: FinWise
3. Configurações → Detalhes do app
4. Site do desenvolvedor: `https://lorecout.github.io`
5. Salvar

---

## ✅ PRONTO!

- ✓ Arquivo está no ar em: https://lorecout.github.io/app-ads.txt
- ✓ Domínio configurado no Play Console
- ✓ Agora vá para AdMob e clique em "Verificar se há atualizações"
- ✓ Aguarde 24-48 horas de verificação

---

## 🆘 Se Não Aparecer

### Verificar no Terminal
```bash
# Ver se arquivo está lá
curl https://lorecout.github.io/app-ads.txt

# Ver status HTTP
curl -I https://lorecout.github.io/app-ads.txt
```

### Dicas
1. Aguarde 5-10 minutos de propagação
2. Recarregar página: Ctrl+F5 (ou Cmd+Shift+R no Mac)
3. Verificar se arquivo está na RAIZ (não em pasta)
4. Verificar nome: `app-ads.txt` (sem espaços ou acentos)

---

**PRÓXIMO:** Publicar app no Play Store com modo de produção ativado!


