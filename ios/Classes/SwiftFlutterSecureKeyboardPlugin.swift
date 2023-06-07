import Flutter
import UIKit

public class SwiftFlutterSecureKeyboardPlugin: NSObject, FlutterPlugin {
  private var methodChannel: FlutterMethodChannel?
  private var secureView: UITextField?
  
  var isScreenCapturable: Bool {
    get {
      return secureView?.isSecureTextEntry == false
    }
  }
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = SwiftFlutterSecureKeyboardPlugin()
    instance.initChannels(registrar.messenger())
    instance.initSecureView()
    registrar.addApplicationDelegate(instance)
  }
  
  private func initChannels(_ messenger: FlutterBinaryMessenger) {
    methodChannel = FlutterMethodChannel(name: "flutter_secure_keyboard", binaryMessenger: messenger)
    methodChannel?.setMethodCallHandler(onMethodCall)
  }
  
  private func initSecureView() {
    if let window = UIApplication.shared.delegate?.window! {
      secureView = UITextField()
      window.addSubview(secureView!)
      secureView!.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
      secureView!.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
      window.layer.superlayer?.addSublayer(secureView!.layer)
      secureView!.layer.sublayers?.first?.addSublayer(window.layer)
    }
  }
  
  private func onMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "secureModeOn":
        secureView?.isSecureTextEntry = true
        break
      case "secureModeOff":
        secureView?.isSecureTextEntry = false
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
