# Regras para o Stripe SDK
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivity$g
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Args
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Error
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningEphemeralKeyProvider

# Evitar que classes e métodos nativos do Stripe sejam removidos
-keep class com.stripe.** { *; }
-keep class com.google.android.gms.wallet.** { *; }
-keepattributes *Annotation*

# Não ofuscar classes críticas do Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.embedding.** { *; }

# Evitar remover classes relacionadas à serialização JSON
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Evitar problemas de reflexão
-keepattributes RuntimeVisibleAnnotations
-keepattributes RuntimeVisibleParameterAnnotations

