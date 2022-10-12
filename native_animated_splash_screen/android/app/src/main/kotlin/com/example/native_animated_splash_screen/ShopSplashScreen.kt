package com.example.native_animated_splash_screen
import io.flutter.embedding.android.SplashScreen
import com.example.native_animated_splash_screen.R
import android.content.Context
import android.view.View
import android.view.LayoutInflater
import android.os.Bundle
import app.rive.runtime.kotlin.RiveAnimationView
import app.rive.runtime.kotlin.core.Loop
import app.rive.runtime.kotlin.core.Fit
import android.os.Handler
import app.rive.runtime.kotlin.RiveArtboardRenderer.Listener
import app.rive.runtime.kotlin.core.PlayableInstance
import io.flutter.embedding.android.FlutterActivity

class ShopSplashScreen(val activity: FlutterActivity) : SplashScreen {
    var animated: Boolean = false
    lateinit var riveView: RiveAnimationView
    override fun createSplashView(context: Context, savedInstanceState: Bundle?): View {

        val inflater: LayoutInflater =
            context.getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
        riveView = inflater.inflate(R.layout.splash, null) as RiveAnimationView
        riveView.fit = Fit.COVER

        riveView.viewTreeObserver.addOnGlobalLayoutListener {
            if (!animated) {
                animated = true
                Handler().postDelayed(
                    {
                        riveView.play(Loop.ONESHOT)
                    },
                    500,
                )
            }

        }

        return riveView;

    }

    override fun transitionToFlutter(r: Runnable) {
        val listener = object : Listener {
            override fun notifyPlay(animation: PlayableInstance) {

            }

            override fun notifyPause(animation: PlayableInstance) {

            }

            override fun notifyStop(animation: PlayableInstance) {
                activity.runOnUiThread {
                    r.run()

                }
            }

            override fun notifyLoop(animation: PlayableInstance) {


            }

            override fun notifyStateChanged(stateMachineName: String, stateName: String) {


            }
        }
        riveView.registerListener(listener)
        if (!riveView.isPlaying) {
            r.run()
        }
    }
}