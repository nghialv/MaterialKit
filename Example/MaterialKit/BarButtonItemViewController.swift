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
    @IBOutlet var imageView: MKImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // customize UIBarButtonItem
        let imgView = MKImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 32))
        imgView.image = UIImage(named: "uibaritem_icon.png")
        imgView.backgroundAniEnabled = false
        imgView.rippleLocation = .Center
        imgView.ripplePercent = 1.15
        imgView.userInteractionEnabled = true
        
        let rightButton = UIBarButtonItem(customView: imgView)
        self.navigationItem.rightBarButtonItem = rightButton
        
        
        label.rippleLocation = .TapLocation
        label.rippleLayerColor = UIColor.MKColor.LightGreen
        label.backgroundLayerColor = UIColor.clearColor()
        //label.userInteractionEnabled = true
        NSTimer.scheduledTimerWithTimeInterval(2.5, target: self, selector: "animateLabelRipple", userInfo: nil, repeats: false)
        
        imageView.layer.borderColor = UIColor.MKColor.Grey.CGColor
        imageView.layer.borderWidth = 1.0
        imageView.ripplePercent = 1.2
        imageView.rippleLocation = .Left
        NSTimer.scheduledTimerWithTimeInterval(3.5, target: self, selector: "animateImageRipple", userInfo: nil, repeats: false)
    }
   
    func animateLabelRipple() {
        label.animateRipple()
    }
    
    func animateImageRipple() {
        imageView.animateRipple()
    }
}
