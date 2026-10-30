package com.skylarkx.menuscan

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Register the factory with an ID
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "listTile", // This ID is used in Flutter
            NativeAdFactoryExample(this)
        )
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "videoCard",                 // ← matches factoryId in Dart
            NativeVideoAdFactory(this)
        )
    }
}
