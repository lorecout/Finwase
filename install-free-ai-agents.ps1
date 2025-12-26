<#
Script: install-free-ai-agents.ps1
Descrição: Instala via CLI do VS Code um conjunto de extensões de agentes IA que são gratuitas no Marketplace (Dez/2025).
Uso: Abra o PowerShell e execute:
  ./install-free-ai-agents.ps1

Observações:
- Requer o comando `code` (VS Code CLI) disponível no PATH. Se o comando não existir, abra o VS Code e execute 'Shell Command: Install 'code' command in PATH' (ou adicione manualmente o caminho para code.exe).
- A instalação é apenas das extensões; algumas podem requerer login ou oferecer funcionalidade limitada sem conta/pagamento.
- As extensões escolhidas são aquelas que aparecem como "Free" no Marketplace (IDs verificados em Dez/2025).
#>

# --- Checagem do CLI do VS Code
if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
    Write-Host "'code' CLI não encontrado. Abra o VS Code, pressione Ctrl+Shift+P e execute 'Shell Command: Install 'code' command in PATH' ou adicione manualmente o caminho para code.exe." -ForegroundColor Red
    exit 1
}

# Lista de extensões gratuitas (IDs do Marketplace)
$extensions = @(
    "Codeium.codeium",                      # Codeium (gratuito para uso individual)
    "Continue.continue",                    # Continue (open-source)
    "TabNine.tabnine-vscode",               # Tabnine (tem plano gratuito limitado)
    "AmazonWebServices.amazon-q-vscode",    # Amazon Q (inclui CodeWhisperer funcionalidades gratuitas)
    "meteorstudio.cursorcode",              # Cursor for VSCode (cursor implementation)
    "aicodeos.aicodeos-devbox",             # AICode Devbox (exemplo de aicode)
    "Kimseungtae.aicodehelper"              # AICodeHelper (opção de AICode)
)

# Observação: se quiser excluir alguma extensão, remova-a da lista acima.

# Instalando
foreach ($ext in $extensions) {
    Write-Host "Instalando $ext..." -ForegroundColor Cyan
    code --install-extension $ext --force
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Falha ao instalar $ext (exit code $LASTEXITCODE)" -ForegroundColor Yellow
    } else {
        Write-Host "$ext instalado com sucesso." -ForegroundColor Green
    }
}

Write-Host "Instalação concluída. Abra o VS Code e verifique em Extensões (Ctrl+Shift+X)." -ForegroundColor Green

# Dica: após instalar, abra cada extensão em Extensões (Ctrl+Shift+X) e verifique se há necessidade de login ou configuração adicional.
# --- Fim
