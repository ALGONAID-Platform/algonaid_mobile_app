package com.example.algonaid_mobile_app

import android.app.PictureInPictureParams
import android.content.res.Configuration
import android.os.Build
import android.util.Rational
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.algonaid.pip"
    private var isPipAllowed = false
    private var methodChannel: MethodChannel? = null
    private var pipRect: android.graphics.Rect? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "setPipAllowed" -> {
                    isPipAllowed = call.argument<Boolean>("allowed") ?: false
                    updatePipParams()
                    result.success(null)
                }
                "setPipRect" -> {
                    val left = call.argument<Int>("left") ?: 0
                    val top = call.argument<Int>("top") ?: 0
                    val right = call.argument<Int>("right") ?: 0
                    val bottom = call.argument<Int>("bottom") ?: 0
                    pipRect = android.graphics.Rect(left, top, right, bottom)
                    updatePipParams()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun updatePipParams() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val aspectRatio = Rational(16, 9)
            val paramsBuilder = PictureInPictureParams.Builder()
                .setAspectRatio(aspectRatio)

            pipRect?.let {
                paramsBuilder.setSourceRectHint(it)
            }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                paramsBuilder.setAutoEnterEnabled(isPipAllowed)
            }
            
            try {
                setPictureInPictureParams(paramsBuilder.build())
            } catch (e: Exception) {
                // Ignore if called before activity is fully created
            }
        }
    }

    override fun onUserLeaveHint() {
        super.onUserLeaveHint()
        if (isPipAllowed && Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val aspectRatio = Rational(16, 9)
            val params = PictureInPictureParams.Builder()
                .setAspectRatio(aspectRatio)
                .build()
            enterPictureInPictureMode(params)
        }
    }

    override fun onPictureInPictureModeChanged(isInPictureInPictureMode: Boolean, newConfig: Configuration) {
        super.onPictureInPictureModeChanged(isInPictureInPictureMode, newConfig)
        methodChannel?.invokeMethod("onPipModeChanged", isInPictureInPictureMode)
    }
}
