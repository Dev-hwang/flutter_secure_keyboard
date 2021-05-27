package com.pravera.flutter_secure_keyboard

import android.app.Activity
import io.flutter.plugin.common.BinaryMessenger

/** FlutterSecureKeyboardPluginChannel */
interface FlutterSecureKeyboardPluginChannel {
	fun initChannel(messenger: BinaryMessenger)
	fun setActivity(activity: Activity?)
	fun disposeChannel()
}
