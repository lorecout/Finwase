<#
Script: install-ai-extensions.ps1
Descrição: Instala via CLI do VS Code um conjunto de extensões de IA úteis (Windows).
Uso: Abra o PowerShell e execute:
  ./install-ai-extensions.ps1

Observações:
- Requer o comando `code` (VS Code CLI) disponível no PATH. Se o comando não existir, abra o VS Code e execute 'Shell Command: Install 'code' command in PATH' (ou adicione manualmente o caminho para code.exe).
- O script instala as extensões listadas; algumas opções ficam comentadas para você escolher.
- IDs foram verificados no Marketplace em Dez/2025.
#>

# --- Checagem do CLI do VS Code
if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
    Write-Host "'code' CLI não encontrado. Abra o VS Code, pressione Ctrl+Shift+P e execute 'Shell Command: Install 'code' command in PATH' ou adicione manualmente o caminho para code.exe." -ForegroundColor Red
    exit 1
}

# Lista de extensões (IDs oficiais do Marketplace)
$extensions = @(
    "Codeium.codeium",                      # Codeium (oficial)
    "Continue.continue",                    # Continue (open-source)
    "TabNine.tabnine-vscode",               # Tabnine (legacy)
    "AmazonWebServices.amazon-q-vscode"     # Amazon Q (inclui CodeWhisperer)
    # Alternativas/optionais para AICode (descomente se quiser):
    # "aicodeos.aicodeos-devbox",           # AICode Devbox (exemplo)
    # "Kimseungtae.aicodehelper"            # AICodeHelper (exemplo)
    # "AmazonWebServices.aws-toolkit-vscode" # AWS Toolkit (opcional - inclui Amazon Q integração)
)

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

# --- Fim
