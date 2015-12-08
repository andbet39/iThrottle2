//
//  LocoInterfaceController.swift
//  iThrottle2
//
//  Created by Andrea Terzani on 01/12/15.
//  Copyright © 2015 Andrea Terzani. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class LocoInterfaceController: WKInterfaceController {

    @IBOutlet var speedPicker: WKInterfacePicker!
    
    var speed: Int = 0
    
  
    
    @IBAction func emergencyButtonAction() {
        
        speedPicker.setSelectedItemIndex(0)
    }
    
    
    @IBAction func speedChangedAction(value: Int) {
        
        speed = value
        
        if WCSession.defaultSession().reachable == true {
            
            let dictionary = ["command":"CHANGE_SPEED_FOR_LOC"]
            
            let session = WCSession.defaultSession()
            
            session.sendMessage(dictionary, replyHandler: { reply in
                
                print("ok")
                
                }, errorHandler: { error in
                    print("error: \(error)")
            })
        }

    }
    
    
    @IBAction func directionButtonAction() {
        
            }
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
    }

    override func willActivate() {
        super.willActivate()
        
        
        let speedItems: [WKPickerItem] = (0...128).map {
            let pickerItem = WKPickerItem()
            pickerItem.title = "SPEED \($0)"
                
            return pickerItem
        }
        speedPicker.setItems(speedItems)
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    

}
