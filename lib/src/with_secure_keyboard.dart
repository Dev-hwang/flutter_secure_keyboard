import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_secure_keyboard/src/secure_keyboard.dart';
import 'package:flutter_secure_keyboard/src/secure_keyboard_key.dart';
import 'package:flutter_secure_keyboard/src/secure_keyboard_type.dart';

/// A widget that implements a secure keyboard with controller.
class WithSecureKeyboard extends StatefulWidget {
  /// Controller to control the secure keyboard.
  final SecureKeyboardController controller;

  /// A child widget with a secure keyboard.
  final Widget child;

  /// The height of the keyboard.
  /// Default value is `280.0`.
  final double keyboardHeight;

  /// The radius of the keyboard key.
  /// Default value is `4.0`.
  final double keyRadius;

  /// The spacing between keyboard keys.
  /// Default value is `1.2`.
  final double keySpacing;

  /// The padding of the key input monitor.
  /// Default value is `const EdgeInsets.only(left: 10.0, right: 5.0)`.
  final EdgeInsetsGeometry keyInputMonitorPadding;

  /// The padding of the keyboard.
  /// Default value is `const EdgeInsets.symmetric(horizontal: 5.0)`.
  final EdgeInsetsGeometry keyboardPadding;

  /// The background color of the keyboard.
  /// Default value is `const Color(0xFF0A0A0A)`.
  final Color backgroundColor;

  /// The color of the string key(alphanumeric, numeric..).
  /// Default value is `const Color(0xFF313131)`.
  final Color stringKeyColor;

  /// The color of the action key(shift, backspace, clear..).
  /// Default value is `const Color(0xFF222222)`.
  final Color actionKeyColor;

  /// The color of the done key.
  /// Default value is `const Color(0xFF1C7CDC)`.
  final Color doneKeyColor;

  /// The key color when the shift action key is activated.
  /// If the value is null, `doneKeyColor` is used.
  final Color? activatedKeyColor;

  /// The text style of the text inside the keyboard key.
  /// Default value is `const TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.w500)`.
  final TextStyle keyTextStyle;

  /// The text style of the text inside the key input monitor.
  /// Default value is `const TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.w500)`.
  final TextStyle inputTextStyle;

  /// Constructs an instance of [WithSecureKeyboard].
  const WithSecureKeyboard({
    super.key,
    required this.controller,
    required this.child,
    this.keyboardHeight = kKeyboardDefaultHeight,
    this.keyRadius = kKeyboardKeyDefaultRadius,
    this.keySpacing = kKeyboardKeyDefaultSpacing,
    this.keyInputMonitorPadding = kKeyInputMonitorDefaultPadding,
    this.keyboardPadding = kKeyboardDefaultPadding,
    this.backgroundColor = kKeyboardDefaultBackgroundColor,
    this.stringKeyColor = kKeyboardDefaultStringKeyColor,
    this.actionKeyColor = kKeyboardDefaultActionKeyColor,
    this.doneKeyColor = kKeyboardDefaultDoneKeyColor,
    this.activatedKeyColor,
    this.keyTextStyle = kKeyboardDefaultKeyTextStyle,
    this.inputTextStyle = kKeyboardDefaultInputTextStyle,
  });

  @override
  _WithSecureKeyboardState createState() => _WithSecureKeyboardState();
}

class _WithSecureKeyboardState extends State<WithSecureKeyboard> {
  final _secureKeyboardStateController = StreamController<bool>.broadcast();
  final _keyBubbleStateController = StreamController<bool>.broadcast();

  bool _isVisibleSoftwareKeyboard = false;
  bool _shouldShowSecureKeyboard = false;

  String? _keyBubbleText;
  double? _keyBubbleWidth;
  double? _keyBubbleHeight;
  double? _keyBubbleDx;
  double? _keyBubbleDy;

  void _onSecureKeyboardStateChanged() {
    if (widget.controller.isShowing) {
      // Schedule the secure keyboard to open when the software keyboard is closed.
      if (_isVisibleSoftwareKeyboard) {
        _shouldShowSecureKeyboard = true;
      }

      // Hide software keyboard
      FocusScope.of(context).requestFocus(FocusNode());

      // If there is a reservation to open the secure keyboard,
      // do not open the secure keyboard immediately.
      if (!_shouldShowSecureKeyboard) {
        _setSecureKeyboardState(true);
      }
    } else {
      _setSecureKeyboardState(false);
    }
  }

  void _setSecureKeyboardState(bool state) async {
    if (state) {
      // Show secure keyboard
      _secureKeyboardStateController.sink.add(true);

      // Scroll to text field position after duration.
      final focusNode = widget.controller._focusNode;
      if (focusNode == null) return;
      if (focusNode.context == null) return;

      final duration = const Duration(milliseconds: 300);
      await Future.delayed(duration);
      Scrollable.ensureVisible(focusNode.context!, duration: duration);
    } else {
      // Hide secure keyboard
      _secureKeyboardStateController.sink.add(false);
    }
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onSecureKeyboardStateChanged);
    KeyboardVisibilityController().onChange.listen((visible) {
      _isVisibleSoftwareKeyboard = visible;

      // Prevents opening at the same time as the software keyboard.
      if (widget.controller.isShowing && visible) {
        widget.controller.hide();
      }

      // Open the secure keyboard when the software keyboard is closed
      // if there is a reservation to open the secure keyboard.
      if (_shouldShowSecureKeyboard && !visible) {
        _setSecureKeyboardState(true);
        _shouldShowSecureKeyboard = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: widget.child),
              _secureKeyboardBuilder(),
            ],
          ),
          _keyBubbleBuilder()
        ],
      ),
    );
  }

  Widget _secureKeyboardBuilder() {
    return StreamBuilder<bool>(
      stream: _secureKeyboardStateController.stream.asBroadcastStream(
        onCancel: (subscription) => subscription.cancel(),
      ),
      initialData: false,
      builder: (context, snapshot) {
        return (snapshot.data == true)
            ? _buildSecureKeyboard()
            : SizedBox.shrink();
      },
    );
  }

  Widget _buildSecureKeyboard() {
    final onKeyPressed = widget.controller._onKeyPressed;
    final onCharCodesChanged = widget.controller._onCharCodesChanged;
    final onDoneKeyPressed = widget.controller._onDoneKeyPressed;
    final onCloseKeyPressed = widget.controller._onCloseKeyPressed;

    return SecureKeyboard(
      type: widget.controller._type,
      initText: widget.controller._initText,
      hintText: widget.controller._hintText,
      inputTextLengthSymbol: widget.controller._inputTextLengthSymbol,
      doneKeyText: widget.controller._doneKeyText,
      clearKeyText: widget.controller._clearKeyText,
      obscuringCharacter: widget.controller._obscuringCharacter,
      maxLength: widget.controller._maxLength,
      alwaysCaps: widget.controller._alwaysCaps,
      obscureText: widget.controller._obscureText,
      shuffleNumericKey: widget.controller._shuffleNumericKey,
      hideKeyInputMonitor: widget.controller._hideKeyInputMonitor,
      height: widget.keyboardHeight,
      keyRadius: widget.keyRadius,
      keySpacing: widget.keySpacing,
      keyInputMonitorPadding: widget.keyInputMonitorPadding,
      keyboardPadding: widget.keyboardPadding,
      backgroundColor: widget.backgroundColor,
      stringKeyColor: widget.stringKeyColor,
      actionKeyColor: widget.actionKeyColor,
      doneKeyColor: widget.doneKeyColor,
      activatedKeyColor: widget.activatedKeyColor,
      keyTextStyle: widget.keyTextStyle,
      inputTextStyle: widget.inputTextStyle,
      onKeyPressed: onKeyPressed,
      onCharCodesChanged: onCharCodesChanged,
      onDoneKeyPressed: (charCodes) {
        widget.controller.hide();
        onDoneKeyPressed?.call(charCodes);
      },
      onCloseKeyPressed: () {
        widget.controller.hide();
        onCloseKeyPressed?.call();
      },
      onStringKeyTouchStart: (keyText, position, constraints) {
        if (widget.controller._disableKeyBubble) return;

        _keyBubbleText = keyText;
        _keyBubbleWidth = constraints.maxWidth * 1.5;
        _keyBubbleHeight = constraints.maxHeight * 1.5;
        _keyBubbleDx =
            position.dx - (constraints.maxWidth / 4) + widget.keySpacing;
        _keyBubbleDy = position.dy - _keyBubbleHeight! - widget.keySpacing;
        _keyBubbleStateController.sink.add(true);
      },
      onStringKeyTouchEnd: () {
        if (widget.controller._disableKeyBubble) return;

        _keyBubbleText = null;
        _keyBubbleWidth = null;
        _keyBubbleHeight = null;
        _keyBubbleDx = null;
        _keyBubbleDy = null;
        _keyBubbleStateController.sink.add(false);
      },
    );
  }

  Widget _keyBubbleBuilder() {
    return StreamBuilder<bool>(
      stream: _keyBubbleStateController.stream.asBroadcastStream(
        onCancel: (subscription) => subscription.cancel(),
      ),
      initialData: false,
      builder: (context, snapshot) {
        Widget keyBubble;
        if (snapshot.data == true) {
          keyBubble = Positioned(
            left: _keyBubbleDx,
            top: _keyBubbleDy,
            child: _buildKeyBubble(),
          );
        } else {
          keyBubble = SizedBox.shrink();
        }

        return keyBubble;
      },
    );
  }

  Widget _buildKeyBubble() {
    final keyFontSize = widget.keyTextStyle.fontSize! * 2;
    final keyTextStyle = widget.keyTextStyle.copyWith(fontSize: keyFontSize);

    return Material(
      elevation: 10.0,
      color: Colors.transparent,
      child: Container(
        width: _keyBubbleWidth,
        height: _keyBubbleHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.actionKeyColor,
          borderRadius: BorderRadius.circular(widget.keyRadius),
        ),
        child: Text(_keyBubbleText ?? '', style: keyTextStyle),
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onSecureKeyboardStateChanged);
    _secureKeyboardStateController.close();
    _keyBubbleStateController.close();
    super.dispose();
  }
}

/// Controller to check or control the state of the secure keyboard.
class SecureKeyboardController extends ChangeNotifier {
  bool _isShowing = false;

  /// Whether the secure keyboard is showing.
  bool get isShowing => _isShowing;

  late SecureKeyboardType _type;
  FocusNode? _focusNode;
  String? _initText;
  String? _hintText;
  String? _inputTextLengthSymbol;
  String? _doneKeyText;
  String? _clearKeyText;
  late String _obscuringCharacter;
  int? _maxLength;
  late bool _alwaysCaps;
  late bool _obscureText;
  late bool _shuffleNumericKey;
  late bool _hideKeyInputMonitor;
  late bool _disableKeyBubble;

  ValueChanged<SecureKeyboardKey>? _onKeyPressed;
  ValueChanged<List<int>>? _onCharCodesChanged;
  ValueChanged<List<int>>? _onDoneKeyPressed;
  VoidCallback? _onCloseKeyPressed;

  /// Show secure keyboard.
  void show({
    required SecureKeyboardType type,
    FocusNode? focusNode,
    String? initText,
    String? hintText,
    String? inputTextLengthSymbol,
    String? doneKeyText,
    String? clearKeyText,
    String obscuringCharacter = '•',
    int? maxLength,
    bool alwaysCaps = false,
    bool obscureText = true,
    bool shuffleNumericKey = true,
    bool hideKeyInputMonitor = false,
    bool disableKeyBubble = false,
    ValueChanged<SecureKeyboardKey>? onKeyPressed,
    ValueChanged<List<int>>? onCharCodesChanged,
    ValueChanged<List<int>>? onDoneKeyPressed,
    VoidCallback? onCloseKeyPressed,
  }) {
    assert(obscuringCharacter.isNotEmpty);

    _type = type;
    _focusNode = focusNode;
    _initText = initText;
    _hintText = hintText;
    _inputTextLengthSymbol = inputTextLengthSymbol;
    _doneKeyText = doneKeyText;
    _clearKeyText = clearKeyText;
    _obscuringCharacter = obscuringCharacter;
    _maxLength = maxLength;
    _alwaysCaps = alwaysCaps;
    _obscureText = obscureText;
    _shuffleNumericKey = shuffleNumericKey;
    _hideKeyInputMonitor = hideKeyInputMonitor;
    _disableKeyBubble = disableKeyBubble;
    _onKeyPressed = onKeyPressed;
    _onCharCodesChanged = onCharCodesChanged;
    _onDoneKeyPressed = onDoneKeyPressed;
    _onCloseKeyPressed = onCloseKeyPressed;
    _isShowing = true;
    notifyListeners();
  }

  /// Hide secure keyboard.
  void hide() {
    _focusNode = null;
    _initText = null;
    _hintText = null;
    _inputTextLengthSymbol = null;
    _doneKeyText = null;
    _clearKeyText = null;
    _maxLength = null;
    _onKeyPressed = null;
    _onCharCodesChanged = null;
    _onDoneKeyPressed = null;
    _onCloseKeyPressed = null;
    _isShowing = false;
    notifyListeners();
  }
}
