# ✅ CHECKLIST - PUBLICAÇÃO FINWISE

## 📋 ANTES DE FAZER UPLOAD

Marque cada item conforme completa:

### Código & Build
- [x] Código sem erros de compilação
- [x] flutter clean executado
- [x] flutter pub get executado
- [x] flutter build appbundle --release executado com sucesso
- [x] AAB gerado em build/app/outputs/bundle/release/app-release.aab
- [x] Tamanho do AAB: 134.4 MB (razoável)

### Certificado & Assinatura
- [x] Keystore verificado: android/app/release.keystore
- [x] SHA1 correto: 19:2E:C6:69:11:E8:BD:47:D9:AB:47:7B:5F:81:76:7C:40:C9:78:4F
- [x] key.properties com senhas corretas
- [x] AAB assinado com chave correta

### Firebase
- [x] google-services.json presente: android/app/google-services.json
- [x] Certificate hash atualizado: 192ec66911e8bd47d9ab477b5f81767c40c9784f
- [x] Firebase Project ID: studio-3273559794-ea66c
- [x] Package name correto: com.lorecout.finwise

### Google Ads
- [x] App ID: ca-app-pub-6846955506912398~2473407367
- [x] Anúncios teste habilitados (ca-app-pub-3940256099942544/...)
- [x] Configuration implementada

### Versão
- [x] Versão definida: 1.0.5
- [x] Build number: 6
- [x] pubspec.yaml atualizado

---

## 🚀 NO PLAY CONSOLE

### Step 1: Acessar Console
- [ ] Ir para https://play.google.com/console
- [ ] Login com sua conta Google
- [ ] Selecionar "FinWise"

### Step 2: Preparar Upload
- [ ] Menu → Produção → Versões
- [ ] Clicar "Criar nova versão"
- [ ] Selecionar "Android App Bundle (.aab)"

### Step 3: Fazer Upload
- [ ] Clicar "Selecionar arquivo"
- [ ] Procurar por: build/app/outputs/bundle/release/app-release.aab
- [ ] Confirmar seleção
- [ ] Aguardar upload completar (2-3 minutos)
- [ ] Confirmar upload bem-sucedido

### Step 4: Informações da Versão
- [ ] Preencher notas de lançamento:
  ```
  Versão 1.0.5
  - Sistema de faturamento por anúncios
  - Dashboard de receita em tempo real
  - Otimizações de performance
  ```

### Step 5: Preço & Distribuição
- [ ] Selecionar "Gratuito"
- [ ] "Disponível em todos os países" (ou selecionar países)
- [ ] Status: Ativado

### Step 6: Classificação
- [ ] Preencher questões de conteúdo:
  - [ ] Violência: NÃO
  - [ ] Linguagem inadequada: NÃO
  - [ ] Conteúdo sexual: NÃO
  - [ ] Jogos de azar: NÃO
  - [ ] Anúncios: SIM (importante!)

### Step 7: Revisar & Publicar
- [ ] Clicar "Revisar versão"
- [ ] Ler todo o resumo cuidadosamente
- [ ] Confirmar informações estão corretas
- [ ] Clicar "Publicar versão"

---

## ⏳ APÓS PUBLICAÇÃO

### Monitoramento
- [ ] Notar "Enviada para análise" no status
- [ ] Aguardar email de aprovação
- [ ] Não fechar o navegador/console
- [ ] Checar email frequentemente

### Se Aprovado (Email)
- [ ] Ler email da aprovação
- [ ] Voltar ao Play Console
- [ ] Verificar status: "Pronta para publicar"
- [ ] Clicar "Publicar agora" (se automático não for)
- [ ] Aguardar propagação (2-24 horas)

### Se Rejeitado (Email)
- [ ] Ler email com a razão da rejeição
- [ ] Entender exatamente o que violou
- [ ] Corrigir o problema
- [ ] Aumentar versão (1.0.6+7)
- [ ] Gerar novo AAB
- [ ] Reenviar

---

## 💰 APÓS PUBLICAÇÃO

### Primeiros Passos
- [ ] Esperar 48-72 horas para dados aparecerem
- [ ] Acessar Dashboard de Receita
- [ ] Verificar primeiras impressões e cliques
- [ ] Notar CPM inicial

### Monitorar Regularmente
- [ ] Checar Play Console diariamente primeira semana
- [ ] Ver número de downloads
- [ ] Responder a comentários negativos
- [ ] Atualizar app conforme necessário

### Receber Pagamentos
- [ ] Verificar "Pagamentos" no Play Console
- [ ] Confirmar dados bancários cadastrados
- [ ] Receber pagamento (~21 dias após fim do mês)

---

## 🆘 TROUBLESHOOTING

### Se der "Certificado inválido"
- [ ] Confirmar SHA1 está correto
- [ ] Deletar versão anterior (se em rascunho)
- [ ] Fazer novo upload com o AAB correto

### Se der "Arquivo corrompido"
- [ ] Executar: flutter clean
- [ ] Executar: flutter pub get
- [ ] Executar: flutter build appbundle --release
- [ ] Fazer novo upload

### Se der "Versão duplicada"
- [ ] Aumentar versão no pubspec.yaml
- [ ] Gerar novo AAB
- [ ] Fazer novo upload com versão maior

### Se der "Rejeitado por política"
- [ ] Ler email com detalhes
- [ ] Corrigir problema
- [ ] Aumentar versão
- [ ] Gerar novo AAB
- [ ] Reenviar

---

## 📞 CONTATOS ÚTEIS

### Se Precisar de Ajuda
- Google Play Support: https://support.google.com/googleplay
- AdMob Help: https://support.google.com/admob
- Firebase Support: https://support.google.com/firebase
- Flutter Issues: https://github.com/flutter/flutter/issues

---

## 🎯 SEUS DADOS

```
App ID: com.lorecout.finwise
Versão: 1.0.5
Build: 6
Firebase Project: studio-3273559794-ea66c
Google Ads ID: ca-app-pub-6846955506912398~2473407367
Keystore: android/app/release.keystore
```

---

## 📌 NOTAS IMPORTANTES

1. **Nunca compartilhe** o arquivo keystore ou senhas
2. **Sempre use a mesma chave** para futuras atualizações
3. **Faça backup** do keystore em local seguro
4. **Aumente versão** a cada novo upload
5. **Leia emails** da Google com atenção
6. **Responda a comentários** para melhorar rating
7. **Atualizar app** regularmente aumenta visibilidade

---

## ✅ TUDO PRONTO!

- [x] AAB gerado
- [x] Certificado correto
- [x] Configurações validadas
- [x] Documentação criada
- [x] Próximo passo: Upload no Play Console

**Você consegue! 🚀**

---

**Criado em:** 07/12/2025
**Status:** ✅ PRONTO

