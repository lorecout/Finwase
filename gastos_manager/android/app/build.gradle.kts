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
    ndkVersion = "27.0.12077973"

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
            isMinifyEnabled = false
            // Shrink unused resources desabilitado para evitar erro de strip
            isShrinkResources = false
            // ProGuard desabilitado temporariamente
            // proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")

            // Desabilitar completamente o strip de símbolos nativos
            packaging {
                jniLibs {
                    keepDebugSymbols += listOf("**/*.so")
                    useLegacyPackaging = true
                }
            }
        }
    }
    
    // Configuração para desabilitar stripping no bundle
    androidComponents {
        onVariants(selector().withBuildType("release")) { variant ->
            variant.packaging.jniLibs.keepDebugSymbols.add("**/*.so")
        }
    }
}

flutter {
    source = "../.."
}

configurations.all {
    // Excluir SafetyNet - deprecated e substituído por Play Integrity
    exclude(group = "com.google.android.gms", module = "play-services-safetynet")
    exclude(group = "com.google.firebase", module = "firebase-appcheck-safetynet")
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")

    // AndroidX Core para Edge-to-Edge (Android 15+)
    implementation("androidx.core:core-ktx:1.15.0")
    implementation("androidx.activity:activity-ktx:1.9.3")

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
