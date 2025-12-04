# Checklist - Upload AAB v1.0.3+4

## ✅ Antes do Upload

- [x] Versão incrementada: 1.0.2+3 → **1.0.3+4**
- [x] `flutter clean` executado
- [ ] AAB gerado com sucesso
- [ ] Assinatura verificada (SHA-1: 19:2E:C6:...)
- [ ] Tamanho do AAB verificado (~130-140 MB)

## 📦 Informações da Versão

- **versionName**: 1.0.3
- **versionCode**: 4
- **Package**: com.lorecout.finwise
- **Keystore**: release.keystore (upload key)
- **SHA-1**: 19:2E:C6:69:11:E8:BD:47:D9:AB:47:7B:5F:81:76:7C:40:C9:78:4F

## 🆕 Novidades nesta Versão

### Adicionado:
- Play Integrity API (app_device_integrity)
- IntegrityService para verificação de segurança
- Exemplos de integração

### Observação:
Esta versão **NÃO inclui integração ativa** do Play Integrity no fluxo do app.
O código está preparado mas não ativo. Pode ser ativado em v1.1.0.

## 🔍 Comandos de Verificação

```powershell
# 1. Verificar AAB existe
Test-Path "c:\Users\Lorena\StudioProjects\Finwase\gastos_manager\build\app\outputs\bundle\release\app-release.aab"

# 2. Verificar tamanho
(Get-Item "c:\Users\Lorena\StudioProjects\Finwase\gastos_manager\build\app\outputs\bundle\release\app-release.aab").Length / 1MB

# 3. Verificar assinatura
keytool -printcert -jarfile "c:\Users\Lorena\StudioProjects\Finwase\gastos_manager\build\app\outputs\bundle\release\app-release.aab"

# 4. Verificar versionCode
# Abrir AAB no Play Console e confirmar versionCode = 4
```

## 📤 Passos para Upload

1. **Acessar Play Console**
   - URL: https://play.google.com/console
   - App: Finwise (com.lorecout.finwise)

2. **Ir para Produção ou Teste Fechado**
   - Escolha: Produção (se pronto) ou Teste Fechado (Alpha)

3. **Criar Nova Versão**
   - Clique em "Criar nova versão"
   - Upload do AAB: `app-release.aab`

4. **Preencher Release Notes**
   ```
   Versão 1.0.3
   
   Melhorias de segurança:
   - Implementação de verificações de integridade do dispositivo
   - Preparação para Play Integrity API
   - Correções de estabilidade
   
   Novidades:
   - Melhorias gerais de desempenho
   - Atualizações de segurança
   ```

5. **Revisar e Enviar**
   - Verificar versionCode = 4
   - Verificar compatibilidade de dispositivos
   - Clicar em "Salvar" e depois "Revisar versão"
   - Clicar em "Iniciar implantação"

## ⚠️ Resolução de Erros Comuns

### "Não é possível lançar esta versão"
- ✅ RESOLVIDO: versionCode incrementado de 3 → 4

### "Esta versão não adiciona nem remove pacotes"
- ✅ RESOLVIDO: Nova versão com versionCode diferente

### "Chave de assinatura incorreta"
- Verificar SHA-1 do AAB com `keytool -printcert`
- Deve ser: 19:2E:C6:69:11:E8:BD:47:D9:AB:47:7B:5F:81:76:7C:40:C9:78:4F

## 📊 Após Upload

- [ ] Versão aparece no Play Console
- [ ] Status: "Processando" → "Disponível"
- [ ] Testar instalação (se Teste Fechado)
- [ ] Monitorar relatórios de falhas
- [ ] Verificar Play Integrity em produção (se integrado)

## 🎯 Próximos Passos (Opcionais)

### Para v1.1.0:
- [ ] Ativar Play Integrity no login
- [ ] Ativar Play Integrity em compras
- [ ] Configurar validação backend
- [ ] Testar em dispositivos físicos variados

---

**Data**: 02/12/2025
**Build**: v1.0.3+4
**Status**: Aguardando build completar
