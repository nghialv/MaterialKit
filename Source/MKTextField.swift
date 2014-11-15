//
//  MKTextField.swift
//  MaterialKit
//
//  Created by LeVan Nghia on 11/14/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

import UIKit

class MKTextField : UITextField {
    @IBInspectable var tapLocationEnabled: Bool = true
    
    private lazy var mkLayer: MKLayer = MKLayer(superLayer: self.layer)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayer()
    }
    
    private func setupLayer() {
        mkLayer.setCircleLayerColor(UIColor.MKColor.Orange)
    }
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        if tapLocationEnabled {
            mkLayer.setCircleLayerLocationAt(touch.locationInView(self))
        }
        
        mkLayer.animateScaleForCircleLayer(0.45, toScale: 1.0, timingFunction: MKTimingFunction.Linear, duration: 0.75)
        mkLayer.animateAlphaForBackgroundLayer(MKTimingFunction.Linear, duration: 0.75)
        
        return super.beginTrackingWithTouch(touch, withEvent: event)
    }
}
