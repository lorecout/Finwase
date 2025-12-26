param(
  [string]$Model = 'gemma3',
  [string]$Prompt = "Teste rápido: confirme se você está pronto",
  [string]$OllamaPath = "C:\\Users\\Lorena\\AppData\\Local\\Programs\\Ollama\\ollama.exe"
)

if (-not (Test-Path $OllamaPath)) {
  Write-Error "ollama.exe não encontrado em $OllamaPath. Atualize o caminho no script."
  exit 1
}

Start-Process -NoNewWindow -FilePath $OllamaPath -ArgumentList @('run', $Model, $Prompt, '--keepalive', '30s') -Wait -PassThru