//
//  LocoManager.swift
//  iThrottle2
//
//  Created by Andrea Terzani on 10/12/15.
//  Copyright © 2015 Andrea Terzani. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class LocoManager: NSObject {

    static let sharedInstance = LocoManager()
    
    var locos:[Loco]=Array()
    
    func sendLocoUpdate(loco:Loco)
    {
    
        if WCSession.defaultSession().reachable == true {
            
            var f:Int=0
            
            if(loco.f[0]){
                f=1
            }else
            {
                f=0
            }
            
            let dictionary = ["command":"SETLOCO" , "BUS":Int(loco.bus) , "ADDRESS":Int(loco.address) , "SPEED":Int(loco.speed) , "DIR":Int(loco.direction), "STEP":Int(loco.speedMax), "F0":f]
            
            let session = WCSession.defaultSession()
            
            session.sendMessage(dictionary as! [String : AnyObject], replyHandler: { reply in
                
                print("ok")
                
                }, errorHandler: { error in
                    print("error: \(error)")
            })
        }
        
        
    }
}
