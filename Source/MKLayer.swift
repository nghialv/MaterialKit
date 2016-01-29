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
    private let rippleLayer = CAShapeLayer()
    private var maskEnabled = false
    private var removeAnimation = false
    private var animationRunning = false
    private var circleCenter = CGPoint()
    private var endRadius: CGFloat = 0
    private var cornerRadius: CGFloat = 0
    private var rippleAnimationEnabled: Bool = true
    
    public var rippleLocation: MKRippleLocation = .TapLocation {
        didSet {
            let origin: CGPoint?
            let sw = CGRectGetWidth(superLayer.bounds)
            let sh = CGRectGetHeight(superLayer.bounds)
            
            switch rippleLocation {
            case .Center:
                origin = CGPoint(x: sw / 2, y: sh / 2)
            case .Left:
                origin = CGPoint(x: sw * 0.25, y: sh / 2)
            case .Right:
                origin = CGPoint(x: sw * 0.75, y: sh / 2)
            default:
                origin = nil
            }
            if let origin = origin {
                setCircleLayerLocationAt(origin)
            }
        }
    }
    
    public init(superLayer: CALayer) {
        self.superLayer = superLayer
        
        let sw = CGRectGetWidth(superLayer.bounds)
        let sh = CGRectGetHeight(superLayer.bounds)
        
        // ripple layer
        rippleLayer.opacity = 0.0
        rippleLayer.strokeColor = UIColor.clearColor().CGColor
        rippleLayer.frame = superLayer.bounds
        rippleLayer.masksToBounds = true
        enableMask(maskEnabled)
        setCircleLayerLocationAt(CGPoint(x: sw / 2, y: sh / 2))
        superLayer.addSublayer(rippleLayer)
    }
    
    public func superLayerDidResize() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        rippleLayer.frame = superLayer.bounds
        enableMask(maskEnabled)
        CATransaction.commit()
        setCircleLayerLocationAt(CGPoint(x: CGRectGetWidth(superLayer.bounds) / 2, y: CGRectGetWidth(superLayer.bounds) / 2))
    }
    
    public func setCircleLayerColor(color: UIColor) {
        rippleLayer.fillColor = color.CGColor
    }
    
    public func setCornerRadius(cornerRadius: CGFloat) {
        self.cornerRadius = cornerRadius
        self.enableMask(maskEnabled)
    }
    
    public func didChangeTapLocation(location: CGPoint) {
        if rippleLocation == .TapLocation {
            setCircleLayerLocationAt(location)
        }
    }
    
    public func enableMask(enable: Bool = true) {
        let mask = CAShapeLayer()
        if enable {
            mask.path = UIBezierPath(arcCenter: CGPointMake(CGRectGetWidth(superLayer.bounds) / 2, CGRectGetHeight(superLayer.bounds) / 2),
                radius: min(CGRectGetWidth(superLayer.bounds), CGRectGetHeight(superLayer.bounds)) / 2,
                startAngle: 0,
                endAngle: CGFloat(2 * M_PI),
                clockwise: true).CGPath
        } else {
            mask.path = UIBezierPath(roundedRect: superLayer.bounds, cornerRadius: cornerRadius).CGPath
        }
        rippleLayer.mask = mask
        maskEnabled = enable
    }
    
    public func setRippleAnimation(enabled: Bool) {
        self.rippleAnimationEnabled = enabled
    }
    
    private func setCircleLayerLocationAt(center: CGPoint) {
        // disable animation when changing layer frame
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        circleCenter = center
        
        let halfWidth = CGRectGetWidth(superLayer.bounds) / 2
        let halfHeight = CGRectGetHeight(superLayer.bounds) / 2
        
        let radiusX = halfWidth > circleCenter.x ? CGRectGetWidth(superLayer.bounds) - circleCenter.x : circleCenter.x
        let radiusY = halfHeight > circleCenter.y ? CGRectGetHeight(superLayer.bounds) - circleCenter.y : circleCenter.y
        
        endRadius = sqrt(radiusX * radiusX + radiusY * radiusY) * CGFloat(1.2)
        CATransaction.commit()
    }
    
    // MARK - Animation
    public func animateRipple(timingFunction: MKTimingFunction, duration: CFTimeInterval) {
        if self.animationRunning || !self.rippleAnimationEnabled {
            return
        }
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {() -> Void in
            self.animationRunning = false
            if self.removeAnimation {
                self.reset()
            }
        }
        rippleLayer.opacity = 0.4
        
        let rippleLayerAnim = CABasicAnimation(keyPath: "path")
        rippleLayerAnim.fromValue = UIBezierPath(arcCenter: circleCenter, radius: 0, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true).CGPath
        rippleLayerAnim.toValue = UIBezierPath(arcCenter: circleCenter, radius: endRadius, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true).CGPath
        rippleLayerAnim.duration = duration
        rippleLayerAnim.timingFunction = timingFunction.function
        rippleLayerAnim.removedOnCompletion = false
        rippleLayerAnim.fillMode = kCAFillModeForwards
        
        rippleLayer.addAnimation(rippleLayerAnim, forKey: nil)
        
        self.animationRunning = true
        CATransaction.commit()
    }
    
    public func animateSuperLayerShadow(fromRadius: CGFloat, toRadius: CGFloat, fromOpacity: Float, toOpacity: Float, timingFunction: MKTimingFunction, duration: CFTimeInterval) {
        animateShadowForLayer(superLayer, fromRadius: fromRadius, toRadius: toRadius, fromOpacity: fromOpacity, toOpacity: toOpacity, timingFunction: timingFunction, duration: duration)
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
    
    public func removeAllAnimations() {
        removeAnimation = true
        if !animationRunning {
            reset()
        }
    }
    
    private func reset() {
        rippleLayer.opacity = 0
        removeAnimation = false
        animationRunning = false
    }
    
}
