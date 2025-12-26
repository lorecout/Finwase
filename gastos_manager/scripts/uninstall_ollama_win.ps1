<#
Safe uninstall script for Ollama on Windows (PowerShell).
Prompts for confirmation and removes common Ollama install paths and user data.
#>

if ($env:OS -notlike '*Windows*' -and $env:OS -ne 'Windows_NT') {
    Write-Error "This script is intended for Windows PowerShell. Exiting."
    exit 1
}

$paths = @(
    "$env:LOCALAPPDATA\Programs\Ollama",
    "$env:ProgramFiles\Ollama",
    "$env:ProgramFiles(x86)\Ollama",
    "$env:LOCALAPPDATA\Ollama",
    "$env:USERPROFILE\.ollama",
    "$env:LOCALAPPDATA\ollama",
    "$env:LOCALAPPDATA\Ollama\ollama.exe"
)

Write-Output "The following paths will be removed (if they exist):"
foreach ($p in $paths) { Write-Output " - $p" }

$confirm = Read-Host "Type EXACTLY YES to continue and permanently delete these paths"
if ($confirm -ne 'YES') { Write-Output "Aborting. No changes made."; exit 0 }

foreach ($p in $paths) {
    if (Test-Path $p) {
        Write-Output "Removing $p"
        Remove-Item -LiteralPath $p -Recurse -Force -ErrorAction SilentlyContinue
    } else {
        Write-Output "Not found: $p"
    }
}

Write-Output "Uninstall complete. Restart your terminal and verify 'ollama' is no longer available." 
