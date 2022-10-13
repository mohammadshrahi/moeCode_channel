package com.example.native_animated_splash_screen

import io.flutter.embedding.android.FlutterActivity
import com.example.native_animated_splash_screen.AppSplashScreen
import io.flutter.embedding.android.SplashScreen

class MainActivity: FlutterActivity() {

     override fun provideSplashScreen(): SplashScreen {
      return AppSplashScreen(this)
    }
}
