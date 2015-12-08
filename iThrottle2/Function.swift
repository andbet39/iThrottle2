//
//  Function.swift
//  iThrottle2
//
//  Created by Andrea Terzani on 07/12/15.
//  Copyright © 2015 Andrea Terzani. All rights reserved.
//

import Foundation
import RealmSwift

class Function:Object
{
   dynamic var name:String=""
    var state:Bool=false

    
    func set(name:String,state:Bool){
        self.name=name
        self.state=state
    
    }

}