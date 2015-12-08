//
//  ViewController.swift
//  iThrottle2
//
//  Created by Andrea Terzani on 01/12/15.
//  Copyright © 2015 Andrea Terzani. All rights reserved.
//

import UIKit

class ViewController: UITableViewController,NewLocoViewControllerDelegate{
    
    let locoManager  = LocoManager.sharedInstance
    var selectedLoco:Loco?
    let protocolManager = SRCPManager.sharedInstance
    
    @IBOutlet var locoTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Locomotives"
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.topItem!.title = "Locomotives";

    }

    @IBAction func connectButton(sender: AnyObject) {
        
        protocolManager.connect()
      
        
        
    }
    
    @IBAction func newLocoBtn(sender: AnyObject) {
        
        self.performSegueWithIdentifier("NewLocoControlSegue", sender: self)
    }

  
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "LocoControlSegue"
        {
            if let destinationVC = segue.destinationViewController as? LocoControlViewController{
                destinationVC.loco  = self.selectedLoco!
            }
        }
        
        if segue.identifier == "NewLocoControlSegue"
        {
            if let destinationVC = segue.destinationViewController as? NewLocoViewController{
                destinationVC.delegate  = self
            }
        }
        
        
    }
    
    
    override func  tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.row < locoManager?.locos?.count){
            self.selectedLoco = (locoManager?.locos![indexPath.row])!
            NSLog("Selected : \((self.selectedLoco?.name)!)")
            self.performSegueWithIdentifier("LocoControlSegue", sender: self)
        }
        else{
            self.performSegueWithIdentifier("NewLocoControlSegue", sender: self)
        
        }
        
    }
    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocoManager.sharedInstance!.locos!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        
        if(indexPath.row < locoManager?.locos?.count){
            let cellIdentifier = "LocoCell"
             let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! LocoViewCell
        
            let loco = locoManager!.locos![indexPath.row]
            cell.locoLabel.text = loco.name
            cell.loco=loco
            NSLog(loco.name)
            
            return cell
        }
        
        return UITableViewCell.init()
    }

    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    
    func didSaveNewLoco(loco: Loco) {
        
       // self.locoTableView.reloadData()
        
        self.locoTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: (locoManager?.locos?.count)!-1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Bottom)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

