# 📱 Play Console Upload Checklist - v1.0.4+5

## Status: ✅ PRONTO PARA UPLOAD

---

## 📦 Build Information

| Campo | Valor |
|-------|-------|
| **Versão** | 1.0.4 (versionCode 5) |
| **Arquivo** | app-release.aab |
| **Caminho** | `build/app/outputs/bundle/release/app-release.aab` |
| **Tamanho** | 54.72 MB |
| **SHA-1** | `4DED6D69699A0B9611B251A3DCE910FD1E3F2133` |
| **Data Build** | 04/12/2025 11:28 |
| **Keystore** | Upload Key (não debug) ✅ |

---

## ✅ Checklist Pré-Upload

### Segurança
- [x] AAB assinado com upload keystore
- [x] Não é debug keystore
- [x] Play Integrity API integrada
- [x] Firebase App Check configurado

### Monetização
- [x] Google AdMob IDs reais configurados
  - Banner: `ca-app-pub-6846955506912398/2600398827`
  - Interstitial: `ca-app-pub-6846955506912398/7605313496`
- [x] In-App Purchase IDs definidos (finwise_premium_*)
- [x] AdMob App ID: `ca-ap-2473407367`

### Compliance
- [x] Política de Privacidade online
  - URL: https://finwase-privice.vercel.app/privacy_policy.html
  - Alternativa: Google Docs (compartilhado)
- [x] Developer Info: Lorena Coutinho (lorecout)
- [x] Email: lorecout.dev@gmail.com
- [x] Package: com.lorecout.finwise

### Store Listing
- [x] Descrição da App
- [x] Screenshots
- [x] Feature Graphic (1024x500)
- [x] Ícone (512x512)

---

## 📋 Passos para Upload (Play Console)

### 1. Acessar Play Console
```
https://play.google.com/console/u/0/apps
```

### 2. Selecionar App
- Nome: FinWise - Controle Financeiro
- Package: com.lorecout.finwise

### 3. Navegar para "Releases"
- Clique em: **Releases** → **Production** (ou Test track)

### 4. Upload do AAB
- Clique em **Create Release**
- Selecionar arquivo: `app-release.aab` (54.72 MB)
- Upload automático de ABs
- Aguardar validação (normalmente 2-5 min)

### 5. Nota de Release (opcional)
```
Versão 1.0.4 - Melhorias de Segurança
- Play Integrity API integrada para proteger contra fraudes
- Google Mobile Ads com controle de anúncios melhorado
- Otimizações de performance
```

### 6. Preparar para Review
- Revisar permissões
- Verificar Política de Privacidade link
- Confirmar dados de contato
- Selecionar Países/Regiões

### 7. Submeter para Review
- Clique em **Review Release**
- Confirmar: **Start rollout to Production**

---

## ⏱️ Timeline Esperada

| Etapa | Tempo |
|-------|-------|
| Upload & Validação | ~5-10 min |
| Preparação | Imediato |
| Review automático | ~2-4 horas |
| Review humano | ~24-48 horas |
| **Aprovação Total** | **~3-7 dias** |
| Rollout gradual | 0-7 dias (configurável) |

---

## 🔧 Pós-Upload - Monitorar

### Imediatamente após Upload
```
✅ Verificar status da compilação
✅ Confirmar que nenhum erro foi retornado
✅ Revisar relatório de validação
```

### Durante Review (1-7 dias)
```
📊 Play Console → App releases → Production
📱 Baixar e testar APK gerado
🔍 Verificar se Play Integrity está funcionando
```

### Após Aprovação
```
✅ Configurar rollout gradual (se desejado)
📊 Monitorar crashes e ANR via Google Play Console
💰 Ativar monetização no AdMob (resolver "Requer revisão")
📈 Acompanhar downloads e avaliações
```

---

## ⚠️ Se Houver Rejeição

### Motivos Comuns (e Soluções)
1. **Política de Privacidade incompleta** 
   - ✅ Já atualizada com Lorena Coutinho, email, package

2. **Permissões não justificadas**
   - Revisar: **App Manifest** → Permissões usadas

3. **Conteúdo inadequado**
   - Revisar: **Content Rating Questionnaire**

4. **Google Play Integrity**
   - ✅ Já integrada via `firebase_app_check`

---

## 📞 Referências Rápidas

- **Play Console**: https://play.google.com/console
- **App Page**: https://play.google.com/store/apps/details?id=com.lorecout.finwise
- **AdMob Console**: https://admob.google.com
- **Firebase Console**: https://console.firebase.google.com

---

## ✨ Status Final

```
🎯 BUILD: ✅ Completo e pronto
🔐 SEGURANÇA: ✅ Play Integrity integrada
💰 MONETIZAÇÃO: ✅ AdMob configurado
📋 COMPLIANCE: ✅ Política de privacidade online
📦 UPLOAD: ⏳ Aguardando seu comando
```

**Próximo passo**: Ir para Play Console e fazer upload do arquivo!

---

**Criado em**: 04/12/2025 às 11:30
**Desenvolvedor**: Lorena Coutinho (lorecout)
**App**: FinWise - Controle Financeiro
