//
//  BarButtonItemViewController.swift
//  MaterialKit
//
//  Created by Le Van Nghia on 11/29/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

import UIKit

class BarButtonItemViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let rightButton = MKBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "rightButtonPressed")
        let label = MKLabel(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        label.text = "+"
        label.textAlignment = .Center
        label.backgroundColor = UIColor.greenColor()
        
        let rightButton = UIBarButtonItem(customView: label)
        self.navigationItem.rightBarButtonItem = rightButton
        
        
        let label2 = MKLabel(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        label2.text = "MKLabel"
        label2.textAlignment = .Center
        label2.rippleLocation = .TapLocation
        label2.circleLayerColor = UIColor.MKColor.LightGreen
        
        self.view.addSubview(label2)
    }
    
    func rightButtonPressed() {
        
    }
}
