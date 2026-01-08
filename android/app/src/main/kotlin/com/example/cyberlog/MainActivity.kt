package com.example.cyberlog

import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val channel = "cyberlog/device"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channel
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getDeviceModel" -> {
                    result.success(Build.MODEL)
                }
                "getAndroidVersion" -> {
                    result.success(Build.VERSION.RELEASE)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
