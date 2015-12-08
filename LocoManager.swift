
//
//  LocoManager.swift
//  iThrottle2
//
//  Created by Andrea Terzani on 01/12/15.
//  Copyright © 2015 Andrea Terzani. All rights reserved.
//

import UIKit
import RealmSwift

class LocoManager {

    static let sharedInstance = LocoManager()
    
    var locos:[Loco]?
    
    init?() {
        

        let realm = try! Realm()
   
        let dbloco = realm.objects(Loco)
        self.locos = Array(dbloco)
        

    }
    
    func getLocoList() ->[String]{
        
        var lista = [String]()
        
        for loco in self.locos!
        {
            lista.append(loco.name)
        }
        
        return lista
    }
    
    
    func saveLoco(loco:Loco){

        let realm = try! Realm()
        try! realm.write {
            realm.add(loco)
        }
        
        self.locos?.append(loco);
    
    }
    
    
    func updateLocoWithLoco(newloco:Loco){
    
        for loco in self.locos!
        {
        
            if(loco.address == newloco.address  && loco.bus == newloco.bus){
            
                loco.speed = newloco.speed
                loco.direction = newloco.direction
            }
        
        }
    
    }
    
    
}
