//
//  ButtonViewController.swift
//  MaterialKit
//
//  Created by LeVan Nghia on 11/14/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

import UIKit
import QuartzCore

class ButtonViewController: UIViewController {

    @IBOutlet var raisedButton: MKButton!
    
    @IBOutlet var flatButton1: MKButton!
    @IBOutlet var flatButton2: MKButton!
    
    @IBOutlet var imageButton1: MKButton!
    @IBOutlet var imageButton2: MKButton!
    
    @IBOutlet var floatButton1: MKButton!
    @IBOutlet var floatButton2: MKButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
            
        flatButton2.maskEnabled = true
        flatButton2.ripplePercent = 0.5
        flatButton2.rippleLocation = .Center
        
        imageButton1.rippleLayerColor = UIColor.MKColor.DeepOrange
        imageButton1.maskEnabled = true
        
        imageButton2.ripplePercent = 1.2
        imageButton2.rippleLocation = .Center
        
        floatButton1.cornerRadius = 40.0
        floatButton1.maskEnabled = true
        floatButton1.ripplePercent = 1.75
        floatButton1.rippleLocation = .Center
        
        floatButton1.layer.shadowOpacity = 0.75
        floatButton1.layer.shadowRadius = 3.5
        floatButton1.layer.shadowColor = UIColor.blackColor().CGColor
        floatButton1.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        
        floatButton2.cornerRadius = 40.0
        floatButton2.layer.shadowOpacity = 0.75
        floatButton2.layer.shadowRadius = 3.5
        floatButton2.layer.shadowColor = UIColor.blackColor().CGColor
        floatButton2.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
    }

    func buttonPressed() {
        print("Button pressed")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

