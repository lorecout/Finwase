# ⚠️ Configuração Firebase Necessária

## Problema Atual

O build falhou porque falta o arquivo `google-services.json` do Firebase.

**Erros encontrados:**
1. ✅ **Git não encontrado** - RESOLVIDO (adicionado ao PATH)
2. ❌ **google-services.json ausente** - REQUER AÇÃO

---

## Como Obter o arquivo google-services.json

### Opção 1: Baixar do Firebase Console (Recomendado)

1. **Acesse o Firebase Console:**
   - Vá para: https://console.firebase.google.com/
   - Faça login com sua conta Google

2. **Selecione seu projeto:**
   - Clique no projeto `Finwise` (ou o nome do seu projeto)

3. **Acesse as configurações:**
   - Clique no ícone de engrenagem ⚙️ ao lado de "Visão geral do projeto"
   - Clique em "Configurações do projeto"

4. **Baixe o arquivo:**
   - Role até a seção "Seus apps"
   - Clique no app Android (ícone do Android)
   - Role até "Arquivo de configuração" ou "SDK config"
   - Clique em "Baixar google-services.json"

5. **Coloque o arquivo no local correto:**
   ```
   C:\Users\Lorena\StudioProjects\Finwase\gastos_manager\android\app\google-services.json
   ```

### Opção 2: Se Você Já Tem o Arquivo (Backup/Email/etc)

Copie o arquivo para:
```
C:\Users\Lorena\StudioProjects\Finwase\gastos_manager\android\app\google-services.json
```

---

## Estrutura Esperada do google-services.json

O arquivo deve ter esta estrutura:

```json
{
  "project_info": {
    "project_number": "123456789012",
    "project_id": "seu-projeto-id",
    "storage_bucket": "seu-projeto.appspot.com"
  },
  "client": [
    {
      "client_info": {
        "mobilesdk_app_id": "1:123456789012:android:abcdef123456",
        "android_client_info": {
          "package_name": "com.lorecout.finwise"
        }
      },
      "oauth_client": [...],
      "api_key": [...],
      "services": {...}
    }
  ],
  "configuration_version": "1"
}
```

**IMPORTANTE:** O `package_name` deve ser exatamente: `com.lorecout.finwise`

---

## Após Adicionar o Arquivo

1. **Reinicie o VS Code** (para garantir que o arquivo seja detectado)

2. **Execute o build novamente:**
   ```powershell
   cd C:\Users\Lorena\StudioProjects\Finwase\gastos_manager
   flutter clean
   flutter pub get
   flutter build apk --debug
   ```

   Ou use a task do VS Code:
   - `Ctrl+Shift+P` → "Tasks: Run Task" → "flutter run"

---

## Checklist de Configuração Atual

- ✅ Flutter SDK instalado: `C:\Users\Lorena\Documents\SDK\flutter`
- ✅ Flutter no PATH
- ✅ `local.properties` configurado com `flutter.sdk`
- ✅ Git adicionado ao PATH
- ✅ Dependências baixadas (`flutter pub get`)
- ❌ **google-services.json** - PENDENTE
- ⚠️ Android SDK cmdline-tools (opcional)

---

## Solução Temporária (Apenas para Testes SEM Firebase)

**ATENÇÃO:** Isso desabilitará completamente o Firebase no app!

Se você quiser apenas testar o build sem Firebase temporariamente:

1. Comente a linha no `build.gradle.kts`:
   ```kotlin
   // id("com.google.gms.google-services")  // COMENTAR TEMPORARIAMENTE
   ```

2. Remova as dependências do Firebase do `pubspec.yaml`

**NÃO RECOMENDADO** se você usa Firebase no app (Auth, Firestore, Storage, etc.).

---

## Próximos Passos

1. Baixe o `google-services.json` do Firebase Console
2. Coloque em `gastos_manager/android/app/google-services.json`
3. Execute `flutter clean && flutter pub get`
4. Tente o build novamente

Se precisar de ajuda com o Firebase Console, me avise!
