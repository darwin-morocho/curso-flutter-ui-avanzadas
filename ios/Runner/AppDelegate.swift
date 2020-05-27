import UIKit
import Flutter
import FBSDKCoreKit
import Stripe

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var channel:FlutterMethodChannel?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        
        self.channel = FlutterMethodChannel(name: "ec.dina/stripe_sdk",
        binaryMessenger: controller.binaryMessenger)
        
        self.channel?.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method {
            case "init":
                let args:[String:Any]  = call.arguments as! [String : Any]
                let pk:String = args["pk"] as! String
                Stripe.setDefaultPublishableKey(pk)
                result(nil)
                
            default:
                result(FlutterMethodNotImplemented)
            }
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
   override func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        
    }
    
    
    
}
