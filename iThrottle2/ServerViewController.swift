//
//  ServerViewController.swift
//  iThrottle2
//
//  Created by Andrea Terzani on 08/12/15.
//  Copyright © 2015 Andrea Terzani. All rights reserved.
//

import UIKit
import RealmSwift

class ServerViewController: UIViewController,SRCPManagerDelegate ,UITableViewDataSource,UITableViewDelegate{

    let protocolManager = SRCPManager.sharedInstance
    let realm = try! Realm()
    
    
    var connections:Results<Server>?
    
    @IBOutlet weak var hostText: UITextField!
    @IBOutlet weak var portText: UITextField!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        protocolManager.delegate = self
        statusLabel.text = "Status : \(protocolManager.status)"
        
        connections = realm.objects(Server)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func connectBtn(sender: AnyObject) {
    
        protocolManager.connect(hostText.text!,port: portText.text!)
    
    }

    @IBAction func cancelBtn(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    
    func updatedStatus() {
        statusLabel.text = "Status : \(protocolManager.status)"

    }
    
    func didConnect() {
        statusLabel.text = "Status : \(protocolManager.status)"
        
        let server = Server()
        server.port = portText.text!
        server.host = hostText.text!
        
        
        let search = realm.objects(Server).filter("port = '\(server.port)' AND host = '\(server.host)'")

        if(search.count == 0)
        {
            try! realm.write {
                self.realm.add(server)
            }
        }
        
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    
    
    
     func  tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        portText.text = connections![indexPath.row].port
        hostText.text = connections![indexPath.row].host
        
        
    }
    
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connections!.count
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
            let cellIdentifier = "serverCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UITableViewCell
            
            cell.textLabel?.text = "\(connections![indexPath.row].host):\(connections![indexPath.row].port)"
            
            return cell
        
    }

}
