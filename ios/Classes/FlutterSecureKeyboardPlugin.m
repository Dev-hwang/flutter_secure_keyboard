#import "FlutterSecureKeyboardPlugin.h"
#if __has_include(<flutter_secure_keyboard/flutter_secure_keyboard-Swift.h>)
#import <flutter_secure_keyboard/flutter_secure_keyboard-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_secure_keyboard-Swift.h"
#endif

@implementation FlutterSecureKeyboardPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterSecureKeyboardPlugin registerWithRegistrar:registrar];
}
@end
