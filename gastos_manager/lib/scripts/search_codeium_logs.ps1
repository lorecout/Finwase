$logs = Join-Path $env:APPDATA 'Code\logs'
Write-Host "Searching logs in: $logs"
if (-not (Test-Path $logs)) { Write-Host "Logs folder not found: $logs"; exit }
Get-ChildItem -Path $logs -Recurse -File -ErrorAction SilentlyContinue | Select-String -Pattern 'codeium|windsurf' -SimpleMatch | Select-Object Path,LineNumber,Line | Select-Object -First 200 | Format-Table -Wrap -AutoSize