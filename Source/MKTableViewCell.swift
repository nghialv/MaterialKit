//
//  MKTableViewCell.swift
//  MaterialKit
//
//  Created by Le Van Nghia on 11/15/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

import UIKit

open class MKTableViewCell: UITableViewCell {
    @IBInspectable open var maskEnabled: Bool = true {
        didSet {
            mkLayer.maskEnabled = maskEnabled
        }
    }
    @IBInspectable open var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            mkLayer.superLayerDidResize()
        }
    }
    @IBInspectable open var elevation: CGFloat = 0 {
        didSet {
            mkLayer.elevation = elevation
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

    private lazy var mkLayer: MKLayer = MKLayer(withView: self.contentView)

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayer()
    }

    deinit {
        mkLayer.recycle()
    }

    // MARK: Setup
    private func setupLayer() {
        selectionStyle = .none
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

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
