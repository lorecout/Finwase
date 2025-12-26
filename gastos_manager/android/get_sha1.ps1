# Script para extrair SHA1 do keystore para Google Sign-In
param(
    [string]$KeystorePath = "app/upload-keystore.jks",
    [string]$Alias = "upload",
    [string]$Password = "upload123"
)

Write-Host "Extraindo SHA1 para Google Sign-In..." -ForegroundColor Cyan
Write-Host "Keystore: $KeystorePath" -ForegroundColor Yellow
Write-Host "Alias: $Alias" -ForegroundColor Yellow

try {
    # Extrair certificado e converter para SHA1 base64 (formato exigido pelo Google)
    $cert = & keytool -exportcert -keystore $KeystorePath -alias $Alias -storepass $Password -noprompt
    
    if ($LASTEXITCODE -ne 0) {
        throw "Erro ao extrair certificado"
    }
    
    # Converter para SHA1 e depois para base64
    $sha1Bytes = [System.Security.Cryptography.SHA1]::Create().ComputeHash($cert)
    $base64Sha1 = [System.Convert]::ToBase64String($sha1Bytes)
    
    Write-Host "`nSHA1 Certificate Hash (para Google Sign-In):" -ForegroundColor Green
    Write-Host $base64Sha1 -ForegroundColor White
    Write-Host "`nAdicione este hash no Firebase Console > Authentication > Sign-in method > Google"` -ForegroundColor Cyan
    
} catch {
    Write-Host "Erro: $_" -ForegroundColor Red
    Write-Host "Verifique se o keystore existe e as credenciais estão corretas." -ForegroundColor Yellow
}
