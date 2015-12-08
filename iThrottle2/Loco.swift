//
//  Loco.swift
//  iThrottle2
//
//  Created by Andrea Terzani on 01/12/15.
//  Copyright © 2015 Andrea Terzani. All rights reserved.
//
import UIKit
import RealmSwift

class Loco:Object{
    
    dynamic var name:String=""
    
    dynamic var speed:Int16=0
    dynamic var address:Int16=0
    dynamic var bus:Int16=0
    dynamic var speedMax:Int16=0
    dynamic var img:String=""
    
    dynamic var imageData:NSData?
    var direction=0
    
    
    var f:[Bool]=[false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
    

   
    
    func set(name: String, address:Int16,bus:Int16,speedMax:Int16,img:String) {
        
        
        self.name = name
        self.address=address
        self.bus=bus
        self.speedMax = speedMax
        self.img = img
        
        
    }
    
    override static func ignoredProperties() -> [String] {
        return ["f","speed","direction"]
    }
    
    
    
    func image() -> UIImage? {
        
        var image = UIImage(named: "FS.JPG")

        if(self.imageData != nil){
             image = UIImage(data: self.imageData!)
        }
        
        return image
        
    }
    
   

}
