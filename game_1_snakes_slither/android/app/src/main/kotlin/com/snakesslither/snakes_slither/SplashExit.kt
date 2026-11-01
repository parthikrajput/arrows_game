package com.snakesslither.snakes_slither

import android.graphics.RenderEffect
import android.graphics.Shader
import android.os.Build
import androidx.core.splashscreen.SplashScreenViewProvider

/** Fades the system splash into Flutter frame 0 so the handoff is invisible. */
object SplashExit {
    private const val FADE_MS = 120L

    fun play(provider: SplashScreenViewProvider) {
        val view = provider.view
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // A light GPU blur on the mark while it fades (API 31+ only).
            provider.iconView.setRenderEffect(RenderEffect.createBlurEffect(12f, 12f, Shader.TileMode.CLAMP))
        }
        view.animate()
            .alpha(0f)
            .setDuration(FADE_MS)
            .withEndAction { provider.remove() }
            .start()
    }
}
