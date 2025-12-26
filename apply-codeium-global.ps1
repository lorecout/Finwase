# Aplica configurações e keybindings do Codeium no nível de usuário (Windows)
$userSettingsPath = Join-Path $env:APPDATA 'Code\User\settings.json'
if (-not (Test-Path $userSettingsPath)) { '{}' | Out-File -FilePath $userSettingsPath -Encoding utf8 }
$raw = Get-Content $userSettingsPath -Raw
try { $settings = ConvertFrom-Json $raw -ErrorAction Stop } catch { $settings = @{} }

$settings['editor.inlineSuggest.enabled'] = $true
$settings['editor.acceptSuggestionOnEnter'] = 'on'
$settings['editor.suggestSelection'] = 'first'
$settings['editor.tabCompletion'] = 'on'

# Codeium settings
$settings['codeium.enableConfig'] = @{ '*' = $true }
$settings['codeium.enableInComments'] = $true
$settings['codeium.enableCodeLens'] = $true
$settings['codeium.useSecretStorage'] = $true

$settings | ConvertTo-Json -Depth 10 | Out-File -FilePath $userSettingsPath -Encoding utf8
Write-Host "User settings updated: $userSettingsPath"

# Keybindings
$kbPath = Join-Path $env:APPDATA 'Code\User\keybindings.json'
if (-not (Test-Path $kbPath)) { '[]' | Out-File -FilePath $kbPath -Encoding utf8 }
$kbRaw = Get-Content $kbPath -Raw
try { $kb = ConvertFrom-Json $kbRaw -ErrorAction Stop } catch { $kb = @() }

$toAdd = @()
$toAdd += @{ key='ctrl+alt+i'; command='editor.action.inlineSuggest.trigger'; when='editorTextFocus && !editorHasSelection && !inlineSuggestionsVisible' }
$toAdd += @{ key='ctrl+shift+a'; command='codeium.openChatView'; when='isMac || isWindows' }
$toAdd += @{ key='ctrl+alt+o'; command='codeium.openChatInPane'; when='editorTextFocus' }
$toAdd += @{ key='alt+['; command='codeium.showPreviousCompletion'; when='editorTextFocus && !editorReadonly' }
$toAdd += @{ key='alt+]'; command='codeium.showNextCompletion'; when='editorTextFocus && !editorReadonly' }

foreach ($entry in $toAdd) {
  $exists = $false
  foreach ($e in $kb) {
    if ($e.command -eq $entry.command -and $e.key -eq $entry.key) { $exists = $true; break }
  }
  if (-not $exists) { $kb += $entry }
}

$kb | ConvertTo-Json -Depth 10 | Out-File -FilePath $kbPath -Encoding utf8
Write-Host "User keybindings updated: $kbPath"

Write-Host "Concluído. Reinicie o VS Code se as mudanças não aparecerem imediatamente."