//
//  LocoViewCell.swift
//  iThrottle2
//
//  Created by Andrea Terzani on 01/12/15.
//  Copyright © 2015 Andrea Terzani. All rights reserved.
//

import UIKit
import Toucan
import ChameleonFramework

class LocoViewCell: UITableViewCell {
    let SRCP:SRCPManager = SRCPManager.sharedInstance

    var timer:NSTimer?
    var loco:Loco?
    
    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var locoLabel: UILabel!
    
   
    
    @IBAction func speedSliderAction(sender: UISlider) {
        
        let speed = Int16(self.speedSlider.value)
        
        if(speed != loco?.speed){
            
            self.loco!.speed = speed
            
            SRCP.setLoco(self.loco!)
            
        }
        
    }
    
    @IBAction func dirBtnAction(sender: AnyObject) {
        
        
        if(loco?.direction == 1){
          loco?.direction = 0
            self.dirButton.setTitle("<", forState: UIControlState.Normal)
        }else{
            loco?.direction = 1
            self.dirButton.setTitle(">", forState: UIControlState.Normal)
        }
        
        SRCP.setLoco(loco!)
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if(loco?.imageData != nil){
            
            let img = UIImage(data: (loco?.imageData)!)
            let resized = Toucan(image: img! ).resize(CGSize(width: 400, height: 150), fitMode: Toucan.Resize.FitMode.Crop).image
            
            self.backgroundView = UIImageView(image: resized)
            self.selectedBackgroundView = UIImageView(image:resized)
            
            
            if(loco?.direction == 0){
                self.dirButton.setTitle("<", forState: UIControlState.Normal)
            }else{
                self.dirButton.setTitle(">", forState: UIControlState.Normal)
            }
            
            
            self.styleView()
            
            timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "update", userInfo: nil, repeats: true)
        }
    }
   
    func update(){
        
        self.updateInterface()
        SRCP.askUpdateForLoco(self.loco!)
        
    }
    
    
    func updateInterface(){
        
        self.speedSlider.value = Float(loco!.speed)
        
        
        if(loco!.direction == 0){
            self.dirButton.setTitle("<", forState: UIControlState.Normal)
        }else{
            self.dirButton.setTitle(">", forState: UIControlState.Normal)
        }
        
        
    }
    
    func styleView(){
        
        
        let img = UIImage(data: (loco?.imageData)!)
        
        let avgColor = UIColor(averageColorFromImage: img)
        let imgColors = ColorsFromImage( img!, withFlatScheme: true)
        
               
        
        let contrastColor  = ContrastColorOf( avgColor , returnFlat: true)
        
        self.locoLabel.textColor = contrastColor
        
        
        self.speedSlider.thumbTintColor = imgColors[4]
        
        
        let btnBaseColor = imgColors[4]
        
        self.dirButton.backgroundColor = btnBaseColor
        self.dirButton.layer.cornerRadius = 5
        self.dirButton.tintColor = ContrastColorOf( self.dirButton.backgroundColor! , returnFlat: true)
        
        self.speedSlider.tintColor = contrastColor
        
        self.speedSlider.value = Float(loco!.speed)
        self.speedSlider.maximumValue = Float(loco!.speedMax)
        
        
    }

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dirButton: UIButton!
    
}
