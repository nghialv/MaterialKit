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
            switchLayer?.enabled = isEnabled
        }
    }
    @IBInspectable open var thumbOnColor: UIColor = UIColor.MKColor.Blue.P500 {
        didSet {
            if let switchLayer = switchLayer,
                let onColorPallete = switchLayer.onColorPallete {
                onColorPallete.thumbColor = thumbOnColor
                switchLayer.updateColors()
            }
        }
    }
    @IBInspectable open var thumbOffColor: UIColor = UIColor(hex: 0xFAFAFA) {
        didSet {
            if let switchLayer = switchLayer,
                let offColorPallete = switchLayer.offColorPallete {
                offColorPallete.thumbColor = thumbOffColor
                switchLayer.updateColors()
            }
        }
    }
    @IBInspectable open var thumbDisabledColor: UIColor = UIColor(hex: 0xBDBDBD) {
        didSet {
            if let switchLayer = switchLayer,
                let disabledColorPallete = switchLayer.disabledColorPallete {
                disabledColorPallete.thumbColor = thumbDisabledColor
                switchLayer.updateColors()
            }
        }
    }
    @IBInspectable open var trackOnColor: UIColor = UIColor.MKColor.Blue.P300 {
        didSet {
            if let switchLayer = switchLayer,
                let onColorPallete = switchLayer.onColorPallete {
                onColorPallete.trackColor = trackOnColor
                switchLayer.updateColors()
            }
        }
    }
    @IBInspectable open var trackOffColor: UIColor = UIColor(hex: 0x000042, alpha: 0.1) {
        didSet {
            if let switchLayer = switchLayer,
                let offColorPallete = switchLayer.offColorPallete {
                offColorPallete.trackColor = trackOffColor
                switchLayer.updateColors()
            }
        }
    }
    @IBInspectable open var trackDisabledColor: UIColor = UIColor(hex: 0xBDBDBD) {
        didSet {
            if let switchLayer = switchLayer,
                let disabledColorPallete = switchLayer.disabledColorPallete {
                disabledColorPallete.trackColor = trackDisabledColor
                switchLayer.updateColors()
            }
        }
    }
    @IBInspectable open var on: Bool = false {
        didSet {
            if let switchLayer = switchLayer {
                switchLayer.switchState(on)
                sendActions(for: .valueChanged)
            }
        }
    }

    private var switchLayer: MKSwitchLayer?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        switchLayer?.updateSuperBounds(bounds)
    }

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let point = touches.first?.location(in: self),
            let switchLayer = switchLayer {
            switchLayer.onTouchDown(layer.convert(point, to: switchLayer))
        }
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if let point = touches.first?.location(in: self),
            let switchLayer = switchLayer {
            switchLayer.onTouchUp(layer.convert(point, to: switchLayer))
        }
    }

    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        if let point = touches.first?.location(in: self),
            let switchLayer = switchLayer {
            switchLayer.onTouchUp(layer.convert(point, to: switchLayer))
        }
    }

    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if let point = touches.first?.location(in: self),
            let switchLayer = switchLayer {
            switchLayer.onTouchMoved(layer.convert(point, to: switchLayer))
        }
    }

    private func setup() {
        switchLayer = { let switchLayer = MKSwitchLayer(withParent: self)
            switchLayer.onColorPallete = MKSwitchColorPallete(
                thumbColor: thumbOnColor, trackColor: trackOnColor)
            switchLayer.offColorPallete = MKSwitchColorPallete(
                thumbColor: thumbOffColor, trackColor: trackOffColor)
            switchLayer.disabledColorPallete = MKSwitchColorPallete(
                thumbColor: thumbDisabledColor, trackColor: trackDisabledColor)
            layer.addSublayer(switchLayer)
            return switchLayer
        }()
        isEnabled = true
    }
}

open class MKSwitchLayer: CALayer {

    open var enabled = true {
        didSet {
            updateColors()
        }
    }
    open weak var parent: MKSwitch?
    open var rippleAnimationDuration: CFTimeInterval = 0.35

    private lazy var trackLayer: CAShapeLayer = {
        let trackLayer = CAShapeLayer()
        self.addSublayer(trackLayer)
        return trackLayer
    }()
    private var thumbBackground = CALayer()
    private lazy var rippleLayer: MKLayer = {
        let rippleLayer = MKLayer(superLayer: self.thumbBackground)
        rippleLayer.rippleScaleRatio = 1.7
        rippleLayer.maskEnabled = false
        rippleLayer.elevation = 0
        return rippleLayer
    }()
    private var thumbLayer = CAShapeLayer()
    private lazy var shadowLayer: MKLayer = {
        let shadowLayer = MKLayer(superLayer: self.thumbLayer)
        shadowLayer.rippleScaleRatio = 0
        return shadowLayer
    }()
    private lazy var thumbHolder: CALayer = {
        let thumbHolder = CALayer()
        thumbHolder.addSublayer(self.thumbBackground)
        thumbHolder.addSublayer(self.thumbLayer)
        self.addSublayer(thumbHolder)
        return thumbHolder
    }()

    private var touchInside = false
    private var touchDownLocation: CGPoint?
    private var thumbFrame: CGRect?
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
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // MARK: FIXME - Previously no setup
    }

    deinit {
        shadowLayer.recycle()
        rippleLayer.recycle()
    }

    fileprivate func updateSuperBounds(_ bounds: CGRect) {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let subX = center.x - kMKControlWidth / 2
        let subY = center.y - kMKControlHeight / 2
        frame = CGRect(x: subX, y: subY, width: kMKControlWidth, height: kMKControlHeight)
        updateTrackLayer()
        updateThumbLayer()
    }

    private func updateTrackLayer() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let subX = center.x - kMKTrackWidth / 2
        let subY = center.y - kMKTrackHeight / 2

        trackLayer.frame = CGRect(x: subX, y: subY, width: kMKTrackWidth, height: kMKTrackHeight)
        trackLayer.path = UIBezierPath(
            roundedRect: trackLayer.bounds,
            byRoundingCorners: .allCorners,
            cornerRadii: CGSize(
                width: kMKTrackCornerRadius,
                height: kMKTrackCornerRadius)).cgPath
    }

    private func updateThumbLayer() {
        var subX: CGFloat = 0
        if let parent = parent {
            if parent.on {
                subX = kMKControlWidth - kMKThumbRadius * 2
            }
        }

        thumbFrame = CGRect(x: subX, y: 0, width: kMKThumbRadius * 2, height: kMKThumbRadius * 2)

        thumbHolder.frame = thumbFrame!
        thumbBackground.frame = thumbHolder.bounds
        thumbLayer.frame = thumbHolder.bounds
        thumbLayer.path = UIBezierPath(ovalIn: thumbLayer.bounds).cgPath
    }

    fileprivate func updateColors() {
        if let parent = parent {
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
        thumbHolder.frame = thumbFrame!
        updateColors()
    }

    open func onTouchDown(_ touchLocation: CGPoint) {
        if enabled {
            rippleLayer.startEffects(atLocation: convert(touchLocation, to: thumbBackground))
            shadowLayer.startEffects(atLocation: convert(touchLocation, to: thumbLayer))

            touchInside = contains(touchLocation)
            touchDownLocation = touchLocation
        }
    }

    open func onTouchMoved(_ moveLocation: CGPoint) {
        if enabled {
            if touchInside {
                if let thumbFrame = thumbFrame, let touchDownLocation = touchDownLocation {
                    var x = thumbFrame.origin.x + moveLocation.x - touchDownLocation.x
                    if x < 0 {
                        x = 0
                    } else if x > bounds.size.width - thumbFrame.size.width {
                        x = bounds.size.width - thumbFrame.size.width
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
            rippleLayer.stopEffects()
            shadowLayer.stopEffects()

            if let touchDownLocation = touchDownLocation, let parent = parent {
                if !touchInside || checkPoint(touchLocation, equalTo: touchDownLocation) {
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

    private func checkPoint(_ point: CGPoint, equalTo other: CGPoint) -> Bool {
        return fabs(point.x - other.x) <= 5 && fabs(point.y - other.y) <= 5
    }
}

open class MKSwitchColorPallete {
    open var thumbColor: UIColor
    open var trackColor: UIColor

    public init(thumbColor: UIColor, trackColor: UIColor) {
        self.thumbColor = thumbColor
        self.trackColor = trackColor
    }
}
