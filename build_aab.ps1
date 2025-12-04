$ErrorActionPreference = "Stop"

$projectPath = "c:\Users\Lorena\StudioProjects\Finwase\gastos_manager"

Write-Host "Navegando para: $projectPath" -ForegroundColor Cyan
Push-Location $projectPath

Write-Host "Verificando pubspec.yaml..." -ForegroundColor Yellow
if (!(Test-Path "pubspec.yaml")) {
    Write-Host "ERRO: pubspec.yaml não encontrado!" -ForegroundColor Red
    Pop-Location
    exit 1
}

Write-Host "Iniciando build do AAB de release..." -ForegroundColor Green
Write-Host "Aguarde... (isso pode levar 5-10 minutos)" -ForegroundColor Yellow
Write-Host ""

$process = Start-Process -FilePath "flutter" -ArgumentList "build","appbundle","--release" -NoNewWindow -Wait -PassThru

if ($process.ExitCode -eq 0) {
    Write-Host "`n✅ AAB gerado com sucesso!" -ForegroundColor Green
    $aabPath = Join-Path $projectPath "build\app\outputs\bundle\release\app-release.aab"
    Write-Host "Local: $aabPath" -ForegroundColor Cyan
    
    if (Test-Path $aabPath) {
        $size = (Get-Item $aabPath).Length / 1MB
        Write-Host ("Tamanho: {0:N2} MB" -f $size) -ForegroundColor Yellow
    }
} else {
    Write-Host "`n❌ Falha ao gerar o AAB!" -ForegroundColor Red
    Write-Host "Exit code: $($process.ExitCode)" -ForegroundColor Red
}

Pop-Location
