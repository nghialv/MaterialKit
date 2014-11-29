//
//  BarButtonItemViewController.swift
//  MaterialKit
//
//  Created by Le Van Nghia on 11/29/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

import UIKit

class BarButtonItemViewController: UIViewController {
    @IBOutlet var label: MKLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // customize UIBarButtonItem
        let imageView = MKImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 32))
        imageView.image = UIImage(named: "uibaritem_icon.png")
        imageView.backgroundAniEnabled = false
        imageView.rippleLocation = .Center
        imageView.circleGrowRatioMax = 1.15
        
        let rightButton = UIBarButtonItem(customView: imageView)
        self.navigationItem.rightBarButtonItem = rightButton
        
        
        label.rippleLocation = .TapLocation
        label.circleLayerColor = UIColor.MKColor.LightGreen
        label.backgroundLayerColor = UIColor.clearColor()
    }
    
    func rightButtonPressed() {
        
    }
}
