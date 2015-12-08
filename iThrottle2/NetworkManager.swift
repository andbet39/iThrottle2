//
//  NetworkManager.swift
//  iThrottle2
//
//  Created by Andrea Terzani on 05/12/15.
//  Copyright © 2015 Andrea Terzani. All rights reserved.
//

import UIKit


protocol NetworkManagerDelegate{
    func consumeMessage()
}

class NetworkManager: NSObject , NSStreamDelegate {
    static let sharedInstance = NetworkManager()

    var messages=[String]()
    var delegate:NetworkManagerDelegate?
    
    
    let serverAddress: CFString = "localhost"
    let serverPort: UInt32 = 4303
    
    private var inputStream: NSInputStream!
    private var outputStream: NSOutputStream!
    
    func connect() {
        
        var readStream:  Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(nil, self.serverAddress, self.serverPort, &readStream, &writeStream)
    
        
        self.inputStream = readStream!.takeRetainedValue()
        self.outputStream = writeStream!.takeRetainedValue()
        
        self.inputStream.delegate = self
        self.outputStream.delegate = self
        
        self.inputStream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        self.outputStream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        
        self.inputStream.open()
        self.outputStream.open()
        
    }
    
    
    func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        switch (eventCode){
        case NSStreamEvent.OpenCompleted:
            NSLog("Stream opened")
            break
            
            
        case NSStreamEvent.HasBytesAvailable:

            var buffer = [UInt8](count: 1024, repeatedValue: 0)
            if ( aStream == inputStream){
                while (inputStream.hasBytesAvailable){
                    var len = inputStream.read(&buffer, maxLength: buffer.count)
                    if(len > 0){
                        var output = NSString(bytes: &buffer, length: buffer.count, encoding: NSUTF8StringEncoding)
                        if (output != ""){
                           processInput(output!)
                            delegate?.consumeMessage()
                        }
                    }
                } 
            }
            break
            
            
        case NSStreamEvent.ErrorOccurred:
            NSLog("ErrorOccurred")
            break
        case NSStreamEvent.EndEncountered:
            NSLog("EndEncountered")
            break
        default:
            NSLog("unknown.")
        }
    }
    
    
    func sendMessage(message:String){
        
        let mess = (message as String) + "\n"
        let data = message.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        outputStream.write(UnsafePointer(data.bytes), maxLength: data.length)

    }
    
    
    func processInput(input:NSString){
    
            let messArray = input.componentsSeparatedByString("\n")
            for mess in messArray
            {
                if(!mess.containsString("\0\0\0\0\0\0\0\0")){
                    messages.append(mess)
                }
            }
        
        
    }
    
}
