//
//  Looo.swift
//  iThrottle2
//
//  Created by Andrea Terzani on 10/12/15.
//  Copyright © 2015 Andrea Terzani. All rights reserved.
//

import UIKit

class Loco {

        
         var name:String=""
        
         var speed:Int16=0
         var address:Int16=0
         var bus:Int16=0
        var speedMax:Int16=0
         var img:String=""
        
        dynamic var imageData:NSData?
        var direction=0
        
        
        var f:[Bool]=[false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
        
        
        
        
        func set(name: String, address:Int16,bus:Int16,speedMax:Int16) {
            
            
            self.name = name
            self.address=address
            self.bus=bus
            self.speedMax = speedMax
         
            
            
        }
        
    
    
        
        
        
    }

