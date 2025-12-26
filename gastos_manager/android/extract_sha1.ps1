# Simple script to extract SHA1 for Google Sign-In
$keystorePath = "app/upload-keystore.jks"
$alias = "upload"
$password = "upload123"

Write-Host "Extracting SHA1 certificate hash..." -ForegroundColor Cyan

# Create a temporary Java keystore reader
$tempScript = @"
import java.io.FileInputStream;
import java.security.KeyStore;
import java.security.cert.Certificate;
import java.security.MessageDigest;

public class SHA1Extractor {
    public static void main(String[] args) throws Exception {
        String keystorePath = args[0];
        String alias = args[1];
        String password = args[2];
        
        FileInputStream fis = new FileInputStream(keystorePath);
        KeyStore ks = KeyStore.getInstance("JKS");
        ks.load(fis, password.toCharArray());
        
        Certificate cert = ks.getCertificate(alias);
        MessageDigest md = MessageDigest.getInstance("SHA1");
        byte[] sha1 = md.digest(cert.getEncoded());
        
        // Convert to base64
        String base64Sha1 = java.util.Base64.getEncoder().encodeToString(sha1);
        System.out.println(base64Sha1);
        
        fis.close();
    }
}
"@

# Write Java file
$tempScript | Out-File -FilePath "SHA1Extractor.java" -Encoding UTF8

# Compile and run
try {
    & javac SHA1Extractor.java
    $sha1Hash = & java SHA1Extractor $keystorePath $alias $password
    
    Write-Host "SHA1 Certificate Hash:" -ForegroundColor Green
    Write-Host $sha1Hash -ForegroundColor White
    Write-Host "Add this hash to Firebase Console > Authentication > Sign-in method > Google" -ForegroundColor Cyan
} catch {
    Write-Host "Error: $_" -ForegroundColor Red
} finally {
    # Cleanup
    if (Test-Path "SHA1Extractor.java") { Remove-Item "SHA1Extractor.java" }
    if (Test-Path "SHA1Extractor.class") { Remove-Item "SHA1Extractor.class" }
}
