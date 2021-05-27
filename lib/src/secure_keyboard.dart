import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_keyboard/src/secure_keyboard_key_action.dart';
import 'package:flutter_secure_keyboard/src/secure_keyboard_key_generator.dart';
import 'package:flutter_secure_keyboard/src/secure_keyboard_key_type.dart';
import 'package:flutter_secure_keyboard/src/secure_keyboard_type.dart';
import 'package:flutter_secure_keyboard/src/secure_keyboard_key.dart';

/// The height of the key input monitor.
const double kKeyInputMonitorHeight = 50.0;

/// The default height of the keyboard.
const double kKeyboardDefaultHeight = 280.0;

/// The default radius of the keyboard key.
const double kKeyboardKeyDefaultRadius = 4.0;

/// The default spacing of the keyboard key.
const double kKeyboardKeyDefaultSpacing = 1.2;

/// The delay ​​of erasing input text when holding backspace.
const int kBackspaceEventDelay = 100;

/// The default background color of the keyboard.
const Color kKeyboardDefaultBackgroundColor = const Color(0xFF0A0A0A);

/// The default color of the string key.
const Color kKeyboardDefaultStringKeyColor = const Color(0xFF313131);

/// The default color of the action key.
const Color kKeyboardDefaultActionKeyColor = const Color(0xFF222222);

/// The default color of the done key.
const Color kKeyboardDefaultDoneKeyColor = const Color(0xFF1C7CDC);

/// The default text style of the text inside the keyboard key.
const TextStyle kKeyboardDefaultKeyTextStyle = const TextStyle(
    color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.w500);

/// The default text style of the text inside the key input monitor.
const TextStyle kKeyboardDefaultInputTextStyle = const TextStyle(
    color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.w500);

/// The default padding of the key input monitor.
const EdgeInsetsGeometry kKeyInputMonitorDefaultPadding =
const EdgeInsets.only(left: 10.0, right: 5.0);

/// The default padding of the keyboard.
const EdgeInsetsGeometry kKeyboardDefaultPadding =
const EdgeInsets.symmetric(horizontal: 5.0);

/// Callback function when the string key touch is started.
typedef StringKeyTouchStartCallback = void Function(
    String keyText, Offset position, BoxConstraints constraints);

/// Callback function when the string key touch is finished.
typedef StringKeyTouchEndCallback = void Function();

/// A widget that implements a secure keyboard.
class SecureKeyboard extends StatefulWidget {
  /// The type of the secure keyboard.
  final SecureKeyboardType type;

  /// Called when the key is pressed.
  final ValueChanged<SecureKeyboardKey>? onKeyPressed;

  /// Called when the character codes changed.
  final ValueChanged<List<int>>? onCharCodesChanged;

  /// Called when the done key is pressed.
  final ValueChanged<List<int>> onDoneKeyPressed;

  /// Called when the close key is pressed.
  final VoidCallback onCloseKeyPressed;

  /// Called when the string key touch is started.
  final StringKeyTouchStartCallback? onStringKeyTouchStart;

  /// Called when the string key touch is finished.
  final StringKeyTouchEndCallback? onStringKeyTouchEnd;

  /// The initial value of the input text.
  final String? initText;

  /// The hint text to display when the input text is empty.
  final String? hintText;

  /// The symbol to use when displaying the input text length.
  final String? inputTextLengthSymbol;

  /// The text of the done key.
  final String? doneKeyText;

  /// The text of the clear key.
  final String? clearKeyText;

  /// The secure character to hide the input text.
  /// Default value is `•`.
  final String obscuringCharacter;

  /// The maximum length of text that can be entered.
  final int? maxLength;

  /// Whether to always display uppercase characters.
  /// Default value is `false`.
  final bool alwaysCaps;

  /// Whether to hide input text as secure characters.
  /// Default value is `true`.
  final bool obscureText;

  /// Whether to shuffle the position of the numeric keys.
  /// Default value is `true`.
  final bool shuffleNumericKey;

  /// Whether to hide the key input monitor.
  /// Default value is `false`.
  final bool hideKeyInputMonitor;

  /// The height of the keyboard.
  /// Default value is `280.0`.
  final double height;

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

  /// Security Alert title, only works on iOS.
  final String? screenCaptureDetectedAlertTitle;

  /// Security Alert message, only works on iOS.
  final String? screenCaptureDetectedAlertMessage;

  /// Security Alert actionTitle, only works on iOS.
  final String? screenCaptureDetectedAlertActionTitle;

  /// Constructs an instance of [SecureKeyboard].
  const SecureKeyboard({
    Key? key,
    required this.type,
    this.onKeyPressed,
    this.onCharCodesChanged,
    required this.onDoneKeyPressed,
    required this.onCloseKeyPressed,
    this.onStringKeyTouchStart,
    this.onStringKeyTouchEnd,
    this.initText,
    this.hintText,
    this.inputTextLengthSymbol,
    this.doneKeyText,
    this.clearKeyText,
    this.obscuringCharacter = '•',
    this.maxLength,
    this.alwaysCaps = false,
    this.obscureText = true,
    this.shuffleNumericKey = true,
    this.hideKeyInputMonitor = false,
    this.height = kKeyboardDefaultHeight,
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
    this.screenCaptureDetectedAlertTitle,
    this.screenCaptureDetectedAlertMessage,
    this.screenCaptureDetectedAlertActionTitle
  })  : assert(obscuringCharacter.length > 0),
        super(key: key);

  @override
  _SecureKeyboardState createState() => _SecureKeyboardState();
}

class _SecureKeyboardState extends State<SecureKeyboard> {
  final _channel = const MethodChannel('flutter_secure_keyboard');

  final _definedKeyRows = <List<SecureKeyboardKey>>[];
  final _specialKeyRows = <List<SecureKeyboardKey>>[];

  final _charCodesController = StreamController<List<int>>.broadcast();
  final _charCodes = <int>[];
  
  Timer? _backspaceEventGenerator;

  bool _isViewEnabled = false;
  bool _isShiftEnabled = false;
  bool _isSpecialCharsEnabled = false;
  
  void _initStateVariables() {
    _isViewEnabled = false;
    _isShiftEnabled = false;
    _isSpecialCharsEnabled = false;

    _definedKeyRows.clear();
    _specialKeyRows.clear();
    _charCodes.clear();
    if (widget.initText != null)
      _charCodes.addAll(widget.initText!.codeUnits);

    final keyGenerator = SecureKeyboardKeyGenerator.instance;
    if (widget.type == SecureKeyboardType.NUMERIC)
      _definedKeyRows.addAll(keyGenerator.getNumericKeyRows(widget.shuffleNumericKey));
    else
      _definedKeyRows.addAll(keyGenerator.getAlphanumericKeyRows(widget.shuffleNumericKey));
    _specialKeyRows.addAll(SecureKeyboardKeyGenerator.instance.getSpecialCharsKeyRows());
  }

  void _notifyCharCodesChanged() {
    _charCodesController.sink.add(_charCodes);
  }

  void _onKeyPressed(SecureKeyboardKey key) {
    if (key.type == SecureKeyboardKeyType.STRING) {
      // The length of `charCodes` cannot exceed `maxLength`.
      final maxLength = widget.maxLength;
      if (maxLength != null && (maxLength <= _charCodes.length)) return;

      // -_- Not good...
      if (key.text == null) return;

      _charCodes.add(key.text!.codeUnits.first);
      _notifyCharCodesChanged();
      if (widget.onCharCodesChanged != null)
        widget.onCharCodesChanged!(_charCodes);
    } else if (key.type == SecureKeyboardKeyType.ACTION) {
      switch (key.action) {
        case SecureKeyboardKeyAction.BACKSPACE:
          if (_charCodes.isNotEmpty) {
            _charCodes.removeLast();
            _notifyCharCodesChanged();
            if (widget.onCharCodesChanged != null)
              widget.onCharCodesChanged!(_charCodes);
          }
          break;
        case SecureKeyboardKeyAction.DONE:
          widget.onDoneKeyPressed(_charCodes);
          break;
        case SecureKeyboardKeyAction.CLEAR:
          _charCodes.clear();
          _notifyCharCodesChanged();
          if (widget.onCharCodesChanged != null)
            widget.onCharCodesChanged!(_charCodes);
          break;
        case SecureKeyboardKeyAction.SHIFT:
          if (!widget.alwaysCaps)
            setState(() {
              _isShiftEnabled = !_isShiftEnabled;
            });
          break;
        case SecureKeyboardKeyAction.SPECIAL_CHARACTERS:
          setState(() {
            _isSpecialCharsEnabled = !_isSpecialCharsEnabled;
          });
          break;
        default:
          return;
      }
    }

    if (widget.onKeyPressed != null)
      widget.onKeyPressed!(key);
  }

  @override
  void didUpdateWidget(covariant SecureKeyboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initStateVariables();
  }

  @override
  void initState() {
    super.initState();
    _channel.invokeMethod('secureModeOn', {
      'screenCaptureDetectedAlertTitle': widget.screenCaptureDetectedAlertTitle,
      'screenCaptureDetectedAlertMessage': widget.screenCaptureDetectedAlertMessage,
      'screenCaptureDetectedAlertActionTitle': widget.screenCaptureDetectedAlertActionTitle
    });
    _initStateVariables();
  }

  @override
  Widget build(BuildContext context) {
    double height;
    Widget keyInputMonitor;
    if (widget.hideKeyInputMonitor) {
      height = widget.height + 5.0;
      keyInputMonitor = SizedBox.shrink();
    } else {
      height = widget.height + kKeyInputMonitorHeight;
      keyInputMonitor = Padding(
        padding: widget.keyInputMonitorPadding,
        child: _buildKeyInputMonitor()
      );
    }

    final keyRows = _isSpecialCharsEnabled
        ? _specialKeyRows
        : _definedKeyRows;
    final keyboard = Padding(
      padding: widget.keyboardPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildKeyboardKey(keyRows)
      ),
    );

    return WillPopScope(
      onWillPop: () async {
        widget.onCloseKeyPressed();
        return false;
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: height,
        color: widget.backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            keyInputMonitor,
            keyboard
          ]
        ),
      ),
    );
  }

  Widget _buildKeyInputMonitor() {
    return StreamBuilder<List<int>>(
      stream: _charCodesController.stream.asBroadcastStream(
        onCancel: (subscription) => subscription.cancel()
      ),
      initialData: _charCodes,
      builder: (context, snapshot) =>
          _buildKeyInputMonitorLayout(snapshot.data ?? _charCodes)
    );
  }

  Widget _buildKeyInputMonitorLayout(List<int> charCodes) {
    String secureText;
    TextStyle secureTextStyle;

    if (charCodes.isNotEmpty) {
      if (widget.obscureText && !_isViewEnabled) {
        secureText = '';
        for (var i=0; i<charCodes.length; i++) {
          if (i == charCodes.length - 1)
            secureText += String.fromCharCode(charCodes[i]);
          else
            secureText += widget.obscuringCharacter;
        }
      } else {
        secureText = String.fromCharCodes(charCodes);
      }

      secureTextStyle = widget.inputTextStyle;
    } else {
      secureText = widget.hintText ?? '';
      secureTextStyle = widget.inputTextStyle.copyWith(
          color: widget.inputTextStyle.color?.withOpacity(0.5));
    }

    String? lengthSymbol = widget.inputTextLengthSymbol;
    if (lengthSymbol == null)
      lengthSymbol = (Platform.localeName == 'ko_KR') ? '자' : 'digit';
    final lengthText = '${charCodes.length}$lengthSymbol';

    return SizedBox(
      height: kKeyInputMonitorHeight,
      child: Row(
        children: [
          Expanded(
            child: Text(
              secureText,
              style: secureTextStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis
            )
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(lengthText, style: widget.keyTextStyle)
          ),
          widget.obscureText
              ? _buildViewButton()
              : SizedBox.shrink(),
          _buildCloseButton()
        ],
      ),
    );
  }

  Widget _buildViewButton() {
    return SizedBox(
      width: kKeyInputMonitorHeight / 1.2,
      height: kKeyInputMonitorHeight / 1.2,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(2.0),
          onTap: () { },
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onPanDown: (_) => setState(() => _isViewEnabled = true),
            onPanEnd: (_) => setState(() => _isViewEnabled = false),
            onPanCancel: ( ) => setState(() => _isViewEnabled = false),
            child: Icon(Icons.remove_red_eye, color: widget.keyTextStyle.color)
          ),
        ),
      ),
    );
  }

  Widget _buildCloseButton() {
    return SizedBox(
      width: kKeyInputMonitorHeight / 1.2,
      height: kKeyInputMonitorHeight / 1.2,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(2.0),
          child: Icon(Icons.close, color: widget.keyTextStyle.color),
          onTap: widget.onCloseKeyPressed
        ),
      ),
    );
  }

  List<Widget> _buildKeyboardKey(List<List<SecureKeyboardKey>> keyRows) {
    return List.generate(keyRows.length, (int rowNum) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(keyRows[rowNum].length, (int keyNum) {
          final key = keyRows[rowNum][keyNum];

          switch (key.type) {
            case SecureKeyboardKeyType.STRING:
              return _buildStringKey(key, keyRows.length);
            case SecureKeyboardKeyType.ACTION:
              return _buildActionKey(key, keyRows.length);
            default:
              throw Exception('Unknown key type.');
          }
        })
      );
    });
  }
  
  Widget _buildStringKey(SecureKeyboardKey key, int keyRowsLength) {
    if (_isShiftEnabled || widget.alwaysCaps)
      key = SecureKeyboardKey.fromJson(key.toJson(toUpperText: true));

    final keyText = key.text ?? '';
    final globalKey = GlobalKey();

    return Expanded(
      child: Container(
        key: globalKey,
        height: widget.height / keyRowsLength,
        padding: EdgeInsets.all(widget.keySpacing),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final keyChild = Material(
              borderRadius: BorderRadius.circular(widget.keyRadius),
              color: widget.stringKeyColor,
              child: InkWell(
                borderRadius: BorderRadius.circular(widget.keyRadius),
                child: Center(child: Text(keyText, style: widget.keyTextStyle)),
                onTap: () => _onKeyPressed(key)
              ),
            );

            if (widget.type == SecureKeyboardType.ALPHA_NUMERIC)
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onPanDown: (_) {
                  if (widget.onStringKeyTouchStart == null) return;

                  final renderObj = globalKey.currentContext?.findRenderObject();
                  if ((renderObj != null) && (renderObj is RenderBox)) {
                    final renderPos = renderObj.localToGlobal(Offset.zero);
                    widget.onStringKeyTouchStart!(keyText, renderPos, constraints);
                  }
                },
                onPanEnd: (_) {
                  if (widget.onStringKeyTouchEnd != null)
                    widget.onStringKeyTouchEnd!();
                },
                onPanCancel: () {
                  if (widget.onStringKeyTouchEnd != null)
                    widget.onStringKeyTouchEnd!();
                },
                child: keyChild
              );

            return keyChild;
          }
        ),
      ),
    );
  }

  Widget _buildActionKey(SecureKeyboardKey key, int keyRowsLength) {
    Widget keyChild;
    switch (key.action ?? SecureKeyboardKeyAction.BLANK) {
      case SecureKeyboardKeyAction.BACKSPACE:
        keyChild = Icon(Icons.backspace, color: widget.keyTextStyle.color);
        break;
      case SecureKeyboardKeyAction.SHIFT:
        keyChild = Icon(Icons.arrow_upward, color: widget.keyTextStyle.color);
        break;
      case SecureKeyboardKeyAction.CLEAR:
        String? keyText = widget.clearKeyText;
        if (keyText == null || keyText.isEmpty)
          keyText = (Platform.localeName == 'ko_KR') ? '초기화' : 'Clear';

        keyChild = Text(keyText, style: widget.keyTextStyle);
        break;
      case SecureKeyboardKeyAction.DONE:
        String? keyText = widget.doneKeyText;
        if (keyText == null || keyText.isEmpty)
          keyText = (Platform.localeName == 'ko_KR') ? '입력완료' : 'Done';

        keyChild = Text(keyText, style: widget.keyTextStyle);
        break;
      case SecureKeyboardKeyAction.SPECIAL_CHARACTERS:
        keyChild = Text(
          _isSpecialCharsEnabled
              ? (_isShiftEnabled ? 'ABC' : 'abc')
              : '!@#',
          style: widget.keyTextStyle
        );
        break;
      case SecureKeyboardKeyAction.BLANK:
        return Expanded(child: SizedBox.shrink());
    }

    keyChild = InkWell(
      borderRadius: BorderRadius.circular(widget.keyRadius),
      child: Center(child: keyChild),
      onTap: () => _onKeyPressed(key)
    );

    if (key.action == SecureKeyboardKeyAction.BACKSPACE)
      keyChild = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onLongPress: () {
          final delay = const Duration(milliseconds: kBackspaceEventDelay);
          _backspaceEventGenerator = Timer.periodic(delay, (_) => _onKeyPressed(key));
        },
        onLongPressUp: () {
          _backspaceEventGenerator?.cancel();
          _backspaceEventGenerator = null;
        },
        child: keyChild
      );

    Color keyColor;
    if (key.action == SecureKeyboardKeyAction.DONE)
      keyColor = widget.doneKeyColor;
    else if (key.action == SecureKeyboardKeyAction.SHIFT && _isShiftEnabled)
      keyColor = widget.activatedKeyColor ?? widget.doneKeyColor;
    else
      keyColor = widget.actionKeyColor;

    return Expanded(
      child: Container(
        height: widget.height / keyRowsLength,
        padding: EdgeInsets.all(widget.keySpacing),
        child: Material(
          borderRadius: BorderRadius.circular(widget.keyRadius),
          color: keyColor,
          child: keyChild
        ),
      ),
    );
  }

  @override
  void dispose() {
    _channel.invokeMethod('secureModeOff');
    _charCodesController.close();
    super.dispose();
  }
}
