package com.snakesslither.snakes_slither

import android.app.ActivityManager
import android.app.Application
import android.os.SystemClock
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.FlutterInjector

/**
 * Starts the Flutter engine and Dart in Application.onCreate, before the
 * activity exists, so Home can draw its first frame as early as possible.
 */
class GameApp : Application() {
    override fun onCreate() {
        super.onCreate()
        val processStart = SystemClock.uptimeMillis()
        val processStartEpoch = System.currentTimeMillis()
        val loader = FlutterInjector.instance().flutterLoader()
        loader.startInitialization(this)
        loader.ensureInitializationComplete(this, null)
        val engine = FlutterEngine(this)
        val am = getSystemService(ACTIVITY_SERVICE) as ActivityManager
        val mem = ActivityManager.MemoryInfo().also { am.getMemoryInfo(it) }
        val tier = when {
            am.isLowRamDevice || mem.totalMem <= 3L * 1024 * 1024 * 1024 -> "low"
            mem.totalMem <= 6L * 1024 * 1024 * 1024 -> "mid"
            else -> "high"
        }
        val args = listOf(
            "tier=$tier",
            "processStartUptimeMs=$processStart",
            "processStartEpochMs=$processStartEpoch",
            "engineStartUptimeMs=${SystemClock.uptimeMillis()}",
        )
        engine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault(),
            args,
        )
        FlutterEngineCache.getInstance().put(ENGINE_ID, engine)
    }

    companion object {
        const val ENGINE_ID = "main"
    }
}
