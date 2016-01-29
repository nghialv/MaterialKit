//
//  MKLabel.swift
//  MaterialKit
//
//  Created by Le Van Nghia on 11/29/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

import UIKit

public class MKLabel: UILabel {
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
    @IBInspectable public var rippleAnimationDuration: Float = 0.35
    @IBInspectable public var rippleAnimationTimingFunction: MKTimingFunction = .Linear
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
            self.layer.masksToBounds = true
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
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
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
            layer.shadowOffset = CGSize(width: 1, height: 1)
            layer.shadowOpacity = shadowOpacity
            layer.shadowPath = shadowPath.CGPath
        }
    }
    
    public func animateRipple(location: CGPoint? = nil) {
        if let point = location {
            mkLayer.didChangeTapLocation(point)
        } else if rippleLocation == .TapLocation {
            rippleLocation = .Center
        }
        mkLayer.animateRipple(
            rippleAnimationTimingFunction,
            duration: CFTimeInterval(self.rippleAnimationDuration))
    }
    
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        if let firstTouch = touches.first {
            let location = firstTouch.locationInView(self)
            animateRipple(location)
        }
    }
    
    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        mkLayer.removeAllAnimations()
    }
    
    public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        mkLayer.removeAllAnimations()
    }
}
