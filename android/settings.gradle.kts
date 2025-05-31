// settings.gradle.kts

pluginManagement {
    // Retrieve Flutter SDK path from local.properties
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val sdkPath = properties.getProperty("flutter.sdk")
        require(sdkPath != null) { "flutter.sdk not set in local.properties" }
        sdkPath
    }

    // Include Flutter Tools Gradle build for Flutter plugin integration
    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    // Define repositories to resolve plugins
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    // Flutter plugin loader (recommended for Flutter plugin management)
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"

    // Android application plugin (version 8.7.0)
    id("com.android.application") version "8.7.0" apply false

    // Kotlin Android plugin (version 1.8.22)
    id("org.jetbrains.kotlin.android") version "1.8.22" apply false
}

// Include the app module
include(":app")
