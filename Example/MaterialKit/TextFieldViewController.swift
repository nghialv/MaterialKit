//
//  TextFieldViewController.swift
//  MaterialKit
//
//  Created by Le Van Nghia on 11/15/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//


import UIKit

class TextFieldViewController: UIViewController {
    @IBOutlet var textField1: MKTextField!
    @IBOutlet var textField2: MKTextField!
    @IBOutlet var textField3: MKTextField!
    @IBOutlet var textField4: MKTextField!
    @IBOutlet var textField5: MKTextField!
    @IBOutlet var textField6: MKTextField!
    
    override func viewDidLoad() {
        // No border, no shadow, floatPlaceHolderDisabled
        textField1.layer.borderColor = UIColor.clearColor().CGColor
        textField1.placeholder = "placeholder"
        textField1.tintColor = UIColor.grayColor()
        
        // Border, no shadow, floatPlaceHolderDisabled
        textField2.layer.borderColor = UIColor.MKColor.Grey.CGColor
        
        // No border, shadow, floatPlaceHolderDisabled
        /*
        textField1.layer.shadowOpacity = 1.0
        textField1.layer.shadowRadius = 1.5
        textField1.layer.shadowColor = UIColor.MKColor.Red.CGColor
        textField1.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        textField1.borderStyle = .None
        */
        
        // No border, no shadow, floatingPlaceholderEnabled
        textField4.layer.borderColor = UIColor.clearColor().CGColor
        textField4.floatingPlaceholderEnabled = true
        textField4.placeholder = "Your name"
        textField4.tintColor = UIColor.MKColor.Blue
        
        // No border, shadow, floatingPlaceholderEnabled
        textField5.floatingPlaceholderEnabled = true
        textField5.placeholder = "Github account"
        textField5.circleLayerColor = UIColor.MKColor.LightBlue
        
        // Border, floatingPlaceholderEnabled
        textField6.floatingPlaceholderEnabled = true
        textField6.cornerRadius = 1.0
        textField6.placeholder = "Description"
        textField6.layer.borderColor = UIColor.MKColor.Green.CGColor
        textField6.circleLayerColor = UIColor.MKColor.LightGreen
        textField6.tintColor = UIColor.MKColor.LightGreen
    }
}