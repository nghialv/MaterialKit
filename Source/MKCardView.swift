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
            mkLayer.elevation = elevation
        }
    }
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            mkLayer.superLayerDidResize()
        }
    }
    @IBInspectable public var shadowOffset: CGSize = CGSizeZero {
        didSet {
            mkLayer.shadowOffset = shadowOffset
        }
    }
    @IBInspectable public var roundingCorners: UIRectCorner = UIRectCorner.AllCorners {
        didSet {
            mkLayer.roundingCorners = roundingCorners
        }
    }
    @IBInspectable public var maskEnabled: Bool = true {
        didSet {
            mkLayer.maskEnabled = maskEnabled
        }
    }
    @IBInspectable public var rippleScaleRatio: CGFloat = 1.0 {
        didSet {
            mkLayer.rippleScaleRatio = rippleScaleRatio
        }
    }
    @IBInspectable public var rippleDuration: CFTimeInterval = 0.35 {
        didSet {
            mkLayer.rippleDuration = rippleDuration
        }
    }
    @IBInspectable public var rippleEnabled: Bool = true {
        didSet {
            mkLayer.rippleEnabled = rippleEnabled
        }
    }
    @IBInspectable public var rippleLayerColor: UIColor = UIColor(hex: 0xEEEEEE) {
        didSet {
            mkLayer.setRippleColor(rippleLayerColor)
        }
    }
    @IBInspectable public var backgroundAnimationEnabled: Bool = true {
        didSet {
            mkLayer.backgroundAnimationEnabled = backgroundAnimationEnabled
        }
    }

    override public var bounds: CGRect {
        didSet {
            mkLayer.superLayerDidResize()
        }
    }

    public lazy var mkLayer: MKLayer = MKLayer(withView: self)

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayer()
    }

    private func setupLayer() {
        mkLayer.elevation = self.elevation
        self.layer.cornerRadius = self.cornerRadius
        mkLayer.elevationOffset = self.shadowOffset
        mkLayer.roundingCorners = self.roundingCorners
        mkLayer.maskEnabled = self.maskEnabled
        mkLayer.rippleScaleRatio = self.rippleScaleRatio
        mkLayer.rippleDuration = self.rippleDuration
        mkLayer.rippleEnabled = self.rippleEnabled
        mkLayer.backgroundAnimationEnabled = self.backgroundAnimationEnabled
        mkLayer.setRippleColor(self.rippleLayerColor)
    }

    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        mkLayer.touchesBegan(touches, withEvent: event)
    }

    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        mkLayer.touchesEnded(touches, withEvent: event)
    }

    public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        mkLayer.touchesCancelled(touches, withEvent: event)
    }

    public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        mkLayer.touchesMoved(touches, withEvent: event)
    }
}