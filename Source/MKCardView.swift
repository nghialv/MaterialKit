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
public class MKCardView: UIView {
    
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
    
    @IBInspectable public var maskEnabled: Bool = true {
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
    
    // color
    @IBInspectable public var rippleLayerColor: UIColor = UIColor(hex: 0xd3d3d3) {
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
    
    public override func layoutSubviews() {
        drawShadow()
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
    
    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
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