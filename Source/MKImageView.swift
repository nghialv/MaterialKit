//
//  MKImageView.swift
//  MaterialKit
//
//  Created by Le Van Nghia on 11/29/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

import UIKit

@IBDesignable
public class MKImageView: UIImageView
{
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
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
            mkLayer.setCornerRadius(self.cornerRadius)
        }
    }
    
    // color
    @IBInspectable public var rippleLayerColor: UIColor = UIColor(hex: 0xE0E0E0, alpha: 0.5) {
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

    override public init(image: UIImage?) {
        super.init(image: image)
        setup()
    }

    override public init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        setup()
    }

    private func setup() {
        self.clipsToBounds = true
        mkLayer.setCircleLayerColor(rippleLayerColor)
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
