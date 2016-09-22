//
//  MKSwitch.swift
//  MaterialKit
//
//  Created by Rahul Iyer on 29/01/16.
//  Copyright © 2016 Le Van Nghia. All rights reserved.
//

import UIKit

public let kMKControlWidth: CGFloat = 40
public let kMKControlHeight: CGFloat = 20
public let kMKTrackWidth: CGFloat = 34
public let kMKTrackHeight: CGFloat = 12
public let kMKTrackCornerRadius: CGFloat = 6
public let kMKThumbRadius: CGFloat = 10

@IBDesignable
open class MKSwitch: UIControl {

    @IBInspectable open override var isEnabled: Bool {
        didSet {
            if let switchLayer = self.switchLayer {
                switchLayer.enabled = self.isEnabled
            }
        }
    }
    @IBInspectable open var thumbOnColor: UIColor = UIColor.MKColor.Blue.P500 {
        didSet {
            if let switchLayer = self.switchLayer {
                if let onColorPallete = switchLayer.onColorPallete {
                    onColorPallete.thumbColor = self.thumbOnColor
                    switchLayer.updateColors()
                }
            }
        }
    }
    @IBInspectable open var thumbOffColor: UIColor = UIColor(hex: 0xFAFAFA) {
        didSet {
            if let switchLayer = self.switchLayer {
                if let offColorPallete = switchLayer.offColorPallete {
                    offColorPallete.thumbColor = self.thumbOffColor
                    switchLayer.updateColors()
                }
            }
        }
    }
    @IBInspectable open var thumbDisabledColor: UIColor = UIColor(hex: 0xBDBDBD) {
        didSet {
            if let switchLayer = self.switchLayer {
                if let disabledColorPallete = switchLayer.disabledColorPallete {
                    disabledColorPallete.thumbColor = self.thumbDisabledColor
                    switchLayer.updateColors()
                }
            }
        }
    }
    @IBInspectable open var trackOnColor: UIColor = UIColor.MKColor.Blue.P300 {
        didSet {
            if let switchLayer = self.switchLayer {
                if let onColorPallete = switchLayer.onColorPallete {
                    onColorPallete.trackColor = self.trackOnColor
                    switchLayer.updateColors()
                }
            }
        }
    }
    @IBInspectable open var trackOffColor: UIColor = UIColor(hex: 0x000042, alpha: 0.1) {
        didSet {
            if let switchLayer = self.switchLayer {
                if let offColorPallete = switchLayer.offColorPallete {
                    offColorPallete.trackColor = self.trackOffColor
                    switchLayer.updateColors()
                }
            }
        }
    }
    @IBInspectable open var trackDisabledColor: UIColor = UIColor(hex: 0xBDBDBD) {
        didSet {
            if let switchLayer = self.switchLayer {
                if let disabledColorPallete = switchLayer.disabledColorPallete {
                    disabledColorPallete.trackColor = self.trackDisabledColor
                    switchLayer.updateColors()
                }
            }
        }
    }
    @IBInspectable open var on: Bool = false {
        didSet {
            if let switchLayer = self.switchLayer {
                switchLayer.switchState(self.on)
                sendActions(for: .valueChanged)
            }
        }
    }

    fileprivate var switchLayer: MKSwitchLayer?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        if let switchLayer = switchLayer {
            switchLayer.updateSuperBounds(self.bounds)
        }
    }

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first {
            let point = touch.location(in: self)
            if let switchLayer = switchLayer {
                switchLayer.onTouchDown(self.layer.convert(point, to: switchLayer))
            }
        }
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if let touch = touches.first {
            let point = touch.location(in: self)
            if let switchLayer = switchLayer {
                switchLayer.onTouchUp(self.layer.convert(point, to: switchLayer))
            }
        }
    }

    

    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
  
        if touches.count > 0 {
            if let touch = touches.first {
                let point = touch.location(in: self)
                if let switchLayer = switchLayer {
                    switchLayer.onTouchUp(self.layer.convert(point, to: switchLayer))
                }
            }
        }
    }

    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if let touch = touches.first {
            let point = touch.location(in: self)
            if let switchLayer = switchLayer {
                switchLayer.onTouchMoved(self.layer.convert(point, to: switchLayer))
            }
        }
    }

    fileprivate func setup() {
        switchLayer = MKSwitchLayer(withParent: self)
        self.isEnabled = true

        switchLayer!.onColorPallete = MKSwitchColorPallete(
            thumbColor: thumbOnColor, trackColor: trackOnColor)
        switchLayer!.offColorPallete = MKSwitchColorPallete(
            thumbColor: thumbOffColor, trackColor: trackOffColor)
        switchLayer!.disabledColorPallete = MKSwitchColorPallete(
            thumbColor: thumbDisabledColor, trackColor: trackDisabledColor)
        self.layer.addSublayer(switchLayer!)
    }
}

open class MKSwitchLayer: CALayer {

    open var enabled: Bool = true {
        didSet {
            updateColors()
        }
    }
    open var parent: MKSwitch?
    open var rippleAnimationDuration: CFTimeInterval = 0.35

    fileprivate var trackLayer: CAShapeLayer?
    fileprivate var thumbHolder: CALayer?
    fileprivate var thumbLayer: CAShapeLayer?
    fileprivate var thumbBackground: CALayer?
    fileprivate var rippleLayer: MKLayer?
    fileprivate var shadowLayer: MKLayer?
    fileprivate var touchInside: Bool = false
    fileprivate var touchDownLocation: CGPoint?
    fileprivate var thumbFrame: CGRect?
    fileprivate var onColorPallete: MKSwitchColorPallete? {
        didSet {
            updateColors()
        }
    }
    fileprivate var offColorPallete: MKSwitchColorPallete? {
        didSet {
            updateColors()
        }
    }
    fileprivate var disabledColorPallete: MKSwitchColorPallete? {
        didSet {
            updateColors()
        }
    }

    public init(withParent parent: MKSwitch) {
        super.init()
        self.parent = parent
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    fileprivate func setup() {
        trackLayer = CAShapeLayer()
        thumbLayer = CAShapeLayer()
        thumbHolder = CALayer()
        thumbBackground = CALayer()
        shadowLayer = MKLayer(superLayer: thumbLayer!)
        shadowLayer!.rippleScaleRatio = 0
        rippleLayer = MKLayer(superLayer: thumbBackground!)
        rippleLayer!.rippleScaleRatio = 1.7
        rippleLayer!.maskEnabled = false
        rippleLayer!.elevation = 0
        thumbHolder!.addSublayer(thumbBackground!)
        thumbHolder!.addSublayer(thumbLayer!)
        self.addSublayer(trackLayer!)
        self.addSublayer(thumbHolder!)
    }

    fileprivate func updateSuperBounds(_ bounds: CGRect) {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let subX = center.x - kMKControlWidth / 2
        let subY = center.y - kMKControlHeight / 2
        self.frame = CGRect(x: subX, y: subY, width: kMKControlWidth, height: kMKControlHeight)
        updateTrackLayer()
        updateThumbLayer()
    }

    fileprivate func updateTrackLayer() {
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let subX = center.x - kMKTrackWidth / 2
        let subY = center.y - kMKTrackHeight / 2

        if let trackLayer = trackLayer {
            trackLayer.frame = CGRect(x: subX, y: subY, width: kMKTrackWidth, height: kMKTrackHeight)
            trackLayer.path = UIBezierPath(
                roundedRect: trackLayer.bounds,
                byRoundingCorners: UIRectCorner.allCorners,
                cornerRadii: CGSize(
                    width: kMKTrackCornerRadius,
                    height: kMKTrackCornerRadius)).cgPath
        }
    }

    fileprivate func updateThumbLayer() {
        var subX: CGFloat = 0
        if let parent = parent {
            if parent.on {
                subX = kMKControlWidth - kMKThumbRadius * 2
            }
        }

        thumbFrame = CGRect(x: subX, y: 0, width: kMKThumbRadius * 2, height: kMKThumbRadius * 2)
        if let
        thumbHolder = thumbHolder,
        let thumbBackground = thumbBackground,
        let thumbLayer = thumbLayer {
            thumbHolder.frame = thumbFrame!
            thumbBackground.frame = thumbHolder.bounds
            thumbLayer.frame = thumbHolder.bounds
            thumbLayer.path = UIBezierPath(ovalIn: thumbLayer.bounds).cgPath
        }
    }

    fileprivate func updateColors() {
        if let trackLayer = trackLayer,
        let thumbLayer = thumbLayer,
        let rippleLayer = rippleLayer,
        let parent = parent {
            if !enabled {
                if let disabledColorPallete = disabledColorPallete {
                    trackLayer.fillColor = disabledColorPallete.trackColor.cgColor
                    thumbLayer.fillColor = disabledColorPallete.thumbColor.cgColor
                }
            } else if parent.on {
                if let
                onColorPallete = onColorPallete {
                    trackLayer.fillColor = onColorPallete.trackColor.cgColor
                    thumbLayer.fillColor = onColorPallete.thumbColor.cgColor
                    rippleLayer.setRippleColor(onColorPallete.thumbColor, withRippleAlpha: 0.1,
                        withBackgroundAlpha: 0.1)
                }
            } else {
                if let
                offColorPallete = offColorPallete {
                    trackLayer.fillColor = offColorPallete.trackColor.cgColor
                    thumbLayer.fillColor = offColorPallete.thumbColor.cgColor
                    rippleLayer.setRippleColor(offColorPallete.thumbColor,
                        withRippleAlpha: 0.1,
                        withBackgroundAlpha: 0.1)
                }
            }
        }
    }

    fileprivate func switchState(_ on: Bool) {
        if on {
            thumbFrame = CGRect(
                x: kMKControlWidth - kMKThumbRadius * 2,
                y: 0,
                width: kMKThumbRadius * 2,
                height: kMKThumbRadius * 2)
        } else {
            thumbFrame = CGRect(
                x: 0, y: 0, width: kMKThumbRadius * 2, height: kMKThumbRadius * 2)
        }
        if let thumbHolder = thumbHolder {
            thumbHolder.frame = thumbFrame!
        }
        self.updateColors()
    }

    open func onTouchDown(_ touchLocation: CGPoint) {
        if enabled {
            if let
            rippleLayer = rippleLayer, let shadowLayer = shadowLayer,
            let thumbBackground = thumbBackground, let thumbLayer = thumbLayer {
                rippleLayer.startEffects(atLocation: self.convert(touchLocation, to: thumbBackground))
                shadowLayer.startEffects(atLocation: self.convert(touchLocation, to: thumbLayer))

                self.touchInside = self.contains(touchLocation)
                self.touchDownLocation = touchLocation
            }
        }
    }

    open func onTouchMoved(_ moveLocation: CGPoint) {
        if enabled {
            if touchInside {
                if let thumbFrame = thumbFrame, let thumbHolder = thumbHolder, let touchDownLocation = touchDownLocation {
                    var x = thumbFrame.origin.x + moveLocation.x - touchDownLocation.x
                    if x < 0 {
                        x = 0
                    } else if x > self.bounds.size.width - thumbFrame.size.width {
                        x = self.bounds.size.width - thumbFrame.size.width
                    }
                    thumbHolder.frame = CGRect(
                        x: x,
                        y: thumbFrame.origin.y,
                        width: thumbFrame.size.width,
                        height: thumbFrame.size.height)
                }
            }
        }
    }

    open func onTouchUp(_ touchLocation: CGPoint) {
        if enabled {
            if let rippleLayer = rippleLayer, let shadowLayer = shadowLayer {
                rippleLayer.stopEffects()
                shadowLayer.stopEffects()
            }

            if let touchDownLocation = touchDownLocation, let parent = parent {
                if !touchInside || self.checkPoint(touchLocation, equalTo: touchDownLocation) {
                    parent.on = !parent.on
                } else {
                    if parent.on && touchLocation.x < touchDownLocation.x {
                        parent.on = false
                    } else if !parent.on && touchLocation.x > touchDownLocation.x {
                        parent.on = true
                    }
                }
            }
            touchInside = false
        }
    }

    fileprivate func checkPoint(_ point: CGPoint, equalTo other: CGPoint) -> Bool {
        return fabs(point.x - other.x) <= 5 && fabs(point.y - other.y) <= 5
    }
}

open class MKSwitchColorPallete {
    open var thumbColor: UIColor
    open var trackColor: UIColor

    init(thumbColor: UIColor, trackColor: UIColor) {
        self.thumbColor = thumbColor
        self.trackColor = trackColor
    }
}
