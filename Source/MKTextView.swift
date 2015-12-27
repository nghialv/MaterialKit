//
//  MKTextView.swift
//  MaterialKit
//
//  Created by Kaushal Deo on 12/26/15.
//  Copyright © 2015 Le Van Nghia. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable
public class MKTextView: UITextView {
    
    
    @IBInspectable public var rippleLocation: MKRippleLocation = .TapLocation {
        didSet {
            mkLayer.rippleLocation = rippleLocation
        }
    }
    
    @IBInspectable public var rippleAniDuration: Float = 0.75
    @IBInspectable public var backgroundAniDuration: Float = 1.0
    
    @IBInspectable public var rippleAniTimingFunction: MKTimingFunction = .Linear
    
    @IBInspectable public var cornerRadius: CGFloat = 2.5 {
        didSet {
            layer.cornerRadius = cornerRadius
            mkLayer.setMaskLayerCornerRadius(cornerRadius)
        }
    }
    // color
    @IBInspectable public var rippleLayerColor: UIColor = UIColor(white: 0.45, alpha: 0.5) {
        didSet {
            mkLayer.setCircleLayerColor(rippleLayerColor)
        }
    }
    @IBInspectable public var backgroundLayerColor: UIColor = UIColor(white: 0.75, alpha: 0.25) {
        didSet {
            mkLayer.setBackgroundLayerColor(backgroundLayerColor)
        }
    }
    
    @IBInspectable public var bottomBorderEnabled: Bool = true {
        didSet {
            bottomBorderLayer?.removeFromSuperlayer()
            bottomBorderLayer = nil
            if bottomBorderEnabled {
                bottomBorderLayer = CALayer()
                bottomBorderLayer?.frame = CGRect(x: 0, y: layer.bounds.height - 1, width: bounds.width, height: 1)
                bottomBorderLayer?.backgroundColor = UIColor.MKColor.Grey.CGColor
                layer.addSublayer(bottomBorderLayer!)
            }
        }
    }
    @IBInspectable public var bottomBorderWidth: CGFloat = 1.0
    @IBInspectable public var bottomBorderColor: UIColor = UIColor.lightGrayColor()
    @IBInspectable public var bottomBorderHighlightWidth: CGFloat = 1.75
    
    
    override public var bounds: CGRect {
        didSet {
            mkLayer.superLayerDidResize()
        }
    }
    
    private lazy var mkLayer: MKLayer = MKLayer(superLayer: self.layer)
    private var floatingLabel: UILabel!
    private var bottomBorderLayer: CALayer?
    private var editing : Bool = false
    
    override  public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer:textContainer)
        setupLayer()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayer()
    }
    
    private func setupLayer() {
        cornerRadius = 2.5
        layer.borderWidth = 1.0
        mkLayer.ripplePercent = 1.0
        mkLayer.setBackgroundLayerColor(backgroundLayerColor)
        mkLayer.setCircleLayerColor(rippleLayerColor)
    }
    
    public func animateRipple(location: CGPoint? = nil) {
        if let point = location {
            mkLayer.didChangeTapLocation(point)
        } else if rippleLocation == .TapLocation {
            rippleLocation = .Center
        }
        
        mkLayer.animateScaleForCircleLayer(0.65, toScale: 1.0, timingFunction: rippleAniTimingFunction, duration: CFTimeInterval(self.rippleAniDuration))
        mkLayer.animateAlphaForBackgroundLayer(MKTimingFunction.Linear, duration: CFTimeInterval(self.backgroundAniDuration))
        self.editing = true
    }
    
    
    override public func closestPositionToPoint(point: CGPoint) -> UITextPosition? {
        self.animateRipple(point)
        return super.closestPositionToPoint(point)
    }

    
    override public func becomeFirstResponder() -> Bool {
        self.bottomLayerAnimation(true)
        return super.becomeFirstResponder()
    }
    
    override public func resignFirstResponder() -> Bool {
        let flag = super.resignFirstResponder()
        self.bottomLayerAnimation(false)
        self.editing = false
        return flag
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        bottomBorderLayer?.backgroundColor = isFirstResponder() ? tintColor.CGColor : bottomBorderColor.CGColor
        let borderWidth = isFirstResponder() ? bottomBorderHighlightWidth : bottomBorderWidth
        bottomBorderLayer?.frame = CGRect(x: 0, y: layer.bounds.height - borderWidth, width: layer.bounds.width, height: borderWidth)
    }
    
    private func bottomLayerAnimation(responding: Bool) {
        bottomBorderLayer?.backgroundColor = isFirstResponder() ? tintColor.CGColor : bottomBorderColor.CGColor
        let borderWidth = responding ? bottomBorderHighlightWidth : bottomBorderWidth
        bottomBorderLayer?.frame = CGRect(x: 0, y: layer.bounds.height - borderWidth, width: layer.bounds.width, height: borderWidth)
    }
    
    
    
}
