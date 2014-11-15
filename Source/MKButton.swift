//
//  MKButton.swift
//  MaterialKit
//
//  Created by LeVan Nghia on 11/14/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

import UIKit

enum MKButtonType {
    case FloatingAction
    case Raised
    case Flat
}

@IBDesignable
class MKButton : UIButton
{
    @IBInspectable var mkType: MKButtonType = .Raised {
        didSet {
            didChangeButtonType()
        }
    }
    
    // animations
    @IBInspectable var shadowAniEnable : Bool = true
    @IBInspectable var backgroundAniEnable: Bool = true
    @IBInspectable var aniDuration : Float = 0.65
    @IBInspectable var aniFromTapLocationEnable : Bool = true
    
    @IBInspectable var cornerRadius: CGFloat = 2.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            mkLayer.setMaskLayerCornerRadius(cornerRadius)
        }
    }
    // color
    @IBInspectable var circleLayerColor: UIColor = UIColor(white: 0.45, alpha: 0.5) {
        didSet {
            mkLayer.setCircleLayerColor(circleLayerColor)
        }
    }
    @IBInspectable var backgroundLayerColor: UIColor = UIColor(white: 0.75, alpha: 0.25) {
        didSet {
            mkLayer.setBackgroundLayerColor(backgroundLayerColor)
        }
    }
   
    private lazy var mkLayer: MKLayer = MKLayer(superLayer: self.layer)
    
    // MARK - initilization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayer()
    }
    
    // MARK - reset methods
    private func setupLayer() {
        mkLayer.setMaskLayerCornerRadius(cornerRadius)
        mkLayer.setBackgroundLayerColor(backgroundLayerColor)
        mkLayer.setCircleLayerColor(circleLayerColor)
    }
   
    private func didChangeButtonType() {
        if mkType == .FloatingAction {
            let width = CGRectGetWidth(self.bounds)
            let height = CGRectGetHeight(self.bounds)
            self.cornerRadius = min(width, height)/2
            mkLayer.enableMask(enable: false)
        } else {
            mkLayer.enableMask(enable: true)
        }
    }
   
    // MARK - location tracking methods
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        if mkType != .FloatingAction {
            mkLayer.setSubLayerLocationAt(touch.locationInView(self))
        }
        
        // circleLayer animation
        let toValue: Float = mkType == .FloatingAction ? 1.75 : 1.0
        let timingFunction = mkType == .FloatingAction ? MKTimingFunction.EaseOut : MKTimingFunction.Linear
        mkLayer.animateScaleForCircleLayer(0.45, toScale: toValue, timingFunction: timingFunction, duration: CFTimeInterval( aniDuration))
        
        // backgroundLayer animation
        if backgroundAniEnable {
            let duration = mkType == .Flat ? 1.0 : CFTimeInterval(aniDuration)
            let timingFunction2 = mkType == .Flat ? MKTimingFunction.EaseOut : MKTimingFunction.Linear
            mkLayer.animateAlphaForBackgroundLayer(timingFunction2, duration: duration)
        }
        // shadow animation for self
        if shadowAniEnable {
            let shadowRadius = self.layer.shadowRadius
            let shadowOpacity = self.layer.shadowOpacity
            
            if mkType == .Flat {
                mkLayer.animateMaskLayerShadow()
            } else {
                mkLayer.animateSuperLayerShadow(10, toRadius: shadowRadius, fromOpacity: 0, toOpacity: shadowOpacity, timingFunction: MKTimingFunction.EaseOut, duration: CFTimeInterval(aniDuration))
            }
        }
        
        return super.beginTrackingWithTouch(touch, withEvent: event)
    }
}
