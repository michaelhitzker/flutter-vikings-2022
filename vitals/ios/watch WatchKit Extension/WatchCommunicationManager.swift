import Foundation
import WatchConnectivity

final class WatchCommunicationManager: NSObject, ObservableObject {
    @Published var beerAmount: Int?
    @Published var coffeeAmount: Int?
    
    private let session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        self.session.activate()
    }
    
    func increaseBeer() {
        session.sendMessage(["method": "increaseBeerFromWatch", "data": [:]], replyHandler: nil, errorHandler: nil)
    }
    
    func increaseCoffee() {
        session.sendMessage(["method": "increaseCoffeeFromWatch", "data": [:]], replyHandler: nil, errorHandler: nil)
    }
    
    func requestCounters(){
        session.sendMessage(["method": "sendCounterToWatch", "data": [:]], replyHandler: nil, errorHandler: nil)
    }
}

extension WatchCommunicationManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        guard activationState == .activated else { return }
        requestCounters()
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        guard self.session.isReachable else { return }
        requestCounters()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        guard let method = message["method"] as? String, let data = message["data"] as? [String: Any] else { return }
        
        switch method {
        case "updateCounterFromFlutter":
            let coffeeCount = data["coffee"] as? Int ?? 0
            let beerCount = data["beer"] as? Int ?? 0
            
            Task { @MainActor in
                beerAmount = beerCount
                coffeeAmount = coffeeCount
            }
        default:
            return;
        }
    }
}
