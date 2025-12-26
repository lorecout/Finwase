# Fix Google Sign-In Certificate Hash Error

## Problem
The app is experiencing `firebase_auth/invalid-cert-hash` error when trying to sign in with Google for package `com.lorecout.finwise`.

## Solution Steps

### 1. Extract SHA1 Certificate Hash

Run the following command in the `android` directory:

```bash
cd android
keytool -exportcert -keystore app/upload-keystore.jks -alias upload -storepass upload123 | openssl sha1 -binary | openssl base64
```

### 2. Add SHA1 Hash to Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your FinWise project
3. Navigate to Authentication > Sign-in method
4. Click on Google provider
5. Add the SHA1 hash obtained from step 1
6. Save the configuration

### 3. Verify google-services.json

Ensure the `google-services.json` file in `android/app/` is configured for:
- Package name: `com.lorecout.finwise`
- Contains the correct SHA1 certificate hash
- Has Google Sign-In enabled

### 4. Test the Configuration

After adding the SHA1 hash:
1. Run `flutter clean`
2. Run `flutter pub get`
3. Build and test the app
4. Try Google Sign-In functionality

## Current App Configuration

- **Package Name**: `com.lorecout.finwise`
- **Keystore**: `android/app/upload-keystore.jks`
- **Alias**: `upload`
- **Store Password**: `upload123`
- **Key Password**: `upload123`

## Alternative: Generate Debug SHA1

For testing with debug builds, also add the debug SHA1:

```bash
cd android
keytool -exportcert -keystore %USERPROFILE%\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android | openssl sha1 -binary | openssl base64
```

## Verification

After completing these steps, the Google Sign-In should work without the `invalid-cert-hash` error.
