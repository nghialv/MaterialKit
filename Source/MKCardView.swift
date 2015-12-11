//
//  The MIT License (MIT)
//
//  Copyright (c) 2014 Andrew Clissold
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//      The above copyright notice and this permission notice shall be included in all
//      copies or substantial portions of the Software.
//
//      THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//      IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//      FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//      AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//      LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//      OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//      SOFTWARE.
//

import UIKit

@IBDesignable
public class MKCardView: UIControl {
    
    @IBInspectable public var elevation: CGFloat = 2 {
        didSet {
            drawShadow()
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            drawShadow()
            mkLayer.setCornerRadius(self.cornerRadius)
        }
    }
    
    @IBInspectable public var shadowOpacity: Float = 0.5 {
        didSet {
            drawShadow()
        }
    }
    
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
    @IBInspectable public var rippleAniDuration: Float = 0.35
    @IBInspectable public var backgroundAniDuration: Float = 1.0
    @IBInspectable public var rippleAniTimingFunction: MKTimingFunction = .Linear
    @IBInspectable public var backgroundAniTimingFunction: MKTimingFunction = .Linear
    @IBInspectable public var rippleAnimationEnabled = true {
        didSet {
            mkLayer.setRippleAnimation(self.rippleAnimationEnabled)
        }
    }
    
    // color
    @IBInspectable public var rippleLayerColor: UIColor = UIColor(hex: 0xe0e0e0) {
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
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
        drawShadow()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayer()
        drawShadow()
    }
    
    public override func layoutSubviews() {
        drawShadow()
        super.layoutSubviews()
    }
    
    private func setupLayer() {
        mkLayer.setCircleLayerColor(rippleLayerColor)
    }
    
    private func drawShadow() {
        if elevation > 0 {
            let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
            layer.masksToBounds = false
            layer.cornerRadius = cornerRadius
            layer.shadowRadius = elevation
            layer.shadowColor = UIColor.blackColor().CGColor
            layer.shadowOffset = CGSize(width: 1, height: 1);
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
        
        mkLayer.animateRipple(rippleAniTimingFunction, duration: CFTimeInterval(self.rippleAniDuration))
        mkLayer.animateAlphaForBackgroundLayer(backgroundAniTimingFunction, duration: CFTimeInterval(self.backgroundAniDuration))
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
        mkLayer.animateRipple(rippleAniTimingFunction, duration: CFTimeInterval(self.rippleAniDuration))
        
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