import Flutter
import UIKit

public class SwiftFlutterSecureKeyboardPlugin: NSObject, FlutterPlugin {
  private var methodChannel: FlutterMethodChannel?
    
  private var notificationObserver: NSObjectProtocol? = nil
  private var isSecureModeOn: Bool = false
  private var screenCaptureDetectedAlertTitle: String?
  private var screenCaptureDetectedAlertMessage: String?
  private var screenCaptureDetectedAlertActionTitle: String?
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = SwiftFlutterSecureKeyboardPlugin()
    instance.initChannels(registrar.messenger())
    registrar.addApplicationDelegate(instance)
  }
    
  private func initChannels(_ messenger: FlutterBinaryMessenger) {
    methodChannel = FlutterMethodChannel(name: "flutter_secure_keyboard", binaryMessenger: messenger)
    methodChannel?.setMethodCallHandler(onMethodCall)
  }

  private func onMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "secureModeOn":
        guard let args = call.arguments as? Dictionary<String, Any> else {
          result(FlutterError(code: call.method, message: "Missing arguments", details: nil))
          return
        }
        
        if (notificationObserver == nil) {
          notificationObserver = NotificationCenter.default.addObserver(
              forName: UIApplication.userDidTakeScreenshotNotification,
              object: nil,
              queue: nil,
              using: applicationUserDidTakeScreenshot)
        }
        isSecureModeOn = true
        screenCaptureDetectedAlertTitle = args["screenCaptureDetectedAlertTitle"] as? String
        screenCaptureDetectedAlertMessage = args["screenCaptureDetectedAlertMessage"] as? String
        screenCaptureDetectedAlertActionTitle = args["screenCaptureDetectedAlertActionTitle"] as? String
        break
      case "secureModeOff":
        if (notificationObserver != nil) {
          NotificationCenter.default.removeObserver(notificationObserver!)
          notificationObserver = nil
        }
        isSecureModeOn = false
        screenCaptureDetectedAlertTitle = nil
        screenCaptureDetectedAlertMessage = nil
        screenCaptureDetectedAlertActionTitle = nil
        break
      default:
        result(FlutterMethodNotImplemented)
    }
  }
    
  public func applicationWillResignActive(_ application: UIApplication) {
    if (isSecureModeOn) {
      UIApplication.shared.delegate?.window??.isHidden = true
    }
  }
    
  public func applicationDidBecomeActive(_ application: UIApplication) {
    if (isSecureModeOn) {
      UIApplication.shared.delegate?.window??.isHidden = false
    }
  }
    
  public func applicationUserDidTakeScreenshot(_ notification: Notification) {
    let alertTitle: String
    let alertMessage: String
    let alertActionTitle: String
    
    let localeID = Locale.preferredLanguages.first
    let deviceLocale = (Locale(identifier: localeID ?? "en").languageCode) ?? "en"
      
    if (deviceLocale == "ko") {
      alertTitle = "보안 경고"
      alertMessage = "보안 문자를 입력하는 동안 화면 캡처가 탐지되었습니다."
      alertActionTitle = "확인"
    } else {
      alertTitle = "Security Warning"
      alertMessage = "Screen Capture was detected while typing secure text."
      alertActionTitle = "OK"
    }
      
    let alert = UIAlertController(
      title: screenCaptureDetectedAlertTitle ?? alertTitle,
      message: screenCaptureDetectedAlertMessage ?? alertMessage,
      preferredStyle: .alert
    )
    let alertAction = UIAlertAction(
      title: screenCaptureDetectedAlertActionTitle ?? alertActionTitle,
      style: .default
    )
    alert.addAction(alertAction)
      
    UIApplication.shared.delegate?.window??.rootViewController?.present(alert, animated: true, completion: nil)
  }
}
