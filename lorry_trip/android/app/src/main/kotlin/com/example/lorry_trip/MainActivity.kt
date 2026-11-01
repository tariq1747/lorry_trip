package com.example.lorry_trip

import android.app.Activity
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall // <-- Add this explicitly
import io.flutter.plugin.common.MethodChannel 

class MainActivity : FlutterActivity() {
    
    private val CHANNEL = "com.example.lorry_trip/native"
    private var pendingResult: MethodChannel.Result? = null
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
            // By adding ": MethodCall" and ": MethodChannel.Result" above, 
            // the compiler now knows exactly what these variables are.
            
            if (call.method == "native_android_method") {
                pendingResult = result 
                val intent = Intent(this, Auth::class.java)
            } else {
                result.notImplemented()
            }
        }
    }


}