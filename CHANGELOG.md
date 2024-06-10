## 4.0.0

* [**FEAT**] Support AGP 8
* [**FEAT**] Add ability for the keyboard to be rendered considering SafeArea
* [**FIX**] Fixed an issue where shift was not released when typing in weak shift state
* [**FIX**] Fixed an issue where screen capture was possible on iOS 17+
* [**CHORE**] Upgrade dependencies

## 3.0.0

* [**CHORE**] Update dependency constraints to `sdk: '>=2.18.0 <4.0.0'` `flutter: '>=3.3.0'`
* [**CHORE**] Update Android Gradle version to `7.1.2`
* [**FEAT-iOS**] Add ability to prevent screen capture
    - Remove `screenCaptureDetectedAlertTitle` option 
    - Remove `screenCaptureDetectedAlertMessage` option 
    - Remove `screenCaptureDetectedAlertActionTitle` option

## 2.2.2

* Improved the native code for each platform.
* Improved keyboard button touch area.
* Added Shift activation step like software keyboard.

## 2.2.1

* Upgrade flutter_keyboard_visibility: ^5.0.3

## 2.2.0

* Upgrade flutter_keyboard_visibility: ^5.0.2
* Upgrade compileSdkVersion to 30 on Android platform.
* Migrate to new Android plugins APIs(embedding v2).
* Update documentation.
* Remove the `capsText` of the `SecureKeyboardKey` and incorporated it into the `text`.
* Fixed an issue where the screen flickered when opening the secure keyboard while the software keyboard was open.
* Fixed an issue where the view button wasn't working properly.
* Fixed an issue where the backspace button wasn't working properly.

## 2.1.3

* Upgrade flutter_keyboard_visibility: ^5.0.1

## 2.1.2

* Fixed an issue that lost focus when switching software keyboard.

## 2.1.1

* Add `hideKeyInputMonitor` option.
* Add `disableKeyBubble` option.

## 2.1.0

* Improve performance.
* Add `Key Bubble` to check the string key pressed.

## 2.0.0

* Migrate null safety.
* Upgrade `flutter_keyboard_visibility` plugin.
* Remove `type` function in `SecureKeyboardController`.

## 1.1.0

* Upgrade `flutter_keyboard_visibility` plugin.
* Change the value of `SecureKeyboardKeyAction` to uppercase.
* Change the value of `SecureKeyboardKeyType` to uppercase.
* Change the value of `SecureKeyboardType` to uppercase.
* Add `shuffleNumericKey` option to ask for shuffle of numeric keys.
* Add `keyRadius` option to set the radius of the key button.
* Add `keySpacing` option to set the spacing between key buttons.
* Add `keyInputMonitorPadding`, `keyboardPadding` option to cope with edge screen.

## 1.0.6

* Documentation updates.
* Added code to close the secure keyboard when the back button on the soft navigation bar is pressed.

## 1.0.5

* README updates.
* Example updates.
* Remove `onDoneKeyPressed` required annotation.

## 1.0.4

* Add `activatedKeyColor` param.

## 1.0.3

* Change action key name from `confirm` to `done`.
* Fixed an issue that caused an exception to occur when setting the key text.

## 1.0.2

* Add `screenCaptureDetectedAlertTitle` param.
* Add `screenCaptureDetectedAlertMessage` param.
* Add `screenCaptureDetectedAlertActionTitle` param.

## 1.0.1+3

* Update documentation.

## 1.0.1+2

* README updates.
* Change package name and structure.

## 1.0.1

* Fixed an issue that caused the input text to overflow.
* Added option to set maximum length of input text.

## 1.0.0+2

* Resize the close and view buttons.
* Fixed an issue where the view button wasn't working properly.

## 1.0.0

* Initial release.
