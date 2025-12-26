$settingsPath = Join-Path $env:APPDATA 'Code\User\settings.json'
if (-not (Test-Path $settingsPath)) { New-Item -ItemType File -Path $settingsPath -Force | Out-Null; Set-Content -Path $settingsPath -Value "{}" -Encoding utf8 }
$raw = Get-Content -Raw -Path $settingsPath
if ($raw.Trim() -eq "") { $s = @{} } else { $s = $raw | ConvertFrom-Json }
$s."editor.inlineSuggest.enabled" = $true
$s."editor.acceptSuggestionOnEnter" = "on"
$s."editor.suggestSelection" = "first"
$s."editor.tabCompletion" = "on"
$s | ConvertTo-Json -Depth 10 | Set-Content -Path $settingsPath -Encoding utf8
Write-Host "User settings updated at: $settingsPath"

$kbPath = Join-Path $env:APPDATA 'Code\User\keybindings.json'
if (-not (Test-Path $kbPath)) { Set-Content -Path $kbPath -Value "[]" -Encoding utf8 }
$kbRaw = Get-Content -Raw -Path $kbPath
if ($kbRaw.Trim() -eq "") { $kb = @() } else { $kb = $kbRaw | ConvertFrom-Json }
$toAdd = @(
    @{ key='ctrl+alt+i'; command='editor.action.inlineSuggest.trigger'; when='editorTextFocus && !editorHasSelection && !inlineSuggestionsVisible' },
    @{ key='ctrl+shift+a'; command='codeium.openChatView'; when='isMac || isWindows' },
    @{ key='ctrl+alt+o'; command='codeium.openChatInPane'; when='editorTextFocus' },
    @{ key='alt['; command='codeium.showPreviousCompletion'; when='editorTextFocus && !editorReadonly' },
    @{ key='alt]'; command='codeium.showNextCompletion'; when='editorTextFocus && !editorReadonly' }
)
foreach ($entry in $toAdd) {
    $exists = $kb | Where-Object { $_.command -eq $entry.command }
    if (-not $exists) {
        $kb += $entry
    }
}
$kb | ConvertTo-Json -Depth 10 | Set-Content -Path $kbPath -Encoding utf8
Write-Host "User keybindings updated at: $kbPath"
