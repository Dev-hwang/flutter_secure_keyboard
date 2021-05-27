package com.pravera.flutter_secure_keyboard

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** FlutterSecureKeyboardPlugin */
class FlutterSecureKeyboardPlugin: FlutterPlugin, ActivityAware {
  private lateinit var methodCallHandler: MethodCallHandlerImpl

  override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    methodCallHandler = MethodCallHandlerImpl()
    methodCallHandler.initChannel(binding.binaryMessenger)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    if (::methodCallHandler.isInitialized)
      methodCallHandler.disposeChannel()
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    methodCallHandler.setActivity(binding.activity)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity()
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivity() {
    methodCallHandler.setActivity(null)
  }
}
