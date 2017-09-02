//
//  MKLayer.swift
//  MaterialKit
//
//  Created by Le Van Nghia on 11/15/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

import UIKit

let kMKClearEffectsDuration = 0.3

open class MKLayer: CALayer, CAAnimationDelegate {

    open var maskEnabled: Bool = true {
        didSet {
            mask = maskEnabled ? maskLayer : nil
        }
    }
    open var rippleEnabled: Bool = true
    open var rippleScaleRatio: CGFloat = 1.0 {
        didSet {
            calculateRippleSize()
        }
    }
    open var rippleDuration: CFTimeInterval = 0.35
    open var elevation: CGFloat = 0 {
        didSet {
            enableElevation()
        }
    }
    open var elevationOffset: CGSize = .zero {
        didSet {
            enableElevation()
        }
    }
    open var roundingCorners: UIRectCorner = .allCorners {
        didSet {
            enableElevation()
        }
    }
    open var backgroundAnimationEnabled: Bool = true

    private weak var superView: UIView?
    private weak var superLayer: CALayer?
    private var rippleLayer: CAShapeLayer?
    private var backgroundLayer: CAShapeLayer?
    private var maskLayer: CAShapeLayer?
    private var userIsHolding: Bool = false
    private var effectIsRunning: Bool = false

    private override init(layer: Any) {
        super.init()
    }

    public init(superLayer: CALayer) {
        super.init()
        self.superLayer = superLayer
        setup()
    }

    public init(withView view: UIView) {
        super.init()
        superView = view
        superLayer = view.layer
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        superLayer = superlayer
        setup()
    }

    public func recycle() {
        superLayer?.removeObserver(self, forKeyPath: "bounds")
        superLayer?.removeObserver(self, forKeyPath: "cornerRadius")
    }

    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let keyPath = keyPath {
            if keyPath == "bounds" {
                superLayerDidResize()
            } else if keyPath == "cornerRadius" {
                if let superLayer = superLayer {
                    setMaskLayerCornerRadius(superLayer.cornerRadius)
                }
            }
        }
    }

    open func superLayerDidResize() {
        if let superLayer = superLayer {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            frame = superLayer.bounds
            setMaskLayerCornerRadius(superLayer.cornerRadius)
            calculateRippleSize()
            CATransaction.commit()
        }
    }

    open func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if anim == animation(forKey: "opacityAnim") {
            opacity = 0
        } else if flag {
            if userIsHolding {
                effectIsRunning = false
            } else {
                clearEffects()
            }
        }
    }

    open func startEffects(atLocation touchLocation: CGPoint) {
        userIsHolding = true
        if let rippleLayer = rippleLayer {
            rippleLayer.timeOffset = 0
            rippleLayer.speed = backgroundAnimationEnabled ? 1 : 1.1
            if rippleEnabled {
                startRippleEffect(nearestInnerPoint(touchLocation))
            }
        }
    }

    open func stopEffects() {
        userIsHolding = false
        if !effectIsRunning {
            clearEffects()
        } else if let rippleLayer = rippleLayer {
            rippleLayer.timeOffset = rippleLayer.convertTime(CACurrentMediaTime(), from: nil)
            rippleLayer.beginTime = CACurrentMediaTime()
            rippleLayer.speed = 1.2
        }
    }

    open func stopEffectsImmediately() {
        userIsHolding = false
        effectIsRunning = false
        if rippleEnabled,
            let rippleLayer = rippleLayer,
            let backgroundLayer = backgroundLayer {
            rippleLayer.removeAllAnimations()
            backgroundLayer.removeAllAnimations()
            rippleLayer.opacity = 0
            backgroundLayer.opacity = 0
        }
    }

    open func setRippleColor(_ color: UIColor,
                             withRippleAlpha rippleAlpha: CGFloat = 0.3,
                             withBackgroundAlpha backgroundAlpha: CGFloat = 0.3) {
        if let rippleLayer = rippleLayer,
            let backgroundLayer = backgroundLayer {
            rippleLayer.fillColor = color.withAlphaComponent(rippleAlpha).cgColor
            backgroundLayer.fillColor = color.withAlphaComponent(backgroundAlpha).cgColor
        }
    }

    // MARK: Touches

    open func touchesBegan(_ touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let first = touches.first, let superView = superView {
            let point = first.location(in: superView)
            startEffects(atLocation: point)
        }
    }

    open func touchesEnded(_ touches: Set<UITouch>, withEvent event: UIEvent?) {
        stopEffects()
    }

    open func touchesCancelled(_ touches: Set<UITouch>?, withEvent event: UIEvent?) {
        stopEffects()
    }

    open func touchesMoved(_ touches: Set<UITouch>, withEvent event: UIEvent?) {
    }

    // MARK: Private

    private func setup() {
        rippleLayer = CAShapeLayer()
        rippleLayer!.opacity = 0
        addSublayer(rippleLayer!)

        backgroundLayer = CAShapeLayer()
        backgroundLayer!.opacity = 0
        backgroundLayer!.frame = superLayer!.bounds
        addSublayer(backgroundLayer!)

        maskLayer = CAShapeLayer()
        setMaskLayerCornerRadius(superLayer!.cornerRadius)
        mask = maskLayer

        frame = superLayer!.bounds
        superLayer!.addSublayer(self)
        superLayer!.addObserver(
            self,
            forKeyPath: "bounds",
            options: NSKeyValueObservingOptions(rawValue: 0),
            context: nil)
        superLayer!.addObserver(
            self,
            forKeyPath: "cornerRadius",
            options: NSKeyValueObservingOptions(rawValue: 0),
            context: nil)

        enableElevation()
        superLayerDidResize()
    }

    private func setMaskLayerCornerRadius(_ radius: CGFloat) {
        maskLayer?.path = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
    }

    private func nearestInnerPoint(_ point: CGPoint) -> CGPoint {
        let centerX = bounds.midX
        let centerY = bounds.midY
        let dx = point.x - centerX
        let dy = point.y - centerY
        let dist = sqrt(dx * dx + dy * dy)
        if let backgroundLayer = rippleLayer { // TODO: Fix what?
            if dist <= backgroundLayer.bounds.size.width / 2 {
                return point
            }
            let d = backgroundLayer.bounds.size.width / 2 / dist
            let x = centerX + d * (point.x - centerX)
            let y = centerY + d * (point.y - centerY)
            return CGPoint(x: x, y: y)
        }
        return .zero
    }

    private func clearEffects() {
        if let rippleLayer = rippleLayer,
            let backgroundLayer = backgroundLayer {
            rippleLayer.timeOffset = 0
            rippleLayer.speed = 1

            if rippleEnabled {
                rippleLayer.removeAllAnimations()
                backgroundLayer.removeAllAnimations()
                removeAllAnimations()

                let opacityAnim = CABasicAnimation(keyPath: "opacity")
                opacityAnim.fromValue = 1
                opacityAnim.toValue = 0
                opacityAnim.duration = kMKClearEffectsDuration
                opacityAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                opacityAnim.isRemovedOnCompletion = false
                opacityAnim.fillMode = kCAFillModeForwards
                opacityAnim.delegate = self

                add(opacityAnim, forKey: "opacityAnim")
            }
        }
    }

    private func startRippleEffect(_ touchLocation: CGPoint) {
        removeAllAnimations()
        opacity = 1
        if let rippleLayer = rippleLayer,
            let backgroundLayer = backgroundLayer,
            let superLayer = superLayer {
            rippleLayer.removeAllAnimations()
            backgroundLayer.removeAllAnimations()

            let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
            scaleAnim.fromValue = 0
            scaleAnim.toValue = 1
            scaleAnim.duration = rippleDuration
            scaleAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            scaleAnim.delegate = self

            let moveAnim = CABasicAnimation(keyPath: "position")
            moveAnim.fromValue = NSValue(cgPoint: touchLocation)
            moveAnim.toValue = NSValue(cgPoint: CGPoint(
                x: superLayer.bounds.midX,
                y: superLayer.bounds.midY))
            moveAnim.duration = rippleDuration
            moveAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)

            effectIsRunning = true
            rippleLayer.opacity = 1
            backgroundLayer.opacity = backgroundAnimationEnabled ? 1 : 0

            rippleLayer.add(moveAnim, forKey: "position")
            rippleLayer.add(scaleAnim, forKey: "scale")
        }
    }

    private func calculateRippleSize() {
        if let superLayer = superLayer {
            let superLayerWidth = superLayer.bounds.width
            let superLayerHeight = superLayer.bounds.height
            let circleDiameter = sqrt(pow(superLayerWidth, 2) + pow(superLayerHeight, 2)) * rippleScaleRatio

            if let rippleLayer = rippleLayer {
                rippleLayer.frame = CGRect(
                    x: superLayer.bounds.midX - circleDiameter / 2,
                    y: superLayer.bounds.midY - circleDiameter / 2,
                    width: circleDiameter, height: circleDiameter)
                rippleLayer.path = UIBezierPath(ovalIn: rippleLayer.bounds).cgPath

                backgroundLayer?.frame = rippleLayer.frame
                backgroundLayer?.path = rippleLayer.path
            }
        }
    }

    private func enableElevation() {
        if let superLayer = superLayer {
            superLayer.shadowOpacity = 0.5
            superLayer.shadowRadius = elevation / 4
            superLayer.shadowColor = UIColor.black.cgColor
            superLayer.shadowOffset = elevationOffset
        }
    }
}
