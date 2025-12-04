param(
  [switch]$bump,
  [switch]$patch
)

$root = "c:\Users\Lorena\StudioProjects\Finwase"
$pubspec = "$root\gastos_manager\pubspec.yaml"

Push-Location $root

if ($bump) {
  Write-Host "Incrementando versão no pubspec..." -ForegroundColor Yellow
  & "$root\bump_version.ps1" @PSBoundParameters
}

Write-Host "Iniciando build e verificação do AAB..." -ForegroundColor Yellow
& "$root\build_and_verify.ps1"

Pop-Location
