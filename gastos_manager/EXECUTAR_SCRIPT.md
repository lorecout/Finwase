# 🚀 EXECUTAR CORREÇÕES AUTOMATICAMENTE

## ⚡ OPÇÃO 1: Script PowerShell (RECOMENDADO)

### Passo 1: Abrir PowerShell como Administrador

1. Pressione: `Win + X`
2. Clique: **Windows PowerShell (Administrador)**
3. Ou procure: "PowerShell" no menu iniciar

### Passo 2: Executar o Script

Cole este comando no PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File "C:\Users\Lorena\StudioProjects\Finwase\gastos_manager\CORRIGIR_AUTOMATICO.ps1"
```

### Resultado Esperado

```
================================
CORRIGINDO ERROS FLUTTER
================================

[1/4] Atualizando versão em pubspec.yaml...
✅ Versão atualizada: 1.0.4+5 → 1.0.5+6

[2/4] Adicionando getters em ad_service.dart...
✅ Getters adicionados a ad_service.dart

[3/4] Adicionando campo em ad_revenue_optimizer.dart...
✅ Campo _performanceData adicionado

[4/4] Ativando modo produção em ad_service.dart...
✅ Modo produção ativado (_isTestMode = false)

[FINAL] Limpando cache e restaurando dependências...
Executando: flutter clean
Executando: flutter pub get

================================
✅ CORREÇÕES CONCLUÍDAS!
================================

Próximo passo: Compilar o projeto

Execute um dos comandos abaixo:

  Para DEBUG:
  flutter build appbundle --debug

  Para RELEASE (recomendado para Play Store):
  flutter build appbundle --release
```

---

## ⚡ OPÇÃO 2: Terminal do VS Code

### Passo 1: Abrir VS Code
```bash
code C:\Users\Lorena\StudioProjects\Finwase\gastos_manager
```

### Passo 2: Abrir Terminal Integrado
- Pressione: `Ctrl + '` (apóstrofo)
- Ou: Menu → Terminal → New Terminal

### Passo 3: Executar Script
```powershell
powershell -ExecutionPolicy Bypass -File "CORRIGIR_AUTOMATICO.ps1"
```

---

## ⚡ OPÇÃO 3: Explorador de Arquivos (Mais Fácil)

### Passo 1: Navegar até a Pasta
```
C:\Users\Lorena\StudioProjects\Finwase\gastos_manager
```

### Passo 2: Encontrar Script
Procure por: `CORRIGIR_AUTOMATICO.ps1`

### Passo 3: Executar
1. Clique com botão direito: `CORRIGIR_AUTOMATICO.ps1`
2. Selecione: **Run with PowerShell**
3. Se pedir permissão, clique: **Sim** ou **Allow**

---

## ✅ CHECKLIST ANTES DE EXECUTAR

- [ ] Você está em Windows
- [ ] PowerShell está instalado (padrão do Windows)
- [ ] Flutter está instalado (`flutter --version` funciona)
- [ ] Você tem permissões de administrador
- [ ] Projeto Flutter está em: `C:\Users\Lorena\StudioProjects\Finwase\gastos_manager`

---

## 🔧 SE NÃO FUNCIONAR

### Problema: "Arquivo não encontrado"
**Solução:**
```powershell
# Verifique se o arquivo existe
dir "C:\Users\Lorena\StudioProjects\Finwase\gastos_manager\CORRIGIR_AUTOMATICO.ps1"
```

### Problema: "Execution Policy Denied"
**Solução:**
```powershell
# Permitir execução
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser

# Depois executar script novamente
powershell -ExecutionPolicy Bypass -File "C:\Users\Lorena\StudioProjects\Finwase\gastos_manager\CORRIGIR_AUTOMATICO.ps1"
```

### Problema: "Flutter não encontrado"
**Solução:**
```powershell
# Verificar se Flutter está no PATH
flutter --version

# Se não encontrar, adicionar ao PATH manualmente
# Ir em: Configurações → Variáveis de Ambiente
# Adicionar: C:\Users\Lorena\Documents\SDK\flutter\bin
```

---

## 📊 O QUE O SCRIPT FAZ

| Ação | Arquivo | Mudança |
|------|---------|---------|
| 1️⃣ Versão | `pubspec.yaml` | `1.0.4+5` → `1.0.5+6` |
| 2️⃣ Getters | `ad_service.dart` | Adiciona 3 getters |
| 3️⃣ Campo | `ad_revenue_optimizer.dart` | Adiciona `_performanceData` |
| 4️⃣ Produção | `ad_service.dart` | `_isTestMode = false` |
| 5️⃣ Limpeza | Global | `flutter clean` |
| 6️⃣ Dependências | Global | `flutter pub get` |

---

## 🎬 DEPOIS QUE O SCRIPT TERMINAR

### Compilar para Release
```bash
flutter build appbundle --release
```

### Ou Compilar para Debug (teste rápido)
```bash
flutter build appbundle --debug
```

---

## ⏱️ TEMPO ESTIMADO

- **Execução do script:** 2-3 minutos
- **Compilação release:** 10-15 minutos
- **Total:** 15-20 minutos

---

**🎯 Vamos lá! Execute o script!**


