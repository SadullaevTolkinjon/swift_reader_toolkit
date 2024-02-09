import UIKit
import Flutter
import ReadiumToolkit
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
     let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let readiumIntegrationChannel = FlutterMethodChannel(name: "readium_integration", binaryMessenger: controller.binaryMessenger)
    readiumIntegrationChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      guard call.method == "openEpubFile",
            let args = call.arguments as? [String: Any],
            let path = args["path"] as? String else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid method arguments", details: nil))
        return
      }
      self?.openEpubFile(path: path, result: result)
    })
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
   private func openEpubFile(path: String, result: FlutterResult) {
    let epubPath = URL(fileURLWithPath: path)
    let book = Book(epubPath: epubPath)
    let reader = EpubReader()
    let controller = reader.make(reader: reader, book: book)
    window?.rootViewController?.present(controller, animated: true, completion: nil)
    result(nil)
  }
}
