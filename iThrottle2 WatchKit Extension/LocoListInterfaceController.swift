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
    
    var locos = [String]()
    
    func setupTable (){
        
            tableView.setNumberOfRows(locos.count, withRowType: "LocoRow")
        
        for var i = 0; i < locos.count; ++i {
            if let row = tableView.rowControllerAtIndex(i) as? LocoRow {
                row.locoNameLabel.setText(locos[i])
            }
        }
        
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        self.pushControllerWithName("locoControl", context: locos[rowIndex])
    }
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        let request = ["command":"GETLOCO"]
        
        if WCSession.defaultSession().reachable == true {
            
            
            let session = WCSession.defaultSession()
            session.sendMessage(request, replyHandler: { reply in

                
                let names = reply["LocoList"]
               
                if (names != nil){
                    
                    self.locos.removeAll()
                    
                    for object in names as! [String] {
                        let name = object
                        self.locos.append(name);
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
