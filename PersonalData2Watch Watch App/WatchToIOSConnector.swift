//
//  WatchConnector.swift
//  PersonalData2
//
//  Created by bogdan on 17.04.2024.
//

import Foundation
import WatchConnectivity

class WatchToIOSConnector: NSObject, WCSessionDelegate, ObservableObject {
    
    var session: WCSession
    
    init(session: WCSession = .default){
        
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        
    }
    
    func sendSmokeToIOS(smoke:Smoke) {
        
        if session.isReachable{
            
            let data: [String:Any] = [
                "start": smoke.start,
                "end": smoke.end,
                "emotion": smoke.emotion ?? "Unknown",
                "cigarettesSmoked": smoke.cigarettesSmoked
                ]
            
            print(data)

           print("Send message")
            session.sendMessage(data, replyHandler: nil){
                error in print(error.localizedDescription)
            }
            print("Send message FINAL")
        }else{
            print("Session is not reacheable")
        }
    }
    
}
