package com.pravera.flutter_secure_keyboard

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** FlutterSecureKeyboardPlugin */
class FlutterSecureKeyboardPlugin : FlutterPlugin, ActivityAware {
  private lateinit var methodCallHandler: MethodCallHandlerImpl

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    methodCallHandler = MethodCallHandlerImpl()
    methodCallHandler.init(binding.binaryMessenger)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    if (::methodCallHandler.isInitialized) {
      methodCallHandler.dispose()
    }
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
