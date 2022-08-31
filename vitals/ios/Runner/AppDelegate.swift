import UIKit
import Flutter
import WatchConnectivity

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private var session: WCSession?
    private var channel: FlutterMethodChannel?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        initFlutterChannel()
        initWatchConnectivity()
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func initWatchConnectivity() {
        guard WCSession.isSupported() else { return }
        session = WCSession.default
        session?.delegate = self
        session?.activate()
    }
    
    private func initFlutterChannel() {
        Task { @MainActor in
            guard let controller = self.window?.rootViewController as? FlutterViewController else { return }
            
            let channel = FlutterMethodChannel(name: "com.michaelhitzker.vitals", binaryMessenger: controller.binaryMessenger)
            channel.setMethodCallHandler { [weak self] call, result in
                let method = call.method
                let args = call.arguments
                
                guard method == "forwardToAppleWatch" else { return }
                guard let watchSession = self?.session, watchSession.isPaired, let messageData = args as? [String: Any] else {
                    print("watch not paired")
                    return
                }
                
                guard watchSession.isReachable else {
                    print("watch not reachable")
                    return
                }
                
                watchSession.sendMessage(messageData, replyHandler: nil, errorHandler: nil)
            }
            
            channel.setMethodCallHandler { [weak self] call, result in
                let method = call.method
                let args = call.arguments
                
                guard method == "forwardToAppleWatch" else { return }
                //TODO: Forward to apple watch
            }
            
            self.channel = channel
        }
    }
}

extension AppDelegate: WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) { }
    func sessionDidDeactivate(_ session: WCSession) { }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        channel?.invokeMethod("sendCounterToWatch", arguments: nil)
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        guard session.isReachable, session.isPaired else { return }
        channel?.invokeMethod("sendCounterToWatch", arguments: nil)
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        guard session.isReachable else { return }
        channel?.invokeMethod("sendCounterToWatch", arguments: nil)
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        guard let methodName = message["method"] as? String else { return }
        let data: [String: Any]? = message["data"] as? [String: Any]
        
        channel?.invokeMethod(methodName, arguments: data)
    }
}
