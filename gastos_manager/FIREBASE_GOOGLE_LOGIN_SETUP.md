# Guia de Login com Google (Android)

Este documento consolida a configuração necessária para o login com Google no app Android deste projeto.

- ApplicationId (package): `com.lorecout.finwise`
- Projeto Firebase: `studio-3273559794-ea66c` (project number: `471429994693`)
- Arquivo de configuração: `gastos_manager/android/app/google-services.json`

## 1) Certificados atuais (Debug)

Obtidos via `gradlew signingReport`:

- Keystore: `C:\\Users\\Lorena\\.android\\debug.keystore`
- SHA-1 (com dois-pontos): `AA:A2:2A:1A:83:EE:8A:73:46:72:F0:EF:12:9F:32:BB:C4:FD:A1:81`
- SHA-1 (sem dois-pontos): `AAA22A1A83EE8A734672F0EF129F32BBC4FDA181`
- SHA-256 (com dois-pontos): `94:D6:7C:C1:E6:BD:30:8E:E9:81:1C:49:AE:57:03:9E:7C:70:AE:80:CF:1B:C1:9C:88:42:9B:09:DB:40:E8:7A`
- SHA-256 (sem dois-pontos): `94D67CC1E6BD308EE9811C49AE57039E7C70AE80CF1BC19C88429B09DB40E87A`

> Importante: Esses valores PRECISAM estar cadastrados na app Android `com.lorecout.finwise` dentro do Firebase Console (Configurações do projeto > Certificados de assinatura), caso contrário o OAuth exibirá erro de “application is not registered to use OAuth2.0”.

## 2) Ajustes no Firebase Console

1. Acesse Firebase Console > Configurações do projeto > suas apps > Android > selecione `com.lorecout.finwise`.
2. Em “Certificados de assinatura”, adicione os certificados acima (SHA‑1 e SHA‑256).
3. Salve e baixe o novo `google-services.json` (ele refletirá os certificados anexados).
4. Substitua o arquivo local em `gastos_manager/android/app/google-services.json`.
5. Em Firebase > Authentication > Sign-in method, confirme que o provedor “Google” está ATIVADO.

Observação: O `google-services.json` atual contém entradas para `com.lorecout.finansapp` (legado) e `com.lorecout.finwise` (atual). O que importa é a entrada de `com.lorecout.finwise` possuir os certificados corretos.

## 3) Rebuild após atualização

Recomendações:

- Desinstale o app do dispositivo/emulador (evita cache de config antiga).
- Rodar um build limpo:

```powershell
cd "c:\\Users\\Lorena\\StudioProjects\\Finwase\\gastos_manager"
flutter clean
flutter pub get
flutter run --debug
```

## 4) Keystore de Release (produção)

Se o APK/AAB de produção for assinado com um keystore próprio, gere os certificados dessa keystore e cadastre-os também no Firebase (mesma tela de certificados), para que o login funcione em produção.

- Via Gradle (no módulo `android`):

```powershell
cd "c:\\Users\\Lorena\\StudioProjects\\Finwase\\gastos_manager\\android"
.\\gradlew.bat signingReport
```

- Alternativa via `keytool`:

```powershell
# Exemplo: ajuste os caminhos e o alias do seu keystore de release
"C:\\Program Files\\Android\\Android Studio\\jbr\\bin\\keytool.exe" -list -v -keystore "c:\\caminho\\para\\seu\\release.keystore" -alias seuAlias
```

Depois de cadastrar os certificados de release, baixe e substitua o `google-services.json` novamente.

## 5) Solução de problemas

- Erro: `This android application is not registered to use OAuth2.0...`
  - Causa: SHA‑1/SHA‑256 do keystore atual não cadastrados na app `com.lorecout.finwise` no Firebase/Google Cloud.
  - Ação: Cadastrar certificados, baixar novo `google-services.json`, limpar e rebuildar.

- Logs sobre `SignInActivity is missing a @GmsCoreVeId annotation`:
  - São mensagens internas do GMS e, em geral, não são a causa raiz do problema de OAuth.

- Verifique também:
  - Hora/data do dispositivo corretas.
  - Google Play Services atualizado no dispositivo.
  - Nenhum `applicationIdSuffix` inesperado no build de debug (no momento não há).

## 6) Client IDs úteis (do `google-services.json`)

Para `com.lorecout.finwise`:

- OAuth clients Android (exemplos do arquivo atual):
  - `471429994693-6k459n1blgnhi6vfl801ssous3ikv76f.apps.googleusercontent.com`
  - `471429994693-9rolq7q0s3p757kq7l664sb1ld9g2miq.apps.googleusercontent.com`
- Web client (client_type 3):
  - `471429994693-ro3pipgvsint8m1kelle53vhpvlun79s.apps.googleusercontent.com`

Se houver uso de `serverClientId` no código Flutter (override manual), certifique-se de usar o Web client correto acima.

---

Atualizado em: 2025-10-29
