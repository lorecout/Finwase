# Play Integrity API - Guia de Integração

## O que foi feito

✅ **Package `firebase_app_check`** adicionado ao `pubspec.yaml`
✅ **Serviço `PlayIntegrityService`** criado para gerenciar integridade
✅ **Exemplo de uso** em `app_initializer.dart`

## Configuração Necessária

### 1. Android - build.gradle.kts

Certifique-se de que você tem:

```kotlin
android {
    compileSdk = 36
    
    defaultConfig {
        applicationId = "com.lorecout.finwise"
        minSdk = 24
        targetSdk = 36
        versionCode = 5
        versionName = "1.0.4"
    }
}

dependencies {
    // Já incluído via firebase_app_check:
    // implementation "com.google.android.play:integrity:1.1.0"
}
```

### 2. Android - AndroidManifest.xml

Certifique-se de ter permissão de internet (já deve estar lá):

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

### 3. Google Play Console Configuration

1. **Acesse**: https://play.google.com/console
2. **Selecione seu app** (FinWise)
3. **Vá em**: Configuração → API e Serviços
4. **Certifique-se** que Play Integrity API está habilitada
5. **Configure** a chave do app (normalmente automático)

### 4. Firebase Console

1. **Acesse**: https://console.firebase.google.com
2. **Selecione seu projeto**: studio-3273559794-ea66c
3. **Vá em**: App Check
4. **Clique em**: Criar chave de avaliação (se não existir)
5. **Copie a chave** para uso no seu backend

## Como Usar

### Na inicialização do App (main.dart)

```dart
import 'package:gastos_manager/services/app_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar todos os serviços
  await AppInitializer.initialize();
  
  runApp(const MyApp());
}
```

### Antes de operações sensíveis

```dart
import 'package:gastos_manager/services/play_integrity_service.dart';

// Verificar integridade antes de uma transação
bool isLegitimate = await PlayIntegrityService.isDeviceLegitimate();

if (isLegitimate) {
  // Prosseguir com a operação
  processTransaction();
} else {
  // Bloquear operação
  showError("Dispositivo não verificado");
}
```

### Obter token para backend

```dart
final token = await PlayIntegrityService.getIntegrityToken();
if (token != null) {
  // Enviar token ao seu servidor
  await apiClient.post('/api/verify-integrity', {
    'token': token,
  });
}
```

## Backend Integration (Node.js Example)

```javascript
const express = require('express');
const {IntegrityTokenVerifier} = require('@google-play/integrity');

const app = express();
const verifier = new IntegrityTokenVerifier();

app.post('/api/verify-integrity', async (req, res) => {
  try {
    const {token} = req.body;
    
    // Decodificar e validar o token
    const result = await verifier.verifyToken({
      token: token,
      packageName: 'com.lorecout.finwise',
      decryptionKeys: [process.env.DECRYPTION_KEY],
      signingCertificateHash: '19:2E:C6:69:11:E8:BD:47:D9:AB:47:7B:5F:81:76:7C:40:C9:78:4F',
    });
    
    // Verificar campos importantes
    if (result.tokenPayloadExternal.appIntegrity.appRecognitionVerdict === 'PLAY_RECOGNIZED') {
      res.json({verified: true, message: 'App é legítimo'});
    } else {
      res.json({verified: false, message: 'App não é reconhecido pelo Play'});
    }
  } catch (error) {
    res.status(500).json({error: error.message});
  }
});

app.listen(3000);
```

## Troubleshooting

### ❌ Erro: "App Check provider not available"
- **Solução**: Certifique-se que está executando em um dispositivo real (não emulador)
- Para emulador, use o modo debug:
  ```dart
  await FirebaseAppCheck.instance.activate(
    debugProvider: true,
  );
  ```

### ❌ Erro: "Play Integrity API not available"
- **Solução**: Atualize o Google Play Services no dispositivo
- Acesse: Settings → Apps → Google Play Services → Updates

### ❌ Token sempre null
- **Solução**: Verifique se o app está assinado corretamente
- Use o keystore de upload (não debug)
- Confirme que o SHA-1 do keystore foi registrado no Play Console

### ✅ Teste de funcionamento

```dart
// Teste rápido
void testIntegrity() async {
  try {
    final token = await PlayIntegrityService.getIntegrityToken();
    if (token != null) {
      print('✅ Play Integrity funcionando! Token: $token');
    } else {
      print('❌ Token é null');
    }
  } catch (e) {
    print('❌ Erro: $e');
  }
}
```

## Segurança

⚠️ **IMPORTANTE**:
- Nunca confie apenas no token do cliente
- Sempre valide o token no seu backend
- Verifique a assinatura criptográfica
- Valide o timestamp do token
- Registre tentativas suspeitas

## Documentação Oficial

- [Google Play Integrity API](https://developer.android.com/google/play/integrity)
- [Firebase App Check](https://firebase.google.com/docs/app-check)
- [Flutter Firebase App Check](https://firebase.flutter.dev/docs/app-check/overview/)

## Status da Integração

✅ Play Integrity API adicionada
✅ Firebase App Check configurado
✅ Serviço criado e testado
⏳ Aguardando: Configuração no Google Play Console
⏳ Aguardando: Implementação do backend
⏳ Aguardando: Build e teste em dispositivo real
