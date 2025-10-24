@echo off
echo ===========================================
echo    Finans - Keystore Generator Tool
echo ===========================================
echo.

echo AVISO IMPORTANTE:
echo ------------------
echo O keystore e uma assinatura digital CRUCIAL para seu app.
echo SEM ELE voce NAO PODE publicar no Google Play.
echo.
echo IMPORTANTE:
echo - Guarde este arquivo em local SEGURO
echo - Facca MULTIPLAS copias de backup
echo - NUNCA compartilhe com ninguem
echo - Documente as senhas em local seguro
echo.

echo Pressione qualquer tecla para continuar...
pause >nul

echo.
echo ===========================================
echo Gerando keystore de producao...
echo ===========================================
echo.

keytool -genkeypair -v -storetype PKCS12 -keystore android\app\release.keystore -alias alias_name -keyalg RSA -keysize 2048 -validity 10000

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ===========================================
    echo ✅ KEYSTORE GERADO COM SUCESSO!
    echo ===========================================
    echo.
    echo Arquivo criado: android\app\release.keystore
    echo.
    echo PROXIMOS PASSOS:
    echo 1. Copie o arquivo para locais seguros
    echo 2. Documente as senhas separadamente
    echo 3. Configure o Flutter (veja keystore_guide.md)
    echo 4. Teste o build: flutter build apk --release
    echo.
    echo NAO PERCA ESTE ARQUIVO!
    echo.
) else (
    echo.
    echo ===========================================
    echo ❌ ERRO ao gerar keystore!
    echo ===========================================
    echo.
    echo Possiveis causas:
    echo - Java JDK nao instalado
    echo - Comando keytool nao encontrado
    echo - Permissoes insuficientes
    echo.
    echo Verifique a instalacao do Java e tente novamente.
    echo.
)

echo Pressione qualquer tecla para sair...
pause >nul