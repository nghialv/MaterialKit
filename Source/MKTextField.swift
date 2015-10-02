//
//  MKTextField.swift
//  MaterialKit
//
//  Created by LeVan Nghia on 11/14/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable
public class MKTextField : UITextField {
    @IBInspectable public var padding: CGSize = CGSize(width: 5, height: 5)
    @IBInspectable public var floatingLabelBottomMargin: CGFloat = 2.0
    @IBInspectable public var floatingPlaceholderEnabled: Bool = false

    @IBInspectable public var rippleLocation: MKRippleLocation = .TapLocation {
        didSet {
            mkLayer.rippleLocation = rippleLocation
        }
    }

    @IBInspectable public var rippleAniDuration: Float = 0.75
    @IBInspectable public var backgroundAniDuration: Float = 1.0
    @IBInspectable public var shadowAniEnabled: Bool = true
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

    // floating label
    @IBInspectable public var floatingLabelFont: UIFont = UIFont.boldSystemFontOfSize(10.0) {
        didSet {
            floatingLabel.font = floatingLabelFont
        }
    }
    @IBInspectable public var floatingLabelTextColor: UIColor = UIColor.lightGrayColor() {
        didSet {
            floatingLabel.textColor = floatingLabelTextColor
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

    override public var placeholder: String? {
        didSet {
            updateFloatingLabelText()
        }
    }
    override public var bounds: CGRect {
        didSet {
            mkLayer.superLayerDidResize()
        }
    }

    private lazy var mkLayer: MKLayer = MKLayer(superLayer: self.layer)
    private var floatingLabel: UILabel!
    private var bottomBorderLayer: CALayer?

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayer()
    }

    private func setupLayer() {
        cornerRadius = 2.5
        layer.borderWidth = 1.0
        borderStyle = .None
        mkLayer.ripplePercent = 1.0
        mkLayer.setBackgroundLayerColor(backgroundLayerColor)
        mkLayer.setCircleLayerColor(rippleLayerColor)

        // floating label
        floatingLabel = UILabel()
        floatingLabel.font = floatingLabelFont
        floatingLabel.alpha = 0.0
        updateFloatingLabelText()
        
        addSubview(floatingLabel)
    }

    override public func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        mkLayer.didChangeTapLocation(touch.locationInView(self))

        mkLayer.animateScaleForCircleLayer(0.45, toScale: 1.0, timingFunction: MKTimingFunction.Linear, duration: CFTimeInterval(self.rippleAniDuration))
        mkLayer.animateAlphaForBackgroundLayer(MKTimingFunction.Linear, duration: CFTimeInterval(self.backgroundAniDuration))

        return super.beginTrackingWithTouch(touch, withEvent: event)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        if !floatingPlaceholderEnabled {
            return
        }

        if !text!.isEmpty {
            floatingLabel.textColor = isFirstResponder() ? tintColor : floatingLabelTextColor
            if floatingLabel.alpha == 0 {
                showFloatingLabel()
            }
        } else {
            hideFloatingLabel()
        }

        bottomBorderLayer?.backgroundColor = isFirstResponder() ? tintColor.CGColor : bottomBorderColor.CGColor
        let borderWidth = isFirstResponder() ? bottomBorderHighlightWidth : bottomBorderWidth
        bottomBorderLayer?.frame = CGRect(x: 0, y: layer.bounds.height - borderWidth, width: layer.bounds.width, height: borderWidth)
    }

    override public func textRectForBounds(bounds: CGRect) -> CGRect {
        let rect = super.textRectForBounds(bounds)
        var newRect = CGRect(x: rect.origin.x + padding.width, y: rect.origin.y,
            width: rect.size.width - 2*padding.width, height: rect.size.height)

        if !floatingPlaceholderEnabled {
            return newRect
        }

        if !text!.isEmpty {
            let dTop = floatingLabel.font.lineHeight + floatingLabelBottomMargin
            newRect = UIEdgeInsetsInsetRect(newRect, UIEdgeInsets(top: dTop, left: 0.0, bottom: 0.0, right: 0.0))
        }
        return newRect
    }

    override public func editingRectForBounds(bounds: CGRect) -> CGRect {
        return textRectForBounds(bounds)
    }
}

// MARK - private methods
private extension MKTextField {
    private func setFloatingLabelOverlapTextField() {
        let textRect = textRectForBounds(bounds)
        var originX = textRect.origin.x
        switch textAlignment {
        case .Center:
            originX += textRect.size.width/2 - floatingLabel.bounds.width/2
        case .Right:
            originX += textRect.size.width - floatingLabel.bounds.width
        default:
            break
        }
        floatingLabel.frame = CGRect(x: originX, y: padding.height,
            width: floatingLabel.frame.size.width, height: floatingLabel.frame.size.height)
    }

    private func showFloatingLabel() {
        let curFrame = floatingLabel.frame
        floatingLabel.frame = CGRect(x: curFrame.origin.x, y: bounds.height/2, width: curFrame.width, height: curFrame.height)
        UIView.animateWithDuration(0.45, delay: 0.0, options: .CurveEaseOut,
            animations: {
                self.floatingLabel.alpha = 1.0
                self.floatingLabel.frame = curFrame
            }, completion: nil)
    }

    private func hideFloatingLabel() {
        floatingLabel.alpha = 0.0
    }
    
    private func updateFloatingLabelText() {
        floatingLabel.text = placeholder
        floatingLabel.sizeToFit()
        setFloatingLabelOverlapTextField()
    }
}
