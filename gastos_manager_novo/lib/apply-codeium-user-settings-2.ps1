# Aplica configurações do Codeium e keybindings globalmente (User scope)
$settingsPath = "$env:APPDATA\Code\User\settings.json"
if (-not (Test-Path $settingsPath)) {
    New-Item -ItemType File -Path $settingsPath -Force | Out-Null
    Set-Content -Path $settingsPath -Value '{}' -Encoding UTF8
}
$raw = Get-Content $settingsPath -Raw -ErrorAction SilentlyContinue
try {
    $settings = $raw | ConvertFrom-Json -ErrorAction Stop
} catch {
    $settings = @{}
}
# Definições desejadas
$settings.'editor.inlineSuggest.enabled' = $true
$settings.'editor.acceptSuggestionOnEnter' = 'on'
$settings.'editor.suggestSelection' = 'first'
$settings.'editor.tabCompletion' = 'on'
$settings.'codeium.enableConfig' = @{ '*' = $true }
$settings.'codeium.enableInComments' = $true
$settings.'codeium.enableCodeLens' = $true
$settings.'codeium.useSecretStorage' = $true
# Salva
$settings | ConvertTo-Json -Depth 10 | Set-Content -Path $settingsPath -Encoding UTF8
Write-Host "User settings updated at $settingsPath"

# Keybindings
$keybindingsPath = "$env:APPDATA\Code\User\keybindings.json"
if (-not (Test-Path $keybindingsPath)) {
    New-Item -ItemType File -Path $keybindingsPath -Force | Out-Null
    Set-Content -Path $keybindingsPath -Value '[]' -Encoding UTF8
}
$rawKb = Get-Content $keybindingsPath -Raw -ErrorAction SilentlyContinue
try {
    $keybindings = $rawKb | ConvertFrom-Json -ErrorAction Stop
} catch {
    $keybindings = @()
}
$toAdd = @(
    @{ key = 'ctrl+alt+i'; command = 'editor.action.inlineSuggest.trigger'; when = 'editorTextFocus && !editorHasSelection && !inlineSuggestionsVisible' },
    @{ key = 'ctrl+shift+a'; command = 'codeium.openChatView'; when = 'isMac || isWindows' },
    @{ key = 'ctrl+alt+o'; command = 'codeium.openChatInPane'; when = 'editorTextFocus' },
    @{ key = 'alt+['; command = 'codeium.showPreviousCompletion'; when = 'editorTextFocus && !editorReadonly' },
    @{ key = 'alt+]'; command = 'codeium.showNextCompletion'; when = 'editorTextFocus && !editorReadonly' }
)
foreach ($item in $toAdd) {
    $exists = $false
    foreach ($kb in $keybindings) {
        if ($kb.command -eq $item.command -and $kb.key -eq $item.key) { $exists = $true; break }
    }
    if (-not $exists) { $keybindings += $item }
}
$keybindings | ConvertTo-Json -Depth 10 | Set-Content -Path $keybindingsPath -Encoding UTF8
Write-Host "User keybindings updated at $keybindingsPath"

# Feedback
Write-Host "Configurações e keybindings aplicados. Reinicie o VS Code se as mudanças não aparecerem imediatamente."