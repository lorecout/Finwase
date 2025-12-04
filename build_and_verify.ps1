$projectPath = "c:\Users\Lorena\StudioProjects\Finwase\gastos_manager"
$aabPath = "$projectPath\build\app\outputs\bundle\release\app-release.aab"

Push-Location $projectPath

Write-Host "Verificando ambiente..." -ForegroundColor Yellow
if (!(Test-Path "pubspec.yaml")) {
    Write-Host "ERRO: pubspec.yaml nao encontrado!" -ForegroundColor Red
    Pop-Location
    exit 1
}

Write-Host "Limpando build anterior..." -ForegroundColor Yellow
if (Test-Path $aabPath) {
    Remove-Item $aabPath -Force
}

Write-Host "Iniciando build..." -ForegroundColor Yellow
$process = Start-Process -FilePath "flutter" -ArgumentList "build","appbundle","--release" -NoNewWindow -Wait -PassThru

Write-Host "Verificando resultado..." -ForegroundColor Yellow

if ($process.ExitCode -eq 0) {
    if (Test-Path $aabPath) {
        $file = Get-Item $aabPath
        Write-Host "AAB GERADO COM SUCESSO!" -ForegroundColor Green
        Write-Host "Arquivo: $($file.Name)" -ForegroundColor White
        Write-Host "Tamanho: $([math]::Round($file.Length / 1MB, 2)) MB" -ForegroundColor White
        Write-Host "Local: $aabPath" -ForegroundColor White
    } else {
        Write-Host "Build OK mas AAB nao encontrado!" -ForegroundColor Red
    }
} else {
    Write-Host "Build falhou com codigo: $($process.ExitCode)" -ForegroundColor Red
}

Pop-Location
