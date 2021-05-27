package com.pravera.flutter_secure_keyboard

import android.app.Activity
import android.view.WindowManager
import androidx.annotation.NonNull
import com.pravera.flutter_secure_keyboard.errors.ErrorCodes

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/** MethodCallHandlerImpl */
class MethodCallHandlerImpl: MethodChannel.MethodCallHandler, FlutterSecureKeyboardPluginChannel {
	private lateinit var channel: MethodChannel
	
	private var activity: Activity? = null

	override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
		if (activity == null) {
			val errorCode = ErrorCodes.ACTIVITY_NOT_ATTACHED
			result.error(errorCode.toString(), errorCode.message(), null)
			return
		}

		when (call.method) {
			"secureModeOn" -> activity!!.window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
			"secureModeOff" -> activity!!.window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
			else -> result.notImplemented()
		}
	}

	override fun initChannel(messenger: BinaryMessenger) {
		channel = MethodChannel(messenger, "flutter_secure_keyboard")
		channel.setMethodCallHandler(this)
	}

	override fun setActivity(activity: Activity?) {
		this.activity = activity
	}

	override fun disposeChannel() {
		if (::channel.isInitialized)
			channel.setMethodCallHandler(null)
	}
}
