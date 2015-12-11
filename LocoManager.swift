
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
        let realm = try! Realm()
        
        let dbloco = realm.objects(Loco)

        
        for loco in dbloco
        {
            let strLoco = "\(loco.name)|\(loco.address)|\(loco.bus)|\(loco.speedMax)"
            lista.append(strLoco)
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
    
    func deleteLoco(loco:Loco){
    
        var idx = -1
        
        for (var i=0;i<self.locos?.count;i++){
            if(self.locos![i] == loco){
                idx=i
            }
        }
        
        if(idx > -1){
            self.locos?.removeAtIndex(idx);
        }
        
        let realm = try! Realm()
        try! realm.write {
            realm.delete(loco)
        }
        
      //  self.locos?.removeAtIndex(loco)

    }
    
    func updateLoco(loco:Loco){
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(loco)
        }
        
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
