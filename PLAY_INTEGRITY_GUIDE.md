# Guia de Implementação: Play Integrity API

## ✅ O que foi implementado

### 1. Pacote instalado
- **`app_device_integrity: ^1.1.0`** - Plugin Flutter que suporta:
  - **Android**: Google Play Integrity API
  - **iOS**: Apple App Attest

### 2. Serviço criado
- **Arquivo**: `lib/services/integrity_service.dart`
- **Funcionalidades**:
  - `initialize()` - Inicializa o serviço
  - `verifyIntegrity({nonce, cloudProjectNumber})` - Gera token de integridade
  - `isDeviceTrusted()` - Verificação rápida de confiança
  - `validateTokenOnServer(token)` - Placeholder para validação backend

### 3. Exemplos de integração
- **Arquivo**: `lib/examples/integrity_integration_example.dart`
- **Inclui**:
  - Exemplo de verificação durante login
  - Exemplo de verificação antes de compra premium
  - Exemplo de verificação periódica
  - Widget de teste da API

---

## 📋 Como integrar no app

### Opção 1: Integração no Login (Recomendado)

**Arquivo**: `lib/screens/auth_page.dart`

**Onde adicionar**: No método `_signInWithGoogle()`, ANTES de `FirebaseAuth.instance.signInWithCredential(credential)`

```dart
// No topo do arquivo, adicionar import
import '../services/integrity_service.dart';

// No método _signInWithGoogle(), adicionar:
Future<void> _signInWithGoogle() async {
  setState(() {
    _isLoading = true;
    _errorMessage = null;
  });

  try {
    // ... código existente de GoogleSignIn ...
    
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      setState(() { _isLoading = false; });
      return;
    }

    // ========== ADICIONAR AQUI ==========
    // Verificar integridade do dispositivo
    final integrityService = IntegrityService();
    await integrityService.initialize();
    
    final integrityResult = await integrityService.verifyIntegrity();
    
    if (integrityResult['success'] != true) {
      // Dispositivo não passou na verificação
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Verificação de Segurança'),
            content: const Text(
              'Não foi possível verificar a segurança do dispositivo.\n\n'
              'Isso pode acontecer em dispositivos modificados ou '
              'apps instalados fora da Play Store.'
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      
      setState(() { _isLoading = false; });
      return; // Bloquear login
    }
    
    print('✅ Integridade verificada: ${integrityResult['token']}');
    // ====================================
    
    // ... continuar com o login normal ...
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    
    final UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(credential);
    
    // ... resto do código ...
  } catch (e) {
    setState(() {
      _errorMessage = 'Erro ao fazer login com Google: ${e.toString()}';
    });
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}
```

---

### Opção 2: Integração em Compras Premium

**Arquivo**: `lib/services/premium_service.dart`

**Onde adicionar**: Antes de processar qualquer compra in-app

```dart
// No topo do arquivo
import 'package:gastos_manager/services/integrity_service.dart';

// Adicionar campo na classe PremiumService
class PremiumService extends ChangeNotifier {
  final IntegrityService _integrityService = IntegrityService();
  
  // ... código existente ...
  
  // Modificar método de compra para incluir verificação
  Future<bool> purchasePremium(BuildContext context) async {
    try {
      // ========== ADICIONAR VERIFICAÇÃO ==========
      final integrityResult = await _integrityService.verifyIntegrity();
      
      if (integrityResult['success'] != true) {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Compra Não Autorizada'),
              content: const Text(
                'Por motivos de segurança, não é possível realizar compras '
                'neste dispositivo.'
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
        return false;
      }
      // ==========================================
      
      // Continuar com a compra normal...
      // ... código existente de in_app_purchase ...
      
    } catch (e) {
      print('Erro na compra: $e');
      return false;
    }
  }
}
```

---

### Opção 3: Verificação Periódica (Avançado)

**Arquivo**: `lib/main.dart`

**Onde adicionar**: Na inicialização do app, após Firebase

```dart
import 'package:gastos_manager/services/integrity_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // ========== ADICIONAR ==========
  // Verificação inicial de integridade
  final integrityService = IntegrityService();
  await integrityService.initialize();
  
  final isTrusted = await integrityService.isDeviceTrusted();
  if (!isTrusted) {
    print('⚠️ ALERTA: Dispositivo não confiável detectado');
    // Opcional: enviar telemetria ao Firebase Analytics
  }
  // ===============================
  
  runApp(const MyApp());
}
```

---

## 🧪 Como testar

### 1. Testar em dispositivo real Android

```powershell
cd c:\Users\Lorena\StudioProjects\Finwase\gastos_manager
flutter run --release
```

**Resultado esperado**:
- ✅ Token de integridade gerado com sucesso
- ✅ Login permitido
- ✅ Compras permitidas

### 2. Testar widget de exemplo

Adicione esta rota no seu app:

```dart
// Em lib/main.dart ou onde você define rotas
MaterialApp(
  routes: {
    '/integrity_test': (context) => const IntegrityTestScreen(),
    // ... outras rotas ...
  },
)
```

Navegue para `/integrity_test` e teste a API.

---

## ⚠️ Limitações e Observações

### 1. Emuladores
- **Play Integrity não funciona em emuladores**
- Em emuladores, a API retornará erro ou token inválido
- Teste SEMPRE em dispositivo físico

### 2. Debug vs Release
- Para funcionar corretamente, o app deve estar em **modo release**
- Debug builds podem ter comportamento diferente

### 3. APK vs AAB
- Play Integrity valida instalações da **Play Store**
- APKs instalados manualmente (sideload) falharão na verificação `PLAY_RECOGNIZED`

### 4. GCP Project Number
- Configurado automaticamente: `3273559794` (projeto Firebase `studio-3273559794-ea66c`)
- Modificável no método `verifyIntegrity(cloudProjectNumber: xxx)`

---

## 🔐 Validação no Backend (Obrigatório para produção)

O token gerado pelo app **DEVE ser validado no backend** para segurança completa.

### Configurar no Google Cloud Console

1. Acesse: https://console.cloud.google.com
2. Selecione projeto: **studio-3273559794-ea66c**
3. Ative a API: **Play Integrity API**
4. Crie credenciais de Service Account

### Implementar validação (Firebase Functions exemplo)

```javascript
const { google } = require('googleapis');
const functions = require('firebase-functions');

exports.validateIntegrityToken = functions.https.onCall(async (data, context) => {
  const token = data.token;
  const packageName = 'com.lorecout.finwise';
  
  try {
    const playintegrity = google.playintegrity('v1');
    const response = await playintegrity.v1.decodeIntegrityToken({
      packageName: packageName,
      requestBody: { integrityToken: token }
    });
    
    const payload = response.data.tokenPayloadExternal;
    
    return {
      success: true,
      appIntegrity: payload.appIntegrity.appRecognitionVerdict,
      deviceIntegrity: payload.deviceIntegrity.deviceRecognitionVerdict,
      accountDetails: payload.accountDetails
    };
  } catch (error) {
    return { success: false, error: error.message };
  }
});
```

### Chamar validação no Flutter

```dart
// No método validateTokenOnServer do IntegrityService
final response = await http.post(
  Uri.parse('https://us-central1-studio-3273559794-ea66c.cloudfunctions.net/validateIntegrityToken'),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({'token': token}),
);

if (response.statusCode == 200) {
  final result = jsonDecode(response.body);
  return result;
}
```

---

## 📊 Próximos Passos

### ✅ Concluído
- [x] Instalação do pacote `app_device_integrity`
- [x] Criação do `IntegrityService`
- [x] Exemplos de integração

### 🔄 Pendente
- [ ] Integrar verificação no login (`auth_page.dart`)
- [ ] Integrar verificação em compras (`premium_service.dart`)
- [ ] Configurar validação backend (Firebase Functions)
- [ ] Testar em dispositivo físico Android
- [ ] Criar lógica de fallback para dispositivos não suportados
- [ ] Implementar telemetria (Firebase Analytics) para falhas de integridade

### 📦 Build para Produção
Após integrar, gere novo AAB:

```powershell
cd c:\Users\Lorena\StudioProjects\Finwase
.\bump_version.ps1  # Incrementa para 1.0.3+4
.\build_and_verify.ps1  # Gera AAB assinado
```

---

## 📚 Documentação Oficial

- **Play Integrity API**: https://developer.android.com/google/play/integrity
- **App Attest (iOS)**: https://developer.apple.com/documentation/devicecheck
- **Pacote Flutter**: https://pub.dev/packages/app_device_integrity

---

## 🆘 Troubleshooting

### Erro: "Token is null or empty"
- Verifique se está em dispositivo físico (não emulador)
- Verifique se Play Integrity API está ativada no GCP
- Verifique se o GCP Project Number está correto

### Erro: "App not recognized"
- Certifique-se de que o app foi instalado pela Play Store
- APKs instalados manualmente não passam nesta verificação

### Erro: "Device not recognized"
- Dispositivo pode estar rooteado
- Bootloader pode estar desbloqueado
- SafetyNet/Play Integrity podem estar comprometidos

---

**Última atualização**: 01/12/2025
