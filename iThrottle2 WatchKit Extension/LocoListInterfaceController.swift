//
//  LocoListInterfaceController.swift
//  iThrottle2
//
//  Created by Andrea Terzani on 01/12/15.
//  Copyright © 2015 Andrea Terzani. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class LocoListInterfaceController: WKInterfaceController {

    @IBOutlet var tableView: WKInterfaceTable!
    
    let locoManager = LocoManager.sharedInstance
    
    
    func setupTable (){
        
            tableView.setNumberOfRows(locoManager.locos.count, withRowType: "LocoRow")
        
        for var i = 0; i < locoManager.locos.count; ++i {
            if let row = tableView.rowControllerAtIndex(i) as? LocoRow {
                row.locoNameLabel.setText(locoManager.locos[i].name)
            }
        }
        
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        self.pushControllerWithName("locoControl", context: locoManager.locos[rowIndex])
    }
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
       
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        let request = ["command":"GETLOCO"]
        
        if WCSession.defaultSession().reachable == true {
            
            
            let session = WCSession.defaultSession()
            session.sendMessage(request, replyHandler: { reply in

                
                let locoStr = reply["LocoList"] // name | address | bus
               
                if (locoStr != nil){
                    
                    self.locoManager.locos.removeAll()
                    
                    for object in locoStr as! [String] {
                        let locoArr = object.characters.split{$0 == "|"}.map(String.init)
                        
                        let loco:Loco = Loco()
                        loco.set(locoArr[0], address: Int16(locoArr[1])!, bus: Int16(locoArr[2])!, speedMax: Int16(locoArr[3])!)
                      
                        self.locoManager.locos.append(loco);
                    }
                    
                    self.setupTable()
                }
            
                
               
            }, errorHandler: { error in
                print("error: \(error)")
            })
            
        }
        self.setupTable()

        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
