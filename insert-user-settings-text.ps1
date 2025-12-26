$path = Join-Path $env:APPDATA 'Code\User\settings.json'
if (-not (Test-Path $path)) { Write-Host "settings.json não encontrado em $path"; exit 1 }
$raw = Get-Content -Raw -Path $path
if ($raw -match '"editor\.inlineSuggest\.enabled"') { Write-Host "Chaves já presentes, nada a fazer."; exit 0 }
$insert = @'
    "editor.inlineSuggest.enabled": true,
    "editor.acceptSuggestionOnEnter": "on",
    "editor.suggestSelection": "first",
    "editor.tabCompletion": "on",
'@
# Insert after first opening brace
$pattern = '^(\s*\{\s*)'
$new = [regex]::Replace($raw, $pattern, "`$1$insert", 1)
Set-Content -Path $path -Value $new -Encoding utf8
Write-Host "Inserido settings do Codeium em $path"