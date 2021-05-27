package com.pravera.flutter_secure_keyboard.errors

/** ErrorCodes */
enum class ErrorCodes {
	ACTIVITY_NOT_ATTACHED;

	fun message(): String {
		return when (this) {
			ACTIVITY_NOT_ATTACHED ->
				"Activity is not attached to FlutterEngine, so the functionality that uses the Activity is not available."
		}
	}
}
