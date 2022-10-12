
import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    lazy var flutterEngine = FlutterEngine(name: "MyApp")
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Runs the default Dart entrypoint with a default Flutter route.
        flutterEngine.run()

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}