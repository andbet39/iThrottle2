//
//  LocoControlViewController.swift
//  iThrottle2
//
//  Created by Andrea Terzani on 05/12/15.
//  Copyright © 2015 Andrea Terzani. All rights reserved.
//

import UIKit
import ChameleonFramework
import Toucan
import RealmSwift


protocol  LocoControlViewControllerDelegate{
    func didUpdateLoco(loco:Loco)
    func didDeleteLoco(loco:Loco)
}

class LocoControlViewController: UIViewController,EditLocoViewControllerDelegate {

    
    var delegate:LocoControlViewControllerDelegate?
    
    
    let realm = try! Realm()
    
    let isFLAT = true
    var loco:Loco = Loco()
    
    var speed:Int16 = 0
    var last_speed:Int16 = 0
    
    let SRCP:SRCPManager = SRCPManager.sharedInstance
    var timer:NSTimer?
    
    @IBOutlet weak var locoNameLabel: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    
    @IBOutlet weak var speedLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var speedSlider: UISlider!
    
    @IBOutlet weak var dirButton: UIButton!
    @IBOutlet weak var f0btn: UIButton!
    @IBOutlet weak var f1btn: UIButton!
    @IBOutlet weak var f2btn: UIButton!
    @IBOutlet weak var f3btn: UIButton!
    @IBOutlet weak var f4btn: UIButton!
    @IBOutlet weak var f5btn: UIButton!
    @IBOutlet weak var f6btn: UIButton!
    @IBOutlet weak var f7btn: UIButton!
    @IBOutlet weak var f8btn: UIButton!
    @IBOutlet weak var f9btn: UIButton!
    @IBOutlet weak var f10btn: UIButton!
    @IBOutlet weak var f11btn: UIButton!
    @IBOutlet weak var f12btn: UIButton!
    @IBOutlet weak var f13btn: UIButton!
    @IBOutlet weak var f14btn: UIButton!

    @IBOutlet weak var emergencyButton: UIButton!
    
    var locoImage:UIImage!
    
    var btnBaseColor:UIColor?
    var originalBarColor:UIColor?
    var barTintColor:UIColor?
    var isGoingToedit:Bool=false
    
    
    func styleView(){
        
        
        
        let avgColor = UIColor(averageColorFromImage: mainImg.image)
        let imgColors = ColorsFromImage( mainImg.image!, withFlatScheme: isFLAT)
        
        self.view.backgroundColor =  avgColor //imgColors[3]
        
        
        let contrastColor  = ContrastColorOf( self.view.backgroundColor! , returnFlat: isFLAT)

        self.locoNameLabel.textColor = contrastColor
        originalBarColor = self.navigationController?.navigationBar.tintColor
      
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true
        self.navigationController!.view.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.tintColor = imgColors[4]
        barTintColor = imgColors[4]
        
        let inset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        let backBtnImg = UIImage(named: "backBtn")?.imageWithAlignmentRectInsets(inset)
        
        navigationController?.navigationBar.backIndicatorImage = backBtnImg
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backBtnImg
        self.navigationController?.navigationBar.topItem!.title = "";
        
        self.speedSlider.thumbTintColor = imgColors[4]
        
        self.speedSlider.tintColor = contrastColor
        
        self.speedLabel.textColor = contrastColor
        self.addressLabel.textColor = contrastColor
        
         btnBaseColor = imgColors[4]
        
        self.f0btn.layer.cornerRadius=5
        self.f1btn.layer.cornerRadius=5
        self.f2btn.layer.cornerRadius=5
        self.f3btn.layer.cornerRadius=5
        self.f4btn.layer.cornerRadius=5
        self.f5btn.layer.cornerRadius=5
        self.f6btn.layer.cornerRadius=5
        self.f7btn.layer.cornerRadius=5
        self.f8btn.layer.cornerRadius=5
        self.f9btn.layer.cornerRadius=5
        self.f10btn.layer.cornerRadius=5
        self.f11btn.layer.cornerRadius=5
        self.f12btn.layer.cornerRadius=5
        self.f13btn.layer.cornerRadius=5
        self.f14btn.layer.cornerRadius=5
        
        self.f0btn.backgroundColor = btnBaseColor
        self.f1btn.backgroundColor = btnBaseColor
        self.f2btn.backgroundColor = btnBaseColor
        self.f3btn.backgroundColor = btnBaseColor
        self.f4btn.backgroundColor = btnBaseColor
        self.f5btn.backgroundColor = btnBaseColor
        self.f6btn.backgroundColor = btnBaseColor
        self.f7btn.backgroundColor = btnBaseColor
        self.f8btn.backgroundColor = btnBaseColor
        self.f9btn.backgroundColor = btnBaseColor
        self.f10btn.backgroundColor = btnBaseColor
        self.f11btn.backgroundColor = btnBaseColor
        self.f12btn.backgroundColor = btnBaseColor
        self.f13btn.backgroundColor = btnBaseColor
        self.f14btn.backgroundColor = btnBaseColor
        
        self.f0btn.tintColor = ContrastColorOf( self.f0btn.backgroundColor! , returnFlat: isFLAT)
        self.f1btn.tintColor = ContrastColorOf( self.f0btn.backgroundColor! , returnFlat: isFLAT)
        self.f2btn.tintColor = ContrastColorOf( self.f0btn.backgroundColor! , returnFlat: isFLAT)
        self.f3btn.tintColor = ContrastColorOf( self.f0btn.backgroundColor! , returnFlat: isFLAT)
        self.f4btn.tintColor = ContrastColorOf( self.f0btn.backgroundColor! , returnFlat: isFLAT)
        self.f5btn.tintColor = ContrastColorOf( self.f0btn.backgroundColor! , returnFlat: isFLAT)
        self.f6btn.tintColor = ContrastColorOf( self.f0btn.backgroundColor! , returnFlat: isFLAT)
        self.f7btn.tintColor = ContrastColorOf( self.f0btn.backgroundColor! , returnFlat: isFLAT)
        self.f8btn.tintColor = ContrastColorOf( self.f0btn.backgroundColor! , returnFlat: isFLAT)
        self.f9btn.tintColor = ContrastColorOf( self.f0btn.backgroundColor! , returnFlat: isFLAT)
        self.f10btn.tintColor = ContrastColorOf( self.f0btn.backgroundColor! , returnFlat: isFLAT)
        self.f11btn.tintColor = ContrastColorOf( self.f0btn.backgroundColor! , returnFlat: isFLAT)
        self.f12btn.tintColor = ContrastColorOf( self.f0btn.backgroundColor! , returnFlat: isFLAT)
        self.f13btn.tintColor = ContrastColorOf( self.f0btn.backgroundColor! , returnFlat: isFLAT)
        self.f14btn.tintColor = ContrastColorOf( self.f0btn.backgroundColor! , returnFlat: isFLAT)
        
        self.dirButton.backgroundColor = btnBaseColor
        self.dirButton.layer.cornerRadius = 5
        self.dirButton.tintColor = ContrastColorOf( self.f0btn.backgroundColor! , returnFlat: isFLAT)
        
        
        self.emergencyButton.backgroundColor = btnBaseColor
        self.emergencyButton.layer.cornerRadius = 5
        self.emergencyButton.tintColor = ContrastColorOf( self.emergencyButton.backgroundColor! , returnFlat: isFLAT)
        


    }
    
    func addGradient(){
        
    
    
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = mainImg.frame
        gradientLayer.startPoint = CGPointZero;
        gradientLayer.endPoint = CGPointMake(0, 1);
        gradientLayer.locations = [0.7,1]
        
        gradientLayer.colors = [UIColor.clearColor().CGColor,(self.view.backgroundColor?.CGColor)!]
        mainImg.layer.addSublayer(gradientLayer)
        
        
    
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if(!isGoingToedit){
            addGradient()
            isGoingToedit=false
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
       /* self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true
        self.navigationController!.view.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.tintColor = barTintColor*/
    }
    override func viewDidLayoutSubviews() {
        
        
    }
    
    @IBAction func emrgencyBtn(sender: AnyObject) {
        
        self.loco.direction=2
        self.loco.speed=0
        self.speedSlider.value=0
        
         SRCP.setLoco(loco)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = ""
    
        self.last_speed=loco.speed;
        self.speedSlider.value = Float(loco.speed)
        self.speedLabel.text = "Speed : \(loco.speed)"
        self.addressLabel.text = "Address : \(loco.address)"
    
        
        self.mainImg.image = loco.image()
        
        locoNameLabel.text=loco.name
        
        if(loco.direction == 0){
            self.dirButton.setTitle("<", forState: UIControlState.Normal)
        }else{
            self.dirButton.setTitle(">", forState: UIControlState.Normal)
        }
        
        
       
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "backButton")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        styleView()
        
         timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "update", userInfo: nil, repeats: true)

        
    }
    
    
    func update(){
     
        self.updateInterface()
        SRCP.askUpdateForLoco(self.loco)
        
    }
    
    
    func updateInterface(){
        
        self.speedSlider.value = Float(loco.speed)
        self.speedLabel.text = "Speed : \(loco.speed)"
        self.addressLabel.text = "Address : \(loco.address)"
        
        
        if(loco.direction == 0){
            self.dirButton.setTitle("<", forState: UIControlState.Normal)
        }else{
            self.dirButton.setTitle(">", forState: UIControlState.Normal)
        }
        
    
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        timer!.invalidate()
        if(!isGoingToedit){
            self.navigationController?.navigationBar.tintColor = originalBarColor
        
            self.navigationController!.navigationBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
            self.navigationController!.navigationBar.shadowImage = nil //UIImage()
            self.navigationController!.navigationBar.translucent = true
        }
    }
    
    @IBAction func speedSliderChanged(sender: AnyObject) {
        
        let slider = sender as! UISlider
        
        speed=Int16(slider.value)
        
        if(speed != last_speed){
            
            self.loco.speed = Int16(slider.value)
            last_speed=speed
            speedLabel.text = "Speed : \(speed)"

            SRCP.setLoco(self.loco)

        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func dirBtnAction(sender: AnyObject) {
        
        
        if(loco.direction > 0 ){
            loco.direction = 0
            self.dirButton.setTitle("<",forState: UIControlState.Normal)
        }else{
            loco.direction = 1
            self.dirButton.setTitle(">",forState: UIControlState.Normal)        }
        
        SRCP.setLoco(loco)
    }
    

    
    @IBAction func f0Btn(sender: AnyObject) {
        
        let btn = sender as! UIButton
        
        if(loco.f[0] == false){
            self.loco.f[0]=true
            btn.backgroundColor = self.btnBaseColor?.darkenByPercentage(0.4)
        }else{
            self.loco.f[0]=false
            btn.backgroundColor = self.btnBaseColor
        }
        
        SRCP.setLoco(self.loco)

    }
    
    @IBAction func f1Btn(sender: AnyObject) {
        
        let btn = sender as! UIButton
        
        if(loco.f[1] == false){
            loco.f[1]=true
            btn.backgroundColor = self.btnBaseColor?.darkenByPercentage(0.4)
        }else{
            loco.f[1]=false
            btn.backgroundColor = self.btnBaseColor
        }
        
         SRCP.setLoco(self.loco)
    }
    
    @IBAction func f2Btn(sender: AnyObject) {
        
        let btn = sender as! UIButton
        
        if(loco.f[2] == false){
            loco.f[2]=true
            btn.backgroundColor = self.btnBaseColor?.darkenByPercentage(0.4)
        }else{
            loco.f[2]=false
            btn.backgroundColor = self.btnBaseColor
        }
        
         SRCP.setLoco(self.loco)
    }
    
    @IBAction func f3Btn(sender: AnyObject) {
        
        let btn = sender as! UIButton
        
        if(loco.f[3] == false){
            loco.f[3]=true
            btn.backgroundColor = self.btnBaseColor?.darkenByPercentage(0.4)
        }else{
            loco.f[3]=false
            btn.backgroundColor = self.btnBaseColor
        }
        
         SRCP.setLoco(self.loco)
    }
    
    @IBAction func f4Btn(sender: AnyObject) {
        
        let btn = sender as! UIButton
        
        if(loco.f[4] == false){
            loco.f[4]=true
            btn.backgroundColor = self.btnBaseColor?.darkenByPercentage(0.4)
        }else{
            loco.f[4]=false
            btn.backgroundColor = self.btnBaseColor
        }
        
        SRCP.setLoco(self.loco)
        
    }
    
    @IBAction func f5Btn(sender: AnyObject) {
        
        let btn = sender as! UIButton
        
        if(loco.f[5] == false){
            loco.f[5]=true
            btn.backgroundColor = self.btnBaseColor?.darkenByPercentage(0.4)
        }else{
            loco.f[5]=false
            btn.backgroundColor = self.btnBaseColor
        }
        
         SRCP.setLoco(self.loco)
    }
    
    @IBAction func f6Btn(sender: AnyObject) {
        
        let btn = sender as! UIButton
        
        if(loco.f[6] == false){
            loco.f[6]=true
            btn.backgroundColor = self.btnBaseColor?.darkenByPercentage(0.4)
        }else{
            loco.f[6]=false
            btn.backgroundColor = self.btnBaseColor
        }
        
         SRCP.setLoco(self.loco)
    }
    
    @IBAction func f7Btn(sender: AnyObject) {
        
        let btn = sender as! UIButton
        
        if(loco.f[7] == false){
            loco.f[7]=true
            btn.backgroundColor = self.btnBaseColor?.darkenByPercentage(0.4)
        }else{
            loco.f[7]=false
            btn.backgroundColor = self.btnBaseColor
        }
        
         SRCP.setLoco(self.loco)
    }
    
    @IBAction func f8Btn(sender: AnyObject) {
        
        let btn = sender as! UIButton
        
        if(loco.f[8] == false){
            loco.f[8]=true
            btn.backgroundColor = self.btnBaseColor?.darkenByPercentage(0.4)
        }else{
            loco.f[8]=false
            btn.backgroundColor = self.btnBaseColor
        }
        
         SRCP.setLoco(self.loco)
    }
    
    @IBAction func f9Btn(sender: AnyObject) {
        
        let btn = sender as! UIButton
        
        if(loco.f[9] == false){
            loco.f[9]=true
            btn.backgroundColor = self.btnBaseColor?.darkenByPercentage(0.4)
        }else{
            loco.f[9]=false
            btn.backgroundColor = self.btnBaseColor
        }
        
         SRCP.setLoco(self.loco)
    }
    
    @IBAction func f10Btn(sender: AnyObject) {
        
        let btn = sender as! UIButton
        
        if(loco.f[10] == false){
            loco.f[10]=true
            btn.backgroundColor = self.btnBaseColor?.darkenByPercentage(0.4)
        }else{
            loco.f[10]=false
            btn.backgroundColor = self.btnBaseColor
        }
        
         SRCP.setLoco(self.loco)
    }
    
    @IBAction func f11Btn(sender: AnyObject) {
        
        let btn = sender as! UIButton
        
        if(loco.f[11] == false){
            loco.f[11]=true
            btn.backgroundColor = self.btnBaseColor?.darkenByPercentage(0.4)
        }else{
            loco.f[11]=false
            btn.backgroundColor = self.btnBaseColor
        }
        
         SRCP.setLoco(self.loco)
    }
    
    @IBAction func f12Btn(sender: AnyObject) {
        
        let btn = sender as! UIButton
        
        if(loco.f[12] == false){
            loco.f[12]=true
            btn.backgroundColor = self.btnBaseColor?.darkenByPercentage(0.4)
        }else{
            loco.f[12]=false
            btn.backgroundColor = self.btnBaseColor
        }
        
         SRCP.setLoco(self.loco)
    }
    
    @IBAction func f13Btn(sender: AnyObject) {
        
        let btn = sender as! UIButton
        
        if(loco.f[13] == false){
            loco.f[13]=true
            btn.backgroundColor = self.btnBaseColor?.darkenByPercentage(0.4)
        }else{
            loco.f[13]=false
            btn.backgroundColor = self.btnBaseColor
        }
        
         SRCP.setLoco(self.loco)
    }
    
    @IBAction func f14Btn(sender: AnyObject) {
        
        let btn = sender as! UIButton
        
        if(loco.f[14] == false){
            loco.f[14]=true
            btn.backgroundColor = self.btnBaseColor?.darkenByPercentage(0.4)
        }else{
            loco.f[14]=false
            btn.backgroundColor = self.btnBaseColor
        }
        
         SRCP.setLoco(self.loco)
    }
    
    
    @IBAction func editButtonAction(sender: AnyObject) {
        timer?.invalidate()

        self.performSegueWithIdentifier("EditLocoSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "EditLocoSegue" {
            
                if let destinationVC = segue.destinationViewController as? EditLocoViewController{
                    isGoingToedit = true
                    destinationVC.loco  = self.loco
                    destinationVC.delegate = self
                }
            
        }
    }
    
    func didUpdateLoco(loco:Loco)
    {
        self.loco=loco
        
        self.last_speed=loco.speed;
        self.speedSlider.value = Float(loco.speed)
        self.speedLabel.text = "Speed : \(loco.speed)"
        self.addressLabel.text = "Address : \(loco.address)"
        
        
        self.mainImg.image = loco.image()
        
        locoNameLabel.text=loco.name
        
        if(loco.direction == 0){
            self.dirButton.setTitle("<", forState: UIControlState.Normal)
        }else{
            self.dirButton.setTitle(">", forState: UIControlState.Normal)
        }
        
        
        
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "backButton")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        styleView()
        addGradient()
        
        delegate?.didUpdateLoco(loco)
        
        
        //timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "update", userInfo: nil, repeats: true)
        

    }
    
    
    func didDeleteLoco(loco: Loco) {
            timer?.invalidate()
            self.navigationController?.popToRootViewControllerAnimated(false)
            delegate?.didDeleteLoco(loco)
        
    }
}
