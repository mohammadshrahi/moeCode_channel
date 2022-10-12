package com.example.native_animated_splash_screen

import io.flutter.embedding.android.FlutterActivity
import com.example.native_animated_splash_screen.ShopSplashScreen
import io.flutter.embedding.android.SplashScreen

class MainActivity: FlutterActivity() {

     override fun provideSplashScreen(): SplashScreen {
        return ShopSplashScreen(this)
    }
}
