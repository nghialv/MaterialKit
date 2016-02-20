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
public class MKSwitch: UIControl {

    @IBInspectable public override var enabled: Bool {
        didSet {
            if let switchLayer = self.switchLayer {
                switchLayer.enabled = self.enabled
            }
        }
    }
    @IBInspectable public var thumbOnColor: UIColor = UIColor.MKColor.Blue.P500 {
        didSet {
            if let switchLayer = self.switchLayer {
                if let onColorPallete = switchLayer.onColorPallete {
                    onColorPallete.thumbColor = self.thumbOnColor
                    switchLayer.updateColors()
                }
            }
        }
    }
    @IBInspectable public var thumbOffColor: UIColor = UIColor(hex: 0xFAFAFA) {
        didSet {
            if let switchLayer = self.switchLayer {
                if let offColorPallete = switchLayer.offColorPallete {
                    offColorPallete.thumbColor = self.thumbOffColor
                    switchLayer.updateColors()
                }
            }
        }
    }
    @IBInspectable public var thumbDisabledColor: UIColor = UIColor(hex: 0xBDBDBD) {
        didSet {
            if let switchLayer = self.switchLayer {
                if let disabledColorPallete = switchLayer.disabledColorPallete {
                    disabledColorPallete.thumbColor = self.thumbDisabledColor
                    switchLayer.updateColors()
                }
            }
        }
    }
    @IBInspectable public var trackOnColor: UIColor = UIColor.MKColor.Blue.P300 {
        didSet {
            if let switchLayer = self.switchLayer {
                if let onColorPallete = switchLayer.onColorPallete {
                    onColorPallete.trackColor = self.trackOnColor
                    switchLayer.updateColors()
                }
            }
        }
    }
    @IBInspectable public var trackOffColor: UIColor = UIColor(hex: 0x000042, alpha: 0.1) {
        didSet {
            if let switchLayer = self.switchLayer {
                if let offColorPallete = switchLayer.offColorPallete {
                    offColorPallete.trackColor = self.trackOffColor
                    switchLayer.updateColors()
                }
            }
        }
    }
    @IBInspectable public var trackDisabledColor: UIColor = UIColor(hex: 0xBDBDBD) {
        didSet {
            if let switchLayer = self.switchLayer {
                if let disabledColorPallete = switchLayer.disabledColorPallete {
                    disabledColorPallete.trackColor = self.trackDisabledColor
                    switchLayer.updateColors()
                }
            }
        }
    }
    @IBInspectable public var on: Bool = false {
        didSet {
            if let switchLayer = self.switchLayer {
                switchLayer.switchState(self.on)
                sendActionsForControlEvents(.ValueChanged)
            }
        }
    }

    private var switchLayer: MKSwitchLayer?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        if let switchLayer = switchLayer {
            switchLayer.updateSuperBounds(self.bounds)
        }
    }

    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        if let touch = touches.first {
            let point = touch.locationInView(self)
            if let switchLayer = switchLayer {
                switchLayer.onTouchDown(self.layer.convertPoint(point, toLayer: switchLayer))
            }
        }
    }

    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        if let touch = touches.first {
            let point = touch.locationInView(self)
            if let switchLayer = switchLayer {
                switchLayer.onTouchUp(self.layer.convertPoint(point, toLayer: switchLayer))
            }
        }
    }

    public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        if let touches = touches {
            if let touch = touches.first {
                let point = touch.locationInView(self)
                if let switchLayer = switchLayer {
                    switchLayer.onTouchUp(self.layer.convertPoint(point, toLayer: switchLayer))
                }
            }
        }
    }

    public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        if let touch = touches.first {
            let point = touch.locationInView(self)
            if let switchLayer = switchLayer {
                switchLayer.onTouchMoved(self.layer.convertPoint(point, toLayer: switchLayer))
            }
        }
    }

    private func setup() {
        switchLayer = MKSwitchLayer(withParent: self)
        self.enabled = true

        switchLayer!.onColorPallete = MKSwitchColorPallete(
            thumbColor: thumbOnColor, trackColor: trackOnColor)
        switchLayer!.offColorPallete = MKSwitchColorPallete(
            thumbColor: thumbOffColor, trackColor: trackOffColor)
        switchLayer!.disabledColorPallete = MKSwitchColorPallete(
            thumbColor: thumbDisabledColor, trackColor: trackDisabledColor)
        self.layer.addSublayer(switchLayer!)
    }
}

public class MKSwitchLayer: CALayer {

    public var enabled: Bool = true {
        didSet {
            updateColors()
        }
    }
    public var parent: MKSwitch?
    public var rippleAnimationDuration: CFTimeInterval = 0.35

    private var trackLayer: CAShapeLayer?
    private var thumbHolder: CALayer?
    private var thumbLayer: CAShapeLayer?
    private var thumbBackground: CALayer?
    private var rippleLayer: MKLayer?
    private var shadowLayer: MKLayer?
    private var touchInside: Bool = false
    private var touchDownLocation: CGPoint?
    private var thumbFrame: CGRect?
    private var onColorPallete: MKSwitchColorPallete? {
        didSet {
            updateColors()
        }
    }
    private var offColorPallete: MKSwitchColorPallete? {
        didSet {
            updateColors()
        }
    }
    private var disabledColorPallete: MKSwitchColorPallete? {
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

    private func setup() {
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

    private func updateSuperBounds(bounds: CGRect) {
        let center = CGPoint(x: CGRectGetMidX(bounds), y: CGRectGetMidY(bounds))
        let subX = center.x - kMKControlWidth / 2
        let subY = center.y - kMKControlHeight / 2
        self.frame = CGRect(x: subX, y: subY, width: kMKControlWidth, height: kMKControlHeight)
        updateTrackLayer()
        updateThumbLayer()
    }

    private func updateTrackLayer() {
        let center = CGPoint(x: CGRectGetMidX(self.bounds), y: CGRectGetMidY(self.bounds))
        let subX = center.x - kMKTrackWidth / 2
        let subY = center.y - kMKTrackHeight / 2

        if let trackLayer = trackLayer {
            trackLayer.frame = CGRect(x: subX, y: subY, width: kMKTrackWidth, height: kMKTrackHeight)
            trackLayer.path = UIBezierPath(
                roundedRect: trackLayer.bounds,
                byRoundingCorners: UIRectCorner.AllCorners,
                cornerRadii: CGSize(
                    width: kMKTrackCornerRadius,
                    height: kMKTrackCornerRadius)).CGPath
        }
    }

    private func updateThumbLayer() {
        var subX: CGFloat = 0
        if let parent = parent {
            if parent.on {
                subX = kMKControlWidth - kMKThumbRadius * 2
            }
        }

        thumbFrame = CGRect(x: subX, y: 0, width: kMKThumbRadius * 2, height: kMKThumbRadius * 2)
        if let
        thumbHolder = thumbHolder,
        thumbBackground = thumbBackground,
        thumbLayer = thumbLayer {
            thumbHolder.frame = thumbFrame!
            thumbBackground.frame = thumbHolder.bounds
            thumbLayer.frame = thumbHolder.bounds
            thumbLayer.path = UIBezierPath(ovalInRect: thumbLayer.bounds).CGPath
        }
    }

    private func updateColors() {
        if let trackLayer = trackLayer,
        thumbLayer = thumbLayer,
        rippleLayer = rippleLayer,
        parent = parent {
            if !enabled {
                if let disabledColorPallete = disabledColorPallete {
                    trackLayer.fillColor = disabledColorPallete.trackColor.CGColor
                    thumbLayer.fillColor = disabledColorPallete.thumbColor.CGColor
                }
            } else if parent.on {
                if let
                onColorPallete = onColorPallete {
                    trackLayer.fillColor = onColorPallete.trackColor.CGColor
                    thumbLayer.fillColor = onColorPallete.thumbColor.CGColor
                    rippleLayer.setRippleColor(onColorPallete.thumbColor, withRippleAlpha: 0.1,
                        withBackgroundAlpha: 0.1)
                }
            } else {
                if let
                offColorPallete = offColorPallete {
                    trackLayer.fillColor = offColorPallete.trackColor.CGColor
                    thumbLayer.fillColor = offColorPallete.thumbColor.CGColor
                    rippleLayer.setRippleColor(offColorPallete.thumbColor,
                        withRippleAlpha: 0.1,
                        withBackgroundAlpha: 0.1)
                }
            }
        }
    }

    private func switchState(on: Bool) {
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

    public func onTouchDown(touchLocation: CGPoint) {
        if enabled {
            if let
            rippleLayer = rippleLayer, shadowLayer = shadowLayer,
            thumbBackground = thumbBackground, thumbLayer = thumbLayer {
                rippleLayer.startEffects(atLocation: self.convertPoint(touchLocation, toLayer: thumbBackground))
                shadowLayer.startEffects(atLocation: self.convertPoint(touchLocation, toLayer: thumbLayer))

                self.touchInside = self.containsPoint(touchLocation)
                self.touchDownLocation = touchLocation
            }
        }
    }

    public func onTouchMoved(moveLocation: CGPoint) {
        if enabled {
            if touchInside {
                if let thumbFrame = thumbFrame, thumbHolder = thumbHolder, touchDownLocation = touchDownLocation {
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

    public func onTouchUp(touchLocation: CGPoint) {
        if enabled {
            if let rippleLayer = rippleLayer, shadowLayer = shadowLayer {
                rippleLayer.stopEffects()
                shadowLayer.stopEffects()
            }

            if let touchDownLocation = touchDownLocation, parent = parent {
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

    private func checkPoint(point: CGPoint, equalTo other: CGPoint) -> Bool {
        return fabs(point.x - other.x) <= 5 && fabs(point.y - other.y) <= 5
    }
}

public class MKSwitchColorPallete {
    public var thumbColor: UIColor
    public var trackColor: UIColor

    init(thumbColor: UIColor, trackColor: UIColor) {
        self.thumbColor = thumbColor
        self.trackColor = trackColor
    }
}