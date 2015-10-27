//
//  MKTableViewCell.swift
//  MaterialKit
//
//  Created by Le Van Nghia on 11/15/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

import UIKit

public class MKTableViewCell : UITableViewCell {
    @IBInspectable public var rippleLocation: MKRippleLocation = .TapLocation {
        didSet {
            mkLayer.rippleLocation = rippleLocation
        }
    }
    @IBInspectable public var rippleAniDuration: Float = 0.75
    @IBInspectable public var backgroundAniDuration: Float = 1.0
    @IBInspectable public var rippleAniTimingFunction: MKTimingFunction = .Linear
    @IBInspectable public var shadowAniEnabled: Bool = true

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

    private lazy var mkLayer: MKLayer = MKLayer(superLayer: self.contentView.layer)
    private var contentViewResized = false

    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayer()
    }

    private func setupLayer() {
        selectionStyle = .None
        mkLayer.setBackgroundLayerColor(backgroundLayerColor)
        mkLayer.setCircleLayerColor(rippleLayerColor)
        mkLayer.ripplePercent = 1.2
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        self.mkLayer.removeAllAnimations()
    }
    
    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        if let firstTouch = touches.first {
            if !contentViewResized {
                mkLayer.superLayerDidResize()
                contentViewResized = true
            }
            mkLayer.didChangeTapLocation(firstTouch.locationInView(contentView))

            mkLayer.animateScaleForCircleLayer(0.65, toScale: 1.0, timingFunction: rippleAniTimingFunction, duration: CFTimeInterval(rippleAniDuration))
            mkLayer.animateAlphaForBackgroundLayer(MKTimingFunction.Linear, duration: CFTimeInterval(backgroundAniDuration))
        }
    }
}
