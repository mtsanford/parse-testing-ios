/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        NSLog("Document Path: %@", documentsPath)
        
        let button1   = UIButton(type: UIButtonType.System)
        button1.frame = CGRectMake(100, 100, 150, 50)
        button1.backgroundColor = UIColor.greenColor()
        button1.setTitle("Query & pin", forState: UIControlState.Normal)
        button1.addTarget(self, action: "button1Action:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let button2   = UIButton(type: UIButtonType.System)
        button2.frame = CGRectMake(100, 150, 150, 50)
        button2.backgroundColor = UIColor.greenColor()
        button2.setTitle("parse first", forState: UIControlState.Normal)
        button2.addTarget(self, action: "button2Action:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let button3   = UIButton(type: UIButtonType.System)
        button3.frame = CGRectMake(100, 200, 150, 50)
        button3.backgroundColor = UIColor.greenColor()
        button3.setTitle("local first", forState: UIControlState.Normal)
        button3.addTarget(self, action: "button3Action:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let button4   = UIButton(type: UIButtonType.System)
        button4.frame = CGRectMake(100, 250, 150, 50)
        button4.backgroundColor = UIColor.greenColor()
        button4.setTitle("unpin all", forState: UIControlState.Normal)
        button4.addTarget(self, action: "button4Action:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let button5   = UIButton(type: UIButtonType.System)
        button5.frame = CGRectMake(100, 250, 150, 50)
        button5.backgroundColor = UIColor.greenColor()
        button5.setTitle("modify & saveEventually", forState: UIControlState.Normal)
        button5.addTarget(self, action: "button5Action:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(button1)
        self.view.addSubview(button2)
        self.view.addSubview(button3)
        self.view.addSubview(button4)
        self.view.addSubview(button5)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Buttons
    
    func button1Action(sender:UIButton!)
    {
        print("Button1 tapped")
        var query = PFQuery(className:"TestObject")
        query.getObjectInBackgroundWithId("5Q1aAPe37q") {
            (testObject: PFObject?, error: NSError?) -> Void in
            if error == nil && testObject != nil {
                print(testObject)
                print("fetched from parse and pinned")
                testObject?.pinInBackground()
                
            } else {
                print(error)
            }
        }
    }
    
    func button2Action(sender:UIButton!)
    {
        print("Button2 tapped")
        var query = PFQuery(className:"TestObject")
        query.getObjectInBackgroundWithId("5Q1aAPe37q") {
            (testObject: PFObject?, error: NSError?) -> Void in
            if error == nil && testObject != nil {
                print("fetched from parse:")
                print(testObject)
                
                var queryLocal = PFQuery(className:"TestObject")
                queryLocal.fromLocalDatastore()
                queryLocal.getObjectInBackgroundWithId("5Q1aAPe37q") {
                    (testObject2: PFObject?, error: NSError?) -> Void in
                    if error == nil && testObject2 != nil {
                        print("fetched from local:")
                        print(testObject2)
                        if (testObject === testObject2) {
                            print("SAME OBJECT")
                        }
                        else {
                            print("DIFFERENT OBJECT")
                        }
                    } else {
                        print(error)
                    }
                }
            
            } else {
                print(error)
            }
        }
    }
    
    func button3Action(sender:UIButton!)
    {
        print("Button3 tapped")
        var queryLocal = PFQuery(className:"TestObject")
        queryLocal.fromLocalDatastore()
        queryLocal.getObjectInBackgroundWithId("5Q1aAPe37q") {
            (testObject: PFObject?, error: NSError?) -> Void in
            if error == nil && testObject != nil {
                print("fetched from local:")
                print(testObject)
                
                var query = PFQuery(className:"TestObject")
                query.getObjectInBackgroundWithId("5Q1aAPe37q") {
                    (testObject2: PFObject?, error: NSError?) -> Void in
                    if error == nil && testObject2 != nil {
                        print("fetched from parse:")
                        print(testObject2)
                        if (testObject === testObject2) {
                            print("SAME OBJECT")
                        }
                        else {
                            print("DIFFERENT OBJECT")
                        }
                    } else {
                        print(error)
                    }
                }
                
            } else {
                print(error)
            }
        }
    }
    
    func button4Action(sender:UIButton!)
    {
        print("Button4 tapped")
        PFObject.unpinAllObjectsInBackground()
    }
    
    func button5Action(sender:UIButton!)
    {
        print("Button3 tapped")
        let queryLocal = PFQuery(className:"TestObject")
        queryLocal.fromLocalDatastore()
        queryLocal.getObjectInBackgroundWithId("5Q1aAPe37q") {
            (testObject: PFObject?, error: NSError?) -> Void in
            if error == nil && testObject != nil {
                testObject!["foo"] = "Mustard"
                print("changed object")
                print(testObject)
                testObject?.saveEventually()
                
            } else {
                print(error)
            }
        }
    }

    
}
