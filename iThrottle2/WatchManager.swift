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
            break
            
        case "SETLOCO" :
            
            NSLog("SETLOCO received")
            //let dictionary = ["command":"SETLOCO" , "BUS":Int(loco.bus) , "ADDRESS":Int(loco.address) , "SPEED":Int(loco.speed) , "DIR":Int(loco.direction)]

            let add = message["ADDRESS"]!.integerValue
            let bus = message["BUS"]!.integerValue
            let speed = message["SPEED"]!.integerValue
            let direction = message["DIR"]!.integerValue
            let f0 = message["F0"]!.integerValue
            
            
            
            let loco:Loco = Loco()
            
            
            loco.set("", address: Int16(add) , bus: Int16(bus) , speedMax: 0,img:"")
            loco.speed = Int16(speed)
            loco.direction = direction
            
            if(Int(f0!) == 0 )
            {
                loco.f[0] = false
            }else {
                loco.f[0] = true
            }
            
            for(var i=1;i<15;i++){
                loco.f[i]=false
            }
            
            SRCPManager.sharedInstance.setLoco(loco)
            
            break
            
            
        default:
            break
        }
        
        replyHandler(replyValues)
        
        
    }

    
    
}
