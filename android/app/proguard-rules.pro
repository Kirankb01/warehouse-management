# Flutter and plugin-related
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**

# Hive example
-keep class com.yourapp.models.** { *; }

# Keep annotations and serialization
-keepattributes *Annotation*
-keep class androidx.** { *; }

# Optional: Prevent obfuscating everything
-dontobfuscate
