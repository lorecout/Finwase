@echo off
echo Fazendo commits pequenos...

echo Commitando arquivos de configuracao...
git add *.json *.md *.bat *.ps1
git commit -m "chore: update configuration files"

echo Commitando mudancas no Android...
git add android/
git commit -m "fix: android build configuration"

echo Commitando mudancas no Flutter...
git add lib/ pubspec.*
git commit -m "feat: flutter app updates"

echo Commitando assets...
git add assets/
git commit -m "assets: update app resources"

echo Concluido!