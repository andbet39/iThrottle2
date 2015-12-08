//
//  SRCPManager.swift
//  iThrottle2
//
//  Created by Andrea Terzani on 05/12/15.
//  Copyright © 2015 Andrea Terzani. All rights reserved.
//

import UIKit

class SRCPManager:NetworkManagerDelegate {

    
    static let sharedInstance = SRCPManager()
    
    var ready:Bool = false
    var connecting:Bool = false
    var settingProtocol:Bool = false
    var settingCommand:Bool = false
    var settingGo:Bool = false
    
    let net = NetworkManager.sharedInstance

    
    func connect(){
        net.delegate=self
        
        connecting = true;
        
        net.connect()
        net.sendMessage("SET PROTOCOL SRCP 0.8.4")
        settingProtocol=true
    }
    
    func setLoco(loco:Loco){
    
        if(ready){
            let tempLoco = loco
            var mess  = "SET \(tempLoco.bus) GL \(tempLoco.address) \(tempLoco.direction) \(tempLoco.speed) \(tempLoco.speedMax)"
            
            for f in loco.f
            {
                if(f==false){
                    mess+=" 0"
                }else{
                    mess+=" 1"
                }
            }
            print(mess)
            net.sendMessage(mess)
        }
    }
    
    func askUpdateForLoco(loco:Loco){
    
        if(ready){
            let mess = "GET \(loco.bus) GL \(loco.address)"
        
        
            print(mess)
            net.sendMessage(mess)
            
        }
    }
    
    func consumeMessage(){
    
        var toremove=[String]()
        
        for mess in net.messages
        {
            if(settingProtocol ){
                if(mess.containsString("201 OK")){
                    print(mess)
                    settingProtocol=false;
                    settingGo=true
                    toremove.append(mess)
                    net.sendMessage("GO")
                }
            }
            
            if(settingCommand){
                if(mess.containsString("202 OK")){
                    print(mess)
                    settingCommand=false;
                    settingGo=true
                    toremove.append(mess)
                    net.sendMessage("GO")
                    
                }
            }
            
            if(settingGo){
                if(mess.containsString("200 OK")){
                    print(mess) 
                    settingGo=false
                    ready=true;
                    toremove.append(mess)                    
                }
            }
            
            if(ready){
            
                if(mess.containsString("412 ERROR")){
                    toremove.append(mess)
                }
                if(mess.containsString("200 OK")){
                    toremove.append(mess)
                }
            }
            
            if(ready){
                if(mess.containsString("100 INFO")){
                    updateMessage(mess)
                    toremove.append(mess)
                }
                
            }
            
        }
        
        //Removing consumed messages
        for mess in toremove {
            if let index = net.messages.indexOf(mess) {
                net.messages.removeAtIndex(index)
            }
        }
    
    }
    
    func updateMessage(mess: String){
    
        //Locomotive update
        if(mess.containsString("GL")){
            //print(mess)
            let mess_part = mess.characters.split{$0 == " "}.map(String.init)
            
            let add = mess_part[5]
            let bus = mess_part[3]
            
            let loco = Loco()
            loco.address=Int16(add)!
            loco.bus=Int16(bus)!
            loco.speed = Int16(mess_part[7])!
            loco.direction = Int(mess_part[6])!
            
            LocoManager.sharedInstance!.updateLocoWithLoco(loco)
        
        }
    
    }
}
