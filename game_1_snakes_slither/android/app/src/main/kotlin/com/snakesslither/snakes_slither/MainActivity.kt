package com.snakesslither.snakes_slither

import android.content.ComponentCallbacks2
import android.os.Bundle
import android.os.SystemClock
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var flutterUiShown = false
    private var channel: MethodChannel? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        val splash = installSplashScreen()
        val shownAt = SystemClock.uptimeMillis()
        // Hold the system splash until Flutter draws Home (safety cap 4 s).
        splash.setKeepOnScreenCondition {
            !flutterUiShown && SystemClock.uptimeMillis() - shownAt < SPLASH_CAP_MS
        }
        splash.setOnExitAnimationListener { view -> SplashExit.play(view) }
        super.onCreate(savedInstanceState)
    }

    override fun getCachedEngineId(): String? = GameApp.ENGINE_ID

    override fun shouldDestroyEngineWithHost(): Boolean = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "snakes_slither/launch").also {
            it.setMethodCallHandler { call, result ->
                when (call.method) {
                    "firstFrame" -> {
                        flutterUiShown = true
                        reportFullyDrawn()
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
        }
    }

    override fun onTrimMemory(level: Int) {
        super.onTrimMemory(level)
        if (level >= ComponentCallbacks2.TRIM_MEMORY_RUNNING_LOW) {
            channel?.invokeMethod("memoryPressure", level)
        }
    }

    companion object {
        private const val SPLASH_CAP_MS = 4000L
    }
}
