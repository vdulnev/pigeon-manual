package com.example.pigeon_manual

import android.os.Handler
import android.os.Looper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    val messenger = flutterEngine.dartExecutor.binaryMessenger
    ExampleHostApi.setUp(messenger, PlatformNameHandler())
    OnCountStreamHandler.register(messenger, CounterStreamHandler())
  }
}

private class PlatformNameHandler : ExampleHostApi {
  override fun getPlatformName(): String = "Android"
}

private class CounterStreamHandler : OnCountStreamHandler() {
  private val handler = Handler(Looper.getMainLooper())
  private var count: Long = 0
  private var runnable: Runnable? = null

  override fun onListen(p0: Any?, sink: PigeonEventSink<Long>) {
    count = 0
    runnable = object : Runnable {
      override fun run() {
        sink.success(count++)
        handler.postDelayed(this, 1000)
      }
    }
    handler.post(runnable!!)
  }

  override fun onCancel(p0: Any?) {
    runnable?.let { handler.removeCallbacks(it) }
    runnable = null
  }
}
