# 📸 Captura Rápida de Screenshots - Finans

## 🎯 Status Atual:
- ✅ **App executando** no emulador/dispositivo
- ✅ **Diretório screenshots** criado
- 📋 **Screenshots necessários:** 2-8 imagens (1080x1920px)

---

## 📱 Telas para Capturar:

### **1. Dashboard (Tela Inicial)**
- Nome do arquivo: `01_dashboard.png`
- Mostrar: Saldo total, transações recentes, botões principais

### **2. Adicionar Transação**
- Nome do arquivo: `02_add_transaction.png`
- Mostrar: Formulário de nova transação preenchido

### **3. Lista de Transações**
- Nome do arquivo: `03_transaction_list.png`
- Mostrar: Lista com várias transações, filtros aplicados

### **4. Relatórios/Gráficos**
- Nome do arquivo: `04_reports.png`
- Mostrar: Gráficos de gastos por categoria

### **5. Funcionalidades Premium**
- Nome do arquivo: `05_premium_features.png`
- Mostrar: Recursos premium disponíveis (se houver)

---

## 🛠️ Como Capturar:

### **Opção 1 - Android Studio/VS Code:**
1. Abra **Device Manager** ou **Device Explorer**
2. Clique no botão **📸 Screenshot**
3. Salve em: `C:\Users\lore-\OneDrive\Ambiente de Trabalho\NEWappdefinans\screenshots\`
4. Renomeie seguindo o padrão acima

### **Opção 2 - ADB (Linha de Comando):**
```bash
# Verificar dispositivo conectado
adb devices

# Capturar screenshot
adb exec-out screencap -p > screenshot.png

# Mover para pasta correta
move screenshot.png "C:\Users\lore-\OneDrive\Ambiente de Trabalho\NEWappdefinans\screenshots\01_dashboard.png"
```

### **Opção 3 - PowerShell:**
```powershell
# Capturar via PowerShell (se ADB estiver instalado)
adb exec-out screencap -p | Set-Content -Path "C:\Users\lore-\OneDrive\Ambiente de Trabalho\NEWappdefinans\screenshots\01_dashboard.png" -Encoding Byte
```

---

## 📋 Checklist de Captura:

- [ ] **01_dashboard.png** - Tela inicial com dados
- [ ] **02_add_transaction.png** - Adicionando transação
- [ ] **03_transaction_list.png** - Lista de transações
- [ ] **04_reports.png** - Relatórios/gráficos
- [ ] **05_premium_features.png** - Recursos premium

---

## 🎨 Requisitos Técnicos:

- **Resolução:** 1080x1920px (ou similar)
- **Formato:** PNG
- **Qualidade:** Alta resolução
- **Texto:** Legível e claro
- **Dispositivo:** Real (preferível) ou emulador

---

## 🚀 Próximo Passo:

Após capturar os screenshots, execute:
```bash
# Verificar screenshots capturados
dir screenshots\

# Prosseguir para upload
# Seguir upload_guide.md
```

**Capturou os screenshots? Me avise quando estiver pronto para o upload!** 📱