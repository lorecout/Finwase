param()

$projectRoot = "c:\Users\Lorena\StudioProjects\Finwase\gastos_manager"
$iconSource = "$projectRoot\assets\icon\novo-icone.png"
$outputDir = "$projectRoot\play-store-assets"

New-Item -ItemType Directory -Force -Path $outputDir | Out-Null

Write-Host "Gerando assets da Play Store..." -ForegroundColor Green

# 1. Icone 512x512
Write-Host "Gerando icone 512x512..." -ForegroundColor Yellow
& magick convert $iconSource -resize 512x512 -gravity center -extent 512x512 "$outputDir\icon-512x512.png"

# 2. Icone 192x192
Write-Host "Gerando icone 192x192..." -ForegroundColor Yellow
& magick convert $iconSource -resize 192x192 -gravity center -extent 192x192 "$outputDir\icon-192x192.png"

# 3. Feature graphic 1024x500
Write-Host "Gerando Feature Graphic 1024x500..." -ForegroundColor Yellow
& magick convert -size 1024x500 xc:"#1976D2" -gravity center -composite "$outputDir\feature-graphic-1024x500.png"

Write-Host ""
Write-Host "Assets gerados com sucesso!" -ForegroundColor Green
Write-Host "Diretorio: $outputDir" -ForegroundColor Cyan
