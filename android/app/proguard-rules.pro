# Flutter ProGuard Rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Flutter Play Core & Deferred Components suppressions
-dontwarn com.google.android.play.core.**
-dontwarn io.flutter.embedding.engine.deferredcomponents.**

# Isar Database Core & Native JNI Rules
-dontwarn dev.isar.**
-keep class dev.isar.** { *; }
-keepclasseswithmembernames class * {
    native <methods>;
}

# Preserve application domain models
-keep class com.example.darzi_dairy.** { *; }
