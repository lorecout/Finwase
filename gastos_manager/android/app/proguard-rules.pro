# Keep Firebase and Google Mobile Ads classes used by reflection
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Flutter uses reflection to load plugins
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**

# Keep Google Mobile Ads mediation/adapters if any are added later
-keep class com.google.ads.** { *; }
-dontwarn com.google.ads.**

# Keep Kotlin metadata for data classes
-keepclassmembers class ** {
    @kotlin.Metadata *;
}

# Remove logging in release (optional)
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}
