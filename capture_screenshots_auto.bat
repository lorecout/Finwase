@echo off
echo ===========================================
echo    CAPTURA AUTOMATICA DE SCREENSHOTS
echo    Finans App - Google Play
echo ===========================================
echo.

cd "C:\Users\lore-\OneDrive\Ambiente de Trabalho\NEWappdefinans\screenshots"

echo Verificando conexao com dispositivo...
adb devices

echo.
echo ===========================================
echo INSTRUCOES PARA CAPTURA MANUAL:
echo ===========================================
echo.
echo 1. Navegue pelas telas do app no dispositivo
echo 2. Execute os comandos abaixo para cada tela:
echo.
echo    adb exec-out screencap -p > 01_dashboard.png
echo    adb exec-out screencap -p > 02_add_transaction.png
echo    adb exec-out screencap -p > 03_transaction_list.png
echo    adb exec-out screencap -p > 04_reports.png
echo    adb exec-out screencap -p > 05_premium_features.png
echo.
echo 3. Verifique os arquivos criados:
echo    dir *.png
echo.

echo ===========================================
echo TELAS NECESSARIAS:
echo ===========================================
echo [ ] 01_dashboard.png        - Tela inicial
echo [ ] 02_add_transaction.png  - Adicionar transacao
echo [ ] 03_transaction_list.png - Lista de transacoes
echo [ ] 04_reports.png          - Relatorios/graficos
echo [ ] 05_premium_features.png - Recursos premium
echo.

echo Pressione qualquer tecla quando terminar...
pause >nul

echo.
echo Verificando screenshots capturados...
dir *.png /b

echo.
echo ===========================================
echo PRONTO PARA UPLOAD!
echo ===========================================
echo.
echo Execute: upload_guide.md
echo.

pause