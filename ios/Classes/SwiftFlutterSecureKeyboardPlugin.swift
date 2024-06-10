import Flutter
import UIKit

public class SwiftFlutterSecureKeyboardPlugin: NSObject, FlutterPlugin {
  private var methodChannel: FlutterMethodChannel?
  private var secureField: UITextField?
  
  var isScreenCapturable: Bool {
    get {
      return secureField?.isSecureTextEntry == false
    }
  }
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = SwiftFlutterSecureKeyboardPlugin()
    instance.initChannels(registrar.messenger())
    instance.initSecureField()
    registrar.addApplicationDelegate(instance)
  }
  
  private func initChannels(_ messenger: FlutterBinaryMessenger) {
    methodChannel = FlutterMethodChannel(name: "flutter_secure_keyboard", binaryMessenger: messenger)
    methodChannel?.setMethodCallHandler(onMethodCall)
  }
  
  private func initSecureField() {
    if let window = UIApplication.shared.delegate?.window! {
      let tf = UITextField()
      let uv = UIView(frame: CGRect(x: 0, y: 0, width: tf.frame.self.width, height: tf.frame.self.height))
      let iv = UIImageView(image: UIImage())
      iv.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
      window.addSubview(tf)
      uv.addSubview(iv)
      window.layer.superlayer?.addSublayer(tf.layer)
      tf.layer.sublayers?.last?.addSublayer(window.layer)
      tf.leftView = uv
      tf.leftViewMode = .always
      self.secureField = tf
    }
  }
  
  private func onMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "secureModeOn":
        secureField?.isSecureTextEntry = true
        break
      case "secureModeOff":
        secureField?.isSecureTextEntry = false
        break
      default:
        result(FlutterMethodNotImplemented)
    }
  }
  
  public func applicationWillResignActive(_ application: UIApplication) {
    if !isScreenCapturable {
      UIApplication.shared.delegate?.window??.isHidden = true
    }
  }
  
  public func applicationDidBecomeActive(_ application: UIApplication) {
    UIApplication.shared.delegate?.window??.isHidden = false
  }
}
