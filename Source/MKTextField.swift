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
open class MKTextField : UITextField {

    @IBInspectable open var padding: CGSize = CGSize(width: 5, height: 5)
    @IBInspectable open var floatingLabelBottomMargin: CGFloat = 2.0
    @IBInspectable open var floatingPlaceholderEnabled: Bool = false {
        didSet {
            self.updateFloatingLabelText()
        }
    }

    @IBInspectable open var maskEnabled: Bool = true {
        didSet {
            mkLayer.maskEnabled = maskEnabled
        }
    }
    @IBInspectable open var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
            mkLayer.superLayerDidResize()
        }
    }
    @IBInspectable open var elevation: CGFloat = 0 {
        didSet {
            mkLayer.elevation = elevation
        }
    }
    @IBInspectable open var shadowOffset: CGSize = CGSize.zero {
        didSet {
            mkLayer.shadowOffset = shadowOffset
        }
    }
    @IBInspectable open var roundingCorners: UIRectCorner = UIRectCorner.allCorners {
        didSet {
            mkLayer.roundingCorners = roundingCorners
        }
    }
    @IBInspectable open var rippleEnabled: Bool = true {
        didSet {
            mkLayer.rippleEnabled = rippleEnabled
        }
    }
    @IBInspectable open var rippleDuration: CFTimeInterval = 0.35 {
        didSet {
            mkLayer.rippleDuration = rippleDuration
        }
    }
    @IBInspectable open var rippleScaleRatio: CGFloat = 1.0 {
        didSet {
            mkLayer.rippleScaleRatio = rippleScaleRatio
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

    // floating label
    @IBInspectable open var floatingLabelFont: UIFont = UIFont.boldSystemFont(ofSize: 10.0) {
        didSet {
            floatingLabel.font = floatingLabelFont
        }
    }
    @IBInspectable open var floatingLabelTextColor: UIColor = UIColor.lightGray {
        didSet {
            floatingLabel.textColor = floatingLabelTextColor
        }
    }

    @IBInspectable open var bottomBorderEnabled: Bool = true {
        didSet {
            bottomBorderLayer?.removeFromSuperlayer()
            bottomBorderLayer = nil
            if bottomBorderEnabled {
                bottomBorderLayer = CALayer()
                bottomBorderLayer?.frame = CGRect(x: 0, y: layer.bounds.height - 1, width: bounds.width, height: 1)
                bottomBorderLayer?.backgroundColor = UIColor.MKColor.Grey.P500.cgColor
                layer.addSublayer(bottomBorderLayer!)
            }
        }
    }
    @IBInspectable open var bottomBorderWidth: CGFloat = 1.0
    @IBInspectable open var bottomBorderColor: UIColor = UIColor.lightGray {
        didSet {
            if bottomBorderEnabled {
                bottomBorderLayer?.backgroundColor = bottomBorderColor.cgColor
            }
        }
    }
    @IBInspectable open var bottomBorderHighlightWidth: CGFloat = 1.75
    override open var attributedPlaceholder: NSAttributedString? {
        didSet {
            updateFloatingLabelText()
        }
    }

    fileprivate lazy var mkLayer: MKLayer = MKLayer(withView: self)
    fileprivate var floatingLabel: UILabel!
    fileprivate var bottomBorderLayer: CALayer?

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayer()
    }

    fileprivate func setupLayer() {
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

        layer.borderWidth = 1.0
        borderStyle = .none

        // floating label
        floatingLabel = UILabel()
        floatingLabel.font = floatingLabelFont
        floatingLabel.alpha = 0.0
        updateFloatingLabelText()

        addSubview(floatingLabel)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        bottomBorderLayer?.backgroundColor = isFirstResponder ? tintColor.cgColor : bottomBorderColor.cgColor
        let borderWidth = isFirstResponder ? bottomBorderHighlightWidth : bottomBorderWidth
        bottomBorderLayer?.frame = CGRect(x: 0, y: layer.bounds.height - borderWidth, width: layer.bounds.width, height: borderWidth)

        if !floatingPlaceholderEnabled {
            return
        }

        if let text = text, text.isEmpty == false {
            floatingLabel.textColor = isFirstResponder ? tintColor : floatingLabelTextColor
            if floatingLabel.alpha == 0 {
                showFloatingLabel()
            }
        } else {
            hideFloatingLabel()
        }
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        var newRect = CGRect(x: rect.origin.x + padding.width, y: rect.origin.y,
            width: rect.size.width - 2 * padding.width, height: rect.size.height)

        if !floatingPlaceholderEnabled {
            return newRect
        }

        if let text = text, text.isEmpty == false {
            let dTop = floatingLabel.font.lineHeight + floatingLabelBottomMargin
            newRect = UIEdgeInsetsInsetRect(newRect, UIEdgeInsets(top: dTop, left: 0.0, bottom: 0.0, right: 0.0))
        }

        return newRect
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }

    // MARK: Touch
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

// MARK - private methods
private extension MKTextField {
    func setFloatingLabelOverlapTextField() {
        let textRect = self.textRect(forBounds: bounds)
        var originX = textRect.origin.x
        switch textAlignment {
        case .center:
            originX += textRect.size.width / 2 - floatingLabel.bounds.width / 2
        case .right:
            originX += textRect.size.width - floatingLabel.bounds.width
        default:
            break
        }
        floatingLabel.frame = CGRect(x: originX, y: padding.height,
            width: floatingLabel.frame.size.width, height: floatingLabel.frame.size.height)
    }

    func showFloatingLabel() {
        let curFrame = floatingLabel.frame
        floatingLabel.frame = CGRect(x: curFrame.origin.x, y: bounds.height / 2, width: curFrame.width, height: curFrame.height)
        UIView.animate(withDuration: 0.45, delay: 0.0, options: .curveEaseOut,
            animations: {
                self.floatingLabel.alpha = 1.0
                self.floatingLabel.frame = curFrame
            }, completion: nil)
    }

    func hideFloatingLabel() {
        floatingLabel.alpha = 0.0
    }

    func updateFloatingLabelText() {
        floatingLabel.attributedText = attributedPlaceholder
        floatingLabel.sizeToFit()
        setFloatingLabelOverlapTextField()
    }
}
