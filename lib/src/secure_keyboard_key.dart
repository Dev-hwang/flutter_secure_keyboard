import 'package:flutter_secure_keyboard/src/secure_keyboard_key_action.dart';
import 'package:flutter_secure_keyboard/src/secure_keyboard_key_type.dart';

/// A model representing secure keyboard keys.
class SecureKeyboardKey {
  /// The text of [SecureKeyboardKey].
  final String? text;

  /// The type of [SecureKeyboardKey].
  final SecureKeyboardKeyType type;

  /// The action of [SecureKeyboardKey].
  final SecureKeyboardKeyAction? action;

  /// Constructs an instance of [SecureKeyboardKey].
  const SecureKeyboardKey({
    this.text,
    required this.type,
    this.action
  });

  /// Generate [SecureKeyboardKey] model from [json].
  factory SecureKeyboardKey.fromJson(Map<String, dynamic> json) {
    return SecureKeyboardKey(
      text: json['text'],
      type: json['type'],
      action: json['action']
    );
  }

  /// Returns the data field of [SecureKeyboardKey] in JSON format.
  Map<String, dynamic> toJson({bool toUpperText = false}) {
    return {
      'text': toUpperText
          ? text?.toUpperCase()
          : text,
      'type': type,
      'action': action
    };
  }
}
