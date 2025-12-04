Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Build APK universal (release) com verificacao" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$projectPath = "c:\Users\Lorena\StudioProjects\Finwase\gastos_manager"
$apk = "$projectPath\build\app\outputs\flutter-apk\app-release.apk"

Push-Location $projectPath

Write-Host "[1/3] Verificando ambiente..." -ForegroundColor Yellow
if (!(Test-Path "pubspec.yaml")) { Write-Host "ERRO: pubspec.yaml nao encontrado!" -ForegroundColor Red; Pop-Location; exit 1 }

Write-Host "[2/3] Limpando APK anterior..." -ForegroundColor Yellow
if (Test-Path $apk) { Remove-Item $apk -Force }

Write-Host "[3/3] Iniciando build universal (apk --release)..." -ForegroundColor Yellow
$proc = Start-Process -FilePath "flutter" -ArgumentList "build","apk","--release" -NoNewWindow -Wait -PassThru

Write-Host "Verificando resultado..." -ForegroundColor Yellow
if ($proc.ExitCode -ne 0) { Write-Host "Aviso: Build retornou codigo: $($proc.ExitCode). Vou checar se o APK foi gerado mesmo assim..." -ForegroundColor Yellow }

if (Test-Path $apk) {
  $file = Get-Item $apk
  Write-Host "APK universal gerado:" -ForegroundColor Green
  Write-Host ("  - {0} | {1} MB | {2}" -f $file.Name, ([math]::Round($file.Length/1MB,2)), $file.LastWriteTime)
  try {
    $sig = & keytool -printcert -jarfile $apk 2>&1 | Out-String
    $sig | Select-String -Pattern "SHA1|SHA-256|Owner" | ForEach-Object { $_.Line } | Write-Output
  } catch {}
} else {
  Write-Host "ERRO: APK universal nao encontrado em $apk" -ForegroundColor Red
}

Pop-Location
