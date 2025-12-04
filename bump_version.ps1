param(
  [switch]$patch
)

$pubspec = "c:\Users\Lorena\StudioProjects\Finwase\gastos_manager\pubspec.yaml"
if (!(Test-Path $pubspec)) { Write-Host "ERRO: pubspec.yaml não encontrado" -ForegroundColor Red; exit 1 }

$content = Get-Content $pubspec
$versionLineIndex = $content.FindIndex({ $_ -match '^version:\s*' })
if ($versionLineIndex -lt 0) { Write-Host "ERRO: Linha de versão não encontrada" -ForegroundColor Red; exit 1 }

$line = $content[$versionLineIndex]
$version = ($line -split ':')[1].Trim()
# Formato esperado: x.y.z+n
$parts = $version -split '\+'
$semver = $parts[0]
$build = [int]$parts[1]
$semverParts = $semver -split '\.'
$major = [int]$semverParts[0]
$minor = [int]$semverParts[1]
$patchPart = [int]$semverParts[2]

if ($patch) { $patchPart += 1 }
$build += 1

$newSemver = "$major.$minor.$patchPart"
$newVersion = "$newSemver+$build"

$content[$versionLineIndex] = "version: $newVersion"
Set-Content -Path $pubspec -Value $content -Encoding UTF8

Write-Host "Versão atualizada para: $newVersion" -ForegroundColor Green
