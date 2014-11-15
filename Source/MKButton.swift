//
//  MKButton.swift
//  MaterialKit
//
//  Created by LeVan Nghia on 11/14/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

import UIKit

enum MKButtonType {
    case FloatingAction
    case Raised
    case Flat
}

@IBDesignable
class MKButton : UIButton
{
    @IBInspectable var shadowAnimationEnable : Bool = true
    @IBInspectable var animationDuration : CFTimeInterval = 0.65
    @IBInspectable var animateFromTapLocationEnable : Bool = true
    @IBInspectable var cornerRadius: CGFloat = 2.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.resetCornerRadius()
        }
    }
    @IBInspectable var mkType: MKButtonType = .Raised {
        didSet {
            didChangeButtonType()
        }
    }
    var subLayerColor = UIColor(white: 0.45, alpha: 0.5)
    var backgroundLayerColor: UIColor = UIColor(white: 0.75, alpha: 0.25) {
        didSet {
            backgroundLayer.backgroundColor = backgroundLayerColor.CGColor
        }
    }
    
    private let subLayer = CALayer()
    private let backgroundLayer = CALayer()
    private let maskLayer = CAShapeLayer()
    
    private let linearTimingFunction = CAMediaTimingFunction(name: "linear")
    private let easeOutTimingFunction = CAMediaTimingFunction(name: "easeOut")
    
    // MARK - initilization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayer()
    }
    
    // MARK - reset methods
    private func setupLayer() {
        // background layer
        backgroundLayer.frame = self.bounds
        backgroundLayer.backgroundColor = backgroundLayerColor.CGColor
        backgroundLayer.opacity = 0.0
        self.layer.addSublayer(backgroundLayer)
       
        // sublayer
        let subSize = max(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) * 0.85
        let subCornerRadius = subSize/2
        
        subLayer.backgroundColor = subLayerColor.CGColor
        subLayer.cornerRadius = subCornerRadius
        resetSubLayerLocation(CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2))
        backgroundLayer.addSublayer(subLayer)
        
        // mask layer
        resetCornerRadius()
        backgroundLayer.mask = maskLayer
    }
   
    private func resetSubLayerLocation(center: CGPoint) {
        if mkType == .FloatingAction {
            return
        }
        
        let width = CGRectGetWidth(self.bounds)
        let height = CGRectGetHeight(self.bounds)
        let subSize = max(width, height) * 0.9
        let subX = center.x - subSize/2
        let subY = center.y - subSize/2
        
        // disable animation when changing layer frame
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        subLayer.frame = CGRect(x: subX, y: subY, width: subSize, height: subSize)
        CATransaction.commit()
    }
    
    private func resetCornerRadius() {
        maskLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).CGPath
    }
    
    private func didChangeButtonType() {
        if mkType == .FloatingAction {
            let width = CGRectGetWidth(self.bounds)
            let height = CGRectGetHeight(self.bounds)
            self.cornerRadius = min(width, height)/2
            backgroundLayer.cornerRadius = self.cornerRadius
            backgroundLayer.mask = nil
        } else {
            backgroundLayer.mask = maskLayer
        }
    }
   
    // MARK - location tracking methods
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        resetSubLayerLocation(touch.locationInView(self))
        // subLayer animation
        let subLayerAnim = CABasicAnimation(keyPath: "transform.scale")
        subLayerAnim.fromValue = 0.45
        subLayerAnim.toValue = mkType == .FloatingAction ? 1.75 : 1.0
        subLayerAnim.duration = animationDuration
        subLayerAnim.timingFunction = mkType == .FloatingAction ? easeOutTimingFunction : linearTimingFunction
        subLayerAnim.removedOnCompletion = false
        subLayerAnim.fillMode = kCAFillModeForwards
        subLayer.addAnimation(subLayerAnim, forKey: "subLayerAnimation")
   
        // backgroundLayer animation
        let backgroundLayerAnim = CABasicAnimation(keyPath: "opacity")
        backgroundLayerAnim.fromValue = 1.0
        backgroundLayerAnim.toValue = 0.0
        backgroundLayerAnim.duration = mkType == .Flat ? 1.0 : animationDuration
        backgroundLayerAnim.timingFunction = mkType == .Flat ? easeOutTimingFunction : linearTimingFunction
        backgroundLayer.addAnimation(backgroundLayerAnim, forKey: "backgroundLayerAnimation")
        
        // shadow animation for self
        if shadowAnimationEnable {
            let shadowRadius = self.layer.shadowRadius
            let shadowOpacity = self.layer.shadowOpacity
            shadowAnimation(10, toRadius: shadowRadius, fromOpacity: 0, toOpacity: shadowOpacity, duration: animationDuration)
        }
        
        return super.beginTrackingWithTouch(touch, withEvent: event)
    }
    
    override func endTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) {
        super.endTrackingWithTouch(touch, withEvent: event)
    }
    
    // MARK - animations
    private func shadowAnimation(fromRadius: CGFloat, toRadius: CGFloat, fromOpacity: Float, toOpacity: Float, duration: CFTimeInterval) {
        let radiusAnimation = CABasicAnimation(keyPath: "shadowRadius")
        radiusAnimation.fromValue = fromRadius
        radiusAnimation.toValue = toRadius
    
        let opacityAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        opacityAnimation.fromValue = fromOpacity
        opacityAnimation.toValue = toOpacity
    
        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = duration
        groupAnimation.removedOnCompletion = false
        groupAnimation.fillMode = kCAFillModeForwards
        groupAnimation.animations = [radiusAnimation, opacityAnimation]
        if mkType == .Flat {
            maskLayer.addAnimation(groupAnimation, forKey: "shadow-animation")
        } else {
            self.layer.addAnimation(groupAnimation, forKey: "shadow-animation")
        }
    }
}
