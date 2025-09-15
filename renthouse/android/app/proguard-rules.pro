# Drift database related classes
-keep class * extends com.google.common.util.concurrent.AbstractFuture { *; }
-keep class drift.** { *; }
-keep class moor.** { *; }

# SQLite database
-keep class org.sqlite.** { *; }
-keep class org.sqlite.database.** { *; }

# Flutter Secure Storage
-keep class androidx.security.crypto.** { *; }

# Crypto related classes
-keep class javax.crypto.** { *; }
-keep class java.security.** { *; }

# Keep all data classes and models
-keep class com.example.renthouse.models.** { *; }

# General Flutter rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Dart VM Service Protocol
-keep class org.dartlang.vm.service.** { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}