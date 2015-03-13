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
      
        raisedButton.layer.shadowOpacity = 0.55
        raisedButton.layer.shadowRadius = 5.0
        raisedButton.layer.shadowColor = UIColor.grayColor().CGColor
        raisedButton.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        
        flatButton1.backgroundLayerColor = UIColor.MKColor.Lime
        flatButton1.layer.shadowOpacity = 0.5
        flatButton1.layer.shadowRadius = 5.0
        flatButton1.layer.shadowColor = UIColor.blackColor().CGColor
        flatButton1.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        
        flatButton2.maskEnabled = false
        flatButton2.ripplePercent = 0.5
        flatButton2.backgroundAniEnabled = false
        flatButton2.rippleLocation = .Center
        
        imageButton1.rippleLayerColor = UIColor.MKColor.DeepOrange
        
        imageButton2.maskEnabled = false
        imageButton2.ripplePercent = 1.2
        imageButton2.backgroundAniEnabled = false
        imageButton2.rippleLocation = .Center
        
        floatButton1.cornerRadius = 40.0
        floatButton1.backgroundLayerCornerRadius = 40.0
        floatButton1.maskEnabled = false
        floatButton1.ripplePercent = 1.75
        floatButton1.rippleLocation = .Center
        floatButton1.aniDuration = 0.85
        
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
        println("Button pressed")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

