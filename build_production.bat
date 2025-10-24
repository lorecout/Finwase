@echo off
echo ===========================================
echo    Finans - Production Build Tool
echo ===========================================
echo.

echo Iniciando build de producao...
echo.

echo Passo 1: Limpando builds anteriores...
flutter clean

echo.
echo Passo 2: Instalando dependencias...
flutter pub get

echo.
echo Passo 3: Executando build de producao...
flutter build apk --release

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ===========================================
    echo ✅ BUILD CONCLUÍDO COM SUCESSO!
    echo ===========================================
    echo.
    echo 📦 APK gerado em:
    echo    build\app\outputs\flutter-apk\app-release.apk
    echo.
    echo 📊 Verificando tamanho do arquivo...
    for %%A in ("build\app\outputs\flutter-apk\app-release.apk") do echo    Tamanho: %%~zA bytes
    echo.
    echo 🔍 Verificando assinatura...
    jarsigner -verify "build\app\outputs\flutter-apk\app-release.apk" >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo    ✅ APK assinado corretamente!
    ) else (
        echo    ❌ Problema na assinatura!
    )
    echo.
    echo 🧪 PROXIMOS PASSOS:
    echo    1. Teste o APK em dispositivo real
    echo    2. Facca backup do arquivo
    echo    3. Upload para Google Play Console
    echo.
) else (
    echo.
    echo ===========================================
    echo ❌ ERRO NO BUILD!
    echo ===========================================
    echo.
    echo Possiveis solucoes:
    echo - Verifique se o keystore esta configurado
    echo - Execute: flutter doctor
    echo - Verifique erros acima
    echo.
    echo Para debug detalhado, execute:
    echo   flutter build apk --release --verbose
    echo.
)

echo.
echo Pressione qualquer tecla para continuar...
pause >nul