import UIKit
import Flutter
import R2Navigator
import R2Shared
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
     let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
     print("---------------here------------")
    let readiumIntegrationChannel = FlutterMethodChannel(name: "readium_integration", binaryMessenger: controller.binaryMessenger)
    readiumIntegrationChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      
      guard call.method == "openEpub",
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
    print("inside of function-------------")
    
    let epubPath = URL(fileURLWithPath: path)
        let book = Book(epubPath: epubPath)
        print(book)
        let reader = EpubReader()
        let controller = reader.makeReaderViewController(book: book)

        // Presenting the EPUB reader view controller.
        if let rootViewController = window?.rootViewController {
            rootViewController.present(controller, animated: true, completion: nil)
        }
        result(nil) // Return success or any appropriate result.
  }
}
class Book {
    var epubPath: URL

    init(epubPath: URL) {
        self.epubPath = epubPath
    }

    // Additional properties and methods can be added here as needed.
}

// A simple EpubReader class that is responsible for creating a view controller to read an EPUB.
class EpubReader {
    func makeReaderViewController(book: Book) -> UIViewController {
        // Here you should create and configure your view controller for reading EPUBs.
        // The following is a placeholder, you would use your actual EPUB reader view controller.
        let epubViewController = UIViewController()
        // Configure the view controller with the book's data.
        
        return epubViewController
    }
}