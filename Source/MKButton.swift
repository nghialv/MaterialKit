//
//  MKButton.swift
//  MaterialKit
//
//  Created by LeVan Nghia on 11/14/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

import UIKit

@IBDesignable
public class MKButton : UIButton
{
    @IBInspectable public var maskEnabled: Bool = false {
        didSet {
            mkLayer.enableMask(maskEnabled)
        }
    }
    @IBInspectable public var rippleLocation: MKRippleLocation = .TapLocation {
        didSet {
            mkLayer.rippleLocation = rippleLocation
        }
    }
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
            mkLayer.setCornerRadius(self.cornerRadius)
        }
    }
    @IBInspectable public var elevation: CGFloat = 0 {
        didSet {
            drawShadow()
        }
    }
    @IBInspectable public var shadowOpacity: Float = 0.5 {
        didSet {
            drawShadow()
        }
    }
    @IBInspectable public var rippleAnimationEnabled = true {
        didSet {
            mkLayer.setRippleAnimation(self.rippleAnimationEnabled)
        }
    }
    
    // animations
    @IBInspectable public var shadowAnimationEnabled: Bool = true
    @IBInspectable public var rippleAnimationDuration: Float = 0.35
    @IBInspectable public var shadowAnimationDuration: Float = 0.35
    
    @IBInspectable public var rippleAnimationTimingFunction: MKTimingFunction = .Linear
    @IBInspectable public var shadowAnimationTimingFunction: MKTimingFunction = .EaseOut
    
    // color
    @IBInspectable public var rippleLayerColor: UIColor = UIColor(hex: 0xE0E0E0) {
        didSet {
            mkLayer.setCircleLayerColor(rippleLayerColor)
        }
    }
    
    override public var bounds: CGRect {
        didSet {
            mkLayer.superLayerDidResize()
        }
    }
    
    private lazy var mkLayer: MKLayer = MKLayer(superLayer: self.layer)
    
    // MARK - initilization
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayer()
    }
    
    // MARK - setup methods
    private func setupLayer() {
        adjustsImageWhenHighlighted = false
        mkLayer.setCircleLayerColor(rippleLayerColor)
        drawShadow()
    }
    
    private func drawShadow() {
        if elevation > 0 {
            let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
            layer.masksToBounds = false
            layer.cornerRadius = cornerRadius
            layer.shadowRadius = elevation
            layer.shadowColor = UIColor.blackColor().CGColor
            layer.shadowOffset = CGSize(width: 1, height: 1) ;
            layer.shadowOpacity = shadowOpacity
            layer.shadowPath = shadowPath.CGPath
        }
    }
    
    // MARK - location tracking methods
    override public func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        if !super.beginTrackingWithTouch(touch, withEvent: event) {
            mkLayer.removeAllAnimations()
            return false
        }
        
        if rippleLocation == .TapLocation {
            mkLayer.didChangeTapLocation(touch.locationInView(self))
        }
        
        // rippleLayer animation
        mkLayer.animateRipple(rippleAnimationTimingFunction, duration: CFTimeInterval(self.rippleAnimationDuration))
        
        // shadow animation for self
        if shadowAnimationEnabled {
            let shadowRadius = layer.shadowRadius
            let shadowOpacity = layer.shadowOpacity
            let duration = CFTimeInterval(shadowAnimationDuration)
            mkLayer.animateSuperLayerShadow(
                10,
                toRadius: shadowRadius,
                fromOpacity: 0,
                toOpacity: shadowOpacity,
                timingFunction: shadowAnimationTimingFunction,
                duration: duration)
        }
        
        return true
    }
    
    public override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        super.endTrackingWithTouch(touch, withEvent: event)
        mkLayer.removeAllAnimations()
    }
    
    public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        mkLayer.removeAllAnimations()
    }
}
