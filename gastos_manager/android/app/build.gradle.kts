import java.util.Properties
import java.io.FileInputStream

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    FileInputStream(keystorePropertiesFile).use { keystoreProperties.load(it) }
}
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.lorecout.finwise"
    compileSdk = 36
    // Removido ndkVersion para usar versão padrão

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
    applicationId = "com.lorecout.finwise"
        minSdk = 24
        targetSdk = flutter.targetSdkVersion
    // Usar versão definida no pubspec.yaml via plugin do Flutter
    versionCode = flutter.versionCode
    versionName = flutter.versionName
        multiDexEnabled = true
        
        // Desabilitar strip de símbolos nativos para evitar erro
        ndk {
            // Não fazer strip automático - o AAB já está otimizado
        }
    }
    
    packaging {
        jniLibs {
            useLegacyPackaging = true
        }
    }

    signingConfigs {
        create("release") {
            val keyPropsFile = rootProject.file("key.properties")
            if (!keyPropsFile.exists()) {
                throw GradleException("key.properties file not found at: ${keyPropsFile.absolutePath}")
            }
            
            val keyProps = Properties()
            keyProps.load(FileInputStream(keyPropsFile))
            
            val storeFilePath = keyProps.getProperty("storeFile") 
                ?: throw GradleException("storeFile not found in key.properties")
            storeFile = file(storeFilePath)
            
            if (!storeFile!!.exists()) {
                throw GradleException("Keystore file not found at: ${storeFile!!.absolutePath}")
            }
            
            storePassword = keyProps.getProperty("storePassword") 
                ?: throw GradleException("storePassword not found in key.properties")
            keyAlias = keyProps.getProperty("keyAlias") 
                ?: throw GradleException("keyAlias not found in key.properties")
            keyPassword = keyProps.getProperty("keyPassword") 
                ?: throw GradleException("keyPassword not found in key.properties")
            
            println("✓ Release signing configured with keystore: ${storeFile!!.absolutePath}")
            println("✓ Using keyAlias: $keyAlias")
        }
    }
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            // Shrink unused resources to reduce APK size
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
            
            // Desabilitar strip de bibliotecas nativas (workaround para toolchain incompleto)
            packaging {
                jniLibs {
                    keepDebugSymbols += listOf("**/*.so")
                }
            }
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.2")

    // Google Play Services dependencies
    implementation(platform("com.google.firebase:firebase-bom:32.7.0"))
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-messaging")
    // Firebase App Check providers
    // Play Integrity for release builds
    implementation("com.google.firebase:firebase-appcheck-playintegrity")
    // Debug provider for debug builds
    debugImplementation("com.google.firebase:firebase-appcheck-debug")
    implementation("com.google.android.gms:play-services-auth:21.0.0")
    implementation("com.google.android.gms:play-services-base:18.3.0")
    implementation("androidx.multidex:multidex:2.0.1")
}
