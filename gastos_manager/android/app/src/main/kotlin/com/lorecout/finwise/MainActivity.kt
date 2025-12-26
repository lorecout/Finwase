package com.lorecout.finwise

import android.os.Build
import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Habilitar Edge-to-Edge para Android 15+
        // Nota: As APIs descontinuadas são do Flutter SDK e serão corrigidas em futuras versões
        WindowCompat.setDecorFitsSystemWindows(window, false)
    }
}
