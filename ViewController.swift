//
//  ViewController.swift
//  TwilioTalk
//
//  Created by swift on 12/4/14.
//  Copyright (c) 2014 Georgia Institute of Technology. All rights reserved.
//

import UIKit
import TwilioClientKit

class ViewController: UIViewController, TCDeviceDelegate {

    @IBOutlet var numberField : UITextField!
    var _phone : TCDevice!
    var _connection : TCConnection?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        #if TARGET_IPHONE_SIMULATOR
        var name = "tommy"
        #else
        var name = "jenny"
        #endif
        
        //check out https://github.com/twilio/mobile-quickstart to get a server up quickly
        let urlString = "http://twilioswift.herokuapp.com/token?client=\(name)"
        let url : NSURL! = NSURL(string: urlString)
        
        var error : NSError? = nil
        
        let result : String? = NSString(contentsOfURL: url, encoding: NSUTF8StringEncoding, error: &error)
        
        if let token = result{
            println("Received Token: \(token)")
            _phone = TCDevice(capabilityToken: token, delegate: self)
        }else{
            println("Error retrieving token: \(error?.localizedDescription)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dialButtonPressed(sender : AnyObject){
        var params : [String:String] = ["TO":self.numberField.text]
        println("Dial Button Pressed Calling: \(params)")
        _connection = _phone.connect(params, delegate: nil)
        
    }
    @IBAction func hangupButtonPressed(sender : AnyObject){
        if _connection != nil{
            _connection?.disconnect()
        }
    }

    func device(device: TCDevice!, didReceiveIncomingConnection connection: TCConnection!){
        println("Device: \(device) didReceiveIncomingConnection: \(connection)");
        if (device.state.value == TCDeviceStateBusy.value) {
            connection.reject()
        } else {
            connection.accept()
            _connection = connection;
        }
    }
    
    func deviceDidStartListeningForIncomingConnections(device: TCDevice!){
        println("Device: \(device) deviceDidStartListeningForIncomingConnections");
    }
    
    func device(device: TCDevice!, didStopListeningForIncomingConnections error: NSError!){
        println("Device: \(device) didStopListeningForIncomingConnections: \(error.localizedDescription)");
    }

    func device(device: TCDevice!, didReceivePresenceUpdate presenceEvent: TCPresenceEvent!){
        println("Device: \(device) didReceivePresenceUpdate: \(presenceEvent)");
    }

}

