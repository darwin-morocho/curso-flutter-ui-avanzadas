import UIKit
import Flutter
import FBSDKCoreKit
import Stripe

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, STPAuthenticationContext {
    
    func authenticationPresentingViewController() -> UIViewController {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        return controller
    }
    
    var channel:FlutterMethodChannel?
    var result:FlutterResult?
    
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
                
            case "pay":
                self.makePay(args: call.arguments as! [String : Any] , result: result)
        
                
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
    
    
    
    
    private func makePay(args: [String:Any], result:@escaping FlutterResult ){
        if(self.result != nil){
            result(FlutterError(code: "PENDING_TASK", message: "You have a pending task.", details: nil))
            return
        }
        self.result = result
        
        let clientSecret:String  =  args["clientSecret"] as! String
        let cardNumber:String  =  args["cardNumber"] as! String
        let cvv:String  = args["cvv"] as! String
        let year:UInt = (args["year"] as! NSNumber).uintValue
        let month:UInt = (args["month"] as! NSNumber).uintValue
        
        
        let cardParams:STPCardParams = STPCardParams()
        cardParams.number = cardNumber
        cardParams.cvc = cvv
        cardParams.expMonth  = month
        cardParams.expYear = year
        
        let card = STPPaymentMethodCardParams(cardSourceParams: cardParams)
        
        let paymentMethodParams = STPPaymentMethodParams(card: card, billingDetails: nil, metadata: nil)
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
        paymentIntentParams.paymentMethodParams = paymentMethodParams
        
        let paymentHandler = STPPaymentHandler.shared()
        
        paymentHandler.confirmPayment(withParams: paymentIntentParams, authenticationContext: self) { (status, paymentIntent, error) in
            switch (status) {
            case .failed:
                self.result!(["status":"failed"])
                self.result = nil
               
                break
            case .canceled:
                self.result!(["status":"canceled"])
                self.result = nil
                break
            case .succeeded:
               self.result!(["status":"succeeded"])
               self.result = nil
                break
            @unknown default:
                fatalError()
                break
            }
        }
        
        
        
        
        
    }
    
    
}
