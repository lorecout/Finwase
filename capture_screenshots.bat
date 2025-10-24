@echo off
echo ===========================================
echo    Finans App - Screenshot Capture Tool
echo ===========================================
echo.

echo Este script ajuda a capturar screenshots do app
echo para submissao no Google Play.
echo.

echo PASSOS PARA CAPTURAR SCREENSHOTS:
echo.

echo 1. Execute o app no emulador ou dispositivo:
echo    flutter run --debug
echo.

echo 2. Navegue pelas telas principais:
echo    - Dashboard (tela inicial)
echo    - Adicao de transacao
echo    - Lista de transacoes
echo    - Relatorios
echo    - Funcionalidades premium
echo.

echo 3. Use uma das opcoes abaixo para capturar:
echo.

echo OPCAO A - Android Studio/VS Code:
echo - Abra o Device Manager
echo - Clique no botao de screenshot
echo - Salve na pasta 'screenshots'
echo.

echo OPCAO B - ADB (se dispositivo conectado):
echo - Conecte o dispositivo via USB
echo - Execute: adb devices (para verificar conexao)
echo - Execute: adb exec-out screencap -p > screenshot.png
echo.

echo 4. Renomeie os arquivos seguindo o padrao:
echo    01_dashboard.png
echo    02_add_transaction.png
echo    03_transaction_list.png
echo    04_reports.png
echo    05_premium_features.png
echo.

echo ===========================================
echo Dicas importantes:
echo - Use dispositivo real para melhor qualidade
echo - Resolucao recomendada: 1080x1920
echo - Formato: PNG
echo - Texto deve estar legivel
echo - Mostre funcionalidades premium
echo ===========================================

pause