Mobile secure keyboard to prevent KeyLogger attack and screen capture.

[![pub package](https://img.shields.io/pub/v/flutter_secure_keyboard.svg)](https://pub.dev/packages/flutter_secure_keyboard)

## Screenshots
| Alphanumeric | Numeric |
|---|---|
| <img src="https://user-images.githubusercontent.com/47127353/111059243-52fbc980-84d7-11eb-9260-01b6b7b5909c.png" width="200"> | <img src="https://user-images.githubusercontent.com/47127353/111059256-7888d300-84d7-11eb-8797-89a69337d8ad.png" width="200"> |

## Getting started

To use this plugin, add `flutter_secure_keyboard` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/). For example:

```yaml
dependencies:
  flutter_secure_keyboard: ^2.2.2
```

## Examples

```dart
class WithSecureKeyboardExample extends StatefulWidget {
  @override
  _WithSecureKeyboardExampleState createState() => _WithSecureKeyboardExampleState();
}

class _WithSecureKeyboardExampleState extends State<WithSecureKeyboardExample> {
  final _secureKeyboardController = SecureKeyboardController();

  final _passwordEditor = TextEditingController();
  final _passwordTextFieldFocusNode = FocusNode();

  final _pinCodeEditor = TextEditingController();
  final _pinCodeTextFieldFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    // Set the WithSecureKeyboard widget as the top-level widget
    // in the build function so that the secure keyboard works properly.
    return WithSecureKeyboard(
      controller: _secureKeyboardController,
      child: Scaffold(
        appBar: AppBar(title: Text('with_secure_keyboard_example')),
        body: _buildContentView()
      ),
    );
  }

  Widget _buildContentView() {
    // We recommend using the ListView widget to prevent widget overflow.
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        _buildPasswordTextField(),
        SizedBox(height: 12.0),
        _buildPinCodeTextField()
      ],
    );
  }

  Widget _buildPasswordTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Password'),
        TextFormField(
          controller: _passwordEditor,
          focusNode: _passwordTextFieldFocusNode,
          // We recommended to set false to prevent the software keyboard from opening.
          enableInteractiveSelection: false,
          obscureText: true,
          onTap: () {
            _secureKeyboardController.show(
              type: SecureKeyboardType.ALPHA_NUMERIC,
              focusNode: _passwordTextFieldFocusNode,
              initText: _passwordEditor.text,
              hintText: 'password',
              // Use onCharCodesChanged to have text entered in real time.
              onCharCodesChanged: (List<int> charCodes) {
                _passwordEditor.text = String.fromCharCodes(charCodes);
              }
            );
          },
        ),
      ],
    );
  }

  Widget _buildPinCodeTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('PinCode'),
        TextFormField(
          controller: _pinCodeEditor,
          focusNode: _pinCodeTextFieldFocusNode,
          // We recommended to set false to prevent the software keyboard from opening.
          enableInteractiveSelection: false,
          obscureText: true,
          onTap: () {
            _secureKeyboardController.show(
              type: SecureKeyboardType.NUMERIC,
              focusNode: _pinCodeTextFieldFocusNode,
              initText: _pinCodeEditor.text,
              hintText: 'pinCode',
              // Use onDoneKeyPressed to allow text to be entered when you press the done key,
              // or to do something like encryption.
              onDoneKeyPressed: (List<int> charCodes) {
                _pinCodeEditor.text = String.fromCharCodes(charCodes);
              }
            );
          },
        ),
      ],
    );
  }
}
```

## Package

* **WithSecureKeyboard** - A widget that implements a secure keyboard with controller.
* **SecureKeyboardController** - Controller to check or control the state of the secure keyboard.

**Note:** The parameters marked with an asterisk(*) are required.

### WithSecureKeyboard

| Parameter | Description |
|---|---|
| `controller`* | Controller to control the secure keyboard. |
| `child`* | A child widget with a secure keyboard. |
| `keyboardHeight` | The height of the keyboard. <br> Default value is `280.0`. |
| `keyRadius` | The radius of the keyboard key. <br> Default value is `4.0`. |
| `keySpacing` | The spacing between keyboard keys. <br> Default value is `1.2`. |
| `keyInputMonitorPadding` | The padding of the key input monitor. <br> Default value is `const EdgeInsets.only(left: 10.0, right: 5.0)`. |
| `keyboardPadding` | The padding of the keyboard. <br> Default value is `const EdgeInsets.symmetric(horizontal: 5.0)`. |
| `backgroundColor` | The background color of the keyboard. <br> Default value is `const Color(0xFF0A0A0A)`. |
| `stringKeyColor` | The color of the string key(alphanumeric, numeric..). <br> Default value is `const Color(0xFF313131)`. |
| `actionKeyColor` | The color of the action key(shift, backspace, clear..). <br> Default value is `const Color(0xFF222222)`. |
| `doneKeyColor` | The color of the done key. <br> Default value is `const Color(0xFF1C7CDC)`. |
| `activatedKeyColor` | The key color when the shift action key is activated. If the value is null, `doneKeyColor` is used. |
| `keyTextStyle` | The text style of the text inside the keyboard key. <br> Default value is `const TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.w500)`. |
| `inputTextStyle` | The text style of the text inside the key input monitor. <br> Default value is `const TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.w500)`. |
| `screenCaptureDetectedAlertTitle` | Security Alert title, only works on iOS. |
| `screenCaptureDetectedAlertMessage` | Security Alert message, only works on iOS |
| `screenCaptureDetectedAlertActionTitle` | Security Alert actionTitle, only works on iOS. |

### SecureKeyboardController

| Function | Description |
|---|---|
| `isShowing` | Whether the secure keyboard is showing. |
| `show` | Show secure keyboard. |
| `hide` | Hide secure keyboard. |

### SecureKeyboardController.show()

| Parameter | Description |
|---|---|
| `type`* | The type of the secure keyboard. |
| `focusNode` | The `FocusNode` that will receive focus on. |
| `initText` | The initial value of the input text. |
| `hintText` | The hint text to display when the input text is empty. |
| `inputTextLengthSymbol` | The symbol to use when displaying the input text length. |
| `doneKeyText` | The text of the done key. |
| `clearKeyText` | The text of the clear key. |
| `obscuringCharacter` | The secure character to hide the input text. <br> Default value is `•`. |
| `maxLength` | The maximum length of text that can be entered. |
| `alwaysCaps` | Whether to always display uppercase characters. <br> Default value is `false`. |
| `obscureText` | Whether to hide input text as secure characters. <br> Default value is `true`. |
| `shuffleNumericKey` | Whether to shuffle the position of the numeric keys. <br> Default value is `true`. |
| `hideKeyInputMonitor` | Whether to hide the key input monitor. <br> Default value is `false`. |
| `disableKeyBubble` | Whether to disable the key bubble. <br> Default value is `false`. |
| `onKeyPressed` | Called when the key is pressed. |
| `onCharCodesChanged` | Called when the character codes changed. |
| `onDoneKeyPressed` | Called when the done key is pressed. |
| `onCloseKeyPressed` | Called when the close key is pressed. |
