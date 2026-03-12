package com.example.pigeon_manual

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    ExampleHostApi.setUp(flutterEngine.dartExecutor.binaryMessenger, PlatformNameHandler())
  }
}

private class PlatformNameHandler : ExampleHostApi {
  override fun getPlatformName(): String = "Android"
}
