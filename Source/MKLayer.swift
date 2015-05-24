//
//  MKLayer.swift
//  MaterialKit
//
//  Created by Le Van Nghia on 11/15/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

import UIKit
import QuartzCore

public enum MKTimingFunction {
    case Linear
    case EaseIn
    case EaseOut
    case Custom(Float, Float, Float, Float)

    public var function: CAMediaTimingFunction {
        switch self {
        case .Linear:
            return CAMediaTimingFunction(name: "linear")
        case .EaseIn:
            return CAMediaTimingFunction(name: "easeIn")
        case .EaseOut:
            return CAMediaTimingFunction(name: "easeOut")
        case .Custom(let cpx1, let cpy1, let cpx2, let cpy2):
            return CAMediaTimingFunction(controlPoints: cpx1, cpy1, cpx2, cpy2)
        }
    }
}

public enum MKRippleLocation {
    case Center
    case Left
    case Right
    case TapLocation
}

public class MKLayer {
    private var superLayer: CALayer!
    private let rippleLayer = CALayer()
    private let backgroundLayer = CALayer()
    private let maskLayer = CAShapeLayer()
    
    public var rippleLocation: MKRippleLocation = .TapLocation {
        didSet {
            let origin: CGPoint?
            let sw = CGRectGetWidth(superLayer.bounds)
            let sh = CGRectGetHeight(superLayer.bounds)
            
            switch rippleLocation {
            case .Center:
                origin = CGPoint(x: sw/2, y: sh/2)
            case .Left:
                origin = CGPoint(x: sw*0.25, y: sh/2)
            case .Right:
                origin = CGPoint(x: sw*0.75, y: sh/2)
            default:
                origin = nil
            }
            if let origin = origin {
                setCircleLayerLocationAt(origin)
            }
        }
    }

    public var ripplePercent: Float = 0.9 {
        didSet {
            if ripplePercent > 0 {
                let sw = CGRectGetWidth(superLayer.bounds)
                let sh = CGRectGetHeight(superLayer.bounds)
                let circleSize = CGFloat(max(sw, sh)) * CGFloat(ripplePercent)
                let circleCornerRadius = circleSize/2

                rippleLayer.cornerRadius = circleCornerRadius
                setCircleLayerLocationAt(CGPoint(x: sw/2, y: sh/2))
            }
        }
    }

    public init(superLayer: CALayer) {
        self.superLayer = superLayer

        let sw = CGRectGetWidth(superLayer.bounds)
        let sh = CGRectGetHeight(superLayer.bounds)

        // background layer
        backgroundLayer.frame = superLayer.bounds
        backgroundLayer.opacity = 0.0
        superLayer.addSublayer(backgroundLayer)

        // ripple layer
        let circleSize = CGFloat(max(sw, sh)) * CGFloat(ripplePercent)
        let rippleCornerRadius = circleSize/2

        rippleLayer.opacity = 0.0
        rippleLayer.cornerRadius = rippleCornerRadius
        setCircleLayerLocationAt(CGPoint(x: sw/2, y: sh/2))
        backgroundLayer.addSublayer(rippleLayer)

        // mask layer
        setMaskLayerCornerRadius(superLayer.cornerRadius)
        backgroundLayer.mask = maskLayer
    }

    public func superLayerDidResize() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        backgroundLayer.frame = superLayer.bounds
        setMaskLayerCornerRadius(superLayer.cornerRadius)
        CATransaction.commit()
        setCircleLayerLocationAt(CGPoint(x: superLayer.bounds.width/2, y: superLayer.bounds.height/2))
    }

    public func enableOnlyCircleLayer() {
        backgroundLayer.removeFromSuperlayer()
        superLayer.addSublayer(rippleLayer)
    }

    public func setBackgroundLayerColor(color: UIColor) {
        backgroundLayer.backgroundColor = color.CGColor
    }

    public func setCircleLayerColor(color: UIColor) {
        rippleLayer.backgroundColor = color.CGColor
    }

    public func didChangeTapLocation(location: CGPoint) {
        if rippleLocation == .TapLocation {
            setCircleLayerLocationAt(location)
        }
    }

    public func setMaskLayerCornerRadius(cornerRadius: CGFloat) {
        maskLayer.path = UIBezierPath(roundedRect: backgroundLayer.bounds, cornerRadius: cornerRadius).CGPath
    }

    public func enableMask(enable: Bool = true) {
        backgroundLayer.mask = enable ? maskLayer : nil
    }

    public func setBackgroundLayerCornerRadius(cornerRadius: CGFloat) {
        backgroundLayer.cornerRadius = cornerRadius
    }

    private func setCircleLayerLocationAt(center: CGPoint) {
        let bounds = superLayer.bounds
        let width = CGRectGetWidth(bounds)
        let height = CGRectGetHeight(bounds)
        let subSize = CGFloat(max(width, height)) * CGFloat(ripplePercent)
        let subX = center.x - subSize/2
        let subY = center.y - subSize/2

        // disable animation when changing layer frame
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        rippleLayer.cornerRadius = subSize / 2
        rippleLayer.frame = CGRect(x: subX, y: subY, width: subSize, height: subSize)
        CATransaction.commit()
    }

    // MARK - Animation
    public func animateScaleForCircleLayer(fromScale: Float, toScale: Float, timingFunction: MKTimingFunction, duration: CFTimeInterval) {
        let rippleLayerAnim = CABasicAnimation(keyPath: "transform.scale")
        rippleLayerAnim.fromValue = fromScale
        rippleLayerAnim.toValue = toScale

        let opacityAnim = CABasicAnimation(keyPath: "opacity")
        opacityAnim.fromValue = 1.0
        opacityAnim.toValue = 0.0

        let groupAnim = CAAnimationGroup()
        groupAnim.duration = duration
        groupAnim.timingFunction = timingFunction.function
        groupAnim.removedOnCompletion = false
        groupAnim.fillMode = kCAFillModeForwards

        groupAnim.animations = [rippleLayerAnim, opacityAnim]

        rippleLayer.addAnimation(groupAnim, forKey: nil)
    }

    public func animateAlphaForBackgroundLayer(timingFunction: MKTimingFunction, duration: CFTimeInterval) {
        let backgroundLayerAnim = CABasicAnimation(keyPath: "opacity")
        backgroundLayerAnim.fromValue = 1.0
        backgroundLayerAnim.toValue = 0.0
        backgroundLayerAnim.duration = duration
        backgroundLayerAnim.timingFunction = timingFunction.function
        backgroundLayer.addAnimation(backgroundLayerAnim, forKey: nil)
    }

    public func animateSuperLayerShadow(fromRadius: CGFloat, toRadius: CGFloat, fromOpacity: Float, toOpacity: Float, timingFunction: MKTimingFunction, duration: CFTimeInterval) {
        animateShadowForLayer(superLayer, fromRadius: fromRadius, toRadius: toRadius, fromOpacity: fromOpacity, toOpacity: toOpacity, timingFunction: timingFunction, duration: duration)
    }

    public func animateMaskLayerShadow() {

    }

    private func animateShadowForLayer(layer: CALayer, fromRadius: CGFloat, toRadius: CGFloat, fromOpacity: Float, toOpacity: Float, timingFunction: MKTimingFunction, duration: CFTimeInterval) {
        let radiusAnimation = CABasicAnimation(keyPath: "shadowRadius")
        radiusAnimation.fromValue = fromRadius
        radiusAnimation.toValue = toRadius

        let opacityAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        opacityAnimation.fromValue = fromOpacity
        opacityAnimation.toValue = toOpacity

        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = duration
        groupAnimation.timingFunction = timingFunction.function
        groupAnimation.removedOnCompletion = false
        groupAnimation.fillMode = kCAFillModeForwards
        groupAnimation.animations = [radiusAnimation, opacityAnimation]

        layer.addAnimation(groupAnimation, forKey: nil)
    }
}
