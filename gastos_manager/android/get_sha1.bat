@echo off
echo Extraindo SHA1 Certificate Hash para Google Sign-In...
echo Keystore: app/upload-keystore.jks
echo Alias: upload
echo.

REM Tentar extrair SHA1 usando keytool
keytool -list -v -keystore "app/upload-keystore.jks" -alias "upload" -storepass "upload123" | find "SHA1"

if %ERRORLEVEL% neq 0 (
    echo Erro ao extrair SHA1. Tentando metodo alternativo...
    echo.
    
    REM Metodo alternativo: exportar certificado e converter
    keytool -exportcert -keystore "app/upload-keystore.jks" -alias "upload" -storepass "upload123" -file temp_cert.der
    
    if %ERRORLEVEL% equ 0 (
        echo Certificado exportado com sucesso.
        echo Convertendo para SHA1 base64...
        
        REM Usar certutil para converter (disponivel no Windows)
        certutil -encode temp_cert.der temp_cert_base64.txt
        
        echo Arquivo temp_cert_base64.txt criado com o certificado em base64.
    ) else (
        echo Erro ao exportar certificado.
    )
    
    if exist temp_cert.der del temp_cert.der
)

echo.
pause
