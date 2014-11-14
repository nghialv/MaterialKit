//
//  ViewController.swift
//  MaterialKit
//
//  Created by LeVan Nghia on 11/14/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {

    @IBOutlet var raisedButton: MKButton!
    @IBOutlet var floatingActionButton: MKButton!
    @IBOutlet var flatButton: MKButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        //raisedButton.backgroundColor = UIColor.MKColor.Blue
        raisedButton.layer.shadowOpacity = 0.55
        raisedButton.layer.shadowRadius = 5.0
        raisedButton.layer.shadowColor = UIColor.grayColor().CGColor
        raisedButton.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        
        floatingActionButton.mkType = .FloatingAction
        floatingActionButton.layer.shadowOpacity = 0.75
        floatingActionButton.layer.shadowRadius = 3.5
        floatingActionButton.layer.shadowColor = UIColor.blackColor().CGColor
        floatingActionButton.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
       
        flatButton.mkType = .Flat
        flatButton.backgroundLayerColor = UIColor.MKColor.Lime
        
        /*
        flatButton.layer.shadowOpacity = 0.5
        flatButton.layer.shadowRadius = 5.0
        flatButton.layer.shadowColor = UIColor.blackColor().CGColor
        
        flatButton.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        */
    }

    func buttonPressed() {
        println("Button pressed")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

