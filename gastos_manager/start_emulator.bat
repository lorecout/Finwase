@echo off
echo Iniciando emulador Android...

REM Tentar iniciar emulador Medium_Phone
echo Tentando iniciar Medium_Phone...
flutter emulators --launch Medium_Phone

REM Aguardar 30 segundos
echo Aguardando emulador inicializar...
timeout /t 30 /nobreak > nul

REM Verificar dispositivos
echo Verificando dispositivos conectados...
flutter devices

REM Tentar executar app
echo Tentando executar app...
flutter run

pause