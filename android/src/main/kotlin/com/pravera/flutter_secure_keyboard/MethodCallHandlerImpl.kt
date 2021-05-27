package com.pravera.flutter_secure_keyboard

import android.app.Activity
import android.view.WindowManager
import androidx.annotation.NonNull
import com.pravera.flutter_secure_keyboard.errors.ErrorCodes

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/** MethodCallHandlerImpl */
class MethodCallHandlerImpl: MethodChannel.MethodCallHandler {
	private lateinit var channel: MethodChannel
	
	private var activity: Activity? = null

	fun startListening(messenger: BinaryMessenger) {
		channel = MethodChannel(messenger, "flutter_secure_keyboard")
		channel.setMethodCallHandler(this)
	}

	fun stopListening() {
		if (::channel.isInitialized)
			channel.setMethodCallHandler(null)
	}

	fun setActivity(activity: Activity?) {
		this.activity = activity
	}

	private fun handleError(result: MethodChannel.Result?, errorCode: ErrorCodes) {
		result?.error(errorCode.toString(), null, null)
	}

	override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
		if (activity == null) {
			handleError(result, ErrorCodes.ACTIVITY_NOT_REGISTERED)
			return
		}

		when (call.method) {
			"secureModeOn" -> activity!!.window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
			"secureModeOff" -> activity!!.window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
			else -> result.notImplemented()
		}
	}
}
