//
//  EditLocoViewController.swift
//  iThrottle2
//
//  Created by Andrea Terzani on 09/12/15.
//  Copyright © 2015 Andrea Terzani. All rights reserved.
//

import UIKit

import Toucan
import ChameleonFramework
import RealmSwift

protocol EditLocoViewControllerDelegate{
    func didUpdateLoco(loco:Loco)
    func didDeleteLoco(loco:Loco)
}

class EditLocoViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate,UIAlertViewDelegate  {
    
    var loco:Loco?;
    var delegate:EditLocoViewControllerDelegate?

    
    var baseViewHeight:CGFloat = 0
    
    @IBOutlet weak var busLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var takePicBtn: UIButton!
    var imagePicker: UIImagePickerController!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var speedText: UITextField!
    @IBOutlet weak var busText: UITextField!
    @IBOutlet weak var takePictureBtn: UIButton!
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    
    
    @IBOutlet weak var trashNtn: UIButton!
    @IBAction func takePictureBtn(sender: AnyObject) {
        
        
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
        
    }

    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("Got an image")
        if let pickedImage:UIImage = (info[UIImagePickerControllerOriginalImage]) as? UIImage {
            let resized = Toucan(image: pickedImage).resize(CGSize(width: 400, height: 230), fitMode: Toucan.Resize.FitMode.Crop).image
            self.imageView.image = resized
            
        }
        imagePicker.dismissViewControllerAnimated(true, completion: {
            self.styleView()
            self.addGradient()
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("User canceled image")
        dismissViewControllerAnimated(true, completion: {
            // Anything you want to happen when the user selects cancel
        })
    }
    
    @IBAction func cancelBtnAction(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    
    
    
    func styleView(){
        
        
        let avgColor = UIColor(averageColorFromImage: self.imageView.image)
        let imgColors = ColorsFromImage( self.imageView.image!, withFlatScheme: true)
        
        self.view.backgroundColor =  avgColor //imgColors[3]
        
        
        let contrastColor  = ContrastColorOf( self.view.backgroundColor! , returnFlat: true)
        
        
        self.navigationBar.tintColor = contrastColor
        self.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.translucent = true
 
        self.busLabel.textColor = contrastColor
        self.nameLabel.textColor = contrastColor
        self.speedLabel.textColor = contrastColor
        self.addressLabel.textColor = contrastColor
        
        self.cancelBtn.tintColor = imgColors[4]
        self.saveBtn.tintColor = imgColors[4]
        
        
        let trashBtnImg = UIImage (named: "trash")?.imageWithRenderingMode(.AlwaysTemplate)
        self.trashNtn.setImage(trashBtnImg , forState: .Normal)
        self.trashNtn.tintColor = imgColors[4]
        
        let picBtnImg = UIImage (named: "pictBtn")?.imageWithRenderingMode(.AlwaysTemplate)
        self.takePicBtn.setImage(picBtnImg , forState: .Normal)
        self.takePicBtn.tintColor = imgColors[4]
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        addGradient()
    
        
    }
    
    func addGradient(){
        
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.imageView.frame
        gradientLayer.startPoint = CGPointZero;
        gradientLayer.endPoint = CGPointMake(0, 1);
        gradientLayer.locations = [0.7,1]
        
        gradientLayer.colors = [UIColor.clearColor().CGColor,(self.view.backgroundColor?.CGColor)!]
        self.imageView.layer.addSublayer(gradientLayer)
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.baseViewHeight = self.view.frame.origin.y
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        
        self.addressText.delegate = self;
        self.speedText.delegate = self;
        self.busText.delegate = self;
        self.nameText.delegate = self;
        
        self.addressText.text = String(loco!.address)
        self.nameText.text = loco!.name
        self.busText.text = String(loco!.bus)
        self.speedText.text = String(loco!.speedMax)
        
        self.imageView.image = loco!.image()
        
        self.styleView()
        
        
    }
    
    @IBAction func saveLoco(sender: AnyObject) {
        
        if(validatefields()){
            let realm = try! Realm()
       
            try! realm.write {
         
                self.loco!.set(self.nameText.text!, address: Int16(self.addressText.text!)!, bus: Int16(self.busText.text!)!, speedMax: Int16(self.speedText.text!)!, img:  "")
                if(self.imageView.image != nil){
                    self.loco!.imageData = UIImagePNGRepresentation(self.imageView.image!);
                }
            }
        
        
            self.dismissViewControllerAnimated(true) { () -> Void in
                self.delegate?.didUpdateLoco(self.loco!)
           
            }
        }
        
    }
    
    
    func validatefields() ->Bool{
        
        var msg=""
        if(nameText.text == ""){
            msg="Name cannot be null."
        }
        if(Int(speedText.text!) == nil)
        {
            msg="Decoder steps must be a number."
            
        }
        
        if(Int(busText.text!) == nil)
        {
            msg="Bus must be a number."
            
        }
        if(Int(addressText.text!) == nil)
        {
            msg="Address must be a number."
            
        }
        
        if(msg != ""){
            
            // Initialize Alert View
            let alertView = UIAlertView(title: "Alert", message: msg, delegate: self, cancelButtonTitle: "Ok")
            
            // Configure Alert View
            alertView.tag = 2
            
            // Show Alert View
            alertView.show()
            
            return false
            
        }
        return true
        
    }

    
    @IBAction func deleteBtnAction(sender: AnyObject) {
    
        // Initialize Alert View
        let alertView = UIAlertView(title: "Alert", message: "Are you sure to delete this loco ?", delegate: self, cancelButtonTitle: "Yes", otherButtonTitles: "No")
        
        // Configure Alert View
        alertView.tag = 1
        
        // Show Alert View
        alertView.show()
        
        
    
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView.tag == 1 {
            if buttonIndex == 0 {
                
                //Delete the loco
                self.dismissViewControllerAnimated(false) { () -> Void in
                    self.delegate?.didDeleteLoco(self.loco!)
                }
            }
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y = self.baseViewHeight - keyboardSize.height
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y =  self.baseViewHeight
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}
