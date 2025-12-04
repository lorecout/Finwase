Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Build APK (split-per-abi) com verificacao" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$projectPath = "c:\Users\Lorena\StudioProjects\Finwase\gastos_manager"
$apkDir = "$projectPath\build\app\outputs\flutter-apk"
$apks = @(
  "$apkDir\app-armeabi-v7a-release.apk",
  "$apkDir\app-arm64-v8a-release.apk",
  "$apkDir\app-x86_64-release.apk"
)

Push-Location $projectPath

Write-Host "`n[1/4] Verificando ambiente..." -ForegroundColor Yellow
if (!(Test-Path "pubspec.yaml")) { Write-Host "ERRO: pubspec.yaml nao encontrado!" -ForegroundColor Red; Pop-Location; exit 1 }

Write-Host "[2/4] Limpando APKs anteriores..." -ForegroundColor Yellow
$apks | ForEach-Object { if (Test-Path $_) { Remove-Item $_ -Force } }

Write-Host "[3/4] Iniciando build de APK (split-per-abi)..." -ForegroundColor Yellow
$proc = Start-Process -FilePath "flutter" -ArgumentList "build","apk","--release","--split-per-abi" -NoNewWindow -Wait -PassThru

Write-Host "`n[4/4] Verificando resultados..." -ForegroundColor Yellow
if ($proc.ExitCode -ne 0) {
  Write-Host "Aviso: Build retornou codigo: $($proc.ExitCode). Vou verificar se os APKs foram gerados mesmo assim..." -ForegroundColor Yellow
}

$found = @()
foreach ($apk in $apks) { if (Test-Path $apk) { $found += (Get-Item $apk) } }

if ($found.Count -eq 0) { Write-Host "ERRO: Nenhum APK encontrado em $apkDir" -ForegroundColor Red; Pop-Location; exit 1 }

Write-Host "`nAPKs gerados:" -ForegroundColor Green
$found | ForEach-Object { Write-Host ("  - {0} | {1} MB | {2}" -f $_.Name, ([math]::Round($_.Length/1MB,2)), $_.LastWriteTime) }

# Verificar a assinatura do APK principal (arm64)
$apkMain = "$apkDir\app-arm64-v8a-release.apk"
if (Test-Path $apkMain) {
  Write-Host "`nVerificando assinatura do APK (arm64)..." -ForegroundColor Cyan
  try {
    $sig = & keytool -printcert -jarfile $apkMain 2>&1 | Out-String
    $sig | Select-String -Pattern "SHA1|SHA-256|Owner" | ForEach-Object { $_.Line } | Write-Output
  } catch {
    Write-Host "Aviso: Nao foi possivel verificar a assinatura com keytool (opcional)." -ForegroundColor Yellow
  }
}

Write-Host "`nPronto. Voce pode instalar o APK arm64 no seu aparelho." -ForegroundColor Cyan
Pop-Location
