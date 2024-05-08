//
//  WatchConnector.swift
//  PersonalData2
//
//  Created by bogdan on 17.04.2024.
//

import Foundation
import WatchConnectivity

class WatchConnector: NSObject, WCSessionDelegate, ObservableObject{
    
    var session: WCSession
    var smokeStore: SmokeStore
    
    init(session: WCSession = .default, smokeStore: SmokeStore){
        
        self.session = session
        self.smokeStore = smokeStore
        super.init()
        session.delegate = self
        session.activate()
    }
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print ("iOS activationDidCompleteWith")
    }
    
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print ("iOS didReceiveMessage with replyhandler ")

        // DO SOMETHING HERE THEN REPLY

        replyHandler(message as [String: Any])
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print(message)
        let newSmoke = Smoke(start: message["start"] as? Date ?? Date.now,
                             end: message["end"] as? Date ?? Date.now,
                             emotion: message["emotion"] as? String ?? "Unknown",
                             cigarettesSmoked: message["cigarettesSmoked"] as? Int ?? 0)
        
        DispatchQueue.main.async {
            self.smokeStore.addSmoke(smoke: newSmoke)  
        }
    }
    
}
