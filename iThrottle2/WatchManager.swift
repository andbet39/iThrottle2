//
//  WatchManager.swift
//  iThrottle2
//
//  Created by Andrea Terzani on 10/12/15.
//  Copyright © 2015 Andrea Terzani. All rights reserved.
//

import UIKit
import WatchConnectivity

class WatchManager:NSObject, WCSessionDelegate{
    static let sharedInstance = WatchManager()

    let locoManager:LocoManager = LocoManager.sharedInstance!
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void)
    {
        
        var replyValues = Dictionary<String, AnyObject>()
        
        switch message["command"] as! String {
        case "GETLOCO" :
            
            replyValues["LocoList"] = locoManager.getLocoList()
            
            
        default:
            break
        }
        
        replyHandler(replyValues)
        
        
    }

    
    
}
