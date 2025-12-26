# 🚀 GUIA RÁPIDO - EMULADOR ANDROID NO VS CODE

## ✅ CONFIGURAÇÃO CONCLUÍDA

Suas configurações do VS Code foram atualizadas com:
- ✅ Caminho correto do Android SDK
- ✅ Caminho do emulador
- ✅ Caminho do ADB
- ✅ Scripts de teste criados

## 📱 EXTENSÃO RECOMENDADA

**Nome:** Android iOS Emulator
**ID:** DiemasMichiels.emulate

### Instalação:
1. **Ctrl+Shift+X** (Extensions)
2. Busque: `Android iOS Emulator`
3. Instale a extensão do **Diemas Michiels**

## 🎯 COMO TESTAR SEU APP

### Opção 1: Script Automático (RECOMENDADO)
```powershell
powershell -ExecutionPolicy Bypass -File "executar_teste_completo.ps1"
```

### Opção 2: Comandos Manuais
```bash
# 1. Listar emuladores
flutter emulators

# 2. Iniciar emulador
flutter emulators --launch Medium_Phone

# 3. Aguardar e verificar
flutter devices

# 4. Executar app
flutter run --debug
```

### Opção 3: Via Extensão VS Code
1. **Ctrl+Shift+P**
2. Digite: `Emulate`
3. Escolha `Medium Phone`
4. **F5** para executar app

## 🔧 COMANDOS ÚTEIS NO EMULADOR

Durante execução do app:
- **r** = Hot reload (recarregar)
- **R** = Hot restart (reiniciar)
- **q** = Sair
- **h** = Ajuda

## 🎯 TESTANDO ANÚNCIOS

Para testar os anúncios AdMob:
1. Execute o app no emulador
2. Navegue pelas telas
3. Verifique se banners aparecem
4. Teste anúncios intersticiais
5. Monitore logs no terminal

## 📊 VERIFICAÇÕES IMPORTANTES

✅ **Antes de publicar, teste:**
- [ ] App abre sem erros
- [ ] Todas as telas funcionam
- [ ] Banners AdMob aparecem
- [ ] Anúncios intersticiais funcionam
- [ ] Navegação está fluida
- [ ] Não há crashes

## 🚀 PRÓXIMOS PASSOS

Após testar com sucesso:
1. Execute o script de correção: `CORRIGIR_AUTOMATICO.ps1`
2. Compile AAB: `flutter build appbundle --release`
3. Publique no Play Store

## 💡 DICAS

- **Emulador lento?** Use dispositivo físico via USB
- **Anúncios não aparecem?** Verifique internet no emulador
- **App não instala?** Limpe cache: `flutter clean`

## 🆘 PROBLEMAS COMUNS

### Emulador não inicia:
```bash
flutter doctor
flutter emulators --create --name TestDevice
```

### App não conecta:
```bash
flutter devices
adb devices
```

### Erro de compilação:
```bash
flutter clean
flutter pub get
flutter run
```

---

**✅ TUDO CONFIGURADO!**
Execute o script e teste seu app agora! 🚀