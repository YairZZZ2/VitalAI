plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")   // Firebase
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.mi_primer_app"
    compileSdk = 36

    defaultConfig {
        applicationId = "com.example.mi_primer_app"
        minSdk = flutter.minSdkVersion
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Firebase depende del google-services
}
