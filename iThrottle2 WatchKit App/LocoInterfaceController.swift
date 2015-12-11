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
    
    @IBOutlet var nameLabel: WKInterfaceLabel!
    var speed: Int = 0
    var loco:Loco?
  
    @IBOutlet var addressLabel: WKInterfaceLabel!
    
    @IBOutlet var dirButton: WKInterfaceButton!
    @IBAction func dirButtonAction() {
        
        if(self.loco?.direction == 0)
        {
            self.loco?.direction = 1
            
        }else{
            self.loco?.direction = 0
        }
        
        
        if(loco?.direction == 0){
            self.dirButton .setTitle("<")
        }else{
            self.dirButton.setTitle(">")
            
        }
         LocoManager.sharedInstance.sendLocoUpdate(self.loco!)
    }
    
    @IBAction func fbuttonAction() {
        
        if(self.loco!.f[0] == false){
            self.loco!.f[0] = true
        }else{
             self.loco!.f[0] = false
        }
        
        
        if(self.loco!.f[0] == false){
            self.fbutton.setBackgroundColor(UIColor.lightGrayColor())
        }else{
            self.fbutton.setBackgroundColor(UIColor.darkGrayColor())
        }
         LocoManager.sharedInstance.sendLocoUpdate(self.loco!)
    }
    
    
    @IBOutlet var fbutton: WKInterfaceButton!
    @IBAction func emergencyButtonAction() {
        
        speedPicker.setSelectedItemIndex(0)
    }
    
    
    @IBAction func speedChangedAction(value: Int) {
        
        speed = value
        self.loco?.speed=Int16(speed)
        
        LocoManager.sharedInstance.sendLocoUpdate(self.loco!)

    }
    
    
    
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)

        self.loco  = context as! Loco
        
        self.addressLabel.setText("ID: \(loco!.address)")
        self.nameLabel.setText("\(loco!.name)")
        
        var speedItems:[WKPickerItem]=Array()
        
        for (var i=0;i < Int((loco?.speedMax)!);i++)
        {
            let pickerItem = WKPickerItem()
            pickerItem.title = "SPEED \(i)"
            
            speedItems.append(pickerItem)
        }
        speedPicker.setItems(speedItems)
        
    }

    override func willActivate() {
        super.willActivate()
        
        
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    

}
