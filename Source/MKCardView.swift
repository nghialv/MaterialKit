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
open class MKCardView: UIControl {
    
    @IBInspectable open var elevation: CGFloat = 2 {
        didSet {
            mkLayer.elevation = elevation
        }
    }
    @IBInspectable open var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            mkLayer.superLayerDidResize()
        }
    }
    @IBInspectable open var shadowOffset: CGSize = .zero {
        didSet {
            mkLayer.shadowOffset = shadowOffset
        }
    }
    @IBInspectable open var roundingCorners: UIRectCorner = .allCorners {
        didSet {
            mkLayer.roundingCorners = roundingCorners
        }
    }
    @IBInspectable open var maskEnabled: Bool = true {
        didSet {
            mkLayer.maskEnabled = maskEnabled
        }
    }
    @IBInspectable open var rippleScaleRatio: CGFloat = 1.0 {
        didSet {
            mkLayer.rippleScaleRatio = rippleScaleRatio
        }
    }
    @IBInspectable open var rippleDuration: CFTimeInterval = 0.35 {
        didSet {
            mkLayer.rippleDuration = rippleDuration
        }
    }
    @IBInspectable open var rippleEnabled: Bool = true {
        didSet {
            mkLayer.rippleEnabled = rippleEnabled
        }
    }
    @IBInspectable open var rippleLayerColor: UIColor = UIColor(hex: 0xEEEEEE) {
        didSet {
            mkLayer.setRippleColor(rippleLayerColor)
        }
    }
    @IBInspectable open var backgroundAnimationEnabled: Bool = true {
        didSet {
            mkLayer.backgroundAnimationEnabled = backgroundAnimationEnabled
        }
    }
    
    override open var bounds: CGRect {
        didSet {
            mkLayer.superLayerDidResize()
        }
    }
    
    open lazy var mkLayer: MKLayer = MKLayer(withView: self)
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayer()
    }
    
    deinit {
        mkLayer.recycle()
    }
    
    private func setupLayer() {
        mkLayer.elevation = elevation
        layer.cornerRadius = cornerRadius
        mkLayer.elevationOffset = shadowOffset
        mkLayer.roundingCorners = roundingCorners
        mkLayer.maskEnabled = maskEnabled
        mkLayer.rippleScaleRatio = rippleScaleRatio
        mkLayer.rippleDuration = rippleDuration
        mkLayer.rippleEnabled = rippleEnabled
        mkLayer.backgroundAnimationEnabled = backgroundAnimationEnabled
        mkLayer.setRippleColor(rippleLayerColor)
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        mkLayer.touchesBegan(touches, withEvent: event)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        mkLayer.touchesEnded(touches, withEvent: event)
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        mkLayer.touchesCancelled(touches, withEvent: event)
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        mkLayer.touchesMoved(touches, withEvent: event)
    }
}
