plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android") // No explicit version here to avoid conflicts
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.shadow_clash"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973" // Use highest required NDK version for compatibility

    defaultConfig {
        applicationId = "com.example.shadow_clash"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        getByName("release") {
            // Using debug signing for simplicity - replace with release signing for production
            signingConfig = signingConfigs.getByName("debug")

            // Enable code shrinking and resource shrinking for release builds
            isMinifyEnabled = true
            isShrinkResources = true

            // Use ProGuard files; adjust as needed
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        getByName("debug") {
            // For debug builds, disable shrinking and minify to speed up builds
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }
}

flutter {
    source = "../.."
}
