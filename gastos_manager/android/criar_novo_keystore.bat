@echo off
echo ========================================
echo Criando NOVO Upload Keystore
echo ========================================
echo.
echo IMPORTANTE: Isso so funciona se voce usa Google Play App Signing!
echo.
pause

cd /d "%~dp0"

keytool -genkeypair -v -storetype PKCS12 ^
  -keystore upload-keystore.jks ^
  -alias upload ^
  -keyalg RSA ^
  -keysize 2048 ^
  -validity 10000

echo.
echo ========================================
echo Keystore criado: upload-keystore.jks
echo ========================================
echo.
echo PROXIMOS PASSOS:
echo 1. Guarde esse keystore em local SEGURO
echo 2. Va no Google Play Console
echo 3. Va em: Configuracao - Integridade do App - Assinatura do App
echo 4. Clique em "Resetar chave de upload"
echo 5. Faca upload do certificado PEM
echo.
echo Para gerar o certificado PEM, execute:
echo keytool -export -rfc -keystore upload-keystore.jks -alias upload -file upload_certificate.pem
echo.
pause
